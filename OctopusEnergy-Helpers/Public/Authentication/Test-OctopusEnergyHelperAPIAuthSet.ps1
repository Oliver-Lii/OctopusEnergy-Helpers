
<#
.Synopsis
   Tests whether Octopus Energy Module API Key has been configured
.OUTPUTS
   Returns a boolean value
.EXAMPLE
   Test-OctopusEnergyHelperAPIAuthSet
.FUNCTIONALITY
   Returns a boolean value depending on whether OctopusEnergy API key has been set

#>
function Test-OctopusEnergyHelperAPIAuthSet
{
   $moduleName = (Get-Command $MyInvocation.MyCommand.Name).Source
   Return (Test-Path "$env:userprofile\$moduleName\$moduleName-Credentials.xml" -PathType Leaf)
}