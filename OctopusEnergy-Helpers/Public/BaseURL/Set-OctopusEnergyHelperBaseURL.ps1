<#
.SYNOPSIS
    Sets the Octopus Energy URL used by the module.
.DESCRIPTION
    Sets the Octopus Energy BaseURL used by the module. The default is "https://api.octopus.energy".
.PARAMETER BaseURL
    Base URL for Octopus Energy API
.INPUTS
    None
.OUTPUTS
    None
.EXAMPLE
    C:\PS>Set-OctopusEnergyHelperBaseURL -BaseURL "https://api.octopus.energy"
    Configure the Octopus Energy Base URL to use "https://api.octopus.energy" as the base URL
#>
function Set-OctopusEnergyHelperBaseURL
{
    [CmdletBinding(SupportsShouldProcess=$true)]
    Param(
        [ValidateNotNullOrEmpty()]
        [String] $BaseURL = "https://api.octopus.energy"
    )
    Try
    {
        New-Variable -Name OctopusEnergyHelperBaseURL -Value $BaseURL -Scope Global -Force -ErrorAction Stop
    }
    Catch
    {
        Write-Error $_
        Return $false
    }

    Return $true
}
