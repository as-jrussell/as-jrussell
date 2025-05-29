
$server = 'CP-QA-LISTENER'


Invoke-sqlcmd -ServerInstance $Server -Query "select * from sys.dm_server_registry WHERE value_name = 'TcpPort'"
