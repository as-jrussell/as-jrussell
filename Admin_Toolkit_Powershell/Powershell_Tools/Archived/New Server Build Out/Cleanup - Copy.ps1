# Delete all Files in C:\temp older than currently 2 day(s) when 
# E drive gets added move and move to that drive will open it to 7 days

$Daysback = "-4"
 
$CurrentDate = Get-Date
$DatetoDelete = $CurrentDate.AddDays($Daysback)
Remove-Item -recurse "E:\logs" -Include *.log  | Where-Object { $_.LastWriteTime -lt $DatetoDelete } 