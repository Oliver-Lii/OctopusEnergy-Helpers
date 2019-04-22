
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
   Param()
    Try
    {
        Remove-Variable -Name OctopusEnergyHelperCredentials -Scope Global -ErrorAction Stop
    }
    Catch
    {
        Write-Error $_
        Return $false
    }

    Return $true
}