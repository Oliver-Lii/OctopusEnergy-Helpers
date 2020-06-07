
<#
.SYNOPSIS
   Removes the Octopus Energy Base URL variable
.DESCRIPTION
   Removes the Octopus Energy Base URL variable
.EXAMPLE
   C:\PS>Remove-OctopusEnergyHelperBaseURL
   Remove the base URL configured for the module
.OUTPUTS
   Returns a Boolean value on the authentication removal operation
#>
function Remove-OctopusEnergyHelperBaseURL
{
   [CmdletBinding(SupportsShouldProcess=$true)]
   Param()
    Try
    {
        Remove-Variable -Name OctopusEnergyHelperBaseURL -Scope Global -ErrorAction Stop
    }
    Catch
    {
        Write-Error $_
        Return $false
    }

    Return $true
}