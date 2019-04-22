# Consumption

The following are the module functions which work with the consumption API endpoint

### Get-OctopusEnergyHelperConsumption
This cmdlet retrieves the consumption for the specified smart gas or electricity meter

```powershell
# Electricity meter
Get-OctopusEnergyHelperConsumption -mpan 1234567890123 -serial_number EM123456789

# Gas meter
Get-OctopusEnergyHelperConsumption -mprn 1234567890123 -serial_number GM123456789
```

# Authors
- Oliver Li