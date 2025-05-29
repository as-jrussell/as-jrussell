

Write-Output "What is the name of the new service create today?`n"
$service_names = Read-Host -Prompt  "(enter new service name)"
#if( [string]::IsNullOrEmpty($version)
Foreach ($service in $service_names){

   $destPath = New-Item -ItemType "directory" -Path "E:\Services\$service"

   Get-ChildItem -Path $destPath -Recurse | Remove-Item -Force -Recurse  
   New-Service -Name "$Service" -BinaryPathName """E:\Services\$Service\Osprey.DashboardService.exe"" -SVCNAME:$Service" -DisplayName "$Service" -StartupType Automatic -Description "$Service"}



   Write-Output "
   Check files on E drive and ensure the service was created`n"

