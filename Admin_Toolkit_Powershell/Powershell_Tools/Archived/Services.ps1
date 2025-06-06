﻿#################################
## done with windows services
## not sure why were checking status now since we know they are off... should we give a prompt to start them here?
Start-Transcript -Path "C:\temp\Production\Services.txt"

 # roll through each server and get the status of all windows services included in the list
$serverList = (
"Unitrac-APP01",
"Unitrac-APP02",
"Unitrac-WH01",
"Unitrac-WH03",
"Unitrac-WH04",
"Unitrac-WH05",
"Unitrac-WH06",
"Unitrac-WH07",
"Unitrac-WH08",
"Unitrac-WH09",
"Unitrac-WH10",
"Unitrac-WH11",
"Unitrac-WH12",
"Unitrac-WH13",
"Unitrac-WH14",
"Unitrac-WH16",
"Unitrac-WH16",
"Unitrac-WH18",
"Unitrac-WH19",
"Unitrac-WH20",
"Unitrac-WH21",
"utprod-asr1.colo.as.local",
"utprod-asr2.colo.as.local",
"utprod-asr3.colo.as.local",
"utprod-asr4.colo.as.local",
"utprod-asr5.colo.as.local",
"utprod-asr6.colo.as.local",
"utprod-asr7.colo.as.local",
"utprod-asr8.colo.as.local",
"utprod-asr9.colo.as.local",
"utprod-asr10.colo.as.local"

)
Foreach ($server in $serverList) {
 #this remote session gets service status for each item in the list
$Session = New-PSSession -ComputerName $server
$serviceControlBlock = {
 
$serviceList = (
"DirectoryWatcher*",
"Fax*",
"LDH*",
"LetterGen*",
"LIMC*",
"Message*",
"MSGSRV*",
"Osprey*",
"QC*",
"Unitrac*",
"UTL*",
"Workflow*"
)

Get-Service  -DisplayName $serviceList | where {$_.StartType -ne "Disabled"} | sort-object status | format-table -Property DisplayName -groupby status 

 }  #end script block

Invoke-Command -ComputerName $server -ScriptBlock {hostname}
Invoke-Command -Session $Session -ScriptBlock $serviceControlBlock

} #end foreach server


Stop-Transcript