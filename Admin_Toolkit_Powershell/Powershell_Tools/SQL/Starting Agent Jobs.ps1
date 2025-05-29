$AG1 = 'GP-SQLPRD-01\I02'
$AG2 = 'GP-SQLPRD-01\I01'
$AG3 = 'TC-DB-01'

$Server = $AG1, $AG2 , $AG3 

Start-DbaAgentJob -SqlInstance $Server  -Job DBA-HarvestDaily