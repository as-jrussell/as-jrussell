$old = 15
$now = Get-Date

Get-ChildItem C:\WINDOWS\system32\LogFiles\W3SVC1 -Recurse |
Where-Object {-not $_.PSIsContainer -and $now.Subtract($_.CreationTime).Days -gt $old } |
Remove-Item -WhatIf