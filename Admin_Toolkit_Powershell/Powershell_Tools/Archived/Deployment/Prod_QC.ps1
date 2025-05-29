Start-Transcript -Path "C:\logs\PowerShell Logs\ProdQC.txt"


Clear-Host
Write-Output "`n`nThe windows services should be stopped and started separately from this script`n`n"
Start-Sleep -s 3
 

 # prompt user for the main parameter within the path. if they hit enter, use the default
Write-Output "Setup folder in TFS to use?`n"
$version = Read-Host -Prompt  "(enter uses the default of 'Version ReleaseCandidate')"
if( [string]::IsNullOrEmpty($version)){
   $version = "Version ReleaseCandidate"
   }


 # set the source path based on the input from the implementer
$tfsPath = "\\tfs-build-07\e$\QCModule\Setups\$version"

if (test-path -Path $tfsPath){
   Clear-Host
   write-Output "`nThe source path will be    $tfsPath"
   Write-Output "`n(hit Ctrl+C within 6 seconds to cancel) `n`n"
   Start-Sleep -s 7
   }
else {
   Write-Host "$tfsPath `nThat path is not accessible"  
   Return      #would like to loop back here
   }


 #we are good, continue on
Clear-Host



$configRepository = "\\as.local\shared\InfoTech\UniTrac_Master_Configs"




Write-Output "Stopping QC Services"


Get-Service  -ComputerName  Unitrac-WH12  -Name	QCBatchEvaluationProcess |Stop-Service -Force -NoWait
Get-Service  -ComputerName  Unitrac-WH12  -Name	QCBatchSendProcess |Stop-Service -Force -NoWait
Get-Service  -ComputerName  Unitrac-WH12  -Name	QCCleanupProcess |Stop-Service -Force -NoWait
Get-Service  -ComputerName  Unitrac-WH12  -Name	QCImportProcess |Stop-Service -Force -NoWait

Write-Output "Updating the code for QC Services"

#QC Services
$service_names = Get-Content "\\usd-rd02\c$\Powershell Scripts\PowerShell\Deployment Jobs\QC\QC.txt"
Foreach ($service in $service_names){

   $destPath = "\\Unitrac-WH12.colo.as.local\C$\Services\$service\"
   Get-ChildItem -Path $destPath -Recurse | Remove-Item -Force -Recurse  
   Copy-Item -Path "$tfsPath\QCModuleBusinessService\*" -Destination $destPath -Recurse
   Copy-Item -Path "$configRepository\Prod\$service\*.exe.config" -Destination $destPath -Force
   }


Write-Output "Done with QC service"

Write-Output "Working on the QC App"
     
#QC Module App
$service_names = Get-Content "\\usd-rd02\c$\Powershell Scripts\PowerShell\Deployment Jobs\QC\QCModule.txt"
Foreach ($service in $service_names){

   $destPath = "\\Unitrac-APP04.colo.as.local\E$\inetpub\Unitrac QC\"
   Get-ChildItem -Path $destPath -Recurse | Remove-Item -Force -Recurse  
   Copy-Item -Path "$tfsPath\QCModule\_PublishedWebsites\QCModule\*" -Destination $destPath -Recurse
   Copy-Item -Path "$configRepository\Prod\$service\*.exe.config" -Destination $destPath -Force
   }

   
Write-Output "Done with QC App"

sqlcmd -S Unitrac-DB01 -U solarwinds_sql -P S0l@rw1nds -i "\\as.local\shared\InfoTech\Application Administrators\SQL\UniTrac\QC Site Permission Update\Prod.sql"

Write-Output "Permission for QC have been updated"







Get-Service  -ComputerName  Unitrac-WH12  -Name	QCBatchEvaluationProcess |Start-Service
Get-Service  -ComputerName  Unitrac-WH12  -Name	QCBatchSendProcess |Start-Service
Get-Service  -ComputerName  Unitrac-WH12  -Name	QCCleanupProcess |Start-Service
Get-Service  -ComputerName  Unitrac-WH12  -Name	QCImportProcess |Start-Service


Write-Output "Deployment is Complete for QC and services had been started"




Stop-Transcript

if(Test-Path "C:\logs\PowerShell Logs\ProdQC.txt"){
$destination = "C:\logs\PowerShell Logs\ProdQC"+[DateTime]::Now.ToString("yyyyMMdd-HHmmss")+".txt"
Copy-Item -Path "C:\logs\PowerShell Logs\ProdQC.txt" -Destination $destination
}


Remove-Item -Path "C:\logs\PowerShell Logs\ProdQC.txt"