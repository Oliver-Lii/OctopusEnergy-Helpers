
<#
.Synopsis
   Tests whether Octopus Energy Module API Key has been configured
.OUTPUTS
   Returns a boolean value
.EXAMPLE
   Test-OctopusEnergyHelperAPIAuthSet 
.FUNCTIONALITY
   Returns a boolean value depending on whether OctopusEnergy API Credentials have been set

#>
function Test-OctopusEnergyHelperAPIAuthSet
{
    If($Global:OctopusEnergyHelperCredentials)
    {
        Return $true
    }
    else
    {
        Return $false
    }
}