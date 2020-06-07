
<#
.SYNOPSIS
   Retrieves the list of energy products
.DESCRIPTION
   Retrieves the list of energy products
.PARAMETER apikey
   The Octopus Energy API Key
.PARAMETER is_variable
   Show only variable products
.PARAMETER is_green
   Show only green products
.PARAMETER is_tracker
   Show only tracker products
.PARAMETER is_prepay
   Show only pre-pay products
.PARAMETER is_business
   Show only business products
.PARAMETER available_at
   Show products available for new agreements on the give datetime.
.INPUTS
   None
.OUTPUTS
   Returns a object with details of the energy products
.EXAMPLE
   C:\PS>Get-OctopusEnergyHelperEnergyProductList
   Retrieve all energy products
.EXAMPLE
   C:\PS>Get-OctopusEnergyHelperEnergyProductList -available_at $((Get-Date).AddMonths(-1))
   Retrieve all energy products which are available in the last month
.EXAMPLE
   C:\PS>Get-OctopusEnergyHelperEnergyProductList -is_variable
   Retrieve all energy products which are variable rate only
#>
function Get-OctopusEnergyHelperEnergyProductList
{
   [CmdletBinding(SupportsShouldProcess=$true)]
   Param(
      [securestring]$ApiKey=(Get-OctopusEnergyHelperAPIAuth),

      [switch]$is_variable,

      [switch]$is_green,

      [switch]$is_tracker,

      [switch]$is_prepay,

      [switch]$is_business,

      [datetime]$available_at
   )
   $oeAPIKey = (New-Object PSCredential "user",$ApiKey).GetNetworkCredential().Password
   $Credential = New-Object System.Management.Automation.PSCredential ($oeAPIKey, (New-Object System.Security.SecureString))
   $requestURL = Get-OctopusEnergyHelperBaseURL -endpoint products

   $psParams = @{}
   $ParameterList = (Get-Command -Name $MyInvocation.InvocationName).Parameters
   $ParamsToIgnore = @("apikey")
   foreach ($key in $ParameterList.keys)
   {
      $var = Get-Variable -Name $key -ErrorAction SilentlyContinue;
      if($ParamsToIgnore -contains $var.Name)
      {
          continue
      }
      elseif($var.value -or $var.value -eq 0)
      {
         $value = $var.value
         $psParams.Add($var.name,$value)
      }
   }

   $apiParams = $psParams | ConvertTo-OctopusEnergyHelperAPIParam
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