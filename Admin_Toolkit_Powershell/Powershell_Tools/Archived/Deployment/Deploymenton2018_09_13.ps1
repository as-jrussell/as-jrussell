Start-Transcript -Path "\\usd-rd02\c$\logs\PowerShell Logs\ProductionSpecial.txt"

Write-Output "Adding UTLSupportService file"
#UTLSupportService
$webAppName = "UTLSupportService"
$sourcePath = "\\tfs-build-06\E$\UniTrac\Setups\Version hotfix_utlsupportservice\UTLSupportService\*"
$destPath =  "\\utprod-api-01.colo.as.local\e$\inetpub\UTL APIs\$webAppName\"
Invoke-Command -ScriptBlock {Remove-Item "\\utprod-api-01.colo.as.local\e$\inetpub\UTL APIs\$webAppName\bin\UTLSupportService.dll"}
Copy-Item -Path $sourcePath -Destination $destPath -Recurse



  Write-Output "Adding Message Service file"

#Message Service
$service_names = Get-Content  "\\usd-rd02\c$\Powershell Scripts\PowerShell\Deployment Jobs\Staging\Message\Message.txt"
Foreach ($service in $service_names){

   if($service -eq "MSGSRVREXTSANT"){
      $destPath = "\\Unitrac-WH19\C$\Program Files (x86)\AlliedSolutions\LDHServices\$service\Extensions\"
      }
    #not 100% sure if this will work but it's worth a shot.
   elseif($service -eq "MSGSRVREXTWELLSFARGO" -or $service -eq "MSGSRVREXTSANT"){
      $destPath = "\\Unitrac-WH21\e$\AlliedSolutions\LDHServices\$service\Extensions\"
      }
   else{   
      $destPath = "\\Unitrac-WH08\C$\Program Files (x86)\AlliedSolutions\LDHServices\$service\Extensions\"
      }  
   Copy-Item -Path "\\tfs-build-06\E$\UniTrac\Setups\Version hotfix_fair_dll\LDH\MessageServer\Extensions\*" -Destination $destPath -Recurse
   }
   

  Write-Output "Adding API File"


#APIs
$service_names = Get-Content "\\usd-rd02\c$\Powershell Scripts\PowerShell\Deployment Jobs\Production\utprod-api-01.txt"
Foreach ($webservice in $service_names){

   $destPath = "\\utprod-api-01.colo.as.local\e$\inetpub\UTL APIs\$webservice\bin\"
   Invoke-Command -ScriptBlock {Remove-Item "\\utprod-api-01.colo.as.local\e$\inetpub\UTL APIs\$webAppName\bin\api.dll"
   Copy-Item -Path "$tfsPath\LDH\API\Build Manager\Deploy\UTLApi\bin\*" -Destination $destPath -Recurse
   }



   Write-Output "Deployment Complete"

  
Stop-Transcript

if(Test-Path "\\usd-rd02\c$\logs\PowerShell Logs\ProductionSpecial.txt"){
$destination = "\\usd-rd02\c$\logs\PowerShell Logs\ProductionSpecial"+[DateTime]::Now.ToString("yyyyMMdd-HHmmss")+".txt"
Copy-Item -Path "\\usd-rd02\c$\logs\PowerShell Logs\ProductionSpecial.txt" -Destination $destination
}


Remove-Item -Path "\\usd-rd02\c$\logs\PowerShell Logs\ProductionSpecial.txt"