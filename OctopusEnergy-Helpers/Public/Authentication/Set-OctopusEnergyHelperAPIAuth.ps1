<#
.SYNOPSIS
    Sets the Octopus Energy API Key used by the module
.DESCRIPTION
    Sets the Octopus Energy API Key used by the module
.PARAMETER APIKey
    SecureString containing the API Key
.INPUTS
    None
.EXAMPLE
    C:\PS>Set-OctopusEnergyHelperAPIAuth -APIKey $SecureStringOctopusEnergyAPIKey
    Set the API authentication credential file
#>
function Set-OctopusEnergyHelperAPIAuth
{
    [CmdletBinding(PositionalBinding=$false,SupportsShouldProcess=$true)]
    [OutputType([System.Boolean])]
    Param(
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [securestring] $APIKey
    )

    Try
    {
        $moduleName = (Get-Command $MyInvocation.MyCommand.Name).Source
        If(! (Test-Path "$env:userprofile\$moduleName\"))
        {
            New-Item "$env:userprofile\$moduleName" -ItemType Directory | Out-Null
        }
        $ApiKey | Export-CliXml -Path "$env:userprofile\$moduleName\$moduleName-Credentials.xml"
    }
    Catch
    {
        Write-Error $_
        Return $false
    }

    Return $true
}
