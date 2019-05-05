<#
.Synopsis
    Updates the Octopus Energy config file used by the module.
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
    Update-OctopusEnergyHelperConfig -mpan "987654321"
.FUNCTIONALITY
    Updates the configuration in the Octopus Energy helper config file used by the module

#>
function Update-OctopusEnergyHelperConfig
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
        if(Test-OctopusEnergyHelperConfigSet)
        {
           $config = Import-CliXml -Path "$env:userprofile\$moduleName\$moduleName-Config.xml"
        }

        $ParameterList = (Get-Command -Name $MyInvocation.InvocationName).Parameters
        foreach ($key in $ParameterList.keys)
        {
            $var = Get-Variable -Name $key -ErrorAction SilentlyContinue;
            if($var.value)
            {
              $config[$var.Name] = $var.value
            }
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
