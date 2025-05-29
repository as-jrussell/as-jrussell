<#
.SYNOPSIS

Clones and existing database.

.DESCRIPTION

Takes a backup of a database and clones it to another host.
Adds the new copies to an existing AG on those instances.

.PARAMETER sourceDB
Specifies the source database.

.PARAMETER sourceInst
Specifies the source host.

.PARAMETER targetDB
Specifies the database name used for the restore as the primary and secondary database.

.PARAMETER targetDrive
Specifies the drive to use for the restore as the primary and secondary database.

.PARAMETER targetPrimary
Specifies the instance to be used for the primary database restore.

.PARAMETER targetSecondary
Specifies the instance to be used for the secondary database restore.

.PARAMETER backupFull
Specifies the location of a FULL backup for the source DB.

.PARAMETER agName
Specifies the name of the Availability Group (AG) to be used by new Primary and Secondary databases.

.PARAMETER skipRestore
Specifies if the user wants to skip performing a database restore.
Currently not available.

.PARAMETER skipAG
Specifies if user wants to skip adding to the AG.
Currently not available.

.PARAMETER overWriteTarget
Specifies if user wants to overwrite the database if it exists on targetPrimary and targetSecondary
Currently not available.

.PARAMETER cleanup
Specifies if the user wants to remove backup files produced during process.

.PARAMETER dryRun
Specifies if the user wants to perform what if.

.INPUTS

None. You cannot pipe objects to Add-Extension.

.OUTPUTS

None.  You cannot pass output from this script to another.

.EXAMPLE

.\cloneDB.ps1 -sourceDB 'LetterGen' -sourceInst 'UT-STG-Listener' -targetDB 'LetterGen_HKB' -targetPrimary 'UTSTAGE-SQL-01' -targetSecondary 'UTSTAGE-SQL-02' -agName 'TestAG' -dryRun 1

.EXAMPLE

.\cloneDB.ps1 -sourceDB 'LetterGen' -sourceInst 'UT-STG-Listener' -targetDB 'LetterGen_HKB' -targetPrimary 'UTSTAGE-SQL-01' -dryRun 0 -verbose
.\cloneDB.ps1 -sourceDB 'LetterGen_HKB' -targetPrimary 'UTSTAGE-SQL-01' -targetSecondary 'UTSTAGE-SQL-02'  -agName 'TestAG' -dryRun 0 -verbose

.EXAMPLE

.\cloneDB.ps1 -sourceDB 'LetterGen' -sourceInst 'UT-STG-Listener' -targetDB 'LetterGen_HKB' -targetPrimary 'UTSTAGE-SQL-01' -targetDrive 'E:\SQL\DATA05' -dryRun 0 -verbose
.\cloneDB.ps1 -sourceDB 'LetterGen_HKB' -targetPrimary 'UTSTAGE-SQL-01' -targetSecondary 'UTSTAGE-SQL-02'  -agName 'TestAG' -targetDrive 'E:\SQL\DATA05' -dryRun 0 -verbose

.EXAMPLE
.\cloneDB.ps1 -sourceDB 'LetterGen' -sourceInst 'UT-STG-Listener' -targetDB 'LetterGen_HKB' -targetPrimary 'UTSTAGE-SQL-01' -agName 'TestAG' -targetdatadrive 'F:\DB_5\' -targetLogDrive 'F:\SQL logs\' -dryRun 0  -verbose
.\cloneDB.ps1 -sourceDB 'LetterGen_HKB' -targetPrimary 'UTSTAGE-SQL-01' -targetSecondary 'UTSTAGE-SQL-02'  -agName 'TestAG' -targetdatadrive 'F:\DB_5\' -targetLogDrive 'F:\SQL logs\' -dryRun 0 -verbose

.LINK

http://tfs-server-04:8080/tfs/defaultcollection/DBA/DBA%20Team/_versionControl/changesets?itemPath=%24%2FDBA%2FPowerShell

#>
[cmdletbinding(SupportsShouldProcess=$True)]

PARAM(

    [string] $sourceDB,  
    [string] $sourceInst,       # host\inst UTSTAGE-SQL-01 or UT-STG-Listner
    [string] $sourceFULL,       # "H:\SQL" "\\IGNITE-SQL14\Restores\letterGenQA.bak"
    [string] $targetDB,
    [string] $targetDataDrive,  # F:\SQLData\
    [string] $targetLogDrive,   # F:\SQLLogs\
    [string] $targetPrimary,    # host\inst
    [string] $targetSecondary,  # host\inst
    [string] $agName,
    [Object[]] $sourceInfo,
    [Object[]] $targetInfo,
    [bool] $skipRestore = $false,
    [bool] $skipAG = $false,
    [bool] $overWriteTarget = $false,
    [bool] $cleanp = $True,
    [bool] $dryRun = $true

)

$project = (Split-Path -Parent $MyInvocation.MyCommand.Path)
# always use '-Force' to load the latest version of the module
Import-Module "$($project)\Modules\Host-Functions.psm1" -Force
Import-Module "$($project)\Modules\Instance-Functions.psm1" -Force
Import-Module "$($project)\Modules\Database-Functions.psm1" -Force

function take-Backup ( [string] $f_sourceDB, [string] $f_sourceHost, [string] $f_backupPath, [string] $f_backupType, [bool] $f_dryRun ){
    $backupSQL = "
        BACKUP DATABASE [$($f_sourceDB)] TO  DISK = N'$($f_backupPath)' 
        WITH NOFORMAT, NOINIT,  NAME = N'$($f_sourceDB)-$($f_backupType) Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10"

    IF($f_backupType -eq 'LOG'){$backupSQL =$backupSQL.replace('BACKUP DATABASE','BACKUP LOG')}
    IF($f_dryRun){
        Write-Host `t"Backup command:
            $($backupSQL)"
    }
    ELSE{
        TRY{    
                 Write-Verbose "
        $($backupSQL)"
                Invoke-Sqlcmd -ServerInstance $f_sourceHost -Database MASTER -Query $backupSQL -QueryTimeout 65535 -ErrorAction 'Stop' 
        }
        CATCH{
                Write-Host `t"[ALERT] FAILED TO QUERY !!!!" -ForegroundColor Red 
                Write-Host `t"$($backupSQL)"
                ### record information or raise alert?
                Write-Host `t"error: $_"
            }
    }
}

function restore-fullBackup ( [Object[]] $f_sourceInfo, [string] $f_backupPath, [Object[]] $f_targetInfo, [string] $f_targetHost,[bool] $f_recovery, [bool] $f_dryRun ){
    #validate the database names are system Databases
    if ($f_targetInfo.Database -in ("Master","Model","TempDB","MSDB")){
        Write-Host "Database validation Failed for [$($f_targetInfo.Database)]. Database can not be restored by the same name as System Databases"
        throw "Database validation Failed for [$($f_targetInfo.Database)]. Database can not be restored by the same name as System Databases"
        return -1
    }

    if (!$f_targetInfo.DataPath -and !$f_targetInto.LogPath){
        $selectSQl = "
            SELECT
            SERVERPROPERTY('InstanceDefaultDataPath') AS InstanceDefaultDataPath,
            SERVERPROPERTY('InstanceDefaultLogPath') AS InstanceDefaultLogPath"
        TRY{   
            Write-Verbose "
            $($selectSQL)"
            $defaultLocations = Invoke-Sqlcmd -ServerInstance $f_targetHost -Database MASTER -Query $selectSQL -QueryTimeout 65535 -ErrorAction 'Stop' 
        }
        CATCH{
            Write-Host `t"[ALERT] FAILED TO QUERY !!!!" -ForegroundColor Red 
            Write-Host `t"$($selectSQL)"
            ### record information or raise alert?
            Write-Host `t"error: $_"
            }
    }
    else{
        Write-Verbose "Target Data Path: $($f_targetInfo.DataPath)"
        Write-Verbose "Target Logs Path: $($f_targetInfo.LogPath)"
        $defaultLocations = new-object -typename psobject -property @{  
                InstanceDefaultDataPath = $f_targetInfo.DataPath
                InstanceDefaultLogPath = $f_targetInfo.LogPath
        }
    }

    $selectSQL = "RESTORE FILELISTONLY FROM DISK =N'$($f_backupPath)'"
    TRY{    
        Write-Verbose "
        $($selectSQL)"
        $restoreFileList = Invoke-Sqlcmd -ServerInstance $f_targetHost -Database MASTER -Query $selectSQL -QueryTimeout 65535 -ErrorAction 'Stop' 
    }
    CATCH{
        Write-Host `t"[ALERT] FAILED TO QUERY !!!!" -ForegroundColor Red 
        Write-Host `t"$($selectSQL)"
        ### record information or raise alert?
        Write-Host `t"error: $_"
        }
    $restoreCommand = "
        USE [MASTER]; RESTORE DATABASE [$($f_targetInfo.Database)]
        FROM DISK = N'$($f_backupPath)'
        WITH"
 
    ForEach($file in $restoreFileList){
        #Write-Host "$($file.logicalname) $($file.physicalName)"
        $currentFile = $file.physicalName.subString($file.physicalName.LastIndexOf('\')+1,$file.physicalName.Length-$file.physicalName.LastIndexOf('\')-1)
        if($file.type -eq 'D'){$currentFile="$($defaultLocations.InstanceDefaultDataPath)$($currentFile)"}ELSE{$currentFile="$($defaultLocations.InstanceDefaultLogPath)$($currentFile)"}
        $restoreCommand = $restoreCommand +"
            MOVE N'$($file.logicalname)' TO N'$($currentFile.replace($f_sourceInfo.Database,$f_targetInfo.Database))',"
    } 
    If($f_recovery){
        $restoreCommand = $restoreCommand +"
        Recovery;"
    }
    ELSE{
        $restoreCommand = $restoreCommand +"
        NoRecovery;"
    }

    IF($f_dryRun){
        Write-Host "[DryRun] Perform FULL restore:
        $($restoreCommand)"
    }
    ELSE{
        TRY{   
            Write-Verbose "
            $($restoreCommand)"
            Invoke-Sqlcmd -ServerInstance $f_targetHost -Database MASTER -Query $restoreCommand -QueryTimeout 65535 -ErrorAction 'Stop' 
        }
        CATCH{
            Write-Host `t"[ALERT] FAILED TO RESTORE FULL BACKUP !!!!" -ForegroundColor Red 
            Write-Host `t"$($restoreCommand)"
            ### record information or raise alert?
            Write-Host `t"error: $_"
            }
    }

}

function restore-logBackup ( [Object[]] $f_targetInfo, [bool] $f_recovery, [bool] $f_dryRun ){
     $restoreCommand = "
        USE [MASTER]; RESTORE LOG [$($f_targetInfo.Database)]
        FROM DISK = N'$($f_targetInfo.LogBackup)'
        WITH"
    If($f_recovery){
        $restoreCommand = $restoreCommand +"
        Recovery;"
    }
    ELSE{
        $restoreCommand = $restoreCommand +"
        NoRecovery;"
    }

    IF($f_dryRun){
        Write-Host "[DryRun] Perform LOG restore:
        $($restoreCommand)"
    }
    ELSE{
        TRY{    
            Write-Verbose "
            $($restoreCommand)"
            Invoke-Sqlcmd -ServerInstance $f_targetInfo.SecondaryInstance -Database MASTER -Query $restoreCommand -QueryTimeout 65535 -ErrorAction 'Stop' 
        }
        CATCH{
            Write-Host `t"[ALERT] FAILED TO RESTORE LOG BACKUP !!!!" -ForegroundColor Red 
            Write-Host `t"$($restoreCommand)"
            ### record information or raise alert?
            Write-Host `t"error: $_"
            }
    }


}

function check-AGstatus ( [string] $f_targetDB, [string] $f_targetHost, [int] $f_replicaType, [bool] $f_dryRun ){
    $selectSQL = "
    SELECT sd.name, 
    COALESCE(grp.ag_name,'N/A') as AGName,
    replica_server_name,
    synchronization_health_desc,
    synchronization_state_desc,
    CASE
        WHEN database_state_desc = 'ONLINE' THEN 'ONLINE'
        WHEN database_state_desc IS NULL THEN 'READONLY'
    END AS database_state_desc,
    CASE 
        WHEN is_primary_replica = 1 THEN 'PRIMARY'
        WHEN is_primary_replica = 0 THEN 'SECONDARY'
    END AS is_primary_replica
    FROM sys.databases as sd
    LEFT OUTER JOIN sys.dm_hadr_database_replica_states hdrs on hdrs.database_id = sd.database_id
    LEFT OUTER JOIN sys.dm_hadr_name_id_map grp on grp.ag_id = hdrs.group_id
    INNER JOIN sys.dm_hadr_availability_replica_cluster_states acs on acs.replica_id = hdrs.replica_id
    WHERE sd.name = '$($f_targetDB)' and is_primary_replica = $($f_replicaType) AND replica_server_name = '$($f_targetHost)'"

    TRY{
        Write-Verbose "
        $($selectSQL)"
        Invoke-Sqlcmd -ServerInstance $f_targetHost -Database MASTER -Query $selectSQL -QueryTimeout 65535 -ErrorAction 'Stop' 
    }
    CATCH{
        Write-Host `t"[ALERT] FAILED TO QUERY !!!!" -ForegroundColor Red 
        Write-Host `t"$($selectSQL)"
        ### record information or raise alert?
        Write-Host `t"error: $_"
        }

}

####################################################################################################################################
$ScriptDirectory = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
[datetime] $startDate = Get-Date
[string] $backupRoot = "\\IGNITE-SQL14\Restores"

Write-Host "start Date: $($startDate)"

if($targetPrimary -ne '' -or $targetSecondary -ne ''){
    IF(!$sourceInst){
        Write-Host "[] No Source Instance...working with Primary and Secondary"
    }
    ELSE{
        if(!$sourceInfo){
            Write-Verbose "[] No Source object...creating"
            $sourceInfo = new-object -typename psobject -property @{  
                Database = $sourceDB
                Instance = $sourceInst
            }
        }

        Write-Host "[] Source Instance: $($sourceInfo.Instance)"
        IF(!$sourceInfo.FullBackup){
            IF( ping-host $($sourceInfo.Instance) $currentDomain ){
                $sourceInfo | Add-Member -membertype NoteProperty -name FullBackup -value "$($backupRoot)\$($env:USERNAME)\$($sourceInfo.Database)_source_$( $startDate.ToString('yyyyMMdd_HHmmss') ).bak"

                Write-Host "[] Take FULL backup: $($sourceInfo.Database)"
                take-backup $sourceInfo.Database $sourceInfo.Instance $sourceInfo.FullBackup 'FULL' $dryRun
            }
            ELSE{ Write-Host `t"[ALERT] FAILED TO PING!!!!!" -ForegroundColor Red }
        }
        else{
            $sourceInfo | Add-Member -membertype NoteProperty -name FullBackup -value $sourceFULL
            Write-Host "[] FULL Backup Supplied: $($sourceInfo.FullBackup)"
        }

        <## touch file test ##>
    }

    if(!$targetInfo){
        If(!$targetDB){ 
            write-Verbose "[] No targetDB ... use source."
            $targetDB = $sourceDB 
        }

        Write-Verbose "[] No target object...creating"
        $targetInfo = new-object -typename psobject -property @{  
            Database = $targetDB
            DataPath = $targetDataDrive
            LogPath = $targetLogDrive
            PrimaryInstance = $targetPrimary
            SecondaryInstance = $targetSecondary
            FullBackup = "$($backupRoot)\$($env:USERNAME)\$($targetDB)_primary_$($startDate.ToString('yyyyMMdd_HHmmss')).bak"
            LogBackup = "$($backupRoot)\$($env:USERNAME)\$($targetDB)_primary_$($startDate.ToString('yyyyMMdd_HHmmss')).trn"
        }
    }

    Write-Host "[] Primary Instance: $($targetInfo.PrimaryInstance)"
    If($sourceInfo.FullBackup){
        IF( ping-host $($targetInfo.PrimaryInstance) $currentDomain ){
            if( !find-Database $($targetInfo.Database) $($targetInfo.PrimaryInstance) $dryRun){
               <# Leaving this out of version 1
                IF(!$targetInfo.SecondaryInstance){
                    Write-Verbose "No Secondary - not pausing log Backups"
                }
                ELSE{
                    Write-Host "Disable Log Backups"
                    $selectJOBS = "select * from msdb..sysjobs where name like '%USER_DATABASES - LOG%' AND enabled = 1"
                } #>

                Write-Host "Restore database as: $($targetInfo.Database)"
                restore-fullBackup $sourceInfo $sourceInfo.FullBackup $targetInfo $targetInfo.PrimaryInstance $true $dryRun

                Write-Host "Check for Orphaned users"
                # check-orphanedUsers $targetInfo $targetInfo.PrimaryInstance $true $dryRun

                Write-Host "Remove source backup files:"
                Write-Host `t"source FULL $($sourceInfo.FullBackup)"
                $delCMD = "del '$($sourceInfo.FullBackup)'"
                if($dryRun){
                    Write-Host "$delCMD"
                }
                else{
                    Invoke-Expression $delCMD
                }           
            }
            else{
                Write-Host `t"[ALERT] Not performing restore DATABASE EXISTS !!!!" -ForegroundColor Red 
            }

        }
        ELSE{ Write-Host `t"[ALERT] FAILED TO PING!!!!!" -ForegroundColor Red }
    }
    else{
        Write-Host "[] No Source Instance...nothing to restore"

        # Write-Host `t"Confirm Primary in AG"
        # check-AGstatus 
    }

    If(!$targetSecondary){
        Write-Verbose "[WARNING] No Secondary requested"
    }
    ELSE{
        Write-Host `t"Take full backup of primary: $($targetInfo.PrimaryInstance)"
        take-backup $targetInfo.Database $targetInfo.PrimaryInstance $targetInfo.FullBackup 'FULL' $dryRun

        Write-Host `t"Take log backup of primary: $($targetInfo.PrimaryInstance)"
        take-backup $targetInfo.Database $targetInfo.PrimaryInstance $targetInfo.LogBackup 'LOG' $dryRun

        Write-Host "[] Secondary Instance: $($targetInfo.SecondaryInstance)"
        IF( ping-host $($targetInfo.SecondaryInstance) $currentDomain ){
            if( !(find-Database $($targetInfo.Database) $($targetInfo.SecondaryInstance) $dryRun) ){
                Write-Host "Restore database as: $($targetInfo.Database) - no recovery"
                restore-fullBackup $targetInfo $targetInfo.FullBackup $targetInfo $targetInfo.SecondaryInstance $false $dryRun

                Write-Host "Restore log backup to secondary - no recovery"
                restore-logBackup $targetInfo $false $dryRun
            }
            else{
                Write-Host `t"[ALERT] Not performing restore DATABASE EXISTS !!!!" -ForegroundColor Red 
            }

            Write-Host "[] Obtain target compatability level"
            $selectSQL = "SELECT compatibility_level FROM sys.databases WHERE name = 'MODEL'"
            TRY{    
                Write-Verbose "
                $($selectSQL)"
                $compLevel = Invoke-Sqlcmd -ServerInstance $targetInfo.PrimaryInstance -Database MASTER -Query $selectSQL -QueryTimeout 65535 -ErrorAction 'Stop' | select -exp compatibility_level
            }
            CATCH{
                Write-Host `t"[ALERT] FAILED TO QUERY !!!!" -ForegroundColor Red 
                Write-Host `t"$($selectSQL)"
                ### record information or raise alert?
                Write-Host `t"error: $_"
                }

            if($skipAG){
                Write-Verbose "[] SkipAG - not adding to Availability Group"
            }
            else{
                Write-Host "[] Perform AG actions"
                #$cmd = "$ScriptDirectory\Add-DBToAG.ps1 -serverNamePrimary $($targetInfo.PrimaryInstance) -serverNameSecondary $($targetInfo.SecondaryInstance) -databaseName $($targetInfo.Database) -agName $($agName) -compatibilityLevel $($compLevel) -dryRun `$$($dryRun)"
                $compatibilityLevel = 130
                add-SecondaryAG  $targetInfo.PrimaryInstance $targetInfo.SecondaryInstance $targetInfo.Database $agName $compatibilityLevel $dryRun
                
                #Write-Verbose "
                #$($cmd)"
                #Invoke-Expression $cmd

                Write-Host "[] Confirm AG is healthy and perform cleanup"
                $agStatus = check-AGstatus $targetInfo.Database $targetInfo.SecondaryInstance 0 $dryRun

                if($agStatus.synchronization_health_desc -eq 'HEALTHY'){
                    Write-verbose "[OK] $($($agName)): $($agStatus.synchronization_health_desc)"

                    Write-Host "[] Remove Primary backup files"
                    If($targetInfo.FullBackup){
                        Write-Host `t`t"primary FULL $($targetInfo.FullBackup)"
                        $delCMD = "del '$($targetInfo.FullBackup)'"
                        if($dryRun){
                            Write-Host "$delCMD"
                        }
                        else{
                            Invoke-Expression $delCMD
                        }
                    }
                    If($targetInfo.LogBackup){
                        Write-Host `t`t"primary LOG $($targetInfo.LogBackup)"
                        $delCMD = "del '$($targetInfo.LogBackup)'"
                        if($dryRun){
                            Write-Host "$delCMD"
                        }
                        else{
                            Invoke-Expression $delCMD
                        }
                    }

                }
                else{                                 
                    Write-Host "[ALERT] $($agName): $($agStatus.synchronization_health_desc)"
                }         
            }

        }
        ELSE{ Write-Host `t"[ALERT] FAILED TO PING!!!!!" -ForegroundColor Red }
    }

}
else{
    Write-Host "[ALERT] No Targets specified"
    get-help ".\cloneDBnewAG.ps1"
}
