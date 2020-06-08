<#
.SYNOPSIS
   Retrieves the tariffs of an energy product
.DESCRIPTION
   Retrieves the tarffis of an energy product
.PARAMETER APIKey
   The Octopus Energy API Key
.PARAMETER TariffCode
   The code of the tariff to be retrieved.
.PARAMETER PeriodFrom
   Show charges active from the given datetime (inclusive). This parameter can be provided on its own.
.PARAMETER PeriodTo
   Show charges active to the given datetime (exclusive). This parameter also requires providing the period_from parameter to create a range.
.INPUTS
   None
.OUTPUTS
   Returns a PSCustom object with tariffs of an energy product
.EXAMPLE
   C:\PS>Get-OctopusEnergyHelperEnergyProductTariff -TariffCode "E-1R-AGILE-18-02-21-C" -PeriodFrom (Get-Date)
   Retrieve the product tariffs for the Octopus Agile for today.
.LINK
   https://developer.octopus.energy/docs/api/#list-tariff-charges
#>
function Get-OctopusEnergyHelperEnergyProductTariff
{
   [CmdletBinding(SupportsShouldProcess=$true)]
   Param(
      [securestring]$APIKey=(Get-OctopusEnergyHelperAPIAuth),

      [Parameter(Mandatory=$true,ParameterSetName='InclusiveDateRange')]
      [Parameter(Mandatory=$true,ParameterSetName='ExclusiveDateRange')]
      [ValidatePattern("^(E\-[12]R|^G\-1R)\-[A-Z0-9\-]*\-[ABCDEFGHJKLMNP]$")]
      [Alias("tariff_code")]
      [string]$TariffCode,

      [Parameter(Mandatory=$false,ParameterSetName='InclusiveDateRange')]
      [Parameter(Mandatory=$true,ParameterSetName='ExclusiveDateRange')]
      [Alias("period_from")]
      [datetime]$PeriodFrom,

      [Parameter(Mandatory=$true,ParameterSetName='ExclusiveDateRange')]
      [Alias("period_to")]
      [datetime]$PeriodTo
   )
   $oeAPIKey = (New-Object PSCredential "user",$ApiKey).GetNetworkCredential().Password
   $Credential = New-Object System.Management.Automation.PSCredential ($oeAPIKey, (New-Object System.Security.SecureString))

   $URL = Get-OctopusEnergyHelperBaseURL -endpoint products

   $rates = [System.Collections.Generic.List[String]]@("standing-charges","standard-unit-rates")

   $TariffCode -match "^(?<fuelType>[EG])\-(?<rateType>[12]R)\-(?<productCode>[A-Z0-9\-]*)\-(?<gspCode>[ABCDEFGHJKLMNP]$)" | Out-Null
   $productCode = $matches.ProductCode
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
      ProductCode = $productCode
      TariffCode = $TariffCode
      FuelType = $fuelType
   }

   $ParamsToIgnore = @("APIKey","TariffCode")
   $allParameterValues = $MyInvocation | Get-OctopusEnergyHelperParameterValue -BoundParameters $PSBoundParameters
   $apiParams = $MyInvocation | Get-OctopusEnergyHelperAPIParameter -Hashtable $allParameterValues -Exclude $paramsToIgnore
   $apiParams = $apiParams | ConvertTo-OctopusEnergyHelperAPIParam

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
         $requestParams["uri"] = "$URL$ProductCode/$fuelPath/$TariffCode/$rate/"
         $tariffList = Get-OctopusEnergyHelperResponse -requestParams $requestParams
         $tariffData | Add-Member -MemberType NoteProperty -Name $rate -Value $tariffList
      }
      Return $tariffData
   }
}