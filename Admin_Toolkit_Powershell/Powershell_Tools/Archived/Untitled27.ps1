$services = Get-Service -Name (Get-Content E:\Powershellscripts\DisableTheseServices.txt)

foreach ($service in $services)
{
Stop-Service -Name $service –Force
Set-Service -Name $service -StartupType Disabled -Verbose
}
