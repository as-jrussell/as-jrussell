function ping-host {
    [cmdletbinding(SupportsShouldProcess=$True)] 

    param(
        [string] $TargetHost, 
        [string] $Domain 
    )

    IF($TargetHost.indexOf('\') -gt 0)
        {
            $TargetServer = $TargetHost.substring(0,$TargetHost.IndexOf('\')) +'.'+ $Domain
            if( $TargetServer -eq '.' ){ $TargetServer = '127.0.0.1' }
            IF( $TargetServer -like '*.'){ $TargetServer = $TargetServer.replace('.','')}
        }
    ELSEIF($TargetHost.indexOf(',') -gt 0){
            $TargetServer = $TargetHost.substring(0,$TargetHost.IndexOf(',')) +'.'+ $Domain
        }
    ELSEIF( ($Domain.indexOf('.net') -gt 0) -or ($Domain.indexOf('.NET') -gt 0) )
        {
            Write-Host "[Warning] Skipping .NET targets"
            #needs SQL authentication - just return false?
            $TargetServer = $TargetHost
            return $true
        }
    ELSEIF($Domain.indexOf('.') -gt 0)
        {
            $TargetServer = $TargetHost +'.'+ $Domain
        }
    ELSE
        {
            $TargetServer = $TargetHost
        }
    Write-Host `t"test-Connection -ComputerName $TargetServer -Count 2 -Quiet"
    test-Connection -ComputerName $TargetServer -Count 2 -Quiet  
    #Get-WmiObject -Class Win32_PingStatus -Filter "Address='$TargetServer' AND Timeout=5";
     
}
Export-ModuleMember -Function ping-host

function Get-RemoteMountPoints {
    <#

    #>
    param (
        [Parameter(Mandatory = $true)][string]$server,
        [switch]$csvExport
    )

    function get-mountpoints {
        $TotalGB = @{Name = "Capacity(GB)"; expression = {[math]::round(($_.Capacity / 1073741824), 2)}}
        $FreeGB = @{Name = "FreeSpace(GB)"; expression = {[math]::round(($_.FreeSpace / 1073741824), 2)}}
        $FreePerc = @{Name = "Free(%)"; expression = {[math]::round(((($_.FreeSpace / 1073741824) / ($_.Capacity / 1073741824)) * 100), 0)}}

        $volumes = Get-WmiObject win32_volume -Filter "DriveType='3'"

        if ($using:csvExport) {
            $volumes | Select-Object Name, Label, DriveLetter, FileSystem, $TotalGB, $FreeGB, $FreePerc | Sort-Object -Property DriveLetter | Export-csv -Path C:\$using:server-DriveSpace.csv
        }
        else {
            $volumes | Select-Object Name, Label, DriveLetter, FileSystem, $TotalGB, $FreeGB, $FreePerc | Sort-Object -Property DriveLetter #| Format-Table -AutoSize
        
        }
    }

    Write-Host `t"Invoke-Command -ComputerName $server -ScriptBlock ${function:get-mountpoints}"
    Invoke-Command -ComputerName $server -ScriptBlock ${function:get-mountpoints}

}
Export-ModuleMember -Function Get-RemoteMountPoints

function Get-HostLastReboot{
    param (
        [Parameter(Mandatory = $true)][string]$server
    )
    Write-Host `t"invoke-command -computername $server -scriptblock {gwmi win32_ntlogevent -filter `"LogFile='System' and EventCode='1074' and Message like '%restart%'`" | 
	Select-Object User,@{n=`"Time`";e={$_.ConvertToDateTime($_.TimeGenerated)}} -First 5}"
    
    invoke-command -computername $server -scriptblock {gwmi win32_ntlogevent -filter "LogFile='System' and EventCode='1074' and Message like '%restart%'" | Select-Object User,@{n="Time";e={$_.ConvertToDateTime($_.TimeGenerated)}} -First 5}
}
Export-ModuleMember -Function Get-HostLastReboot

Function Get-PageFileInfo {

<# 
 .Synopsis 
  Returns info about the page file size of a Windows computer. Defaults to local machine. 

 .Description 
  Returns the pagefile size info in MB. Also returns the PageFilePath, PageFileTotalSize, PagefileCurrentUsage,
  and PageFilePeakusage. Also returns if computer is using a TempPafeFile and if the machine's pagefile is
  managed by O/S (AutoManaged = true) or statically set (AutoManaged = False)

  

 .Example 
  Get-PageFileInfo -computername SRV01
  Returns pagefile info for the computer named SRV01

  Computer             : SRV01
  FilePath             : C:\pagefile.sys
  AutoManagedPageFile  : True
  TotalSize (in MB)    : 8192
  CurrentUsage (in MB) : 60
  PeakUsage (in MB)    : 203
  TempPageFileInUse    : False


 .Example 
  Get-PageFileInfo SRV01, SRV02
  Returns pagefile info for two computers named SRV01 & DC02.

  Computer             : SRV01
  FilePath             : C:\pagefile.sys
  AutoManagedPageFile  : True
  TotalSize (in MB)    : 8192
  CurrentUsage (in MB) : 60
  PeakUsage (in MB)    : 203
  TempPageFileInUse    : False

  Computer             : SRV02
  FilePath             : C:\pagefile.sys
  AutoManagedPageFile  : True
  TotalSize (in MB)    : 8192
  CurrentUsage (in MB) : 0
  PeakUsage (in MB)    : 0
  TempPageFileInUse    : False

.Example 
  Get-PageFileInfo SRV01, SRV02, SRV03 | Format-Table
  Returns pagefile info for three computers named SRV01, SRV02 & SRV03 in a table format.


  Computer  FilePath        AutoManagedPageFile TotalSize (in MB) CurrentUsage (in MB) PeakUsage (in MB) TempPageFileInUse
  --------  --------        ------------------- ----------------- -------------------- ----------------- -----------------
  SRV01    C:\pagefile.sys                True              8192                   60               203             False
  SRV02    C:\pagefile.sys                True             13312                    0                 0             False
  SRV03    C:\pagefile.sys                True              2432                    0                 0             False

 
  .Parameter computername 
  The name of the computer to query. Required field.

 .Notes 
  NAME: Get-PageFileInfo 
  AUTHOR: Mike Kanakos 
  Version: v1.1
  LASTEDIT: Thursday, August 30, 2018 2:19:18 PM
  
  .Link 
  
  
#> 

[CmdletBinding()]
Param(
    [Parameter(Mandatory=$True,ValueFromPipeline=$True)]  
    [string[]]$ComputerName
)

# Main Part of function


Foreach ($computer in $ComputerName)
{

  $online= Test-Connection -ComputerName $computer -Count 2 -Quiet
    if ($online -eq $true)
     {
      $PageFileResults = gwmi -Class Win32_PageFileUsage -ComputerName $Computer | Select-Object *
      $CompSysResults = gwmi win32_computersystem -ComputerName $computer -Namespace 'root\cimv2'
    
      $PageFileStats = [PSCustomObject]@{
        Computer = $computer
        FilePath = $PageFileResults.Description
        AutoManagedPageFile = $CompSysResults.AutomaticManagedPagefile
        "TotalSize(in MB)" = $PageFileResults.AllocatedBaseSize
        "CurrentUsage(in MB)"  = $PageFileResults.CurrentUsage
        "PeakUsage(in MB)" = $PageFileResults.PeakUsage
        TempPageFileInUse = $PageFileResults.TempPageFile
      } #END PSCUSTOMOBJECT
     } #END IF
    else
     {
        # Computer is not reachable!
        Write-Host "Error: $computer not online" -Foreground white -BackgroundColor Red
     } # END ELSE


  $PageFileStats
 
} #END FOREACH


} #END FUNCTION
Export-ModuleMember -Function Get-PageFileInfo

Function Get-RemoteDDBoostVersion {
     param (
        [Parameter(Mandatory = $true)][string]$server
    )

    function get-DDBoostVersion{
        $Path = Get-ChildItem -Path Env:Path
        $PathList = $Path.Value -split ';'
        $DDboostPathList = $PathList | Where{  ($_ -like '*MSAPPAGENT*') -OR ($_ -like '*DDBMA*')} # -OR non standard path name

        ForEach($DDBoostPath in $DDBoostPathList){
            $DDboostEXPToolPath = $DDboostPath +'ddbmexptool.exe'

            IF(Test-Path -Path $DDboostEXPToolPath -PathType leaf){
                Try{
                    get-itemproperty $($DDboostEXPToolPath) | select -exp VersionInfo
                }
                Catch{
                    write-host "failed to get version"
                }
            }

        }
    }

    Write-Host `t"invoke-command -computername $server  -ScriptBlock ${function:get-DDBoostVersion}"
    invoke-command -computername $server -scriptblock ${function:get-DDBoostVersion} | select

}
Export-ModuleMember -Function Get-RemoteDDBoostVersion

Function Update-RemoteDDBoostVersion {
     param (
        [Parameter(Mandatory = $true)][string]$server
    )

    <########## Paramters ##########>
    $Computer = $server

    <########## Install Software On PC ##########>
    $SourcePath = "\\as.local\Shared\Infotech\Software\Avamar\msappagent194_win_x64\win_x64\"
    $SourceFile = "emcmsappagent-19.4.0.0.exe"

    $TargetPath = "\\$Computer\E$\DDBoost\194\"
    $LocalPath = "E:\DDBoost\194\"

    $InstallDate = get-date 
    $LogFile = "upgradelog_$($InstallDate -replace(' ','_') -replace(':','') -replace('/','_')).txt"

    Write-Host "[] Creating target Path"
    Write-Host " ]  New-Item -ItemType directory -Path $TargetPath -Force"
    #New-Item -ItemType directory -Path "\\$Computer\E$\DDBoost" -Force
    New-Item -ItemType directory -Path $TargetPath -Force

    Write-Host "[]Copy source files to $Computer"
    $remotecmd = "robocopy $sourcePath $targetPath /MIR /ETA "
    Write-Host " ] $($remoteCmd)"
    invoke-expression $remoteCMD
   
    Write-Host "[] Create EMPTY Log File on $Computer"
    Write-Host " ] New-Item -ItemType file -Path $($TargetPath)$($LogFile)"
    New-Item -ItemType file -Path $TargetPath$LogFile

    Write-Host "Upgrading DDBoost on $Computer"
    $ScriptBlock = "&cmd.exe /c `"$LocalPath$sourceFile`" -s -upgrade EnableSSMSProtectPoint=1 -log $LocalPath$LogFile -NoNewWindow -wait"
    $remoteCMD = "Invoke-Command -ComputerName $($Computer) -ScriptBlock { $($ScriptBlock) } -AsJob "
    Write-Host " ] $($remoteCMD)"
    invoke-expression $remoteCMD

}
Export-ModuleMember -Function Update-RemoteDDBoostVersion

function Get-RemoteProcess{
	param( [string] $Server, [object[]] $ProcessName )

        ## Gathering processes
        Try{
            IF( $ProcessName ){
                #$Processes = Get-Process -ComputerName $Server -ErrorAction Stop | WHERE { ($_.Name -eq $ProcessName) } | Select-Object ProcessName,@{n='Mem (KB)';e={[int]($_.WS/1KB)}},@{n='CPU';e={[int]($_.CPU/1KB)}},ID  | Sort-Object 'Mem (KB)' -Descending | Out-GridView -PassThru -Title "Select processes"
                #Get-Process -ComputerName $Server -ErrorAction Stop | WHERE { ($_.Name -eq $ProcessName) } | Select-Object @{n="HostName"; e={[string]("$($Server)")}}, ProcessName,@{n='Mem(KB)';e={[int]($_.WS/1KB)}},@{n='CPU';e={[int]($_.CPU/1KB)}},ID, StartTime  | Sort-Object 'Mem(KB)' -Descending
                
                <# Changed to GWMI to retrieve start date #>
                gwmi win32_process -computername $Server |
                    ? { $_.name -like "$($ProcessName)*" } | 
                    Select-Object @{n="HostName"; e={[string]("$($Server)")}}, ProcessName, @{n='Mem(KB)';e={[int]($_.WS/1KB)}},ProcessID, @{n='StartDate';e={[DateTime]$_.ConvertToDateTime( $_.CreationDate )}}  | Sort-Object 'StartDate' -Descending

            }ELSE{
                #$Processes = Get-Process -ComputerName $Server -ErrorAction Stop | Select-Object ProcessName,@{n='Mem(KB)';e={[int]($_.WS/1KB)}},@{n='CPU';e={[int]($_.CPU/1KB)}},ID  | Sort-Object 'Mem(KB)' -Descending | Out-GridView -PassThru -Title "Select processes"
                Get-Process -ComputerName $Server -ErrorAction Stop | Select-Object ProcessName,@{n='Mem(KB)';e={[int]($_.WS/1KB)}},@{n='CPU';e={[int]($_.CPU/1KB)}},ID  | Sort-Object 'StartDate' -Descending
            }

            #RETURN $ReturnObject
        }
        Catch{
            $_.Exception.Message
            Continue #Break
        }

}
Export-ModuleMember -Function get-RemoteProcess

function Stop-RemoteProcess{
    [CmdletBinding()]        
   
    # Parameters used in this function
    param
    (
        [Parameter(Position=0, Mandatory = $false, HelpMessage="Provide server name", ValueFromPipeline = $true)] 
        $Server = $env:computername,
        $ProcessName,
        $Force = 0
    ) 
    #    # Gathering processes
    #    Try{
            IF( $ProcessName ){
                #$Processes = Get-Process -ComputerName $Server -ErrorAction Stop | WHERE { ($_.Name -eq $ProcessName) } | Select-Object ProcessName,@{n='Mem (KB)';e={[int]($_.WS/1KB)}},@{n='CPU';e={[int]($_.CPU/1KB)}},ID  | Sort-Object 'Mem (KB)' -Descending 
                <# Changed to GWMI to retrieve start date #>
                $Processes = gwmi win32_process -computername $Server |
                    ? { $_.name -like "$($ProcessName)*" } | 
                    Select-Object @{n="HostName"; e={[string]("$($Server)")}}, ProcessName, @{n='Mem(KB)';e={[int]($_.WS/1KB)}},ProcessID, @{n='StartDate';e={[DateTime]$_.ConvertToDateTime( $_.CreationDate )}}  | Sort-Object 'Mem(KB)' -Descending

            }ELSE{
                $Processes = Get-Process -ComputerName $Server -ErrorAction Stop | Select-Object ProcessName,@{n='Mem (KB)';e={[int]($_.WS/1KB)}},@{n='CPU';e={[int]($_.CPU/1KB)}},ID  | Sort-Object 'Mem (KB)' -Descending | Out-GridView -PassThru -Title "Select processes"
            }
        #}
        #Catch{
        #    $_.Exception.Message 
        #    Continue #Break
        #}
  
    If($Processes){
        Write-Host "The following processes have been selected:" -ForegroundColor Yellow
        $Processes | Out-String | Format-Table -AutoSize
        $Processes | Format-Table -AutoSize
     
        If( $Force -eq 0 ){
            # Confirm if you want to proceed
            Write-Host -NoNewline "Do you want to proceed? (Y/N): "
            $Response = Read-Host
        }
        ELSE{
            Write-Host "[FORCE] Response = 'Y' "
            $Response = "Y"
        }
   
            # If response was different that Y script will end
            If( $Response -ne "Y" ){ 
                Write-Warning "Script ends"    
            }
            Else{
                $ErrorActionPreference = "Stop"
                ForEach($Process in $Processes){
                    Write-Host "`nProcess" $Process.ProcessID "on $Server :" -ForegroundColor Green
                    Try{
                        #TASKKILL /s $Server /f /IM $Process.id
                        TASKKILL /s $Server /f /PID $Process.ProcessID
                        # Stop-Process -Id $Process.id -Force -Verbose # You can use this for killing process on localhost
                    }
                    Catch{
                        Try{
                            Stop-Process -Id $Process.ProcessID -Force -Verbose # You can use this for killing process on localhost
                        }
                        Catch{
                            $_.Exception.Message
                            Continue
                        }
                    }
                }
            }
     }
     Else{
        Write-Warning "Script ends: Processes have not been selected"
     }
}
Export-ModuleMember -Function Stop-RemoteProcess