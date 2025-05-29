Start-Transcript -Path "C:\logs\PowerShell Logs\PreProd.txt"
$Version = 'Version ReleaseCandidate'

# Delete all Files in C:\temp older than 30 day(s)

$Daysback = "-60"
$CurrentDate = Get-Date
$DatetoDelete = $CurrentDate.AddDays($Daysback)

$Path = "\\Unitrac-PreProd\c$\inetpub\wwwroot\UniTrac\Application Files"
Get-ChildItem $Path | Where-Object { $_.LastWriteTime -lt $DatetoDelete } | Remove-Item -Recurse


$Path = "\\Unitrac-PreProd\c$\inetpub\wwwroot\UniTracSSO"
Get-ChildItem $Path | Where-Object { $_.LastWriteTime -lt $DatetoDelete } | Remove-Item -Recurse

$Path = "\\Unitrac-PreProd\c$\inetpub\wwwroot\VehicleLookupService"
Get-ChildItem $Path | Where-Object { $_.LastWriteTime -lt $DatetoDelete } | Remove-Item -Recurse


$sourcePath = "\\tfs-build-06\E$\UniTrac\Setups\$Version\LDH\UnitracSSO"
$destPath =  "\\Unitrac-PreProd\c$\inetpub\wwwroot\UniTracSSO"


Get-ChildItem $sourcePath -Recurse -Include '*.*' | Foreach-Object `
    {
        $destDir = Split-Path ($_.FullName -Replace [regex]::Escape($sourcePath), $destPath)
        if (!(Test-Path $destDir))
        {
            New-Item -ItemType directory $destDir | Out-Null
        }
        Copy-Item $_ -Destination $destDir}


$sourcePath = "\\tfs-build-06\E$\UniTrac\Setups\$Version\LDH\VehicleLookupService"
$destPath =  "\\Unitrac-PreProd\C$\inetpub\wwwroot\VehicleLookupService"


Get-ChildItem $sourcePath -Recurse -Include '*.*' | Foreach-Object `
    {
        $destDir = Split-Path ($_.FullName -Replace [regex]::Escape($sourcePath), $destPath)
        if (!(Test-Path $destDir))
        {
            New-Item -ItemType directory $destDir | Out-Null
        }
        Copy-Item $_ -Destination $destDir}



Get-ChildItem -Path "\\UTPreProd-APP01\C$\Program Files (x86)\AlliedSolutions\LDHServices\LDHService" -Recurse -ErrorAction SilentlyContinue | 
Remove-Item -Force -Recurse -ErrorAction SilentlyContinue

Get-ChildItem -Path "\\UTPreProd-APP01\C$\Program Files (x86)\AlliedSolutions\LDHServices\LDHServiceUSD" -Recurse -ErrorAction SilentlyContinue | 
Remove-Item -Force -Recurse -ErrorAction SilentlyContinue


 Get-ChildItem -Path "\\UTPreProd-APP01\C$\Program Files (x86)\AlliedSolutions\LDHServices\DirectoryWatcherIn" -Recurse -ErrorAction SilentlyContinue | 
Remove-Item -Force -Recurse -ErrorAction SilentlyContinue

 Get-ChildItem -Path "\\UTPreProd-APP01\C$\Program Files (x86)\AlliedSolutions\LDHServices\DirectoryWatcherOut" -Recurse -ErrorAction SilentlyContinue | 
Remove-Item -Force -Recurse -ErrorAction SilentlyContinue

 Get-ChildItem -Path "\\UTPreProd-APP01\C$\Program Files (x86)\AlliedSolutions\LDHServices\LetterGen" -Recurse -ErrorAction SilentlyContinue | 
Remove-Item -Force -Recurse -ErrorAction SilentlyContinue

 Get-ChildItem -Path "\\UTPreProd-APP01\C$\Program Files (x86)\AlliedSolutions\LDHServices\MSGSRVRBSS" -Recurse -ErrorAction SilentlyContinue | 
Remove-Item -Force -Recurse -ErrorAction SilentlyContinue


 Get-ChildItem -Path "\\UTPreProd-APP01\C$\Program Files (x86)\AlliedSolutions\LDHServices\MSGSRVRDEF" -Recurse -ErrorAction SilentlyContinue | 
Remove-Item -Force -Recurse -ErrorAction SilentlyContinue


 Get-ChildItem -Path "\\UTPreProd-APP01\C$\Program Files (x86)\AlliedSolutions\LDHServices\MSGSRVREDIIDR" -Recurse -ErrorAction SilentlyContinue | 
Remove-Item -Force -Recurse -ErrorAction SilentlyContinue


 Get-ChildItem -Path "\\UTPreProd-APP01\C$\Program Files (x86)\AlliedSolutions\LDHServices\MSGSRVREXTHUNT" -Recurse -ErrorAction SilentlyContinue | 
Remove-Item -Force -Recurse -ErrorAction SilentlyContinue


 Get-ChildItem -Path "\\UTPreProd-APP01\C$\Program Files (x86)\AlliedSolutions\LDHServices\MSGSRVREXTINFO" -Recurse -ErrorAction SilentlyContinue | 
Remove-Item -Force -Recurse -ErrorAction SilentlyContinue


 Get-ChildItem -Path "\\UTPreProd-APP01\C$\Program Files (x86)\AlliedSolutions\LDHServices\MSGSRVREXTUSD" -Recurse -ErrorAction SilentlyContinue | 
Remove-Item -Force -Recurse -ErrorAction SilentlyContinue



 Get-ChildItem -Path "\\UTPreProd-APP01\C$\Program Files (x86)\AlliedSolutions\LDHServices\UnitracBusinessService" -Recurse -ErrorAction SilentlyContinue | 
Remove-Item -Force -Recurse -ErrorAction SilentlyContinue


 Get-ChildItem -Path "\\UTPreProd-APP01\C$\Program Files (x86)\AlliedSolutions\LDHServices\UnitracBusinessServiceCycle" -Recurse -ErrorAction SilentlyContinue | 
Remove-Item -Force -Recurse -ErrorAction SilentlyContinue


 Get-ChildItem -Path "\\UTPreProd-APP01\C$\Program Files (x86)\AlliedSolutions\LDHServices\UnitracBusinessServiceMatchIn" -Recurse -ErrorAction SilentlyContinue | 
Remove-Item -Force -Recurse -ErrorAction SilentlyContinue

 Get-ChildItem -Path "\\UTPreProd-APP01\C$\Program Files (x86)\AlliedSolutions\LDHServices\UnitracBusinessServiceMatchOut" -Recurse -ErrorAction SilentlyContinue | 
Remove-Item -Force -Recurse -ErrorAction SilentlyContinue


 Get-ChildItem -Path "\\UTPreProd-APP01\C$\Program Files (x86)\AlliedSolutions\LDHServices\UnitracBusinessServicePRT" -Recurse -ErrorAction SilentlyContinue | 
Remove-Item -Force -Recurse -ErrorAction SilentlyContinue

 Get-ChildItem -Path "\\UTPreProd-APP01\C$\Program Files (x86)\AlliedSolutions\LDHServices\UnitracBusinessServiceRPT" -Recurse -ErrorAction SilentlyContinue | 
Remove-Item -Force -Recurse -ErrorAction SilentlyContinue

 Get-ChildItem -Path "\\UTPreProd-APP01\C$\Program Files (x86)\AlliedSolutions\LDHServices\UnitracSyncService" -Recurse -ErrorAction SilentlyContinue | 
Remove-Item -Force -Recurse -ErrorAction SilentlyContinue

 Get-ChildItem -Path "\\UTPreProd-APP01\C$\Program Files (x86)\AlliedSolutions\LDHServices\WorkflowService" -Recurse -ErrorAction SilentlyContinue | 
Remove-Item -Force -Recurse -ErrorAction SilentlyContinue









$sourcePath = "\\tfs-build-06\E$\UniTrac\Setups\$Version\LDH\LDHService"
$destPath =  "\\UTPreProd-APP01\C$\Program Files (x86)\AlliedSolutions\LDHServices\LDHService"


Get-ChildItem $sourcePath -Recurse -Include '*.*' | Foreach-Object `
    {
        $destDir = Split-Path ($_.FullName -Replace [regex]::Escape($sourcePath), $destPath)
        if (!(Test-Path $destDir))
        {
            New-Item -ItemType directory $destDir | Out-Null
        }
        Copy-Item $_ -Destination $destDir}

    
$sourcePath = "\\tfs-build-06\E$\UniTrac\Setups\$Version\LDH\LDHService"
$destPath =  "\\UTPreProd-APP01\C$\Program Files (x86)\AlliedSolutions\LDHServices\LDHServiceUSD"


Get-ChildItem $sourcePath -Recurse -Include '*.*' | Foreach-Object `
    {
        $destDir = Split-Path ($_.FullName -Replace [regex]::Escape($sourcePath), $destPath)
        if (!(Test-Path $destDir))
        {
            New-Item -ItemType directory $destDir | Out-Null
        }
        Copy-Item $_ -Destination $destDir}

    


$sourcePath = "\\tfs-build-06\E`$\UniTrac\Setups\$Version\LDH\UnitracBusinessService"
$destPath =  "\\UTPreProd-APP01\C$\Program Files (x86)\AlliedSolutions\LDHServices\UnitracBusinessService"


Get-ChildItem $sourcePath -Recurse -Include '*.*' | Foreach-Object `
    {
        $destDir = Split-Path ($_.FullName -Replace [regex]::Escape($sourcePath), $destPath)
        if (!(Test-Path $destDir))
        {
            New-Item -ItemType directory $destDir | Out-Null
        }
        Copy-Item $_ -Destination $destDir}




$sourcePath = "\\tfs-build-06\E`$\UniTrac\Setups\$Version\LDH\UnitracBusinessService"
$destPath =  "\\UTPreProd-APP01\C$\Program Files (x86)\AlliedSolutions\LDHServices\UnitracBusinessServiceCycle"


Get-ChildItem $sourcePath -Recurse -Include '*.*' | Foreach-Object `
    {
        $destDir = Split-Path ($_.FullName -Replace [regex]::Escape($sourcePath), $destPath)
        if (!(Test-Path $destDir))
        {
            New-Item -ItemType directory $destDir | Out-Null
        }
        Copy-Item $_ -Destination $destDir}


$sourcePath = "\\tfs-build-06\E`$\UniTrac\Setups\$Version\LDH\UnitracBusinessService"
$destPath =  "\\UTPreProd-APP01\C$\Program Files (x86)\AlliedSolutions\LDHServices\UnitracBusinessServiceMatchIn"


Get-ChildItem $sourcePath -Recurse -Include '*.*' | Foreach-Object `
    {
        $destDir = Split-Path ($_.FullName -Replace [regex]::Escape($sourcePath), $destPath)
        if (!(Test-Path $destDir))
        {
            New-Item -ItemType directory $destDir | Out-Null
        }
        Copy-Item $_ -Destination $destDir}



$sourcePath = "\\tfs-build-06\E`$\UniTrac\Setups\$Version\LDH\UnitracBusinessService"
$destPath =  "\\UTPreProd-APP01\C$\Program Files (x86)\AlliedSolutions\LDHServices\UnitracBusinessServiceMatchOut"


Get-ChildItem $sourcePath -Recurse -Include '*.*' | Foreach-Object `
    {
        $destDir = Split-Path ($_.FullName -Replace [regex]::Escape($sourcePath), $destPath)
        if (!(Test-Path $destDir))
        {
            New-Item -ItemType directory $destDir | Out-Null
        }
        Copy-Item $_ -Destination $destDir}




$sourcePath = "\\tfs-build-06\E`$\UniTrac\Setups\$Version\LDH\UnitracBusinessService"
$destPath =  "\\UTPreProd-APP01\C$\Program Files (x86)\AlliedSolutions\LDHServices\UnitracBusinessServicePRT"


Get-ChildItem $sourcePath -Recurse -Include '*.*' | Foreach-Object `
    {
        $destDir = Split-Path ($_.FullName -Replace [regex]::Escape($sourcePath), $destPath)
        if (!(Test-Path $destDir))
        {
            New-Item -ItemType directory $destDir | Out-Null
        }
        Copy-Item $_ -Destination $destDir}



$sourcePath = "\\tfs-build-06\E`$\UniTrac\Setups\$Version\LDH\UnitracBusinessService"
$destPath =  "\\UTPreProd-APP01\C$\Program Files (x86)\AlliedSolutions\LDHServices\UnitracBusinessServiceRPT"


Get-ChildItem $sourcePath -Recurse -Include '*.*' | Foreach-Object `
    {
        $destDir = Split-Path ($_.FullName -Replace [regex]::Escape($sourcePath), $destPath)
        if (!(Test-Path $destDir))
        {
            New-Item -ItemType directory $destDir | Out-Null
        }
        Copy-Item $_ -Destination $destDir}



$sourcePath = "\\tfs-build-06\E`$\UniTrac\Setups\$Version\LDH\UnitracBusinessService"
$destPath =  "\\UTPreProd-APP01\C$\Program Files (x86)\AlliedSolutions\LDHServices\UnitracSyncService"


Get-ChildItem $sourcePath -Recurse -Include '*.*' | Foreach-Object `
    {
        $destDir = Split-Path ($_.FullName -Replace [regex]::Escape($sourcePath), $destPath)
        if (!(Test-Path $destDir))
        {
            New-Item -ItemType directory $destDir | Out-Null
        }
        Copy-Item $_ -Destination $destDir}


$sourcePath = "\\tfs-build-06\E`$\UniTrac\Setups\$Version\LDH\UnitracBusinessService"
$destPath =  "\\UTPreProd-APP01\C$\Program Files (x86)\AlliedSolutions\LDHServices\LetterGen"


Get-ChildItem $sourcePath -Recurse -Include '*.*' | Foreach-Object `
    {
        $destDir = Split-Path ($_.FullName -Replace [regex]::Escape($sourcePath), $destPath)
        if (!(Test-Path $destDir))
        {
            New-Item -ItemType directory $destDir | Out-Null
        }
        Copy-Item $_ -Destination $destDir}

$sourcePath = "\\tfs-build-06\E`$\UniTrac\Setups\$Version\LDH\DirectoryWatcherServer"
$destPath =  "\\UTPreProd-APP01\C$\Program Files (x86)\AlliedSolutions\LDHServices\DirectoryWatcherIn"


Get-ChildItem $sourcePath -Recurse -Include '*.*' | Foreach-Object `
    {
        $destDir = Split-Path ($_.FullName -Replace [regex]::Escape($sourcePath), $destPath)
        if (!(Test-Path $destDir))
        {
            New-Item -ItemType directory $destDir | Out-Null
        }
        Copy-Item $_ -Destination $destDir}

$sourcePath = "\\tfs-build-06\E`$\UniTrac\Setups\$Version\LDH\DirectoryWatcherServer"
$destPath =  "\\UTPreProd-APP01\C$\Program Files (x86)\AlliedSolutions\LDHServices\DirectoryWatcherOut"


Get-ChildItem $sourcePath -Recurse -Include '*.*' | Foreach-Object `
    {
        $destDir = Split-Path ($_.FullName -Replace [regex]::Escape($sourcePath), $destPath)
        if (!(Test-Path $destDir))
        {
            New-Item -ItemType directory $destDir | Out-Null
        }
        Copy-Item $_ -Destination $destDir}


$sourcePath = "\\tfs-build-06\E`$\UniTrac\Setups\$Version\LDH\MessageServer"
$destPath =  "\\UTPreProd-APP01\C$\Program Files (x86)\AlliedSolutions\LDHServices\MSGSRVRBSS"


Get-ChildItem $sourcePath -Recurse -Include '*.*' | Foreach-Object `
    {
        $destDir = Split-Path ($_.FullName -Replace [regex]::Escape($sourcePath), $destPath)
        if (!(Test-Path $destDir))
        {
            New-Item -ItemType directory $destDir | Out-Null
        }
        Copy-Item $_ -Destination $destDir}


$sourcePath = "\\tfs-build-06\E`$\UniTrac\Setups\$Version\LDH\MessageServer"
$destPath =  "\\UTPreProd-APP01\C$\Program Files (x86)\AlliedSolutions\LDHServices\MSGSRVRDEF"


Get-ChildItem $sourcePath -Recurse -Include '*.*' | Foreach-Object `
    {
        $destDir = Split-Path ($_.FullName -Replace [regex]::Escape($sourcePath), $destPath)
        if (!(Test-Path $destDir))
        {
            New-Item -ItemType directory $destDir | Out-Null
        }
        Copy-Item $_ -Destination $destDir}




$sourcePath = "\\tfs-build-06\E`$\UniTrac\Setups\$Version\LDH\MessageServer"
$destPath =  "\\UTPreProd-APP01\C$\Program Files (x86)\AlliedSolutions\LDHServices\MSGSRVREDIIDR"


Get-ChildItem $sourcePath -Recurse -Include '*.*' | Foreach-Object `
    {
        $destDir = Split-Path ($_.FullName -Replace [regex]::Escape($sourcePath), $destPath)
        if (!(Test-Path $destDir))
        {
            New-Item -ItemType directory $destDir | Out-Null
        }
        Copy-Item $_ -Destination $destDir}

        


$sourcePath = "\\tfs-build-06\E`$\UniTrac\Setups\$Version\LDH\MessageServer"
$destPath =  "\\UTPreProd-APP01\C$\Program Files (x86)\AlliedSolutions\LDHServices\MSGSRVREXTHUNT"


Get-ChildItem $sourcePath -Recurse -Include '*.*' | Foreach-Object `
    {
        $destDir = Split-Path ($_.FullName -Replace [regex]::Escape($sourcePath), $destPath)
        if (!(Test-Path $destDir))
        {
            New-Item -ItemType directory $destDir | Out-Null
        }
        Copy-Item $_ -Destination $destDir}

$sourcePath = "\\tfs-build-06\E`$\UniTrac\Setups\$Version\LDH\MessageServer"
$destPath =  "\\UTPreProd-APP01\C$\Program Files (x86)\AlliedSolutions\LDHServices\MSGSRVREXTINFO"


Get-ChildItem $sourcePath -Recurse -Include '*.*' | Foreach-Object `
    {
        $destDir = Split-Path ($_.FullName -Replace [regex]::Escape($sourcePath), $destPath)
        if (!(Test-Path $destDir))
        {
            New-Item -ItemType directory $destDir | Out-Null
        }
        Copy-Item $_ -Destination $destDir}




$sourcePath = "\\tfs-build-06\E`$\UniTrac\Setups\$Version\LDH\MessageServer"
$destPath =  "\\UTPreProd-APP01\C$\Program Files (x86)\AlliedSolutions\LDHServices\MSGSRVREXTUSD"


Get-ChildItem $sourcePath -Recurse -Include '*.*' | Foreach-Object `
    {
        $destDir = Split-Path ($_.FullName -Replace [regex]::Escape($sourcePath), $destPath)
        if (!(Test-Path $destDir))
        {
            New-Item -ItemType directory $destDir | Out-Null
        }
        Copy-Item $_ -Destination $destDir}


    
$sourcePath = "\\tfs-build-06\E`$\UniTrac\Setups\$Version\LDH\OspreyWorkflowService"
$destPath =  "\\UTPreProd-APP01\C$\Program Files (x86)\AlliedSolutions\LDHServices\WorkflowService"


Get-ChildItem $sourcePath -Recurse -Include '*.*' | Foreach-Object `
    {
        $destDir = Split-Path ($_.FullName -Replace [regex]::Escape($sourcePath), $destPath)
        if (!(Test-Path $destDir))
        {
            New-Item -ItemType directory $destDir | Out-Null
        }
        Copy-Item $_ -Destination $destDir}






Get-ChildItem   "\\as.local\shared\InfoTech\UniTrac_Master_Configs\Test\PreProd\DirectoryWatcherIn\Osprey.DirectoryWatcherServer.exe.config" |Copy-Item -Destination  "\\UTPreProd-APP01\C$\Program Files (x86)\AlliedSolutions\LDHServices\DirectoryWatcherIn"  -Force
    
Get-ChildItem   "\\as.local\shared\InfoTech\UniTrac_Master_Configs\Test\PreProd\DirectoryWatcherOut\Osprey.DirectoryWatcherServer.exe.config" |Copy-Item -Destination   "\\UTPreProd-APP01\C$\Program Files (x86)\AlliedSolutions\LDHServices\DirectoryWatcherOut" -Force
 
Get-ChildItem   "\\as.local\shared\InfoTech\UniTrac_Master_Configs\Test\PreProd\LDHService\Osprey.LDHService.exe.config" |Copy-Item -Destination  "\\UTPreProd-APP01\C$\Program Files (x86)\AlliedSolutions\LDHServices\LDHService" -Force
    
Get-ChildItem   "\\as.local\shared\InfoTech\UniTrac_Master_Configs\Test\PreProd\LDHServiceUSD\Osprey.LDHService.exe.config" |Copy-Item -Destination  "\\UTPreProd-APP01\C$\Program Files (x86)\AlliedSolutions\LDHServices\LDHServiceUSD" -Force

Get-ChildItem   "\\as.local\shared\InfoTech\UniTrac_Master_Configs\Test\PreProd\MSGSRVRBSS\Osprey.MessageServer.exe.config" |Copy-Item -Destination  "\\UTPreProd-APP01\C$\Program Files (x86)\AlliedSolutions\LDHServices\MSGSRVRBSS" -Force
 
Get-ChildItem   "\\as.local\shared\InfoTech\UniTrac_Master_Configs\Test\PreProd\MSGSRVRDEF\Osprey.MessageServer.exe.config" |Copy-Item -Destination  "\\UTPreProd-APP01\C$\Program Files (x86)\AlliedSolutions\LDHServices\MSGSRVRDEF" -Force
    
Get-ChildItem   "\\as.local\shared\InfoTech\UniTrac_Master_Configs\Test\PreProd\MSGSRVREDIIDR\Osprey.MessageServer.exe.config" |Copy-Item -Destination  "\\UTPreProd-APP01\C$\Program Files (x86)\AlliedSolutions\LDHServices\MSGSRVREDIIDR" -Force

Get-ChildItem   "\\as.local\shared\InfoTech\UniTrac_Master_Configs\Test\PreProd\MSGSRVREXTHUNT\Osprey.MessageServer.exe.config" |Copy-Item -Destination  "\\UTPreProd-APP01\C$\Program Files (x86)\AlliedSolutions\LDHServices\MSGSRVREXTHUNT" -Force

Get-ChildItem   "\\as.local\shared\InfoTech\UniTrac_Master_Configs\Test\PreProd\MSGSRVREXTINFO\Osprey.MessageServer.exe.config" |Copy-Item -Destination  "\\UTPreProd-APP01\C$\Program Files (x86)\AlliedSolutions\LDHServices\MSGSRVREXTINFO" -Force
    
Get-ChildItem   "\\as.local\shared\InfoTech\UniTrac_Master_Configs\Test\PreProd\MSGSRVREXTUSD\Osprey.MessageServer.exe.config" |Copy-Item -Destination  "\\UTPreProd-APP01\C$\Program Files (x86)\AlliedSolutions\LDHServices\MSGSRVREXTUSD" -Force

Get-ChildItem   "\\as.local\shared\InfoTech\UniTrac_Master_Configs\Test\PreProd\UnitracBusinessService\UnitracBusinessService.exe.config" |Copy-Item -Destination  "\\UTPreProd-APP01\C$\Program Files (x86)\AlliedSolutions\LDHServices\UnitracBusinessService"  -Force
    
Get-ChildItem   "\\as.local\shared\InfoTech\UniTrac_Master_Configs\Test\PreProd\UnitracBusinessServiceCycle\UnitracBusinessService.exe.config" |Copy-Item -Destination  "\\UTPreProd-APP01\C$\Program Files (x86)\AlliedSolutions\LDHServices\UnitracBusinessServiceCycle"  -Force

Get-ChildItem   "\\as.local\shared\InfoTech\UniTrac_Master_Configs\Test\PreProd\UnitracBusinessServiceMatchIn\UnitracBusinessService.exe.config" |Copy-Item -Destination  "\\UTPreProd-APP01\C$\Program Files (x86)\AlliedSolutions\LDHServices\UnitracBusinessServiceMatchIn"  -Force

Get-ChildItem   "\\as.local\shared\InfoTech\UniTrac_Master_Configs\Test\PreProd\UnitracBusinessServiceMatchOut\UnitracBusinessService.exe.config" |Copy-Item -Destination  "\\UTPreProd-APP01\C$\Program Files (x86)\AlliedSolutions\LDHServices\UnitracBusinessServiceMatchOut" -Force
    
Get-ChildItem   "\\as.local\shared\InfoTech\UniTrac_Master_Configs\Test\PreProd\UnitracBusinessServicePRT\UnitracBusinessService.exe.config" |Copy-Item -Destination  "\\UTPreProd-APP01\C$\Program Files (x86)\AlliedSolutions\LDHServices\UnitracBusinessServicePRT" -Force

Get-ChildItem   "\\as.local\shared\InfoTech\UniTrac_Master_Configs\Test\PreProd\UnitracBusinessServiceRPT\UnitracBusinessService.exe.config" |Copy-Item -Destination  "\\UTPreProd-APP01\C$\Program Files (x86)\AlliedSolutions\LDHServices\UnitracBusinessServiceRPT" -Force

Get-ChildItem   "\\as.local\shared\InfoTech\UniTrac_Master_Configs\Test\PreProd\UnitracSyncService\UnitracSyncService.exe.config" |Copy-Item -Destination  "\\UTPreProd-APP01\C$\Program Files (x86)\AlliedSolutions\LDHServices\UnitracSyncService" -Force

Get-ChildItem   "\\as.local\shared\InfoTech\UniTrac_Master_Configs\Test\PreProd\WorkflowService\OspreyWorkflowService.exe.config" |Copy-Item -Destination  "\\UTPreProd-APP01\C$\Program Files (x86)\AlliedSolutions\LDHServices\WorkflowService" -Force

Get-ChildItem   "\\as.local\shared\InfoTech\UniTrac_Master_Configs\Test\PreProd\UniTracServer\Web.config" |Copy-Item -Destination  "\\Unitrac-PreProd\C$\inetpub\wwwroot\UniTracServer" -Force

Get-ChildItem   "\\as.local\shared\InfoTech\UniTrac_Master_Configs\Test\PreProd\UniTracSSO\Web.config" |Copy-Item -Destination  "\\Unitrac-PreProd\C$\inetpub\wwwroot\UniTracSSO" -Force
            
Get-ChildItem   "\\as.local\shared\InfoTech\UniTrac_Master_Configs\Test\PreProd\VehicleLookupService\Web.config" |Copy-Item -Destination   "\\Unitrac-PreProd\c$\inetpub\wwwroot\VehicleLookupService" -Force


Stop-Transcript

if(Test-Path "C:\logs\PowerShell Logs\PreProd.txt"){
$destination = "C:\logs\PowerShell Logs\PreProd"+[DateTime]::Now.ToString("yyyyMMdd-HHmmss")+".txt"
Copy-Item -Path "C:\logs\PowerShell Logs\PreProd.txt" -Destination $destination
}


Remove-Item -Path "C:\logs\PowerShell Logs\PreProd.txt"