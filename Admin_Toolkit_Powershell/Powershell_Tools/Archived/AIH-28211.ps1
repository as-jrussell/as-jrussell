$AG1 = 'SQLSPRDAWEC11'

$Source = 'SQLSPRDAWEC10'
$Job = 'UTRC-Generate_LFP_Stats'


Copy-DbaAgentJob -Job $Job -Source $Source -Destination $AG1

Set-DbaAgentJob -Disabled -Job $Job -SqlInstance $AG1

