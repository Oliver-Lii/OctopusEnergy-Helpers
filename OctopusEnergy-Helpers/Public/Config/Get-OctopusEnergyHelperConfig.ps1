
<#
.SYNOPSIS
   Gets the Octopus Energy Config
.DESCRIPTION
   Returns the information relating to the requested property of config data, returning all config data if no property specified.
.PARAMETER Property
   The property of the Octopus Energy Config to retrieve
.OUTPUTS
   Returns the requested property of config
.EXAMPLE
   C:\PS>Get-OctopusEnergyHelperConfig -property mpan
   Retrieve the configuration for the mpan property
#>
function Get-OctopusEnergyHelperConfig
{
   Param(
      [ValidateSet("mpan","mprn","elec_serial_number","gas_serial_number")]
      [string]$property
   )

   $moduleName = (Get-Command $MyInvocation.MyCommand.Name).Source
   if(Test-OctopusEnergyHelperConfigSet)
   {
      $config = Import-CliXml -Path "$env:userprofile\$moduleName\$moduleName-Config.xml"
   }

   $data = $config
   if($property)
   {
      $data = $config[$property]
   }
   Return $data
}
