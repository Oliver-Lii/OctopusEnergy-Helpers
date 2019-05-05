
<#
.Synopsis
   Tests whether Octopus Energy Config file is available
.OUTPUTS
   Returns a boolean value
.EXAMPLE
   Test-OctopusEnergyHelperConfigSet
.FUNCTIONALITY
   Returns a boolean value depending on whether Octopus Energy Config file has been set

#>
function Test-OctopusEnergyHelperConfigSet
{
   $moduleName = (Get-Command $MyInvocation.MyCommand.Name).Source
   Return (Test-Path "$env:userprofile\$moduleName\$moduleName-Config.xml" -PathType Leaf)
}