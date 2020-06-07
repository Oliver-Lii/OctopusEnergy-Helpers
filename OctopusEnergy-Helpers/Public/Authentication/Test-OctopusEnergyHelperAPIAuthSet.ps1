
<#
.SYNOPSIS
   Tests whether Octopus Energy Module API Key has been configured
.DESCRIPTION
   Returns a boolean value depending on whether OctopusEnergy API key has been set
.OUTPUTS
   Returns a boolean value
.EXAMPLE
   C:\PS>Test-OctopusEnergyHelperAPIAuthSet
   Test whether the credential file exists
#>
function Test-OctopusEnergyHelperAPIAuthSet
{
   $moduleName = (Get-Command $MyInvocation.MyCommand.Name).Source
   Return (Test-Path "$env:userprofile\$moduleName\$moduleName-Credentials.xml" -PathType Leaf)
}