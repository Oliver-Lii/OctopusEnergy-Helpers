# EnergyProducts

The following are the module functions which work with the product API endpoint

### Find-OctopusEnergyHelperAgileRate
This cmdlet can be used to retrieve a desired target rate over a specified duration. E.g. Lowest rate in a continuous two hour block.

```powershell
Find-OctopusEnergyHelperAgileRate -mpan 1234567890123 -duration (New-TimeSpan -hours 2) -target "lowest"
```
### Get-OctopusEnergyHelperEnergyProduct
This cmdlet can be used to retrieve the details for a specific energy product

```powershell
Get-OctopusEnergyHelperEnergyProduct -product_code "AGILE-18-02-21"
```
### Get-OctopusEnergyHelperEnergyProductList
This cmdlet can be used to retrieve list of available energy products

```powershell
Get-OctopusEnergyHelperEnergyProductList
```

### Get-OctopusEnergyHelperEnergyProductTariff
This cmdlet can be used to retrieve the tariff details for a specific energy product

```powershell
Get-OctopusEnergyHelperEnergyProductTariff -tariff_code "E-1R-AGILE-18-02-21-A"
```

# Authors
- Oliver Li