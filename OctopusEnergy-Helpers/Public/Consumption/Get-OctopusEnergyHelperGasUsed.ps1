<#
.SYNOPSIS
   Retrieves the consumption for a smart gas meter
.DESCRIPTION
   Returns the consumption for a smart gas meter. No parameters required if configuration has been set via the Set-OctopusEnergyHelperConfig command
.PARAMETER apikey
   The Octopus Energy API Key
.PARAMETER mprn
   The mprn of the gas meter
.PARAMETER serial_number
   The gas meter's serial number
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
   C:\PS>Get-OctopusEnergyHelperConsumption -mprn 1234567890 -serial_number A1B2C3D4
   Retrieve the consumption details for MPRN 1234567890 with serial number A1B2C3D4
.EXAMPLE
   C:\PS>Get-OctopusEnergyHelperGasUsed
   Retrieve the electricity consumption details using details configured with Set-OctopusEnergyHelperConfig
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
      [string]$serial_number=(Get-OctopusEnergyHelperConfig -property gas_serial_number),

      [Parameter(ParameterSetName='InclusiveDateRange')]
      [Parameter(Mandatory=$true,ParameterSetName='ExclusiveDateRange')]
      [datetime]$period_from,

      [Parameter(Mandatory=$true,ParameterSetName='ExclusiveDateRange')]
      [datetime]$period_to,

      [ValidateRange(1,25000)]
      [int]$page_size,

      [ValidateSet("period","-period")]
      [string]$order_by,

      [ValidateSet("hour","day","week","month","quarter")]
      [string]$group_by
   )

   foreach($param in $MyInvocation.MyCommand.Parameters.GetEnumerator())
   {
      $var = Get-Variable -Name $param.Key -ErrorAction SilentlyContinue
      if ( $var.value -and (! $PSBoundParameters.ContainsKey($var.Name)))
      {
         $PSBoundParameters.Add($param.Key,$var.value)
      }
   }

   if( $pscmdlet.ShouldProcess("Octopus Energy API", "Retrieve Gas Consumption") )
   {
      $response = Get-OctopusEnergyHelperConsumption @PSBoundParameters
      Return $response
   }
}