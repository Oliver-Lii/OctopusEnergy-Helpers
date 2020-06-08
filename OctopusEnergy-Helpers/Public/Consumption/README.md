# Consumption

The following are the module functions which work with the consumption API endpoint

### Get-OctopusEnergyHelperConsumption
This cmdlet retrieves the consumption for the specified smart gas or electricity meter

```powershell
# Electricity meter
Get-OctopusEnergyHelperConsumption -MPAN 1234567890123 -SerialNumber EM123456789
consumption interval_start            interval_end
----------- --------------            ------------
      0.000 2020-01-01T00:00:00+01:00 2020-01-01T00:30:00+01:00
      0.000 2020-01-01T23:30:00+01:00 2020-01-01T00:00:00+01:00
      0.000 2020-01-02T23:00:00+01:00 2020-01-02T23:30:00+01:00
      0.000 2020-01-02T22:30:00+01:00 2020-01-02T23:00:00+01:00
      0.000 2020-01-02T22:00:00+01:00 2020-01-02T22:30:00+01:00
      0.000 2020-01-02T21:30:00+01:00 2020-01-02T22:00:00+01:00
      0.000 2020-01-02T21:00:00+01:00 2020-01-02T21:30:00+01:00
      0.000 2020-01-02T20:30:00+01:00 2020-01-02T21:00:00+01:00
      0.000 2020-01-02T20:00:00+01:00 2020-01-02T20:30:00+01:00
      0.000 2020-01-02T19:30:00+01:00 2020-01-02T20:00:00+01:00
      0.000 2020-01-02T19:00:00+01:00 2020-01-02T19:30:00+01:00

# If configuration has been set the following function can be called with no parameters
Get-OctopusEnergyHelperElectricityUsed

# Gas meter
Get-OctopusEnergyHelperConsumption -MPRN 1234567890123 -SerialNumber GM123456789
consumption interval_start            interval_end
----------- --------------            ------------
      0.000 2020-01-01T00:00:00+01:00 2020-01-01T00:30:00+01:00
      0.000 2020-01-01T23:30:00+01:00 2020-01-01T00:00:00+01:00
      0.000 2020-01-02T23:00:00+01:00 2020-01-02T23:30:00+01:00
      0.000 2020-01-02T22:30:00+01:00 2020-01-02T23:00:00+01:00
      0.000 2020-01-02T22:00:00+01:00 2020-01-02T22:30:00+01:00
      0.000 2020-01-02T21:30:00+01:00 2020-01-02T22:00:00+01:00
      0.000 2020-01-02T21:00:00+01:00 2020-01-02T21:30:00+01:00
      0.000 2020-01-02T20:30:00+01:00 2020-01-02T21:00:00+01:00
      0.000 2020-01-02T20:00:00+01:00 2020-01-02T20:30:00+01:00
      0.000 2020-01-02T19:30:00+01:00 2020-01-02T20:00:00+01:00
      0.000 2020-01-02T19:00:00+01:00 2020-01-02T19:30:00+01:00

# If configuration has been set the following function can be called with no parameters
Get-OctopusEnergyHelperGasUsed
```

# Authors
- Oliver Li