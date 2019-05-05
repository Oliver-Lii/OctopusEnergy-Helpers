$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$ModuleRoot = "$here\..\octopusenergy-helpers"

if(! (Test-OctopusEnergyHelperAPIAuthSet))
{
    $apiKey = Read-Host "Octopus Energy API key" -AsSecureString
    Set-OctopusEnergyHelperAPIAuth -ApiKey $apiKey | Out-Null
}

if(! (Test-OctopusEnergyHelperConfigSet))
{
    $configProperties = [ordered]@{"mpan"="Electricity Meter Mpan";"elec_serial_number"="Electricity Meter Serial Number";"mprn"="Gas Meter Mprn";"gas_serial_number"="Gas Meter Serial Number"}

    $cfgProps = @{}
    foreach($property in $configProperties.GetEnumerator())
    {
        $value = Read-Host $property.value
        $cfgProps.Add($property.key,$value)
    }
    Set-OctopusEnergyHelperConfig @cfgProps | Out-Null
}
else
{
    $config = Get-OctopusEnergyHelperConfig
}

Describe "Octopus Energy Consumption Meter Readings Functions" {

    It "Get-OctopusEnergyHelperConsumption retrieves all electricty meter readings in the last 24 hours" {
        $results = Get-OctopusEnergyHelperConsumption -mpan $config["mpan"] -serial_number $config["elec_serial_number"] -period_from $((Get-Date).AddDays(-1))
        $results.count | Should BeGreaterOrEqual 0
    }

    It "Get-OctopusEnergyHelperConsumption retrieves all gas meter readings in the last 24 hours" {
        $results = Get-OctopusEnergyHelperConsumption -mprn $config["mprn"] -serial_number $config["gas_serial_number"] -period_from $((Get-Date).AddDays(-1))
        $results.count | Should BeGreaterOrEqual 0
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
        {Find-OctopusEnergyHelperAgileRate -duration $(New-TimeSpan -Hours 50) -mpan $config["mpan"] -target lowest} | Should -Throw "Duration greater than the number of available rates"
    }

    It "Find-OctopusEnergyHelperAgileRate find the time period with lowest charges via the MPAN"{
        $result = Find-OctopusEnergyHelperAgileRate -duration $(New-TimeSpan -Hours 2) -mpan $config["mpan"] -target lowest
        $result."value_exc_vat" | Measure-Object -Sum | Select-Object -ExpandProperty Sum | Should -BeLessThan 40
    }
}

Describe "Octopus Energy Meter Point Functions" {

    It "Get-OctopusEnergyHelperMeterPoint retrieves details of a electricity meter point"{
        $result = Get-OctopusEnergyHelperMeterPoint -mpan $config["mpan"]
        $result.mpan | Should Be $config["mpan"]
    }

}
