#BEFORE STARTING ENSURE THE SOURCEPATH ($SOURCEPATH) HAS BEEN UPDATED TO MOST CURRENT PATH BEFORE DEPLOYING
#BEFORE STARTING ENSURE THE SOURCEPATH ($SOURCEPATH) HAS BEEN UPDATED TO MOST CURRENT PATH BEFORE DEPLOYING

Start-Transcript -Path "\\usd-rd02\c$\logs\PowerShell Logs\ProductionUTL.txt"
Clear-Host
Write-Output "`n`nThe windows services should be stopped and started separately from this script`n`n"
Start-Sleep -s 3
 

 # prompt user for the main parameter within the path. if they hit enter, use the default
Write-Output "Setup folder in TFS to use?`n"
$version = Read-Host -Prompt  "(enter uses the default of 'UTL Release')"
if( [string]::IsNullOrEmpty($version)){
   $version = "UTL Release"
   }


 # set the source path based on the input from the implementer
$tfsPath = "\\tfs-build-06\E$\$version\Build Manager\Deploy"

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


Write-Output "Working on the windows apps"

Write-Output "Working on the UTLBusiness"
#UTLBusinessService
$ServiceName = "UTLBusinessService"
$sourcePath = "$tfsPath\LDH\API\\Build Manager\Deploy\$ServiceName\*"
$destPath =  "\\utprod-utlapp-1.colo.as.local\E$\WindowsServices\$ServiceName\"
Get-ChildItem -Path $destPath -Recurse  | Remove-Item -Force -Recurse  
Copy-Item -Path $sourcePath -Destination $destPath -Recurse
Copy-Item -Path "$configRepository\Prod\$ServiceName\Web.config" -Destination $destPath -Force


Write-Output "Working on the Rematch Services on Unitrac-WH09"
#Rematch Services on WH09
$service_names = Get-Content "\\usd-rd02\c$\Powershell Scripts\PowerShell\Deployment Jobs\Production\UnitracWH09.txt"
Foreach ($service in $service_names){

   $destPath = "\\Unitrac-WH09\c$\Program Files\Allied Solutions\$service\"
   Get-ChildItem -Path $destPath -Recurse | Remove-Item -Force -Recurse  
   Copy-Item -Path "$tfsPath\LDH\API\\Build Manager\Deploy\UTLBusinessService\*" -Destination $destPath -Recurse
   Copy-Item -Path "$configRepository\Prod\$service\*.exe.config" -Destination $destPath -Force
   }


Write-Output "Working on the Rematch Services on Unitrac-WH15"
#Rematch Services on WH15
$service_names = Get-Content "\\usd-rd02\c$\Powershell Scripts\PowerShell\Deployment Jobs\Production\UnitracWH15.txt"
Foreach ($service in $service_names){

   $destPath = "\\Unitrac-WH15\C$\Services\$service\"
   Get-ChildItem -Path $destPath -Recurse | Remove-Item -Force -Recurse  
   Copy-Item -Path "$tfsPath\UTLBusinessService\*" -Destination $destPath -Recurse
   Copy-Item -Path "$configRepository\Prod\$service\*.exe.config" -Destination $destPath -Force
   }

Write-Output "Working on the Match Services on Unitrac-WH16"
#Match Services on WH16
$service_names = Get-Content "\\usd-rd02\c$\Powershell Scripts\PowerShell\Deployment Jobs\Production\UnitracWH16.txt"
Foreach ($service in $service_names){

   $destPath = "\\Unitrac-WH16\e$\Program Files\Allied Solutions\$service\"
   Get-ChildItem -Path $destPath -Recurse | Remove-Item -Force -Recurse  
   Copy-Item -Path "$tfsPath\UTLBusinessService\*" -Destination $destPath -Recurse
   Copy-Item -Path "$configRepository\Prod\$service\*.exe.config" -Destination $destPath -Force
   }

Write-Output "Working on APIs"

#APIs
$service_names = Get-Content "\\usd-rd02\c$\Powershell Scripts\PowerShell\Deployment Jobs\Production\utprod-api-01.txt"
Foreach ($webservice in $service_names){

   $destPath = "\\utprod-api-01.colo.as.local\e$\inetpub\UTL APIs\$webservice\"
   Get-ChildItem -Path $destPath -Recurse | Remove-Item -Force -Recurse  
   Copy-Item -Path "$tfsPath\UTLApi\*" -Destination $destPath -Recurse
   Copy-Item -Path "$configRepository\Prod\$webservice\Web.config" -Destination $destPath -Force
   }


Write-Output "Deployment Complete"

  
Stop-Transcript

if(Test-Path "\\usd-rd02\c$\logs\PowerShell Logs\ProductionUTL.txt"){
$destination = "\\usd-rd02\c$\logs\PowerShell Logs\ProductionUTL"+[DateTime]::Now.ToString("yyyyMMdd-HHmmss")+".txt"
Copy-Item -Path "\\usd-rd02\c$\logs\PowerShell Logs\ProductionUTL.txt" -Destination $destination
}


Remove-Item -Path "\\usd-rd02\c$\logs\PowerShell Logs\ProductionUTL.txt"

Invoke-item $deployLogDestination