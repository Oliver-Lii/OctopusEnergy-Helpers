<#
.Synopsis
   Retrieves the consumption for a smart gas or electricity meter
.PARAMETER apikey
   The Octopus Energy API Key
.PARAMETER mpan
   The mpan of the electricity meter
.PARAMETER mprn
   The mprn of the gas meter
.PARAMETER serial_number
   The gas or electricity meter's serial number
.PARAMETER period_from
   Show consumption from the given datetime (inclusive). This parameter can be provided on its own.
.PARAMETER period_to
   Show consumption to the given datetime (exclusive). This parameter also requires providing the period_from parameter to create a range.
.PARAMETER page_size
   Page size of returned results. Default is 100, maximum is 25,000 to give a full year of half-hourly consumption details.
.PARAMETER order_by
   Ordering of results returned. Default is that results are returned in reverse order from latest available figure.
   Valid values: * ‘period’, to give results ordered forward. * ‘-period’, (default), to give results ordered from most recent backwards.
.PARAMETER group_by
   Grouping of consumption. Default is that consumption is returned in half-hour periods. Possible alternatives are: * ‘hour’ * ‘day’ * ‘week’ * ‘month’ * ‘quarter’
.INPUTS
   None
.OUTPUTS
   Returns a PSCustomObject with details of the consumption
.EXAMPLE
   Get-OctopusEnergyHelperConsumption -mpan 1234567890 -serial_number A1B2C3D4
.FUNCTIONALITY
   Returns the consumption for a smart gas or electricity meter.
#>
function Get-OctopusEnergyHelperConsumption
{
   [CmdletBinding(SupportsShouldProcess=$true)]
   Param(
      [securestring]$ApiKey=(Get-OctopusEnergyHelperAPIAuth),

      [Parameter(Mandatory=$true,ParameterSetName='Electricity')]
      [Parameter(Mandatory=$true,ParameterSetName='InclusiveDateRange')]
      [Parameter(Mandatory=$true,ParameterSetName='ExclusiveDateRange')]
      [ValidateNotNullOrEmpty()]
      [string]$mpan,

      [Parameter(Mandatory=$true,ParameterSetName='Gas')]
      [Parameter(Mandatory=$true,ParameterSetName='InclusiveDateRange')]
      [Parameter(Mandatory=$true,ParameterSetName='ExclusiveDateRange')]
      [ValidateNotNullOrEmpty()]
      [string]$mprn,

      [Parameter(Mandatory=$true,ParameterSetName='Electricity')]
      [Parameter(Mandatory=$true,ParameterSetName='Gas')]
      [Parameter(Mandatory=$true,ParameterSetName='InclusiveDateRange')]
      [Parameter(Mandatory=$true,ParameterSetName='ExclusiveDateRange')]
      [ValidateNotNullOrEmpty()]
      [string]$serial_number,

      [Parameter(Mandatory=$false,ParameterSetName='Electricity')]
      [Parameter(Mandatory=$false,ParameterSetName='Gas')]
      [Parameter(Mandatory=$false,ParameterSetName='InclusiveDateRange')]
      [Parameter(Mandatory=$true,ParameterSetName='ExclusiveDateRange')]
      [datetime]$period_from,

      [Parameter(Mandatory=$false,ParameterSetName='Electricity')]
      [Parameter(Mandatory=$false,ParameterSetName='Gas')]
      [Parameter(Mandatory=$true,ParameterSetName='ExclusiveDateRange')]
      [datetime]$period_to,

      [Parameter(Mandatory=$false,ParameterSetName='Electricity')]
      [Parameter(Mandatory=$false,ParameterSetName='Gas')]
      [Parameter(Mandatory=$false,ParameterSetName='InclusiveDateRange')]
      [Parameter(Mandatory=$false,ParameterSetName='ExclusiveDateRange')]
      [ValidateRange(1,25000)]
      [int]$page_size=100,

      [Parameter(Mandatory=$false,ParameterSetName='Electricity')]
      [Parameter(Mandatory=$false,ParameterSetName='Gas')]
      [Parameter(Mandatory=$false,ParameterSetName='InclusiveDateRange')]
      [Parameter(Mandatory=$false,ParameterSetName='ExclusiveDateRange')]
      [ValidateSet("period","-period")]
      [string]$order_by,

      [Parameter(Mandatory=$false,ParameterSetName='Electricity')]
      [Parameter(Mandatory=$false,ParameterSetName='Gas')]
      [Parameter(Mandatory=$false,ParameterSetName='InclusiveDateRange')]
      [Parameter(Mandatory=$false,ParameterSetName='ExclusiveDateRange')]
      [ValidateSet("hour","day","week","month","quarter")]
      [string]$group_by
   )

   $oeAPIKey = (New-Object PSCredential "user",$ApiKey).GetNetworkCredential().Password
   $Credential = New-Object System.Management.Automation.PSCredential ($oeAPIKey, (new-object System.Security.SecureString))

   if($mpan)
   {
      $URL = Get-OctopusEnergyHelperBaseURL -endpoint elecmp
      $requestURL = "$URL$mpan/meters/$serial_number/consumption/"
   }
   else
   {
      $URL = Get-OctopusEnergyHelperBaseURL -endpoint gasmp
      $requestURL = "$URL$mprn/meters/$serial_number/consumption/"
   }

   $psParams = @{}
   $ParameterList = (Get-Command -Name $MyInvocation.InvocationName).Parameters
   $ParamsToIgnore = @("apikey","mpan","mprn","serial_number")
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
   if( $pscmdlet.ShouldProcess("Octopus Energy API", "Retrieve Consumption") )
   {
      $response = Get-OctopusEnergyHelperResponse -requestParams $requestParams
      Return $response
   }
}