# EnergyProducts

The following are the module functions which work with the product API endpoint

### ConvertTo-OctopusEnergyHelperRateHTML
This cmdlet can be used create a HTML page with the supplied rates. A rate to be highlighted on the HTML page can be specified along with the desired set of values to highlight.

```powershell
$agileRates = Get-OctopusEnergyHelperEnergyProductTariff -TariffCode "E-1R-AGILE-18-02-21-A" -PeriodFrom (Get-Date)
($agileRates).'standard-unit-rates' | ConvertTo-OctopusEnergyHelperRateHTML -TargetRate 11 -Highlight Lower | Out-File .\AgileRate.html
```

### Find-OctopusEnergyHelperAgileRate
This cmdlet can be used to retrieve a desired target rate over a specified duration. E.g. Lowest rate in a continuous two hour block.

```powershell
Find-OctopusEnergyHelperAgileRate -MPAN 1234567890123 -Duration (New-TimeSpan -hours 2) -target "lowest"
```
### Get-OctopusEnergyHelperEnergyProduct
This cmdlet can be used to retrieve the details for a specific energy product

```powershell
Get-OctopusEnergyHelperEnergyProduct -ProductCode "AGILE-18-02-21"

code                                : AGILE-18-02-21
full_name                           : Agile Octopus February 2018
display_name                        : Agile Octopus
description                         :
is_variable                         : True
is_green                            : True
is_tracker                          : False
is_prepay                           : False
is_business                         : False
is_restricted                       : False
term                                : 12
available_from                      : 2017-01-01T00:00:00Z
available_to                        :
tariffs_active_at                   : 2020-06-08T18:42:48.463789Z
single_register_electricity_tariffs : @{_A=; _B=; _C=; _D=; _E=; _F=; _G=; _H=; _J=; _K=; _L=; _M=; _N=; _P=}
dual_register_electricity_tariffs   :
single_register_gas_tariffs         :
sample_quotes                       : @{_A=; _B=; _C=; _D=; _E=; _F=; _G=; _H=; _J=; _K=; _L=; _M=; _N=; _P=}
sample_consumption                  : @{electricity_single_rate=; electricity_dual_rate=; dual_fuel_single_rate=; dual_fuel_dual_rate=}
links                               : {@{href=https://api.octopus.energy/v1/products/AGILE-18-02-21/; method=GET; rel=self}}
brand                               : OCTOPUS_ENERGY
```
### Get-OctopusEnergyHelperEnergyProductList
This cmdlet can be used to retrieve list of available energy products

```powershell
# Retrieve the product list information for Agile Octopus from the product list
Get-OctopusEnergyHelperEnergyProductList | Where-Object {$_.display_name -eq "Agile Octopus"}

code           : AGILE-18-02-21
direction      : IMPORT
full_name      : Agile Octopus February 2018
display_name   : Agile Octopus
description    :
is_variable    : True
is_green       : True
is_tracker     : False
is_prepay      : False
is_business    : False
is_restricted  : False
term           : 12
available_from : 2017-01-01T00:00:00Z
available_to   :
links          : {@{href=https://api.octopus.energy/v1/products/AGILE-18-02-21/; method=GET; rel=self}}
brand          : OCTOPUS_ENERGY
```

### Get-OctopusEnergyHelperEnergyProductTariff
This cmdlet can be used to retrieve the tariff details for a specific energy product

```powershell
Get-OctopusEnergyHelperEnergyProductTariff -TariffCode "E-1R-AGILE-18-02-21-A"

ProductCode         : AGILE-18-02-21
TariffCode          : E-1R-AGILE-18-02-21-C
FuelType            : electricity
standing-charges    : @{value_exc_vat=20.0; value_inc_vat=21.0; valid_from=2017-01-01T00:00:00Z; valid_to=}
standard-unit-rates : {@{value_exc_vat=4.8; value_inc_vat=5.04; valid_from=2020-06-09T21:30:00Z; valid_to=2020-06-09T22:00:00Z}, @{value_exc_vat=5.6; value_inc_vat=5.88;
                      valid_from=2020-06-09T21:00:00Z; valid_to=2020-06-09T21:30:00Z}, @{value_exc_vat=5.6; value_inc_vat=5.88; valid_from=2020-06-09T20:30:00Z;
                      valid_to=2020-06-09T21:00:00Z}, @{value_exc_vat=6.64; value_inc_vat=6.972; valid_from=2020-06-09T20:00:00Z; valid_to=2020-06-09T20:30:00Z}...}
```

# Authors
- Oliver Li