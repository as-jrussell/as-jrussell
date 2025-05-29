$serverList = (

"UTQA2-APP1",
"UTQA2-APP2",
"UTQA2-APP3",
"UTQA2-APP4",
"UTQA2-ASR1",
"UTQA2-ASR2",
"UTQA2-ASR3",
"UTSTAGE-APP1",
"UTSTAGE-APP2",
"UTSTAGE-APP3",
"UTSTAGE-APP4",
"UTSTAGE-ASR1",
"UTSTAGE-ASR2",
"UTSTAGE-ASR3",
"UTAUTO-APP1", 
"Unitrac-PreProd", 
"UTPreProd-APP01", 
"UT-PPDIIS-01", 
"TFS-Build-06",
"TFS-Build-07",
"TFS-Server-03",
"USD-RD02","USD-RD01",
"Unitrac-PROD1"

)

$server_names =  $serverList
Foreach ($Server in $server_names){

Get-WmiObject win32_logicaldisk -computername $Server| Where-Object -FilterScript { ($_.Freespace/1GB -le 10) -and ($_.VolumeName  -ne 'PageFile') -and ($_.Description  -ne 'CD-ROM Disc') -and ($_.Description  -ne '3 1/2 Inch Floppy Drive') 
}   |
 select SystemName,name,  @{Name="SizeGB";Expression={$_.Size/1GB -as [int]}},@{Name="FreeGB";Expression={[math]::Round($_.Freespace/1GB,2)
 }}, @{Name="%";Expression={[math]::round($_.FreeSpace/1024/1024/1024, 0)}}
 
 }


