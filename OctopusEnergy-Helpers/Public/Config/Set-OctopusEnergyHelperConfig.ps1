<#
.Synopsis
    Configures the Octopus Energy config file used by the module.
.PARAMETER mpan
   The mpan of the electricity meter
.PARAMETER mprn
   The mprn of the gas meter
.PARAMETER elec_serial_number
   The electricity meter's serial number
.PARAMETER gas_serial_number
   The electricity meter's serial number
.INPUTS
    None
.OUTPUTS
    None
.EXAMPLE
    Set-OctopusEnergyHelperConfig -mpan "123456789" -mprn "123456789" -elec_serial_number "E123456789" -gas_serial_number "G123456789"
.FUNCTIONALITY
    Configures the Octopus Energy config file used by the module

#>
function Set-OctopusEnergyHelperConfig
{
    [CmdletBinding(SupportsShouldProcess=$true)]
    [OutputType([System.Boolean])]
    Param(
        [ValidateNotNullOrEmpty()]
        [String] $mpan,

        [ValidateNotNullOrEmpty()]
        [string] $mprn,

        [ValidateNotNullOrEmpty()]
        [string] $elec_serial_number,

        [ValidateNotNullOrEmpty()]
        [string] $gas_serial_number
    )

    Try
    {
        $moduleName = (Get-Command $MyInvocation.MyCommand.Name).Source
        If(! (Test-Path "$env:userprofile\$moduleName\"))
        {
            New-Item "$env:userprofile\$moduleName" -ItemType Directory | Out-Null
        }
        $config = [ordered]@{
            mpan = $mpan
            mprn = $mprn
            elec_serial_number = $elec_serial_number
            gas_serial_number = $gas_serial_number
        }
        $config | Export-CliXml -Path "$env:userprofile\$moduleName\$moduleName-Config.xml"
    }
    Catch
    {
        Write-Error $_
        Return $false
    }

    Return $true
}
