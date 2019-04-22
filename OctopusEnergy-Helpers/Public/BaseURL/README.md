# Base URL

The following are the functions for the module to manage Octopus Energy API base URL used by the module.

### Get-OctopusEnergyHelperBaseURL
This cmdlet retrieves the specified Octopus Energy API endpoint URL for use by the other cmdlets

```powershell
Get-OctopusEnergyHelperBaseURL -endpoint "products"
```

### Remove-OctopusEnergyHelperBaseURL
This cmdlet removes the Octopus Energy API Base URL returning true or false based on the result of removal operation.

```powershell
Remove-OctopusEnergyHelperBaseURL
```

### Set-OctopusEnergyHelperBaseURL
This cmdlet sets the Octopus Energy API base URL for use by the other cmdlets

```powershell
$octopusEnergyBaseURL = "https://api.octopus.energy"
Set-OctopusEnergyHelperBaseURL -BaseURL $octopusEnergyBaseURL
```

### Test-OctopusEnergyHelperBaseURL
This cmdlet tests for the presence of Octopus Energy API base URL

```powershell
Test-OctopusEnergyHelperBaseURL
```

# Authors
- Oliver Li