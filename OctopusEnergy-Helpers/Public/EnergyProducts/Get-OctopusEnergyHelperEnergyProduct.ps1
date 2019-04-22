
<#
.Synopsis
   Retrieves the details of an energy product
.PARAMETER product_code
   The code of the product to be retrieved.
.PARAMETER tariffs_active_at
   The point in time in which to show the active charges
.INPUTS
   None
.OUTPUTS
   Returns a object with details of an energy product
.EXAMPLE
   Get-OctopusEnergyHelperEnergyProduct -product_code "GO-18-06-12"
.FUNCTIONALITY
   Retrieves the details of an energy product

#>
function Get-OctopusEnergyHelperEnergyProduct
{
   [CmdletBinding(SupportsShouldProcess=$true)]
   Param(
      [System.Management.Automation.PSCredential]$Credential=(Get-OctopusEnergyHelperAPIAuth),

      [Parameter(Mandatory=$true)]
      [ValidateNotNullOrEmpty()]
      [string]$product_code,

      [datetime]$tariffs_active_at
   )
   $URL = Get-OctopusEnergyHelperBaseURL -endpoint products
   $requestURL = "$URL$product_code/"

   $psParams = @{}
   $ParameterList = (Get-Command -Name $MyInvocation.InvocationName).Parameters
   $ParamsToIgnore = @("product_code")
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
          If($value.GetType().Name -eq "DateTime")
          {
            $value = ($value | Get-date -format "s").tostring()
          }
         $psParams.Add($var.name,$value)
       }
   }

   $requestParams = @{
      Credential = $Credential
      uri = $requestURL
      UseBasicParsing = $true
      method = "Get"
      ContentType = "application/x-www-form-urlencoded"
      body = $psParams
  }
   if( $pscmdlet.ShouldProcess("Octopus Energy API", "Retrieve Product Detail") )
   {
      $response = Get-OctopusEnergyHelperResponse -requestParams $requestParams
      Return $response
   }
}
