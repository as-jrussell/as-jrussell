

#multiple service registry add
$server_names = Get-Content  "\\usd-rd02\c$\Powershell Scripts\PowerShell\Deployment Jobs\QA2\Message\Message.txt"
Foreach ($Service in $server_names){
New-ItemProperty -Path "HKLM:\System\CurrentControlSet\Services\$service" -Name "Description" -Value $Service}
Get-ItemProperty "HKLM:\System\CurrentControlSet\Services\$service"



#multiple service registry add login user to database
$server_names = Get-Content  "\\usd-rd02\c$\Powershell Scripts\PowerShell\Deployment Jobs\QA2\Message\Message.txt"
Foreach ($Service in $server_names){
New-ItemProperty -Path "HKLM:\System\CurrentControlSet\Services\$service" -Name "ObjectName" -Value "LDHService@as.local"}
Get-ItemProperty "HKLM:\System\CurrentControlSet\Services\$service"



#For one service regristry add

 -Name "DisplayName" -Value MSGSRVREXTINFO




#multiple service registry updates
$server_names = Get-Content "C:\temp\UBS.txt"
Foreach ($Service in $server_names)
{set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Services\$Service" -Name "ImagePath" -Value """C:\Services\$Service\UnitracBusinessService.exe"" -SVCNAME:$Service"}



#For one service regristry update
set-ItemProperty -Path "HKLM:\System\CurrentControlSet\MSGSRVREXTINFO" -Name "DisplayName" -Value MSGSRVREXTINFO



Invoke-Command -ComputerName 'OCR-SQLTMP-01' -ScriptBlock {Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQLServer\'}
Invoke-Command -ComputerName 'OCR-SQLTMP-02' -ScriptBlock {Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQLServer\'}
Invoke-Command -ComputerName 'OCR-SQLTMP-03' -ScriptBlock {Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQLServer\'}
Invoke-Command -ComputerName 'OCR-SQLTMP-04' -ScriptBlock {Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQLServer\'}
Invoke-Command -ComputerName 'OCR-SQLTMP-05' -ScriptBlock {Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQLServer\'}
Invoke-Command -ComputerName 'OCR-SQLTMP-06' -ScriptBlock {Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQLServer\'}



Show-Command

Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQLServer\DefaultData"


Get-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\PowerShell\1\PowerShellEngine

ApplicationBase         : C:\Windows\system32\WindowsPowerShell\v1.0\
ConsoleHostAssemblyName : Microsoft.PowerShell.ConsoleHost, Version=1.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35, ProcessorArchitecture=msil
PowerShellVersion       : 2.0
RuntimeVersion          : v2.0.50727
CTPVersion              : 5
PSCompatibleVersion     : 1.0,2.0

Invoke-Command -ComputerName 'TFS-BUILD-06' -ScriptBlock {Get-ItemProperty -Path "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Microsoft SQL Server\MSSQL.1\MSSQLServer"}

Get-ItemProperty 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\Microsoft SQL Server\MSSQL%\MSSQLServer'



Remove-ItemProperty -Path "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Microsoft SQL Server\JCENVIRONMENT\MSSQLServer" -Name DefaultData -Value "C:\Downloads\SQLDATA\"