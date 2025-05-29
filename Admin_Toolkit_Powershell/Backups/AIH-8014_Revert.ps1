$AG1 = 'ON-SQLCLSTPRD-2'
$AG2 = 'DB-SQLCLST-01-1'
$AG3 = 'ON-SQLCLSTPRD-1'


$Job2 = 'Unitrac-ArchivePropertyChange_WeekendOnly_Archive'


$Server= $AG1, $AG2, $AG3

Remove-DbaAgentJob -Job $Job2 -SqlInstance $Server

