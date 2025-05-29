Start-Transcript -Path "\\usd-rd02\c$\logs\PowerShell Logs\StageUTL.txt"
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
$sourcePath = "$tfsPath\UTLBusinessService\*"
$destPath =  "\\utstage-app3\c$\Program Files\Allied Solutions\$ServiceName\"
Get-ChildItem -Path $destPath -Recurse  | Remove-Item -Force -Recurse  
Copy-Item -Path $sourcePath -Destination $destPath -Recurse
Copy-Item -Path "$configRepository\Test\Stage\$ServiceName\Web.config" -Destination $destPath -Force


Write-Output "Working on the Match Services on UTSTAGE-APP1"
#Match Services on UTSTAGE-APP1
$ServiceName = "UnitracBusinessServiceMatchIn"
$sourcePath = "$tfsPath\UTLBusinessService\*"
$destPath =  "\\utstage-app1\e$\Services\$ServiceName\"
Get-ChildItem -Path $destPath -Recurse  | Remove-Item -Force -Recurse  
Copy-Item -Path $sourcePath -Destination $destPath -Recurse
Copy-Item -Path "$configRepository\Test\Stage\$ServiceName\Web.config" -Destination $destPath -Force

Write-Output "Working on the Rematch Services on UnitracBusinessServiceMatchIn2"
#Rematch Services on \UnitracBusinessServiceMatchIn2
$ServiceName = "UnitracBusinessServiceMatchIn2"
$sourcePath = "$tfsPath\UTLBusinessService\*"
$destPath =  "\\utstage-app4\c$\Program Files\Allied Solutions\$ServiceName\"
Get-ChildItem -Path $destPath -Recurse  | Remove-Item -Force -Recurse  
Copy-Item -Path $sourcePath -Destination $destPath -Recurse
Copy-Item -Path "$configRepository\Test\Stage\$ServiceName\Web.config" -Destination $destPath -Force

Write-Output "Working on APIs"

#APIs
$service_names = Get-Content "\\usd-rd02\c$\Powershell Scripts\PowerShell\Deployment Jobs\UTL\api.txt"
Foreach ($webservice in $service_names){

   $destPath = "\\UTSTAGE-APP2.rd.as.local\d$\inetpub\UTL APIs\$webservice\"
   Get-ChildItem -Path $destPath -Recurse | Remove-Item -Force -Recurse  
   Copy-Item -Path "$tfsPath\UTLApi\*" -Destination $destPath -Recurse
   Copy-Item -Path "$configRepository\Test\Stage\$webservice\Web.config" -Destination $destPath -Force
   }


Write-Output "Deployment Complete"

  
Stop-Transcript

if(Test-Path "\\usd-rd02\c$\logs\PowerShell Logs\StageUTL.txt"){
$destination = "\\usd-rd02\c$\logs\PowerShell Logs\StageUTL"+[DateTime]::Now.ToString("yyyyMMdd-HHmmss")+".txt"
Copy-Item -Path "\\usd-rd02\c$\logs\PowerShell Logs\StageUTL.txt" -Destination $destination
}


Remove-Item -Path "\\usd-rd02\c$\logs\PowerShell Logs\StageUTL.txt"

Invoke-item $deployLogDestination