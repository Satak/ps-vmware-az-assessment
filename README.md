# PS VMware Azure Assessment Module

Convert VMware export VM data to azure Migrate CSV import format

## Install

```powershell
Install-Module -Name ps-vmware-az-assessment-Force -Confirm:$False
```

## Usage

```powershell
 Import-Module -Name ps-vmware-az-assessment
 Import-Csv '.\data\Vmware_export.csv' | ConvertTo-AzMigrate | Export-Csv '.\data\vms.csv' -UseQuotes AsNeeded
```

## Azure Migrate Project

Create resource group and project

```powershell
New-AzResourceGroup -Name 'rg-migrate' -Location 'westeurope'
New-AzMigrateProject -Name 'migr-test' -ResourceGroupName 'rg-migrate' -Location 'westeurope'
```

import csv file from azure portal
