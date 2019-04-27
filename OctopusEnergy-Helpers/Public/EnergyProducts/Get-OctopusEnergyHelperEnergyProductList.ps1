
<#
.Synopsis
   Retrieves the list of energy products
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
   Get-OctopusEnergyHelperEnergyProductList
.EXAMPLE
   Get-OctopusEnergyHelperEnergyProductList -is_variable
.FUNCTIONALITY
   Retrieves the list of energy products

#>
function Get-OctopusEnergyHelperEnergyProductList
{
   [CmdletBinding(SupportsShouldProcess=$true)]
   Param(
      [System.Management.Automation.PSCredential]$Credential=(Get-OctopusEnergyHelperAPIAuth),

      [switch]$is_variable,

      [switch]$is_green,

      [switch]$is_tracker,

      [switch]$is_prepay,

      [switch]$is_business,

      [datetime]$available_at
   )
   $requestURL = Get-OctopusEnergyHelperBaseURL -endpoint products

   $psParams = @{}
   $ParameterList = (Get-Command -Name $MyInvocation.InvocationName).Parameters
   $ParamsToIgnore = @("Credential")
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