$Service1 = 'MSSQLSERVER'
$Service2 = 'MSSQLFDLauncher'
$Service3 = 'MsDtsServer120' 
$Service4 = 'SQLSERVERAGENT'

$computer = 'UTQA-SQL-14'


$services = $Service1,$Service2,$Service3, $Service4

Invoke-Command -Computername $computer -ScriptBlock {
foreach ($service in $services)

{
    Set-Service -Name $service -StartupType Automatic -Verbose
    Start-Service  -Name $service 
}
}


Invoke-Command -Computername 'UTQA-SQL-14' -ScriptBlock {Set-Service -Name 'MSSQLSERVER' -StartupType Automatic -Verbose}
Invoke-Command -Computername 'UTQA-SQL-14' -ScriptBlock {Set-Service -Name 'MSSQLFDLauncher' -StartupType Automatic -Verbose}
Invoke-Command -Computername 'UTQA-SQL-14' -ScriptBlock {Set-Service -Name 'MsDtsServer120' -StartupType Automatic -Verbose}
Invoke-Command -Computername 'UTQA-SQL-14' -ScriptBlock {Set-Service -Name 'SQLSERVERAGENT' -StartupType Automatic -Verbose}



Invoke-Command -Computername 'UTQA-SQL-14' -ScriptBlock {  Start-Service  -Name 'MSSQLSERVER' }
Invoke-Command -Computername 'UTQA-SQL-14' -ScriptBlock {  Start-Service  -Name 'MSSQLFDLauncher'}
Invoke-Command -Computername 'UTQA-SQL-14' -ScriptBlock {  Start-Service  -Name 'MsDtsServer120' }
Invoke-Command -Computername 'UTQA-SQL-14' -ScriptBlock {  Start-Service  -Name 'SQLSERVERAGENT' }