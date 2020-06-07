
<#
.SYNOPSIS
   Tests whether Octopus Energy Config file is available
.DESCRIPTION
   Returns a boolean value depending on whether Octopus Energy Config file has been set.
.OUTPUTS
   Returns a boolean value
.EXAMPLE
   C:\PS>Test-OctopusEnergyHelperConfigSet
   Test that the OCtopus Energy Helper module configuration file exists
#>
function Test-OctopusEnergyHelperConfigSet
{
   $moduleName = (Get-Command $MyInvocation.MyCommand.Name).Source
   Return (Test-Path "$env:userprofile\$moduleName\$moduleName-Config.xml" -PathType Leaf)
}