Get-WmiObject -ClassName Win32_OperatingSystem -ComputerName HOSTED-SQL01 | Select-Object -Property Caption, PSComputerName   
