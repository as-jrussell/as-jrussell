# Delete all Files in C:\temp older than 30 day(s)

$Daysback = "-30"
$CurrentDate = Get-Date
$DatetoDelete = $CurrentDate.AddDays($Daysback)

$Path = "\\Unitrac-App04\E$\inetpub\wwwroot\UniTrac\Application Files\"
Get-ChildItem $Path | Where-Object { $_.LastWriteTime -lt $DatetoDelete } | Remove-Item -Recurse



$Path = "\\Unitrac-App04\E$\inetpub\wwwroot\LDHWebService"
Get-ChildItem $Path | Where-Object { $_.LastWriteTime -lt $DatetoDelete } | Remove-Item -Recurse

$Path = "\\Unitrac-App04\E$\inetpub\wwwroot\LenderService"
Get-ChildItem $Path | Where-Object { $_.LastWriteTime -lt $DatetoDelete } | Remove-Item -Recurse

$Path = "\\Unitrac-App04\E$\inetpub\wwwroot\MyInsuranceInfo.com"
Get-ChildItem $Path | Where-Object { $_.LastWriteTime -lt $DatetoDelete } | Remove-Item -Recurse

$Path = "\\Unitrac-App04\E$\inetpub\wwwroot\UniTracServer"
Get-ChildItem $Path | Where-Object { $_.LastWriteTime -lt $DatetoDelete } | Remove-Item -Recurse

$Path = "\\Unitrac-App04\E$\inetpub\wwwroot\UnitracSSO"
Get-ChildItem $Path | Where-Object { $_.LastWriteTime -lt $DatetoDelete } | Remove-Item -Recurse

$Path = "\\Unitrac-App04\E$\inetpub\wwwroot\VehicleLookupService"
Get-ChildItem $Path | Where-Object { $_.LastWriteTime -lt $DatetoDelete } | Remove-Item -Recurse

$Path = "\\VUT-SCAN\c$\Inetpub\wwwroot\LFPWebService"
Get-ChildItem $Path | Where-Object { $_.LastWriteTime -lt $DatetoDelete } | Remove-Item -Recurse


