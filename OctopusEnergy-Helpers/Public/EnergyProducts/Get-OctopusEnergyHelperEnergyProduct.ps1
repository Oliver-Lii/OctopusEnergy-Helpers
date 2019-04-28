
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
.EXAMPLE
   Get-OctopusEnergyHelperEnergyProduct -display_name @("Flexible Octopus", "Super Green Octopus") -tariffs_active_at (Get-Date)
.EXAMPLE
   Get-OctopusEnergyHelperEnergyProduct -full_name @("Super Green Octopus 12M Fixed April 2019 v1", "Flexible Octopus April 2019 v1") -tariffs_active_at (Get-Date)
.EXAMPLE
   Get-OctopusEnergyHelperEnergyProduct
.FUNCTIONALITY
   Retrieves the details of an energy product

#>
function Get-OctopusEnergyHelperEnergyProduct
{
   [CmdletBinding(SupportsShouldProcess=$true,DefaultParameterSetName='all')]
   [OutputType([System.Collections.Generic.List[PSObject]])]
   Param(
      [System.Management.Automation.PSCredential]$Credential=(Get-OctopusEnergyHelperAPIAuth),

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
   $URL = Get-OctopusEnergyHelperBaseURL -endpoint products

   If($PSCmdlet.ParameterSetName -ne "ByProductCode")
   {
      if( $pscmdlet.ShouldProcess("Octopus Energy API", "Retrieve Product List") )
      {
         $oeProductList = Get-OctopusEnergyHelperEnergyProductList -Credential $Credential
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
   $ParamsToIgnore = @("Credential","product_code","display_name","product_code","full_name")
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
