Start-Transcript -Path "C:\logs\PowerShell Logs\QA2UTL.txt"


Get-Service	 -ComputerName	UTQA2-APP1	  -Name	UTLBusinessService| Stop-Service -Force -NoWait


Get-ChildItem -Path "\\utqa2-app1\c$\Program Files\Allied Solutions\UTLBusinessService" -Recurse -ErrorAction SilentlyContinue | 
Remove-Item -Force -Recurse -ErrorAction SilentlyContinue



Get-ChildItem -Path "\\utqa2-app1\c$\inetpub\UTL API\UTL-Match" -Recurse -ErrorAction SilentlyContinue | 
Remove-Item -Force -Recurse -ErrorAction SilentlyContinue


Get-ChildItem -Path "\\utqa2-app1\c$\inetpub\UTL API\UTL-Rematch" -Recurse -ErrorAction SilentlyContinue | 
Remove-Item -Force -Recurse -ErrorAction SilentlyContinue


Get-ChildItem -Path "\\utqa2-app1\c$\inetpub\UTL API\UTL-Service" -Recurse -ErrorAction SilentlyContinue | 
Remove-Item -Force -Recurse -ErrorAction SilentlyContinue

Get-ChildItem -Path "\\utqa2-app1\c$\inetpub\UTL API\UTL-OCR" -Recurse -ErrorAction SilentlyContinue | 
Remove-Item -Force -Recurse -ErrorAction SilentlyContinue







$sourcePath = "\\tfs-build-06\E$\UTL Release\Build Manager\Deploy\UTLBusinessService"
$destPath =  "\\utqa2-app1\c$\Program Files\Allied Solutions\UTLBusinessService"


Get-ChildItem $sourcePath -Recurse -Include '*.*' | Foreach-Object `
    {
        $destDir = Split-Path ($_.FullName -Replace [regex]::Escape($sourcePath), $destPath)
        if (!(Test-Path $destDir))
        {
            New-Item -ItemType directory $destDir | Out-Null
        }
        Copy-Item $_ -Destination $destDir}

    
$sourcePath = "\\tfs-build-06\E$\UTL Release\Build Manager\Deploy\UTLApi"
$destPath =  "\\utqa2-app1\c$\inetpub\UTL API\UTL-Match"


Get-ChildItem $sourcePath -Recurse -Include '*.*' | Foreach-Object `
    {
        $destDir = Split-Path ($_.FullName -Replace [regex]::Escape($sourcePath), $destPath)
        if (!(Test-Path $destDir))
        {
            New-Item -ItemType directory $destDir | Out-Null
        }
        Copy-Item $_ -Destination $destDir}


    
$sourcePath = "\\tfs-build-06\E$\UTL Release\Build Manager\Deploy\UTLApi"
$destPath =  "\\utqa2-app1\c$\inetpub\UTL API\UTL-Rematch"


Get-ChildItem $sourcePath -Recurse -Include '*.*' | Foreach-Object `
    {
        $destDir = Split-Path ($_.FullName -Replace [regex]::Escape($sourcePath), $destPath)
        if (!(Test-Path $destDir))
        {
            New-Item -ItemType directory $destDir | Out-Null
        }
        Copy-Item $_ -Destination $destDir}

    
$sourcePath = "\\tfs-build-06\E$\UTL Release\Build Manager\Deploy\UTLApi"
$destPath =  "\\utqa2-app1\c$\inetpub\UTL API\UTL-Service"


Get-ChildItem $sourcePath -Recurse -Include '*.*' | Foreach-Object `
    {
        $destDir = Split-Path ($_.FullName -Replace [regex]::Escape($sourcePath), $destPath)
        if (!(Test-Path $destDir))
        {
            New-Item -ItemType directory $destDir | Out-Null
        }
        Copy-Item $_ -Destination $destDir}


$sourcePath = "\\tfs-build-06\E$\UTL Release\Build Manager\Deploy\UTLApi"
$destPath =  "\\utqa2-app1\c$\inetpub\UTL API\UTL-OCR"


Get-ChildItem $sourcePath -Recurse -Include '*.*' | Foreach-Object `
    {
        $destDir = Split-Path ($_.FullName -Replace [regex]::Escape($sourcePath), $destPath)
        if (!(Test-Path $destDir))
        {
            New-Item -ItemType directory $destDir | Out-Null
        }
        Copy-Item $_ -Destination $destDir}

     




Get-ChildItem   "\\as.local\shared\InfoTech\UniTrac_Master_Configs\Test\QA2\UTLBusinessService\UTLBusinessService.exe.config" |Copy-Item -Destination  "\\utqa2-app1\c$\Program Files\Allied Solutions\UTLBusinessService"  -Force
    
Get-ChildItem   "\\as.local\shared\InfoTech\UniTrac_Master_Configs\Test\QA2\UTL-Match\Web.config" |Copy-Item -Destination   "\\utqa2-app1\c$\inetpub\UTL API\UTL-Match" -Force
 
Get-ChildItem   "\\as.local\shared\InfoTech\UniTrac_Master_Configs\Test\QA2\UTL-Rematch\Web.config" |Copy-Item -Destination  "\\utqa2-app1\c$\inetpub\UTL API\UTL-Rematch" -Force
    
Get-ChildItem   "\\as.local\shared\InfoTech\UniTrac_Master_Configs\Test\QA2\UTL-Service\Web.config" |Copy-Item -Destination  "\\utqa2-app1\c$\inetpub\UTL API\UTL-Service" -Force

    
Get-ChildItem   "\\as.local\shared\InfoTech\UniTrac_Master_Configs\Test\QA2\UTL-OCR\Web.config" |Copy-Item -Destination  "\\utqa2-app1\c$\inetpub\UTL API\UTL-OCR" -Force


Get-Service	 -ComputerName	UTQA2-APP1	  -Name	UTLBusinessService |  Start-Service
invoke-command -computername UTQA2-APP1 -scriptblock {iisreset /RESTART}

Stop-Transcript

if(Test-Path "C:\logs\PowerShell Logs\QA2UTL.txt"){
$destination = "C:\logs\PowerShell Logs\QA2UTL"+[DateTime]::Now.ToString("yyyyMMdd-HHmmss")+".txt"
Copy-Item -Path "C:\logs\PowerShell Logs\QA2UTL.txt" -Destination $destination
}


Remove-Item -Path "C:\logs\PowerShell Logs\QA2UTL.txt"