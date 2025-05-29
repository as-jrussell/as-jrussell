#################################
## this deployment script can be run from the local server console or from a desktop remotely.  
## the implementer's windows account will need to be part of the destination servers' local administrators group
## since we are connecting to folders through the admin $ shares.  This should be changed in the future and ideally
## replaced by an agent-based auto deployment utility



 # record the deployment session
$deployLogDestination = "C:\logs\Deployments\QADeployment"+[DateTime]::Now.ToString("yyyyMMdd-HHmmss")+".txt"
Start-Transcript -Path $deployLogDestination


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
$tfsPath = "\\tfs-build-06\E$\UniTrac\Setups\$version"

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



 
 # this remote session finds all web app pools that are running on the server and stops them
$Session = New-PSSession -ComputerName UTQA2-APP1
$appPoolStopBlock = {
   Import-Module WebAdministration

   $websites = Get-ChildItem -Path IIS:Sites 

   foreach( $site in $websites ) { 
     $siteName = $site.name
     $siteAppPool = $site.applicationPool
     $appPoolState = ((Get-WebAppPoolState -name $siteAppPool).Value)
     
     if ( $appPoolState -eq "Started"){
        Write-Output "$siteName  application pool stopping"
        Stop-WebAppPool -name $siteAppPool
        }
     } #end of foreach

 }  #end script block
Invoke-Command -Session $Session -ScriptBlock $appPoolStopBlock 



 # stop IIS on the vut web server
#(Get-Service -ComputerName VUTQA01 -Name 'IISAdmin').stop()


Write-Output "IIS components are stopped"



#################################
## remove UI application files older than the specified number of days
## not sure why we need to do this delete here, or why 7 days
Write-Output "Purging the Unitrac Application Files folder"

$Daysback = "-7"
$CurrentDate = Get-Date
$DatetoDelete = $CurrentDate.AddDays($Daysback)
$unitracAppPath = "\\utqa2-app1\c$\inetpub\wwwroot\UniTrac\Application Files"
Get-ChildItem $unitracAppPath | Where-Object { $_.LastWriteTime -lt $DatetoDelete } | Remove-Item -Recurse







#################################
## remove existing content at the deployment destination, copy web content files from the tfs source to the destination
## and replace the config files deployed from the tfs source with the curated ones from the repository
## This list is in alphabetical order, not by type, location, or purpose

Write-Output "Working on the web apps"

#AuditHistoryService
$webAppName = "AuditHistoryService"
$sourcePath = "$tfsPath\LDH\API\$webAppName\*"
$destPath =  "\\utqa2-app1\c$\inetpub\UniTrac APIs\$webAppName\"
Get-ChildItem -Path $destPath -Recurse  | Remove-Item -Force -Recurse  
Copy-Item -Path $sourcePath -Destination $destPath -Recurse
Copy-Item -Path "$configRepository\Test\QA2\$webAppName\Web.config" -Destination $destPath -Force



#InteractionHistoryService
$webAppName = "InteractionHistoryService"
$sourcePath = "$tfsPath\LDH\API\$webAppName\*"
$destPath =  "\\utqa2-app1\c$\inetpub\UniTrac APIs\$webAppName\"
Get-ChildItem -Path $destPath -Recurse | Remove-Item -Force -Recurse  
Copy-Item -Path $sourcePath -Destination $destPath -Recurse
Copy-Item -Path "$configRepository\Test\QA2\$webAppName\Web.config" -Destination $destPath -Force



#LDHWebService
$webAppName = "LDHWebService"
$sourcePath = "$tfsPath\LDH\$webAppName\*"
$destPath =  "\\utqa2-app1\c$\inetpub\wwwroot\$webAppName\"
Get-ChildItem -Path $destPath -Recurse | Remove-Item -Force -Recurse  
Copy-Item -Path $sourcePath -Destination $destPath -Recurse -Exclude "*.cs"
Copy-Item -Path "$configRepository\Test\QA2\$webAppName\Web.config" -Destination $destPath -Force



#LenderService (legacy)
$sourcePath = "$tfsPath\LDH\LenderService\*"
$destPath =  "\\utqa2-app1\c$\inetpub\wwwroot\LenderService\"
Get-ChildItem -Path $destPath -Recurse | Remove-Item -Force -Recurse  
Copy-Item -Path $sourcePath -Destination $destPath -Recurse
Copy-Item -Path "$configRepository\Test\QA2\LenderService\Web.config" -Destination $destPath -Force



#LenderService (API version) 
#ideally rename this webservice LenderServiceAPI to differentiate from legacy and make use of $service variable
$sourcePath = "$tfsPath\LDH\API\LenderService\*"
$destPath =  "\\utqa2-app1\c$\inetpub\UniTrac APIs\LenderService\"
Get-ChildItem -Path $destPath -Recurse | Remove-Item -Force -Recurse  
Copy-Item -Path $sourcePath -Destination $destPath -Recurse
Copy-Item -Path "$configRepository\Test\QA2\LenderServiceAPI\Web.config" -Destination $destPath -Force



#LFPWebService (VUT)
$sourcePath = "$tfsPath\LDH\LDHWebService\*"
$destPath =  "\\vutqa01\c$\inetpub\wwwroot\LFPWebService\"
Get-ChildItem -Path $destPath -Recurse | Remove-Item -Force -Recurse  
Copy-Item -Path $sourcePath -Destination $destPath -Recurse -Exclude "*.cs"
Copy-Item -Path "$configRepository\Test\QA2\LFPWebService\Web.config" -Destination $destPath -Force



#NotificationService
$webAppName = "NotificationService"
$sourcePath = "$tfsPath\LDH\API\$webAppName\*"
$destPath =  "\\utqa2-app1\c$\inetpub\UniTrac APIs\$webAppName\"
Get-ChildItem -Path $destPath -Recurse | Remove-Item -Force -Recurse  
Copy-Item -Path $sourcePath -Destination $destPath -Recurse
Copy-Item -Path "$configRepository\Test\QA2\$webAppName\Web.config" -Destination $destPath -Force



#PropertyService
$webAppName = "PropertyService"
$sourcePath = "$tfsPath\LDH\API\$webAppName\*"
$destPath =  "\\utqa2-app1\c$\inetpub\UniTrac APIs\$webAppName\"
Get-ChildItem -Path $destPath -Recurse | Remove-Item -Force -Recurse  
Copy-Item -Path $sourcePath -Destination $destPath -Recurse
Copy-Item -Path "$configRepository\Test\QA2\$webAppName\Web.config" -Destination $destPath -Force



#QCService
$sourcePath = "$tfsPath\LDH\API\QCService\*"
$destPath =  "\\utqa2-app1\c$\inetpub\UniTrac APIs\QCService\"
Get-ChildItem -Path $destPath -Recurse | Remove-Item -Force -Recurse  
Copy-Item -Path $sourcePath -Destination $destPath -Recurse
Copy-Item -Path "$configRepository\Test\QA2\QCServiceAPI\Web.config" -Destination $destPath -Force



#QuickPoint
$sourcePath = "$tfsPath\quickpoint\*"
$destPath =  "\\utqa2-app1\c$\inetpub\wwwroot\QuickPoint\"
Get-ChildItem -Path $destPath -Recurse | Remove-Item -Force -Recurse  
Copy-Item -Path $sourcePath -Destination $destPath -Recurse
Copy-Item -Path "$configRepository\Test\QA2\QuickPointWCF\Web.config" -Destination   "$destPath\QuickPoint.WCF\" -Force
Copy-Item -Path "$configRepository\Test\QA2\QuickPointAuth\Web.config" -Destination   "$destPath\QuickPoint.Auth\" -Force
Copy-Item -Path "$configRepository\Test\QA2\QuickPointWeb\Web.config" -Destination   "$destPath\QuickPointWeb\" -Force



#ReferenceDataService
$webAppName = "ReferenceDataService"
$sourcePath = "$tfsPath\LDH\API\$webAppName\*"
$destPath =  "\\utqa2-app1\c$\inetpub\UniTrac APIs\$webAppName\"
Get-ChildItem -Path $destPath -Recurse | Remove-Item -Force -Recurse  
Copy-Item -Path $sourcePath -Destination $destPath -Recurse
Copy-Item -Path "$configRepository\Test\QA2\$webAppName\Web.config" -Destination $destPath -Force



#UnitracSSO
$webAppName = "UnitracSSO"
$sourcePath = "$tfsPath\LDH\$webAppName\*"
$destPath =  "\\utqa2-app1\c$\inetpub\wwwroot\$webAppName\"
Get-ChildItem -Path $destPath -Recurse | Remove-Item -Force -Recurse  
Copy-Item -Path $sourcePath -Destination $destPath -Recurse
Copy-Item -Path "$configRepository\Test\QA2\$webAppName\Web.config" -Destination $destPath -Force



#UTLService
$webAppName = "UTLService"
$sourcePath = "$tfsPath\LDH\API\$webAppName\*"
$destPath =  "\\utqa2-app1\c$\inetpub\UniTrac APIs\$webAppName\"
Get-ChildItem -Path $destPath -Recurse | Remove-Item -Force -Recurse  
Copy-Item -Path $sourcePath -Destination $destPath -Recurse
Copy-Item -Path "$configRepository\Test\QA2\$webAppName\Web.config" -Destination $destPath -Force



#UTLSupportService
$webAppName = "UTLSupportService"
$sourcePath = "$tfsPath\LDH\API\$webAppName\*"
$destPath =  "\\utqa2-app1\c$\inetpub\UniTrac APIs\$webAppName\"
Get-ChildItem -Path $destPath -Recurse  | Remove-Item -Force -Recurse  
Copy-Item -Path $sourcePath -Destination $destPath -Recurse
Copy-Item -Path "$configRepository\Test\QA2\$webAppName\Web.config" -Destination $destPath -Force



#VehicleLookupService
 # this is good but needs to be changed to a remote pssession.  will that session have permits to pull from source and reposibory?
$webAppName = "VehicleLookupService"
$sourcePath = "$tfsPath\LDH\$webAppName\*"
$destPath =  "\\utqa2-app1\c$\inetpub\wwwroot\$webAppName\"
Get-ChildItem -Path $destPath -Recurse | Remove-Item -Force -Recurse  
Copy-Item -Path $sourcePath -Destination $destPath -Recurse
Copy-Item -Path "$configRepository\Test\QA2\$webAppName\Web.config" -Destination $destPath -Force



#WorkItemService
$webAppName = "WorkItemService"
$sourcePath = "$tfsPath\LDH\API\$webAppName\*"
$destPath =  "\\utqa2-app1\c$\inetpub\UniTrac APIs\$webAppName\"
Get-ChildItem -Path $destPath -Recurse | Remove-Item -Force -Recurse  
Copy-Item -Path $sourcePath -Destination $destPath -Recurse
Copy-Item -Path "$configRepository\Test\QA2\$webAppName\Web.config" -Destination $destPath -Force


Write-Output "Done with web apps, starting them up"


#################################
## done with web components, start them all

 
 # this remote session finds all web app pools that are stopped and starts them
$Session = New-PSSession -ComputerName UTQA2-APP1
$appPoolStartBlock = {
   Import-Module WebAdministration

   $websites = Get-ChildItem -Path IIS:Sites 

   foreach( $site in $websites ) { 
     $siteName = $site.name
     $siteAppPool = $site.applicationPool
     $appPoolState = ((Get-WebAppPoolState -name $siteAppPool).Value)
     if ( $appPoolState -eq "Stopped"){
        Start-WebAppPool -name $siteAppPool
        }
     } #end of foreach
 }  #end script block
Invoke-Command -Session $Session -ScriptBlock $appPoolStartBlock


 # start IIS on the vut web server
#(Get-Service -ComputerName vutqa01 -Name 'IISAdmin').start()





 





#################################
## remove existing content from the deployment destination, copy windows service content files from the tfs source to the destination
## and replace the config files deployed from the tfs source with the curated ones from the repository
## some service names are contained in the referenced txt files, hence the foreach to work off of the list
## This list is in alphabetical order, not by type, location, or purpose


Write-Output "Working on the windows apps"


#Directory Watcher
$service_names = Get-Content "\\usd-rd02\c$\Powershell Scripts\PowerShell\Deployment Jobs\QA2\DW\DW.txt"
Foreach ($service in $service_names){

   $destPath = "\\utqa2-app1\c$\Program Files\Allied Solutions\$service\"
   Get-ChildItem -Path $destPath -Recurse | Remove-Item -Force -Recurse  
   Copy-Item -Path "$tfsPath\LDH\DirectoryWatcherServer\*" -Destination $destPath -Recurse
   Copy-Item -Path "$configRepository\Test\QA2\$service\*.exe.config" -Destination $destPath -Force
   }




#LDH Service
$service_names = Get-Content "\\usd-rd02\c$\Powershell Scripts\PowerShell\Deployment Jobs\QA2\LDH\LDH.txt"
Foreach ($service in $service_names){

   $destPath = "\\utqa2-app2\E$\Program Files\Allied Solutions\$service\"
   Get-ChildItem -Path $destPath -Recurse | Remove-Item -Force -Recurse  
   Copy-Item -Path "$tfsPath\LDH\LDHService\*" -Destination $destPath -Recurse
   Copy-Item -Path "$configRepository\Test\QA2\$service\*.exe.config" -Destination $destPath -Force
   }





#LDH Service
$service_names = Get-Content "\\usd-rd02\c$\Powershell Scripts\PowerShell\Deployment Jobs\QA2\WF\WF.txt"
Foreach ($service in $service_names){

   $destPath = "\\utqa2-app2\E$\Program Files\Allied Solutions\$service\"
   Get-ChildItem -Path $destPath -Recurse | Remove-Item -Force -Recurse  
   Copy-Item -Path "$tfsPath\LDH\OspreyWorkflowService\*" -Destination $destPath -Recurse
   Copy-Item -Path "$configRepository\Test\QA2\$service\*.exe.config" -Destination $destPath -Force
   }




#Message Service
$service_names = Get-Content  "\\usd-rd02\c$\Powershell Scripts\PowerShell\Deployment Jobs\QA2\Message\Message.txt"
Foreach ($service in $service_names){

   $destPath = "\\utqa2-app4.rd.as.local\E$\Services\$service\"
   Get-ChildItem -Path $destPath -Recurse | Remove-Item -Force -Recurse  
   Copy-Item -Path "$tfsPath\LDH\MessageServer\*" -Destination $destPath -Recurse
   Copy-Item -Path "$configRepository\Test\QA2\$service\*.exe.config" -Destination $destPath -Force
   }
   



#UBS ASR Services
$service_names = Get-Content  "\\usd-rd02\c$\Powershell Scripts\PowerShell\Deployment Jobs\QA2\UBS\ASR1.txt"
Foreach ($service in $service_names){

   $destPath = "\\UTQA2-ASR1\c$\Program Files\Allied Solutions\$service\"
   Get-ChildItem -Path $destPath -Recurse | Remove-Item -Force -Recurse  
   Copy-Item -Path "$tfsPath\LDH\UnitracBusinessService\*" -Destination $destPath -Recurse
   Copy-Item -Path "$configRepository\Test\QA2\$service\*.exe.config" -Destination $destPath -Force
   }




#UBS ASR Services
$service_names = Get-Content "\\usd-rd02\c$\Powershell Scripts\PowerShell\Deployment Jobs\QA2\UBS\ASR2.txt"
Foreach ($service in $service_names){

   $destPath = "\\UTQA2-ASR2\E$\Program Files\Allied Solutions\$service\"
   Get-ChildItem -Path $destPath -Recurse | Remove-Item -Force -Recurse  
   Copy-Item -Path "$tfsPath\LDH\UnitracBusinessService\*" -Destination $destPath -Recurse
   Copy-Item -Path "$configRepository\Test\QA2\$service\*.exe.config" -Destination $destPath -Force
   }




#UBS ASR Services
$service_names = Get-Content "\\usd-rd02\c$\Powershell Scripts\PowerShell\Deployment Jobs\QA2\UBS\ASR3.txt"
Foreach ($service in $service_names){

   $destPath = "\\UTQA2-ASR3\c$\Program Files\Allied Solutions\$service\"
   Get-ChildItem -Path $destPath -Recurse | Remove-Item -Force -Recurse  
   Copy-Item -Path "$tfsPath\LDH\UnitracBusinessService\*" -Destination $destPath -Recurse
   Copy-Item -Path "$configRepository\Test\QA2\$service\*.exe.config" -Destination $destPath -Force
   }




#UBS Service
$service_names = Get-Content "\\usd-rd02\c$\Powershell Scripts\PowerShell\Deployment Jobs\QA2\UBS\UBS.txt"
Foreach ($service in $service_names){

   $destPath = "\\utqa2-app3\E$\Services\Unitrac\$service\"
   Get-ChildItem -Path $destPath -Recurse | Remove-Item -Force -Recurse  
   Copy-Item -Path "$tfsPath\LDH\UnitracBusinessService\*" -Destination $destPath -Recurse
   Copy-Item -Path "$configRepository\Test\QA2\$service\*.exe.config" -Destination $destPath -Force
   }



## utilities

#ProdSupportTool
$sourcePath = "$tfsPath\ProdSupportTool\*"
$destPath =  "\\utqa2-app1\c$\ProdSupportTool\"
Get-ChildItem -Path $destPath -Recurse | Remove-Item -Force -Recurse  
Copy-Item -Path $sourcePath -Destination $destPath -Recurse
Copy-Item -Path "$configRepository\Test\QA2\ProdSupportTool\ProductionSupportTool.exe.config" -Destination $destPath -Force



#SAMU
$sourcePath = "$tfsPath\SAMU\*"
$destPath =  "\\utqa2-app1\c$\SAMU\"
Get-ChildItem -Path $destPath -Recurse | Remove-Item -Force -Recurse  
Copy-Item -Path $sourcePath -Destination $destPath -Recurse
Copy-Item -Path "$configRepository\Test\QA2\SAMU\SAMU.exe.config" -Destination $destPath -Force



Write-Output "Done with Windows apps"

#################################
## done with windows services
## not sure why were checking status now since we know they are off... should we give a prompt to start them here?


 # roll through each server and get the status of all windows services included in the list
$serverList = (
"UTQA2-APP1",
"UTQA2-APP2",
"UTQA2-APP3",
"UTQA2-APP4",
"UTQA2-ASR1",
"UTQA2-ASR2",
"UTQA2-ASR3"
)
Foreach ($server in $serverList) {
 #this remote session gets service status for each item in the list
$Session = New-PSSession -ComputerName $server
$serviceControlBlock = {
 
$serviceList = (
"DirectoryWatcher*",
"Fax*",
"LDH*",
"LetterGen*",
"LIMC*",
"Message*",
"MSGSRV*",
"Osprey*",
"QC*",
"Unitrac*",
"UTL*",
"Workflow*"
)

Get-Service  -DisplayName $serviceList | where {$_.StartType -ne "Disabled"} | sort-object status | format-table -Property DisplayName -groupby status 

 }  #end script block

Invoke-Command -ComputerName $server -ScriptBlock {hostname}
Invoke-Command -Session $Session -ScriptBlock $serviceControlBlock

} #end foreach server


 #would rather prompt for permission to run start script but have not figured out how to execute the script remotely yet
Write-Output "`n`n`n Please remember to start the windows services when you are ready! `n`n`n"


Stop-Transcript

