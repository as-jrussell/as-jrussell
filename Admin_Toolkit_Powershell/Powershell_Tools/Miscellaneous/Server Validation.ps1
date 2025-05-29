#Services
get-wmiobject win32_service| where {$_.StartName -like "*@as.local" -or  $_.StartName -like "ELDREDGE_A\*"}



#Scheduled Task

Get-ScheduledTaskInfo  -TaskName "Clean up Job"
Get-ScheduledTask -TaskName "Clean up Job"


 

#Accounts

Get-LocalGroupMember -Group "Administrators"

Get-LocalGroupMember  -Group "Remote Desktop Users"

Get-LocalGroupMember  -Group "Users"




#Memory Check


Get-CimInstance Win32_PhysicalMemory | Measure-Object -Property capacity -Sum | ForEach-Object {"{0:N2}" -f ([math]::round(($_.Sum / 1GB),2))}



#Processor Check

Get-WmiObject Win32_ComputerSystem | Select NumberOfProcessors,NumberOfLogicalProcessors



#Hard Drive

get-wmiobject -class win32_logicaldisk -Filter "DriveType =3"  |  select SystemName, DriveType, name, @{Name="SizeGB";Expression={$_.Size/1GB -as [int]}}






Invoke-Command -ComputerName utqa2-app3 -ScriptBlock {Get-ScheduledTask  -TaskName "Clean up Job"}
Invoke-Command -ComputerName utqa2-app3 -ScriptBlock {Get-ScheduledTaskInfo  -TaskName "Clean up Job"} 

Invoke-Command -ComputerName utqa2-app3 -ScriptBlock {get-wmiobject win32_service|Select Name,StartName |where {$_.StartName -like "*@as.local" -or  $_.StartName -like "ELDREDGE_A\*" }} 



Invoke-Command -ComputerName utqa2-app3 -ScriptBlock {Get-WmiObject Win32_ComputerSystem | Select NumberOfProcessors,NumberOfLogicalProcessors} 




Invoke-Command -ComputerName utqa2-app3 -ScriptBlock {Get-CimInstance Win32_PhysicalMemory | Measure-Object -Property capacity -Sum | Foreach {"{0:N2}" -f ([math]::round(($_.Sum / 1GB),2))}} 



Invoke-Command -ComputerName utqa2-app3 -ScriptBlock {Get-LocalGroupMember -Group "Administrators"} 




Invoke-Command -ComputerName utqa2-app3 -ScriptBlock {get-wmiobject -class win32_logicaldisk -Filter "DriveType <>5"|  select SystemName, DriveType,name, @{Name="SizeGB";Expression={$_.Size/1GB -as [int]}}}

