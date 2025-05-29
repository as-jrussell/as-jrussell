

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

New-ItemProperty -Path "HKLM:\System\CurrentControlSet\MSGSRVREXTINFO" -Name "DisplayName" -Value MSGSRVREXTINFO
Get-ItemProperty "HKLM:\System\CurrentControlSet\MSGSRVREXTINFO"



#multiple service registry updates
$server_names = Get-Content "C:\temp\UBS.txt"
Foreach ($Service in $server_names)
{set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Services\$Service" -Name "ImagePath" -Value """C:\Services\$Service\UnitracBusinessService.exe"" -SVCNAME:$Service"}



#For one service regristry update
set-ItemProperty -Path "HKLM:\System\CurrentControlSet\MSGSRVREXTINFO" -Name "DisplayName" -Value MSGSRVREXTINFO

