$services = Get-Content D:\temp\Services.txt


foreach ($service in $services)

{
Stop-Service -Name $service –Force
Set-Service -Name $service -StartupType Disabled -Verbose
}

