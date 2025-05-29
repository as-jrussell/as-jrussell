$server1	= 'UIPA-TST-DB1'
#$server2	= 'CP-SQLQA-02'  $server3	= 'CP-SQLQA-03'



$Environment = $server1#, $server2, $server3
Get-NetIPAddress -CimSession $Environment -AddressFamily IPv4 | 
where { $_.InterfaceAlias -notmatch 'Loopback'} | where {$_.IPAddress -NotLike '169*'}|
Select PSComputername,IPAddress,*| Sort-Object PSComputerName






#Find-DbaDbGrowthEvent -SqlInstance CP-SQLPRD-01 | Out-GridView