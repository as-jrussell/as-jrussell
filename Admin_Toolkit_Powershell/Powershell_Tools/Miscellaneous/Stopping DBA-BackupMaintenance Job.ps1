<#$server1	= 'CP-SQLPRD-01'
$server2	= 'CP-SQLPRD-02'
$server3	= 'CP-SQLPRD-03'


$Environment = $server1, $server2, $server3 #>

$Environment ='on-sqlclstprd-1'


Get-Process -ComputerName $Environment  -Name ddbmsqlsv 

  #Stop-DbaAgentJob -Job 'DBA-BackupMaintenance' -SqlInstance $Environment 

 # Invoke-Command  -ComputerName $Environment -ScriptBlock {Get-Process  -Name ddbmexptool}