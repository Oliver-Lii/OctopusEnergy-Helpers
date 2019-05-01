
<#
.Synopsis
   Gets the Octopus Energy Module API Key
.EXAMPLE
   Get-OctopusEnergyHelperAPIAuth
.OUTPUTS
   Returns a securestring containing the OctopusEnergy API Key
.FUNCTIONALITY
   Returns a securestring object containing the OctopusEnergy API Key

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