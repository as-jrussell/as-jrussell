$AG1 = 'CP-SQLPRD-01'
$AG2 = 'CP-SQLPRD-02'
$AG3 = 'CP-SQLPRD-03'

$Server= $AG1, $AG2, $AG3

Remove-DbaAgentJob -Job 'IQQ Purge Response and Response_Property Data > 90 days'-SqlInstance $Server
Remove-DbaAgentJob -Job 'IQQ RESPONSE LOG PURGE' -SqlInstance $Server

Copy-DbaAgentJob -Job 'IQQ Purge Response and Response_Property Data > 90 days' -Source CPIQ-STG-LISTEN -Destination $Server
Copy-DbaAgentJob -Job 'IQQ RESPONSE LOG PURGE' -Source CPIQ-STG-LISTEN -Destination $Server


Set-DbaAgentJob -Job 'IQQ Purge Response and Response_Property Data > 90 days' -EmailOperator 'Job - Purge Response tables - failure' -EmailLevel 2 -SqlInstance  $Server