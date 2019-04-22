# Authentication

The following are the functions for the module to manage Octopus Energy API credentials used by the module.

### Remove-OctopusEnergyHelperAPIAuth
This cmdlet removes the OctopusEnergy API Authentication credentials returning true or false based on the result of removal operation.

```powershell
Remove-OctopusEnergyHelperAPIAuth
```

### Set-OctopusEnergyHelperAPIAuth
This cmdlet sets the OctopusEnergy API Authentication credentials for use by the other cmdlets

```powershell
$oeAPIKey = "APIKey"
$oeAPIKeySecString = ConvertTo-SecureString $oeAPIKey -AsPlainText -Force
$oeCredentials = New-Object System.Management.Automation.PSCredential ("APIKey", $oeAPIKey)
Set-OctopusEnergyHelperAPIAuth -Credentials $oeCredentials
```
### Test-OctopusEnergyHelperAPIAuth
This cmdlet tests for the presence of Octopus Energy API Authentication credentials

```powershell
Test-OctopusEnergyHelperAPIAuth
```

# Authors
- Oliver Li