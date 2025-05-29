#For multiple; ensure that there is a document created for the services needed

$server_names = Get-Content  "C:\temp\UBS.txt"
Foreach ($Service in $server_names){New-Service -Name "$Service" -BinaryPathName """C:\Services\$Service\UnitracBusinessService.exe"" -SVCNAME:$Service" -DisplayName "$Service" -StartupType Automatic -Description "$Service"}


