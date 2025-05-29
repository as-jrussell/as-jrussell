
$AG2 = 'UTQA-SQL-14'


$Server=  $AG2

Remove-DbaAgentJob -Job 'Unitrac-ArchivePropertyChange_Archive'-SqlInstance $Server
Remove-DbaAgentJob -Job 'Unitrac-ArchiveInteractionHistory_Archive' -SqlInstance $Server
Remove-DbaAgentJob -Job 'Unitrac-ArchiveChangeHistory_Archive' -SqlInstance $Server

Copy-DbaAgentJob -Job 'Unitrac-ArchiveChangeHistory_Archive' -Source ON-SQLCLSTPRD-1 -Destination $Server
Copy-DbaAgentJob -Job 'Unitrac-ArchiveInteractionHistory_Archive' -Source ON-SQLCLSTPRD-1 -Destination $Server
Copy-DbaAgentJob -Job 'Unitrac-ArchivePropertyChange_Archive' -Source ON-SQLCLSTPRD-1 -Destination $Server

