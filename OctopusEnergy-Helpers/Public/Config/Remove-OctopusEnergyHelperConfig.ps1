
<#
.SYNOPSIS
   Removes the Octopus Energy Config file
.DESCRIPTION
   Removes the Octopus Energy Config file
.EXAMPLE
   C:\PS>Remove-OctopusEnergyHelperConfig
   Remove the Octopus Energy Helper configuration file
.OUTPUTS
   Returns a Boolean value on the authentication removal operation
#>
function Remove-OctopusEnergyHelperConfig
{
   [CmdletBinding(SupportsShouldProcess=$true)]
   [OutputType([System.Boolean])]
   Param()
    Try
    {
         $moduleName = (Get-Command $MyInvocation.MyCommand.Name).Source
         Remove-Item "$env:userprofile\$moduleName\$moduleName-Config.xml" -Force
    }
    Catch
    {
        Write-Error $_
        Return $false
    }

    Return $true
}