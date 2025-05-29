Start-Transcript -Path "C:\logs\PowerShell Logs\DevAPI.txt"

Get-ChildItem -Path "\\cp-websvcdev-01\e$\inetpub\CPWebSVC\AuditHistoryService" -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
Get-ChildItem -Path "\\cp-websvcdev-02\e$\inetpub\CPWebSVC\AuditHistoryService" -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
Get-ChildItem -Path "\\cp-websvcdev-03\e$\inetpub\CPWebSVC\AuditHistoryService" -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
Get-ChildItem -Path "\\cp-websvcdev-01\e$\inetpub\CPWebSVC\InteractionHistoryService" -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
Get-ChildItem -Path "\\cp-websvcdev-02\e$\inetpub\CPWebSVC\InteractionHistoryService" -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
Get-ChildItem -Path "\\cp-websvcdev-03\e$\inetpub\CPWebSVC\InteractionHistoryService" -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
Get-ChildItem -Path "\\cp-websvcdev-01\e$\inetpub\CPWebSVC\LenderService" -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
Get-ChildItem -Path "\\cp-websvcdev-02\e$\inetpub\CPWebSVC\LenderService" -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
Get-ChildItem -Path "\\cp-websvcdev-03\e$\inetpub\CPWebSVC\LenderService" -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
Get-ChildItem -Path "\\cp-websvcdev-01\e$\inetpub\CPWebSVC\NotificationService" -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
Get-ChildItem -Path "\\cp-websvcdev-02\e$\inetpub\CPWebSVC\NotificationService" -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
Get-ChildItem -Path "\\cp-websvcdev-03\e$\inetpub\CPWebSVC\NotificationService" -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
Get-ChildItem -Path "\\cp-websvcdev-01\e$\inetpub\CPWebSVC\PropertyService" -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
Get-ChildItem -Path "\\cp-websvcdev-02\e$\inetpub\CPWebSVC\PropertyService" -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
Get-ChildItem -Path "\\cp-websvcdev-03\e$\inetpub\CPWebSVC\PropertyService" -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
Get-ChildItem -Path "\\cp-websvcdev-01\e$\inetpub\CPWebSVC\ReferenceDataService" -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
Get-ChildItem -Path "\\cp-websvcdev-02\e$\inetpub\CPWebSVC\ReferenceDataService" -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
Get-ChildItem -Path "\\cp-websvcdev-03\e$\inetpub\CPWebSVC\ReferenceDataService" -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
Get-ChildItem -Path "\\cp-websvcdev-01\e$\inetpub\CPWebSVC\UTLService" -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
Get-ChildItem -Path "\\cp-websvcdev-02\e$\inetpub\CPWebSVC\UTLService" -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
Get-ChildItem -Path "\\cp-websvcdev-03\e$\inetpub\CPWebSVC\UTLService" -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
Get-ChildItem -Path "\\cp-websvcdev-01\e$\inetpub\CPWebSVC\WorkItemService" -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
Get-ChildItem -Path "\\cp-websvcdev-02\e$\inetpub\CPWebSVC\WorkItemService" -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
Get-ChildItem -Path "\\cp-websvcdev-03\e$\inetpub\CPWebSVC\WorkItemService" -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue

#AuditHistoryService
$sourcePath = "\\utqa2-app1\c$\inetpub\wwwroot\api\AuditHistoryService"
$destPath =  "\\cp-websvcdev-01\e$\inetpub\CPWebSVC\AuditHistoryService"


Get-ChildItem $sourcePath -Recurse -Include '*.*' | Foreach-Object `
    {
        $destDir = Split-Path ($_.FullName -Replace [regex]::Escape($sourcePath), $destPath)
        if (!(Test-Path $destDir))
        {
            New-Item -ItemType directory $destDir | Out-Null
        }
        Copy-Item $_ -Destination $destDir}




$sourcePath = "\\utqa2-app1\c$\inetpub\wwwroot\api\AuditHistoryService"
$destPath =  "\\cp-websvcdev-02\e$\inetpub\CPWebSVC\AuditHistoryService"


Get-ChildItem $sourcePath -Recurse -Include '*.*' | Foreach-Object `
    {
        $destDir = Split-Path ($_.FullName -Replace [regex]::Escape($sourcePath), $destPath)
        if (!(Test-Path $destDir))
        {
            New-Item -ItemType directory $destDir | Out-Null
        }
        Copy-Item $_ -Destination $destDir}




$sourcePath = "\\utqa2-app1\c$\inetpub\wwwroot\api\AuditHistoryService"
$destPath =  "\\cp-websvcdev-03\e$\inetpub\CPWebSVC\AuditHistoryService"


Get-ChildItem $sourcePath -Recurse -Include '*.*' | Foreach-Object `
    {
        $destDir = Split-Path ($_.FullName -Replace [regex]::Escape($sourcePath), $destPath)
        if (!(Test-Path $destDir))
        {
            New-Item -ItemType directory $destDir | Out-Null
        }
        Copy-Item $_ -Destination $destDir}

#InteractionHistoryService
$sourcePath = "\\utqa2-app1\c$\inetpub\wwwroot\api\InteractionHistoryService"
$destPath =  "\\cp-websvcdev-01\e$\inetpub\CPWebSVC\InteractionHistoryService"


Get-ChildItem $sourcePath -Recurse -Include '*.*' | Foreach-Object `
    {
        $destDir = Split-Path ($_.FullName -Replace [regex]::Escape($sourcePath), $destPath)
        if (!(Test-Path $destDir))
        {
            New-Item -ItemType directory $destDir | Out-Null
        }
        Copy-Item $_ -Destination $destDir}




$sourcePath = "\\utqa2-app1\c$\inetpub\wwwroot\api\InteractionHistoryService"
$destPath =  "\\cp-websvcdev-02\e$\inetpub\CPWebSVC\InteractionHistoryService"


Get-ChildItem $sourcePath -Recurse -Include '*.*' | Foreach-Object `
    {
        $destDir = Split-Path ($_.FullName -Replace [regex]::Escape($sourcePath), $destPath)
        if (!(Test-Path $destDir))
        {
            New-Item -ItemType directory $destDir | Out-Null
        }
        Copy-Item $_ -Destination $destDir}




$sourcePath = "\\utqa2-app1\c$\inetpub\wwwroot\api\InteractionHistoryService"
$destPath =  "\\cp-websvcdev-03\e$\inetpub\CPWebSVC\InteractionHistoryService"


Get-ChildItem $sourcePath -Recurse -Include '*.*' | Foreach-Object `
    {
        $destDir = Split-Path ($_.FullName -Replace [regex]::Escape($sourcePath), $destPath)
        if (!(Test-Path $destDir))
        {
            New-Item -ItemType directory $destDir | Out-Null
        }
        Copy-Item $_ -Destination $destDir}


#LenderService
$sourcePath = "\\utqa2-app1\c$\inetpub\wwwroot\api\LenderService"
$destPath =  "\\cp-websvcdev-01\e$\inetpub\CPWebSVC\LenderService"


Get-ChildItem $sourcePath -Recurse -Include '*.*' | Foreach-Object `
    {
        $destDir = Split-Path ($_.FullName -Replace [regex]::Escape($sourcePath), $destPath)
        if (!(Test-Path $destDir))
        {
            New-Item -ItemType directory $destDir | Out-Null
        }
        Copy-Item $_ -Destination $destDir}




$sourcePath = "\\utqa2-app1\c$\inetpub\wwwroot\api\LenderService"
$destPath =  "\\cp-websvcdev-02\e$\inetpub\CPWebSVC\LenderService"


Get-ChildItem $sourcePath -Recurse -Include '*.*' | Foreach-Object `
    {
        $destDir = Split-Path ($_.FullName -Replace [regex]::Escape($sourcePath), $destPath)
        if (!(Test-Path $destDir))
        {
            New-Item -ItemType directory $destDir | Out-Null
        }
        Copy-Item $_ -Destination $destDir}




$sourcePath = "\\utqa2-app1\c$\inetpub\wwwroot\api\LenderService"
$destPath =  "\\cp-websvcdev-03\e$\inetpub\CPWebSVC\LenderService"


Get-ChildItem $sourcePath -Recurse -Include '*.*' | Foreach-Object `
    {
        $destDir = Split-Path ($_.FullName -Replace [regex]::Escape($sourcePath), $destPath)
        if (!(Test-Path $destDir))
        {
            New-Item -ItemType directory $destDir | Out-Null
        }
        Copy-Item $_ -Destination $destDir}


#NotificationService
$sourcePath = "\\utqa2-app1\c$\inetpub\wwwroot\api\NotificationService"
$destPath =  "\\cp-websvcdev-01\e$\inetpub\CPWebSVC\NotificationService"


Get-ChildItem $sourcePath -Recurse -Include '*.*' | Foreach-Object `
    {
        $destDir = Split-Path ($_.FullName -Replace [regex]::Escape($sourcePath), $destPath)
        if (!(Test-Path $destDir))
        {
            New-Item -ItemType directory $destDir | Out-Null
        }
        Copy-Item $_ -Destination $destDir}




$sourcePath = "\\utqa2-app1\c$\inetpub\wwwroot\api\NotificationService"
$destPath =  "\\cp-websvcdev-02\e$\inetpub\CPWebSVC\NotificationService"


Get-ChildItem $sourcePath -Recurse -Include '*.*' | Foreach-Object `
    {
        $destDir = Split-Path ($_.FullName -Replace [regex]::Escape($sourcePath), $destPath)
        if (!(Test-Path $destDir))
        {
            New-Item -ItemType directory $destDir | Out-Null
        }
        Copy-Item $_ -Destination $destDir}




$sourcePath = "\\utqa2-app1\c$\inetpub\wwwroot\api\NotificationService"
$destPath =  "\\cp-websvcdev-03\e$\inetpub\CPWebSVC\NotificationService"


Get-ChildItem $sourcePath -Recurse -Include '*.*' | Foreach-Object `
    {
        $destDir = Split-Path ($_.FullName -Replace [regex]::Escape($sourcePath), $destPath)
        if (!(Test-Path $destDir))
        {
            New-Item -ItemType directory $destDir | Out-Null
        }
        Copy-Item $_ -Destination $destDir}



#PropertyService
$sourcePath = "\\utqa2-app1\c$\inetpub\wwwroot\api\PropertyService"
$destPath =  "\\cp-websvcdev-01\e$\inetpub\CPWebSVC\PropertyService"


Get-ChildItem $sourcePath -Recurse -Include '*.*' | Foreach-Object `
    {
        $destDir = Split-Path ($_.FullName -Replace [regex]::Escape($sourcePath), $destPath)
        if (!(Test-Path $destDir))
        {
            New-Item -ItemType directory $destDir | Out-Null
        }
        Copy-Item $_ -Destination $destDir}




$sourcePath = "\\utqa2-app1\c$\inetpub\wwwroot\api\PropertyService"
$destPath =  "\\cp-websvcdev-02\e$\inetpub\CPWebSVC\PropertyService"


Get-ChildItem $sourcePath -Recurse -Include '*.*' | Foreach-Object `
    {
        $destDir = Split-Path ($_.FullName -Replace [regex]::Escape($sourcePath), $destPath)
        if (!(Test-Path $destDir))
        {
            New-Item -ItemType directory $destDir | Out-Null
        }
        Copy-Item $_ -Destination $destDir}




$sourcePath = "\\utqa2-app1\c$\inetpub\wwwroot\api\PropertyService"
$destPath =  "\\cp-websvcdev-03\e$\inetpub\CPWebSVC\PropertyService"


Get-ChildItem $sourcePath -Recurse -Include '*.*' | Foreach-Object `
    {
        $destDir = Split-Path ($_.FullName -Replace [regex]::Escape($sourcePath), $destPath)
        if (!(Test-Path $destDir))
        {
            New-Item -ItemType directory $destDir | Out-Null
        }
        Copy-Item $_ -Destination $destDir}


#ReferenceDataService
$sourcePath = "\\utqa2-app1\c$\inetpub\wwwroot\api\ReferenceDataService"
$destPath =  "\\cp-websvcdev-01\e$\inetpub\CPWebSVC\ReferenceDataService"


Get-ChildItem $sourcePath -Recurse -Include '*.*' | Foreach-Object `
    {
        $destDir = Split-Path ($_.FullName -Replace [regex]::Escape($sourcePath), $destPath)
        if (!(Test-Path $destDir))
        {
            New-Item -ItemType directory $destDir | Out-Null
        }
        Copy-Item $_ -Destination $destDir}




$sourcePath = "\\utqa2-app1\c$\inetpub\wwwroot\api\ReferenceDataService"
$destPath =  "\\cp-websvcdev-02\e$\inetpub\CPWebSVC\ReferenceDataService"


Get-ChildItem $sourcePath -Recurse -Include '*.*' | Foreach-Object `
    {
        $destDir = Split-Path ($_.FullName -Replace [regex]::Escape($sourcePath), $destPath)
        if (!(Test-Path $destDir))
        {
            New-Item -ItemType directory $destDir | Out-Null
        }
        Copy-Item $_ -Destination $destDir}




$sourcePath = "\\utqa2-app1\c$\inetpub\wwwroot\api\ReferenceDataService"
$destPath =  "\\cp-websvcdev-03\e$\inetpub\CPWebSVC\ReferenceDataService"


Get-ChildItem $sourcePath -Recurse -Include '*.*' | Foreach-Object `
    {
        $destDir = Split-Path ($_.FullName -Replace [regex]::Escape($sourcePath), $destPath)
        if (!(Test-Path $destDir))
        {
            New-Item -ItemType directory $destDir | Out-Null
        }
        Copy-Item $_ -Destination $destDir}



#UTLService
$sourcePath = "\\utqa2-app1\c$\inetpub\wwwroot\api\UTLService"
$destPath =  "\\cp-websvcdev-01\e$\inetpub\CPWebSVC\UTLService"


Get-ChildItem $sourcePath -Recurse -Include '*.*' | Foreach-Object `
    {
        $destDir = Split-Path ($_.FullName -Replace [regex]::Escape($sourcePath), $destPath)
        if (!(Test-Path $destDir))
        {
            New-Item -ItemType directory $destDir | Out-Null
        }
        Copy-Item $_ -Destination $destDir}




$sourcePath = "\\utqa2-app1\c$\inetpub\wwwroot\api\UTLService"
$destPath =  "\\cp-websvcdev-02\e$\inetpub\CPWebSVC\UTLService"


Get-ChildItem $sourcePath -Recurse -Include '*.*' | Foreach-Object `
    {
        $destDir = Split-Path ($_.FullName -Replace [regex]::Escape($sourcePath), $destPath)
        if (!(Test-Path $destDir))
        {
            New-Item -ItemType directory $destDir | Out-Null
        }
        Copy-Item $_ -Destination $destDir}




$sourcePath = "\\utqa2-app1\c$\inetpub\wwwroot\api\UTLService"
$destPath =  "\\cp-websvcdev-03\e$\inetpub\CPWebSVC\UTLService"


Get-ChildItem $sourcePath -Recurse -Include '*.*' | Foreach-Object `
    {
        $destDir = Split-Path ($_.FullName -Replace [regex]::Escape($sourcePath), $destPath)
        if (!(Test-Path $destDir))
        {
            New-Item -ItemType directory $destDir | Out-Null
        }
        Copy-Item $_ -Destination $destDir}



#WorkItemService
$sourcePath = "\\utqa2-app1\c$\inetpub\wwwroot\api\WorkItemService"
$destPath =  "\\cp-websvcdev-01\e$\inetpub\CPWebSVC\WorkItemService"


Get-ChildItem $sourcePath -Recurse -Include '*.*' | Foreach-Object `
    {
        $destDir = Split-Path ($_.FullName -Replace [regex]::Escape($sourcePath), $destPath)
        if (!(Test-Path $destDir))
        {
            New-Item -ItemType directory $destDir | Out-Null
        }
        Copy-Item $_ -Destination $destDir}




$sourcePath = "\\utqa2-app1\c$\inetpub\wwwroot\api\WorkItemService"
$destPath =  "\\cp-websvcdev-02\e$\inetpub\CPWebSVC\WorkItemService"


Get-ChildItem $sourcePath -Recurse -Include '*.*' | Foreach-Object `
    {
        $destDir = Split-Path ($_.FullName -Replace [regex]::Escape($sourcePath), $destPath)
        if (!(Test-Path $destDir))
        {
            New-Item -ItemType directory $destDir | Out-Null
        }
        Copy-Item $_ -Destination $destDir}




$sourcePath = "\\utqa2-app1\c$\inetpub\wwwroot\api\WorkItemService"
$destPath =  "\\cp-websvcdev-03\e$\inetpub\CPWebSVC\WorkItemService"


Get-ChildItem $sourcePath -Recurse -Include '*.*' | Foreach-Object `
    {
        $destDir = Split-Path ($_.FullName -Replace [regex]::Escape($sourcePath), $destPath)
        if (!(Test-Path $destDir))
        {
            New-Item -ItemType directory $destDir | Out-Null
        }
        Copy-Item $_ -Destination $destDir}






Get-ChildItem   "\\as.local\shared\InfoTech\UniTrac_Master_Configs\Test\Dev\AuditHistoryService\Web.config" |Copy-Item -Destination  "\\cp-websvcdev-01\e$\inetpub\CPWebSVC\AuditHistoryService" -Force
Get-ChildItem   "\\as.local\shared\InfoTech\UniTrac_Master_Configs\Test\Dev\AuditHistoryService\Web.config" |Copy-Item -Destination  "\\cp-websvcdev-02\e$\inetpub\CPWebSVC\AuditHistoryService" -Force
Get-ChildItem   "\\as.local\shared\InfoTech\UniTrac_Master_Configs\Test\Dev\AuditHistoryService\Web.config" |Copy-Item -Destination  "\\cp-websvcdev-03\e$\inetpub\CPWebSVC\AuditHistoryService" -Force

Get-ChildItem   "\\as.local\shared\InfoTech\UniTrac_Master_Configs\Test\Dev\InteractionHistoryService\Web.config" |Copy-Item -Destination  "\\cp-websvcdev-01\e$\inetpub\CPWebSVC\InteractionHistoryService" -Force
Get-ChildItem   "\\as.local\shared\InfoTech\UniTrac_Master_Configs\Test\Dev\InteractionHistoryService\Web.config" |Copy-Item -Destination  "\\cp-websvcdev-02\e$\inetpub\CPWebSVC\InteractionHistoryService" -Force
Get-ChildItem   "\\as.local\shared\InfoTech\UniTrac_Master_Configs\Test\Dev\InteractionHistoryService\Web.config" |Copy-Item -Destination  "\\cp-websvcdev-03\e$\inetpub\CPWebSVC\InteractionHistoryService" -Force

Get-ChildItem   "\\as.local\shared\InfoTech\UniTrac_Master_Configs\Test\Dev\LenderService\Web.config" |Copy-Item -Destination  "\\cp-websvcdev-01\e$\inetpub\CPWebSVC\LenderService" -Force
Get-ChildItem   "\\as.local\shared\InfoTech\UniTrac_Master_Configs\Test\Dev\LenderService\Web.config" |Copy-Item -Destination  "\\cp-websvcdev-02\e$\inetpub\CPWebSVC\LenderService" -Force
Get-ChildItem   "\\as.local\shared\InfoTech\UniTrac_Master_Configs\Test\Dev\LenderService\Web.config" |Copy-Item -Destination  "\\cp-websvcdev-03\e$\inetpub\CPWebSVC\LenderService" -Force

Get-ChildItem   "\\as.local\shared\InfoTech\UniTrac_Master_Configs\Test\Dev\NotificationService\Web.config" |Copy-Item -Destination  "\\cp-websvcdev-01\e$\inetpub\CPWebSVC\NotificationService" -Force
Get-ChildItem   "\\as.local\shared\InfoTech\UniTrac_Master_Configs\Test\Dev\NotificationService\Web.config" |Copy-Item -Destination  "\\cp-websvcdev-02\e$\inetpub\CPWebSVC\NotificationService" -Force
Get-ChildItem   "\\as.local\shared\InfoTech\UniTrac_Master_Configs\Test\Dev\NotificationService\Web.config" |Copy-Item -Destination  "\\cp-websvcdev-03\e$\inetpub\CPWebSVC\NotificationService" -Force

Get-ChildItem   "\\as.local\shared\InfoTech\UniTrac_Master_Configs\Test\Dev\PropertyService\Web.config" |Copy-Item -Destination  "\\cp-websvcdev-01\e$\inetpub\CPWebSVC\PropertyService" -Force
Get-ChildItem   "\\as.local\shared\InfoTech\UniTrac_Master_Configs\Test\Dev\PropertyService\Web.config" |Copy-Item -Destination  "\\cp-websvcdev-02\e$\inetpub\CPWebSVC\PropertyService" -Force
Get-ChildItem   "\\as.local\shared\InfoTech\UniTrac_Master_Configs\Test\Dev\PropertyService\Web.config" |Copy-Item -Destination  "\\cp-websvcdev-03\e$\inetpub\CPWebSVC\PropertyService" -Force

Get-ChildItem   "\\as.local\shared\InfoTech\UniTrac_Master_Configs\Test\Dev\ReferenceDataService\Web.config" |Copy-Item -Destination  "\\cp-websvcdev-01\e$\inetpub\CPWebSVC\ReferenceDataService" -Force
Get-ChildItem   "\\as.local\shared\InfoTech\UniTrac_Master_Configs\Test\Dev\ReferenceDataService\Web.config" |Copy-Item -Destination  "\\cp-websvcdev-02\e$\inetpub\CPWebSVC\ReferenceDataService" -Force
Get-ChildItem   "\\as.local\shared\InfoTech\UniTrac_Master_Configs\Test\Dev\ReferenceDataService\Web.config" |Copy-Item -Destination  "\\cp-websvcdev-03\e$\inetpub\CPWebSVC\ReferenceDataService" -Force

Get-ChildItem   "\\as.local\shared\InfoTech\UniTrac_Master_Configs\Test\Dev\UTLService\Web.config" |Copy-Item -Destination  "\\cp-websvcdev-01\e$\inetpub\CPWebSVC\UTLService" -Force
Get-ChildItem   "\\as.local\shared\InfoTech\UniTrac_Master_Configs\Test\Dev\UTLService\Web.config" |Copy-Item -Destination  "\\cp-websvcdev-02\e$\inetpub\CPWebSVC\UTLService" -Force
Get-ChildItem   "\\as.local\shared\InfoTech\UniTrac_Master_Configs\Test\Dev\UTLService\Web.config" |Copy-Item -Destination  "\\cp-websvcdev-03\e$\inetpub\CPWebSVC\UTLService" -Force

Get-ChildItem   "\\as.local\shared\InfoTech\UniTrac_Master_Configs\Test\Dev\WorkItemService\Web.config" |Copy-Item -Destination  "\\cp-websvcdev-01\e$\inetpub\CPWebSVC\WorkItemService" -Force
Get-ChildItem   "\\as.local\shared\InfoTech\UniTrac_Master_Configs\Test\Dev\WorkItemService\Web.config" |Copy-Item -Destination  "\\cp-websvcdev-02\e$\inetpub\CPWebSVC\WorkItemService" -Force
Get-ChildItem   "\\as.local\shared\InfoTech\UniTrac_Master_Configs\Test\Dev\WorkItemService\Web.config" |Copy-Item -Destination  "\\cp-websvcdev-03\e$\inetpub\CPWebSVC\WorkItemService" -Force





Stop-Transcript

if(Test-Path "C:\logs\PowerShell Logs\DevAPI.txt"){
$destination = "C:\logs\PowerShell Logs\DevAPI"+[DateTime]::Now.ToString("yyyyMMdd-HHmmss")+".txt"
Copy-Item -Path "C:\logs\PowerShell Logs\DevAPI.txt" -Destination $destination
}


Remove-Item -Path "C:\logs\PowerShell Logs\DevAPI.txt"