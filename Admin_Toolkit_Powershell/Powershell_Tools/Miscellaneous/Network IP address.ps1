$computername = Get-Content  "C:\temp\ASR.txt"
Get-NetIPAddress -CimSession $computername -AddressFamily IPv4 | 
where { $_.InterfaceAlias -notmatch 'Loopback'} |Select PSComputername,IPAddress | Export-Csv -path "\\as.local\shared\InfoTech\Application Administrators\Unitrac\Unitrac_Powershell_Scripts\Unitrac-Server_IPs.csv"