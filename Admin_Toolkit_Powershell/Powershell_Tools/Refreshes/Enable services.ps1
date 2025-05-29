
Invoke-Command -Computername 'UTQA-SQL-14' -ScriptBlock {Set-Service -Name 'MSSQLSERVER' -StartupType Automatic -Verbose}
Invoke-Command -Computername 'UTQA-SQL-14' -ScriptBlock {Set-Service -Name 'MSSQLFDLauncher' -StartupType Automatic -Verbose}
Invoke-Command -Computername 'UTQA-SQL-14' -ScriptBlock {Set-Service -Name 'MsDtsServer120' -StartupType Automatic -Verbose}
Invoke-Command -Computername 'UTQA-SQL-14' -ScriptBlock {Set-Service -Name 'SQLSERVERAGENT' -StartupType Automatic -Verbose}



Invoke-Command -Computername 'UTQA-SQL-14' -ScriptBlock {  Start-Service  -Name 'MSSQLSERVER' }
Invoke-Command -Computername 'UTQA-SQL-14' -ScriptBlock {  Start-Service  -Name 'MSSQLFDLauncher'}
Invoke-Command -Computername 'UTQA-SQL-14' -ScriptBlock {  Start-Service  -Name 'MsDtsServer120' }
Invoke-Command -Computername 'UTQA-SQL-14' -ScriptBlock {  Start-Service  -Name 'SQLSERVERAGENT' }


nslookup 172.31.30.36,1433

nslookup SQLSDEVAWEC01