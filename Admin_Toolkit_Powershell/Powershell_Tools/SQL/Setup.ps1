Get-ExecutionPolicy -List

#Set-ExecutionPolicy -Scope Process -ExecutionPolicy Undefined
#Set-ExecutionPolicy -Scope LocalMachine -ExecutionPolicy Unrestricted


#Get-Module -ListAvailable PowerShellGet | Select-Object Path


Get-Module
Get-InstalledModule

Show-Command

Get-PSRepository
#

Invoke-SQLcmd -QueryTimeout 0 -Server 'UT-SQLDEV-01' -Database Unitrac 'Select * FROM Lender where code_tx= ''usdtest1'''  




$PSVersionTable