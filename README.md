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
