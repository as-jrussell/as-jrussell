$AG1 = 'UTSTAGE-SQL-01'

$Server= $AG1

#Remove-DbaAgentJob -Job 'ArchivePropertyChange' -SqlInstance $Server

Copy-DbaAgentJob -Job 'Unitrac-ArchivePropertyChange_Archive' -Source ON-SQLCLSTPRD-2 -Destination $Server

nslookup 10.8.17.32