
<#
.Synopsis
   Removes the Octopus Energy Base URL variable
.EXAMPLE
   Remove-OctopusEnergyHelperBaseURL
.OUTPUTS
   Returns a Boolean value on the authentication removal operation
.FUNCTIONALITY
   Removes the Octopus EnergyBase URL variable

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