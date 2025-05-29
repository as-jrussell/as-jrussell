#Shows Services that were created
Invoke-Command -ComputerName UNITRAC-WH017 -ScriptBlock {get-wmiobject win32_service|Select Name,StartName |where {$_.StartName -like "*@as.local" -or  $_.StartName -like "ELDREDGE_A\*" }}

#Show Scheduled Task

Get-ScheduledTaskInfo  -TaskName "Clean up Job"
Get-ScheduledTask -TaskName "Clean up Job"

#Validates the processor 
Get-WmiObject Win32_ComputerSystem | Select NumberOfProcessors,NumberOfLogicalProcessors

#Checks Memory

Foreach-Object {
  Get-CimInstance -Class Win32_ComputerSystem -ComputerName ::NAME:: |
  Select-Object PSComputerName, @{Name="Memory"; Expression={[math]::Round($_.TotalPhysicalMemory/1GB)}}
}



#Users
Invoke-Command -ComputerName OCR-SQLPRD-02 -ScriptBlock {Get-LocalGroupMember -Group "Administrators"| select Name ,ObjectClass}
Get-LocalGroupMember  -Group "Users"| select Name ,ObjectClass


#Hard Drive
get-wmiobject -class win32_logicaldisk -Filter "DriveType =3"  |  select SystemName, DriveType, name, @{Name="SizeGB";Expression={$_.Size/1GB -as [int]}}


Get-WmiObject Win32_LogicalDisk | Where-Object { $_.DriveType -eq "3" } | Select-Object SystemName,
    @{ Name = "Drive" ; Expression = { ( $_.DeviceID ) } },
    @{ Name = "Size (GB)" ; Expression = {"{0:N1}" -f ( $_.Size / 1gb)}},
    @{ Name = "FreeSpace (GB)" ; Expression = {"{0:N1}" -f ( $_.Freespace / 1gb ) } },
    @{ Name = "PercentFree" ; Expression = {"{0:P1}" -f ( $_.FreeSpace / $_.Size ) } } |
        Format-Table -AutoSize | Out-String

<#
Drive type uses a numerical code:

0 -- Unknown
1 -- No Root directory
2 -- Removable Disk
3 -- Local Disk
4 -- Network Drive
5 -- Compact Disc
6 -- Ram Disk
#>

