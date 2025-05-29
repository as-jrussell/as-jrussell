$AG1 = 'ON-SQLCLSTPRD-2'
$AG2 = 'DB-SQLCLST-01-1'
$AG3 = 'ON-SQLCLSTPRD-1'

$Source = 'UT-SQLSTG-01'
$Job = 'Unitrac-ArchivePropertyChange_Archive'


$Server= $AG1, $AG2, $AG3

Remove-DbaAgentJob -Job $Job -SqlInstance $Server

Copy-DbaAgentJob -Job $Job -Source $Source -Destination $Server

