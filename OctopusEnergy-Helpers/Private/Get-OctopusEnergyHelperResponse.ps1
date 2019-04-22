<#
.Synopsis
   Collates the results from the responses
.PARAMETER requestParams
   Hashtable of parameters for Invoke-RestMethod
.INPUTS
   None
.OUTPUTS
   List containing all the results for a given request
.EXAMPLE
   Get-OctopusEnergyHelperResponse -requestParams $requestParams 
.FUNCTIONALITY
   Collates the results from the responses

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
         $response = Invoke-RestMethod -uri $response.next
      }
   }while($response.next)

   Return $oehlist
}