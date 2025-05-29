Start-Transcript -Path "C:\logs\PowerShell Logs\StagingQC.txt"



Get-Service	 -ComputerName	UTSTAGE-APP4	  -Name	QCBatchEvaluationProcess |Stop-Service -Force -NoWait
Get-Service	 -ComputerName	UTSTAGE-APP4	  -Name	QCBatchSendProcess |Stop-Service -Force -NoWait
Get-Service	 -ComputerName	UTSTAGE-APP4	  -Name	QCImportProcess |Stop-Service -Force -NoWait

Get-ChildItem -Path "\\utstage-app4\D$\Services\QCBatchEvaluationProcess" -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue

Get-ChildItem -Path "\\utstage-app4\D$\Services\QCBatchSendProcess" -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue

Get-ChildItem -Path "\\utstage-app4\D$\Services\QCCleanupProcess" -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue

Get-ChildItem -Path "\\utstage-app4\D$\Services\QCImportProcess" -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue

Get-ChildItem -Path "\\utstage-app2\D$\inetpub\Unitrac QC\QCModule" -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue






$sourcePath = "\\tfs-build-07\e$\QCModule\Setups\Version ReleaseCandidate\QCModuleBusinessService"
$destPath =  "\\utstage-app4\D$\Services\QCBatchEvaluationProcess"


Get-ChildItem $sourcePath -Recurse -Include '*.*' | Foreach-Object `
    {
        $destDir = Split-Path ($_.FullName -Replace [regex]::Escape($sourcePath), $destPath)
        if (!(Test-Path $destDir))
        {
            New-Item -ItemType directory $destDir | Out-Null
        }
        Copy-Item $_ -Destination $destDir}

    

$sourcePath = "\\tfs-build-07\e$\QCModule\Setups\Version ReleaseCandidate\QCModuleBusinessService"
$destPath =  "\\utstage-app4\D$\Services\QCBatchSendProcess"



Get-ChildItem $sourcePath -Recurse -Include '*.*' | Foreach-Object `
    {
        $destDir = Split-Path ($_.FullName -Replace [regex]::Escape($sourcePath), $destPath)
        if (!(Test-Path $destDir))
        {
            New-Item -ItemType directory $destDir | Out-Null
        }
        Copy-Item $_ -Destination $destDir}


    

$sourcePath = "\\tfs-build-07\e$\QCModule\Setups\Version ReleaseCandidate\QCModuleBusinessService"
$destPath =  "\\utstage-app4\D$\Services\QCCleanupProcess"



Get-ChildItem $sourcePath -Recurse -Include '*.*' | Foreach-Object `
    {
        $destDir = Split-Path ($_.FullName -Replace [regex]::Escape($sourcePath), $destPath)
        if (!(Test-Path $destDir))
        {
            New-Item -ItemType directory $destDir | Out-Null
        }
        Copy-Item $_ -Destination $destDir}

    

$sourcePath = "\\tfs-build-07\e$\QCModule\Setups\Version ReleaseCandidate\QCModuleBusinessService"
$destPath =  "\\utstage-app4\D$\Services\QCImportProcess"



Get-ChildItem $sourcePath -Recurse -Include '*.*' | Foreach-Object `
    {
        $destDir = Split-Path ($_.FullName -Replace [regex]::Escape($sourcePath), $destPath)
        if (!(Test-Path $destDir))
        {
            New-Item -ItemType directory $destDir | Out-Null
        }
        Copy-Item $_ -Destination $destDir}


$sourcePath = "\\tfs-build-07\e$\QCModule\Setups\Version ReleaseCandidate\QCModule\_PublishedWebsites\QCModule"
$destPath =  "\\utstage-app2\D$\inetpub\Unitrac QC\QCModule" 


Get-ChildItem $sourcePath -Recurse -Include '*.*' | Foreach-Object `
    {
        $destDir = Split-Path ($_.FullName -Replace [regex]::Escape($sourcePath), $destPath)
        if (!(Test-Path $destDir))
        {
            New-Item -ItemType directory $destDir | Out-Null
        }
        Copy-Item $_ -Destination $destDir}

     




Get-ChildItem   "\\as.local\shared\InfoTech\UniTrac_Master_Configs\Test\QA2\QCImportProcess\QCModuleBusinessService.exe.config" |Copy-Item -Destination  "\\utstage-app4\D$\Services\QCImportProcess"  -Force
    
Get-ChildItem   "\\as.local\shared\InfoTech\UniTrac_Master_Configs\Test\QA2\QCCleanupProcess\QCModuleBusinessService.exe.config" |Copy-Item -Destination   "\\utstage-app4\D$\Services\QCCleanupProcess" -Force
 
Get-ChildItem   "\\as.local\shared\InfoTech\UniTrac_Master_Configs\Test\QA2\QCBatchSendProcess\QCModuleBusinessService.exe.config" |Copy-Item -Destination  "\\utstage-app4\D$\Services\QCBatchSendProcess" -Force
    
Get-ChildItem   "\\as.local\shared\InfoTech\UniTrac_Master_Configs\Test\QA2\QCBatchEvaluationProcess\QCModuleBusinessService.exe.config" |Copy-Item -Destination  "\\utstage-app4\D$\Services\QCBatchEvaluationProcess" -Force
  
Get-ChildItem   "\\as.local\shared\InfoTech\UniTrac_Master_Configs\Test\Stage\QCModule\Web.config" |Copy-Item -Destination  "\\utstage-app2\D$\inetpub\Unitrac QC\QCModule" -Force



Get-Service	 -ComputerName	UTQA2-APP3	  -Name	QCBatchEvaluationProcess |  Start-Service
Get-Service	 -ComputerName	UTQA2-APP3	  -Name	QCBatchSendProcess |  Start-Service
Get-Service	 -ComputerName	UTQA2-APP3	  -Name	QCCleanupProcess |  Start-Service

invoke-command -computername UTQA2-APP1 -scriptblock {iisreset /RESTART}

Stop-Transcript

if(Test-Path "C:\logs\PowerShell Logs\StagingQC.txt"){
$destination = "C:\logs\PowerShell Logs\StagingQC"+[DateTime]::Now.ToString("yyyyMMdd-HHmmss")+".txt"
Copy-Item -Path "C:\logs\PowerShell Logs\StagingQC.txt" -Destination $destination
}


Remove-Item -Path "C:\logs\PowerShell Logs\StagingQC.txt"