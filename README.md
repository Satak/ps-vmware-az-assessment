# PS VMware Azure Assessment Module

Convert VMware export VM data to azure Migrate CSV import format

```powershell
 Import-Csv '.\data\Vmware_export.csv' | ConvertTo-AzMigrate | Export-Csv '.\data\vms.csv' -UseQuotes AsNeeded
```
