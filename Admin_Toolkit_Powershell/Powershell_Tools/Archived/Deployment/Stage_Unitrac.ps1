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
 

 # prompt user for the main parameter within the path. if they hit enter, use the default
Write-Output "Setup folder in TFS to use?`n"
$version = Read-Host -Prompt  "(enter uses the default of 'Version hotfix')"
if( [string]::IsNullOrEmpty($version)){
   $version = "Version hotfix"
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





#UnitracSSO
$webAppName = "UnitracSSO"
$sourcePath = "$tfsPath\LDH\$webAppName\*"
$destPath =  "\\utstage-app2\d$\inetpub\wwwroot\$webAppName\"
Get-ChildItem -Path $destPath -Recurse | Remove-Item -Force -Recurse  
Copy-Item -Path $sourcePath -Destination $destPath -Recurse
Copy-Item -Path "$configRepository\Test\Stage\$webAppName\Web.config" -Destination $destPath -Force




 #would rather prompt for permission to run start script but have not figured out how to execute the script remotely yet
Write-Output "`n`n`n Please remember to start the windows services when you are ready! `n`n`n"


Stop-Transcript

