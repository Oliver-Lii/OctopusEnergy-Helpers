
<#
.Synopsis
   Removes the Octopus Energy Module API Key
.OUTPUTS
   Returns a Boolean value on the authentication removal operation
.EXAMPLE
   Remove-OctopusEnergyHelperAPIAuth
.FUNCTIONALITY
   Removes the Octopus Energy API Key

#>
function Remove-OctopusEnergyHelperAPIAuth
{
   [CmdletBinding(SupportsShouldProcess=$true)]
   [OutputType([System.Boolean])]
   Param()
    Try
    {
         $moduleName = (Get-Command $MyInvocation.MyCommand.Name).Source
         Remove-Item "$env:userprofile\$moduleName\$moduleName-Credentials.xml" -Force
    }
    Catch
    {
        Write-Error $_
        Return $false
    }

    Return $true
}