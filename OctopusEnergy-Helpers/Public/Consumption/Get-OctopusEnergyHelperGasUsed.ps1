<#
.SYNOPSIS
   Retrieves the consumption for a smart gas meter
.DESCRIPTION
   Returns the consumption for a smart gas meter. No parameters required if configuration has been set via the Set-OctopusEnergyHelperConfig command
.PARAMETER APIKey
   The Octopus Energy API Key
.PARAMETER MPRN
   The MPRN of the gas meter
.PARAMETER SerialNumber
   The gas meter's serial number
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
   C:\PS>Get-OctopusEnergyHelperGasUsed -MPRN 1234567890 -SerialNumber A1B2C3D4
   Retrieve the consumption details for MPRN 1234567890 with serial number A1B2C3D4
.EXAMPLE
   C:\PS>Get-OctopusEnergyHelperGasUsed
   Retrieve the electricity consumption details using details configured with Set-OctopusEnergyHelperConfig
.LINK
   https://developer.octopus.energy/docs/api/#consumption
#>
function Get-OctopusEnergyHelperGasUsed
{
   [CmdletBinding(SupportsShouldProcess=$true)]
   Param(
      [ValidateNotNullOrEmpty()]
      [securestring]$ApiKey=(Get-OctopusEnergyHelperAPIAuth),

      [ValidateNotNullOrEmpty()]
      [string]$mprn=(Get-OctopusEnergyHelperConfig -property mprn),

      [ValidateNotNullOrEmpty()]
      [Alias("serial_number")]
      [string]$SerialNumber=(Get-OctopusEnergyHelperConfig -property gas_serial_number),

      [Parameter(ParameterSetName='InclusiveDateRange')]
      [Parameter(Mandatory=$true,ParameterSetName='ExclusiveDateRange')]
      [Alias("period_from")]
      [datetime]$PeriodFrom,

      [Parameter(Mandatory=$true,ParameterSetName='ExclusiveDateRange')]
      [Alias("period_to")]
      [datetime]$PeriodTo,

      [ValidateRange(1,25000)]
      [Alias("page_size")]
      [int]$PageSize=1500,

      [ValidateSet("period","-period")]
      [Alias("order_by")]
      [string]$OrderBy,

      [ValidateSet("hour","day","week","month","quarter")]
      [Alias("group_by")]
      [string]$GroupBy
   )

   $allParameterValues = $MyInvocation | Get-OctopusEnergyHelperParameterValue -BoundParameters $PSBoundParameters

   if( $pscmdlet.ShouldProcess("Octopus Energy API", "Retrieve Gas Consumption") )
   {
      $response = Get-OctopusEnergyHelperConsumption @allParameterValues
      Return $response
   }
}