$computername = Get-Content  "\\as.local\shared\InfoTech\Application Administrators\Unitrac\Unitrac_Powershell_Scripts\servers.txt"
Get-NetIPAddress -CimSession $computername -AddressFamily IPv4 | 
where { $_.InterfaceAlias -notmatch 'Loopback'} |Select PSComputername,IPAddress 