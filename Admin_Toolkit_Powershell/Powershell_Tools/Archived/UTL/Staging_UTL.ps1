#BEFORE STARTING ENSURE THE SOURCEPATH ($SOURCEPATH) HAS BEEN UPDATED TO MOST CURRENT PATH BEFORE DEPLOYING
Start-Transcript -Path "C:\logs\PowerShell Logs\StagingUTL.txt"




Get-ChildItem -Path "\\UTSTAGE-APP3\c$\Program Files\Allied Solutions\UTLBusinessService" -Recurse -ErrorAction SilentlyContinue | 
Remove-Item -Force -Recurse -ErrorAction SilentlyContinue



Get-ChildItem -Path "\\utstage-app2\d$\inetpub\UTL APIs\UTL-Match" -Recurse -ErrorAction SilentlyContinue | 
Remove-Item -Force -Recurse -ErrorAction SilentlyContinue


Get-ChildItem -Path "\\utstage-app2\d$\inetpub\UTL APIs\UTL-Rematch" -Recurse -ErrorAction SilentlyContinue | 
Remove-Item -Force -Recurse -ErrorAction SilentlyContinue


Get-ChildItem -Path "\\utstage-app2\d$\inetpub\UTL APIs\UTL-Service" -Recurse -ErrorAction SilentlyContinue | 
Remove-Item -Force -Recurse -ErrorAction SilentlyContinue

Get-ChildItem -Path "\\utstage-app2\d$\inetpub\UTL APIs\UTL-OCR" -Recurse -ErrorAction SilentlyContinue | 
Remove-Item -Force -Recurse -ErrorAction SilentlyContinue






#BEFORE STARTING ENSURE THE SOURCEPATH ($SOURCEPATH) HAS BEEN UPDATED TO MOST CURRENT PATH BEFORE DEPLOYING
$sourcePath = "\\tfs-build-06\E$\UTL Release\Build Manager\Deploy\UTLBusinessService"
$destPath =  "\\UTSTAGE-APP3\c$\Program Files\Allied Solutions\UTLBusinessService"


Get-ChildItem $sourcePath -Recurse -Include '*.*' | Foreach-Object `
    {
        $destDir = Split-Path ($_.FullName -Replace [regex]::Escape($sourcePath), $destPath)
        if (!(Test-Path $destDir))
        {
            New-Item -ItemType directory $destDir | Out-Null
        }
        Copy-Item $_ -Destination $destDir}


#BEFORE STARTING ENSURE THE SOURCEPATH ($SOURCEPATH) HAS BEEN UPDATED TO MOST CURRENT PATH BEFORE DEPLOYING    
$sourcePath = "\\tfs-build-06\E$\UTL Release\Build Manager\Deploy\UTLApi"
$destPath =  "\\utstage-app2\d$\inetpub\UTL APIs\UTL-Match"


Get-ChildItem $sourcePath -Recurse -Include '*.*' | Foreach-Object `
    {
        $destDir = Split-Path ($_.FullName -Replace [regex]::Escape($sourcePath), $destPath)
        if (!(Test-Path $destDir))
        {
            New-Item -ItemType directory $destDir | Out-Null
        }
        Copy-Item $_ -Destination $destDir}



#BEFORE STARTING ENSURE THE SOURCEPATH ($SOURCEPATH) HAS BEEN UPDATED TO MOST CURRENT PATH BEFORE DEPLOYING    
$sourcePath = "\\tfs-build-06\E$\UTL Release\Build Manager\Deploy\UTLApi"
$destPath =  "\\utstage-app2\d$\inetpub\UTL APIs\UTL-Rematch"


Get-ChildItem $sourcePath -Recurse -Include '*.*' | Foreach-Object `
    {
        $destDir = Split-Path ($_.FullName -Replace [regex]::Escape($sourcePath), $destPath)
        if (!(Test-Path $destDir))
        {
            New-Item -ItemType directory $destDir | Out-Null
        }
        Copy-Item $_ -Destination $destDir}


#BEFORE STARTING ENSURE THE SOURCEPATH ($SOURCEPATH) HAS BEEN UPDATED TO MOST CURRENT PATH BEFORE DEPLOYING    
$sourcePath = "\\tfs-build-06\E$\UTL Release\Build Manager\Deploy\UTLApi"
$destPath =  "\\utstage-app2\d$\inetpub\UTL APIs\UTL-Service"


Get-ChildItem $sourcePath -Recurse -Include '*.*' | Foreach-Object `
    {
        $destDir = Split-Path ($_.FullName -Replace [regex]::Escape($sourcePath), $destPath)
        if (!(Test-Path $destDir))
        {
            New-Item -ItemType directory $destDir | Out-Null
        }
        Copy-Item $_ -Destination $destDir}


#BEFORE STARTING ENSURE THE SOURCEPATH ($SOURCEPATH) HAS BEEN UPDATED TO MOST CURRENT PATH BEFORE DEPLOYING
$sourcePath = "\\tfs-build-06\E$\UTL Release\Build Manager\Deploy\UTLApi"
$destPath =  "\\utstage-app2\d$\inetpub\UTL API\UTL-OCR"


Get-ChildItem $sourcePath -Recurse -Include '*.*' | Foreach-Object `
    {
        $destDir = Split-Path ($_.FullName -Replace [regex]::Escape($sourcePath), $destPath)
        if (!(Test-Path $destDir))
        {
            New-Item -ItemType directory $destDir | Out-Null
        }
        Copy-Item $_ -Destination $destDir}

     




Get-ChildItem   "\\as.local\shared\InfoTech\UniTrac_Master_Configs\Test\Stage\UTLBusinessService\UTLBusinessService.exe.config" |Copy-Item -Destination  "\\UTSTAGE-APP3\c$\Program Files\Allied Solutions\UTLBusinessService"  -Force
    
Get-ChildItem   "\\as.local\shared\InfoTech\UniTrac_Master_Configs\Test\STAGE\API\UTL-Match\Web.config" |Copy-Item -Destination   "\\utstage-app2\d$\inetpub\UTL APIs\UTL-Match" -Force
 
Get-ChildItem   "\\as.local\shared\InfoTech\UniTrac_Master_Configs\Test\STAGE\API\UTL-Rematch\Web.config" |Copy-Item -Destination  "\\utstage-app2\d$\inetpub\UTL APIs\UTL-Rematch" -Force
    
Get-ChildItem   "\\as.local\shared\InfoTech\UniTrac_Master_Configs\Test\STAGE\API\UTL-Service\Web.config" |Copy-Item -Destination  "\\utstage-app2\d$\inetpub\UTL APIs\UTL-Service" -Force

    
Get-ChildItem   "\\as.local\shared\InfoTech\UniTrac_Master_Configs\Test\STAGE\API\UTL-OCR\Web.config" |Copy-Item -Destination  "\\utstage-app2\d$\inetpub\UTL APIs\UTL-OCR" -Force


invoke-command -computername UTSTAGE-APP2 -scriptblock {iisreset /RESTART}

Stop-Transcript

if(Test-Path "C:\logs\PowerShell Logs\StagingUTL.txt"){
$destination = "C:\logs\PowerShell Logs\StagingUTL"+[DateTime]::Now.ToString("yyyyMMdd-HHmmss")+".txt"
Copy-Item -Path "C:\logs\PowerShell Logs\StagingUTL.txt" -Destination $destination
}


Remove-Item -Path "C:\logs\PowerShell Logs\StagingUTL.txt"