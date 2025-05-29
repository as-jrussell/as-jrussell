# Delete all Files in C:\temp older than 30 day(s)

$Daysback = "-14"
 
$CurrentDate = Get-Date
$DatetoDelete = $CurrentDate.AddDays($Daysback)

$Path = "\\UTSTAGE-APP2.rd.as.local\d$\inetpub\wwwroot\UniTrac\Application Files"
Get-ChildItem $Path | Where-Object { $_.LastWriteTime -lt $DatetoDelete } | Remove-Item -Recurse

$Path = "\\UTSTAGE-APP2.rd.as.local\d$\inetpub\wwwroot\LDHWebService"
Get-ChildItem $Path | Where-Object { $_.LastWriteTime -lt $DatetoDelete } | Remove-Item -Recurse

$Path = "\\UTSTAGE-APP2.rd.as.local\d$\inetpub\wwwroot\LenderService"
Get-ChildItem $Path | Where-Object { $_.LastWriteTime -lt $DatetoDelete } | Remove-Item -Recurse

$Path = "\\UTSTAGE-APP2.rd.as.local\d$\inetpub\wwwroot\MyInsuranceInfo.com"
Get-ChildItem $Path | Where-Object { $_.LastWriteTime -lt $DatetoDelete } | Remove-Item -Recurse



$Path = "\\UTSTAGE-APP2.rd.as.local\d$\inetpub\wwwroot\UnitracSSO"
Get-ChildItem $Path | Where-Object { $_.LastWriteTime -lt $DatetoDelete } | Remove-Item -Recurse

$Path = "\\UTSTAGE-APP2.rd.as.local\d$\inetpub\wwwroot\VehicleLookupService"
Get-ChildItem $Path | Where-Object { $_.LastWriteTime -lt $DatetoDelete } | Remove-Item -Recurse

$Path = "\\vutstage01.rd.as.local\c$\Inetpub\wwwroot\LFPWebService"
Get-ChildItem $Path | Where-Object { $_.LastWriteTime -lt $DatetoDelete } | Remove-Item -Recurse


