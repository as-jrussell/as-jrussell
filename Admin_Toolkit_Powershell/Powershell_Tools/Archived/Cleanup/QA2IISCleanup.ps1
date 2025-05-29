# Delete all Files in C:\temp older than 30 day(s)

$Daysback = "-7"
$CurrentDate = Get-Date
$DatetoDelete = $CurrentDate.AddDays($Daysback)

$Path = "\\utqa2-app1.rd.as.local\c$\inetpub\wwwroot\UniTrac\Application Files"
Get-ChildItem $Path | Where-Object { $_.LastWriteTime -lt $DatetoDelete } | Remove-Item -Recurse

$Path = "\\utqa2-app1.rd.as.local\c$\inetpub\wwwroot\LDHWebService"
Get-ChildItem $Path | Where-Object { $_.LastWriteTime -lt $DatetoDelete } | Remove-Item -Recurse

$Path = "\\utqa2-app1.rd.as.local\c$\inetpub\wwwroot\LenderService"
Get-ChildItem $Path | Where-Object { $_.LastWriteTime -lt $DatetoDelete } | Remove-Item -Recurse



$Path = "\\utqa2-app1.rd.as.local\c$\inetpub\wwwroot\UnitracSSO"
Get-ChildItem $Path | Where-Object { $_.LastWriteTime -lt $DatetoDelete } | Remove-Item -Recurse

$Path = "\\utqa2-app1.rd.as.local\c$\inetpub\wwwroot\VehicleLookupService"
Get-ChildItem $Path | Where-Object { $_.LastWriteTime -lt $DatetoDelete } | Remove-Item -Recurse

$Path = "\\vutqa01.rd.as.local\c$\Inetpub\wwwroot\LFPWebService"
Get-ChildItem $Path | Where-Object { $_.LastWriteTime -lt $DatetoDelete } | Remove-Item -Recurse
