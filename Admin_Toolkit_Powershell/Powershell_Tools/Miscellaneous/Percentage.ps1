for ($i = 0; $i -le 100; $i+=20)

{Write-Progress -Activity "Progress" -Status "$i% Complete:" -PercentComplete $i;
Start-Sleep 1
 }