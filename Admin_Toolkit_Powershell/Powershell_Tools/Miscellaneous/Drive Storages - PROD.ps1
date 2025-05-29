$server1	="UNITRAC-WH001"
$server2	="UNITRAC-WH002"
$server3	="UNITRAC-WH003"
$server4	="UNITRAC-WH004"
$server5	="UNITRAC-WH005"
$server6	="UNITRAC-WH006"
$server7	="UNITRAC-WH007"
$server8	="UNITRAC-WH008"
$server9	="UNITRAC-WH009"
$server10	="UNITRAC-WH010"
$server11	="UNITRAC-WH011"
$server12	="UNITRAC-WH012"
$server13	="UNITRAC-WH013"
$server14	="UNITRAC-WH014"
$server15	="UNITRAC-WH015"
$server16	="UNITRAC-WH016"
$server17	="UNITRAC-WH017"
$server18	="UTPROD-ASR1"
$server19	="UTPROD-ASR2"
$server20	="UTPROD-ASR3"
$server21	="UTPROD-ASR4"
$server22	="UTPROD-ASR5"
$server23	="UTPROD-ASR6"
$server24	="UTPROD-ASR7"
$server25	="UTPROD-ASR8"
$server26	="UTPROD-ASR9"
$server27	="UTPROD-UTLAPP-1"
$server28	="LIMC-APP-01"
$server29   ="UTL-SQL-01" 
$server30   ="mongodb-prod-01"
$server31   ="Unitrac-APP04"
$server32   ="UTPROD-WEB-1"
$server33   ="utprod-api-01"

$Environment = $server1,$server2,$server3,$server4,$server5,$server6,$server7,$server8,$server9,$server10,$server11,$server12,$server13,$server14,$server15,$server16,$server17,$server18,$server19,$server20,$server21,$server22,$server23,$server24,$server25,$server26,$server27,$server28,$server29,$server30,$server31,$server32,$server33



 Get-CimInstance win32_logicaldisk -computername $Environment | Where-Object -FilterScript { ($_.FreeSpace/$_.Size*100 -le 15 ) -and 
($_.VolumeName  -ne 'PageFile') -and ($_.Description  -ne 'CD-ROM Disc') -and ($_.Description  -ne '3 1/2 Inch Floppy Drive') 
}   |
 select SystemName,name, @{Name="SizeGB";Expression={$_.Size/1GB -as [int]}} , @{Name="%";Expression={[math]::round($_.FreeSpace/$_.Size*100,0)}} ,
@{Name="Free Space";Expression={($_.FreeSpace/1GB -as [int])}}  | Out-GridView -Title "Storage Space Free less than 10%"



