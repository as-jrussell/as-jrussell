
$server1	=  'SQLSPRDAWEC10'
$server2	=  'DB-SQLCLST-01-1'
$server3	=  'ON-SQLCLSTPRD-1'
$server4	=  'ON-SQLCLSTPRD-2'
$server5	=  'SQLSPRDAWEC11'
$user       =  'ELDREDGE_A\UiPath Robots' 


Copy-DbaLogin -Source $server1  -Destination $server2  -Login $user 
Copy-DBALogin -Source $server1  -Destination $server3  -Login $user 
Copy-DbaLogin -Source $server1  -Destination $server4  -Login $user 
Copy-DbaLogin -Source $server1  -Destination $server5  -Login $user 

Sync-DbaLoginPermission -Source $server1  -Destination $server2  -Login $user 
Sync-DbaLoginPermission -Source $server1  -Destination $server3  -Login $user 
Sync-DbaLoginPermission -Source $server1  -Destination $server4  -Login $user 
Sync-DbaLoginPermission -Source $server1  -Destination $server5  -Login $user 


$Environment = $server1, $server2, $server3, $server4, $server5

Get-DbaLogin -SqlInstance $Environment  -Login $user  | SELECT-OBJECT NAME, ComputerName, HasAccess