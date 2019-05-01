# OctopusEnergy-Helpers [![Build status](https://ci.appveyor.com/api/projects/status/8pysopaejmlno2ly/branch/master?svg=true)](https://ci.appveyor.com/project/Oliver-Lii/OctopusEnergy-Helpers/branch/master) [![GitHub license](https://img.shields.io/github/license/Oliver-Lii/OctopusEnergy-Helpers.svg)](LICENSE) [![PowerShell Gallery](https://img.shields.io/powershellgallery/v/OctopusEnergy-Helpers.svg)]()


This module was written to assist working with [Octopus Energy API](https://developer.octopus.energy/docs/api/ "Octopus Energy API Docs") endpoints available to customers. Additional functionality may be added later and I will use this as a generic module to house Powershell functions specific to working with Octopus Energy API.

**DISCLAIMER:** Neither this module, nor its creator are in any way affiliated with Octopus Energy.


# Usage
This module can be installed from the PowerShell Gallery using the command below.
```powershell
Install-Module OctopusEnergy-Helpers -Repository PSGallery
```

## Example

 The following illustrates how to set up the credentials and retrieve details for products and tariffs

```powershell
# Configure Octopus Energy API key
$apiKey = Read-Host "Enter the Octopus Energy API key" -AsSecureString
Set-OctopusEnergyHelperAPIAuth -ApiKey $apiKey

# Retrieve the list of active products
$oeProductList = Get-OctopusEnergyHelperEnergyProductList

# Retrieve the details of a product
$ProductDetail = Get-OctopusEnergyHelperEnergyProduct -product_code "AGILE-18-02-21"

# On the Agile Octopus tariff find the cheapest time for 2 hours of continous import using the MPAN number
$times = Find-OctopusEnergyHelperAgileRate -duration $(New-TimeSpan -hours 2) -mpan "123456789012"

# On the Agile Octopus tariff find all the times where the rate is below average
$tariffs = Get-OctopusEnergyHelperEnergyProductTariff -tariff_code "E-1R-AGILE-18-02-21-A"
$average = ($tariffs.'standard-unit-rates' | Measure-object -Property value_exc_vat -Average).Average
$belowAverage = $tariffs.'standard-unit-rates' | Where-Object {$_.value_exc_vat -le $average}
```

## Functions

Below is a list of the available functions in the module

[Authentication](https://github.com/Oliver-Lii/octopusenergy-helpers/tree/master/OctopusEnergy-Helpers/Public/Authentication "Octopus Energy Authentication")
*  Remove-OctopusEnergyHelperAPIAuth
*  Set-OctopusEnergyHelperAPIAuth
*  Test-StatusCakeHelperAPIAuthSet

[BaseURL](https://github.com/Oliver-Lii/octopusenergy-helpers/tree/master/OctopusEnergy-Helpers/Public/BaseURL "Octopus Energy Base URL")
*  Get-OctopusEnergyHelperBaseURL
*  Remove-OctopusEnergyHelperBaseURL
*  Set-OctopusEnergyHelperBaseURL
*  Test-OctopusEnergyHelperBaseURLSet

[Consumption](https://github.com/Oliver-Lii/octopusenergy-helpers/tree/master/OctopusEnergy-Helpers/Public/Consumption "Octopus Energy Consumption")
*  Get-OctopusEnergyHelperConsumption

[EnergyProducts](https://github.com/Oliver-Lii/octopusenergy-helpers/tree/master/OctopusEnergy-Helpers/Public/EnergyProducts "Octopus Energy Products")
*  Find-OctopusEnergyHelperAgileRate
*  Get-OctopusEnergyHelperEnergyProduct
*  Get-OctopusEnergyHelperEnergyProductList
*  Get-OctopusEnergyHelperEnergyProductTariff

[MeterPoint](https://github.com/Oliver-Lii/octopusenergy-helpers/tree/master/OctopusEnergy-Helpers/Public/MeterPoint "Octopus Energy Meter Points")
*  Get-OctopusEnergyHelperMeterPoint

## Tests

This module comes with [Pester](https://github.com/pester/Pester/) tests for unit testing. 

# Authors
- Oliver Li