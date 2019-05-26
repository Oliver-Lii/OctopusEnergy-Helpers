<#
.Synopsis
   Retrieves the tariffs of an energy product
.PARAMETER apikey
   The Octopus Energy API Key
.PARAMETER tariff_code
   The code of the tariff to be retrieved.
.PARAMETER tariffs_active_at
   The point in time in which to show the active charges
.PARAMETER period_from
   Show charges active from the given datetime (inclusive). This parameter can be provided on its own.
.PARAMETER period_to
   Show charges active to the given datetime (exclusive). This parameter also requires providing the period_from parameter to create a range.
.INPUTS
   None
.OUTPUTS
   Returns a PSCustom object with tariffs of an energy product
.EXAMPLE
   Get-OctopusEnergyHelperEnergyProductTariff -tariff_code "E-1R-AGILE-18-02-21-C" -period_from (Get-Date)
.FUNCTIONALITY
   Retrieves the tarffis of an energy product

#>
function Get-OctopusEnergyHelperEnergyProductTariff
{
   [CmdletBinding(SupportsShouldProcess=$true)]
   Param(
      [securestring]$ApiKey=(Get-OctopusEnergyHelperAPIAuth),

      [Parameter(Mandatory=$true,ParameterSetName='InclusiveDateRange')]
      [Parameter(Mandatory=$true,ParameterSetName='ExclusiveDateRange')]
      [ValidatePattern("^(E\-[12]R|^G\-1R)\-[A-Z0-9\-]*\-[ABCDEFGHJKLMNP]$")]
      [string]$tariff_code,

      [Parameter(Mandatory=$false,ParameterSetName='InclusiveDateRange')]
      [Parameter(Mandatory=$true,ParameterSetName='ExclusiveDateRange')]
      [datetime]$period_from,

      [Parameter(Mandatory=$true,ParameterSetName='ExclusiveDateRange')]
      [datetime]$period_to
   )
   $oeAPIKey = (New-Object PSCredential "user",$ApiKey).GetNetworkCredential().Password
   $Credential = New-Object System.Management.Automation.PSCredential ($oeAPIKey, (New-Object System.Security.SecureString))

   $URL = Get-OctopusEnergyHelperBaseURL -endpoint products

   $rates = [System.Collections.Generic.List[String]]@("standing-charges","standard-unit-rates")

   $tariff_code -match "^(?<fuelType>[EG])\-(?<rateType>[12]R)\-(?<productCode>[A-Z0-9\-]*)\-(?<gspCode>[ABCDEFGHJKLMNP]$)" | Out-Null
   $product_code = $matches.ProductCode
   switch($Matches.fuelType)
   {
      "G" {$fuelType = "gas"}
      "E" {
         If($Matches.rateType -eq "2R")
         {
            $rates.Remove("standard-unit-rates")
            $rates.Add("day-unit-rates")
            $rates.Add("night-unit-rates")
         }
         $fuelType = "electricity"
      }
   }
   $fuelPath = "$fuelType-tariffs"

   $tariffData = [PSCustomObject]@{
      ProductCode = $product_code
      TariffCode = $tariff_code
      FuelType = $fuelType
   }

   $psParams = @{}
   $ParameterList = (Get-Command -Name $MyInvocation.InvocationName).Parameters
   $ParamsToIgnore = @("apikey","product_code","tariff_code","type")
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
      method = "Get"
      ContentType = "application/x-www-form-urlencoded"
      body = $apiParams
      uri = ""
  }

   if( $pscmdlet.ShouldProcess("Octopus Energy API", "Retrieve Product Tariffs") )
   {
      foreach($rate in $rates)
      {
         $tariffList = @()
         $requestParams["uri"] = "$URL$product_code/$fuelPath/$tariff_code/$rate/"
         $tariffList = Get-OctopusEnergyHelperResponse -requestParams $requestParams
         $tariffData | Add-Member -MemberType NoteProperty -Name $rate -Value $tariffList
      }
      Return $tariffData
   }
}