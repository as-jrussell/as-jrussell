
$server1	=  'SQLSPRDAWEC10'
$server2	=  'SQLSPRDAWEC11'
$user       =  'UTRCdbNancy.Yu' 


Copy-DBALogin -Source $server1  -Destination $server2  -Login $user 

Sync-DbaLoginPermission -Source $server1  -Destination $server2  -Login $user 


$Environment = $server1, $server2
Get-DbaLogin -SqlInstance $Environment  -Login $user  | SELECT-OBJECT NAME, ComputerName, HasAccess


