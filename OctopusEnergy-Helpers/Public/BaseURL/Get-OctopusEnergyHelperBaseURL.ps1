
<#
.Synopsis
   Gets the OctopusEnergy Base URL
.OUTPUTS
   Returns a string with the URL for the target endpoint
.EXAMPLE
   Get-OctopusEnergyHelperBaseURL -endpoint products   
.FUNCTIONALITY
   Returns a string with the URL for the target endpoint

#>
function Get-OctopusEnergyHelperBaseURL
{
   Param(
      [ValidateSet("elecmp","gasmp","products")]
      [string]$endpoint
   )
   $endpointPath = @{
      "elecmp" = "/v1/electricity-meter-points/"
      "gasmp" = "/v1/gas-meter-points/"
      "products" = "/v1/products/"
   }

   if(! (Test-OctopusEnergyHelperBaseURLSet))
   {
      Set-OctopusEnergyHelperBaseURL | Out-Null
   }

   $requestEndpoint = "$Global:OctopusEnergyHelperBaseURL$($endpointPath[$endpoint])"
   Return $requestEndpoint
}