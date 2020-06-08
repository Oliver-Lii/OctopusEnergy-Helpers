
<#
.SYNOPSIS
   Retrieves the meter point for a Octopus Energy electricity meter
.DESCRIPTION
   Returns the meter point for a Octopus Energy electricity meter
.PARAMETER APIKey
   The Octopus Energy API Key
.PARAMETER MPAN
   The MPAN of the electricity meter
.INPUTS
   None
.OUTPUTS
   Returns a PSCustomObject with details of the meter point
.EXAMPLE
   C:\PS>Get-OctopusEnergyHelperMeterPoint -MPAN 1234567890
   Retrieve meter point details for MPAN 1234567890
.LINK
   https://developer.octopus.energy/docs/api/#retrieve-a-meter-point
#>
function Get-OctopusEnergyHelperMeterPoint
{
   [CmdletBinding(SupportsShouldProcess=$true)]
   Param(
      [securestring]$APIKey=(Get-OctopusEnergyHelperAPIAuth),

      [ValidateNotNullOrEmpty()]
      [string]$MPAN = (Get-OctopusEnergyHelperConfig -property MPAN)
   )

   $oeAPIKey = (New-Object PSCredential "user",$APIKey).GetNetworkCredential().Password
   $Credential = New-Object System.Management.Automation.PSCredential ($oeAPIKey, (New-Object System.Security.SecureString))

   if($MPAN)
   {
      $URL = Get-OctopusEnergyHelperBaseURL -endpoint elecmp
      $requestURL = "$URL$MPAN/"
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
