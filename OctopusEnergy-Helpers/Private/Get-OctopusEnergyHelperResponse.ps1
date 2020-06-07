<#
.SYNOPSIS
   Collates the results from the responses
.DESCRIPTION
   Hashtable of parameters to be used when calling Invoke-RestMethod
.PARAMETER RequestParams
   Hashtable of parameters for Invoke-RestMethod
.INPUTS
   None
.OUTPUTS
   List containing all the results for a given request
.EXAMPLE
   C:\>Get-OctopusEnergyHelperResponse -requestParams $requestParams
   Retrieve the Octopus Energy API response

#>
Function Get-OctopusEnergyHelperResponse
{
   Param(
      [hashtable]$requestParams
   )

   $oehlist = [System.Collections.Generic.List[PSObject]]::new()
   $response = Invoke-RestMethod @requestParams

   do
   {
      if(! $response.Results)
      {
         $oehlist = $response
      }
      else
      {
         $response.Results | ForEach-Object {$oehlist.Add($_)}
         $percent = ($oehlist.Count / $response.count) * 100
         Write-Progress -Activity "Retrieving results" -Status "Collected $($oehlist.Count) out of $($response.count) results" -PercentComplete $percent
      }
      if($response.next)
      {
         $response = Invoke-RestMethod -uri $response.next -Credential $requestParams["Credential"] -UseBasicParsing
      }
   }while($response.next)

   Return $oehlist
}