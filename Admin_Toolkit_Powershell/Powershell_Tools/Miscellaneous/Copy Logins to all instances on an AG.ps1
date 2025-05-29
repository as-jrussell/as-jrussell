
$server1	=  ''
$server2	=  ''
$server3	=  ''
$user       =  '' 


Copy-DbaLogin -Source $server1  -Destination $server3  -Login $user 
Copy-DBALogin -Source $server1  -Destination $server2  -Login $user 

Sync-DbaLoginPermission -Source $server1  -Destination $server3  -Login $user 
Sync-DbaLoginPermission -Source $server1  -Destination $server2  -Login $user 


$Environment = $server1, $server2, $server3

Get-DbaLogin -SqlInstance $Environment  -Login $user  | SELECT-OBJECT NAME, ComputerName, HasAccess