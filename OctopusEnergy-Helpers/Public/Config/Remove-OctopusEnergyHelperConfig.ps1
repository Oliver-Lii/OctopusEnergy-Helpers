
<#
.Synopsis
   Removes the Octopus Energy Config file
.EXAMPLE
   Remove-OctopusEnergyHelperConfig
.OUTPUTS
   Returns a Boolean value on the authentication removal operation
.FUNCTIONALITY
   Removes the Octopus Energy Config file

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