<#
.Synopsis
    Sets the Octopus Energy API Key used by the module.
.PARAMETER BaseURL
    Base URL for Octopus Energy API
.INPUTS
    None
.OUTPUTS
    None
.EXAMPLE
    Set-OctopusEnergyHelperBaseURL -BaseURL "https://api.octopus.energy"   
.FUNCTIONALITY
    Sets the Octopus Energy API Key used by the module
   
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
