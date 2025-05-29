#BEFORE STARTING ENSURE THE SOURCEPATH ($SOURCEPATH) HAS BEEN UPDATED TO MOST CURRENT PATH BEFORE DEPLOYING
#BEFORE STARTING ENSURE THE SOURCEPATH ($SOURCEPATH) HAS BEEN UPDATED TO MOST CURRENT PATH BEFORE DEPLOYING

Start-Transcript -Path "\\usd-rd02\c$\logs\PowerShell Logs\ProductionAPI.txt"



Get-ChildItem -Path "\\utprod-api-01\e$\inetpub\UTL APIs\UTL-Rematch" -Recurse -ErrorAction SilentlyContinue | 
Remove-Item -Force -Recurse -ErrorAction SilentlyContinue

Get-ChildItem -Path "\\utprod-api-01\e$\inetpub\UTL APIs\UTL-Match" -Recurse -ErrorAction SilentlyContinue | 
Remove-Item -Force -Recurse -ErrorAction SilentlyContinue


Get-ChildItem -Path "\\utprod-api-01\e$\inetpub\UTL APIs\UTL-OCR" -Recurse -ErrorAction SilentlyContinue | 
Remove-Item -Force -Recurse -ErrorAction SilentlyContinue


#BEFORE STARTING ENSURE THE SOURCEPATH ($SOURCEPATH) HAS BEEN UPDATED TO MOST CURRENT PATH BEFORE DEPLOYING
$sourcePath = "\\tfs-build-07\E$\UTL Hotfix\Build Manager\Deploy\UTLApi"
$destPath =  "\\utprod-api-01\e$\inetpub\UTL APIs\UTL-Rematch"


Get-ChildItem $sourcePath -Recurse -Include '*.*' | Foreach-Object `
    {
        $destDir = Split-Path ($_.FullName -Replace [regex]::Escape($sourcePath), $destPath)
        if (!(Test-Path $destDir))
        {
            New-Item -ItemType directory $destDir | Out-Null
        }
        Copy-Item $_ -Destination $destDir}

    
$sourcePath = "\\tfs-build-07\E$\UTL Hotfix\Build Manager\Deploy\UTLApi"
$destPath =  "\\utprod-api-01\e$\inetpub\UTL APIs\UTL-Match"


Get-ChildItem $sourcePath -Recurse -Include '*.*' | Foreach-Object `
    {
        $destDir = Split-Path ($_.FullName -Replace [regex]::Escape($sourcePath), $destPath)
        if (!(Test-Path $destDir))
        {
            New-Item -ItemType directory $destDir | Out-Null
        }
        Copy-Item $_ -Destination $destDir}

    


$sourcePath = "\\tfs-build-07\E$\UTL Hotfix\Build Manager\Deploy\UTLApi"
$destPath =  "\\utprod-api-01\e$\inetpub\UTL APIs\UTL-OCR"


Get-ChildItem $sourcePath -Recurse -Include '*.*' | Foreach-Object `
    {
        $destDir = Split-Path ($_.FullName -Replace [regex]::Escape($sourcePath), $destPath)
        if (!(Test-Path $destDir))
        {
            New-Item -ItemType directory $destDir | Out-Null
        }
        Copy-Item $_ -Destination $destDir}



        
Get-ChildItem   "\\as.local\shared\InfoTech\UniTrac_Master_Configs\Prod\API\UTL-Match\web.config" |Copy-Item -Destination  "\\utprod-api-01\e$\inetpub\UTL APIs\UTL-Match"  -Force
Get-ChildItem   "\\as.local\shared\InfoTech\UniTrac_Master_Configs\Prod\API\UTL-OCR\web.config" |Copy-Item -Destination  "\\utprod-api-01\e$\inetpub\UTL APIs\UTL-OCR"  -Force
Get-ChildItem   "\\as.local\shared\InfoTech\UniTrac_Master_Configs\Prod\API\UTL-Rematch\web.config" |Copy-Item -Destination  "\\utprod-api-01\e$\inetpub\UTL APIs\UTL-Rematch"  -Force

Stop-Transcript

if(Test-Path "\\usd-rd02\c$\logs\PowerShell Logs\ProductionAPI.txt"){
$destination = "\\usd-rd02\c$\logs\PowerShell Logs\ProductionAPI"+[DateTime]::Now.ToString("yyyyMMdd-HHmmss")+".txt"
Copy-Item -Path "\\usd-rd02\c$\logs\PowerShell Logs\ProductionAPI.txt" -Destination $destination
}


Remove-Item -Path "\\usd-rd02\c$\logs\PowerShell Logs\ProductionAPI.txt"