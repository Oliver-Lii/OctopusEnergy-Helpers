
<#
.Synopsis
   Tests whether Octopus Energy Base URL has been configured
.OUTPUTS
   Returns a boolean value
.EXAMPLE
   Test-OctopusEnergyHelperBaseURLSet
.FUNCTIONALITY
   Returns a boolean value depending on whether OctopusEnergy Base URL has been set

#>
function Test-OctopusEnergyHelperBaseURLSet
{
    If($Global:OctopusEnergyHelperBaseURL)
    {
        Return $true
    }
    else
    {
        Return $false
    }
}