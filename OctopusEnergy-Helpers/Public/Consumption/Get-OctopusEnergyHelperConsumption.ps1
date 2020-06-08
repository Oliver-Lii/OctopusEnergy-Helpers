<#
.SYNOPSIS
   Retrieves the consumption for a smart gas or electricity meter
.DESCRIPTION
   Returns the consumption for a smart gas or electricity meter. Consumption data returned is dependent on whether the MPAN or MPRN and associated serial number is supplied.
.PARAMETER APIKey
   The Octopus Energy API Key
.PARAMETER MPAN
   The MPAN of the electricity meter
.PARAMETER MPRN
   The MPRN of the gas meter
.PARAMETER SerialNumber
   The gas or electricity meter's serial number
.PARAMETER PeriodFrom
   Show consumption from the given datetime (inclusive). This parameter can be provided on its own.
.PARAMETER PeriodTo
   Show consumption to the given datetime (exclusive). This parameter also requires providing the period_from parameter to create a range.
.PARAMETER PageSize
   Page size of returned results. Default is 100, maximum is 25,000 to give a full year of half-hourly consumption details.
.PARAMETER OrderBy
   Ordering of results returned. Default is that results are returned in reverse order from latest available figure.
   Valid values: * ‘period’, to give results ordered forward. * ‘-period’, (default), to give results ordered from most recent backwards.
.PARAMETER GroupBy
   Grouping of consumption. Default is that consumption is returned in half-hour periods. Possible alternatives are: * ‘hour’ * ‘day’ * ‘week’ * ‘month’ * ‘quarter’
.INPUTS
   None
.OUTPUTS
   Returns a PSCustomObject with details of the consumption
.EXAMPLE
   C:\PS>Get-OctopusEnergyHelperConsumption -mpan 1234567890 -serial_number A1B2C3D4
   Retrieve the electricity consumption data with MPAN 1234567890 with serial number A1B2C3D4
.EXAMPLE
   C:\PS>Get-OctopusEnergyHelperConsumption -mprn 1234567890 -serial_number A1B2C3D4
   Retrieve the gas consumption data with MPRN 1234567890 with serial number A1B2C3D4
.LINK
   https://developer.octopus.energy/docs/api/#consumption
#>
function Get-OctopusEnergyHelperConsumption
{
   [CmdletBinding(SupportsShouldProcess=$true)]
   Param(
      [securestring]$APIKey=(Get-OctopusEnergyHelperAPIAuth),

      [Parameter(Mandatory=$true,ParameterSetName='Electricity')]
      [Parameter(Mandatory=$true,ParameterSetName='InclusiveDateRange')]
      [Parameter(Mandatory=$true,ParameterSetName='ExclusiveDateRange')]
      [ValidateNotNullOrEmpty()]
      [string]$MPAN,

      [Parameter(Mandatory=$true,ParameterSetName='Gas')]
      [Parameter(Mandatory=$true,ParameterSetName='InclusiveDateRange')]
      [Parameter(Mandatory=$true,ParameterSetName='ExclusiveDateRange')]
      [ValidateNotNullOrEmpty()]
      [string]$MPRN,

      [Parameter(Mandatory=$true,ParameterSetName='Electricity')]
      [Parameter(Mandatory=$true,ParameterSetName='Gas')]
      [Parameter(Mandatory=$true,ParameterSetName='InclusiveDateRange')]
      [Parameter(Mandatory=$true,ParameterSetName='ExclusiveDateRange')]
      [ValidateNotNullOrEmpty()]
      [Alias("serial_number")]
      [string]$SerialNumber,

      [Parameter(Mandatory=$false,ParameterSetName='Electricity')]
      [Parameter(Mandatory=$false,ParameterSetName='Gas')]
      [Parameter(Mandatory=$false,ParameterSetName='InclusiveDateRange')]
      [Parameter(Mandatory=$true,ParameterSetName='ExclusiveDateRange')]
      [Alias("period_from")]
      [datetime]$PeriodFrom,

      [Parameter(Mandatory=$false,ParameterSetName='Electricity')]
      [Parameter(Mandatory=$false,ParameterSetName='Gas')]
      [Parameter(Mandatory=$true,ParameterSetName='ExclusiveDateRange')]
      [Alias("period_to")]
      [datetime]$PeriodTo,

      [Parameter(Mandatory=$false,ParameterSetName='Electricity')]
      [Parameter(Mandatory=$false,ParameterSetName='Gas')]
      [Parameter(Mandatory=$false,ParameterSetName='InclusiveDateRange')]
      [Parameter(Mandatory=$false,ParameterSetName='ExclusiveDateRange')]
      [ValidateRange(1,25000)]
      [Alias("page_size")]
      [int]$PageSize=1000,

      [Parameter(Mandatory=$false,ParameterSetName='Electricity')]
      [Parameter(Mandatory=$false,ParameterSetName='Gas')]
      [Parameter(Mandatory=$false,ParameterSetName='InclusiveDateRange')]
      [Parameter(Mandatory=$false,ParameterSetName='ExclusiveDateRange')]
      [ValidateSet("period","-period")]
      [Alias("order_by")]
      [string]$OrderBy,

      [Parameter(Mandatory=$false,ParameterSetName='Electricity')]
      [Parameter(Mandatory=$false,ParameterSetName='Gas')]
      [Parameter(Mandatory=$false,ParameterSetName='InclusiveDateRange')]
      [Parameter(Mandatory=$false,ParameterSetName='ExclusiveDateRange')]
      [ValidateSet("hour","day","week","month","quarter")]
      [Alias("group_by")]
      [string]$GroupBy
   )

   $oeAPIKey = (New-Object PSCredential "user",$APIKey).GetNetworkCredential().Password
   $Credential = New-Object System.Management.Automation.PSCredential ($oeAPIKey, (new-object System.Security.SecureString))

   if($MPAN)
   {
      $URL = Get-OctopusEnergyHelperBaseURL -endpoint elecmp
      $requestURL = "$URL$MPAN/meters/$SerialNumber/consumption/"
   }
   else
   {
      $URL = Get-OctopusEnergyHelperBaseURL -endpoint gasmp
      $requestURL = "$URL$MPRN/meters/$SerialNumber/consumption/"
   }

   $paramsToIgnore = @("APIKey","MPAN","MPRN","SerialNumber")
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
   if( $pscmdlet.ShouldProcess("Octopus Energy API", "Retrieve Consumption") )
   {
      $response = Get-OctopusEnergyHelperResponse -requestParams $requestParams
      Return $response
   }
}