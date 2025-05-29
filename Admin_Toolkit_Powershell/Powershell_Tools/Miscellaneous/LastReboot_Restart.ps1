#Last Restart/Reboot of a server via Powershell

Invoke-Command -ComputerName UIPA-TST-DB1 -ScriptBlock {Get-WmiObject win32_operatingsystem | Select-Object csname, @{LABEL=’LastBootUpTime’;EXPRESSION={$_.ConverttoDateTime($_.lastbootuptime)}}}



#Last Restart via Command Prompt. 

<#


systeminfo | find "System Boot Time"


#>


Invoke-Command -ComputerName UIPA-TST-DB1 -ScriptBlock {systeminfo | find "System Boot Time"}
