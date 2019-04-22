
<#
.Synopsis
   Retrieves the meter point for a Octopus Energy electricity meter
.PARAMETER mpan
   The mpan of the electricity meter
.INPUTS
   None
.OUTPUTS
   Returns a PSCustomObject with details of the meter point
.EXAMPLE
   Get-OctopusEnergyHelperMeterPoint -mpan 1234567890   
.FUNCTIONALITY
   Returns the meter point for a Octopus Energy electricity meter

#>
function Get-OctopusEnergyHelperMeterPoint
{
   [CmdletBinding(SupportsShouldProcess=$true)]
   Param(
      [System.Management.Automation.PSCredential]$Credential=(Get-OctopusEnergyHelperAPIAuth),

      [Parameter(Mandatory=$true)]
      [ValidateNotNullOrEmpty()]
      [string]$mpan
   )

   if($mpan)
   {
      $URL = Get-OctopusEnergyHelperBaseURL -endpoint elecmp
      $requestURL = "$URL$mpan/"
   }

   $requestParams = @{
      Credential = $Credential
      uri = $requestURL
      UseBasicParsing = $true
      method = "Get"
      ContentType = "application/x-www-form-urlencoded"
  }
   if( $pscmdlet.ShouldProcess("Octopus Energy API", "Retrieve MeterPoint") )
   {
      $response = Get-OctopusEnergyHelperResponse -requestParams $requestParams
      Return $response
   }
}
