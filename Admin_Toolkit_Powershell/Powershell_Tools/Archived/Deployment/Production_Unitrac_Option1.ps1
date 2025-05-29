#################################
## this deployment script can be run from the local server console or from a desktop remotely.  
## the implementer's windows account will need to be part of the destination servers' local administrators group
## since we are connecting to folders through the admin $ shares.  This should be changed in the future and ideally
## replaced by an agent-based auto deployment utility



 # record the deployment session
$deployLogDestination = "C:\logs\Deployments\ProductionDeployment"+[DateTime]::Now.ToString("yyyyMMdd-HHmmss")+".txt"
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
$Session = New-PSSession -ComputerName Unitrac-APP04
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



 # this remote session finds all web app pools that are running on the server and stops them
 # Would 
$Session = New-PSSession -ComputerName utprod-api-01.colo.as.local
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
(Get-Service -ComputerName VUT-SCAN.colo.as.local -Name 'IISAdmin').stop()


Write-Output "IIS components are stopped"

#################################
## remove UI application files older than the specified number of days
## not sure why we need to do this delete here, or why 7 days
Write-Output "Purging the Unitrac Application Files folder"

$Daysback = "-7"
$CurrentDate = Get-Date
$DatetoDelete = $CurrentDate.AddDays($Daysback)
$unitracAppPath = "\\unitrac-app04\e$\inetpub\wwwroot\UniTrac\Application Files"
Get-ChildItem $unitracAppPath | Where-Object { $_.LastWriteTime -lt $DatetoDelete } | Remove-Item -Recurse


Write-Output "IIS components updated on Unitrac-APP04"

#LDHWebService
$webAppName = "LDHWebService"
$sourcePath = "$tfsPath\LDH\$webAppName\*"
$destPath =  "\\unitrac-app04\e$\inetpub\wwwroot\$webAppName\"
Get-ChildItem -Path $destPath -Recurse | Remove-Item -Force -Recurse  
Copy-Item -Path $sourcePath -Destination $destPath -Recurse -Exclude "*.cs"
Copy-Item -Path "$configRepository\Prod\$webAppName\Web.config" -Destination $destPath -Force



#LenderService (legacy)
$sourcePath = "$tfsPath\LDH\LenderService\*"
$destPath =  "\\unitrac-app04\e$\inetpub\wwwroot\LenderService\"
Get-ChildItem -Path $destPath -Recurse | Remove-Item -Force -Recurse  
Copy-Item -Path $sourcePath -Destination $destPath -Recurse
Copy-Item -Path "$configRepository\Prod\LenderService\Web.config" -Destination $destPath -Force



#QuickPoint
$sourcePath = "$tfsPath\quickpoint\"
$destPath =  "\\unitrac-app04\e$\inetpub\wwwroot\QuickPoint\QuickPoint.WCF\*"
Get-ChildItem -Path $destPath -Recurse | Remove-Item -Force -Recurse  
Copy-Item -Path $sourcePath -Destination $destPath -Recurse
Copy-Item -Path "$configRepository\Prod\QuickPoint_WCF\Web.config" -Destination   "$destPath\QuickPoint.WCF\" -Force


#UnitracSSO
$webAppName = "UnitracSSO"
$sourcePath = "$tfsPath\LDH\$webAppName\*"
$destPath =  "\\unitrac-app04\e$\inetpub\wwwroot\$webAppName\"
Get-ChildItem -Path $destPath -Recurse | Remove-Item -Force -Recurse  
Copy-Item -Path $sourcePath -Destination $destPath -Recurse
Copy-Item -Path "$configRepository\Prod\$webAppName\Web.config" -Destination $destPath -Force


#VehicleLookupService
 # this is good but needs to be changed to a remote pssession.  will that session have permits to pull from source and reposibory?
$webAppName = "VehicleLookupService"
$sourcePath = "$tfsPath\LDH\$webAppName\*"
$destPath =  "\\unitrac-app04\e$\inetpub\wwwroot\$webAppName\"
Get-ChildItem -Path $destPath -Recurse | Remove-Item -Force -Recurse  
Copy-Item -Path $sourcePath -Destination $destPath -Recurse
Copy-Item -Path "$configRepository\Prod\$webAppName\Web.config" -Destination $destPath -Force



Write-Output "IIS components updated on VUT-SCAN"


#LFPWebService (VUT)
$sourcePath = "$tfsPath\LDH\LDHWebService\*"
$destPath =  "\\VUT-SCAN.colo.as.local\c$\inetpub\wwwroot\LFPWebService\"
Get-ChildItem -Path $destPath -Recurse | Remove-Item -Force -Recurse  
Copy-Item -Path $sourcePath -Destination $destPath -Recurse -Exclude "*.cs"
Copy-Item -Path "$configRepository\Prod\LFPWebService\Web.config" -Destination $destPath -Force


Write-Output "IIS components updated on utprod-api-01"




#AuditHistoryService
$webAppName = "AuditHistoryService"
$sourcePath = "$tfsPath\LDH\API\$webAppName\*"
$destPath =  "\\utprod-api-01.colo.as.local\e$\inetpub\UniTrac APIs\$webAppName\"
Get-ChildItem -Path $destPath -Recurse  | Remove-Item -Force -Recurse  
Copy-Item -Path $sourcePath -Destination $destPath -Recurse
Copy-Item -Path "$configRepository\Prod\API\$webAppName\Web.config" -Destination $destPath -Force



#InteractionHistoryService
$webAppName = "InteractionHistoryService"
$sourcePath = "$tfsPath\LDH\API\$webAppName\*"
$destPath =  "\\utprod-api-01.colo.as.local\e$\inetpub\UniTrac APIs\$webAppName\"
Get-ChildItem -Path $destPath -Recurse | Remove-Item -Force -Recurse  
Copy-Item -Path $sourcePath -Destination $destPath -Recurse
Copy-Item -Path "$configRepository\Prod\API\$webAppName\Web.config" -Destination $destPath -Force



#LenderService (API version) 
$sourcePath = "$tfsPath\LDH\API\LenderService\*"
$destPath =  "\\utprod-api-01.colo.as.local\e$\inetpub\UniTrac APIs\LenderService\"
Get-ChildItem -Path $destPath -Recurse | Remove-Item -Force -Recurse  
Copy-Item -Path $sourcePath -Destination $destPath -Recurse
Copy-Item -Path "$configRepository\Prod\API\LenderServiceAPI\Web.config" -Destination $destPath -Force


#NotificationService
$webAppName = "NotificationService"
$sourcePath = "$tfsPath\LDH\API\$webAppName\*"
$destPath =  "\\utprod-api-01.colo.as.local\e$\inetpub\UniTrac APIs\$webAppName\"
Get-ChildItem -Path $destPath -Recurse | Remove-Item -Force -Recurse  
Copy-Item -Path $sourcePath -Destination $destPath -Recurse
Copy-Item -Path "$configRepository\Prod\API\$webAppName\Web.config" -Destination $destPath -Force


#PropertyService
$webAppName = "PropertyService"
$sourcePath = "$tfsPath\LDH\API\$webAppName\*"
$destPath =  "\\utprod-api-01.colo.as.local\e$\inetpub\UniTrac APIs\$webAppName\"
Get-ChildItem -Path $destPath -Recurse | Remove-Item -Force -Recurse  
Copy-Item -Path $sourcePath -Destination $destPath -Recurse
Copy-Item -Path "$configRepository\Prod\API\$webAppName\Web.config" -Destination $destPath -Force


#QCService
$sourcePath = "$tfsPath\LDH\API\QCService\*"
$destPath =  "\\utprod-api-01.colo.as.local\e$\inetpub\UniTrac APIs\QCService\"
Get-ChildItem -Path $destPath -Recurse | Remove-Item -Force -Recurse  
Copy-Item -Path $sourcePath -Destination $destPath -Recurse
Copy-Item -Path "$configRepository\Prod\API\QCServiceAPI\Web.config" -Destination $destPath -Force

#ReferenceDataService
$webAppName = "ReferenceDataService"
$sourcePath = "$tfsPath\LDH\API\$webAppName\*"
$destPath =  "\\utprod-api-01.colo.as.local\e$\inetpub\UniTrac APIs\$webAppName\"
Get-ChildItem -Path $destPath -Recurse | Remove-Item -Force -Recurse  
Copy-Item -Path $sourcePath -Destination $destPath -Recurse
Copy-Item -Path "$configRepository\Prod\API\$webAppName\Web.config" -Destination $destPath -Force


#UTLService
$webAppName = "UTLService"
$sourcePath = "$tfsPath\LDH\API\$webAppName\*"
$destPath =  "\\utprod-api-01.colo.as.local\e$\inetpub\UniTrac APIs\$webAppName\"
Get-ChildItem -Path $destPath -Recurse | Remove-Item -Force -Recurse  
Copy-Item -Path $sourcePath -Destination $destPath -Recurse
Copy-Item -Path "$configRepository\Prod\API\$webAppName\Web.config" -Destination $destPath -Force


#WorkItemService
$webAppName = "WorkItemService"
$sourcePath = "$tfsPath\LDH\API\$webAppName\*"
$destPath =  "\\utprod-api-01.colo.as.local\e$\inetpub\UniTrac APIs\$webAppName\"
Get-ChildItem -Path $destPath -Recurse | Remove-Item -Force -Recurse  
Copy-Item -Path $sourcePath -Destination $destPath -Recurse
Copy-Item -Path "$configRepository\Prod\API\$webAppName\Web.config" -Destination $destPath -Force



#UTLSupportService
$webAppName = "UTLSupportService"
$sourcePath = "$tfsPath\LDH\$webAppName\*"
$destPath =  "\\utprod-api-01.colo.as.local\e$\inetpub\UTL APIs\$webAppName\"
Get-ChildItem -Path $destPath -Recurse  | Remove-Item -Force -Recurse  
Copy-Item -Path $sourcePath -Destination $destPath -Recurse
Copy-Item -Path "$configRepository\Prod\API\$webAppName\Web.config" -Destination $destPath -Force


Write-Output "Done with web apps, starting them up"


#################################
## done with web components, start them all

 
 # this remote session finds all web app pools that are stopped and starts them
$Session = New-PSSession -ComputerName Unitrac-APP04
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
(Get-Service -ComputerName VUT-SCAN.colo.as.local -Name 'IISAdmin').start()


 # this remote session finds all web app pools that are stopped and starts them
$Session = New-PSSession -ComputerName utprod-api-01.colo.as.local
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


Write-Output "Updating Prod Support Tool"

#ProdSupportTool
$sourcePath = "$tfsPath\ProdSupportTool\*"
$destPath =  "\\Unitrac-APP01\e$\Production Support Tool\"
Get-ChildItem -Path $destPath -Recurse | Remove-Item -Force -Recurse  
Copy-Item -Path $sourcePath -Destination $destPath -Recurse
Copy-Item -Path "$configRepository\Prod\ProdSupportTool\ProductionSupportTool.exe.config" -Destination $destPath -Force


Write-Output "Updating SAMU Tool"

#SAMU
$sourcePath = "$tfsPath\SAMU\*"
$destPath =  "\\Unitrac-APP01\e$\SAMU\"
Get-ChildItem -Path $destPath -Recurse | Remove-Item -Force -Recurse  
Copy-Item -Path $sourcePath -Destination $destPath -Recurse
Copy-Item -Path "$configRepository\Prod\SAMU\SAMU.exe.config" -Destination $destPath -Force


Write-Output "Updating Services"

#UnitracBusinessService
$sourcePath = "$tfsPath\LDH\UnitracBusinessService\*"
$destPath =  "\\Unitrac-APP01\c$\Program Files\Allied Solutions\UnitracBusinessService\"
Get-ChildItem -Path $destPath -Recurse | Remove-Item -Force -Recurse  
Copy-Item -Path $sourcePath -Destination $destPath -Recurse
Copy-Item -Path "$configRepository\Prod\UniTracBusinessService\*.exe.config" -Destination $destPath -Force



#LDHServiceUSD
$sourcePath = "$tfsPath\LDH\LDHService\*"
$destPath =  "\\Unitrac-APP02\c$\Program Files\Allied Solutions\LDHServiceUSD\"
Get-ChildItem -Path $destPath -Recurse | Remove-Item -Force -Recurse  
Copy-Item -Path $sourcePath -Destination $destPath -Recurse
Copy-Item -Path "$configRepository\Prod\LDHServiceUSD\*.exe.config" -Destination $destPath -Force


#UniTracBusinessService on Unitrac-APP02
$service_names = Get-Content "\\usd-rd02\c$\Powershell Scripts\PowerShell\Deployment Jobs\Production\Unitac-APP02.txt"
Foreach ($service in $service_names){

   $destPath = "\\Unitrac-APP02\c$\Program Files\Allied Solutions\$service\"
   Get-ChildItem -Path $destPath -Recurse | Remove-Item -Force -Recurse  
   Copy-Item -Path "$tfsPath\LDH\UnitracBusinessService\*" -Destination $destPath -Recurse
   Copy-Item -Path "$configRepository\Prod\$service\*.exe.config" -Destination $destPath -Force
   }


#LDHServicePRCPA
$sourcePath = "$tfsPath\LDH\LDHService\*"
$destPath =  "\\Unitrac-WH01\c$\Program Files\Allied Solutions\LDHServicePRCPA\"
Get-ChildItem -Path $destPath -Recurse | Remove-Item -Force -Recurse  
Copy-Item -Path $sourcePath -Destination $destPath -Recurse
Copy-Item -Path "$configRepository\Prod\LDHServicePRCPA\*.exe.config" -Destination $destPath -Force



#LDHService
$sourcePath = "$tfsPath\LDH\LDHService\*"
$destPath =  "\\Unitrac-WH03\c$\Program Files\Allied Solutions\LDHService\"
Get-ChildItem -Path $destPath -Recurse | Remove-Item -Force -Recurse  
Copy-Item -Path $sourcePath -Destination $destPath -Recurse
Copy-Item -Path "$configRepository\Prod\LDHService\*.exe.config" -Destination $destPath -Force



#LDHServiceADHOC
$sourcePath = "$tfsPath\LDH\LDHService\*"
$destPath =  "\\Unitrac-WH04\c$\Program Files\Allied Solutions\LDHServiceADHOC\"
Get-ChildItem -Path $destPath -Recurse | Remove-Item -Force -Recurse  
Copy-Item -Path $sourcePath -Destination $destPath -Recurse
Copy-Item -Path "$configRepository\Prod\LDHServiceADHOC\*.exe.config" -Destination $destPath -Force



#OspreyWorkflowService
$sourcePath = "$tfsPath\LDH\OspreyWorkflowService\*"
$destPath =  "\\Unitrac-WH04\c$\Program Files\Allied Solutions\OspreyWorkflowService\"
Get-ChildItem -Path $destPath -Recurse | Remove-Item -Force -Recurse  
Copy-Item -Path $sourcePath -Destination $destPath -Recurse
Copy-Item -Path "$configRepository\Prod\OspreyWorkflowService\*.exe.config" -Destination $destPath -Force


#UnitracBusinessServiceMatchOut
$sourcePath = "$tfsPath\LDH\UnitracBusinessService\*"
$destPath =  "\\Unitrac-WH05\c$\Program Files\Allied Solutions\UnitracBusinessServiceMatchOut\"
Get-ChildItem -Path $destPath -Recurse | Remove-Item -Force -Recurse  
Copy-Item -Path $sourcePath -Destination $destPath -Recurse
Copy-Item -Path "$configRepository\Prod\UnitracBusinessServiceMatchOut\*.exe.config" -Destination $destPath -Force


#UnitracBusinessServiceRPT
$sourcePath = "$tfsPath\LDH\UnitracBusinessService\*"
$destPath =  "\\Unitrac-WH06\c$\Program Files\Allied Solutions\UnitracBusinessServiceRPT\"
Get-ChildItem -Path $destPath -Recurse | Remove-Item -Force -Recurse  
Copy-Item -Path $sourcePath -Destination $destPath -Recurse
Copy-Item -Path "$configRepository\Prod\UnitracBusinessServiceRPT\*.exe.config" -Destination $destPath -Force


#LDHServiceHUNT
$sourcePath = "$tfsPath\LDH\LDHService\*"
$destPath =  "\\Unitrac-WH07\c$\Program Files\Allied Solutions\LDHServiceHUNT"
Get-ChildItem -Path $destPath -Recurse | Remove-Item -Force -Recurse  
Copy-Item -Path $sourcePath -Destination $destPath -Recurse
Copy-Item -Path "$configRepository\Prod\LDHServiceHUNT\*.exe.config" -Destination $destPath -Force

#UniTracBusinessService on Unitrac-WH07
$service_names = Get-Content "\\usd-rd02\c$\Powershell Scripts\PowerShell\Deployment Jobs\Production\Unitrac-WH07.txt"
Foreach ($service in $service_names){

   $destPath = "\\Unitrac-WH07\c$\Program Files\Allied Solutions\$service\"
   Get-ChildItem -Path $destPath -Recurse | Remove-Item -Force -Recurse  
   Copy-Item -Path "$tfsPath\LDH\UnitracBusinessService\*" -Destination $destPath -Recurse
   Copy-Item -Path "$configRepository\Prod\$service\*.exe.config" -Destination $destPath -Force
   }

Write-Output "........Still deploying service, currently up to Unitrac-WH08 server"



#Message Service
$service_names = Get-Content  "\\usd-rd02\c$\Powershell Scripts\PowerShell\Deployment Jobs\Staging\Message\Message.txt"
Foreach ($service in $service_names){

   if($service -eq "MSGSRVREXTSANT"){
      $destPath = "\\Unitrac-WH19\C$\Program Files (x86)\AlliedSolutions\LDHServices\$service\"
      }
    #not 100% sure if this will work but it's worth a shot.
   elseif($service -eq "MSGSRVREXTWELLSFARGO" -or $service -eq "MSGSRVREXTSANT"){
      $destPath = "\\Unitrac-WH21\e$\AlliedSolutions\LDHServices\$service\"
      }
   else{   
      $destPath = "\\Unitrac-WH08\C$\Program Files (x86)\AlliedSolutions\LDHServices\$service\"
      }
   Get-ChildItem -Path $destPath -Recurse | Remove-Item -Force -Recurse  
   Copy-Item -Path "$tfsPath\LDH\MessageServer\*" -Destination $destPath -Recurse
   Copy-Item -Path "$configRepository\PROD\$service\*.exe.config" -Destination $destPath -Force
   }
   


#OspreyWorkflowService2
$sourcePath = "$tfsPath\LDH\OspreyWorkflowService\*"
$destPath =  "\\Unitrac-WH10\c$\Program Files\Allied Solutions\OspreyWorkflowService2\"
Get-ChildItem -Path $destPath -Recurse | Remove-Item -Force -Recurse  
Copy-Item -Path $sourcePath -Destination $destPath -Recurse
Copy-Item -Path "$configRepository\Prod\OspreyWorkflowService2\*.exe.config" -Destination $destPath -Force

#OspreyWorkflowService3
$sourcePath = "$tfsPath\LDH\OspreyWorkflowService\*"
$destPath =  "\\Unitrac-WH11\c$\Program Files\Allied Solutions\OspreyWorkflowService3\"
Get-ChildItem -Path $destPath -Recurse | Remove-Item -Force -Recurse  
Copy-Item -Path $sourcePath -Destination $destPath -Recurse
Copy-Item -Path "$configRepository\Prod\OspreyWorkflowService3\*.exe.config" -Destination $destPath -Force


#OspreyWorkflowService4
$sourcePath = "$tfsPath\LDH\OspreyWorkflowService\*"
$destPath =  "\\Unitrac-WH13\c$\Program Files\Allied Solutions\OspreyWorkflowService4\"
Get-ChildItem -Path $destPath -Recurse | Remove-Item -Force -Recurse  
Copy-Item -Path $sourcePath -Destination $destPath -Recurse
Copy-Item -Path "$configRepository\Prod\OspreyWorkflowService4\*.exe.config" -Destination $destPath -Force

#UnitracBusinessServiceBackfeed
$sourcePath = "$tfsPath\LDH\UnitracBusinessService\*"
$destPath =  "\\Unitrac-WH13\c$\Program Files\Allied Solutions\UnitracBusinessServiceBackfeed\"
Get-ChildItem -Path $destPath -Recurse | Remove-Item -Force -Recurse  
Copy-Item -Path $sourcePath -Destination $destPath -Recurse
Copy-Item -Path "$configRepository\Prod\UnitracBusinessServiceBackfeed\*.exe.config" -Destination $destPath -Force




#DirectoryWatchers
$service_names = Get-Content "\\usd-rd02\c$\Powershell Scripts\PowerShell\Deployment Jobs\Production\Unitrac-WH07.txt"
Foreach ($service in $service_names){

   $destPath = "\\Unitrac-WH07\c$\Program Files\Allied Solutions\$service\"
   Get-ChildItem -Path $destPath -Recurse | Remove-Item -Force -Recurse  
   Copy-Item -Path "$tfsPath\LDH\DirectoryWatcherServer\*" -Destination $destPath -Recurse
   Copy-Item -Path "$configRepository\Prod\$service\*.exe.config" -Destination $destPath -Force
   }


#UnitracBusinessServiceCycle3
$sourcePath = "$tfsPath\LDH\UnitracBusinessService\*"
$destPath =  "\\Unitrac-WH16\c$\Program Files\Allied Solutions\UnitracBusinessServiceCycle3\"
Get-ChildItem -Path $destPath -Recurse | Remove-Item -Force -Recurse  
Copy-Item -Path $sourcePath -Destination $destPath -Recurse
Copy-Item -Path "$configRepository\Prod\UnitracBusinessServiceCycle3\*.exe.config" -Destination $destPath -Force



#LetterGen
$sourcePath = "$tfsPath\LDH\UnitracBusinessService\*"
$destPath =  "\\Unitrac-WH18\c$\Program Files\Allied Solutions\LetterGen\"
Get-ChildItem -Path $destPath -Recurse | Remove-Item -Force -Recurse  
Copy-Item -Path $sourcePath -Destination $destPath -Recurse
Copy-Item -Path "$configRepository\Prod\LetterGen\*.exe.config" -Destination $destPath -Force


#LDHServiceSANT
$sourcePath = "$tfsPath\LDH\LDHService\*"
$destPath =  "\\Unitrac-WH19\c$\Program Files\Allied Solutions\LDHServiceSANT\"
Get-ChildItem -Path $destPath -Recurse | Remove-Item -Force -Recurse  
Copy-Item -Path $sourcePath -Destination $destPath -Recurse
Copy-Item -Path "$configRepository\Prod\LDHServiceSANT\*.exe.config" -Destination $destPath -Force



#UniTracBusinessService on Unitrac-WH20
$service_names = Get-Content "\\usd-rd02\c$\Powershell Scripts\PowerShell\Deployment Jobs\Production\Unitrac-WH20.txt"
Foreach ($service in $service_names){

   $destPath = "\\Unitrac-WH20\c$\Program Files\Allied Solutions\$service\"
   Get-ChildItem -Path $destPath -Recurse | Remove-Item -Force -Recurse  
   Copy-Item -Path "$tfsPath\LDH\UnitracBusinessService\*" -Destination $destPath -Recurse
   Copy-Item -Path "$configRepository\Prod\$service\*.exe.config" -Destination $destPath -Force
   }


#OspreyWorkflowService5
$sourcePath = "$tfsPath\LDH\OspreyWorkflowService\*"
$destPath =  "\\Unitrac-WH20\c$\Program Files\Allied Solutions\OspreyWorkflowService5\"
Get-ChildItem -Path $destPath -Recurse | Remove-Item -Force -Recurse  
Copy-Item -Path $sourcePath -Destination $destPath -Recurse
Copy-Item -Path "$configRepository\Prod\OspreyWorkflowService5\*.exe.config" -Destination $destPath -Force



#LDHWellsFargo
$sourcePath = "$tfsPath\LDH\LDHService\*"
$destPath =  "\\Unitrac-WH21\e$\AlliedSolutions\LDHServices\LDHWellsFargo\"
Get-ChildItem -Path $destPath -Recurse | Remove-Item -Force -Recurse  
Copy-Item -Path $sourcePath -Destination $destPath -Recurse
Copy-Item -Path "$configRepository\Prod\LDHWellsFargo\*.exe.config" -Destination $destPath -Force

Write-Output "Final stretch updating the ASR services"

#UBSProc
$sourcePath = "$tfsPath\LDH\UnitracBusinessService\*"
$destPath =  "\\UTPROD-ASR1\c$\Program Files\Allied Solutions\UnitracBusinessServiceDist\"
Get-ChildItem -Path $destPath -Recurse | Remove-Item -Force -Recurse  
Copy-Item -Path $sourcePath -Destination $destPath -Recurse
Copy-Item -Path "$configRepository\Prod\UBSProc\*.exe.config" -Destination $destPath -Force


#UnitracBusinessServiceProc1
$sourcePath = "$tfsPath\LDH\UnitracBusinessService\*"
$destPath =  "\\UTPROD-ASR2\c$\Program Files\Allied Solutions\UnitracBusinessServiceProc1\"
Get-ChildItem -Path $destPath -Recurse | Remove-Item -Force -Recurse  
Copy-Item -Path $sourcePath -Destination $destPath -Recurse
Copy-Item -Path "$configRepository\Prod\UnitracBusinessServiceProc1\*.exe.config" -Destination $destPath -Force



#UnitracBusinessServiceProc2
$sourcePath = "$tfsPath\LDH\UnitracBusinessService\*"
$destPath =  "\\UTPROD-ASR3\c$\Program Files\Allied Solutions\UnitracBusinessServiceProc2\"
Get-ChildItem -Path $destPath -Recurse | Remove-Item -Force -Recurse  
Copy-Item -Path $sourcePath -Destination $destPath -Recurse
Copy-Item -Path "$configRepository\Prod\UnitracBusinessServiceProc2\*.exe.config" -Destination $destPath -Force



#UnitracBusinessServiceProc4
$sourcePath = "$tfsPath\LDH\UnitracBusinessService\*"
$destPath =  "\\UTPROD-ASR4\c$\Program Files\Allied Solutions\UnitracBusinessServiceProc4\"
Get-ChildItem -Path $destPath -Recurse | Remove-Item -Force -Recurse  
Copy-Item -Path $sourcePath -Destination $destPath -Recurse
Copy-Item -Path "$configRepository\Prod\UnitracBusinessServiceProc4\*.exe.config" -Destination $destPath -Force



#UnitracBusinessServiceProc5
$sourcePath = "$tfsPath\LDH\UnitracBusinessService\*"
$destPath =  "\\UTPROD-ASR5\c$\Program Files\Allied Solutions\UnitracBusinessServiceProc5\"
Get-ChildItem -Path $destPath -Recurse | Remove-Item -Force -Recurse  
Copy-Item -Path $sourcePath -Destination $destPath -Recurse
Copy-Item -Path "$configRepository\Prod\UnitracBusinessServiceProc5\*.exe.config" -Destination $destPath -Force

#UnitracBusinessServiceProc6
$sourcePath = "$tfsPath\LDH\UnitracBusinessService\*"
$destPath =  "\\UTPROD-ASR6\c$\Program Files\Allied Solutions\UnitracBusinessServiceProc6\"
Get-ChildItem -Path $destPath -Recurse | Remove-Item -Force -Recurse  
Copy-Item -Path $sourcePath -Destination $destPath -Recurse
Copy-Item -Path "$configRepository\Prod\UnitracBusinessServiceProc6\*.exe.config" -Destination $destPath -Force

#UnitracBusinessServiceProc7
$sourcePath = "$tfsPath\LDH\UnitracBusinessService\*"
$destPath =  "\\UTPROD-ASR7\c$\Program Files\Allied Solutions\UnitracBusinessServiceProc7\"
Get-ChildItem -Path $destPath -Recurse | Remove-Item -Force -Recurse  
Copy-Item -Path $sourcePath -Destination $destPath -Recurse
Copy-Item -Path "$configRepository\Prod\UnitracBusinessServiceProc7\*.exe.config" -Destination $destPath -Force



$serverList = (
"Unitrac-APP01",
"Unitrac-APP02",
"Unitrac-WH01",
"Unitrac-WH03",
"Unitrac-WH04",
"Unitrac-WH05",
"Unitrac-WH06",
"Unitrac-WH07",
"Unitrac-WH08",
"Unitrac-WH09",
"Unitrac-WH10",
"Unitrac-WH11",
"Unitrac-WH12",
"Unitrac-WH13",
"Unitrac-WH14",
"Unitrac-WH16",
"Unitrac-WH16",
"Unitrac-WH18",
"Unitrac-WH19",
"Unitrac-WH20",
"Unitrac-WH21",
"utprod-asr1.colo.as.local",
"utprod-asr2.colo.as.local",
"utprod-asr3.colo.as.local",
"utprod-asr4.colo.as.local",
"utprod-asr5.colo.as.local",
"utprod-asr6.colo.as.local",
"utprod-asr7.colo.as.local"

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

Write-Output "Complete with service install"

 #would rather prompt for permission to run start script but have not figured out how to execute the script remotely yet
Write-Output "`n`n`n Please remember to start the windows services when you are ready! `n`n`n"


Stop-Transcript