<#
.Synopsis
   Find the desired target rate for the specified period of time under the Agile Octopus tariff
.PARAMETER Credential
   Credentials for Octopus Energy API
.PARAMETER timespan
   The period of time which should be tracked
.PARAMETER target
   Value used to specify if the highest or lowest value should be found
.PARAMETER gsp
   The GSP of the electricity meter point
.PARAMETER mpan
   The mpan of the electricity meter
.INPUTS
   None
.OUTPUTS
   Returns a list of rates which meet the desired duration
.EXAMPLE
   Get-OctopusEnergyHelperEnergyProductTariff -duration (New-TimeSpan -hours 2 -minutes 30) -target "lowest" -mpan 123456789012
.FUNCTIONALITY
   Retrieves rates which meet the target for the specified duration. E.g Find the time period which has the lowest total rate over a 2 1/2 hours period
#>

function Find-OctopusEnergyHelperAgileRate
{
   [CmdletBinding(SupportsShouldProcess=$true)]
   Param(
      [System.Management.Automation.PSCredential]$Credential=(Get-OctopusEnergyHelperAPIAuth),

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

      [Parameter(Mandatory=$true,ParameterSetName='MPAN')]
      [ValidateNotNullOrEmpty()]
      [string]$mpan
   )

   if($mpan)
   {
      $meterPoint = Get-OctopusEnergyHelperMeterPoint -mpan $mpan
      $gsp = $meterPoint.gsp -replace "_",""
   }

   $tariffs = Get-OctopusEnergyHelperEnergyProductTariff -tariff_code "E-1R-AGILE-18-02-21-$gsp" -period_from $((Get-Date))
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
