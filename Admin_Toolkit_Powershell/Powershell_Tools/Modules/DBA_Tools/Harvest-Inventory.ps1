 [cmdletbinding(SupportsShouldProcess=$True)]
<#
.SYNOPSIS

Gathers information of servers known to the CMS.

.DESCRIPTION

Gathers host list from CMS and interrogates machine, instance and databases.

.PARAMETER targetCMS

Specifies the source of truth CMS.

.PARAMETER cmsGroup

Specifies the group to target for information [DEV,TEST,QA....]

.PARAMETER targetInvServer

Specifies the instances where to store the information.

.PARAMETER targetInvDB

Specifies the database where to store the information.

.PARAMETER ProcessInfo

Specifies the category of info to process. [Auto,Host,Instance,Database]

.PARAMETER dryRun

Specifies if the user wants to perform what if.

.INPUTS

None. You cannot pipe objects to Add-Extension.

.OUTPUTS

None.  You cannot pass output from this script to another.

.EXAMPLE

.\Harvest-Inventory.ps1 -dryRun 1 -verbose

.EXAMPLE

.\Harvest-Inventory.ps1 -targetCMS "DBA-SQLPRD-01\I01" -cmsGroup "DEV" -TargetInvServer "DBA-SQLPRD-01\I01" -TargetInvDB "AlliedDatabases" -dryRun 1 -verbose

.EXAMPLE

.\Harvest-Inventory.ps1 -TargetInvServer ".\HKB1" -TargetInvDB "InventoryDWH" -dryRun 0 -verbose

.LINK

http://tfs-server-04:8080/tfs/defaultcollection/DBA/DBA%20Team/_versionControl/changesets?itemPath=%24%2FDBA%2FPowerShell

#>
PARAM(
    [string] $TargetCMS = 'DBA-SQLPRD-01\I01',
    [string] $TargetHost = "",
    [string] $CMSGroup = 'DEV',
    [string] $TargetInvServer = "DBA-SQLPRD-01\I01", #"DBA-SQLPRD-01\I01",
    [string] $TargetInvDB = "InventoryDWH", #"AlliedDatabases",
    [string] $ProcessInfo = "Auto", # Auto = all, all/Host/Instance/Database/
    [boolean] $force = $False,
    [boolean] $DryRun = $True
)

$project = (Split-Path -Parent $MyInvocation.MyCommand.Path)
# always use '-Force' to load the latest version of the module
Import-Module "$($project)\Modules\Host-Functions.psm1" -Force
Import-Module "$($project)\Modules\Instance-Functions.psm1" -Force
Import-Module "$($project)\Modules\Database-Functions.psm1" -Force
#Import-Module "$($project)\Modules\SQLsupport-Functions.psm1" -Force

function Merge-HarvestInfo( [Object[]]$f_HarvestInfo ){
    $execMerge="EXEC info.HarvestHistoryMerge 
            @HarvestID = $(if($f_HarvestInfo.HarvestID -eq $null){ 'null' }ELSE{$f_HarvestInfo.HarvestID}),
            @TargetCMS ='$($f_HarvestInfo.TargetCMS)', 
            @CMSGroup ='$($f_HarvestInfo.CMSGroup)', 
            @TargetInvServer ='$($f_HarvestInfo.TargetInvServer)',
            @TargetInvDB ='$($f_HarvestInfo.TargetDB)', 
            @ProcessInfo = '$($f_HarvestInfo.ProcessInfo)', 
            @DryRun = '$($f_HarvestInfo.DryRun)', 
            --@Comments,
            @StartDateTime = '$($f_HarvestInfo.StartDateTime)', 
            @EndDateTime = $(if($f_HarvestInfo.HarvestID -eq $null){ 'null' }ELSE{$("'"+ $f_HarvestInfo.EndDateTime +"'")}), 
            @StartedBy ='$($env:USERNAME)'; "

    TRY{
        Write-Verbose "
        $($execMerge)"
        Invoke-Sqlcmd -ServerInstance $f_HarvestInfo.TargetInvServer -Database $f_HarvestInfo.TargetDB -Query $execMerge -QueryTimeout 65535 -ErrorAction 'Stop' 
    }
    Catch{
        Write-Host "[ALERT] FAILED TO MERGE HARVEST!!!!!" -ForegroundColor Red 
        $failedOBJ = [ordered]@{
            Host = $($f_HarvestInfo.TargetInvServer)
            Function = "Merge-HarvestInfo"
            Command = "Merge-HarvestInfo `$HarvestInfo $($f_HarvestInfo.DryRun)"
            Message = 'NA'
        }
        record-Failure $f_HarvestInfo $failedOBJ $f_HarvestInfo.DryRun
    }


    $selectSQL = "
    IF EXISTS( SELECT HarvestID AS ID FROM info.HarvestHistory 
                WHERE TargetCMS ='$($f_HarvestInfo.TargetCMS)' AND 
                        CMSGroup ='$($f_HarvestInfo.CMSGroup)' AND 
                        TargetInvServer ='$($f_HarvestInfo.TargetInvServer)' AND
                        TargetInvDB ='$($f_HarvestInfo.TargetDB)' AND 
                        ProcessInfo = '$($f_HarvestInfo.ProcessInfo)' AND
                        DryRun = '$($f_HarvestInfo.DryRun)' AND
                        StartDateTime = '$($f_HarvestInfo.StartDateTime)' AND 
                        StartedBy = '$($env:USERNAME)' )
	    BEGIN
		    SELECT MAX(HarvestID) AS ID FROM info.HarvestHistory 
                WHERE TargetCMS ='$($f_HarvestInfo.TargetCMS)' AND 
                        CMSGroup ='$($f_HarvestInfo.CMSGroup)' AND 
                        TargetInvServer ='$($f_HarvestInfo.TargetInvServer)' AND
                        TargetInvDB ='$($f_HarvestInfo.TargetDB)' AND 
                        ProcessInfo = '$($f_HarvestInfo.ProcessInfo)' AND
                        DryRun = '$($f_HarvestInfo.DryRun)' AND
                        StartDateTime = '$($f_HarvestInfo.StartDateTime)' AND 
                        StartedBy = '$($env:USERNAME)'
	    END
    ELSE
	    BEGIN
            IF( 1 = $(if($f_HarvestInfo.DryRun){1}ELSE{0}) )
                BEGIN
		            SELECT isNull(ident_current('info.HarvestHistory') + ident_incr('info.HarvestHistory'),1) AS ID
                END
	    END;"

    TRY{
        Write-verbose "
        $($selectSQL)"
        Invoke-Sqlcmd -ServerInstance $f_HarvestInfo.TargetInvServer -Database $f_HarvestInfo.TargetDB -Query $selectSQL -QueryTimeout 65535 -ErrorAction 'Stop' | select -exp ID
    }
    CATCH{
        Write-Host `t"[ALERT] FAILED TO GET Harvest ID !!!!" -ForegroundColor Red 
            $failedOBJ = [ordered]@{
                Host = $($f_HarvestInfo.TargetInvServer)
                Function = "Merge-HarvestInfo"
                Command = "Merge-HarvestInfo Get HarvestID $($f_HarvestInfo.DryRun)"
                Message = 'NA'
            }
            record-Failure $f_HarvestInfo $failedOBJ $f_HarvestInfo.DryRun
    }

}

function record-Failure( [Object[]]$f_HarvestInfo, [Object[]]$f_failedOBJ ){
    $insertSQL = "
    Insert into info.HarvestFailures ([HarvestID], [SQLServerName], [Function], [command], [ErrorMessage], [Daterun])
        VALUES
    ($(if($f_HarvestInfo.HarvestID -eq $null){ 'null' }ELSE{$f_HarvestInfo.HarvestID}),'$($f_failedOBJ.Host)','$($f_failedOBJ.Function)','$($f_failedOBJ.Command -replace("'","''"))','$($f_failedOBJ.Message -replace("'","''"))','$(Get-Date)'); "
    
    Try{
        Write-Verbose $insertSQL
        Invoke-Sqlcmd -ServerInstance $($f_HarvestInfo.TargetInvServer) -Database $($f_HarvestInfo.TargetDB) -Query $insertSQL -QueryTimeout 65535 -ErrorAction 'Stop' 
    }
    CATCH{
        Write-Host `t"[ALERT] FAILED TO RECORD FAILURE !!!!" -ForegroundColor Red 
        WRITE-Host `t`t" $($insertSQL)"
    }
}

function get-HostInfo( [Object[]]$f_instanceInfo, [Object[]]$f_HarvestInfo ){

    Try{
        # https://docs.microsoft.com/en-us/windows/win32/cimwin32prov/win32-computersystem
        $compInfo = gwmi -computername $f_instanceInfo.MachineName win32_computersystem
        # https://docs.microsoft.com/en-us/windows/win32/cimwin32prov/win32-operatingsystem
        $osInfo = gwmi -computername $f_instanceInfo.MachineName win32_operatingsystem
        $networkInfo = gwmi  -computername $f_instanceInfo.MachineName Win32_NetworkAdapterConfiguration  | ? {$_.IPEnabled}
        $timeInfo = gwmi -computername $f_instanceInfo.MachineName –Class Win32_TimeZone
        # https://devblogs.microsoft.com/scripting/use-powershell-and-wmi-to-get-processor-information/
        $cpuInfo =  gwmi -computername $f_instanceInfo.MachineName win32_processor
        $count= 0; ForEach( $cpu in $cpuInfo){ $count= $Count + $cpu.numberofcores }; #$count #Cores

        #import-module C:\Users\hbrotherton\source\Workspaces\dba\Powershell\dba_tools\dba_tools\Modules\Host-Functions.psm1
        $pageFileInfo = get-pagefileinfo -computername $f_instanceInfo.MachineName

        if( $f_instanceInfo.ServerEnvironment -eq 'PROD' -or $f_instanceInfo.ServerEnvironment -eq 'ADMIN'){
            $myENV = 1
        }
        else{
            $myENV = 0
        }

        $HarvestMachine = [ordered]@{
            MachineName = $compInfo.Name
            DomainName = $compInfo.Domain
            Timezone =  $timeInfo.Caption
            BuildDate = $(([WMI]'').converttodatetime($osInfo.installdate)) #buildDate
            Hardware = $($compInfo.manufacturer +' '+  $compInfo.Model) #hardware
            Processor = $(IF( $cpuInfo.count -gt 1 ){ $cpuInfo.Name[0] }ELSE{ $cpuInfo.Name }) #Processor
            Sockets = $cpuInfo.DeviceID.Count  #sockets
            Cores = $count  #Cores
            RAM_GB = [Math]::Round( $compinfo.totalphysicalmemory/1GB ) #total in GB
            Cdrive_GB = 0 # Cdrive
            Ddrive_GB = 0 # Ddrive
            NIC = $($networkInfo.index.count) # nic
            PageFilePath = $pagefileInfo.FilePath
            PageFileAutoManaged =  $(if( $pageFileInfo.filepath.Count -ne 1 ){ if( $pageFileInfo.filepath.Count -gt 1 ){ 'ALERT - Multiple PageFiles' }ELSE{'ALERT - Cannot access Host'} }ELSE{ $pagefileInfo.AutoManagedPageFile })
            PageFileTotalSizeMB = $(if( $pageFileInfo.filepath.Count -ne 1 ){ 0 }ELSE{ $pageFileInfo.'TotalSize(in MB)' })
            PageFileCurrentUsageMB = $(if( $pageFileInfo.filepath.Count -ne 1 ){ 0 }ELSE{ $pagefileInfo.'CurrentUsage(in MB)' })
            PageFilePeakUsageMB = $(if( $pageFileInfo.filepath.Count -ne 1 ){ 0 }ELSE{ $PageFileInfo.'PeakUsage(in MB)' })
            PageFileTempInUse = $(if( $pageFileInfo.filepath.Count -ne 1 ){ if( $pageFileInfo.filepath.Count -gt 1 ){ 'ALERT - Multiple PageFiles' }ELSE{'ALERT - Cannot access Host'} }ELSE{ $PagefileInfo.TempPageFileInUse })
            ClusterID = 0 #ClusterID
            IsProduction = $myENV #Is Production
            IsOn = 1 #IsOn
        }

        RETURN $HarvestMachine

    }
    CATCH{
        $dacPort = 0
        Write-Host `t"[ALERT] FAILED TO QUERY DAC !!!!" -ForegroundColor Red 
        #Write-Host `t"$($execSQL)"
        Write-Verbose ".\Harvest-Inventory.ps1 -TargetHost $($f_instanceInfo.ConnectionString) -TargetINVServer $() -TargetDB $() -ProcessInfo 'Machine' -DryRun 0 -verbose"
        ### record information or raise alert?
        Write-Host `t"error: $_"

        $failedOBJ = [ordered]@{
           Host = $($f_instanceInfo.DisplayName)
           Function = "get-HostInfo"
           Command = "PowerShell - Need to break this down into smaller pieces."
           Message = $($_)
        }
        record-Failure $f_HarvestInfo $failedOBJ $f_HarvestInfo.DryRun

    }

}

function merge-HostInfo( [Object[]]$f_HostInfo, [Object[]]$f_HarvestInfo ){

     $execMerge="
        EXEC [inv].[MachineMerge]
            @MachineName = '$($f_HostInfo.MachineName)',
            @DomainName  = '$($f_HostInfo.DomainName)',
            @TimeZone = '$($f_HostInfo.TimeZone)',
            @BuildDate = '$($f_HostInfo.BuildDate)',
            @Hardware = '$($f_HostInfo.Hardware)',
            @Processor = '$($f_HostInfo.Processor)',
            @Sockets = $($f_HostInfo.Sockets),
            @Cores = $($f_HostInfo.Cores),
            @RAM_GB  = $($f_HostInfo.RAM_GB),
            @cDrive_GB = $($f_HostInfo.cDrive_GB),
            @dDrive_GB  = $($f_HostInfo.dDrive_GB),
            @NIC  = $($f_HostInfo.NIC),
            @PageFilePath = '$($f_HostInfo.PageFilePath)',
            @PageFileAutoManaged = '$($f_HostInfo.PageFileAutoManaged)',
            @PageFileTotalSizeMB = $($f_HostInfo.PageFileTotalSizeMB),
            @PageFileCurrentUsageMB = $($f_HostInfo.PageFileCurrentUsageMB),
            @PagefilePeakUsageMB  = $($f_HostInfo.PagefilePeakUsageMB),
            @PageFileTempInUse = '$($f_HostInfo.PageFileTempInUse)',
            @clusterID  = $($f_HostInfo.clusterID),
            @isProduction  = $($f_HostInfo.isProduction),
            @isON = $($f_HostInfo.isON),
            --@RemovalDate [datetime] ,
            @HarvestDate  = '$(get-Date)',
            --@Comments nvarchar(128),
            --@CREATE_DT [datetime],
            --@UPDATE_DT [datetime],
            @UPDATE_USER ='$($env:USERNAME)';"

    If( $f_HarvestInfo.DryRun ) {
        Write-Host "[DryRun] - Not Performing MERGE
        $($execMerge)"
    }
    ELSE{
        TRY{
            Write-verbose "
            $($execMerge)"
            Invoke-Sqlcmd -ServerInstance $f_HarvestInfo.TargetInvServer -Database $f_HarvestInfo.TargetDB -Query $execMerge -QueryTimeout 65535 -ErrorAction 'Stop' 
        }
        CATCH{
            Write-Host `t"[ALERT] FAILED TO MERGE $($f_HostInfo.MachineName)" -ForegroundColor Red 
            Write-Host `t"$($execMerge)"
            ### record information or raise alert?
            Write-Host `t"error: $_" -ForegroundColor Red 

            $failedOBJ = [ordered]@{
                Host = $($f_HostInfo.MachineName)
                Function = "merge-HostInfo"
                Command = "$($execMerge)"
                Message = $($_)
            }
            record-Failure $f_HarvestInfo $failedOBJ $f_HarvestInfo.DryRun
        }
    }
}

function merge-DDBoostInfo( [Object[]]$f_HostInfo, [Object[]]$f_BoostInfo, [Object[]]$f_HarvestInfo ){
    $execMerge="EXEC inv.BackupSoftwareMerge 
        @MachineName = '$($f_HostInfo.MachineName)', 
        @SoftwareName = '$($f_BoostInfo.ProductName)',
        @FileName = '$($f_BoostInfo.OriginalFileName)',
        @FileVErsion = '$($f_BoostInfo.FileVersion)',
        @FileLocation = '$($f_BoostInfo.FileName)',
        --@HarvestDate = '$($f_BoostInfo.HarvestDate)',
        @Comments = '$($f_BoostInfo.FileDescription)',
        --@CREATE_DT,
        --@UPDATE_DT,
        @UPDATE_USER ='$($env:USERNAME)';"
 
    If( $f_HarvestInfo.DryRun ){
        Write-Host "[DryRun] - Not Performing MERGE
        $($execMerge)"
    }
    ELSE{
        TRY{
            Write-verbose "
            $($execMerge)"
            Invoke-Sqlcmd -ServerInstance $f_HarvestInfo.TargetInvServer -Database $f_HarvestInfo.TargetDB -Query $execMerge -QueryTimeout 65535 -ErrorAction 'Stop' 
        }
        CATCH{
            Write-Host `t"[ALERT] FAILED TO MERGE DDBOOST INFO" -ForegroundColor Red 
            Write-Host `t"$($execMerge)"
            ### record information or raise alert?
            Write-Host `t"error: $_" -ForegroundColor Red 

            $failedOBJ = [ordered]@{
                Host = $($email.ProfileName)
                Function = "$($f_HostInfo.MachineName)"
                Command = "$($execMerge)"
                Message = $($_)
            }
            record-Failure $f_HarvestInfo $failedOBJ $f_HarvestInfo.DryRun
        }
    }
}

function get-InstInfo( [Object[]]$f_currentInst, [Object[]]$f_HarvestInfo ){

    $selectSQL = "SELECT '$($f_currentInst.ConnectionString)' as CMSConnectionString, *, getdate() as HarvestDate FROM DBA.info.Instance"
    TRY{
        write-verbose "
        $($selectSQL)"
        Invoke-Sqlcmd -ServerInstance $f_currentInst.ConnectionString -Database MASTER -Query $selectSQL -QueryTimeout 65535 -ErrorAction 'Stop' 
    }
    CATCH{
        Write-Host `t"[ALERT] FAILED TO QUERY INSTANCE $($f_currentInst.ConnectionString) " -ForegroundColor Red 
        ### record information or raise alert?
        Write-Host `t"error: $_" -ForegroundColor Red 

        $failedOBJ = [ordered]@{
            Host = $($f_currentInst.DisplayName)
            Function = "get-InstInfo"
            Command = "$($selectSQL)"
            Message = $($_)
        }
        record-Failure $f_HarvestInfo $failedOBJ $f_HarvestInfo.DryRun
    }

}

function merge-InstInfo( [Object[]]$f_instanceInfo, [Object[]]$f_currentInfo, [Object[]]$f_HarvestInfo ){
    $execMerge="EXEC inv.InstanceMerge @SQLServerName ='$($f_instanceInfo.SQLServerName)', 
                @MachineName ='$($f_instanceInfo.MachineName)', 
                @InstanceName ='$($f_instanceInfo.InstanceName)',
                @DomainName ='$($f_instanceInfo.DomainName)', 
                @local_net_address = '$($f_instanceInfo.local_net_address)', 
                @Port = $($f_instanceInfo.Port), 
                @DACPort = $($f_instanceInfo.DACPort), 
                @ProductName = '$($f_instanceInfo.ProductName)', 
                @ProductVersion = '$($f_instanceInfo.ProductVersion)', 
                @ProductLevel = '$($f_instanceInfo.ProductLevel)', 
                @ProductUpdateLevel = '$($f_instanceInfo.ProductUpdateLevel)',
                @Edition = '$($f_instanceInfo.Edition)', 
                @EngineEdition = '$($f_instanceInfo.EngineEdition)', 
                @min_size_server_memory_mb = '$($f_instanceInfo.min_size_server_memory_mb)', 
                @max_size_server_memory_mb = '$($f_instanceInfo.max_size_server_memory_mb)', 
                @CTFP = $($f_instanceInfo.CTFP), 
                @MDOP = $($f_instanceInfo.MDOP),
                @IsAdHocEnabled = $($($f_instanceInfo.IsAdHocEnabled)),
                @IsDBMailEnabled = $($($f_instanceInfo.IsDBMailEnabled)),
                @IsAgentXPsEnabled = $($($f_instanceInfo.IsAgentXPsEnabled)),
                @IsHadrEnabled = $($f_instanceInfo.IsHadrEnabled),
                @HadrManagerStatus = '$($f_instanceInfo.HadrManagerStatus)',
                @InSingleUser = $($f_instanceInfo.InSingleUser),
                @IsClustered = $($f_instanceInfo.IsClustered),
                @ServerEnvironment = '$($f_currentInfo.ENV)',
                @ServerStatus = '$(if($f_currentInfo.Description -like 'DCOM*'){'DECOMMED'}ELSE{'UP'})',
                @HarvestDate = '$($f_instanceInfo.HarvestDate)',
                --@Comments = '$($f_currentInfo.Description)',
                --@CREATE_DT,
                --@UPDATE_DT,
                @UPDATE_USER ='$($env:USERNAME)';"

    If( $f_HarvestInfo.DryRun ) {
        Write-Host "[DryRun] - Not Performing MERGE
        $($execMerge)"
    }
    ELSE{
        TRY{
            Write-verbose "
            $($execMerge)"
            Invoke-Sqlcmd -ServerInstance $f_HarvestInfo.TargetInvServer -Database $f_HarvestInfo.TargetDB -Query $execMerge -QueryTimeout 65535 -ErrorAction 'Stop' 
        }
        CATCH{
            Write-Host `t"[ALERT] FAILED TO MERGE $($f_currentInfo.SQLServerName)" -ForegroundColor Red 
            Write-Host `t"$($execMerge)"
            ### record information or raise alert?
            Write-Host `t"error: $_" -ForegroundColor Red 

            $failedOBJ = [ordered]@{
                Host = $($f_currentInfo.SQLServerName)
                Function = "merge-InstInfo"
                Command = "$($selectSQL)"
                Message = $($_)
            }
            record-Failure $f_HarvestInfo $failedOBJ $f_HarvestInfo.DryRun
        }
    }

    ### Does not pass Harvest Info as object becuase it is in a shared module...
    get-InstanceID $f_HarvestInfo.TargetInvServer $f_HarvestInfo.TargetDB $($f_instanceInfo.SQLServerName) $f_HarvestInfo.DryRun
}

function merge-AppInst( [String] $f_ApplicationName, [Object[]]$f_instanceInfo, [Object[]]$f_HarvestInfo ){
    $execMerge="EXEC inv.AppInstMerge 
                @ApplicationName = '$($f_ApplicationName)',
                @InstanceID = $($f_instanceInfo.InstanceID),
                --@Comments = '$($f_instanceInfo.Comments)',
                --@CREATE_DT,
                --@UPDATE_DT,
                @UPDATE_USER ='$($env:USERNAME)';"

    If( $f_HarvestInfo.DryRun ) {
        Write-Host "[DryRun] - Not Performing MERGE
        $($execMerge)"
    }
    ELSE{
        TRY{
            Write-verbose "
            $($execMerge)"
            Invoke-Sqlcmd -ServerInstance $f_HarvestInfo.TargetInvServer -Database $f_HarvestInfo.TargetDB -Query $execMerge -QueryTimeout 65535 -ErrorAction 'Stop' 
        }
        CATCH{
            Write-Host `t"[ALERT] FAILED TO MERGE $($f_instanceInfo.ApplicationName)" -ForegroundColor Red 
            Write-Host `t"$($execMerge)"
            ### record information or raise alert?
            Write-Host `t"error: $_" -ForegroundColor Red 

            $failedOBJ = [ordered]@{
                Host = $($f_instanceInfo.DisplayName)
                Function = "merge-AppInst"
                Command = "$($execMerge)"
                Message = $($_)
            }
            record-Failure $f_HarvestInfo $failedOBJ $f_HarvestInfo.DryRun
        }
    }

    ### Does not passs Harvest Info as object becuase it is in a share module...
    #get-ApplicationID $f_HarvestInfo.TargetInvServer $f_HarvestInfo.TargetDB $($f_currentInfo.SQLServerName) $f_HarvestInfo.DryRun
}

function get-linkInfo( [Object[]]$f_instanceInfo, [Object[]]$f_HarvestInfo ){
    $selectSQL = "
    SELECT
      $($f_instanceInfo.InstanceID) as [InstanceID]
      ,[Name]
      ,[Product]
      ,[Provider]
      ,[Data_source]
      ,[Provider_string]
      ,[Catalog]
      ,[Uses_self_credential]
      ,[Remote_name]
      ,[Modify_date]
      ,[Status]
      ,[Comments]
      ,[HarvestDate]
    FROM [DBA].[info].[LinkedServer]"

    TRY{
        write-verbose "
        $($selectSQL)"
        Invoke-Sqlcmd -ServerInstance $($f_instanceInfo.CMSConnectionString) -Database MASTER -Query $selectSQL -QueryTimeout 65535 -ErrorAction 'Stop' 
    }
    CATCH{
        Write-Host `t"[ALERT] FAILED TO QUERY $($f_instanceInfo.CMSConnectionString)" -ForegroundColor Red 
        Write-Host `t"$($selectSQL)"
        ### record information or raise alert?
        Write-Host `t"error: $_" -ForegroundColor Red 

        $failedOBJ = [ordered]@{
           Host = $($f_instanceInfo.DisplayName)
           Function = "get-linkInfo"
           Command = "$($selectSQL)"
           Message = $($_)
        }
        record-Failure $f_HarvestInfo $failedOBJ $f_HarvestInfo.DryRun
    }
}

function merge-linkInfo( [Object[]]$f_linkInfo, [Object[]]$f_currentInst, [Object[]]$f_HarvestInfo ){
    $linkcounter = 1
    <# WE are not displaying info older than 2 days in reporting views.
    IF ( $($f_linkInfo.Count) -eq 0 ){
       
        TRY{
            #Write-Verbose "No linked servers found - removing any from inventory.."
            # Should be stored procedure in InventoryDWH #
            #$deleteSQL = "DELETE FROM inv.LinkedServer WHERE InstanceID = $($f_currentInst.InstanceID)"
            Write-verbose "
            $($deleteSQL)"
            Invoke-Sqlcmd -ServerInstance $f_HarvestInfo.TargetInvServer -Database $f_HarvestInfo.TargetDB -Query $deleteSQL -QueryTimeout 65535 -ErrorAction 'Stop' 
        }
        CATCH{
            Write-Host `t"[ALERT] FAILED TO DELETE WHERE InstanceID = $($f_currentInst.InstanceID)" -ForegroundColor Red 
            Write-Host `t"$($deleteSQL)"
            ### record information or raise alert?
            Write-Host `t"error: $_" -ForegroundColor Red 

            $failedOBJ = [ordered]@{
                Host = $($f_currentInst.DisplayName)
                Function = "Merge-LinkInfo (DELETE)"
                Command = "$($deleteSQL)"
                Message = $($_)
            }
            record-Failure $f_HarvestInfo $failedOBJ $f_HarvestInfo.DryRun
        }
    }#>

    ForEach($link in $f_linkInfo){
        $execMerge="
        EXEC inv.LinkServerMerge 
            @InstanceID ='$($f_currentInst.InstanceID)', 
            @name ='$($link.name)', 
            @product ='$($link.product)',
            @provider ='$($link.provider)', 
            @data_source = '$($link.data_source)', 
            @provider_string = '$($link.provider_string)', 
            @catalog = '$($link.catalog)', 
            @uses_self_credential = '$($link.uses_self_credential)', 
            @remote_name = '$($link.remote_name)', 
            @Modify_date = '$($link.Modify_date)', 
            @Status = '$($link.Status)',
             @HarvestDate = '$($link.HarvestDate)',
            --@Comments,
            --@CREATE_DT,
            --@UPDATE_DT,
            @UPDATE_USER ='$($env:USERNAME)'; "
 
        If( $f_HarvestInfo.DryRun ) {
            Write-Host "[DryRun] - Not Performing MERGE
            $($execMerge)"
        }
        ELSE{
            TRY{
                Write-Verbose `t"[ $($linkcounter) of $($f_linkInfo.Count) ] $($link.name)"
                Write-verbose "
                $($execMerge)"
                Invoke-Sqlcmd -ServerInstance $f_HarvestInfo.TargetInvServer -Database $f_HarvestInfo.TargetDB -Query $execMerge -QueryTimeout 65535 -ErrorAction 'Stop' 
            }
            CATCH{
                Write-Host `t"[ALERT] FAILED TO MERGE $($link.name)" -ForegroundColor Red 
                Write-Host `t"$($execMerge)"
                ### record information or raise alert?
                Write-Host `t"error: $_" -ForegroundColor Red 

                $failedOBJ = [ordered]@{
                   Host = $($f_currentInst.DisplayName)
                   Function = "Merge-LinkInfo"
                   Command = "$($link.name)"
                   Message = $($_)
                }
                record-Failure $f_HarvestInfo $failedOBJ $f_HarvestInfo.DryRun
            }
        }
        $linkcounter++
    } # ForEach($link in $f_linkInfo)
    
}

function get-traceInfo( [Object[]]$f_instanceInfo, [Object[]]$f_HarvestInfo ){
    <# Need to build temp table and insert InstanceID #>
    $selectSQL = "
    begin Try
	    dbcc tracestatus
    end try
    begin catch
	    print 'Skipping'
	    --select 0 as TraceFlag, 0 as Status, 0 as Global, 0 as Session
    end catch"

    TRY{
        write-verbose "
        $($selectSQL)"
        Invoke-Sqlcmd -ServerInstance $($f_instanceInfo.CMSConnectionString) -Database MASTER -Query $selectSQL -QueryTimeout 65535 -ErrorAction 'Stop' 
        #$results | Add-Member -membertype NoteProperty -name InstanceID -value "$(f_currentInst.InstanceID)"
        #$results
    }
    CATCH{
        Write-Host `t"[ALERT] FAILED TO QUERY $($f_instanceInfo.CMSConnectionString)" -ForegroundColor Red 
        Write-Host `t"$($selectSQL)"
        ### record information or raise alert?
        Write-Host `t"error: $_" -ForegroundColor Red 

        $failedOBJ = [ordered]@{
           Host = $($f_instanceInfo.DisplayName)
           Function = "get-traceInfo"
           Command = "$($selectSQL)"
           Message = $($_) 
        }
        record-Failure $f_HarvestInfo $failedOBJ $f_HarvestInfo.DryRun
    }
}

function merge-traceInfo( [Object[]]$f_currentInst, [Object[]]$f_traceInfo, [Object[]]$f_HarvestInfo ){
    $traceCounter = 1
    ForEach($trace in $f_traceInfo){
        $execMerge="
        EXEC inv.TraceFlagsMerge 
            @InstanceID =$($f_currentInst.InstanceID), 
            @TraceFlag =$($trace.TraceFlag), 
            @Status =$($trace.Status),
            @Global =$($trace.Global ), 
            @Session = $($trace.Session), 
            --@Comments,
            --@CREATE_DT,
            --@UPDATE_DT,
            @UPDATE_USER ='$($env:USERNAME)'; "

        If( $f_HarvestInfo.DryRun ) {
            Write-Host "[DryRun] - Not Performing MERGE
            $($execMerge)"
        }
        ELSE{
            TRY{
                Write-Verbose `t"[ $($traceCounter) of $($f_traceInfo.Count) ] $($trace.TraceFlag)"
                Write-verbose "
                $($execMerge)"
                Invoke-Sqlcmd -ServerInstance $f_HarvestInfo.TargetInvServer -Database $f_HarvestInfo.TargetDB -Query $execMerge -QueryTimeout 65535 -ErrorAction 'Stop' 
            }
            CATCH{
                Write-Host `t"[ALERT] FAILED TO MERGE $($trace.TraceFlag)" -ForegroundColor Red 
                Write-Host `t"$($execMerge)"
                ### record information or raise alert?
                Write-Host `t"error: $_"  -ForegroundColor Red 

                $failedOBJ = [ordered]@{
                   Host = $($f_currentInst.DisplayName)
                   Function = "Merge-TraceInfo"
                   Command = "$($execMerge)"
                   Message = $($_)
                }
                record-Failure $f_HarvestInfo $failedOBJ $f_HarvestInfo.DryRun
            }
        }
        $linkcounter++
    } # ForEach($link in $f_linkInfo)
    
}

function get-dbInfo( [Object[]]$f_instanceInfo, [Object[]]$f_HarvestInfo ){
    $selectSQL = "
    SELECT
        $($f_instanceInfo.InstanceID) as [InstanceID]
        ,[DBID]
        ,[DatabaseName]
        ,[Owner]
        ,[State]
        ,[CompatibilityLevel]
        ,[RecoveryModel]
        ,[CanAcceptConnections]
        ,[DataConsumedSizeMB]
        ,[DataFreeSpaceMB]
        ,[LogConsumedSizeMB]
        ,[LogFreeSpaceMB]
        ,[ServerType]
        ,[ReplicationStatus]
        ,[IsEncrypted]
        ,[EncryptionType]
        ,[CreateDate]
        ,[LastFullBackup]
        ,[LastTranBackup] 
        ,[LastCheckDB]
		,[HarvestDate]
    FROM [DBA].[info].[Database]"

    TRY{
        write-verbose "
        $($selectSQL)"
        Invoke-Sqlcmd -ServerInstance $($f_instanceInfo.CMSConnectionString) -Database MASTER -Query $selectSQL -QueryTimeout 65535 -ErrorAction 'Stop' 
    }
    CATCH{
        Write-Host `t"[ALERT] FAILED DB QUERY $($f_instanceInfo.CMSConnectionString)" -ForegroundColor Red 
        Write-Host `t"$($selectSQL)"
        ### record information or raise alert?
        Write-Host `t"error: $_"  -ForegroundColor Red 

        $failedOBJ = [ordered]@{
            Host = $($f_instanceInfo.DisplayName)
            Function = "Get-DBInfo"
            Command = "NA"  #"$($selectSQL)"
            Message = $($_)
        }
        record-Failure $f_HarvestInfo $failedOBJ $f_HarvestInfo.DryRun
    }
}

function merge-dbInfo( [Object[]]$f_dbInfo, [Object[]]$f_HarvestInfo ){
    foreach($database in $f_dbInfo){
        $execMerge="
        EXEC inv.DatabaseMerge
            @InstanceID =$($database.InstanceID),
            @DBID =$($database.DBID),
            @DatabaseName ='$($database.DatabaseName)',
            @owner ='$($database.Owner)',
            @State ='$($database.State)',
            @CompatibilityLevel =$($database.CompatibilityLevel),
            @RecoveryModel ='$($database.RecoveryModel)',
            @CanAcceptConnections =$($database.CanAcceptConnections),
            @DataConsumedSizeMB =$($database.DataConsumedSizeMB),
            @DataFreeSpaceMB =$($database.DataFreeSpaceMB),
            @LogConsumedSizeMB =$($database.LogConsumedSizeMB),
            @LogFreeSpaceMB =$($database.LogFreeSpaceMB),
            @ServerType ='$($database.ServerType)',
            @ReplicationStatus ='$($database.ReplicationStatus)',
            @IsEncrypted =$($database.IsEncrypted),
            @EncryptionType ='$($database.EncryptionType)',
            @CreateDate ='$($database.CreateDate)',
            @LastFullBackup ='$($database.LastFullBackup)',
            @LastTranBackup ='$($database.LastTranBackup)',
            @LastCheckDB ='$($database.LastCheckDB)',
            --@AGID = '',
            @HarvestDate ='$($database.HarvestDate)',
            @UPDATE_USER ='$($env:USERNAME)';
        "

        If( $f_HarvestInfo.DryRun ){
            Write-Host "[DryRun] - Not Performing MERGE
            $($execMerge)"
        }
        ELSE{
            TRY{
                Write-verbose "
                $($execMerge)"
                Invoke-Sqlcmd -ServerInstance $f_HarvestInfo.TargetInvServer -Database $f_HarvestInfo.TargetDB -Query $execMerge -QueryTimeout 65535 -ErrorAction 'Stop' 
            }
            CATCH{
                Write-Host `t"[ALERT] FAILED TO MERGE $($database.DatabaseName)!!!!" -ForegroundColor Red 
                Write-Host `t"$($execMerge)"
                ### record information or raise alert?
                Write-Host `t"error: $_" -ForegroundColor Red 

                $failedOBJ = [ordered]@{
                    Host = $($f_dbInfo.DatabaseName)
                    Function = "Merge-DBInfo"
                    Command = "$($execMerge)"
                    Message = $($_)
                }
                record-Failure $f_HarvestInfo $failedOBJ $f_HarvestInfo.DryRun
            }
        }
    }
}

<#
function harvest-dbInfo( [Object[]]$f_currentInst, [Object[]]$f_HarvestInfo ){
    $execSQL = "EXEC DBA.inv.getDatabase" # @dryRun=$(if($f_HarvestInfo.DryRun){1}ELSE{0})"
    TRY{
        write-verbose "
        $($execSQL)"
        $dbInfo = Invoke-Sqlcmd -ServerInstance $($f_currentInst.MachineName+'.'+$f_currentInst.DomainName) -Database MASTER -Query $execSQL -QueryTimeout 65535 -ErrorAction 'Stop' 
    }
    CATCH{
        Write-Host `t"[ALERT] FAILED DB QUERY $($f_currentInst.DisplayName)" -ForegroundColor Red 
        Write-Host `t"$($selectSQL)"
        ### record information or raise alert?
        Write-Host `t"error: $_"

        $failedOBJ = [ordered]@{
            Host = $($f_currentInst.MachineName+'.'+$f_currentInst.DomainName)
            Function = "Get-DBInfo"
            Command = "NA"  #"$($selectSQL)"
            Message = $($_)
        }
        record-Failure $f_HarvestInfo $failedOBJ $f_HarvestInfo.DryRun
    }

    foreach($database in $dbInfo){
        $execMerge="
        EXEC inv.DatabaseMerge
            @InstanceID =$($f_currentInst.InstanceID),
            @DBID =$($database.DBID),
            @DatabaseName ='$($database.Name)',
            @State ='$($database.State)',
            @CompatibilityLevel =$($database.CompatibilityLevel),
            @RecoveryModel ='$($database.RecoveryModel)',
            @CanAcceptConnections =$($database.CanAcceptConnections),
            @DataConsumedSizeMB =$($database.DataConsumedSizeMB),
            @DataFreeSpaceMB =$($database.DataFreeSpaceMB),
            @LogConsumedSizeMB =$($database.LogConsumedSizeMB),
            @LogFreeSpaceMB =$($database.LogFreeSpaceMB),
            @ServerType ='$($database.ServerType)',
            @ReplicationStatus ='$($database.ReplicationStatus)',
            @IsEncrypted =$($database.IsEncrypted),
            @EncryptionType ='$($database.EncryptionType)',
            @HarvestDate ='$($database.DryRunDate)',
            --@AGID = '',
            @UPDATE_USER ='$($env:USERNAME)';
        "

        If( $f_HarvestInfo.DryRun ) {
            Write-Host "[DryRun] - Not Performing MERGE
            $($execMerge)"
        }
        ELSE{
            TRY{
                Write-verbose "
                $($execMerge)"
                Invoke-Sqlcmd -ServerInstance $f_HarvestInfo.TargetInvServer -Database $f_HarvestInfo.TargetDB -Query $execMerge -QueryTimeout 65535 -ErrorAction 'Stop' 
            }
            CATCH{
                Write-Host `t"[ALERT] FAILED TO MERGE $($database.DatabaseName)!!!!" -ForegroundColor Red 
                Write-Host `t"$($execMerge)"
                ### record information or raise alert?
                Write-Host `t"error: $_"

                $failedOBJ = [ordered]@{
                    Host = $($dbInfo.DatabaseName)
                    Function = "Merge-DBInfo"
                    Command = "$($execMerge)"
                    Message = $($_)
                }
                record-Failure $f_HarvestInfo $failedOBJ $f_HarvestInfo.DryRun
            }
        }
    }

} #>

function get-EmailInfo( [Object[]]$f_instanceInfo, [Object[]]$f_HarvestInfo ){

    $selectSQL = "
    DECLARE @EmailSubject VARCHAR(100), @EmailSendDate dateTime, @EmailStatus VARCHAR(100)
    SELECT TOP 1 @EmailSubject = Subject, @EmailSendDate = Send_request_Date, @EmailStatus = sent_status 
    FROM MSDB..sysmail_allitems 
    WHERE subject = 'EMAIL Test from '+ @@servername AND body like 'EMAIL Test from '+ @@servername +'%'
    ORDER BY  Send_request_Date desc

    select  $($f_instanceInfo.InstanceID) AS InstanceID, p.name as ProfileName, p.last_mod_datetime as ProfileLastModDatTime, p.last_mod_user as ProfileLastModUser,
        a.name as AccountName, a.description as AccountDescription, a.email_address as AccountEmailAddress, a.replyto_address as AccountReplyToAddress, a.last_mod_datetime as AccountLastModDateTime, a.last_mod_user AS AccountLastModUser,
        s.ServerName as ServerName, s.port as ServerPort, s.servertype as ServerType, s.last_mod_datetime as ServerLastModDateTime, s.last_mod_user AS ServerLastModUser,
        @EmailSubject AS EmailTestSubject, @EmailSendDate AS EmailTestSendDate, @EmailStatus AS EmailTestStatus
    from msdb.dbo.sysmail_profile p 
    join msdb.dbo.sysmail_profileaccount pa on p.profile_id = pa.profile_id 
    join msdb.dbo.sysmail_account a on pa.account_id = a.account_id 
    join msdb.dbo.sysmail_server s on a.account_id = s.account_id
    "

    TRY{
        write-verbose "
        $($selectSQL)"
        Invoke-Sqlcmd -ServerInstance $($f_instanceInfo.CMSConnectionString) -Database MASTER -Query $selectSQL -QueryTimeout 65535 -ErrorAction 'Stop' 
        #$results | Add-Member -membertype NoteProperty -name InstanceID -value "$(f_currentInst.InstanceID)"
        #$results
    }
    CATCH{
        Write-Host `t"[ALERT] FAILED TO QUERY $($f_instanceInfo.CMSConnectionString)" -ForegroundColor Red 
        Write-Host `t"$($selectSQL)"
        ### record information or raise alert?
        Write-Host `t"error: $_" -ForegroundColor Red 

        $failedOBJ = [ordered]@{
           Host = $($f_instanceInfo.DisplayName)
           Function = "get-traceInfo"
           Command = "$($selectSQL)"
           Message = $($_)
        }
        record-Failure $f_HarvestInfo $failedOBJ $f_dryRun
    }
}

function merge-EmailInfo( [Object[]]$f_EmailInfo, [Object[]]$f_HarvestInfo ){
    $emailCounter = 1
    ForEach($email in $f_emailInfo){
        $execMerge="EXEC inv.EmailMerge 
            @InstanceID = $($email.InstanceID), 
            @ProfileName = '$($email.ProfileName)',
            @ProfileLastModDatTime = '$($email.ProfileLastModDatTime)',
            @ProfileLastModUser = '$($email.ProfileLastModUser)',
            @AccountName = '$($email.AccountName)',
            @AccountDescription = '$($email.AccountDescription)',
            @AccountEmailAddress = '$($email.AccountEmailAddress)',
            @AccountReplyToAddress = '$($email.AccountReplyToAddress)',
            @AccountLastModDateTime = '$($email.AccountLastModDateTime)',
            @AccountLastModUser = '$($email.AccountLastModUser)',
            @ServerName = '$($email.ServerName)',
            @ServerPort = '$($email.ServerPort)',
            @ServerType = '$($email.ServerType)',
            @ServerLastModDateTime = '$($email.ServerLastModDateTime)',
            @ServerLastModUser = '$($email.ServerLastModUser)',
            @EmailTestSubject = '$($email.EmailTestSubject)',
            @EmailTestSendDate = '$($email.EmailTestSendDate)',
            @EmailTestStatus = '$($email.EmailTestStatus)',
            --@Comments,
            --@CREATE_DT,
            --@UPDATE_DT,
            @UPDATE_USER ='$($env:USERNAME)'; "
 
        If( $f_HarvestInfo.DryRun ){
            Write-Host "[DryRun] - Not Performing MERGE
            $($execMerge)"
        }
        ELSE{
            TRY{
                Write-Verbose `t"[ $($emailCounter) of $($f_EmailInfo.Count) ] $($email.ProfileName)"
                Write-verbose "
                $($execMerge)"
                Invoke-Sqlcmd -ServerInstance $f_HarvestInfo.TargetInvServer -Database $f_HarvestInfo.TargetDB -Query $execMerge -QueryTimeout 65535 -ErrorAction 'Stop' 
            }
            CATCH{
                Write-Host `t"[ALERT] FAILED TO MERGE $($email.ProfileName)" -ForegroundColor Red 
                Write-Host `t"$($execMerge)"
                ### record information or raise alert?
                Write-Host `t"error: $_" -ForegroundColor Red 

                $failedOBJ = [ordered]@{
                   Host = $($email.ProfileName)
                   Function = "Merge-EmailInfo"
                   Command = "$($email.ProfileName)"
                   Message = $($_)
                }
                record-Failure $f_HarvestInfo $failedOBJ $f_HarvestInfo.DryRun
            }
        }
        $emailCounter++
    } # ForEach($link in $f_linkInfo)
}

function get-DriveInfo( [Object[]]$f_instanceInfo, [Object[]]$f_HarvestInfo ){

    $selectSQL = "
    SELECT 
        $($f_instanceInfo.InstanceID) as [InstanceID]
        ,[Path]
        ,[TotalGB]
        ,[FreeGB]
        ,[FreePct]
        ,[HarvestDate]
    FROM [DBA].[info].[DriveUsage]
    "

    TRY{
        write-verbose "
        $($selectSQL)"
        Invoke-Sqlcmd -ServerInstance $($f_instanceInfo.CMSConnectionString) -Database MASTER -Query $selectSQL -QueryTimeout 65535 -ErrorAction 'Stop' 
        #$results | Add-Member -membertype NoteProperty -name InstanceID -value "$(f_currentInst.InstanceID)"
        #$results
    }
    CATCH{
        Write-Host `t"[ALERT] FAILED TO QUERY DriveInfo $($f_instanceInfo.CMSConnectionString)" -ForegroundColor Red 
        Write-Host `t"$($selectSQL)"
        ### record information or raise alert?
        Write-Host `t"error: $_" -ForegroundColor Red 

        $failedOBJ = [ordered]@{
           Host = $($f_instanceInfo.DisplayName)
           Function = "get-DriveInfo"
           Command = "$($selectSQL)"
           Message = $($_)
        }
        record-Failure $f_HarvestInfo $failedOBJ $f_dryRun
    }
}

function merge-DriveInfo( [Object[]]$f_DriveInfo, [Object[]]$f_HarvestInfo ){
    $DriveCounter = 1  # ????
    ForEach($drive in $f_DriveInfo){
        $execMerge="EXEC inv.DriveMerge 
            @InstanceID = $($drive.InstanceID), 
            @Path = '$($drive.Path)',
            @TotalGB = '$($drive.TotalGB)',
            @FreeGB = '$($drive.FreeGB)',
            @FreePCT = '$($drive.FreePCT)',
            @HarvestDate = '$($drive.HarvestDate)',
            --@Comments,
            --@CREATE_DT,
            --@UPDATE_DT,
            @UPDATE_USER ='$($env:USERNAME)'; "
 
        If( $f_HarvestInfo.DryRun ){
            Write-Host "[DryRun] - Not Performing MERGE
            $($execMerge)"
        }
        ELSE{
            TRY{
                Write-Verbose `t"[ $($DriveCounter) of $($f_DriveInfo.Count) ] $($drive.Path)"
                Write-verbose "
                $($execMerge)"
                Invoke-Sqlcmd -ServerInstance $f_HarvestInfo.TargetInvServer -Database $f_HarvestInfo.TargetDB -Query $execMerge -QueryTimeout 65535 -ErrorAction 'Stop' 
            }
            CATCH{
                Write-Host `t"[ALERT] FAILED TO MERGE Drive: $($drive.Path)" -ForegroundColor Red 
                Write-Host `t"$($execMerge)"
                ### record information or raise alert?
                Write-Host `t"error: $_" -ForegroundColor Red 

                $failedOBJ = [ordered]@{
                   Host = $($email.ProfileName)
                   Function = "Merge-DriveInfo"
                   Command = "$($execMerge)"
                   Message = $($_)
                }
                record-Failure $f_HarvestInfo $failedOBJ $f_HarvestInfo.DryRun
            }
        }
        $DriveCounter++
    } # ForEach($drive in $f_DriveInfo)
}

function get-agInfo( [Object[]]$f_instanceInfo, [Object[]]$f_HarvestInfo ){

    $selectSQL = "
     SELECT sd.name, --compatibility_level, recovery_model_desc,
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
    "

    TRY{
        write-verbose "
        $($selectSQL)"
        Invoke-Sqlcmd -ServerInstance $($f_instanceInfo.CMSConnectionString) -Database MASTER -Query $selectSQL -QueryTimeout 65535 -ErrorAction 'Stop' 
        #$results | Add-Member -membertype NoteProperty -name InstanceID -value "$(f_currentInst.InstanceID)"
        #$results
    }
    CATCH{
        Write-Host `t"[ALERT] FAILED TO QUERY AG $($f_instanceInfo.CMSConnectionString)" -ForegroundColor Red 
        Write-Host `t"$($selectSQL)"
        ### record information or raise alert?
        Write-Host `t"error: $_" -ForegroundColor Red 

        $failedOBJ = [ordered]@{
           Host = $($f_instanceInfo.DisplayName)
           Function = "get-agInfo"
           Command = "$($selectSQL)"
           Message = $($_)
        }
        record-Failure $f_HarvestInfo $failedOBJ $f_dryRun
    }
}

function merge-agInfo( [Object[]]$f_agInfo, [Object[]]$f_HarvestInfo ){
    $dbCounter = 1  # ????
    ForEach($database in $f_agInfo){
        $execMerge="EXEC inv.EmailMerge @InstanceID = $($email.InstanceID), 
            @ProfileName = '$($email.ProfileName)',
            @ProfileLastModDatTime = '$($email.ProfileLastModDatTime)',
            @ProfileLastModUser = '$($email.ProfileLastModUser)',
            @AccountName = '$($email.AccountName)',
            @AccountDescription = '$($email.AccountDescription)',
            @AccountEmailAddress = '$($email.AccountEmailAddress)',
            @AccountReplyToAddress = '$($email.AccountReplyToAddress)',
            @AccountLastModDateTime = '$($email.AccountLastModDateTime)',
            @AccountLastModUser = '$($email.AccountLastModUser)',
            @ServerName = '$($email.ServerName)',
            @ServerPort = '$($email.ServerPort)',
            @ServerType = '$($email.ServerType)',
            @ServerLastModDateTime = '$($email.ServerLastModDateTime)',
            @ServerLastModUser = '$($email.ServerLastModUser)',
            @EmailTestSubject = '$($email.EmailTestSubject)',
            @EmailTestSendDate = '$($email.EmailTestSendDate)',
            @EmailTestStatus = '$($email.EmailTestStatus)',
            --@Comments,
            --@CREATE_DT,
            --@UPDATE_DT,
            @UPDATE_USER ='$($env:USERNAME)'; "
 
        If( $f_HarvestInfo.DryRun ){
            Write-Host "[DryRun] - Not Performing MERGE
            $($execMerge)"
        }
        ELSE{
            TRY{
                Write-Host `t"[ $($emailCounter) of $($f_EmailInfo.Count) ] $($email.ProfileName)"
                Write-verbose "
                $($execMerge)"
                Invoke-Sqlcmd -ServerInstance $f_HarvestInfo.TargetInvServer -Database $f_HarvestInfo.TargetDB -Query $execMerge -QueryTimeout 65535 -ErrorAction 'Stop' 
            }
            CATCH{
                Write-Host `t"[ALERT] FAILED TO MERGE $($email.ProfileName)" -ForegroundColor Red 
                Write-Host `t"$($execMerge)"
                ### record information or raise alert?
                Write-Host `t"error: $_" -ForegroundColor Red 

                $failedOBJ = [ordered]@{
                   Host = $($email.ProfileName)
                   Function = "Merge-agInfo"
                   Command = "$($execMerge)"
                   Message = $($_)
                }
                record-Failure $f_HarvestInfo $failedOBJ $f_HarvestInfo.DryRun
            }
        }
        $emailCounter++
    } # ForEach($database in $f_agInfo)
}

function get-AuditLoginInfo( [Object[]]$f_instanceInfo, [Object[]]$f_HarvestInfo ){

    $selectSQL = "
    SELECT $($f_instanceInfo.InstanceID) as [InstanceID]
          ,[TimeStampUTC]
          ,[UserName]
          ,[NTUserName]
          ,[ServerPrincipalName]
          ,[IsSystem]
          ,[ClientHostName]
          ,[ClientAppName]
          ,[DatabaseName]
    FROM [DBA].[info].[AuditLogin]
    "

    TRY{
        write-verbose "
        $($selectSQL)"
        Invoke-Sqlcmd -ServerInstance $($f_instanceInfo.CMSConnectionString) -Database MASTER -Query $selectSQL -QueryTimeout 65535 -ErrorAction 'Stop' 
        #$results | Add-Member -membertype NoteProperty -name InstanceID -value "$(f_currentInst.InstanceID)"
        #$results
    }
    CATCH{
        Write-Host `t"[ALERT] FAILED TO QUERY AuditLogin $($f_instanceInfo.CMSConnectionString)" -ForegroundColor Red 
        Write-Host `t"$($selectSQL)"
        ### record information or raise alert?
        Write-Host `t"error: $_" -ForegroundColor Red 

        $failedOBJ = [ordered]@{
           Host = $($f_instanceInfo.DisplayName)
           Function = "get-AuditLoginInfo"
           Command = "$($selectSQL)"
           Message = $($_)
        }
        record-Failure $f_HarvestInfo $failedOBJ $f_dryRun
    }
}

function merge-AuditLoginInfo( [Object[]]$f_alInfo, [Object[]]$f_HarvestInfo ){
    $LoginCounter = 1  # ????
    ForEach($login in $f_alInfo){
        $execMerge="EXEC inv.AuditLoginMerge 
            @InstanceID = $($login.InstanceID), 
            @TimeStampUTC = '$($login.TimeStampUTC)',
            @UserName = '$($login.UserName)',
            @NTUserName = '$($login.NTUserName)',
            @ServerPrincipalName = '$($login.ServerPrincipalName)',
            @IsSystem = '$($login.IsSystem)',
            @ClientHostName = '$($login.ClientHostName)',
            @ClientAppName = '$($login.ClientAppName)',
            @DatabaseName = '$($login.DatabaseName)',
            @HarvestDAte = '$(Get-Date)',
            --@Comments,
            --@CREATE_DT,
            --@UPDATE_DT,
            @UPDATE_USER ='$($env:USERNAME)'; "
 
        If( $f_HarvestInfo.DryRun ){
            Write-Host "[DryRun] - Not Performing MERGE
            $($execMerge)"
        }
        ELSE{
            TRY{
                Write-Host `t"[ $($LoginCounter) of $($f_alInfo.Count) ] $($login.UserName)"
                Write-verbose "
                $($execMerge)"
                Invoke-Sqlcmd -ServerInstance $f_HarvestInfo.TargetInvServer -Database $f_HarvestInfo.TargetDB -Query $execMerge -QueryTimeout 65535 -ErrorAction 'Stop' 
            }
            CATCH{
                Write-Host `t"[ALERT] FAILED TO MERGE AuditLoginInfo" -ForegroundColor Red 
                Write-Host `t"$($execMerge)"
                ### record information or raise alert?
                Write-Host `t"error: $_" -ForegroundColor Red 

                $failedOBJ = [ordered]@{
                   Host = $($login.UserName)
                   Function = "Merge-AuditLoginInfo"
                   Command = "$($execMerge)"
                   Message = $($_)
                }
                record-Failure $f_HarvestInfo $failedOBJ $f_HarvestInfo.DryRun
            }
        }
        $LoginCounter++
    } # ForEach($database in $f_agInfo)
}

function get-JobInfo( [Object[]]$f_instanceInfo, [Object[]]$f_HarvestInfo ){

    $selectSQL = "
     SELECT 
          $($f_instanceInfo.InstanceID) as [InstanceID]
          ,[JobName]
          ,[JobDescription]
          ,[JobCategory]
          ,[JobEnabled]
          ,[JobStatus]
          ,[StatusDesc]
          ,[JobDurationSec]
          ,[RunDateTime]
          ,[EndDateTime]
          ,[CreateDate]
          ,[ModifiedDate]
          ,[HarvestDate]
      FROM [info].[AgentJob]
    "

    TRY{
        write-verbose "
        $($selectSQL)"
        Invoke-Sqlcmd -ServerInstance $($f_instanceInfo.CMSConnectionString) -Database DBA -Query $selectSQL -QueryTimeout 65535 -ErrorAction 'Stop' 
        #$results | Add-Member -membertype NoteProperty -name InstanceID -value "$(f_currentInst.InstanceID)"
        #$results
    }
    CATCH{
        Write-Host `t"[ALERT] FAILED TO QUERY Jobs $($f_instanceInfo.CMSConnectionString)" -ForegroundColor Red 
        Write-Host `t"$($selectSQL)"
        ### record information or raise alert?
        Write-Host `t"error: $_" -ForegroundColor Red 

        $failedOBJ = [ordered]@{
           Host = $($f_instanceInfo.DisplayName)
           Function = "get-JobInfo"
           Command = "$($selectSQL)"
           Message = $($_)
        }
        record-Failure $f_HarvestInfo $failedOBJ $f_dryRun
    }
}

function delete-JobInfo( [Object[]]$f_instanceInfo, [Object[]]$f_HarvestInfo ){

    TRY{
        Write-Verbose "No Agent Jobs found - removing any from inventory.."
        <# Should be stored procedure in InventoryDWH #>
        $deleteSQL = "DELETE FROM inv.AgentJob WHERE InstanceID = $($f_instanceInfo.InstanceID)"
        Write-verbose "
        $($deleteSQL)"
        Invoke-Sqlcmd -ServerInstance $f_HarvestInfo.TargetInvServer -Database $f_HarvestInfo.TargetDB -Query $deleteSQL -QueryTimeout 65535 -ErrorAction 'Stop' 
    }
    CATCH{
        Write-Host `t"[ALERT] FAILED TO DELETE WHERE InstanceID = $($f_instanceInfo.InstanceID)" -ForegroundColor Red 
        Write-Host `t"$($deleteSQL)"
        ### record information or raise alert?
        Write-Host `t"error: $_" -ForegroundColor Red 

        $failedOBJ = [ordered]@{
            Host = $($f_instanceInfo.DisplayName)
            Function = "Delete-JobInfo"
            Command = "$($deleteSQL)"
            Message = $($_)
        }
        record-Failure $f_HarvestInfo $failedOBJ $f_HarvestInfo.DryRun
    }

}

function merge-JobInfo( [Object[]]$f_JobInfo, [Object[]]$f_HarvestInfo ){
    $JobCounter = 1  # ????
    ForEach($Job in $f_JobInfo){
        $execMerge="EXEC inv.AgentJobMerge 
            @InstanceID = $($Job.InstanceID), 
            @JobName = '$($Job.JobName -replace("'","''") )',
            @JobDescription = '$($Job.JobDescription -replace("'","''") )',
            @JobCategory = '$($Job.JobCategory)',
            @JobEnabled = '$($Job.JobEnabled)',
            @JobStatus = '$($Job.JobStatus)',
            @StatusDesc = '$($Job.StatusDesc)',
            @JobDurationSec = '$($Job.JobDurationSec)',
            @RunDateTime = '$($Job.RunDateTime)',
            @EndDateTime = '$($Job.EndDateTime)',
            @CreateDate = '$($Job.CreateDate)',
            @ModifiedDate = '$($Job.ModifiedDate)',
            @HarvestDate = '$($Job.HarvestDate)',
            --@Comments,
            --@CREATE_DT,
            --@UPDATE_DT,
            @UPDATE_USER ='$($env:USERNAME)';"
 
        If( $f_HarvestInfo.DryRun ){
            Write-Host "[DryRun] - Not Performing MERGE
            $($execMerge)"
        }
        ELSE{
            TRY{
                Write-Verbose `t"[ $($JobCounter) of $($f_JobInfo.Count) ] $($Job.JobName)"
                Write-verbose "
                $($execMerge)"
                Invoke-Sqlcmd -ServerInstance $f_HarvestInfo.TargetInvServer -Database $f_HarvestInfo.TargetDB -Query $execMerge -QueryTimeout 65535 -ErrorAction 'Stop' 
            }
            CATCH{
                Write-Host `t"[ALERT] FAILED TO MERGE $($email.JobName)" -ForegroundColor Red 
                Write-Host `t"$($execMerge)"
                ### record information or raise alert?
                Write-Host `t"error: $_" -ForegroundColor Red 

                $failedOBJ = [ordered]@{
                   Host = $($email.ProfileName)
                   Function = "Merge-JobInfo"
                   Command = "$($execMerge)"
                   Message = $($_)
                }
                record-Failure $f_HarvestInfo $failedOBJ $f_HarvestInfo.DryRun
            }
        }
        $JobCounter++
    } # ForEach($Job in $f_JobInfo)
}

###############################################################################################################################

#Create Results DataTable
IF( $ProcessInfo -like "EXEC*" ){
    $ResultsTable = New-Object System.Data.DataTable 
    [void]$ResultsTable.Columns.Add("Count")
    [void]$resultsTable.Columns.Add("Source")
    [void]$resultsTable.Columns.Add("Command")
}

### Create Harvet object with start date
$HarvestInfo = [ordered]@{
    TargetCMS = $TargetCMS
    CMSGroup = $CMSGroup
    TargetInvServer = $TargetInvServer
    TargetDB = $TargetInvDB
    ProcessInfo =  $ProcessInfo
    Force = $Force
    DryRun = $DryRun
    StartDateTime = Get-Date
    StartedByUser = $env:USERNAME
}

$TargetInventory = [ordered]@{
    ServerName = $TargetInvServer
    TargetDB = $TargetInvDB
}

Write-Output "Harvest Initiated at :$($HarvestInfo.StartDateTime) by: $($HarvestInfo.StartedByUser)"
Write-Output "[] CMS Instance: $($HarvestInfo.targetCMS)"
IF( $($HarvestInfo.StartedByUser) -ne "Power-Daemon-PROD" ){
    $cmsInst = get-SQLServiceStatus $($HarvestInfo.targetCMS) 'Instance' 
    IF( $cmsInst.Status -eq "Running" ){
        Write-Host " ] CMS Instance Online"
    }
    else{
        Write-Host "[ALERT] CMS INSTANCE OFFLINE!!!!!" -ForegroundColor Red
        EXIT
    }
}

Write-Output "[] Inv Instance: $($HarvestInfo.targetInvServer)"
IF( $($HarvestInfo.StartedByUser) -ne "Power-Daemon-PROD" ){
    $invInst = get-SQLServiceStatus $($HarvestInfo.targetInvServer) 'Instance'
    IF( $invInst.Status -eq "Running" ){
        Write-Host " ] Inv Instance Online"
    }
    else{
        Write-Host "[ALERT] INVENTORY INSTANCE OFFLINE!!!!!" -ForegroundColor Red
        EXIT
    }
}

Write-Output "[] Inv Database: $($HarvestInfo.targetDB)"
IF( $($HarvestInfo.StartedByUser) -ne "Power-Daemon-PROD" ){
    $invdb = get-DBstate $($TargetInventory) $($HarvestInfo) 
    IF( $invDB.Status -eq "Online" ){
        Write-Host " ] Inv Instance Online"
    }
    else{
        Write-Host "[ALERT] INVENTORY DATABASE OFFLINE!!!!!" -ForegroundColor Red
        EXIT
    }
}

# Needs try Catch
IF( $TargetHost -eq ""){
    IF( $HarvestInfo.cmsGroup -eq "" ){
        Write-Host "[] No CMS Group and no target instance supplied - exiting"
        EXIT
    }
    ELSE{
        Write-Host "[] No target instance supplied - looking at Inventory for CMS group $($HarvestInfo.cmsGroup)"
        If( $HarvestInfo.cmsGroup -eq "nonprod"){
            $execSQL = "EXEC info.getCMSApplications @SearchENV = 'nonPROD'"
            #$selectSQL = "SELECT [SQLServerName] as DisplayName, [DomainName] as DomainName, [ServerEnvironment] FROM [InventoryDWH].[inv].[SQLInstances] WHERE ServerEnvironment NOT IN ( 'PROD', 'ADMIN', '_DCOM' ) ORDER BY ServerEnvironment, SQLServerName"
        }
        ELSEIf( $HarvestInfo.cmsGroup -eq "allprod"){
            $execSQL = "EXEC info.getCMSApplications @SearchENV = 'allPROD'"
            #$selectSQL = "SELECT [SQLServerName] as DisplayName, [DomainName] as DomainName, [ServerEnvironment] FROM [InventoryDWH].[inv].[SQLInstances] WHERE ServerEnvironment IN ( 'PROD', 'ADMIN' ) ORDER BY ServerEnvironment, SQLServerName"
        }
        ELSEIf( $HarvestInfo.cmsGroup -eq "all"){
            $execSQL = "EXEC info.getCMSInstances @SearchENV = 'ALL'"
            ##$selectSQL = "SELECT [SQLServerName] as DisplayName, [DomainName] as DomainName, [ServerEnvironment] FROM [InventoryDWH].[inv].[SQLInstances] ORDER BY ServerEnvironment, SQLServerName"
        }
        ELSE{
            $execSQL = "EXEC info.getCMSInstances @SearchENV = '$($HarvestInfo.cmsGroup)'"
            #$selectSQL = "SELECT [SQLServerName] as DisplayName, [DomainName] as DomainName, Local_net_address +','+ convert(varchar(10), Port) as ConnectionString, [ServerEnvironment] FROM [InventoryDWH].[inv].[Instance] WHERE ServerEnvironment = '$($HarvestInfo.cmsGroup)' ORDER BY SQLServerName"
        }

        Write-Output "[] Getting $($HarvestInfo.cmsGroup) Instances "  
        #Write-Verbose $selectSQL
        #$execSQL = "EXEC info.getCMSInstances @searchENV = '$($HarvestInfo.CMSGroup)'"
        Write-Output `t"$($execSQL)"
        # Get CMS info
        $InstList = @( invoke-sqlcmd -ServerInstance $HarvestInfo.targetCMS -Database $HarvestInfo.targetDB -Query $execSQL -QueryTimeout 65535 -ErrorAction 'Stop' )
    }
}
else{
    Write-Host "[] Getting $($TargetHost) Info "           
    $execSQL = "EXEC info.getCMSInstances @searchHost = '$($TargetHost)'"
    Write-Host `t"$($execSQL)"
    # Get single host information
    $InstList = @( invoke-sqlcmd -ServerInstance $HarvestInfo.targetCMS -Database $HarvestInfo.targetDB -Query $execSQL -QueryTimeout 65535 -ErrorAction 'Stop' )
}
Write-Host " "
#$InstanceCount = $InstList.Count
$HarvestInfo | Add-Member -membertype NoteProperty -name InstanceCount -value "$($InstList.Count)" 
## Merge Harvets info and return ID.
$HarvestID = Merge-HarvestInfo $HarvestInfo $DryRun
$HarvestInfo | Add-Member -membertype NoteProperty -name HarvestID -value "$($HarvestID)"
IF(!$HarvestID){
    Write-Verbose "CRAP!"
}
ELSE{
    [int] $instCounter = 1
    forEach( $currentInst in $InstList ){
        Write-Output "[ Processing: $($instCounter) of $($InstList.Count) ]"
        Write-Output " ] Ping Test: $($currentInst.DisplayName)"
        [string] $listenerTarget = ""
        IF( !$($HarvestInfo.Force) ){
            $currentPing = ping-host $($currentInst.DisplayName) $currentDomain 
        }
        ELSE{
            Write-Output '[FORCE] - Skipping ping test'
            $currentPing = $true
        }
        IF( $currentPing ){
            if( $currentInst.DisplayName -like '*listen*' ){
                ## verify Listner target host is in arral $instList
                try{
                    Write-Output " ] Resolve Listener target"
                    $listenerTarget = Invoke-Sqlcmd -ServerInstance $currentInst.DisplayName -Database MASTER -Query 'SELECT @@ServerName as ServerName' -QueryTimeout 65535 -ErrorAction 'Stop' | select -exp ServerName
                }
                Catch{
                    Write-Host "[ALERT] FAILED TO RESOLVE LISTENER  $($currentInst.DisplayName)" -ForegroundColor Red 

                    $failedOBJ = [ordered]@{
                       Host = $($currentInst.DisplayName)
                       Function = "Resolve-Listener"
                       Command = "Resolve-Listener $($currentInst.DisplayName) $currentDomain"
                       Message = 'NA' 
                    }
                    record-Failure $HarvestInfo $failedOBJ $HarvestInfo.DryRun
                }
            }
                if( $InstList.DisplayName -contains $listenerTarget ){
                    Write-Host "[WARNING] Listener is duplicate $($listenerTarget) - skipping." -ForegroundColor Yellow
                }
                else{
                    
                    Write-Host " ] Confirm Instance Online: $($currentInst.DisplayName) "
                    IF( !$($HarvestInfo.Force) ){
                        $currentService = get-SQLServiceStatus $($currentInst.DisplayName) 'Instance'
                    }
                    ELSE{
                        Write-Output '[FORCE] - Skipping Service check'
                    }

                    IF($HarvestInfo.ProcessInfo -like 'AUTO*'){
                        IF( ($currentService.Status -eq "Running") -OR ( $($HarvestInfo.Force) ) ){
                            Write-Output " ] Query Instance"
                            $instanceInfo = get-InstInfo $($currentInst) $($HarvestInfo)
                        
                            if( $instanceInfo.SQLServerName.Count -gt 0 ){

                                if( ($HarvestInfo.ProcessInfo -eq "CMS") -or ($HarvestInfo.ProcessInfo -eq "Auto") ){
                                    Write-Host " ] Merge Instance"
                                    $InstanceID = merge-InstInfo $($instanceInfo) $($currentInst) $($HarvestInfo)
                                    ### IF InstanceID is null need to throw out....
                                    $InstanceInfo | Add-Member -membertype NoteProperty -name InstanceID -value "$($InstanceID)"
                                    Write-Verbose `t"Adding - Property : InstanceInfo.InstanceID Value : $($InstanceInfo.InstanceID) "
                                 
                                    IF( $($currentInst.ApplicationName) -ne 'Instance' ){
                                        Write-Output " ] Merge Application and Instance: $($currentInst.ApplicationName)"
                                        ### Return appID ?  Not to be done here.  Needs process during setup and config
                                        #merge-AppInst  $($currentInst.ApplicationName) $($InstanceInfo) $($HarvestInfo)
                                    }
                                    ELSE{
                                        Write-Output "[SKIP] Merge Application and Instance: $($currentInst.ApplicationName)"
                                    }


                                }

                                if( ($HarvestInfo.ProcessInfo -eq "traceflags") -or ($HarvestInfo.ProcessInfo -eq "Auto") ){
                                    Write-Host " ] Query TraceFlags"
                                    $TraceInfo = @()
                                    $TraceInfo += get-TraceInfo $($instanceInfo) $($HarvestInfo)

                                    Write-Host " ] Merge TraceFlags: $($traceInfo.Count)"
                                    merge-TraceInfo $($instanceInfo) $($traceInfo) $($HarvestInfo)
                                }

                                if( ($HarvestInfo.ProcessInfo -eq "linkedServers") -or ($HarvestInfo.ProcessInfo -eq "Auto") ){ 
                                    Write-Host " ] Query LinkedServers"
                                    $linkInfo = @()
                                    $linkInfo += get-linkInfo $($instanceInfo) $($HarvestInfo)
                            
                                    #IF( $($linkInfo.Count) -gt 0 ){
                                        Write-Host " ] Merge LinkedServers: $($linkInfo.Count)"
                                        merge-linkInfo $($linkInfo) $($instanceInfo) $($HarvestInfo)
                                    #}
                                    #else{
                                    #    Write-Host " ] Delete LinkedServers: $($linkInfo.Count)"
                                    #    delete-linkInfo $($instanceInfo) $($HarvestInfo)
                                    #}
                                
                                }

                                if( ($HarvestInfo.ProcessInfo -eq "AgentJob") -or ($HarvestInfo.ProcessInfo -eq "Auto") ){ 
                                    Write-Host " ] Query AgentJobs"
                                    $JobInfo = @()
                                    $JobInfo += get-JobInfo $($instanceInfo) $($HarvestInfo)
                                    IF( $($JobInfo.Count) -gt 0 ){
                                        Write-Host " ] Merge AgentJobs: $($JobInfo.Count)"
                                        merge-JobInfo $($JobInfo) $($HarvestInfo)
                                    }
                                    else{
                                        Write-Host " ] Delete AgentJobs: $($JobInfo.Count)"
                                        delete-JobInfo $($instanceInfo) $($HarvestInfo)
                                    }
                                }

                                if( ($HarvestInfo.ProcessInfo -eq "email") -or ($HarvestInfo.ProcessInfo -eq "Auto") ){ 
                                    Write-Host " ] Query Email"
                                    $EmailInfo = @()
                                    $EmailInfo += get-EmailInfo $($instanceInfo) $($HarvestInfo)

                                    Write-Host " ] Merge Email: $($EmailInfo.Count)"
                                    merge-EmailInfo $($EmailInfo) $($HarvestInfo)
                                }

                                if( ($HarvestInfo.ProcessInfo -eq "drive") -or ($HarvestInfo.ProcessInfo -eq "Auto") ){ 
                                    Write-Host " ] Query Drives"
                                    $DriveInfo = @()
                                    $DriveInfo += get-DriveInfo $($instanceInfo) $($HarvestInfo)

                                    Write-Host " ] Merge Drives: $($DriveInfo.Count)"
                                    merge-DriveInfo $($DriveInfo) $($HarvestInfo)
                                }

                                if( ($HarvestInfo.ProcessInfo -eq "database") -or ($HarvestInfo.ProcessInfo -eq "Auto") ){ 
                                    #Write-Host " ] Harvest DB Info"
                                    #Harvest-dbInfo $($instanceInfo) $($HarvestInfo)
                                    Write-Host " ] Query Databases"
                                    $dbInfo = @()
                                    $dbInfo += get-dbInfo $($instanceInfo) $($HarvestInfo)

                                    Write-Host " ] Merge Databases: $($dbInfo.Count)"
                                    merge-dbInfo $($dbInfo) $($HarvestInfo)
                                }
                            
                                If( $($dbInfo.Count) -gt 0 ){ 
                                    if( $dbInfo.ServerType.Contains("PRIMARY") ){
                                        Write-Host "DISABLED ] Query Availability Group from Primary"
                                        $agInfo = @()
                                        #$agInfo += get-agInfo $($instanceInfo) $($HarvestInfo)

                                        Write-Host "DISABLED ] Merge Availability Group: $($agInfo.Count)"
                                        #merge-agInfo $($agInfo) $($HarvestInfo)
                                    }
                                }
                                if( ($HarvestInfo.ProcessInfo -eq "AuditLogin") -or ($HarvestInfo.ProcessInfo -eq "Auto") ){
                                    Write-Host "DISABLED ] Query Audit Login"
                                    $alInfo = @()
                                    $alInfo += get-AuditLoginInfo $($instanceInfo) $($HarvestInfo)

                                    Write-Host "DISABLED ] Merge Audit Login: $($alInfo.Count)"
                                    merge-AuditLoginInfo $($alInfo) $($HarvestInfo)
                                }

                                IF( (($($HarvestInfo.ProcessInfo) -eq "Host") -OR ($($HarvestInfo.ProcessInfo) -eq "Auto")) -and ($($HarvestInfo.StartedByUser) -ne "Power-Daemon-PROD") ){
                                    Write-Host " ] Query Host: $($InstanceInfo.MachineName)"
                                    $hostInfo = get-HostInfo $($instanceInfo) $($HarvestInfo)

                                    IF( $($instanceInfo.MachineName) -eq $($hostInfo.MachineName) ){
                                        Write-Host " ] Merge Host"
                                        merge-HostInfo $($hostInfo) $($HarvestInfo)
                                    }
                                }
                            
                                IF( (($($HarvestInfo.ProcessInfo) -eq "DDBoost") -OR ($($HarvestInfo.ProcessInfo) -eq "Auto")) -and ($($HarvestInfo.StartedByUser) -ne "Power-Daemon-PROD") ){
                                    Write-Host " ] Query DDBoost: $($InstanceInfo.MachineName)"
                                    $DDBoostInfo = get-RemoteDDBoostVersion $($InstanceInfo.MachineName)

                                    #IF( $($instanceInfo.MachineName) -eq $($hostInfo.MachineName) ){
                                        Write-Host " ] Merge DDBoost"
                                        Write-Host $DDBoostInfo
                                        merge-DDBoostInfo $($hostInfo) $($DDBoostInfo) $($HarvestInfo)
                                    #}
                                }
                   
                            }
                            ELSE{
                                Write-Verbose '[WARNING] Verify SQL Agent Job : DBA-HarvestDaily'

                            }
                        }
                        ELSE{
                            IF( $currentInst.Description -like 'DCOM*' ){
                                Write-Host "[Warning] DCOM Instance not retired in inventory" -ForegroundColor Yellow 
                            }
                            ELSE{
                                Write-Host "[ALERT] INSTANCE OFFLINE!!!!!" -ForegroundColor Red 
                                $failedOBJ = [ordered]@{
                                   Host = $($currentInst.DisplayName)
                                   Function = "get-SQLServiceStatus"
                                   Command = "get-SQLServiceStatus $($currentInst.DisplayName) 'Instance' -eq `"Running`""
                                   Message = $($_)
                                }

                                record-Failure $HarvestInfo $failedOBJ $HarvestInfo.DryRun
                            }

                        }
                    }
                    ELSE{ ################## -like EXEC
                            IF($currentInst.DisplayName.indexOf('\') -gt 0){
                                    $TargetServer = $currentInst.DisplayName.substring(0,$currentInst.DisplayName.IndexOf('\'))
                                    if( $TargetServer -eq '.' ){ $TargetServer = '127.0.0.1' }
                                }
                            ELSEIF($currentInst.DisplayName.indexOf(',') -gt 0){
                                    $TargetServer = $currentInst.DisplayName.substring(0,$currentInst.DisplayName.IndexOf(','))
                                }
                            ELSE{
                                    $TargetServer = $currentInst.DisplayName
                                }

                        #(get-RemoteProcess -server $currentInst.DisplayName -ProcessName ddbmexptool).Count
                        Try{
                            #$ProcessDetails = (get-RemoteProcess -server $TargetServer -ProcessName ddbmexptool).Count
                            #IF( $ProcessDetails.ProcessID.Count -gt 0){
                                #get-RemoteProcess -server $TargetServer -ProcessName ddbmexptool | Format-Table -AutoSize
                                Write-Host " ] Get-RemoteProcess -server $($TargetServer) -ProcessName ddbmexptool"
                                #$ProcessDetails = @()
                                $ProcessDetails = get-RemoteProcess -server $($TargetServer) -ProcessName ddbmexptool
                                $ProcessDetails | Format-Table -auto
                               #IF( $ProcessDetails.StartDate -lt (get-date).addDays(-1) ){ Write-Host "Too Old"}
                                IF( (($ProcessDetails.ProcessID.Count -gt 0) -AND ($ProcessDetails.StartDate -lt (get-date).addDays(-1))) -or ($Force -eq 1) ){
                                    IF( (($ProcessDetails.ProcessID.Count -gt 0) -AND ($ProcessDetails.StartDate -lt (get-date).addDays(-1))) ){
                                        Write-Host "[Alert] Run Stop-RemoteProcess -Server $($TargetServer) -ProcessName ddbmexptool " -ForegroundColor Red 
                                        [void]$ResultsTable.Rows.Add($ProcessCount, $currentInst.DisplayName, "Stop-RemoteProcess -Server $($TargetServer) -ProcessName ddbmexptool" )
                                    }

                                    if( ($DryRun -eq 0) -and ($Force -eq 1)  ){ # -AND ($ProcessDetails.ProcessID.Count -gt 0) should need force to take action
                                        Write-Host "$(if($Force){'[FORCE'}ELSE{' '})] Stop-RemoteProcess -server $($TargetServer) -ProcessName ddbmexptool $(if($Force){' -FORCE 1'}ELSE{''})" -ForegroundColor Red 
                                        Stop-RemoteProcess -Server $($TargetServer) -ProcessName ddbmexptool -Force $Force
                                    }
                                }
                            #}
                            #ELSE{
                            #    write-host "Process is not running" -ForegroundColor Yellow 
                            #}
                        }
                        Catch{
                            Write-Host "[Alert] Cannot connect to: $($TargetServer) -ProcessName ddbmexptool " -ForegroundColor Red 
                            [void]$ResultsTable.Rows.Add($ProcessCount, $currentInst.DisplayName, "Kill-RemoteProcess -Server $($TargetServer) -ProcessName ddbmexptool" )
                        }


                    }


                }


        }
        ELSE{
            ## IF Instance marked for DCOM do not alert just mark as DOWN.
            if( $currentInst.Description -like 'DCOM*' ){
                Write-Host "[WARNING] Host marked for decom - update inventory as down."  -ForegroundColor Yellow
                $updateSQL = "
                    UPDATE inv.SQLInstances 
                    SET ServerStatus = 'DOWN', 
                        ServerEnvironment = '_DCOM',
                        Comments = '$($currentInst.Description)'
                    WHERE SQLServerName = '$($currentInst.DisplayName)'"
                TRY{
                    write-verbose "
                    $($updateSQL)"
                    Invoke-Sqlcmd -ServerInstance $HarvestInfo.targetCMS -Database $HarvestInfo.targetDB -Query $updateSQL -QueryTimeout 65535 -ErrorAction 'Stop' 
                }
                CATCH{
                    Write-Host `t"[ALERT] FAILED TO UPDATE $($HarvestInfo.targetDB)" -ForegroundColor Red 
                    Write-Host `t"$($updateSQL)"
                    ### record information or raise alert?
                    Write-Host `t"error: $_" -ForegroundColor Red 

                    $failedOBJ = [ordered]@{
                        Host = $($currentInst.DisplayName)
                        Function = "get-linkInfo"
                        Command = "$($updateSQL)"
                        Message = $($_)
                    }
                    record-Failure $HarvestInfo $failedOBJ $HarvestInfo.DryRun
                }

            }
            ELSEIF( $currentInst.Description -like 'SQL Auth only*'){
                 Write-Host "[WARNING] Host marked as SQL Auth Only."  -ForegroundColor Yellow 
                 # record Warnings as message in HarvestFailures ?

            }
            ELSE{
                Write-Host "[ALERT] FAILED TO PING  $($currentInst.DisplayName)" -ForegroundColor Red 

                $failedOBJ = [ordered]@{
                    Host = $($currentInst.DisplayName)
                    Function = "Ping-Host"
                    Command = "ping-host $($currentInst.DisplayName) $currentDomain"
                    Message = $($_)
                }
                record-Failure $HarvestInfo $failedOBJ $HarvestInfo.DryRun
            }

        }

        $instCounter++
    }

    $HarvestInfo | Add-Member -membertype NoteProperty -name EndDateTime -value "$(Get-Date)"
    Write-Host "[] Harvest complete: $($HarvestInfo.EndDateTime)"
    $ThrowAway = Merge-HarvestInfo $HarvestInfo $HarvestInfo.DryRun

    $ResultsTable | Sort-Object @{Expression = "Count"}, @{Expression = "Source"}, @{Expression = "Command"}  | Format-Table -AutoSize
}


