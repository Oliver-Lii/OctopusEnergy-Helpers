# Config

The following are the functions for the module to manage Octopus Energy Helper config file used by the module.

### Get-OctopusEnergyHelperConfig
This cmdlet retrieves the specified Octopus Energy item of data for use by the other cmdlets

```powershell
Get-OctopusEnergyHelperConfig -type "mpan"
```

### Remove-OctopusEnergyHelperConfig
This cmdlet removes the Octopus Energy Helper Config file returning true or false based on the result of removal operation.

```powershell
Remove-OctopusEnergyHelperConfig
```

### Set-OctopusEnergyHelperConfig
This cmdlet sets the Octopus Energy Helper Config file for use by the other cmdlets

```powershell

Set-OctopusEnergyHelperConfig -mpan "123456789" -mprn "123456789" -elec_serial_number "E123456789" -gas_serial_number "G123456789"
```

### Test-OctopusEnergyHelperConfigSet
This cmdlet tests for the presence of Octopus Energy Helper Config file

```powershell
Test-OctopusEnergyHelperConfigSet
```

# Authors
- Oliver Li