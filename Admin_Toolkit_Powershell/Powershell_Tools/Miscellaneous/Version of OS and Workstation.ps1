

$addr  = Get-Content "C:\Downloads\Infa.txt"

Invoke-Command $addr -ScriptBlock { 
 (Get-WmiObject Win32_OperatingSystem).CSName,(Get-WMIObject win32_operatingsystem).caption
} 





