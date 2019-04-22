<#
.Synopsis
   Sets the Octopus Energy API Key used by the module
.PARAMETER Credential
    Credential object containing the API Key in the username property
.INPUTS
   None
.EXAMPLE
   Set-OctopusEnergyHelperAPIAuth -Credential <Credential>
.FUNCTIONALITY
    Sets the Octopus Energy API Key used by the module

#>
function Set-OctopusEnergyHelperAPIAuth
{
    [CmdletBinding(PositionalBinding=$false,SupportsShouldProcess=$true)]
    Param(
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.PSCredential] $Credential
    )

    Try
    {
        New-Variable -Name OctopusEnergyHelperCredentials -Value $Credential -Scope Global -Force -ErrorAction Stop
    }
    Catch
    {
        Write-Error $_
        Return $false
    }

    Return $true
}

