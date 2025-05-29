$server1	="UTQA2-APP1"
$server2	="UTQA2-APP2"
$server3	="UTQA2-APP3"
$server4	="UTQA2-APP4"
$server5	="UTQA2-ASR1"
$server6	="UTQA2-ASR2"
$server7	="UTQA2-ASR3"
$server8	="UTSTAGE-APP2"
$server9	="UTSTAGE-APP3"
$server10	="UTSTAGE-APP4"
$server11	="UTSTAGE-ASR1"
$server12	="UTSTAGE-ASR2"
$server13	="UTSTAGE-ASR3"
$server14	="UT-STAGEWEB-1"
$server15	="UT-STGAPP-02"
$server16	="UT-QAWEB-1"
$server17	="TFS-Build-06"
$server18	="usd-rd001"

$Environment = $server1,$server2,$server3,$server4,$server5,$server6,$server7,$server8,$server9,$server10,$server11,$server12,$server13,$server14,$server15,$server16,$server17,$server18


 Get-CimInstance win32_logicaldisk -computername $Environment | Where-Object -FilterScript { ($_.FreeSpace/$_.Size*100 -le 15 ) -and 
($_.VolumeName  -ne 'PageFile') -and ($_.Description  -ne 'CD-ROM Disc') -and ($_.Description  -ne '3 1/2 Inch Floppy Drive') 
}   |
 select SystemName,name, @{Name="SizeGB";Expression={$_.Size/1GB -as [int]}} , @{Name="%";Expression={[math]::round($_.FreeSpace/$_.Size*100,0)}} ,
@{Name="Free Space";Expression={($_.FreeSpace/1GB -as [int])}}  | Out-GridView -Title "Storage Space Free less than 10%"



