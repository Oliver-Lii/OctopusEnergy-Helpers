
<#
.SYNOPSIS
   Gets the OctopusEnergy Base URL
.DESCRIPTION
   Returns a string with the URL for the target endpoint
.PARAMETER Endpoint
   The API endpoint to retrieve.
.OUTPUTS
   Returns a string with the URL for the target endpoint
.EXAMPLE
   C:\PS>Get-OctopusEnergyHelperBaseURL -endpoint products
   Retrieve the path to API products endpoint
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