
<#
.SYNOPSIS
   Removes the Octopus Energy Module API Key
.DESCRIPTION
   Removes the Octopus Energy API Key
.OUTPUTS
   Returns a Boolean value on the authentication removal operation
.EXAMPLE
   C:\PS>Remove-OctopusEnergyHelperAPIAuth
   Remove the StatusCake Authentication credential configured for the module

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