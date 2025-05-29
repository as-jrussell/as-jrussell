
$server1	=  'CP-SQLPRD-01'
$server2	=  'CP-SQLPRD-02'
$server3	=  'CP-SQLPRD-03'
$user       =  'ELDREDGE_A\svc_bond_lg_PRD01' 


$Environment = $server1, $server2, $server3

Get-DbaLogin -SqlInstance $Environment  -Login $user  | SELECT-OBJECT NAME, ComputerName, HasAccess



nslookup  172.20.50.84