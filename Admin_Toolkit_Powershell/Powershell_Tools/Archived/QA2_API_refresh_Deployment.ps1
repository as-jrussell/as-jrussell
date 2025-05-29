Start-Transcript -Path "C:\logs\PowerShell Logs\QA2API.txt"

Get-ChildItem -Path "\\utqa2-app1\c$\inetpub\UniTrac APIs\AuditHistoryService" -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
Get-ChildItem -Path "\\utqa2-app1\c$\inetpub\UniTrac APIs\InteractionHistoryService" -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
Get-ChildItem -Path "\\utqa2-app1\c$\inetpub\UniTrac APIs\LenderService" -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
Get-ChildItem -Path "\\utqa2-app1\c$\inetpub\UniTrac APIs\NotificationService" -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
Get-ChildItem -Path "\\utqa2-app1\c$\inetpub\UniTrac APIs\PropertyService" -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
Get-ChildItem -Path "\\utqa2-app1\c$\inetpub\UniTrac APIs\ReferenceDataService" -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
Get-ChildItem -Path "\\utqa2-app1\c$\inetpub\UniTrac APIs\UTLService" -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
Get-ChildItem -Path "\\utqa2-app1\c$\inetpub\UniTrac APIs\WorkItemService" -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue

#AuditHistoryService
$sourcePath = "\\tfs-build-06\E$\UniTrac\Setups\Version 8.3\LDH\API\AuditHistoryService"
$destPath =  "\\utqa2-app1\c$\inetpub\UniTrac APIs\AuditHistoryService"


Get-ChildItem $sourcePath -Recurse -Include '*.*' | Foreach-Object `
    {
        $destDir = Split-Path ($_.FullName -Replace [regex]::Escape($sourcePath), $destPath)
        if (!(Test-Path $destDir))
        {
            New-Item -ItemType directory $destDir | Out-Null
        }
        Copy-Item $_ -Destination $destDir}




#InteractionHistoryService
$sourcePath = "\\tfs-build-06\E$\UniTrac\Setups\Version 8.3\LDH\API\InteractionHistoryService"
$destPath =  "\\utqa2-app1\c$\inetpub\UniTrac APIs\InteractionHistoryService"


Get-ChildItem $sourcePath -Recurse -Include '*.*' | Foreach-Object `
    {
        $destDir = Split-Path ($_.FullName -Replace [regex]::Escape($sourcePath), $destPath)
        if (!(Test-Path $destDir))
        {
            New-Item -ItemType directory $destDir | Out-Null
        }
        Copy-Item $_ -Destination $destDir}





#LenderService
$sourcePath = "\\tfs-build-06\E$\UniTrac\Setups\Version 8.3\LDH\API\LenderService"
$destPath =  "\\utqa2-app1\c$\inetpub\UniTrac APIs\LenderService"


Get-ChildItem $sourcePath -Recurse -Include '*.*' | Foreach-Object `
    {
        $destDir = Split-Path ($_.FullName -Replace [regex]::Escape($sourcePath), $destPath)
        if (!(Test-Path $destDir))
        {
            New-Item -ItemType directory $destDir | Out-Null
        }
        Copy-Item $_ -Destination $destDir}





#NotificationService
$sourcePath = "\\tfs-build-06\E$\UniTrac\Setups\Version 8.3\LDH\API\NotificationService"
$destPath =  "\\utqa2-app1\c$\inetpub\UniTrac APIs\NotificationService"


Get-ChildItem $sourcePath -Recurse -Include '*.*' | Foreach-Object `
    {
        $destDir = Split-Path ($_.FullName -Replace [regex]::Escape($sourcePath), $destPath)
        if (!(Test-Path $destDir))
        {
            New-Item -ItemType directory $destDir | Out-Null
        }
        Copy-Item $_ -Destination $destDir}





#PropertyService
$sourcePath = "\\tfs-build-06\E$\UniTrac\Setups\Version 8.3\LDH\API\PropertyService"
$destPath =  "\\utqa2-app1\c$\inetpub\UniTrac APIs\PropertyService"


Get-ChildItem $sourcePath -Recurse -Include '*.*' | Foreach-Object `
    {
        $destDir = Split-Path ($_.FullName -Replace [regex]::Escape($sourcePath), $destPath)
        if (!(Test-Path $destDir))
        {
            New-Item -ItemType directory $destDir | Out-Null
        }
        Copy-Item $_ -Destination $destDir}



#ReferenceDataService
$sourcePath = "\\tfs-build-06\E$\UniTrac\Setups\Version 8.3\LDH\API\ReferenceDataService"
$destPath =  "\\utqa2-app1\c$\inetpub\UniTrac APIs\ReferenceDataService"


Get-ChildItem $sourcePath -Recurse -Include '*.*' | Foreach-Object `
    {
        $destDir = Split-Path ($_.FullName -Replace [regex]::Escape($sourcePath), $destPath)
        if (!(Test-Path $destDir))
        {
            New-Item -ItemType directory $destDir | Out-Null
        }
        Copy-Item $_ -Destination $destDir}






#UTLService
#$sourcePath = "\\tfs-build-06\E$\UniTrac\Setups\Version 8.3\LDH\API\UTLService"
#$destPath =  "\\utqa2-app1\c$\inetpub\UniTrac APIs\UTLService"


#Get-ChildItem $sourcePath -Recurse -Include '*.*' | Foreach-Object `
 #   {
   #     $destDir = Split-Path ($_.FullName -Replace [regex]::Escape($sourcePath), $destPath)
  #      if (!(Test-Path $destDir))
      #  {
            New-Item -ItemType directory $destDir | Out-Null
      #  }
      #  Copy-Item $_ -Destination $destDir}





#WorkItemService
$sourcePath = "\\tfs-build-06\E$\UniTrac\Setups\Version 8.3\LDH\API\WorkItemService"
$destPath =  "\\utqa2-app1\c$\inetpub\UniTrac APIs\WorkItemService"


Get-ChildItem $sourcePath -Recurse -Include '*.*' | Foreach-Object `
    {
        $destDir = Split-Path ($_.FullName -Replace [regex]::Escape($sourcePath), $destPath)
        if (!(Test-Path $destDir))
        {
            New-Item -ItemType directory $destDir | Out-Null
        }
        Copy-Item $_ -Destination $destDir}






Get-ChildItem   "\\as.local\shared\InfoTech\UniTrac_Master_Configs\Test\QA2\AuditHistoryService\Web.config" |Copy-Item -Destination  "\\utqa2-app1\c$\inetpub\UniTrac APIs\AuditHistoryService" -Force

Get-ChildItem   "\\as.local\shared\InfoTech\UniTrac_Master_Configs\Test\QA2\InteractionHistoryService\Web.config" |Copy-Item -Destination  "\\utqa2-app1\c$\inetpub\UniTrac APIs\InteractionHistoryService" -Force

Get-ChildItem   "\\as.local\shared\InfoTech\UniTrac_Master_Configs\Test\QA2\LenderService\Web.config" |Copy-Item -Destination  "\\utqa2-app1\c$\inetpub\UniTrac APIs\LenderService" -Force

Get-ChildItem   "\\as.local\shared\InfoTech\UniTrac_Master_Configs\Test\QA2\NotificationService\Web.config" |Copy-Item -Destination  "\\utqa2-app1\c$\inetpub\UniTrac APIs\NotificationService" -Force

Get-ChildItem   "\\as.local\shared\InfoTech\UniTrac_Master_Configs\Test\QA2\PropertyService\Web.config" |Copy-Item -Destination  "\\utqa2-app1\c$\inetpub\UniTrac APIs\PropertyService" -Force

Get-ChildItem   "\\as.local\shared\InfoTech\UniTrac_Master_Configs\Test\QA2\ReferenceDataService\Web.config" |Copy-Item -Destination  "\\utqa2-app1\c$\inetpub\UniTrac APIs\ReferenceDataService" -Force

Get-ChildItem   "\\as.local\shared\InfoTech\UniTrac_Master_Configs\Test\QA2\UTLService\Web.config" |Copy-Item -Destination  "\\utqa2-app1\c$\inetpub\UniTrac APIs\UTLService" -Force

Get-ChildItem   "\\as.local\shared\InfoTech\UniTrac_Master_Configs\Test\QA2\WorkItemService\Web.config" |Copy-Item -Destination  "\\utqa2-app1\c$\inetpub\UniTrac APIs\WorkItemService" -Force





Stop-Transcript

if(Test-Path "C:\logs\PowerShell Logs\QA2API.txt"){
$destination = "C:\logs\PowerShell Logs\QA2API"+[DateTime]::Now.ToString("yyyyMMdd-HHmmss")+".txt"
Copy-Item -Path "C:\logs\PowerShell Logs\QA2API.txt" -Destination $destination
}


Remove-Item -Path "C:\logs\PowerShell Logs\QA2API.txt"