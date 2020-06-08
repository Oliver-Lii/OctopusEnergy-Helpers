
<#
.SYNOPSIS
   Retrieves the details of an energy product
.DESCRIPTION
   Retrieves the details of an energy product. Products can be retrieved by product code, display name or fulle name. When called with no parameters this will return all products.
.PARAMETER APIKey
   The Octopus Energy API Key
.PARAMETER FullName
   The full name of the product to be retrieved.
.PARAMETER DisplayName
   The display name of the product to be retrieved.
.PARAMETER ProductCode
   The product code of the product to be retrieved.
.PARAMETER TariffsActiveAt
   The point in time in which to show the active charges
.INPUTS
   None
.OUTPUTS
   Returns a object with details of an energy product
.EXAMPLE
   C:\PS>Get-OctopusEnergyHelperEnergyProduct -ProductCode "GO-18-06-12"
   Retrieve the details for the Octopus Go product with code GO-18-06-12
.EXAMPLE
   C:\PS>Get-OctopusEnergyHelperEnergyProduct -DisplayName @("Agile Octopus", "Octopus Go") -TariffsActiveAt (Get-Date)
   Retrieve the details for the products with display name "Agile Octopus" and "Octopus Go" with tariffs active from today
.EXAMPLE
   C:\PS>Get-OctopusEnergyHelperEnergyProduct -FullName @("Agile Octopus February 2018", "Octopus Go June 2018") -TariffsActiveAt (Get-Date)
   Retrieve the details for the products with full name "Agile Octopus February 2018" and "Octopus Go June 2018" with tariffs active from today
.EXAMPLE
   C:\PS>Get-OctopusEnergyHelperEnergyProduct
   Retrieve all products
.LINK
   https://developer.octopus.energy/docs/api/#retrieve-a-product
#>
function Get-OctopusEnergyHelperEnergyProduct
{
   [CmdletBinding(SupportsShouldProcess=$true,DefaultParameterSetName='all')]
   [OutputType([System.Collections.Generic.List[PSObject]])]
   Param(
      [securestring]$APIKey=(Get-OctopusEnergyHelperAPIAuth),

      [Parameter(Mandatory=$true,ParameterSetName='ByFullName')]
      [ValidateNotNullOrEmpty()]
      [Alias("full_name")]
      [string[]]$FullName,

      [Parameter(Mandatory=$true,ParameterSetName='ByDisplayName')]
      [ValidateNotNullOrEmpty()]
      [Alias("display_name")]
      [string[]]$DisplayName,

      [Parameter(Mandatory=$true,ParameterSetName='ByProductCode')]
      [ValidateNotNullOrEmpty()]
      [Alias("product_code")]
      [string[]]$ProductCode,

      [Parameter(ParameterSetName='ByFullName')]
      [Parameter(ParameterSetName='ByDisplayName')]
      [Parameter(ParameterSetName='ByProductCode')]
      [Alias("tariffs_active_at")]
      [datetime]$TariffsActiveAt
   )
   $oeAPIKey = (New-Object PSCredential "user",$APIKey).GetNetworkCredential().Password
   $Credential = New-Object System.Management.Automation.PSCredential ($oeAPIKey, (New-Object System.Security.SecureString))

   $URL = Get-OctopusEnergyHelperBaseURL -endpoint products

   If($PSCmdlet.ParameterSetName -ne "ByProductCode")
   {
      if( $pscmdlet.ShouldProcess("Octopus Energy API", "Retrieve Product List") )
      {
         $oeProductList = Get-OctopusEnergyHelperEnergyProductList -ApiKey $APIKey
      }

      Switch($PSCmdlet.ParameterSetName)
      {
         'ByFullName'{
            $ProductCode = ($oeProductList | Where-Object {($_ | Select-Object -ExpandProperty "full_name") -in $FullName}).code
         }
         'ByDisplayName'{
            $ProductCode = ($oeProductList | Where-Object {($_ | Select-Object -ExpandProperty "display_name") -in $DisplayName}).code
         }
         'All'{
            $ProductCode = $oeProductList.code
         }
      }
   }

   $ParamsToIgnore = @("APIKey","ProductCode","DisplayName","FullName")
   $allParameterValues = $MyInvocation | Get-OctopusEnergyHelperParameterValue -BoundParameters $PSBoundParameters
   $apiParams = $MyInvocation | Get-OctopusEnergyHelperAPIParameter -Hashtable $allParameterValues -Exclude $paramsToIgnore
   $apiParams = $apiParams | ConvertTo-OctopusEnergyHelperAPIParam

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
      $oehlist = [System.Collections.Generic.List[PSObject]]::new($ProductCode.count)
      foreach($code in $ProductCode)
      {
         $requestParams.uri = "$URL$code/"
         $percent = ($oehlist.Count / $ProductCode.count) * 100
         Write-Progress -Activity "Retrieving results" -Status "Collected $($oehlist.Count) out of $($ProductCode.count) results" -PercentComplete $percent
         $response = Get-OctopusEnergyHelperResponse -requestParams $requestParams
         $oehlist.Add($response)
      }

      Return $oehlist
   }
}
