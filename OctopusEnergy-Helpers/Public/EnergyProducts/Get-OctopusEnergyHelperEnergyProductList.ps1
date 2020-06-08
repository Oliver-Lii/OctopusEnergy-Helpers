
<#
.SYNOPSIS
   Retrieves the list of energy products
.DESCRIPTION
   Retrieves the list of energy products
.PARAMETER APIKey
   The Octopus Energy API Key
.PARAMETER Variable
   Show only variable products
.PARAMETER Green
   Show only green products
.PARAMETER Tracker
   Show only tracker products
.PARAMETER Prepay
   Show only pre-pay products
.PARAMETER Business
   Show only business products
.PARAMETER AvailableAt
   Show products available for new agreements on the give datetime.
.INPUTS
   None
.OUTPUTS
   Returns a object with details of the energy products
.EXAMPLE
   C:\PS>Get-OctopusEnergyHelperEnergyProductList
   Retrieve all energy products
.EXAMPLE
   C:\PS>Get-OctopusEnergyHelperEnergyProductList -AvailableAt $((Get-Date).AddMonths(-1))
   Retrieve all energy products which are available in the last month
.EXAMPLE
   C:\PS>Get-OctopusEnergyHelperEnergyProductList -Variable
   Retrieve all energy products which are variable rate only
.LINK
   https://developer.octopus.energy/docs/api/#energy-products
#>
function Get-OctopusEnergyHelperEnergyProductList
{
   [CmdletBinding(SupportsShouldProcess=$true)]
   Param(
      [securestring]$APIKey=(Get-OctopusEnergyHelperAPIAuth),

      [Alias("is_variable")]
      [switch]$Variable,

      [Alias("is_green")]
      [switch]$Green,

      [Alias("is_tracker")]
      [switch]$Tracker,

      [Alias("is_prepay")]
      [switch]$Prepay,

      [Alias("is_business")]
      [switch]$Business,

      [Alias("available_at")]
      [datetime]$AvailableAt
   )
   $oeAPIKey = (New-Object PSCredential "user",$APIKey).GetNetworkCredential().Password
   $Credential = New-Object System.Management.Automation.PSCredential ($oeAPIKey, (New-Object System.Security.SecureString))
   $requestURL = Get-OctopusEnergyHelperBaseURL -endpoint products

   $allParameterValues = $MyInvocation | Get-OctopusEnergyHelperParameterValue -BoundParameters $PSBoundParameters
   $apiParams = $MyInvocation | Get-OctopusEnergyHelperAPIParameter -Hashtable $allParameterValues -Exclude $paramsToIgnore
   $apiParams = $apiParams | ConvertTo-OctopusEnergyHelperAPIParam

   $requestParams = @{
      Credential = $Credential
      uri = $requestURL
      UseBasicParsing = $true
      method = "Get"
      ContentType = "application/x-www-form-urlencoded"
      body = $apiParams
   }

   if( $pscmdlet.ShouldProcess("Octopus Energy API", "Retrieve Product List") )
   {
      $response = Get-OctopusEnergyHelperResponse -requestParams $requestParams
      Return $response
   }
}