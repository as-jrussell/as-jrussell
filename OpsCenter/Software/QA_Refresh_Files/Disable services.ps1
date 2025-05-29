Invoke-Command -Computername 'UTQA-SQL-14' -ScriptBlock {  Stop-Service  -Name 'MSSQLFDLauncher'}
Invoke-Command -Computername 'UTQA-SQL-14' -ScriptBlock {  Stop-Service  -Name 'MsDtsServer120' }
Invoke-Command -Computername 'UTQA-SQL-14' -ScriptBlock {  Stop-Service  -Name 'SQLSERVERAGENT' }
Invoke-Command -Computername 'UTQA-SQL-14' -ScriptBlock {  Stop-Service  -Name 'MSSQLSERVER' }

Invoke-Command -Computername 'UTQA-SQL-14' -ScriptBlock {Set-Service -Name 'MSSQLSERVER'  -StartupType Disabled -Verbose}
Invoke-Command -Computername 'UTQA-SQL-14' -ScriptBlock {Set-Service -Name 'MSSQLFDLauncher' -StartupType Disabled -Verbose}
Invoke-Command -Computername 'UTQA-SQL-14' -ScriptBlock {Set-Service -Name 'MsDtsServer120'  -StartupType Disabled -Verbose}
Invoke-Command -Computername 'UTQA-SQL-14' -ScriptBlock {Set-Service -Name 'SQLSERVERAGENT'  -StartupType Disabled -Verbose}
