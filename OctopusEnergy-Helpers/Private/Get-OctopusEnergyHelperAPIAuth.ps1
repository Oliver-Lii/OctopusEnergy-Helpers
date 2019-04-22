
<#
.Synopsis
   Gets the Octopus Energy Module API Key
.EXAMPLE
   Get-OctopusEnergyHelperAPIAuth
.OUTPUTS
   Returns a credential object containing the OctopusEnergy API Key
.FUNCTIONALITY
   Returns a credential object containing the OctopusEnergy API Key

#>
function Get-OctopusEnergyHelperAPIAuth
{
    if(Test-OctopusEnergyHelperAPIAuthSet)
    {
        Return $Global:OctopusEnergyHelperCredentials
    }
    else
    {
        Return
    }
}