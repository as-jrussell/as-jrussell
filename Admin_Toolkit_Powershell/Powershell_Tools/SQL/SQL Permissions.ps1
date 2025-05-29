
$user       =  'ELDREDGE_A\IT Support Group'
$server1	=  'on-sqlclstprd-1'
$server2	=  'on-sqlclstprd-2'
$server3	=  'DB-SQLCLST-01-1' 

$Environment = $server1, $server2, $server3


Get-DbaUserPermission -SqlInstance $Environment  |Select-Object Member,SqlInstance,Object,Permission,GrantorType | Where-Object {$_.Member -like $user  }


