class VirtualMachine {
  #region params
  [string]$Name
  [string]$IPAddress
  [string]$Cores
  [string]$Memory
  [string]$OSName
  [string]$OSVersion
  [string]$OSArchitecture
  [string]$CPUUtilizationPercentage
  [string]$MemoryUtilizationPercentage
  [string]$NetworkAdapters
  [string]$NetworkInThroughput
  [string]$NetworkOutThroughput
  [string]$BootType
  [string]$NumberOfDisks
  [string]$Disk1Size
  [string]$Disk1ReadThroughput
  [string]$Disk1WriteThroughput
  [string]$Disk1ReadOPS
  [string]$Disk1WriteOPS
  #endregion

  VirtualMachine(
    [string]$Name,
    [string]$Cores,
    [string]$Memory,
    [string]$OSName
  ) {
    $this.Name = $Name
    $this.Cores = $Cores
    $this.Memory = $Memory
    $this.OSName = $OSName
  }
  [PSCustomObject]AsCSVData() {
    return [PSCustomObject]@{
      '*Server name'                             = $this.Name
      'IP addresses'                             = $this.IPAddress
      '*Cores'                                   = $this.Cores
      '*Memory (In MB)'                          = $this.Memory
      '*OS name'                                 = $this.OSName
      'OS version'                               = $this.OSVersion
      'OS architecture'                          = $this.OSArchitecture
      'CPU utilization percentage'               = $this.CPUUtilizationPercentage
      'Memory utilization percentage'            = $this.MemoryUtilizationPercentage
      'Network adapters'                         = $this.NetworkAdapters
      'Network In throughput'                    = $this.NetworkInThroughput
      'Network Out throughput'                   = $this.NetworkOutThroughput
      'Boot type'                                = $this.BootType
      'Number of disks'                          = $this.NumberOfDisks
      'Disk 1 size (In GB)'                      = $this.Disk1Size
      'Disk 1 read throughput (MB per second)'   = $this.Disk1ReadThroughput
      'Disk 1 write throughput (MB per second)'  = $this.Disk1WriteThroughput
      'Disk 1 read ops (operations per second)'  = $this.Disk1ReadOPS
      'Disk 1 write ops (operations per second)' = $this.Disk1WriteOPS
    }
  }
}

function ConvertTo-AzMigrate {
  <#
    .SYNOPSIS
        Convert to Azure Migrate CSV import data object
    .EXAMPLE
        ConvertTo-AzMigrate
    .PARAMETER VMwareVMObject
        VMware data object
    .PARAMETER ObfuscateNames
        Make VM names anonymous
  #>
  [CmdletBinding()]
  param (
    [Parameter(Mandatory, ValueFromPipeline)]
    [object[]]$VMwareVMObject,

    [Parameter()]
    [switch]$ObfuscateNames
  )

  process {
    foreach ($vm in $VMwareVMObject) {
      $name = $vm.'DNS Name' ? $vm.'DNS Name' : $vm.Name

      if ($ObfuscateNames.IsPresent) {
        $name = $name.split('.')[0].Replace($name.split('.')[0].Substring(0, 3), 'example') + '.example.local'
      }

      [int]$memory = $vm.'Memory Size'.replace(' ', '') / 1mb
      [int]$diskSize = $vm.'Used Space'.replace(' ', '') / 1gb

      $ipv4, $ipv6 = $vm.'IP Address'.split(', ')
      # $ips = "$ipv4;$ipv6"

      $vmObject = [VirtualMachine]::new($name, $vm.CPUs, $memory, $vm.'Guest OS')

      $vmObject.IPAddress = $ipv4
      $vmObject.NumberOfDisks = 1
      $vmObject.Disk1Size = $diskSize

      $vmObject.AsCSVData()
    }
  }
}
