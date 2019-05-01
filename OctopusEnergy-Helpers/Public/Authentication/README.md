# Authentication

The following are the functions for the module to manage Octopus Energy API key used by the module.

### Remove-OctopusEnergyHelperAPIAuth
This cmdlet removes the OctopusEnergy API key file returning true or false based on the result of removal operation.

```powershell
Remove-OctopusEnergyHelperAPIAuth
```

### Set-OctopusEnergyHelperAPIAuth
This cmdlet sets the OctopusEnergy API key file for use by the other cmdlets

```powershell
$apiKey = Read-Host "Enter the Octopus Energy API key" -AsSecureString
Set-OctopusEnergyHelperAPIAuth -ApiKey $apiKey
```

### Test-OctopusEnergyHelperAPIAuth
This cmdlet tests for the presence of Octopus Energy API key file

```powershell
Test-OctopusEnergyHelperAPIAuth
```

# Authors
- Oliver Li