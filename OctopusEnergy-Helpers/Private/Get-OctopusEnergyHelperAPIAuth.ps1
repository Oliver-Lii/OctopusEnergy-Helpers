
<#
.SYNOPSIS
   Gets the Octopus Energy Module API Key
.DESCRIPTION
   Returns a securestring object containing the OctopusEnergy API Key
.PARAMETER InputObject
   Hashtable containing the values to pass to the API
.EXAMPLE
   C:\PS>Get-OctopusEnergyHelperAPIAuth
   Retrieve the Octopus Energy API authentication key
.OUTPUTS
   Returns a securestring containing the OctopusEnergy API Key
#>
function Get-OctopusEnergyHelperAPIAuth
{
   $moduleName = (Get-Command $MyInvocation.MyCommand.Name).Source
   if(Test-OctopusEnergyHelperAPIAuthSet)
   {
      $ApiKey = Import-CliXml -Path "$env:userprofile\$moduleName\$moduleName-Credentials.xml"
   }

   Return $ApiKey
}