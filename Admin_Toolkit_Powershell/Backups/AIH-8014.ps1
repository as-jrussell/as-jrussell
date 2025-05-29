$AG1 = 'UT-SQLSTG-01'
$AG2 = 'UTQA-SQL-14'



$Job = 'Unitrac-ArchivePropertyChange_Archive'
$Job2 = 'Unitrac-ArchivePropertyChange_WeekendOnly_Archive'


$Dest =  $AG1, $AG2
$Job  =  $Job1, $Job2




Set-DbaAgentJob -SqlInstance $Dest -Job $Job -Enabled 1
