<#
.SYNOPSIS
   Find the desired target rate for the specified period of time under the Agile Octopus tariff
.DESCRIPTION
   Retrieves Agile Octopus rates which meet the target for the specified duration. E.g Find the time period which has the lowest total rate over a 2 1/2 hours period.
.PARAMETER apikey
   The Octopus Energy API Key
.PARAMETER timespan
   The period of time which should be tracked
.PARAMETER target
   Value used to specify if the highest or lowest value should be found
.PARAMETER gsp
   The Grid Supply Point (GSP) of the electricity meter
.PARAMETER mpan
   The mpan of the electricity meter
.PARAMETER period_from
   Search through rates from the given datetime (inclusive).
.PARAMETER period_to
   Search through rates to the given datetime (exclusive).
.INPUTS
   None
.OUTPUTS
   Returns a list of rates which meet the desired duration
.EXAMPLE
   C:\PS>Find-OctopusEnergyHelperAgileRate -duration (New-TimeSpan -hours 2 -minutes 30) -target "lowest" -mpan 123456789012
   Find the time period which has the lowest total rate for a 2 1/2 hour period from the current time
.EXAMPLE
   C:\PS>Find-OctopusEnergyHelperAgileRate -duration (New-TimeSpan -hours 2 -minutes 30) -target "highest" -gsp A
   Find the time period which has the highest total rate for a 2 1/2 hour period from the current time for Grid Supply Point A
.EXAMPLE
   C:\PS>$fromDate = Get-Date 21:00
   C:\PS>Find-OctopusEnergyHelperAgileRate -duration (New-TimeSpan -hours 2 -minutes 30) -target "lowest" -gsp A -period_from $fromDate
   Find the time period which has the lowest total rate for a 2 1/2 hour period starting from today at 21:00
#>

function Find-OctopusEnergyHelperAgileRate
{
   [CmdletBinding(SupportsShouldProcess=$true,DefaultParameterSetName='MPAN')]
   [OutputType([System.Collections.Generic.List[PSObject]])]
   Param(
      [securestring]$ApiKey=(Get-OctopusEnergyHelperAPIAuth),

      [Parameter(Mandatory=$true,ParameterSetName='GSPCode')]
      [Parameter(Mandatory=$true,ParameterSetName='MPAN')]
      [timespan]$duration,

      [Parameter(ParameterSetName='GSPCode')]
      [Parameter(ParameterSetName='MPAN')]
      [ValidateSet("lowest","highest")]
      [string]$target="lowest",

      [Parameter(Mandatory=$true,ParameterSetName='GSPCode')]
      [ValidateSet("A","B","C","D","E","F","G","H","J","K","L","M","N","P")]
      [string]$gsp,

      [Parameter(Mandatory=$false,ParameterSetName='MPAN')]
      [ValidateNotNullOrEmpty()]
      [string]$mpan = (Get-OctopusEnergyHelperConfig -property mpan),

      [Parameter(ParameterSetName='GSPCode')]
      [Parameter(ParameterSetName='MPAN')]
      [datetime]$period_from = $((Get-Date)),

      [Parameter(ParameterSetName='GSPCode')]
      [Parameter(ParameterSetName='MPAN')]
      [datetime]$period_to
   )

   if($mpan)
   {
      if( $pscmdlet.ShouldProcess("Octopus Energy API", "Retrieve Meter Point Information") )
      {
         $meterPoint = Get-OctopusEnergyHelperMeterPoint -mpan $mpan -ApiKey $ApiKey
      }
      $gsp = $meterPoint.gsp -replace "_",""
   }

   $tariffParams = @{
      ApiKey = $ApiKey
      tariff_code = "E-1R-AGILE-18-02-21-$gsp"
      period_from = $period_from
   }

   if($period_to){$tariffParams.Add("period_to",$period_to)}

   if( $pscmdlet.ShouldProcess("Octopus Energy API", "Retrieve Agile Octopus Tariff Data") )
   {
      $tariffs = Get-OctopusEnergyHelperEnergyProductTariff @tariffParams
   }
   $rates= $tariffs.'standard-unit-rates'

   $dataPoints = [int]$duration.TotalHours * 2
   If([int]$dataPoints -gt $rates.count){Throw "Duration greater than the number of available rates"}
   $desiredRange = [System.Collections.Generic.List[PSObject]]::new($dataPoints)
   $sum = ($rates | Measure-Object -Property "value_exc_vat" -Sum).Sum
   If($target -eq "highest"){$sum=0}

   for(($startMarker = 0),($endMarker = $dataPoints -1) ; $endMarker -lt $rates.Count ;($startMarker++), ($endMarker++))
   {
      $rangeMeasure = $rates[$startMarker..$endMarker] | Measure-Object -Property "value_exc_vat" -Sum
      Switch($target)
      {
         "lowest" {
            If($rangeMeasure.Sum -lt $sum)
            {
               $sum = $rangeMeasure.Sum
               $desiredRange = $rates[$startMarker..$endMarker]
            }
         }
         "highest" {
            If($rangeMeasure.Sum -gt $sum)
            {
               $sum = $rangeMeasure.Sum
               $desiredRange = $rates[$startMarker..$endMarker]
            }
         }
      }
   }
   Return $desiredRange
}
