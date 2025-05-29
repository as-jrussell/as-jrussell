#################################
## this deployment script can be run from the local server console or from a desktop remotely.  
## the implementer's windows account will need to be part of the destination servers' local administrators group
## since we are connecting to folders through the admin $ shares.  This should be changed in the future and ideally
## replaced by an agent-based auto deployment utility



 # record the deployment session
$deployLogDestination = "C:\logs\Deployments\StageDeployment"+[DateTime]::Now.ToString("yyyyMMdd-HHmmss")+".txt"
Start-Transcript -Path $deployLogDestination


Clear-Host
Write-Output "`n`nThe windows services should be stopped and started separately from this script`n`n"
Start-Sleep -s 3
 


 #we are good, continue on
Clear-Host



$configRepository = "\\as.local\shared\InfoTech\UniTrac_Master_Configs\ArchivedConfigs"



 
 # this remote session finds all web app pools that are running on the server and stops them
$Session = New-PSSession -ComputerName UTSTAGE-APP2
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
#(Get-Service -ComputerName VUTSTAGE01 -Name 'IISAdmin').stop()


Write-Output "IIS components are stopped"







#################################
## remove existing content at the deployment destination, copy web content files from the tfs source to the destination
## and replace the config files deployed from the tfs source with the curated ones from the repository
## This list is in alphabetical order, not by type, location, or purpose

Write-Output "Working on the web apps"

#AuditHistoryService
$webAppName = "AuditHistoryService"
$destPath =  "\\utstage-app2\d$\inetpub\UniTrac APIs\$webAppName\"
Copy-Item -Path "$configRepository\Test\STAGE - 2018-10-03\API\$webAppName\Web.config" -Destination $destPath -Force




#AuthenticationService
$webAppName = "AuthenticationService"
$destPath =  "\\utstage-app2\d$\inetpub\UniTrac APIs\$webAppName\"
Copy-Item -Path "$configRepository\Test\STAGE - 2018-10-03\API\$webAppName\Web.config" -Destination $destPath -Force


#ContentDiscoveryService
$webAppName = "ContentDiscoveryService"
$destPath =  "\\utstage-app2\d$\inetpub\UniTrac APIs\$webAppName\"
Copy-Item -Path "$configRepository\Test\STAGE - 2018-10-03\API\$webAppName\Web.config" -Destination $destPath -Force


#EscrowService
$webAppName = "EscrowService"
$destPath =  "\\utstage-app2\d$\inetpub\UniTrac APIs\$webAppName\"
Copy-Item -Path "$configRepository\Test\STAGE - 2018-10-03\API\$webAppName\Web.config" -Destination $destPath -Force



#InteractionHistoryService
$webAppName = "InteractionHistoryService"
$destPath =  "\\utstage-app2\d$\inetpub\UniTrac APIs\$webAppName\"
Copy-Item -Path "$configRepository\Test\STAGE - 2018-10-03\API\$webAppName\Web.config" -Destination $destPath -Force



#LDHWebService
$webAppName = "LDHWebService"
$destPath =  "\\utstage-app2\d$\inetpub\wwwroot\$webAppName\"
 #-Exclude "*.cs"
Copy-Item -Path "$configRepository\Test\STAGE - 2018-10-03\$webAppName\Web.config" -Destination $destPath -Force



#LenderService (legacy)
$destPath =  "\\utstage-app2\d$\inetpub\wwwroot\LenderService\"
Copy-Item -Path "$configRepository\Test\STAGE - 2018-10-03\LenderService\Web.config" -Destination $destPath -Force



#LenderService (API version) 
#ideally rename this webservice LenderServiceAPI to differentiate from legacy and make use of $service variable
$destPath =  "\\utstage-app2\d$\inetpub\UniTrac APIs\LenderService\"
Copy-Item -Path "$configRepository\Test\STAGE - 2018-10-03\API\LenderService\Web.config" -Destination $destPath -Force



#LFPWebService (VUT)
$destPath =  "\\vutstage01\c$\inetpub\wwwroot\LFPWebService\"
 #-Exclude "*.cs"
Copy-Item -Path "$configRepository\Test\STAGE - 2018-10-03\LFPWebService\Web.config" -Destination $destPath -Force



#NotificationService
$webAppName = "NotificationService"
$destPath =  "\\utstage-app2\d$\inetpub\UniTrac APIs\$webAppName\"
Copy-Item -Path "$configRepository\Test\STAGE - 2018-10-03\API\$webAppName\Web.config" -Destination $destPath -Force



#PropertyService
$webAppName = "PropertyService"
$destPath =  "\\utstage-app2\d$\inetpub\UniTrac APIs\$webAppName\"
Copy-Item -Path "$configRepository\Test\STAGE - 2018-10-03\API\$webAppName\Web.config" -Destination $destPath -Force



#QCService
$sourcePath = "$tfsPath\LDH\API\QCService\*"
$destPath =  "\\utstage-app2\d$\inetpub\UniTrac APIs\QCService\"
Copy-Item -Path "$configRepository\Test\STAGE - 2018-10-03\API\QCService\Web.config" -Destination $destPath -Force



#QuickPoint
$configRepository = "\\as.local\shared\InfoTech\UniTrac_Master_Configs\ArchivedConfigs"

$destPath =  "\\utstage-app2\d$\inetpub"

Copy-Item -Path "$configRepository\Test\STAGE - 2018-10-03\QuickPointWCF\Web.config" -Destination   "$destPath\wwwroot\QuickPoint.WCF\QuickPoint.WCF\" -Force
Copy-Item -Path "$configRepository\Test\STAGE - 2018-10-03\QuickPointAuth\Web.config" -Destination   "$destPath\QuickPointStaging\QuickPoint.Auth\" -Force
Copy-Item -Path "$configRepository\Test\STAGE - 2018-10-03\QuickPointWeb\Web.config" -Destination   "$destPath\QuickPointStaging\QuickPointWeb\" -Force



#ReferenceDataService
$webAppName = "ReferenceDataService"
$destPath =  "\\utstage-app2\d$\inetpub\UniTrac APIs\$webAppName\"
Copy-Item -Path "$configRepository\Test\STAGE - 2018-10-03\API\$webAppName\Web.config" -Destination $destPath -Force



#UnitracSSO
$webAppName = "UnitracSSO"
$destPath =  "\\utstage-app2\d$\inetpub\wwwroot\$webAppName\"
Copy-Item -Path "$configRepository\Test\STAGE - 2018-10-03\$webAppName\Web.config" -Destination $destPath -Force



#UTLService
$webAppName = "UTLService"
$destPath =  "\\utstage-app2\d$\inetpub\UniTrac APIs\$webAppName\"
Copy-Item -Path "$configRepository\Test\STAGE - 2018-10-03\API\$webAppName\Web.config" -Destination $destPath -Force


#UTLSupportService
$webAppName = "UTLSupportService"
$destPath =  "\\utstage-app2\d$\inetpub\UTL APIs\$webAppName\"
Copy-Item -Path "$configRepository\Test\STAGE - 2018-10-03\$webAppName\Web.config" -Destination $destPath -Force


#UserService
$webAppName = "UserService"
$destPath =  "\\utstage-app2\d$\inetpub\UniTrac APIs\$webAppName\"
Copy-Item -Path "$configRepository\Test\STAGE - 2018-10-03\API\$webAppName\Web.config" -Destination $destPath -Force



#VehicleLookupService
 # this is good but needs to be changed to a remote pssession.  will that session have permits to pull from source and reposibory?
$webAppName = "VehicleLookupService"
$destPath =  "\\utstage-app2\d$\inetpub\wwwroot\$webAppName\"
Copy-Item -Path "$configRepository\Test\STAGE - 2018-10-03\$webAppName\Web.config" -Destination $destPath -Force



#WorkItemService
$webAppName = "WorkItemService"
$destPath =  "\\utstage-app2\d$\inetpub\UniTrac APIs\$webAppName\"
Copy-Item -Path "$configRepository\Test\STAGE - 2018-10-03\API\$webAppName\Web.config" -Destination $destPath -Force

Write-Output "Done with web apps, starting them up"


#################################
## done with web components, start them all

 
 # this remote session finds all web app pools that are stopped and starts them
$Session = New-PSSession -ComputerName UTSTAGE-APP2
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
#(Get-Service -ComputerName vutstage01 -Name 'IISAdmin').start()





 





#################################
## remove existing content from the deployment destination, copy windows service content files from the tfs source to the destination
## and replace the config files deployed from the tfs source with the curated ones from the repository
## some service names are contained in the referenced txt files, hence the foreach to work off of the list
## This list is in alphabetical order, not by type, location, or purpose


Write-Output "Working on the windows apps"






#Directory Watcher
$service_names = Get-Content "\\usd-rd02\c$\Powershell Scripts\PowerShell\Deployment Jobs\Staging\DW\DW.txt"
Foreach ($service in $service_names){

   $destPath = "\\utstage-app1\c$\Program Files\Allied Solutions\$service\"
   Copy-Item -Path "$configRepository\Test\STAGE - 2018-10-03\$service\*.exe.config" -Destination $destPath -Force
   }

   


#LDH Service
$service_names = Get-Content "\\usd-rd02\c$\Powershell Scripts\PowerShell\Deployment Jobs\Staging\LDH\LDH.txt"
Foreach ($service in $service_names){

   if($service -eq "LDHServiceSANT"){
      $destPath = "\\utstage-app3\c$\Program Files\Allied Solutions\$service\"
      }
   else{   
      $destPath = "\\utstage-app1\c$\Program Files\Allied Solutions\$service\"
      }

   
  
   Copy-Item -Path "$configRepository\Test\STAGE - 2018-10-03\$service\*.exe.config" -Destination $destPath -Force
   }


$configRepository = "\\as.local\shared\InfoTech\UniTrac_Master_Configs\ArchivedConfigs"


#Message Service
$service_names = Get-Content  "\\usd-rd02\c$\Powershell Scripts\PowerShell\Deployment Jobs\Staging\Message\Message.txt"
Foreach ($service in $service_names){

   if($service -eq "MSGSRVREXTSANT"){
      $destPath = "\\utstage-app4\c$\Program Files\AlliedSolutions\LDHServices\$service\"
      }
    #bss and idr services should be moved from x86 to match QA, then get rid of this elseif
   elseif($service -eq "MSGSRVRBSS" -or $service -eq "MSGSRVREDIIDR"){
      $destPath = "\\utstage-app1\c$\Program Files (x86)\AlliedSolutions\LDHServices\$service\"
      }
   else{   
      $destPath = "\\utstage-app1\c$\Program Files\AlliedSolutions\LDHServices\$service\"
      }
   Copy-Item -Path "$configRepository\Test\STAGE - 2018-10-03\$service\*.exe.config" -Destination $destPath -Force
   }
   



#UBS ASR Services
$service_names = Get-Content  "\\usd-rd02\c$\Powershell Scripts\PowerShell\Deployment Jobs\Staging\UBS\ASR1.txt"
Foreach ($service in $service_names){

   $destPath = "\\UTSTAGE-ASR1\c$\Program Files\Allied Solutions\$service\"
   Copy-Item -Path "$configRepository\Test\STAGE - 2018-10-03\$service\*.exe.config" -Destination $destPath -Force
   }




#UBS ASR Services
$service_names = Get-Content "\\usd-rd02\c$\Powershell Scripts\PowerShell\Deployment Jobs\Staging\UBS\ASR2.txt"
Foreach ($service in $service_names){

   $destPath = "\\UTSTAGE-ASR2\c$\Program Files\Allied Solutions\$service\"
   Copy-Item -Path "$configRepository\Test\STAGE - 2018-10-03\$service\*.exe.config" -Destination $destPath -Force
   }




#UBS ASR Services
$service_names = Get-Content "\\usd-rd02\c$\Powershell Scripts\PowerShell\Deployment Jobs\Staging\UBS\ASR3.txt"
Foreach ($service in $service_names){

   $destPath = "\\UTSTAGE-ASR3\c$\Program Files\Allied Solutions\$service\"
   Copy-Item -Path "$configRepository\Test\STAGE - 2018-10-03\$service\*.exe.config" -Destination $destPath -Force
   }




#UBS Services
$service_names = Get-Content "\\usd-rd02\c$\Powershell Scripts\PowerShell\Deployment Jobs\Staging\UBS\App1.txt"
Foreach ($service in $service_names){

   $destPath = "\\utstage-app1\C$\Program Files\Allied Solutions\$service\"
   Copy-Item -Path "$configRepository\Test\STAGE - 2018-10-03\$service\*.exe.config" -Destination $destPath -Force 
   }



#UBS Services
$service_names = Get-Content "\\usd-rd02\c$\Powershell Scripts\PowerShell\Deployment Jobs\Staging\UBS\App3.txt"
Foreach ($service in $service_names){

   $destPath = "\\utstage-app3\C$\Program Files\Allied Solutions\$service\"
   Copy-Item -Path "$configRepository\Test\STAGE - 2018-10-03\$service\*.exe.config" -Destination $destPath -Force 
   }



#UBS Services
$service_names = Get-Content "\\usd-rd02\c$\Powershell Scripts\PowerShell\Deployment Jobs\Staging\UBS\App4.txt"
Foreach ($service in $service_names){

   $destPath = "\\utstage-app4\C$\Program Files\Allied Solutions\$service\"
   Copy-Item -Path "$configRepository\Test\STAGE - 2018-10-03\$service\*.exe.config" -Destination $destPath -Force 
   }



#Workflow
$service_names = Get-Content "\\usd-rd02\c$\Powershell Scripts\PowerShell\Deployment Jobs\Staging\Workflow\Workflow.txt"
Foreach ($service in $service_names){

   if($service -eq "OspreyWorkflowService4"){
      $destPath =  "\\utstage-app4\c$\Program Files\Allied Solutions\$service\"
      }
    else{
      $destPath =  "\\utstage-app1\c$\Program Files\Allied Solutions\$service\"
      }
Copy-Item -Path "$configRepository\Test\STAGE - 2018-10-03\$service\OspreyWorkflowService.exe.config" -Destination $destPath -Force
   }


## utilities

#ProdSupportTool
$destPath =  "\\utstage-app1\c$\ProdSupportTool\"
Copy-Item -Path "$configRepository\Test\STAGE - 2018-10-03\ProdSupportTool\ProductionSupportTool.exe.config" -Destination $destPath -Force



#SAMU
$destPath =  "\\utstage-app1\c$\Program Files\Allied Solutions\SAMU\"
Copy-Item -Path "$configRepository\Test\STAGE - 2018-10-03\SAMU\SAMU.exe.config" -Destination $destPath -Force

Get-Service	 -ComputerName	UTSTAGE-APP1	  -Name	DirectoryWatcherServerIn |  select machinename, name, status
Get-Service	 -ComputerName	UTSTAGE-APP1	  -Name	DirectoryWatcherServerOut |  select machinename, name, status
Get-Service	 -ComputerName	UTSTAGE-APP1	  -Name	LDHServ	|  select machinename, name, status
Get-Service	 -ComputerName	UTSTAGE-APP1	  -Name	LDHServiceHUNT	|  select machinename, name, status
Get-Service	 -ComputerName	UTSTAGE-APP1	  -Name	LDHServicePRCPA	|  select machinename, name, status
Get-Service	 -ComputerName	UTSTAGE-APP1	  -Name	UnitracBusinessService |  select machinename, name, status
Get-Service	 -ComputerName	UTSTAGE-APP1	  -Name	ldhserviceUSD |  select machinename, name, status
Get-Service	 -ComputerName	UTSTAGE-APP1	  -Name	UnitracBusinessServiceCycle |  select machinename, name, status
Get-Service	 -ComputerName	UTSTAGE-APP1	  -Name	UnitracBusinessServicePRT |  select machinename, name, status
Get-Service	 -ComputerName	UTSTAGE-APP1	  -Name	UnitracBusinessServiceMatchIn |  select machinename, name, status
Get-Service	 -ComputerName	UTSTAGE-APP1	  -Name	UnitracBusinessServiceMatchOut |  select machinename, name, status
Get-Service	 -ComputerName	UTSTAGE-APP1	  -Name	UnitracBusinessServiceRPT |  select machinename, name, status
Get-Service	 -ComputerName	UTSTAGE-APP1	  -Name	WorkflowService |  select machinename, name, status
Get-Service	 -ComputerName	UTSTAGE-APP1	  -Name	WorkflowService2 |  select machinename, name, status
Get-Service	 -ComputerName	UTSTAGE-APP1	  -Name	WorkflowService3 |  select machinename, name, status
Get-Service	 -ComputerName	UTSTAGE-APP1	  -Name	MSGSRVREDIIDR |  select machinename, name, status
Get-Service	 -ComputerName	UTSTAGE-APP1	  -Name	MSGSRVRBSS |  select machinename, name, status 
Get-Service	 -ComputerName	UTSTAGE-APP1	  -Name	MSGSRVRDEF|  select machinename, name, status
Get-Service	 -ComputerName	UTSTAGE-APP1	  -Name	MSGSRVREXTUSD |  select machinename, name, status
Get-Service	 -ComputerName	UTSTAGE-APP1	  -Name	MSGSRVREXTINFO	 |  select machinename, name, status
Get-Service	 -ComputerName	UTSTAGE-APP1	  -Name	MSGSRVREXTHUNT|  select machinename, name, status
Get-Service	 -ComputerName	UTSTAGE-APP1	  -Name	LIMCExport |  select machinename, name, status
Get-Service	 -ComputerName	UTSTAGE-APP1	  -Name	UnitracBusinessServiceBackfeed |  select machinename, name, status
Get-Service	 -ComputerName	UTSTAGE-APP3	  -Name	MSGSRVREXTSANT |  select machinename, name, status
Get-Service	 -ComputerName	UTSTAGE-APP3	  -Name	LDHServiceSANT |  select machinename, name, status
Get-Service	 -ComputerName	UTSTAGE-APP3	  -Name	LetterGen |  select machinename, name, status
Get-Service	 -ComputerName	UTSTAGE-APP3	  -Name	UTLBusinessService |  select machinename, name, status
Get-Service	 -ComputerName	UTSTAGE-APP4	  -Name	WorkflowService4 |  select machinename, name, status
Get-Service	 -ComputerName	UTSTAGE-APP4	  -Name	UnitracBusinessServiceMatchIn2 |  select machinename, name, status
Get-Service	 -ComputerName	UTSTAGE-APP4	  -Name	UnitracBusinessServiceCycle2 |  select machinename, name, status
Get-Service	 -ComputerName	UTSTAGE-APP4	  -Name	QCBatchEvaluationProcess |  select machinename, name, status 
Get-Service	 -ComputerName	UTSTAGE-APP4	  -Name	QCBatchSendProcess|  select machinename, name, status
Get-Service	 -ComputerName	UTSTAGE-APP4	  -Name	QCImportProcess |  select machinename, name, status
Get-Service	 -ComputerName	UTSTAGE-APP4	  -Name	QCCleanupProcess | select machinename, name, status
Get-Service	 -ComputerName	UTSTAGE-ASR1	  -Name	UnitracBusinessServiceDist |  select machinename, name, status
Get-Service	 -ComputerName	UTSTAGE-ASR1	  -Name	UnitracBusinessServiceProc1 |  select machinename, name, status
Get-Service	 -ComputerName	UTSTAGE-ASR2	  -Name	UnitracBusinessServiceProc2 |  select machinename, name, status
Get-Service	 -ComputerName	UTSTAGE-ASR3	  -Name	UnitracBusinessServiceProc3 |  select machinename, name, status
 
 #would rather prompt for permission to run start script but have not figured out how to execute the script remotely yet
Write-Output "`n`n`n Please remember to start the windows services when you are ready! `n`n`n"


Stop-Transcript

Invoke-item $deployLogDestination
