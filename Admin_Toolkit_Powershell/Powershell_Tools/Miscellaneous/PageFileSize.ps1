Get-WmiObject -ComputerName Unitrac-DB01 Win32_PageFileusage | 
 Select-Object Name,AllocatedBaseSize,PeakUsage

