
<#
.SYNOPSIS
   Tests whether Octopus Energy Base URL has been configured
.DESCRIPTION
   Returns a boolean value depending on whether OctopusEnergy Base URL has been set
.OUTPUTS
   Returns a boolean value
.EXAMPLE
   C:\>Test-OctopusEnergyHelperBaseURLSet
   Test whether the Octopus Energy Helper Base URL global variable has been set
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