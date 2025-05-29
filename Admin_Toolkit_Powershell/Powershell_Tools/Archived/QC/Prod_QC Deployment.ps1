Start-Transcript -Path "C:\logs\PowerShell Logs\ProdQC.txt"



Get-Service  -ComputerName  Unitrac-WH12  -Name	QCBatchEvaluationProcess |Stop-Service -Force -NoWait
Get-Service  -ComputerName  Unitrac-WH12  -Name	QCBatchSendProcess |Stop-Service -Force -NoWait
Get-Service  -ComputerName  Unitrac-WH12  -Name	QCCleanupProcess |Stop-Service -Force -NoWait
Get-Service  -ComputerName  Unitrac-WH12  -Name	QCImportProcess |Stop-Service -Force -NoWait

Get-ChildItem -Path "\\Unitrac-WH12.colo.as.local\C$\Services\QCBatchEvaluationProcess" -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue

Get-ChildItem -Path "\\Unitrac-WH12.colo.as.local\C$\Services\QCBatchSendProcess" -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue

Get-ChildItem -Path "\\Unitrac-WH12.colo.as.local\C$\Services\QCCleanupProcess" -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue

Get-ChildItem -Path "\\Unitrac-WH12.colo.as.local\C$\Services\QCImportProcess" -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue

Get-ChildItem -Path "\\utstage-app2\D$\inetpub\Unitrac QC\QCModule" -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue






#BEFORE STARTING ENSURE THE SOURCEPATH ($SOURCEPATH) HAS BEEN UPDATED TO MOST CURRENT PATH BEFORE DEPLOYING
$sourcePath = "\\tfs-build-07\e$\QCModule\Setups\Version ReleaseCandidate\QCModuleBusinessService"
$destPath =  "\\Unitrac-WH12.colo.as.local\C$\Services\QCBatchEvaluationProcess"


Get-ChildItem $sourcePath -Recurse -Include '*.*' | Foreach-Object `
    {
        $destDir = Split-Path ($_.FullName -Replace [regex]::Escape($sourcePath), $destPath)
        if (!(Test-Path $destDir))
        {
            New-Item -ItemType directory $destDir | Out-Null
        }
        Copy-Item $_ -Destination $destDir}

    

#BEFORE STARTING ENSURE THE SOURCEPATH ($SOURCEPATH) HAS BEEN UPDATED TO MOST CURRENT PATH BEFORE DEPLOYING
$sourcePath = "\\tfs-build-07\e$\QCModule\Setups\Version ReleaseCandidate\QCModuleBusinessService"
$destPath =  "\\Unitrac-WH12.colo.as.local\C$\Services\QCBatchSendProcess"



Get-ChildItem $sourcePath -Recurse -Include '*.*' | Foreach-Object `
    {
        $destDir = Split-Path ($_.FullName -Replace [regex]::Escape($sourcePath), $destPath)
        if (!(Test-Path $destDir))
        {
            New-Item -ItemType directory $destDir | Out-Null
        }
        Copy-Item $_ -Destination $destDir}


    

#BEFORE STARTING ENSURE THE SOURCEPATH ($SOURCEPATH) HAS BEEN UPDATED TO MOST CURRENT PATH BEFORE DEPLOYING
$sourcePath = "\\tfs-build-07\e$\QCModule\Setups\Version ReleaseCandidate\QCModuleBusinessService"
$destPath =  "\\Unitrac-WH12.colo.as.local\C$\Services\QCCleanupProcess"



Get-ChildItem $sourcePath -Recurse -Include '*.*' | Foreach-Object `
    {
        $destDir = Split-Path ($_.FullName -Replace [regex]::Escape($sourcePath), $destPath)
        if (!(Test-Path $destDir))
        {
            New-Item -ItemType directory $destDir | Out-Null
        }
        Copy-Item $_ -Destination $destDir}

    

#BEFORE STARTING ENSURE THE SOURCEPATH ($SOURCEPATH) HAS BEEN UPDATED TO MOST CURRENT PATH BEFORE DEPLOYING
$sourcePath = "\\tfs-build-07\e$\QCModule\Setups\Version ReleaseCandidate\QCModuleBusinessService"
$destPath =  "\\Unitrac-WH12.colo.as.local\C$\Services\QCImportProcess"



Get-ChildItem $sourcePath -Recurse -Include '*.*' | Foreach-Object `
    {
        $destDir = Split-Path ($_.FullName -Replace [regex]::Escape($sourcePath), $destPath)
        if (!(Test-Path $destDir))
        {
            New-Item -ItemType directory $destDir | Out-Null
        }
        Copy-Item $_ -Destination $destDir}


#BEFORE STARTING ENSURE THE SOURCEPATH ($SOURCEPATH) HAS BEEN UPDATED TO MOST CURRENT PATH BEFORE DEPLOYING
$sourcePath = "\\tfs-build-07\e$\QCModule\Setups\Version ReleaseCandidate\QCModule\_PublishedWebsites\QCModule"
$destPath =  "\\Unitrac-APP04.colo.as.local\E$\inetpub\Unitrac QC\QCModule" 


Get-ChildItem $sourcePath -Recurse -Include '*.*' | Foreach-Object `
    {
        $destDir = Split-Path ($_.FullName -Replace [regex]::Escape($sourcePath), $destPath)
        if (!(Test-Path $destDir))
        {
            New-Item -ItemType directory $destDir | Out-Null
        }
        Copy-Item $_ -Destination $destDir}

     




Get-ChildItem   "\\as.local\shared\InfoTech\UniTrac_Master_Configs\Prod\QCImportProcess\QCModuleBusinessService.exe.config" |Copy-Item -Destination  "\\Unitrac-WH12.colo.as.local\C$\Services\QCImportProcess"  -Force
    
Get-ChildItem   "\\as.local\shared\InfoTech\UniTrac_Master_Configs\Prod\QCCleanupProcess\QCModuleBusinessService.exe.config" |Copy-Item -Destination   "\\Unitrac-WH12.colo.as.local\C$\Services\QCCleanupProcess" -Force
 
Get-ChildItem   "\\as.local\shared\InfoTech\UniTrac_Master_Configs\Prod\QCBatchSendProcess\QCModuleBusinessService.exe.config" |Copy-Item -Destination  "\\Unitrac-WH12.colo.as.local\C$\Services\QCBatchSendProcess" -Force
    
Get-ChildItem   "\\as.local\shared\InfoTech\UniTrac_Master_Configs\Prod\QCBatchEvaluationProcess\QCModuleBusinessService.exe.config" |Copy-Item -Destination  "\\Unitrac-WH12.colo.as.local\C$\Services\QCBatchEvaluationProcess" -Force
  
Get-ChildItem   "\\as.local\shared\InfoTech\UniTrac_Master_Configs\Prod\QCModule\Web.config" |Copy-Item -Destination  "\\Unitrac-APP04.colo.as.local\E$\inetpub\Unitrac QC\QCModule" -Force



Get-Service  -ComputerName  Unitrac-WH12  -Name	QCBatchEvaluationProcess |Start-Service
Get-Service  -ComputerName  Unitrac-WH12  -Name	QCBatchSendProcess |Start-Service
Get-Service  -ComputerName  Unitrac-WH12  -Name	QCCleanupProcess |Start-Service
Get-Service  -ComputerName  Unitrac-WH12  -Name	QCImportProcess |Start-Service


invoke-command -computername Unitrac-APP04.colo.as.local -scriptblock {iisreset /RESTART}

Stop-Transcript

if(Test-Path "C:\logs\PowerShell Logs\ProdQC.txt"){
$destination = "C:\logs\PowerShell Logs\ProdQC"+[DateTime]::Now.ToString("yyyyMMdd-HHmmss")+".txt"
Copy-Item -Path "C:\logs\PowerShell Logs\ProdQC.txt" -Destination $destination
}


Remove-Item -Path "C:\logs\PowerShell Logs\ProdQC.txt"