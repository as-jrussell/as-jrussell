Start-Transcript -Path "C:\temp\Prod Support\Kingoftheworld.txt"

#Get-ChildItem   "C:\temp\Prod Support\Prod Support Tool Config\Production\ProductionSupportTool.exe.config" |Copy-Item -Destination  "\\Unitrac-APP01\Production Support Tool" -Force



Get-ChildItem -Path "C:\temp\Prod Support\Production Support Tool\" -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
Get-ChildItem -Path "C:\temp\Prod Support\Production Support Tool - QA\" -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
Get-ChildItem -Path "C:\temp\Prod Support\Production Support Tool - SnapShot\" -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
Get-ChildItem -Path "C:\temp\Prod Support\Production Support Tool - Staging\" -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue

$Version = "Version ReleaseCandidate"


#UBS Service
$server_names = Get-Content "C:\temp\Prod Support\PST.txt"
Foreach ($Service in $server_names){Copy-Item "\\tfs-build-06\E$\UniTrac\Setups\$Version\ProdSupportTool\*.*" -Destination "C:\Temp\Prod Support\$Service" -Recurse}




Get-ChildItem   "C:\temp\Prod Support\Prod Support Tool Config\Production\ProductionSupportTool.exe.config" |Copy-Item -Destination  "C:\Temp\Prod Support\Production Support Tool" -Force
Get-ChildItem   "C:\temp\Prod Support\Prod Support Tool Config\QA\ProductionSupportTool.exe.config" |Copy-Item -Destination  "C:\Temp\Prod Support\Production Support Tool - QA" -Force
Get-ChildItem   "C:\temp\Prod Support\Prod Support Tool Config\Staging\ProductionSupportTool.exe.config" |Copy-Item -Destination  "C:\Temp\Prod Support\Production Support Tool - Staging" -Force
Get-ChildItem   "C:\temp\Prod Support\Prod Support Tool Config\Snapshot\ProductionSupportTool.exe.config" |Copy-Item -Destination  "C:\Temp\Prod Support\Production Support Tool - Snapshot" -Force



Stop-Transcript

if(Test-Path "C:\Temp\Prod Support\Kingoftheworld.txt"){
$destination = "C:\Temp\Prod Support\Kingoftheworld"+[DateTime]::Now.ToString("yyyyMMdd-HHmmss")+".txt"
Copy-Item -Path "C:\Temp\Prod Support\Kingoftheworld.txt" -Destination $destination
}


Remove-Item -Path "C:\Temp\Prod Support\Kingoftheworld.txt"