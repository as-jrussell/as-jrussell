$server1	=  'OCR-SQLPRD-05'
$server2	=  'CP-SQLQA-01'
$server3	=  'CP-SQLQA-03'



$Environment = $server1, $server2, $server3

#$Environment ='OCR-SQLPRD-05'


#Start-DbaAgentJob -SqlInstance $Environment -Job DBA-HarvestDaily


 Get-CimInstance win32_logicaldisk -computername $Environment | Where-Object -FilterScript { ($_.FreeSpace  ) -and 
($_.VolumeName  -ne 'PageFile') -and ($_.Description  -ne 'CD-ROM Disc') -and ($_.Description  -ne '3 1/2 Inch Floppy Drive') 
}   |
 Select-Object SystemName,name, @{Name="SizeGB";Expression={$_.Size/1GB -as [int]}} , @{Name="15% of drive is";Expression={$_.Size/1GB*.15 -as [int]}} ,  
 @{Name="20% of drive is";Expression={$_.Size/1GB*.2 -as [int]}} , @{Name="Free Space";Expression={($_.FreeSpace/1GB -as [int])}},
@{Name="%";Expression={[math]::round($_.FreeSpace/$_.Size*100,0)}} | Out-GridView -Title "Storage Space Free less than 10%"


nslookup 10.9.5.7


Invoke-Command -ComputerName 'DBA-SQLPRD-01' -ScriptBlock {Restart-Computer}
