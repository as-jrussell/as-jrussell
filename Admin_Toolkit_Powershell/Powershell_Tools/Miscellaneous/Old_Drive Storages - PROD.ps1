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
 "UTPROD-UTLAPP-1",
 "UTPROD-API-01",
 "Unitrac-PRT",
"Unitrac-EDI-01", "VUT-SCAN"

)

$server_names =  $serverList
Foreach ($Server in $server_names){
Get-WmiObject win32_logicaldisk -computername $Server| Where-Object -FilterScript { ($_.Freespace/1GB -le 10) -and ($_.VolumeName  -ne 'PageFile') -and ($_.Description  -ne 'CD-ROM Disc') -and ($_.Description  -ne '3 1/2 Inch Floppy Drive') 
}   |
 select SystemName,name,  @{Name="SizeGB";Expression={$_.Size/1GB -as [int]}},@{Name="FreeGB";Expression={[math]::Round($_.Freespace/1GB,2)
 }}}




