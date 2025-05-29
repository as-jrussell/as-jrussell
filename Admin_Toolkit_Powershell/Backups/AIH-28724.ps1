$AG1 = 'SQLSPRDAWEC10'
$AG2 = 'SQLSPRDAWEC11'

$Source = 'ON-SQLCLSTPRD-1'
$Job = 'Unitrac-PegaEscrowWorkitemStatus'


$Server= $AG1, $AG2

Copy-DbaAgentJob -Job $Job -Source $Source -Destination $Server




Set-DbaAgentJob -Disabled -Job $Job -SqlInstance $Source
Set-DbaAgentJob -Disabled -Job $Job -SqlInstance $AG2
Set-DbaAgentJob -Enabled -Job $Job -SqlInstance $AG1

