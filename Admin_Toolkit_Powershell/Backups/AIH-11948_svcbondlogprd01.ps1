
$server1	=  'CP-SQLPRD-01'
$server2	=  'CP-SQLPRD-02'
$server3	=  'CP-SQLPRD-03'
$user       =  'ELDREDGE_A\svc_bond_log_PRD01' 


Copy-DbaLogin -Source $server1  -Destination $server3  -Login $user 
Copy-DBALogin -Source $server1  -Destination $server2  -Login $user 

Sync-DbaLoginPermission -Source $server1  -Destination $server3  -Login $user 
Sync-DbaLoginPermission -Source $server1  -Destination $server2  -Login $user 


$Environment = $server1, $server2, $server3

Get-DbaLogin -SqlInstance $Environment  -Login $user  | SELECT-OBJECT NAME, ComputerName, HasAccess