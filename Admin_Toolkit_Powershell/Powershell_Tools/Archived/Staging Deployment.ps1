Get-Service	 -ComputerName	UTSTAGE-APP1	  -Name	UnitracBusinessServiceCycle | Stop-Service -Force -NoWait
Get-Service	 -ComputerName	UTSTAGE-APP1	  -Name	UnitracBusinessServicePRT  |Stop-Service -Force -NoWait
Get-Service	 -ComputerName	UTSTAGE-APP1	  -Name	UnitracBusinessServiceMatchOut |Stop-Service -Force -NoWait
Get-Service	 -ComputerName	UTSTAGE-APP1	  -Name	UnitracBusinessServiceRPT |Stop-Service -Force -NoWait
Get-Service	 -ComputerName	UTSTAGE-APP1	  -Name	UnitracBusinessServiceBackfeed |Stop-Service -Force -NoWait
Get-Service	 -ComputerName	UTSTAGE-APP4	  -Name	UnitracBusinessServiceCycle2 |Stop-Service -Force -NoWait
Get-Service	 -ComputerName	UTSTAGE-ASR1	  -Name	UnitracBusinessServiceDist | Stop-Service  -Force -NoWait
Get-Service	 -ComputerName	UTSTAGE-ASR1	  -Name	UnitracBusinessServiceProc1 | Stop-Service  -Force -NoWait
Get-Service	 -ComputerName	UTSTAGE-ASR2	  -Name	UnitracBusinessServiceProc2 | Stop-Service  -Force -NoWait
Get-Service	 -ComputerName	UTSTAGE-ASR3	  -Name	UnitracBusinessServiceProc3 | Stop-Service  -Force -NoWait



Get-ChildItem -Path "\\UTSTAGE-APP1\c$\Program Files\Allied Solutions\UnitracBusinessServiceCycle" -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
Get-ChildItem -Path "\\UTSTAGE-APP1\c$\Program Files\Allied Solutions\UnitracBusinessServicePRT" -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
Get-ChildItem -Path "\\UTSTAGE-APP1\c$\Program Files\Allied Solutions\UnitracBusinessServiceMatchOut" -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
Get-ChildItem -Path "\\UTSTAGE-APP1\c$\Program Files\Allied Solutions\UnitracBusinessServiceRPT" -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
Get-ChildItem -Path "\\UTSTAGE-APP1\c$\Program Files\Allied Solutions\UnitracBusinessServiceBackfeed" -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
Get-ChildItem -Path "\\UTSTAGE-APP4\c$\Program Files\Allied Solutions\UnitracBusinessServiceCycle2" -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
Get-ChildItem -Path "\\UTSTAGE-ASR1\c$\Program Files\Allied Solutions\UnitracBusinessServiceDist" -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
Get-ChildItem -Path "\\UTSTAGE-ASR1\c$\Program Files\Allied Solutions\UnitracBusinessServiceProc1" -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
Get-ChildItem -Path "\\UTSTAGE-ASR2\c$\Program Files\Allied Solutions\UnitracBusinessServiceProc2" -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
Get-ChildItem -Path "\\UTSTAGE-ASR3\c$\Program Files\Allied Solutions\UnitracBusinessServiceProc3" -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue


$sourcePath = "\\tfs-build-06\e$\UniTrac\Setups\Version ReleaseCandidate\LDH\UnitracBusinessService"
$destPath =  "\\UTSTAGE-APP1\c$\Program Files\Allied Solutions\UnitracBusinessServiceCycle"


Get-ChildItem $sourcePath -Recurse -Include '*.*' | Foreach-Object `
    {
        $destDir = Split-Path ($_.FullName -Replace [regex]::Escape($sourcePath), $destPath)
        if (!(Test-Path $destDir))
        {
            New-Item -ItemType directory $destDir | Out-Null
        }
        Copy-Item $_ -Destination $destDir}



$sourcePath = "\\tfs-build-06\e$\UniTrac\Setups\Version ReleaseCandidate\LDH\UnitracBusinessService"
$destPath =  "\\UTSTAGE-APP1\c$\Program Files\Allied Solutions\UnitracBusinessServicePRT"


Get-ChildItem $sourcePath -Recurse -Include '*.*' | Foreach-Object `
    {
        $destDir = Split-Path ($_.FullName -Replace [regex]::Escape($sourcePath), $destPath)
        if (!(Test-Path $destDir))
        {
            New-Item -ItemType directory $destDir | Out-Null
        }
        Copy-Item $_ -Destination $destDir}




$sourcePath = "\\tfs-build-06\e$\UniTrac\Setups\Version ReleaseCandidate\LDH\UnitracBusinessService"
$destPath =  "\\UTSTAGE-APP1\c$\Program Files\Allied Solutions\UnitracBusinessServiceMatchOut"


Get-ChildItem $sourcePath -Recurse -Include '*.*' | Foreach-Object `
    {
        $destDir = Split-Path ($_.FullName -Replace [regex]::Escape($sourcePath), $destPath)
        if (!(Test-Path $destDir))
        {
            New-Item -ItemType directory $destDir | Out-Null
        }
        Copy-Item $_ -Destination $destDir}




$sourcePath = "\\tfs-build-06\e$\UniTrac\Setups\Version ReleaseCandidate\LDH\UnitracBusinessService"
$destPath =  "\\UTSTAGE-APP1\c$\Program Files\Allied Solutions\UnitracBusinessServiceRPT"


Get-ChildItem $sourcePath -Recurse -Include '*.*' | Foreach-Object `
    {
        $destDir = Split-Path ($_.FullName -Replace [regex]::Escape($sourcePath), $destPath)
        if (!(Test-Path $destDir))
        {
            New-Item -ItemType directory $destDir | Out-Null
        }
        Copy-Item $_ -Destination $destDir}

$sourcePath = "\\tfs-build-06\e$\UniTrac\Setups\Version ReleaseCandidate\LDH\UnitracBusinessService"
$destPath =  "\\UTSTAGE-APP1\c$\Program Files\Allied Solutions\UnitracBusinessServiceBackfeed"


Get-ChildItem $sourcePath -Recurse -Include '*.*' | Foreach-Object `
    {
        $destDir = Split-Path ($_.FullName -Replace [regex]::Escape($sourcePath), $destPath)
        if (!(Test-Path $destDir))
        {
            New-Item -ItemType directory $destDir | Out-Null
        }
        Copy-Item $_ -Destination $destDir}



$sourcePath = "\\tfs-build-06\e$\UniTrac\Setups\Version ReleaseCandidate\LDH\UnitracBusinessService"
$destPath =  "\\UTSTAGE-APP4\c$\Program Files\Allied Solutions\UnitracBusinessServiceCycle2"


Get-ChildItem $sourcePath -Recurse -Include '*.*' | Foreach-Object `
    {
        $destDir = Split-Path ($_.FullName -Replace [regex]::Escape($sourcePath), $destPath)
        if (!(Test-Path $destDir))
        {
            New-Item -ItemType directory $destDir | Out-Null
        }
        Copy-Item $_ -Destination $destDir}



$sourcePath = "\\tfs-build-06\e$\UniTrac\Setups\Version ReleaseCandidate\LDH\UnitracBusinessService"
$destPath =  "\\UTSTAGE-ASR1\c$\Program Files\Allied Solutions\UnitracBusinessServiceDist"


Get-ChildItem $sourcePath -Recurse -Include '*.*' | Foreach-Object `
    {
        $destDir = Split-Path ($_.FullName -Replace [regex]::Escape($sourcePath), $destPath)
        if (!(Test-Path $destDir))
        {
            New-Item -ItemType directory $destDir | Out-Null
        }
        Copy-Item $_ -Destination $destDir}



$sourcePath = "\\tfs-build-06\e$\UniTrac\Setups\Version ReleaseCandidate\LDH\UnitracBusinessService"
$destPath =  "\\UTSTAGE-ASR1\c$\Program Files\Allied Solutions\UnitracBusinessServiceProc1"


Get-ChildItem $sourcePath -Recurse -Include '*.*' | Foreach-Object `
    {
        $destDir = Split-Path ($_.FullName -Replace [regex]::Escape($sourcePath), $destPath)
        if (!(Test-Path $destDir))
        {
            New-Item -ItemType directory $destDir | Out-Null
        }
        Copy-Item $_ -Destination $destDir}



$sourcePath = "\\tfs-build-06\e$\UniTrac\Setups\Version ReleaseCandidate\LDH\UnitracBusinessService"
$destPath =  "\\UTSTAGE-ASR2\c$\Program Files\Allied Solutions\UnitracBusinessServiceProc2"


Get-ChildItem $sourcePath -Recurse -Include '*.*' | Foreach-Object `
    {
        $destDir = Split-Path ($_.FullName -Replace [regex]::Escape($sourcePath), $destPath)
        if (!(Test-Path $destDir))
        {
            New-Item -ItemType directory $destDir | Out-Null
        }
        Copy-Item $_ -Destination $destDir}



    $sourcePath = "\\tfs-build-06\e$\UniTrac\Setups\Version ReleaseCandidate\LDH\UnitracBusinessService"
$destPath =  "\\UTSTAGE-ASR3\c$\Program Files\Allied Solutions\UnitracBusinessServiceProc3"


Get-ChildItem $sourcePath -Recurse -Include '*.*' | Foreach-Object `
    {
        $destDir = Split-Path ($_.FullName -Replace [regex]::Escape($sourcePath), $destPath)
        if (!(Test-Path $destDir))
        {
            New-Item -ItemType directory $destDir | Out-Null
        }
        Copy-Item $_ -Destination $destDir}


Get-ChildItem   "\\as.local\shared\InfoTech\UniTrac_Master_Configs\Test\Stage\UnitracBusinessServiceCycle\UnitracBusinessService.exe.config" |Copy-Item -Destination  "\\UTSTAGE-APP1\c$\Program Files\Allied Solutions\UnitracBusinessServiceCycle" -Force
Get-ChildItem   "\\as.local\shared\InfoTech\UniTrac_Master_Configs\Test\Stage\UnitracBusinessServiceBackfeed\UnitracBusinessService.exe.config" |Copy-Item -Destination  "\\UTSTAGE-APP1\c$\Program Files\Allied Solutions\UnitracBusinessServiceMatchBackfeed" -Force
Get-ChildItem   "\\as.local\shared\InfoTech\UniTrac_Master_Configs\Test\Stage\UnitracBusinessServiceMatchOut\UnitracBusinessService.exe.config" |Copy-Item -Destination  "\\UTSTAGE-APP1\c$\Program Files\Allied Solutions\UnitracBusinessServiceMatchOut" -Force
Get-ChildItem   "\\as.local\shared\InfoTech\UniTrac_Master_Configs\Test\Stage\UnitracBusinessServicePRT\UnitracBusinessService.exe.config" |Copy-Item -Destination  "\\UTSTAGE-APP1\c$\Program Files\Allied Solutions\UnitracBusinessServicePRT" -Force
Get-ChildItem   "\\as.local\shared\InfoTech\UniTrac_Master_Configs\Test\Stage\UnitracBusinessServiceBackfeed\UnitracBusinessService.exe.config" |Copy-Item -Destination  "\\UTSTAGE-APP1\c$\Program Files\Allied Solutions\UnitracBusinessServiceBackfeed" -Force
Get-ChildItem   "\\as.local\shared\InfoTech\UniTrac_Master_Configs\Test\STAGE\UnitracBusinessServiceCycle2\UnitracBusinessService.exe.config" |Copy-Item -Destination  "\\UTSTAGE-APP4\c$\Program Files\Allied Solutions\UnitracBusinessServiceCycle2" -Force
Get-ChildItem   "\\as.local\shared\InfoTech\UniTrac_Master_Configs\Test\Stage\UnitracBusinessServiceDist\UnitracBusinessService.exe.config" |Copy-Item -Destination  "\\UTSTAGE-ASR1\c$\Program Files\Allied Solutions\UnitracBusinessServiceDist" -Force
Get-ChildItem   "\\as.local\shared\InfoTech\UniTrac_Master_Configs\Test\Stage\UnitracBusinessServiceProc1\UnitracBusinessService.exe.config" |Copy-Item -Destination  "\\UTSTAGE-ASR1\c$\Program Files\Allied Solutions\UnitracBusinessServiceProc1" -Force
Get-ChildItem   "\\as.local\shared\InfoTech\UniTrac_Master_Configs\Test\Stage\UnitracBusinessServiceProc2\UnitracBusinessService.exe.config" |Copy-Item -Destination  "\\UTSTAGE-ASR2\c$\Program Files\Allied Solutions\UnitracBusinessServiceProc2" -Force
Get-ChildItem   "\\as.local\shared\InfoTech\UniTrac_Master_Configs\Test\Stage\UnitracBusinessServiceProc3\UnitracBusinessService.exe.config" |Copy-Item -Destination  "\\UTSTAGE-ASR3\c$\Program Files\Allied Solutions\UnitracBusinessServiceProc3" -Force



Get-Service	 -ComputerName	UTSTAGE-APP1	  -Name	UnitracBusinessServiceCycle | Start-Service
Get-Service	 -ComputerName	UTSTAGE-APP1	  -Name	UnitracBusinessServicePRT  |Start-Service
Get-Service	 -ComputerName	UTSTAGE-APP1	  -Name	UnitracBusinessServiceMatchOut |Start-Service
Get-Service	 -ComputerName	UTSTAGE-APP1	  -Name	UnitracBusinessServiceRPT |Start-Service
Get-Service	 -ComputerName	UTSTAGE-APP1	  -Name	UnitracBusinessServiceBackfeed | Start-Service
Get-Service	 -ComputerName	UTSTAGE-APP4	  -Name	UnitracBusinessServiceCycle2 |Start-Service
Get-Service	 -ComputerName	UTSTAGE-ASR1	  -Name	UnitracBusinessServiceDist | Start-Service
Get-Service	 -ComputerName	UTSTAGE-ASR1	  -Name	UnitracBusinessServiceProc1 | Start-Service
Get-Service	 -ComputerName	UTSTAGE-ASR2	  -Name	UnitracBusinessServiceProc2 | Start-Service
Get-Service	 -ComputerName	UTSTAGE-ASR3	  -Name	UnitracBusinessServiceProc3 | Start-Service