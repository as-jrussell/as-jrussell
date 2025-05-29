

#Create new IIS AppPools
$server_names = Get-Content  "UnitracDataAppPool"
Foreach ($Service in $server_names){
New-WebAppPool -Name $Service }



#Set user name logins IIS AppPools
$server_names = Get-Content  "E:\Temp\Unitrac IIS5.txt"
Foreach ($Service in $server_names){
Import-Module WebAdministration
Set-ItemProperty IIS:\AppPools\$service -name processModel -value @{userName="LDHService@as.local";password="1ijt3kOwko2WT64mLhfh";identitytype=3}}



#stop IIS service
$server_names = Get-Content  "E:\Temp\Unitrac IIS.txt"
Foreach ($Service in $server_names){
Stop-WebAppPool -Name $service}

#start IIS service
$server_names = Get-Content  "E:\Temp\Unitrac IIS.txt"
Foreach ($Service in $server_names){
Start-WebAppPool -Name $service}