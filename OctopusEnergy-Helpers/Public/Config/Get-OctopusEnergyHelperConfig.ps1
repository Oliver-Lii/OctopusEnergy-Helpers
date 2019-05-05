
<#
.Synopsis
   Gets the Octopus Energy Config
.PARAMETER property
   The property of the Octopus Energy Config to retrieve
.OUTPUTS
   Returns the requested property of config
.EXAMPLE
   Get-OctopusEnergyHelperConfig -property mpan
.FUNCTIONALITY
   Returns the information relating to the requested property of config data, returning all config data if no property specified.

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
