
<#
.SYNOPSIS
   Retrieves the details of an energy product
.DESCRIPTION
   Retrieves the details of an energy product. Products can be retrieved by product code, display name or fulle name. When called with no parameters this will return all products.
.PARAMETER apikey
   The Octopus Energy API Key
.PARAMETER full_name
   The full name of the product to be retrieved.
.PARAMETER display_name
   The display name of the product to be retrieved.
.PARAMETER product_code
   The product code of the product to be retrieved.
.PARAMETER tariffs_active_at
   The point in time in which to show the active charges
.INPUTS
   None
.OUTPUTS
   Returns a object with details of an energy product
.EXAMPLE
   C:\PS>Get-OctopusEnergyHelperEnergyProduct -product_code "GO-18-06-12"
   Retrieve the details for the Octopus Go product with code GO-18-06-12
.EXAMPLE
   C:\PS>Get-OctopusEnergyHelperEnergyProduct -display_name @("Flexible Octopus", "Super Green Octopus") -tariffs_active_at (Get-Date)
   Retrieve the details for the products with display name "Flexible Octopus" and "Super Green Octopus" with tariffs active from today
.EXAMPLE
   C:\PS>Get-OctopusEnergyHelperEnergyProduct -full_name @("Super Green Octopus 12M Fixed April 2019 v1", "Flexible Octopus April 2019 v1") -tariffs_active_at (Get-Date)
   Retrieve the details for the products with full name "Super Green Octopus 12M Fixed April 2019 v1" and "Flexible Octopus April 2019 v1" with tariffs active from today
.EXAMPLE
   C:\PS>Get-OctopusEnergyHelperEnergyProduct
   Retrieve all products
#>
function Get-OctopusEnergyHelperEnergyProduct
{
   [CmdletBinding(SupportsShouldProcess=$true,DefaultParameterSetName='all')]
   [OutputType([System.Collections.Generic.List[PSObject]])]
   Param(
      [securestring]$ApiKey=(Get-OctopusEnergyHelperAPIAuth),

      [Parameter(Mandatory=$true,ParameterSetName='ByFullName')]
      [ValidateNotNullOrEmpty()]
      [string[]]$full_name,

      [Parameter(Mandatory=$true,ParameterSetName='ByDisplayName')]
      [ValidateNotNullOrEmpty()]
      [string[]]$display_name,

      [Parameter(Mandatory=$true,ParameterSetName='ByProductCode')]
      [ValidateNotNullOrEmpty()]
      [string[]]$product_code,

      [Parameter(ParameterSetName='ByFullName')]
      [Parameter(ParameterSetName='ByDisplayName')]
      [Parameter(ParameterSetName='ByProductCode')]
      [datetime]$tariffs_active_at
   )
   $oeAPIKey = (New-Object PSCredential "user",$ApiKey).GetNetworkCredential().Password
   $Credential = New-Object System.Management.Automation.PSCredential ($oeAPIKey, (New-Object System.Security.SecureString))

   $URL = Get-OctopusEnergyHelperBaseURL -endpoint products

   If($PSCmdlet.ParameterSetName -ne "ByProductCode")
   {
      if( $pscmdlet.ShouldProcess("Octopus Energy API", "Retrieve Product List") )
      {
         $oeProductList = Get-OctopusEnergyHelperEnergyProductList -ApiKey $ApiKey
      }

      Switch($PSCmdlet.ParameterSetName)
      {
         'ByFullName'{
            $product_code = ($oeProductList | Where-Object {($_ | Select-Object -ExpandProperty "full_name") -in $full_name}).code
         }
         'ByDisplayName'{
            $product_code = ($oeProductList | Where-Object {($_ | Select-Object -ExpandProperty "display_name") -in $display_name}).code
         }
         'All'{
            $product_code = $oeProductList.code
         }
      }
   }

   $psParams = @{}
   $ParameterList = (Get-Command -Name $MyInvocation.InvocationName).Parameters
   $ParamsToIgnore = @("apikey","product_code","display_name","product_code","full_name")
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
      UseBasicParsing = $true
      uri = ""
      method = "Get"
      ContentType = "application/x-www-form-urlencoded"
      body = $apiParams
   }
   if( $pscmdlet.ShouldProcess("Octopus Energy API", "Retrieve Product Detail") )
   {
      $oehlist = [System.Collections.Generic.List[PSObject]]::new($product_code.count)
      foreach($code in $product_code)
      {
         $requestParams.uri = "$URL$code/"
         $percent = ($oehlist.Count / $product_code.count) * 100
         Write-Progress -Activity "Retrieving results" -Status "Collected $($oehlist.Count) out of $($product_code.count) results" -PercentComplete $percent
         $response = Get-OctopusEnergyHelperResponse -requestParams $requestParams
         $oehlist.Add($response)
      }

      Return $oehlist
   }
}
