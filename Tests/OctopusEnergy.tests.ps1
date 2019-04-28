$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$ModuleRoot = "$here\..\octopusenergy-helpers"
$DefaultsFile = "$here\octopusenergy-helpers.Pester.Defaults.json"

if(Test-Path $DefaultsFile)
{
    $defaults=@{}
    (Get-Content $DefaultsFile | Out-String | ConvertFrom-Json).psobject.properties | ForEach-Object{$defaults."$($_.Name)" = $_.Value}

    # Prompt for credentials
    $config = @{
        ApiKey = if($defaults.ApiKey){$defaults.ApiKey}else{Read-Host "ApiKey"}
        PSRequired = " "
        Mpan = if($defaults.Mpan){$defaults.Mpan}else{Read-Host "Electricity Meter Mpan"}
        ElecSerialNo = if($defaults.ElecSerialNo){$defaults.ElecSerialNo}else{Read-Host "Electricity Meter Serial Number"}
        Mprn = if($defaults.Mprn){$defaults.Mprn}else{Read-Host "Gas Meter Mprn"}
        GasSerialNo = if($defaults.ElecSerialNo){$defaults.GasSerialNo}else{Read-Host "Gas Meter Serial Number"}
    }

    $PSRequired = ConvertTo-SecureString $config.PSRequired -AsPlainText -Force
    $credential = New-Object System.Management.Automation.PSCredential ($config.ApiKey, $PSRequired)
    Set-OctopusEnergyHelperAPIAuth -Credential $credential | Out-Null
}
else
{
    Write-Error "$DefaultsFile does not exist. Created example file. Please populate with your values";

    # Write example file
    @{
        ApiKey = "OctopusEnergyAPIKey";
        Mpan = "MPANOfElectricityMeter"
        ElecSerialNo = "SerialNumberOfElectricityMeter"
        Mprn = "MPRNOfGasMeter"
        GasSerialNo = "SerialNumberOfGasMeter"

    } | ConvertTo-Json | Set-Content $DefaultsFile
    return;
}

Describe "Octopus Energy Consumption Meter Readings Functions" {

    If($config.mpan)
    {
        It "Get-OctopusEnergyHelperConsumption retrieves all electricty meter readings in the last 24 hours" {
            $results = Get-OctopusEnergyHelperConsumption -mpan $config.mpan -serial_number $config.ElecSerialNo -period_from $((Get-Date).AddDays(-1))
            $results.count | Should BeGreaterOrEqual 0
        }
    }

    If($config.mprn)
    {
        It "Get-OctopusEnergyHelperConsumption retrieves all gas meter readings in the last 24 hours" {
            $results = Get-OctopusEnergyHelperConsumption -mprn $config.mprn -serial_number $config.GasSerialNo -period_from $((Get-Date).AddDays(-1))
            $results.count | Should BeGreaterOrEqual 0
        }
    }
}

Describe "Octopus Energy Product Functions" {

    It "Get-OctopusEnergyHelperEnergyProductList retrieves list of all products"{
        $results = Get-OctopusEnergyHelperEnergyProductList
        $results.count | Should -BeGreaterThan 0
    }

    It "Get-OctopusEnergyHelperEnergyProductList retrieves list of all variable products"{
        $results = Get-OctopusEnergyHelperEnergyProductList -is_variable
        $results.is_variable | Should -Not -Contain $False
    }

    It "Get-OctopusEnergyHelperEnergyProductList retrieves products available upto 12 months ago"{
        $results = Get-OctopusEnergyHelperEnergyProductList -available_at (Get-Date).AddMonths(-12)
        $timeSpans = $results.available_to | Where-Object {$_} | ForEach-Object{New-TimeSpan $_ $(Get-Date)}
        $inRange = $timeSpans.Days | ForEach-Object {if($_ -gt 365){$false}else{$true} }
        $inRange | Should -Not -Contain $False
    }

    It "Get-OctopusEnergyHelperEnergyProduct retrieves details about a product"{
        $result = Get-OctopusEnergyHelperEnergyProduct -product_code "GO-18-06-12"
        $result.full_name | Should -Be "Octopus Go June 2018"
    }

    It "Get-OctopusEnergyHelperEnergyProduct retrieves details about a product by display name"{
        $result = Get-OctopusEnergyHelperEnergyProduct -display_name @("Flexible Octopus", "Super Green Octopus")
        $result.display_name | Should -Contain "Flexible Octopus"
        $result.display_name | Should -Contain "Super Green Octopus"
        $result.count | Should -Be 2
    }

    It "Get-OctopusEnergyHelperEnergyProduct retrieves details about all products"{
        $result = Get-OctopusEnergyHelperEnergyProduct
        $result.count | Should -BeGreaterThan 8
    }

    It "Get-OctopusEnergyHelperEnergyProductTariff retrieves details about a single rate electricity product tariff"{
        $result = Get-OctopusEnergyHelperEnergyProductTariff -tariff_code "E-1R-AGILE-18-02-21-C" -period_from $((Get-Date))
        $result.FuelType | Should -Be "electricity"
        $result.'standard-unit-rates'."value_exc_vat".Count | Should -BeGreaterThan 0
    }

    It "Get-OctopusEnergyHelperEnergyProductTariff retrieves details about a gas product tariff"{
        $result = Get-OctopusEnergyHelperEnergyProductTariff -tariff_code "G-1R-IRESAPP-VAR-18-09-21-A" -period_from $((Get-Date).AddDays(-1))
        $result.FuelType | Should -Be "gas"
        $result."standard-unit-rates"."value_exc_vat".count | Should -BeGreaterThan 0
    }

    It "Get-OctopusEnergyHelperEnergyProductTariff retrieves details about a dual rate electricity product tariff"{
        $result = Get-OctopusEnergyHelperEnergyProductTariff -tariff_code "E-2R-IRESAPP-VAR-18-09-21-A" -period_from $((Get-Date).AddDays(-1))
        $result.FuelType | Should -Be "electricity"
        $result."day-unit-rates"."value_exc_vat".count | Should -BeGreaterThan 0
        $result."night-unit-rates"."value_exc_vat".count | Should -BeGreaterThan 0
    }

    It "Find-OctopusEnergyHelperAgileRate find the time period with highest charges via GSP"{
        $result = Find-OctopusEnergyHelperAgileRate -duration $(New-TimeSpan -Hours 2) -gsp A -target highest
        $result."value_exc_vat" | Measure-Object -Sum | Select-Object -ExpandProperty Sum | Should -BeGreaterThan 80
    }

    It "Find-OctopusEnergyHelperAgileRate should throw an error if the duration exceed the number of rates available"{
        {Find-OctopusEnergyHelperAgileRate -duration $(New-TimeSpan -Hours 50) -mpan $config.mpan -target lowest} | Should -Throw "Duration greater than the number of available rates"
    }

    If($config.mpan)
    {
        It "Find-OctopusEnergyHelperAgileRate find the time period with lowest charges via the MPAN"{
            $result = Find-OctopusEnergyHelperAgileRate -duration $(New-TimeSpan -Hours 2) -mpan $config.mpan -target lowest
            $result."value_exc_vat" | Measure-Object -Sum | Select-Object -ExpandProperty Sum | Should -BeLessThan 40
        }
    }
}

Describe "Octopus Energy Meter Point Functions" {
    If($config.mpan)
    {
        It "Get-OctopusEnergyHelperMeterPoint retrieves details of a electricity meter point"{
            $result = Get-OctopusEnergyHelperMeterPoint -mpan $config.mpan
            $result.mpan | Should Be $config.mpan
        }
    }

}
