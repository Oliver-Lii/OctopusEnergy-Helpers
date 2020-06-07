
<#
.SYNOPSIS
   Retrieves the meter point for a Octopus Energy electricity meter
.DESCRIPTION
   Returns the meter point for a Octopus Energy electricity meter
.PARAMETER apikey
   The Octopus Energy API Key
.PARAMETER mpan
   The mpan of the electricity meter
.INPUTS
   None
.OUTPUTS
   Returns a PSCustomObject with details of the meter point
.EXAMPLE
   C:\PS>Get-OctopusEnergyHelperMeterPoint -mpan 1234567890
   Retrieve meter point details for mpan 1234567890
#>
function Get-OctopusEnergyHelperMeterPoint
{
   [CmdletBinding(SupportsShouldProcess=$true)]
   Param(
      [securestring]$ApiKey=(Get-OctopusEnergyHelperAPIAuth),

      [ValidateNotNullOrEmpty()]
      [string]$mpan = (Get-OctopusEnergyHelperConfig -property mpan)
   )

   $oeAPIKey = (New-Object PSCredential "user",$ApiKey).GetNetworkCredential().Password
   $Credential = New-Object System.Management.Automation.PSCredential ($oeAPIKey, (New-Object System.Security.SecureString))

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
