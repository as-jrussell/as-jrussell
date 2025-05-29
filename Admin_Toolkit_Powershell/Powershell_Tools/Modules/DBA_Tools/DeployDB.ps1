 [cmdletbinding(SupportsShouldProcess=$True)]
<#
.SYNOPSIS

Deploys trusted scripts to servers known to the CMS.

.DESCRIPTION

Runs scripts against administrative databases and attempts to create them where missing.

.PARAMETER 

Specifies the

.PARAMETER 

Specifies the 

.PARAMETER 

Specifies the 

.PARAMETER

Specifies the 

.PARAMETER dryRun

Specifies if the user wants to perform what if.

.INPUTS

None. You cannot pipe objects to Add-Extension.

.OUTPUTS

None.  You cannot pass output from this script to another.

.EXAMPLE

.\deployDB.ps1 -targetDB "DBA" -cmsGroup "DEV" -dryRun 0 -verbose

.EXAMPLE

.\deployDB.ps1 -targetDB "InventoryDWH" -targetHost ".\HKB1" -repoFolder "Create"

.EXAMPLE

.\deployDB.ps1 -targetDB "InventoryDWH" -targetHost ".\HKB1" -targetCMS "DBA-SQLPRD-01\I01" -dryRun 0 -verbose

.EXAMPLE

.\deployDB.ps1 -targetDB "InventoryDWH" -targetHost ".\HKB1" -repoRoot "C:\Users\hbrotherton\source\Workspaces\DBA\InventoryDWH" -repoFolder "StoredProcedure"

.EXAMPLE

.\deployDB.ps1 -targetDB "InventoryDWH" -targetHost ".\HKB1" -repoRoot "EXEC DBA.deploy.SetSysConfiguration" -repoFolder "EXEC"

.LINK

http://tfs-server-04:8080/tfs/defaultcollection/DBA/DBA%20Team/_versionControl/changesets?itemPath=%24%2FDBA%2FPowerShell

#>
PARAM(
        [Parameter(Mandatory=$true)] [string] $targetDB = "InventoryDWH",
		[string] $targetHost = "",
        [string] $cmsGroup = "", 
		[string] $repoRoot = "",
        #[ValidateSet("Auto","EXEC","PowerShell","SSRS","Role","Schema")]
		[string] $repoFolder = "Auto", #Create, Auto, PowerShell, Command
    ##    [string] $repoType = 'GitHub', # GitHub, TFS ....
    ## rerun variables - not yet ready
    ##    [string] DeployID, 
    ##    [string] repoVersion, 
        [Parameter( Mandatory = $FALSE, HelpMessage = 'Supply a credential object to access Azure.')]
            [ValidateNotNull()]
            [System.Management.Automation.PSCredential]
            [System.Management.Automation.Credential()]
            $Credential = [System.Management.Automation.PSCredential]::Empty,
        [string] $targetInvServer = "DBA-SQLPRD-01\I01",  # should be optional and if not specified do not record failures
        [string] $targetInvDB = "InventoryDWH",           # should be optional and if not specified do not record failures
        [string] $fileFilter = '*.sql',
        [boolean] $configure = $false,                    # used during inital set up of instance
        [boolean] $notify = $True,                        # automated jobs should use this to alert team
        [boolean] $force = $False,                        # THIS SHOULD ONLY BE USED FOR DEPLOYING OUTSIDE INVENTORYDWH AND SANITY CHECKS
		[boolean] $dryRun = $True
	)

$ErrorActionPreference="Continue";	

$dotnetversion = [Environment]::Version            
IF(!($dotnetversion.Major -ge 4 -and $dotnetversion.Build -ge 30319)) 
{            
    write-error "You are not having Microsoft DotNet Framework 4.5 installed. Script exiting"            
    exit(1)            
}            

# Import dotnet libraries            
[Void][Reflection.Assembly]::LoadWithPartialName('System.IO.Compression.FileSystem')      

$project = (Split-Path -Parent $MyInvocation.MyCommand.Path)
# always use '-Force' to load the latest version of the module
Import-Module "$($project)\Modules\Host-Functions.psm1" -Force
Import-Module "$($project)\Modules\Instance-Functions.psm1" -Force
Import-Module "$($project)\Modules\Database-Functions.psm1" -Force
Import-Module "$($project)\Modules\File-Functions.psm1" -Force
Import-Module "$($project)\Modules\SSRS-Functions.psm1" -Force
Import-Module "$($project)\Modules\Inventory-Functions.psm1" -Force

function merge-deployInfo ( [Object[]] $f_DeployInfo, [string] $f_finalMessage ){
    $execMerge="EXEC info.DeployHistoryMerge 
        @DeployID = $(if($f_DeployInfo.DeployID -eq $null){ 'null' }ELSE{$f_DeployInfo.DeployID}),
        @TargetDB ='$($f_DeployInfo.TargetDB)', 
        --@TargetHost ='$($f_DeployInfo.TargetHost)',
        @ServerCount = $($f_DeployInfo.ServerCount),
        @DeployTarget ='$(if($f_DeployInfo.TargetHost -eq ''){ $f_DeployInfo.CMSGroup.ToUpper() }ELSE{ $f_DeployInfo.TargetHost })', 
        @RepoRoot ='$($f_DeployInfo.RepoRoot -replace("'","''"))', 
        @RepoFolder ='$($f_DeployInfo.RepoFolder)', 
        @RepoVersion = '$($f_DeployInfo.RepoMajor).$($f_DeployInfo.RepoMinor)', 
        @ScriptsPath ='$($f_DeployInfo.ScriptsPath)', 
        @TargetInvServer ='$($f_DeployInfo.TargetInvServer)',
        @TargetInvDB ='$($f_DeployInfo.TargetInvDB)', 
        @FileFilter = '$($f_DeployInfo.FileFilter)', 
        @DryRun = '$($f_DeployInfo.DryRun)', 
        @Configure = '$($f_DeployInfo.Configure)',
        @Force = '$($f_DeployInfo.Force)',
        @Comments = $(IF($f_finalMessage -eq ''){ "'*** STARTED ***'" }ELSE{ $("'"+ $f_finalMessage +"'") }),
        @StartDateTime = '$($f_DeployInfo.StartDateTime)', 
        @EndDateTime = $(if($f_DeployInfo.DeployID -eq $null){ 'null' }ELSE{$("'"+ $f_DeployInfo.EndDateTime +"'")}), 
        @StartedBy ='$($env:USERNAME)'; "
    If($f_DeployInfo.DryRun) {
        Write-Host "[DryRun] - Not Performing MERGE
        $($execMerge)"
    }
    ELSE{
        TRY{
            Write-Verbose "
            $($execMerge)"
            Invoke-Sqlcmd -ServerInstance $f_DeployInfo.TargetInvServer -Database $f_DeployInfo.TargetInvDB -Query $execMerge -QueryTimeout 65535 -ErrorAction 'Stop' 
        }
        Catch{
            Write-Host "[ALERT] FAILED TO MERGE DEPLOY!!!!!" -ForegroundColor Red 
            $failedOBJ = [ordered]@{
                Host = $($f_DeployInfo.TargetInvServer)
                Function = "Merge-DeployInfo"
                Command = "Merge-DeployInfo `$DeployInfo $($f_DeployInfo.DryRun)"
                Message = 'NA'
            }

            IF( $f_DeployInfo.TargetDB -ne 'InventoryDWH' ){
                record-Failure $f_DeployInfo $failedOBJ 
            }
            
        }
    }

    $selectSQL = "
    IF EXISTS( SELECT DeployID AS ID FROM info.DeployHistory 
                WHERE TargetDB ='$($f_DeployInfo.TargetDB)' AND 
                        DeployTarget ='$(if($f_DeployInfo.TargetHost -eq ''){ $f_DeployInfo.CMSGroup.ToUpper() }ELSE{ $f_DeployInfo.TargetHost })' AND 
                        TargetInvServer ='$($f_DeployInfo.TargetInvServer)' AND
                        TargetInvDB ='$($f_DeployInfo.TargetInvDB)' AND 
                        DryRun = '$($f_DeployInfo.DryRun)' AND
                        StartDateTime = '$($f_DeployInfo.StartDateTime)' AND 
                        StartedBy = '$($env:USERNAME)' )
	    BEGIN
		    SELECT MAX(DeployID) AS ID FROM info.DeployHistory 
                WHERE TargetDB ='$($f_DeployInfo.TargetDB)' AND 
                        DeployTarget ='$(if($f_DeployInfo.TargetHost -eq ''){ $f_DeployInfo.CMSGroup.ToUpper() }ELSE{ $f_DeployInfo.TargetHost })' AND 
                        TargetInvServer ='$($f_DeployInfo.TargetInvServer)' AND
                        TargetInvDB ='$($f_DeployInfo.TargetInvDB)' AND 
                        DryRun = '$($f_DeployInfo.DryRun)' AND
                        StartDateTime = '$($f_DeployInfo.StartDateTime)' AND 
                        StartedBy = '$($env:USERNAME)'
	    END
    ELSE
	    BEGIN
            IF( 1 = $(if($f_DeployInfo.DryRun){1}ELSE{0}) )
                BEGIN
		            SELECT isNull(ident_current('info.DeployHistory') + ident_incr('info.DeployHistory'),1) AS ID
                END
	    END;"

    TRY{
        Write-verbose "
        $($selectSQL)"
        Invoke-Sqlcmd -ServerInstance $f_DeployInfo.TargetInvServer -Database $f_DeployInfo.TargetInvDB -Query $selectSQL -QueryTimeout 65535 -ErrorAction 'Stop' | select -exp ID
    }
    CATCH{
        Write-Host `t"[ALERT] FAILED TO GET DEPLOY ID !!!!" -ForegroundColor Red 
        Write-Host `t"error: $_"
        $ExceptionMessage = "[FAILED - QUERY] .\deployDB.ps1 -targetDB $($f_DeployInfo.TargetDB) -targetHost $($f_DeployInfo.TargetHost) -dryRun `$$($f_DeployInfo.DryRun) "
        [void]$ResultsTable.Rows.Add("3", $currentHost.ServerName, $DeployInfo.TargetDB, $ExceptionMessage)
        #$failedOBJ = [ordered]@{
        #    Host = $($f_DeployInfo.TargetInvServer)
        #    Function = "Merge-DeployInfo"
        #    Command = "Merge-DeployInfo Get HarvestID $DryRun"
        #    Message = 'NA'
        #}
        #record-Failure $f_DeployInfo $failedOBJ $dryRun
                                                    
        $failedOBJ = [ordered]@{
            Host = $($currentHost.ServerName)
            Function = "Merge-DeployInfo"
            Command = $ExceptionMessage.Substring($ExceptionMessage.IndexOf('] ')+2,$ExceptionMessage.length - $ExceptionMessage.IndexOf('] ')-2 )
            Message = $($_)
        }

        IF( $f_DeployInfo.TargetDB -ne 'InventoryDWH' ){
            record-Failure $DeployInfo $failedOBJ 
        }
    }
}

function record-Failure( [Object[]] $f_DeployInfo, [Object[]]$f_failedOBJ ){
    $insertSQL = "
    Insert into info.DeployFailures ([DeployID], [SQLServerName], [Function], [command], [ErrorMessage], [Daterun])
        VALUES
    ($(if($f_DeployInfo.DeployID -eq $null){ 'null' }ELSE{$f_DeployInfo.DeployID}),'$($f_failedOBJ.Host)','$($f_failedOBJ.Function)','$($f_failedOBJ.Command -replace("'","''"))','$($f_failedOBJ.Message -replace("'","''"))','$(Get-Date)'); "
  
    Write-Verbose $insertSQL
    IF( $f_DeployInfo.DryRun ){
         Write-Host "[ALERT] Processing Failure Occurred"  -ForegroundColor Red
    }
    ELSE{
        #Try Catch?
        Invoke-Sqlcmd -ServerInstance $($f_DeployInfo.TargetInvServer) -Database $($f_DeployInfo.TargetInvDB) -Query $insertSQL -QueryTimeout 65535 -ErrorAction 'Stop' 
    }
    
}

function update-DBinfo ( [Object[]] $f_DeployInfo, [Object[]] $f_currentHost ){
    $execSQL = "EXEC DBA.info.SetDatabaseConfig 
        @dbname = '$(if($f_DeployInfo.RepoFolder -like 'AUTO' -or 
                        $f_DeployInfo.RepoFolder -like 'StoreProcedure' 
                        ){$f_DeployInfo.TargetDB} ELSE {$f_DeployInfo.RepoFolder})',
        @key = 'version',
        @val = '$($f_DeployInfo.RepoMajor)',
        @dryRun = $(if($DeployInfo.DryRun){1}ELSE{0});
    EXEC DBA.info.SetDatabaseConfig 
        @dbname = '$(if($f_DeployInfo.RepoFolder -like 'AUTO' -or 
                        $f_DeployInfo.RepoFolder -like 'StoreProcedure' 
                        ){$f_DeployInfo.TargetDB} ELSE {$f_DeployInfo.RepoFolder})',
        @key = 'changeSet',
        @val = '$($f_DeployInfo.RepoMinor)',
        @dryRun = $(if($DeployInfo.DryRun){1}ELSE{0})"

    if( $($f_DeployInfo.DryRun) ){
        Write-Host "
        $execSQL
        "
    }
    Else{
        Try{
            Write-Verbose $execSQL
            Try{
                Invoke-Sqlcmd -ServerInstance $($f_currentHost.ServerName) -Database $($f_DeployInfo.TargetDB) -Query $execSQL -QueryTimeout 65535 -ErrorAction 'Stop'
            }
            Catch{
                Try{
                    Invoke-Sqlcmd -ServerInstance $($f_currentHost.ServerName +'.'+ $f_currentHost.DomainName) -Database $($f_DeployInfo.TargetDB) -Query $execSQL -QueryTimeout 65535 -ErrorAction 'Stop'
                }
                Catch{
                    Invoke-Sqlcmd -ServerInstance $($f_currentHost.ServerName +'.'+ $f_currentHost.DomainName) -Database $($f_DeployInfo.TargetDB) -username $($f_DeployInfo.Credential.username) -password $($f_DeployInfo.Credential.GetNetworkCredential().password) -Query $execSQL -QueryTimeout 65535 -ErrorAction 'Stop'
                }
            }
        }
        catch{
            Write-Host `t`t"[ALERT] FAILED TO UPDATE DBCONFIG $($f_currentHost.ServerName) - logging Failure"
            Write-Host `t"error: $_"
            $ExceptionMessage = "[FAILED - UpdateDBCONFIG] .\deployDB.ps1 -targetDB $($f_DeployInfo.TargetDB) -targetHost $($f_currentHost.ServerName +'.'+ $f_currentHost.DomainName) -dryRun `$$($f_DeployInfo.DryRun) "
            [void]$ResultsTable.Rows.Add("3", $($f_currentHost.ServerName), $($f_DeployInfo.TargetDB), $ExceptionMessage)
                #$failedOBJ = [ordered]@{
                #    Host = $($f_DeployInfo.TargetInvServer)
                #    Function = "update-DBinfo"
                #    Command = "update-DBinfo `$DeployInfo $($f_DeployInfo.DryRun)"
                #    Message = 'NA'
                #}
            #record-Failure $f_DeployInfo $failedOBJ $f_DeployInfo.DryRun
                                                        
            $failedOBJ = [ordered]@{
                Host = $($currentHost.ServerName)
                Function = "UPDATE-DBinfo"
                Command = $ExceptionMessage.Substring($ExceptionMessage.IndexOf('] ')+2,$ExceptionMessage.length - $ExceptionMessage.IndexOf('] ')-2 )
                Message = $($_)
            }

            IF( $f_DeployInfo.TargetDB -ne 'InventoryDWH' ){
                record-Failure $DeployInfo $failedOBJ 
            }
        }
    }
}

function get-LocalVersion ( [String] $localpath ){
    Write-Verbose "Retrieve local repo version"
    $tfexepath = "C:\Program Files (x86)\Microsoft Visual Studio\2019\Professional\Common7\IDE\CommonExtensions\Microsoft\TeamFoundation\Team Explorer\tf.exe"
    If( Test-Path $tfexepath ){
         Write-Verbose "Found in default location"
    }
    else{
        Write-Verbose "Searching for TF.EXE location"
        $tfexeSearch = @(Invoke-Expression "where.exe /R c:\ tf.exe")
        $tfexepath = $tfexeSearch[0]
      
    }
    #$localpath = "C:\Users\hbrotherton\source\Workspaces\DBA\DBA"
    Write-Verbose $tfexepath
    Write-Verbose $localpath


    $result = & $tfexepath history $localpath /noprompt /stopafter:1 /version:W 
    "$result" -match "\d+" | out-null
    $major = $matches[0]

    # I am uncertain about this next section of code - it looks to return the local change history.
    $result2 = & $tfexepath history $localpath /r /noprompt /stopafter:1 /version:$id~W        
    "$result2" -match "\d+" | out-null
    $minor =  $matches[0]

    $VersionInfo = [ordered]@{
        RepoRoot = $localpath
        Branch = "TFS"
        Major = $major
	    Minor = $minor
        }
    #return
    #$id
    $VersionInfo

}

function setup-NewInstance ( [string] $f_targetHost, [Object[]] $f_DeployInfo ){

    $setupCommands = @(
                        "EXEC DBA.deploy.SetInstanceConfig @ForceReset = $(if($f_DeployInfo.Force){1}ELSE{0})"
                        "EXEC DBA.deploy.SetDBMail @notify = $(if($f_DeployInfo.Notify){1}ELSE{0})"
                        "EXEC DBA.deploy.SetAgentConfig"
                        "EXEC DBA.deploy.SetSQLAuthLogin " # @ForceReset = $(if($f_DeployInfo.Force){1}ELSE{0})",
                        "EXEC [DBA].[deploy].[SetServerLogin] @TargetLogin = 'ELDREDGE_A\SQL Server Maint Group'"
                        #EXEC DBA.deploy.EnableAgentJobs
                        "EXEC [DBA].[deploy].[SetTraceFlag]"
                        # Alter Startup 
                        #Set-SQLStartupParameter $f_targetHost
                        )

    ForEach( $execCMD in $setupCommands){
        $execCMD = $execCMD + $(if($execCMD.contains("@")){", "}ELSE{""}) + " @dryRun=$(if($f_DeployInfo.DryRun){1}ELSE{0})" 
        
            #if( !$($f_DeployInfo.DryRun) ) { Write-Host " }
            TRY{
                Write-Verbose "Invoke-Sqlcmd -ServerInstance $f_targetHost -Database $($f_DeployInfo.TargetDB) -Query '$execCMD' -ErrorAction 'Stop' "
	            Invoke-Sqlcmd -ServerInstance $f_targetHost -Database $($f_DeployInfo.TargetDB) -Query $execCMD -ErrorAction 'Stop'
            }
            Catch{
                TRY{
                    Write-Verbose "Invoke-Sqlcmd -ServerInstance $($f_TargetHost.ServerName + $f_TargetHost.DomainName) -Database $($f_DeployInfo.TargetDB) -SQLAUTH -Query '$execCMD' -ErrorAction 'Stop' "
	                Invoke-Sqlcmd -ServerInstance $($f_TargetHost.ServerName + $f_TargetHost.DomainName) -Database $($f_DeployInfo.TargetDB) -username $($f_DeployInfo.Credential.username) -password $($f_DeployInfo.Credential.GetNetworkCredential().password) -Query $execCMD -ErrorAction 'Stop'
                }
                Catch{
                    WRITE-HOST `t"[ALERT] !!! Failed to setup Instance !!! "
                    Write-Verbose `t`t"$($execCMD)"
                    $ExceptionMessage = "[FAILED - Setup-NewInstance] Set-SQLStartupParameters $($execCMD)"
                    [void]$ResultsTable.Rows.Add("3", $($f_currentHost.ServerName), $($f_DeployInfo.TargetDB), $ExceptionMessage)

                    $failedOBJ = [ordered]@{
                        Host = $($currentHost.ServerName)
                        Function = "Setup-NewInstance"
                        Command = $ExceptionMessage.Substring($ExceptionMessage.IndexOf('] ')+2,$ExceptionMessage.length - $ExceptionMessage.IndexOf('] ')-2 )
                        Message = $($_)
                    }

                    IF( $f_DeployInfo.TargetDB -ne 'InventoryDWH' ){
                        record-Failure $DeployInfo $failedOBJ 
                    }
                }
            }   
    } # ForEach( $execCMD in $setupCommands)
   
    Try{
        Write-Verbose "Set-SQLStartupParameters $($f_targetHost)"
        $returnCode = Set-SQLStartupParameters $f_targetHost

        IF( $returnCode -ne 1){
            $ExceptionMessage = "[FAILED - Set-SQLStartupParameters] Set-SQLStartupParameters $($f_targetHost)"
            [void]$ResultsTable.Rows.Add("3", $($f_currentHost.ServerName), $($f_DeployInfo.TargetDB), $ExceptionMessage)
                                                        
            $failedOBJ = [ordered]@{
                Host = $($currentHost.ServerName)
                Function = "SET-SQLStartupParameters"
                Command = $ExceptionMessage.Substring($ExceptionMessage.IndexOf('] ')+2,$ExceptionMessage.length - $ExceptionMessage.IndexOf('] ')-2 )
                Message = $($_)
            }

            IF( $f_DeployInfo.TargetDB -ne 'InventoryDWH' ){
                record-Failure $DeployInfo $failedOBJ 
            }
        }
    }
    Catch{
        WRITE-HOST `t"[ALERT] !!! Failed to setup Instance !!! "
        Write-Verbose "Set-SQLStartupParameters $($f_targetHost)"

        $ExceptionMessage = "[FAILED - Set-SQLStartupParameters] Set-SQLStartupParameters $($f_targetHost)"
        [void]$ResultsTable.Rows.Add("3", $($f_currentHost.ServerName), $($f_DeployInfo.TargetDB), $ExceptionMessage)
                                                    
        $failedOBJ = [ordered]@{
            Host = $($currentHost.ServerName)
            Function = "EXEC-CMD"
            Command = $ExceptionMessage.Substring($ExceptionMessage.IndexOf('] ')+2,$ExceptionMessage.length - $ExceptionMessage.IndexOf('] ')-2 )
            Message = $($_)
        }

        IF( $f_DeployInfo.TargetDB -ne 'InventoryDWH' ){
            record-Failure $DeployInfo $failedOBJ 
        }
    } 
    
    ### Record new instance into inventory. (SQLInstances)
    IF( $f_DeployInfo.ServerCount -eq 1 ){
        $execSQL = "EXEC DBA.info.GetInstance"
        Write-Verbose $execSQL

        TRY{
            Write-Verbose "Invoke-Sqlcmd -ServerInstance $($f_targetHost) -Database $($f_DeployInfo.TargetDB) -Query '$execSQL' -ErrorAction 'Stop' "
	        $NewInstanceInfo = Invoke-Sqlcmd -ServerInstance $f_targetHost -Database $($f_DeployInfo.TargetDB) -Query $execSQL -ErrorAction 'Stop'
        }
        Catch{
            Write-HOST `t"[ALERT] !!! Failed to QUERY Instance !!! "
            Write-Verbose `t`t"$($execSQL)"
        }

        #  Call Merge - should it be converted to Inventory Module
        $InstanceID = merge-InstInfo $($NewInstanceInfo) $($f_DeployInfo)
        #WRITE-VERBOSE $mergeSQL # -ServerInstance $($f_DeployInfo.TargetInvServer) -Database $($f_DeployInfo.TargetInvDB)

        ## Call CMS Refresh
        $execSQL = "EXEC [Info].[SetCMSInstances] @dryRun=$(if($f_DeployInfo.DryRun){1}ELSE{0})"
        Write-Verbose $execSQL
        TRY{
            Write-Verbose "Invoke-Sqlcmd -ServerInstance $($f_DeployInfo.TargetInvServer) -Database $($f_DeployInfo.TargetInvDB) -Query '$execSQL' -ErrorAction 'Stop' "
	        $NewInstanceInfo = Invoke-Sqlcmd -ServerInstance $($f_DeployInfo.TargetInvServer) -Database $($f_DeployInfo.TargetInvDB) -Query $execSQL -ErrorAction 'Stop'
        }
        Catch{
            Write-HOST `t"[ALERT] !!! Failed to REFRESH CMS Instances !!! "
            Write-Verbose `t`t"$($execSQL)"
        }

    }
    
  
}

function process-folder ( [string] $f_sqlSourcePath, [Object[]] $f_currentHost, [Object[]] $f_DeployInfo ){
    $total = 0
    If( $f_sqlSourcePath -like '*SSRS' ){
        $FileFilter = "*.rdl"
    }
    else{
        $FileFilter = $f_DeployInfo.FileFilter
    }
    
    IF(test-path -path $f_sqlSourcePath) {
        get-childitem -path $f_sqlSourcePath -filter $FileFilter | % {
            $file = $_
            $total ++
        }
    }

    IF( $total -eq 0 -AND ( $f_DeployInfo.DryRun -eq "False" ) ){
        Write-Host " ] Source Location: $f_sqlSourcePath"
        Write-Host `t"Files to process: $total"
        $WarningMessage = "[WARNING] Nothing to Process in: $f_sqlSourcePath "
        [void]$ResultsTable.Rows.Add("2", $f_currentHost.ServerName, $f_DeployInfo.TargetDB, $WarningMessage)
    }
    ELSE{
        IF( $total -ne 0 ){
            Write-Host " ] Source Location: $f_sqlSourcePath"
            Write-Host `t"Files to process: $total"
        }

        $attemptCounter = 0
        $scriptFailure = 0
        $process = "Started"

        WHILE( $process -ne "Succesful" -AND $attemptCounter -lt $total ){
            $process = "Started"
            IF( ($scriptFailure -eq 1) -or ($scriptFailure -eq $total) ){
                Write-Verbose "[ALERT] LAST CHANCE "
                $attemptCounter = $total-1
            }
            ElseIF( ($scriptFailure -lt $attemptCounter) -and (($attemptCounter + $scriptFailure) -lt $total) ){
                Write-Verbose `t"[ALERT] Failures: $($scriptFailure) - Reducing Run attempts From $($total) TO $($scriptFailure) "
                $attemptCounter = $total - $scriptFailure
                $scriptFailure = 0
            }
            ELSE{
                $scriptFailure = 0
            }

            get-childitem -path $f_sqlSourcePath -filter $FileFilter | % {
                $file = $_
	            $currentFile = $file.name
                
                IF( !$($f_DeployInfo.DryRun) ){
                    TRY{
                        $sqlFile =  $f_sqlSourcePath +"\"+ $currentFile
                        $ExceptionMessage = "[FAILED - SQL] Invoke-Sqlcmd -ServerInstance $($f_currentHost.ServerName +'.'+ $f_currentHost.DomainName) -Database $($f_DeployInfo.TargetDB)  -ErrorAction Stop -InputFile $f_sqlSourcePath\$currentFile -verbose"
                       
                        IF( ($f_targetDB -eq "InventoryDWH") -AND ($f_sqlSourcePath -like '*AgentJob') ){ # Add variables to agent jobs
                            $sqlOptions = "invServer=$f_currentHost.ServerName", "invDB=$f_DeployInfo.TargetDB"
                            Write-Verbose "Invoke-Sqlcmd -ServerInstance $($f_currentHost.ServerName) -Database $($f_DeployInfo.TargetDB)  -ErrorAction Stop -InputFile $sqlFile -Variable $sqlOptions "
	                        Invoke-Sqlcmd -ServerInstance $f_currentHost.ServerName -Database $f_DeployInfo.TargetDB  -ErrorAction Stop -InputFile $sqlFile -Variable $sqlOptions
                        }
                        elseIF( $f_sqlSourcePath -like '*SSRS' ){ # Add variables to deploy SSRS objects
                            #$sqlOptions = "invServer=$f_targetHost", "invDB=$f_targetDB"
                            IF( $currentFile -like '*.rdl'){
                                $ssrsReportFolder = "DBA/$($f_DeployInfo.TargetDB)"
                            }
                            elseIF( $currentFile -like '*.rds'){
                                $ssrsReportFolder = "DBA/$($f_DeployInfo.TargetDB)/DataSources"
                            }

                            Write-Verbose "Install-SSRSRDL -webServiceUrl '$($f_DeployInfo.TargetSSRSurl)' -rdlFile '$sqlFile' -reportFolder '$ssrsReportFolder' -force"
	                        #Install-SSRSRDL -webServiceUrl '$($f_DeployInfo.TargetSSRSurl)' -rdlFile '$sqlFile' -reportFolder '$ssrsReportFolder' -force
                        }
                        elseIF( $f_sqlSourcePath -like '*INIT' ){ # Add variables to deploy INIT objects
                            IF( $f_DeployInfo.cmsGroup -eq 'PROD' -or $f_DeployInfo.cmsGroup -eq 'ADMIN' -or $f_DeployInfo.cmsGroup -eq 'allPROD'){
                                $sqlOptions = "targetEnv=PROD"
                            }
                            else{
                                $sqlOptions = "targetEnv=$($f_currentHost.ServerEnvironment)"
                            }
                            
                             TRY{
                                Write-Verbose "Invoke-Sqlcmd -ServerInstance $($f_currentHost.ServerName)  -Database $($f_DeployInfo.TargetDB) -ErrorAction Stop -InputFile $sqlFile -Variable $sqlOptions "
	                            Invoke-Sqlcmd -ServerInstance $($f_currentHost.ServerName) -Database $f_DeployInfo.TargetDB -ErrorAction Stop -InputFile $sqlFile -Variable $sqlOptions
                            }
                            Catch{
                                TRY{
                                    Write-Verbose "Invoke-Sqlcmd -ServerInstance $($f_currentHost.ServerName +'.'+ $f_currentHost.DomainName) -Database $($f_DeployInfo.TargetDB) -ErrorAction Stop -InputFile $sqlFile -Variable $sqlOptions "
	                                Invoke-Sqlcmd -ServerInstance $($f_currentHost.ServerName +'.'+ $f_currentHost.DomainName) -Database $f_DeployInfo.TargetDB -ErrorAction Stop -InputFile $sqlFile -Variable $sqlOptions
                                }
                                Catch{
                                    Write-Verbose "Invoke-Sqlcmd -ServerInstance $($f_currentHost.ServerName +'.'+ $f_currentHost.DomainName) -Database $($f_DeployInfo.TargetDB) -SQLAUTH -ErrorAction Stop -InputFile $sqlFile -Variable $sqlOptions "
	                                Invoke-Sqlcmd -ServerInstance $($f_currentHost.ServerName +'.'+ $f_currentHost.DomainName) -Database $f_DeployInfo.TargetDB -username $($f_DeployInfo.Credential.username) -password $($f_DeployInfo.Credential.GetNetworkCredential().password) -ErrorAction Stop -InputFile $sqlFile -Variable $sqlOptions
                                }
                            }

                        }
                        else{
                            TRY{
                                Write-Verbose "Invoke-Sqlcmd -ServerInstance $($f_currentHost.ServerName) -Database $($f_DeployInfo.TargetDB) -DisableVariables -ErrorAction Stop -InputFile $sqlFile "
	                            Invoke-Sqlcmd -ServerInstance $($f_currentHost.ServerName) -Database $f_DeployInfo.TargetDB -DisableVariables -ErrorAction Stop -InputFile $sqlFile
                            }
                            Catch{
                                TRY{
                                    Write-Verbose "Invoke-Sqlcmd -ServerInstance $($f_currentHost.ServerName +'.'+ $f_currentHost.DomainName) -Database $($f_DeployInfo.TargetDB) -DisableVariables -ErrorAction Stop -InputFile $sqlFile "
	                                Invoke-Sqlcmd -ServerInstance $($f_currentHost.ServerName +'.'+ $f_currentHost.DomainName) -Database $f_DeployInfo.TargetDB -DisableVariables -ErrorAction Stop -InputFile $sqlFile
                                }
                                Catch{
                                    Write-Verbose "Invoke-Sqlcmd -ServerInstance $($f_currentHost.ServerName +'.'+ $f_currentHost.DomainName) -Database $($f_DeployInfo.TargetDB) -SQLAUTH -DisableVariables -ErrorAction Stop -InputFile '$sqlFile' "
	                                Invoke-Sqlcmd -ServerInstance $($f_currentHost.ServerName +'.'+ $f_currentHost.DomainName) -Database $($f_DeployInfo.TargetDB) -username $($f_DeployInfo.Credential.username) -password $($f_DeployInfo.Credential.GetNetworkCredential().password) -DisableVariables -ErrorAction 'Stop' -InputFile $sqlFile
                                }
                            }
                            
                        }

                        ## CHECK FOR PREVIOUS ERROR AND REMOVE IT FROM TABLE!
                        if( ($ResultsTable.Rows.Count -gt 0) -and ($attemptCounter -gt 0) ){ 
                            if($ResultsTable.FinalResults.Contains("$ExceptionMessage")){
                                #[void]$ResultsTable.Rows.Remove("3", $f_targetHost, $f_targetDB, $ExceptionMessage)
                                ($ResultsTable.Rows | Where-Object {($_.FinalResults -eq "$ExceptionMessage")}).Delete()
                                Write-Verbose "Removing Previous Failure  $($currentFile)"
                            }
                        }

                        IF($process -ne "FAILED"){ $Process = "Succesful" }
                    }
                    CATCH{
                        ## Check to see if already recorded
                        if( ($ResultsTable.Rows.Count -gt 0) -and ($attemptCounter -gt 0) ){
                            if($ResultsTable.FinalResults.Contains("$ExceptionMessage")){ # this could be a problem...if two servers throw the same error.
                                Write-Verbose `t"DO NOT RECORD AGAIN  $($currentFile)"
                            }
                            else{
                                [void]$ResultsTable.Rows.Add("3", $($f_currentHost.ServerName), $($f_DeployInfo.TargetDB), $ExceptionMessage)
                            }
                        }
                        else{
                            [void]$ResultsTable.Rows.Add("3", $($f_currentHost.ServerName), $($f_DeployInfo.TargetDB), $ExceptionMessage)
                        }

                        $scriptFailure = $scriptFailure + 1
                        #$displayCounter = $attemptCounter + 1
                        $process = "FAILED"
                    }
                }
                ELSE{
                    Write-Verbose `t"File: $currentFile"
                    WRITE-VERBOSE "Invoke-Sqlcmd -ServerInstance $($f_currentHost.ServerName) -Database $($f_DeployInfo.TargetDB)  -ErrorAction Stop -InputFile $f_sqlSourcePath\$currentFile "
                    IF($process -ne "FAILED"){ $Process = "Succesful" }
                }
            } #end get-childItem
            $attemptCounter ++
        } #end WHILE

        If( $process -eq "FAILED" ){
            Write-Verbose "[ALERT] Failure $scriptFailure Total $total"
            IF( ($attemptCounter -eq $total) -AND $verbose) { $error }
                    
            #[void]$ResultsTable.Rows.Add("3", $ExceptionMessage)
            $ExceptionMessage = "[FAILED - $($f_sqlSourcePath|split-path -leaf)] .\deployDB.ps1 -targetHost $($f_currentHost.ServerName) -targetDB $($f_DeployInfo.TargetDB) -repoFolder $($f_sqlSourcePath|split-path -leaf) -dryRun $($f_DeployInfo.DryRun) -force"
            [void]$ResultsTable.Rows.Add("3", $($f_currentHost.ServerName), $($f_DeployInfo.TargetDB), $ExceptionMessage)

            $failedOBJ = [ordered]@{
                Host = $($currentHost.ServerName)
                Function = "Process-$($f_sqlSourcePath|split-path -leaf)"
                Command = $ExceptionMessage.Substring($ExceptionMessage.IndexOf('] ')+2,$ExceptionMessage.length - $ExceptionMessage.IndexOf('] ')-2 )
                Message = $($_)
            }

            IF( $f_DeployInfo.TargetDB -ne 'InventoryDWH' ){
                record-Failure $DeployInfo $failedOBJ 
            }
        }
        ELSEIF( $f_dryRun -eq 0 -AND $total -ne 0){
            Write-Verbose "[OK] Process was Successful "
            $SuccessfulMessage = "[Success] Processed: $f_sqlSourcePath"
            [void]$ResultsTable.Rows.Add("1", $($f_currentHost.ServerName), $($f_DeployInfo.TargetDB), $SuccessfulMessage)
        }
        $total = 0

        ## CALL  setup-NewInstance
    } #end ELSE
}

function process-actions ( [string] $f_sqlSourcePath, [Object[]] $f_currentHost, [Object[]] $f_DeployInfo ){
    $total = 0
    <# Grab table contents #>
    $selectSQL = "SELECT UID, Name, Implementation, SanityCheck, Backout, Description, Parameters, IsEnabled, DataSource FROM [AdminSupportTool].[deploy].[ScriptConfig];"

    Write-Host `t"$($selectSQL)"
    Write-Verbose `t"invoke-sqlcmd -ServerInstance $($f_currentHost.ServerName) -Database $($f_DeployInfo.TargetDB) -Query $selectSQL "
    $ActionList = @( invoke-sqlcmd -ServerInstance $($f_currentHost.ServerName) -Database $($f_DeployInfo.TargetDB) -Query $selectSQL ) 
    
    #IF(test-path -path $f_sqlSourcePath) {
    #    get-childitem -recurse -path $f_sqlSourcePath -filter $f_DeployInfo.FileFilter | % {
    #        $file = $_
    #        $total ++
    #    }
    #}

    IF( ($ActionList.Count -eq 0) -AND ($f_DeployInfo.DryRun -eq "False") ){
        Write-Host " ] Source Location: $f_sqlSourcePath"
        Write-Host `t"Files to process: $($ActionList.Count)"
        $WarningMessage = "[WARNING] Nothing to Process in: $f_sqlSourcePath "
        [void]$ResultsTable.Rows.Add("2", $f_currentHost.ServerName, $f_DeployInfo.TargetDB, $WarningMessage)
    }
    #ELSE( $ScriptList.Count -ne $total ){
    #    Write-Host " ] Source Location: $f_sqlSourcePath"
    #    Write-Host `t"Files to process: $($ScriptList.Count)"
    #    $WarningMessage = "[WARNING] File count does not match config "
    #    [void]$ResultsTable.Rows.Add("2", $f_currentHost.ServerName, $f_DeployInfo.TargetDB, $WarningMessage)
    #}
    ELSE{
        IF( $ActionList.Count -ne 0 ){
            Write-Host " ] Source Location: $f_sqlSourcePath"
            Write-Host `t"Files to process: $($ActionList.Count)"
        }

        $attemptCounter = 0
        $scriptFailure = 0
        $process = "Started"
        
        WHILE( $process -ne "Succesful" -AND $attemptCounter -lt $ActionList.Count ){
            $process = "Started"
            IF( ($scriptFailure -eq 1) -or ($scriptFailure -eq $ActionList.Count) ){
                Write-Verbose "[ALERT] LAST CHANCE "
                $attemptCounter = $ActionList.Count+1
            }
            ElseIF( ($scriptFailure -lt $attemptCounter) -and (($attemptCounter + $scriptFailure) -lt $ActionList.Count) ){
                Write-Verbose `t"[ALERT] Failures: $($scriptFailure) - Reducing Run attempts From $($ActionList.Count) TO $($scriptFailure) "
                $attemptCounter = $ActionList.Count - $scriptFailure
                $scriptFailure = 0
            }
            ELSE{
                $scriptFailure = 0
            }
            
            #get-childitem -recurse -path $f_sqlSourcePath -filter $FileFilter | % {
            ForEach($action in $ActionList){
                $SystemName = $($action.Implementation).substring(0,$($action.Implementation).IndexOf('.'))
                $mergeSQL = "EXEC AdminSupportTool.deploy.ScriptMerge
                @UID = $($action.UID),
                @System = '$( $($action.Implementation).substring(0,$($action.Implementation).IndexOf('.')) )',
                --@Name =   '$( $($action.Implementation).substring($SystemName.Length + 1, $($action.Implementation).IndexOf('.Implementation') - $SystemName.Length -1) )',
                @Name = '$($action.Name)',
                @Description = '$($action.Description)',
                @Implementation = '$($action.Implementation)',
                @SanityCheck = '$($action.SanityCheck)',
                @Backout = '$($action.Backout)',
                @Parameters = '$($action.Parameters)',
                @IsEnabled = $($action.IsEnabled),
                @DataSource = '$($action.DataSource)',
                @UPDATE_USER ='$($env:USERNAME)';"
                
                IF( !$($f_DeployInfo.DryRun) ){
                    TRY{
                        <# touch file and get contenxt #>
                        $sqlFile = $f_sqlSourcePath +"\"+ $($action.Implementation)
                        Write-Verbose "Test-Path -Path $($sqlFile) -PathType Leaf"
                        IF( (Test-Path -Path $($sqlFile) -PathType Leaf) ){
                            $ActionsScript = $(Get-Content -Path $($sqlFile) ) -replace "'","''"
                            #$mergeSQL = $mergeSQL.replace($($action.Implementation), 'Found' )
                            $mergeSQL = $mergeSQL.replace($($action.Implementation), $ActionsScript )
                        }
                        ELSE{
                            Write-Verbose '[ALERT] No Implementaion file Found'
                        }
    
                        $sqlFile =  $f_sqlSourcePath +"\"+ $($action.SanityCheck)
                        Write-Verbose "Test-Path -Path $($sqlFile) -PathType Leaf"
                        IF(Test-Path -Path $($sqlFile) -PathType Leaf){
                            $ActionsScript = $(Get-Content -Path $($sqlFile) ) -replace "'","''"
                            $mergeSQL = $mergeSQL.replace($($action.SanityCheck), $ActionsScript )
                        }
                        ELSE{
                            Write-Verbose '[ALERT] No Sanity file Found'
                        }

                        $sqlFile =  $f_sqlSourcePath +"\"+ $($action.Backout)
                        Write-Verbose "Test-Path -Path $($sqlFile) -PathType Leaf"
                        IF(Test-Path -Path $($sqlFile) -PathType Leaf){
                            $ActionsScript = $(Get-Content -Path $($sqlFile) ) -replace "'","''"
                            $mergeSQL = $mergeSQL.replace($($action.Backup), $ActionsScript )
                        }
                        ELSE{
                            Write-Verbose '[WARNING] No Backout file Found'
                        }                        

                        $ExceptionMessage = "[FAILED - MERGE ACTIONS] Invoke-Sqlcmd -ServerInstance $($f_currentHost.ServerName +'.'+ $f_currentHost.DomainName) -Database $($f_DeployInfo.TargetDB)  -ErrorAction Stop  -Query $mergeSQL -verbose"
                           
                        TRY{
                            Write-Verbose "Invoke-Sqlcmd -ServerInstance $($f_currentHost.ServerName)  -Database $($f_DeployInfo.TargetDB) -ErrorAction Stop -Query $mergeSQL "
	                        Invoke-Sqlcmd -ServerInstance $($f_currentHost.ServerName) -Database $f_DeployInfo.TargetDB -ErrorAction Stop -Query $mergeSQL
                        }
                        Catch{
                            TRY{
                                Write-Verbose "Invoke-Sqlcmd -ServerInstance $($f_currentHost.ServerName +'.'+ $f_currentHost.DomainName) -Database $($f_DeployInfo.TargetDB) -ErrorAction Stop -Query $mergeSQL "
	                            Invoke-Sqlcmd -ServerInstance $($f_currentHost.ServerName +'.'+ $f_currentHost.DomainName) -Database $f_DeployInfo.TargetDB -ErrorAction Stop -Query $mergeSQL
                            }
                            Catch{
                                Write-Verbose "Invoke-Sqlcmd -ServerInstance $($f_currentHost.ServerName +'.'+ $f_currentHost.DomainName) -Database $($f_DeployInfo.TargetDB) -SQLAUTH -ErrorAction Stop -Query $mergeSQL "
	                            Invoke-Sqlcmd -ServerInstance $($f_currentHost.ServerName +'.'+ $f_currentHost.DomainName) -Database $f_DeployInfo.TargetDB -username $($f_DeployInfo.Credential.username) -password $($f_DeployInfo.Credential.GetNetworkCredential().password) -ErrorAction Stop -Query $mergeSQL
                            }
                        }


                        ## CHECK FOR PREVIOUS ERROR AND REMOVE IT FROM TABLE!
                        if( ($ResultsTable.Rows.Count -gt 0) -and ($attemptCounter -gt 0) ){ 
                            if($ResultsTable.FinalResults.Contains("$ExceptionMessage")){
                                #[void]$ResultsTable.Rows.Remove("3", $f_targetHost, $f_targetDB, $ExceptionMessage)
                                ($ResultsTable.Rows | Where-Object {($_.FinalResults -eq "$ExceptionMessage")}).Delete()
                                Write-Verbose "Removing Previous Failure  $($currentFile)"
                            }
                        }

                        IF($process -ne "FAILED"){ $Process = "Succesful" }
                    }
                    CATCH{
                        ## Check to see if already recorded
                        if( ($ResultsTable.Rows.Count -gt 0) -and ($attemptCounter -gt 0) ){
                            if($ResultsTable.FinalResults.Contains("$ExceptionMessage")){ # this could be a problem...if two servers throw the same error.
                                Write-Verbose `t"DO NOT RECORD AGAIN  $($currentFile)"
                            }
                            else{
                                [void]$ResultsTable.Rows.Add("3", $($f_currentHost.ServerName), $($f_DeployInfo.TargetDB), $ExceptionMessage)
                            }
                        }
                        else{
                            [void]$ResultsTable.Rows.Add("3", $($f_currentHost.ServerName), $($f_DeployInfo.TargetDB), $ExceptionMessage)
                        }

                        $scriptFailure = $scriptFailure + 1
                        #$displayCounter = $attemptCounter + 1
                        $process = "FAILED"
                    }
                }
                ELSE{
                    Write-Verbose `t" $($mergeSQL) "
                    WRITE-VERBOSE "Invoke-Sqlcmd -ServerInstance $($f_currentHost.ServerName) -Database $($f_DeployInfo.TargetDB)  -ErrorAction Stop -InputFile $f_sqlSourcePath\$currentFile "
                    IF($process -ne "FAILED"){ $Process = "Succesful" }
                }
            } # ForEach($action in $ActionList)
            $attemptCounter ++
        } #end WHILE

        If( $process -eq "FAILED" ){
            Write-Verbose "[ALERT] Failure $scriptFailure Total $total"
            IF( ($attemptCounter -eq $total) -AND $verbose) { $error }
                    
            #[void]$ResultsTable.Rows.Add("3", $ExceptionMessage)
            $ExceptionMessage = "[FAILED - $($f_sqlSourcePath|split-path -leaf)] .\deployDB.ps1 -targetHost $($f_currentHost.ServerName) -targetDB $($f_DeployInfo.TargetDB) -repoFolder $($f_sqlSourcePath|split-path -leaf) -dryRun $($f_DeployInfo.DryRun) -force"
            [void]$ResultsTable.Rows.Add("3", $($f_currentHost.ServerName), $($f_DeployInfo.TargetDB), $ExceptionMessage)

            $failedOBJ = [ordered]@{
                Host = $($currentHost.ServerName)
                Function = "Process-$($f_sqlSourcePath|split-path -leaf)"
                Command = $ExceptionMessage.Substring($ExceptionMessage.IndexOf('] ')+2,$ExceptionMessage.length - $ExceptionMessage.IndexOf('] ')-2 )
                Message = $($_)
            }

            IF( $f_DeployInfo.TargetDB -ne 'InventoryDWH' ){
                record-Failure $DeployInfo $failedOBJ 
            }
        }
        ELSEIF( $f_dryRun -eq 0 -AND $total -ne 0){
            Write-Verbose "[OK] Process was Successful "
            $SuccessfulMessage = "[Success] Processed: $f_sqlSourcePath"
            [void]$ResultsTable.Rows.Add("1", $($f_currentHost.ServerName), $($f_DeployInfo.TargetDB), $SuccessfulMessage)
        }
        $total = 0

        ## CALL  setup-NewInstance
    } #end ELSE
}

function notify-Teams ([Object[]] $f_DeployInfo, [String] $Status, $f_ResultsTable ){
    write-host " ] Notify Teams: $Status"
    $somethingForLater = ".\deployDB.ps1 -targetDB $($f_DeployInfo.TargetDB) -repoRoot $($f_DeployInfo.repoRoot) -repoFolder $($f_DeployInfo.repoFolder) -cmsGroup $($f_DeployInfo.cmsGroup) -dryRun `$$($f_DeployInfo.DryRun) -force `$$($f_DeployInfo.Force) -verbose"
    $sendSubject = "DEPLOY: $($f_DeployInfo.TargetDB.ToUpper()) STATUS: $Status VERSION: $($f_DeployInfo.RepoMajor).$($f_DeployInfo.RepoMinor)"# $(if($($DeployInfo.ServerCount) -gt 1){CMS: $($f_DeployInfo.cmsGroup.ToUpper())} ) "
    Write-Verbose "Subject: $($sendSubject)"
# $f_ResultsTable
    if( $status -eq "Starting" ){
        $sendBody = "
            $($f_DeployInfo.cmsGroup.ToUpper()) Instances: "+ $(IF($DeployInfo.ServerCount -eq 1){$DeployInfo.TargetHost}ELSE{$DeployInfo.ServerCount}) +"
            Processing: "+ $f_DeployInfo.RepoFolder.ToUpper() 
        IF( $f_DeployInfo.RepoFolder -eq 'EXEC' ){
            $sendBody = $sendBody + "
            Command: $($f_DeployInfo.RepoRoot -replace("'","''"))"
        }
        $sendBody = $sendBody +"
            Initiated by: $($env:USERNAME)
            "
    }
    ElseIF( $Status -eq "Successful" ){
        $sendBody = "
            $($f_DeployInfo.cmsGroup.ToUpper()) Instances: "+ $(IF($DeployInfo.ServerCount -eq 1){$DeployInfo.TargetHost}ELSE{$DeployInfo.ServerCount}) +"
            Instances Skipped: "+ $f_ResultsTable.Select("FinalResults LIKE '*SKIPPED*'").Count +" - Same Version
            Scripts failed: "+ $f_ResultsTable.Select("FinalResults LIKE '*FAILED - SQL*'").Count +"
            "    
    }
    ElseIF( $Status -eq "Failed" ){
        $sendBody = "
            $($f_DeployInfo.cmsGroup.ToUpper()) Instances: "+ $(IF($DeployInfo.ServerCount -eq 1){$DeployInfo.TargetHost}ELSE{$DeployInfo.ServerCount}) +"
            Instances Skipped: "+ $f_ResultsTable.Select("FinalResults LIKE '*SKIPPED*'").Count +" - Same Version
            Scripts failed: "+ $f_ResultsTable.Select("FinalResults LIKE '*FAILED - SQL*'").Count +"
            "
        ForEach( $failure in $f_ResultsTable ){ 
            $failure
            If( $failure.OrderValue -eq 3 ){
                write-host $($failure.FinalResults.replace("'",''))
                $sendBody = $sendBody + "
                "+ $($failure.FinalResults.replace("'",""))
            }
        }
    }


    #SELECT * FROM [info].[deployResults] WHERE deployID = $($f_DeployInfo.DeployID) ORDER BY deployID desc,  DeployStatus DESC "
    
    #$recipient = "5ae56b28.alliedsolutions.net@amer.teams.ms" #General - Database Services
    $recipient = "fa979978.alliedsolutions.net@amer.teams.ms" #Automations - Database Services
    #$recipient = "Harold.Brotherton@alliedSolutions.net"
    $sendSQL = "
		EXEC msdb..sp_send_dbmail 
			@recipients ='$($recipient)',
			@importance = 'LOW',
			@subject = '$($sendSubject)',
			@body = '$($sendBody)'"
    
   ## EXEC MSDB..send_dbmail @toAddress = `"$recipient`", @emailSubject = `"$sendSubject`", @emailBody = `"$sendBody`""
    if( $($f_DeployInfo.DryRun) ){
        Write-Host `t"[DryRun] Not Notifying Teams Channel
        $sendSQL
        "
    }
    Else{
        TRY {
                WRITE-VERBOSE "Invoke-Sqlcmd -ServerInstance $($f_DeployInfo.TargetInvServer) -Database $($f_DeployInfo.TargetInvDB) -DisableVariables -ErrorAction Stop -Query $sendSQL "
	            Invoke-Sqlcmd -ServerInstance $($f_DeployInfo.TargetInvServer) -Database $($f_DeployInfo.TargetInvDB) -DisableVariables -ErrorAction Stop -Query "$sendSQL"
            }
        CATCH{            
                WRITE-HOST `t"[ALERT] !!! Email failed to notify Teams !!! "
            }

    }


}

##########################################################################################################################################

## Prompt for credentials to admin SQL auth instances?
if( !$Credential.username ){ $Credential = Get-Credential }
# $myCred = Get-Credential
# https://www.sqlnethub.com/blog/how-to-resolve-cannot-connect-to-wmi-provider-sql-server-configuration-manager/
# Load the assemblies
#[reflection.assembly]::LoadWithPartialName("Microsoft.SqlServer.Smo")
#[reflection.assembly]::LoadWithPartialName("Microsoft.SqlServer.SqlWmiManagement")

#Create Results DataTable
$ResultsTable = New-Object System.Data.DataTable 
[void]$ResultsTable.Columns.Add("OrderValue")
[void]$resultsTable.Columns.Add("targetInstance")
[void]$resultsTable.Columns.Add("targetDatabase")
[void]$ResultsTable.Columns.Add("FinalResults")

IF(  $targetDB -eq "DBA" ){ 
    $ScriptsPath = $project.Substring(0, $project.toUpper().IndexOf('DBA\')+3)  +'\SetupConfigs\' 
}
ELSEIF( $targetDB -eq "AdminSupportTool" ){ 
    $ScriptsPath = $project.Substring(0, $project.toUpper().IndexOf('DBA\')+3)  +'\INIT\Actions\' 
    $Configure = 1
}
ELSE{ # InventoryDWH needs tool kit deployed
    $ScriptsPath = $project
}

IF( $repoRoot -eq "" ){ 
    $repoRoot = $project.Substring(0, $project.toUpper().IndexOf('DBA\')+3) +'\'+ $targetDB +'\' 
}
ELSEIF( $repoRoot.substring($repoRoot.Length -1, 1) -ne "\" ){
    $repoRoot = $repoRoot +'\'
}

IF( $repoRoot -like "*GitHub*"){
    Write-Host "[] Retrieving local GitHub version....."
    write-host " ] git -C $($repoRoot) branch --show-current"
    $Branch = invoke-expression "git -C $($repoRoot) branch --show-current"

    ### Sanity check for Main branch if -CMSgroup = PROD
    Write-Verbose "   Source branch: $($Branch)"
    try{
        $gitVersion = git -C $($repoRoot) describe --abbrev=0 --tags
        IF($gitVersion.indexOf('.') -gt 0)
            {
               Write-Host "wahat"
               $gitMajor = $gitVersion.substring(0,$gitVersion.IndexOf('.')).replace("v","")
               $gitMinor = $gitVersion.replace("v$($gitMajor).","") # 
            }
    }
    catch{
            $gitMajor = "1"
	        $gitMinor = "0"
    }

    ### Sanity check for dev branch is -CMSgroup = NONProd ( DEV, QA, TEST, STG)
    IF($Branch -eq "dev" -AND ($cmsGroup -notin ('ADMIN','PROD' )) ){
        Write-Verbose "[DEV] Deploying $($Branch) to $($cmsGroup)"
    } 
    ELSEIF($Branch -eq "main" -AND ($cmsGroup -in ('ADMIN','PROD' )) ){ 
        Write-Verbose "[MAIN] Deploying $($Branch) to $($cmsGroup)"
    }
    ELSE{
        Write-Host "[ALERT] Deploying $($Branch) to $($cmsGroup)" -ForegroundColor Yellow
        IF( !$($force) ){
            Write-Host -NoNewline "Do you want to proceed? (Y/N): "
            $Response = Read-Host

            If( $Response -ne "Y" ){ 
                Write-Warning "Script ends"  
                BREAK
            }
        }
        ELSE{
            Write-Host "[FORCE] Deploying $($Branch) to $($cmsGroup)" -ForegroundColor Red
        }
    }
    #$force = $true
    $RepoVersion = [ordered]@{
        RepoRoot = $repoRoot
        Branch = $Branch
        Major = $gitMajor
	    Minor = $gitMinor
    }
}
ELSE{
    if( Test-Path $repoRoot ){
        Write-Host "[] Retrieving local repository version....."
        Write-Verbose " ] $repoRoot" #" ] $($project.Substring(0, $project.toUpper().IndexOf('DBA')+4) + $targetDB +'\')"
        $RepoVersion = get-LocalVersion $repoRoot
    }
    ELSE{ #should put exclusions for nonrepo deploys
        Write-Host "Not Deploying TFS objects"
        $RepoVersion = [ordered]@{
            RepoRoot = $repoRoot
            Branch = "TFS"
            Major = "0"
	        Minor = "0"
        }
    }
}

Write-Host " "
### Create Harvest object with start date - name and ID and parameters
$DeployInfo = [ordered]@{
    TargetDB = $targetDB
	TargetHost = $targetHost
    cmsGroup = $cmsGroup
	RepoRoot = $RepoVersion.RepoRoot
	RepoFolder = $repoFolder
    RepoMajor = $RepoVersion.Major
    RepoMinor = $RepoVersion.Minor
    ScriptsPath = $ScriptsPath
    TargetInvServer = $targetInvServer
    TargetInvDB = $targetInvDB
    TargetSSRSurl = "http://dba-sqlprd-01/ReportServer/reportservice2005.asmx?wsdl"
    FileFilter = $fileFilter
    Credential = $Credential
    Configure = $configure # should be zero if dryrun = 1
    Notify = $notify
    Force = $force
	DryRun = $dryRun
    StartDateTime = Get-Date
}

Write-Host "[] Target DB: $($DeployInfo.TargetDB) "
IF( $DeployInfo.TargetHost -ne "" ){ Write-Host "[] Target Host: $($DeployInfo.TargetHost) " }
IF( $DeployInfo.cmsGroup -ne "" ){ Write-Host "[] CMS Group: $($DeployInfo.cmsGroup) " }
Write-Host "[] Folder: $($DeployInfo.RepoFolder) "

IF( $DeployInfo.RepoFolder -eq "EXEC" ){
    Write-Host "[] Command: $($DeployInfo.RepoRoot) "
}
ELSE{ 
    Write-Host "[] Repo Root: $($DeployInfo.RepoRoot) ($($RepoVersion.Branch))" 
    Write-Host "[] Repo Version: $($DeployInfo.RepoMajor)"
    Write-Host "[] Repo ChangeSet: $($DeployInfo.RepoMinor)"
}

Write-Host "[] Inv DB: $($DeployInfo.TargetInvDB) "
Write-Host "[] Inv Server: $($DeployInfo.TargetInvServer) "
Write-Host "[] Scripts Folder: $($DeployInfo.ScriptsPath) "
Write-Host "[] Filter: $($DeployInfo.FileFilter) "
Write-Host "[] Notify: $($DeployInfo.Notify) "
Write-Host "[] Force: $($DeployInfo.Force) "
Write-Host "[] DryRun: $($DeployInfo.DryRun) "
Write-Verbose ".\deployDB.ps1 -targetDB $($DeployInfo.TargetDB) $(IF( $DeployInfo.TargetHost -eq ''){ '-cmsGroup '+ $($DeployInfo.cmsGroup) }else{ '-TargetHost '+ $($DeployInfo.TargetHost) }) -repoFolder $($DeployInfo.repoFolder) -cmsGroup $($DeployInfo.cmsGroup) -dryRun `$$($DeployInfo.DryRun)" 
Write-Host " "

IF( $DeployInfo.TargetHost -eq ""){
    IF( $DeployInfo.cmsGroup -eq "" ){
        Write-Host "[] No CMS Group and no target instance supplied - exiting"
        EXIT
    }
    ELSE{
        Write-Host "[] No target instance supplied - looking at Inventory for CMS group $($DeployInfo.cmsGroup)"
        If( $DeployInfo.cmsGroup -eq "nonprod"){
            $selectSQL = "SELECT [SQLServerName] as ServerName, [DomainName] as DomainName, [ServerEnvironment] FROM [InventoryDWH].[inv].[SQLInstances] WHERE ServerEnvironment NOT IN ( 'PROD', 'ADMIN', '_DCOM' ) ORDER BY ServerEnvironment, SQLServerName"
        }
        ELSEIf( $DeployInfo.cmsGroup -eq "allprod"){
            $selectSQL = "SELECT [SQLServerName] as ServerName, [DomainName] as DomainName, [ServerEnvironment] FROM [InventoryDWH].[inv].[SQLInstances] WHERE ServerEnvironment IN ( 'PROD', 'ADMIN' ) ORDER BY ServerEnvironment, SQLServerName"
        }
        ELSEIf( $DeployInfo.cmsGroup -eq "all"){
            $selectSQL = "SELECT [SQLServerName] as ServerName, [DomainName] as DomainName, [ServerEnvironment] FROM [InventoryDWH].[inv].[SQLInstances] ORDER BY ServerEnvironment, SQLServerName"
        }
        ELSE{
            $selectSQL = "SELECT [SQLServerName] as ServerName, [DomainName] as DomainName, [ServerEnvironment] FROM [InventoryDWH].[inv].[SQLInstances] WHERE ServerEnvironment = '$($DeployInfo.cmsGroup)' ORDER BY SQLServerName"
        }
    }
}
ELSE{
    Write-Host "[] Target instance supplied: $($DeployInfo.targetHost) "
    # $hostList = $($DeployInfo.targetHost)
    IF( $DeployInfo.configure ){
        #$selectSQL = "SELECT '$($DeployInfo.targetHost)' as ServerName, '' as DomainName, '$($DeployInfo.cmsGroup)' as ServerEnvironment"
        $selectSQL = "SELECT TOP 1 '$($DeployInfo.targetHost)' as ServerName, IsNull([ServerEnvironment],'$($DeployInfo.cmsGroup)') as ServerEnvironment, IsNull([DomainName],'') as DomainName FROM [InventoryDWH].[inv].[SQLInstances] "

        ## Sanity check on NULL CMS Group?

        ## Sanity check on domain?
    }
    ELSE{
        IF($($DeployInfo.targetHost).indexOf('.') -gt 1){
            $shortname = $($DeployInfo.targetHost).substring(0,$($DeployInfo.targetHost).IndexOf('.'))
        }
        ELSE{
            $shortname = $($DeployInfo.targetHost)
        }
        IF( $($DeployInfo.Force) ){
            ## Check inventory and if @@rowsReturn = 0 default to _Unmanaged and DEV values
             $selectSQL = "SELECT '$($DeployInfo.targetHost)' as ServerName, 'DomainName' as DomainName, CASE WHEN '$($DeployInfo.cmsGroup)' = '' THEN '_Unmanaged' ELSE '$($DeployInfo.cmsGroup)' END as ServerEnvironment "
        }
        ELSE{
             $selectSQL = "SELECT '$($DeployInfo.targetHost)' as ServerName, [DomainName] as DomainName, IsNull([ServerEnvironment],'$($DeployInfo.cmsGroup)') as ServerEnvironment FROM [InventoryDWH].[inv].[SQLInstances] WHERE SQLServerName = '$($shortname)'"
        }
       
    }
}
  ## Sanity check on NULL CMSD Group?

Write-Host `t"$($selectSQL)"
Write-Verbose `t"invoke-sqlcmd -ServerInstance $($DeployInfo.TargetInvServer) -Database $($DeployInfo.TargetInvDB) -Query $selectSQL "
$hostList = @( invoke-sqlcmd -ServerInstance $($DeployInfo.TargetInvServer) -Database $($DeployInfo.TargetInvDB) -Query $selectSQL)
$DeployInfo | Add-Member -membertype NoteProperty -name ServerCount -value "$($hostList.count)"

Write-Host "[] Starting Deploy $($DeployInfo.StartDateTime)"
## Merge Harvets info and return ID.
If( $DeployID -eq $null ){
    $DeployID = Merge-DeployInfo $DeployInfo
}

$DeployInfo | Add-Member -membertype NoteProperty -name DeployID -value "$($DeployID)"

if( $($DeployInfo.Notify) ){
    notify-Teams $DeployInfo "Starting" $ResultsTable
}

IF( $targetDB.ToUpper() -eq "PowerShellScripts" ){           
    Write-Host "[  CopyFiles   ]"
    Write-Host `t"Copy to Standard location used by baseline:  $($DeployInfo.ScriptsPath)\Install "
    #process-zipFile "$DeployInfo.RepoRoot\COPY" $currentHost.ServerName $folder $targetDB $repoVersion $dryRun
                
    Write-Host `t"Copy to location used by SQL Agent Jobs: $($DeployInfo.ScriptsPath)\Jobs "
    #process-zipFile "$DeployInfo.RepoRoot\COPY" $currentHost.ServerName $folder $targetDB $repoVersion $dryRun
}
ELSE{   
    [int] $hostCounter = 1
    ForEach ( $currentHost in $hostList){
        Write-Host "[  Processing: $($hostCounter) of $($DeployInfo.ServerCount)  ] $($currentHost.ServerName)"

        IF( !$($DeployInfo.Force) ){
            Write-Host " ] Ping Test: $($currentHost.ServerName) "
            $currentPing = ping-host $($currentHost.ServerName) $($currentHost.DomainName) 
        }
        ELSE{
            Write-Output "[FORCE] - Skipping ping test: $($currentHost.ServerName)"
            $currentPing = $true
        }
        IF( $currentPing ){
            ## Instance Check

            Write-Host " ] DB online Test: $($DeployInfo.TargetDB) "
            $targetDBInfo = @( get-dbState $currentHost $DeployInfo  )
            Write-Verbose "DB: $($targetDBInfo.Name) Status: $($targetDBInfo.Status) Type: $($targetDBInfo.serverType) Version: $($targetDBInfo.Version) ChangeSet: $($targetDBInfo.changeSet) Count: $($targetDBInfo.Count)"
            IF( ($targetDBInfo.Count -eq 0) -AND ($DeployInfo.RepoFolder -ne 'EXEC') ){
                Write-Host "[WARNING] Creating: $($DeployInfo.TargetDB) on $($currentHost.ServerName) "
                $createScript = "$($DeployInfo.RepoRoot)create$($DeployInfo.TargetDB).sql"
                Write-Host " ] Excute create script: $($createScript)"
                if( !$dryRun ){
                    Try{
                        $sqlOptions = "dryRun=$dryRun"
                        Write-Verbose "Invoke-Sqlcmd -ServerInstance $($currentHost.ServerName) -Database MASTER -InputFile $createScript -Variable $sqlOptions -ErrorAction Stop "
                        invoke-sqlcmd -ServerInstance $currentHost.ServerName -Database MASTER -InputFile $createScript -Variable $sqlOptions -QueryTimeout 65535 -ErrorAction 'Stop' 
                        #$targetDBInfo = @( get-dbState $DeployInfo.TargetDB $currentHost.ServerName $dryRun )
                        $targetDBInfo = @( get-dbState $currentHost $DeployInfo )
                    }
                    Catch{
                        Write-Host `t`t"[ALERT] FAILED TO CREATE DB $($DeployInfo.TargetDB) - logging Failure"  -ForegroundColor Red
                        Write-Host `t"error: $_"
                        $ExceptionMessage = "[ALERT - CreateDB] Invoke-Sqlcmd -ServerInstance $($currentHost.ServerName) -Database MASTER -InputFile $createScript -Variable '$sqlOptions' -ErrorAction Stop -verbose"
                        [void]$ResultsTable.Rows.Add("2", $currentHost.ServerName, $DeployInfo.TargetDB, $ExceptionMessage)
                        #$failedOBJ = [ordered]@{
                        #    Host = $($DeployInfo.TargetInvServer)
                        #    Function = "Create-Database"
                        #    Command = "Create-Database `$DeployInfo $($f_DeployInfo.DryRun)"
                        #    Message = 'NA'
                        #}
                        #record-Failure $DeployInfo $failedOBJ $f_DeployInfo.DryRun
                                                                    
                        $failedOBJ = [ordered]@{
                            Host = $($currentHost.ServerName)
                            Function = "Create-DB"
                            Command = $ExceptionMessage.Substring($ExceptionMessage.IndexOf('] ')+2,$ExceptionMessage.length - $ExceptionMessage.IndexOf('] ')-2 )
                            Message = $($_)
                        }

                        IF( $DeployInfo.TargetDB -ne 'InventoryDWH' ){
                            record-Failure $DeployInfo $failedOBJ 
                        }
                    }
                }
                else{
                    Write-Host `t"$($createScript)"
                    # populate with data for dryRun
                    $targetDBInfo = @( get-dbState $currentHost $DeployInfo )
                }
            }

            IF( ($targetDBInfo.Status -eq "Online") -OR ($($DeployInfo.Force)) ) {
                IF( $DeployInfo.FileFilter -eq "*.sql" ){
                    Write-Host " ] Processing: TSQL $($DeployInfo.RepoFolder)"
                    IF( $DeployInfo.RepoFolder -eq 'EXEC' ){
                        $commandType = $DeployInfo.RepoRoot.substring(0,$DeployInfo.RepoRoot.IndexOf(' '))
                        try{
                            $execCMD = "$($DeployInfo.RepoRoot)"
                            If( $DeployInfo.Force -eq "False" ){  # use force for system stored procedures...poorly designed.
                                IF( $commandType -eq "EXEC" ){ 
                                    $execCMD = $execCMD 
                                }
                            }
                            else{
                                IF( $commandType -eq "EXEC" ){ 
                                    $execCMD = $execCMD + $(if($execCMD.contains("@")){", "}ELSE{""}) + " @dryRun=$(if($DeployInfo.DryRun){1}ELSE{0})" 
                                }
                            }

                            Write-Host " ] Command: $($execCMD)"
                            
                            WRITE-VERBOSE "Invoke-Sqlcmd -ServerInstance $($currentHost.ServerName) -Database $($DeployInfo.TargetDB) -Query `"$execCMD`" -ErrorAction 'Stop' -verbose"
	                        Invoke-Sqlcmd -ServerInstance $($currentHost.ServerName) -Database $($DeployInfo.TargetDB) -Query $execCMD -ErrorAction 'Stop'
                        }
                        catch{
                            Write-Host "[ALERT] $($currentHost.ServerName) Failed to EXEC $($execCMD) "  -ForegroundColor Red
                            Write-Verbose "Target DB Info: $($targetDBInfo.Name) $($targetDBInfo.Status) $($targetDBInfo.Servertype)"
                            $ExceptionMessage = "[FAILED - EXEC] .\deployDB.ps1 -targetHost $($currentHost.ServerName) -targetDB $($targetDBInfo.Name) -repoRoot `"$($DeployInfo.RepoRoot)`" -repoFolder 'EXEC' -dryRun `$$($DeployInfo.DryRun) -verbose"
                            [void]$ResultsTable.Rows.Add("3", $($currentHost.ServerName), $DeployInfo.TargetDB, $ExceptionMessage)
                            #$failedOBJ = [ordered]@{
                            #    Host = $($DeployInfo.TargetInvServer)
                            #    Function = "EXEC-Command"
                            #    Command = "$($execCMD)"
                            #    Message = 'NA'
                            #}
                            #record-Failure $DeployInfo $failedOBJ $f_DeployInfo.DryRun
                                            
                            $failedOBJ = [ordered]@{
                                Host = $($currentHost.ServerName)
                                Function = "EXEC-CMD"
                                Command = $ExceptionMessage.Substring($ExceptionMessage.IndexOf('] ')+2,$ExceptionMessage.length - $ExceptionMessage.IndexOf('] ')-2 )
                                Message = $($_)
                            }

                            IF( $DeployInfo.TargetDB -ne 'InventoryDWH' ){
                                record-Failure $DeployInfo $failedOBJ 
                            }
                        }
                    }
                    ElseIf( ($DeployInfo.RepoFolder -eq "Auto") -AND ( 
                                                                        ( 
                                                                           $($targetDBInfo.Version)+"."+$($targetDBInfo.changeSet) -lt $($DeployInfo.RepoMajor)+"."+$($DeployInfo.RepoMinor)
                                                                        ) -OR ( ($DeployInfo.Force) -OR ($DeployInfo.Configure) )
                                                                     ) ){	
                        process-Folder "$($DeployInfo.RepoRoot)Role" $currentHost $DeployInfo
                        process-Folder "$($DeployInfo.RepoRoot)Schema" $currentHost $DeployInfo
                        process-Folder "$($DeployInfo.RepoRoot)Table" $currentHost $DeployInfo
                        process-Folder "$($DeployInfo.RepoRoot)View" $currentHost $DeployInfo 
                        process-Folder "$($DeployInfo.RepoRoot)Type" $currentHost  $DeployInfo	
                        process-Folder "$($DeployInfo.RepoRoot)Synonym" $currentHost $DeployInfo
                        process-Folder "$($DeployInfo.RepoRoot)UserDefinedFunction" $currentHost $DeployInfo
                        process-Folder "$($DeployInfo.RepoRoot)StoredProcedure" $currentHost $DeployInfo
                        process-Folder "$($DeployInfo.RepoRoot)Init" $currentHost $DeployInfo
                        
                        if( ($DeployInfo.Configure -eq "True") -and ($DeployInfo.TargetDB -eq "AdminSupportTool") ){
                            <# EXEC AdminSupportTool.deploy.SetActionStatus 0 with force  #>
                            Write-Host "[  Disable ALL Action Scripts during deploy... ]"
                            $execCMD = "EXEC [deploy].[SetScriptStatus] @ScriptStatus = 0, @force = 1, @dryRun=$(if($DeployInfo.DryRun){1}ELSE{0}), @update_user = '$($env:USERNAME)'"
                            WRITE-VERBOSE "Invoke-Sqlcmd -ServerInstance $($currentHost.ServerName) -Database $($DeployInfo.TargetDB) -Query `"$execCMD`" -ErrorAction 'Stop' -verbose"
	                        Invoke-Sqlcmd -ServerInstance $($currentHost.ServerName) -Database $($DeployInfo.TargetDB) -Query $execCMD -ErrorAction 'Stop'

                            Write-Host "[  Deploying Action Scripts  ]"  
                            process-Actions "$($DeployInfo.RepoRoot)Init\Actions" $currentHost $DeployInfo
                        }

                        process-Folder "$($DeployInfo.RepoRoot)SSRS" $currentHost $DeployInfo

                        if( ($DeployInfo.Configure -eq "True") -and ($DeployInfo.TargetDB -eq "DBA") ){
                            Write-Host "[  Starting Instance Setup  ]"  
                            #Write-Host " ] Deploying OLA default objects" # These scripts needs to be replaced with DBA objects
                            #process-Folder "$($DeployInfo.ScriptsPath)DBA-OLA\MaintenanceJobs" $currentHost $DeployInfo

                            Write-Host " ] Deploying First Responder Kit"
                            process-Folder "$($DeployInfo.ScriptsPath)DBA-OLA\FirstResponderKit" $currentHost $DeployInfo

                            Write-Host " ] Running Configuration Stored Procedures"
                            setup-NewInstance $currentHost.ServerName $DeployInfo

                            Write-Host " ] Restart SQL Agent"
                            #set-SQLServiceStatus $currentHost.ServerName 'Agent' 'restart'
                        }

                        IF( ($CurrentHost.DomainName.indexOf('.net') -gt 0) -or ($CurrentHost.DomainName.indexOf('.NET') -gt 0) ){
                            Write-Host "[Warning] Skipping .NET targets"
                             $agentStatus = [ordered]@{ Status = 'Running' }
                        }
                        ELSE{
                            $agentStatus = get-SQLServiceStatus $currentHost.ServerName 'Agent'
                            if( $agentStatus.Status -ne "Running" ){
                                Write-Host "[Warning] SQL Agent is not online - Attemping start"

                                Try{
                                    set-SQLServiceStatus $currentHost.ServerName 'Agent' 'start'

                                    $agentStatus = get-SQLServiceStatus $currentHost.ServerName 'Agent'
                                }
                                Catch{
                                    $ExceptionMessage = "[FAILED - StartAgent]  Set-SQLServiceStatus $($currentHost.ServerName) 'Agent' 'start'"
                                    [void]$ResultsTable.Rows.Add("3", $currentHost.ServerName, $targetDBInfo.Name, $ExceptionMessage)

                                    $failedOBJ = [ordered]@{
                                        Host = $($currentHost.ServerName)
                                        Function = "set-SQLServiceStatus"
                                        Command = $ExceptionMessage.Substring($ExceptionMessage.IndexOf('] ')+2,$ExceptionMessage.length - $ExceptionMessage.IndexOf('] ')-2 )
                                        Message = $($_)
                                    }

                                    IF( $DeployInfo.TargetDB -ne 'InventoryDWH' ){
                                        record-Failure $DeployInfo $failedOBJ 
                                    }

                                    $agentStatus = [ordered]@{ Status = 'NA' }
                                }

                            }

                        }


                        if( ($agentStatus.Status -eq "Running") -OR ($DeployInfo.Force -eq "True") ){
                            process-Folder "$($DeployInfo.RepoRoot)AgentJob" $currentHost $DeployInfo
                            process-Folder "$($DeployInfo.RepoRoot)Alert" $currentHost $DeployInfo

                            ## Start local harvest

                        }
                        else{
                            Write-Host "[ALERT] SQL Agent is not online - Attemping start" -ForegroundColor Red
                            set-SQLServiceStatus $currentHost.ServerName 'Agent' 'start'

                            $ExceptionMessage = "[SQLAgent - OffLine] .\deployDB.ps1 -targetHost $($currentHost.ServerName) -targetDB $($targetDBInfo.Name) -dryRun `$$($DeployInfo.DryRun) -verbose"
                            [void]$ResultsTable.Rows.Add("3", $currentHost.ServerName, $targetDBInfo.Name, $ExceptionMessage)

                            $failedOBJ = [ordered]@{
                                Host = $($currentHost.ServerName)
                                Function = "SQLAgent - OffLine"
                                Command = $ExceptionMessage.Substring($ExceptionMessage.IndexOf('] ')+2,$ExceptionMessage.length - $ExceptionMessage.IndexOf('] ')-2 )
                                Message = $($_)
                            }

                            IF( $DeployInfo.TargetDB -ne 'InventoryDWH' ){
                                record-Failure $DeployInfo $failedOBJ 
                            }

                        }

                    ## Update Version number in systemConfig Table - This is considered a full deploy
                        If($ResultsTable.Select("FinalResults LIKE '*FAILED*' AND TargetInstance = '$($currentHost.ServerName)'").ItemArray -eq $null){
                            Write-Host " ] Update local version number in DBA.info.databaseConfig"
                            update-DBinfo $DeployInfo $currentHost
                        }
                        Else{
                            Write-Host "[ALERT] Failed to deploy objects"
                            #$ResultsTable | where {$_.OrderValue -eq 3} | Sort-Object @{Expression = "OrderValue"}, @{Expression = "TargetInstance"}, @{Expression = "FinalResults"} | format-Table -Property @{Label="Final Results $($DeployInfo.cmsGroup)"; Expression={ $_.FinalResults }} -wrap  
                            #$FinalResultMessage = "*** FAILURE ***"
                            #IF( $($DeployInfo.Notify) ){
                            #    notify-Teams $DeployInfo "Failed" $ResultsTable
                            #}
                        }
                        #Write-Host " ] Update local version number in DBA.info.databaseConfig"
                        #    update-DBinfo $DeployInfo $currentHost

                    ## Addditional services for special databases.
                        if ( $targetDBInfo.Name -eq 'InventoryDWH' ){ # files required to support jobs.
                            Write-Host "[  Copy Supporting Powershell scripts. (DBA_Tools)  ]"
                            write-verbose `t"Source: $($DeployInfo.ScriptsPath)"

                            $selectSQL = "
                                SELECT Left([Path], 2)+'\SQLPowerShell\DBA_Tools' as Path FROM [DBA].[info].[DriveUsage] where path like '%Programs%';"

                            $scriptsDestination = invoke-sqlcmd -ServerInstance $currentHost.ServerName -Database MASTER -Query $selectSQL -QueryTimeout 65535 -ErrorAction 'Stop' | select -exp Path

                            Write-Verbose `t"Target: $($scriptsDestination)"
                            copy-MyFiles $($DeployInfo.ScriptsPath) $($scriptsDestination) $($currentHost.ServerName) "*" $DeployInfo.DryRun
                        }
                    }
                    ELSEIF( ($DeployInfo.RepoFolder -eq "Auto") -AND ( ($($targetDBInfo.Version) -eq $($DeployInfo.RepoMajor)) -AND ($($targetDBInfo.changeSet) -eq $($DeployInfo.RepoMinor)) ) ){
                        Write-Host " ] No changes required DB is at version $($targetDBInfo.Version).$($targetDBInfo.changeSet)"
                        $ExceptionMessage = "[SKIPPED - HOST] $($currentHost.ServerName) $($DeployInfo.TargetDB) is current"
                        [void]$ResultsTable.Rows.Add("1", $($currentHost.ServerName), $($DeployInfo.TargetDB), $ExceptionMessage)
                    }
                    ELSE{ 
                        Write-Host "Something went wrong"
                        Process-Folder "$($DeployInfo.RepoRoot + $repoFolder)" $currentHost $DeployInfo

                        ## Update Version number in systemConfig Table - This is considered a full deploy
                        Write-Host " ] Update local version number in DBA.info.databaseConfig"
                            update-DBinfo $DeployInfo $currentHost
                    }
                }
                ELSEIf( $DeployInfo.FileFilter -eq "*.ps1" ){
                    Write-Host "[] Processing: PowerShell"
                    IF( $DeployInfo.RepoFolder -eq 'AUTO' ){
                        ## run all scripts in alphabetial order

                    }
                    ELSEIF(  $DeployInfo.RepoFolder -eq 'EXEC' ){
                        ## Execute a function in a module
                        get-RemoteProcess -Server $currentHost -ProcessName ddbmexptool

                    }
                    WRITE-VERBOSE ".\deployDB.ps1 -targetHost $($currentHost.ServerName) -targetDB $($targetDBInfo.Name) -dryRun $($DeployInfo.DryRun) -verbose"
                    If($repoFolder -eq "Auto"){	
                        processFolder "$($DeployInfo.RepoRoot)\Scripts" $currentHost $DeployInfo
                    }
                    ELSE{
                        ProcessFolder "$($DeployInfo.RepoRoot)\$repoFolder" $currentHost $DeployInfo
                    }
                }
                ELSEIf( $DeployInfo.FileFilter -eq ".ps1" ){
                    Write-Host "[] Processing: PowerShell"
                    WRITE-VERBOSE ".\deployDB.ps1 -targetHost $($currentHost.ServerName) -targetDB $($targetDBInfo.Name) -dryRun $($DeployInfo.DryRun) -verbose"
                    If($repoFolder -eq "Auto"){	
                        processFolder "$($DeployInfo.RepoRoot)\Scripts" $currentHost $DeployInfo
                    }
                    ELSE{
                        ProcessFolder "$($DeployInfo.RepoRoot)\$repoFolder" $currentHost $DeployInfo
                    }
                }
            }
            ELSEIF( ($targetDBInfo.Status -eq "RESTORING") -AND ($targetDBInfo.serverType -eq "Secondary") -AND ($targetDBInfo.Count -ne 0)  ){
                Write-Host "[SKIP] Target Host is of Type RESTORE and target DB is in state RESTORING"
            }
            ELSE{
                Write-Host "[ALERT] TargetDatabase does not exist. "  -ForegroundColor Red
                Write-Verbose "Target DB Info: $($targetDBInfo.Name) $($targetDBInfo.Status) $($targetDBInfo.Servertype)"
                $ExceptionMessage = "[FAILED - MissingDB] .\deployDB.ps1 -targetHost $($currentHost.ServerName) -targetDB $($DeployInfo.TargetDB) -RepoFolder 'Auto' -dryRun `$$($DeployInfo.DryRun) -verbose"
                [void]$ResultsTable.Rows.Add("3", $($currentHost.ServerName),  $($DeployInfo.TargetDB), $ExceptionMessage)
                
                $failedOBJ = [ordered]@{
                    Host = $($currentHost.ServerName)
                    Function = "Missing-DB"
                    Command = $ExceptionMessage.Substring($ExceptionMessage.IndexOf('] ')+2,$ExceptionMessage.length - $ExceptionMessage.IndexOf('] ')-2 )
                    Message = $($_)
                }

                IF( $DeployInfo.TargetDB -ne 'InventoryDWH' ){
                    record-Failure $DeployInfo $failedOBJ 
                }
            }
        } #IF( ping-host $currentHost.ServerName $currentDomain )
        ELSE{
            Write-Host `t`t"[ALERT] FAILED TO CONNECT - logging Failure"  -ForegroundColor Red
            #  ([DeployID], [SQLServerName], [Function], [command], [ErrorMessage], [Daterun])
            $ExceptionMessage = "[FAILED - PING] .\deployDB.ps1 -targetHost $($currentHost.ServerName) -targetDB $($DeployInfo.TargetDB) -dryRun `$$($DeployInfo.DryRun) -notify `$$($DeployInfo.Notify) -force `$$($DeployInfo.Force) -verbose"
            [void]$ResultsTable.Rows.Add("3", $($currentHost.ServerName), $($DeployInfo.TargetDB), $ExceptionMessage)

            $failedOBJ = [ordered]@{
                Host = $($currentHost.ServerName)
                Function = "Ping-Host"
                Command = $ExceptionMessage.Substring($ExceptionMessage.IndexOf('] ')+2,$ExceptionMessage.length - $ExceptionMessage.IndexOf('] ')-2 )
                Message = $($_)
            }

            IF( $DeployInfo.TargetDB -ne 'InventoryDWH' ){
                record-Failure $DeployInfo $failedOBJ 
            }
        }



        $hostCounter++
    } #forEach Host
}

IF( $($DeployInfo.ServerCount) -eq 0 ){Write-Host "[WARNING] Zero row count indicates new instance not in inventory add '-cmsGroup value -configure 1' to deploy"}
#Print final Result of the script
If($ResultsTable.Select("FinalResults LIKE '*FAILED*'").ItemArray -eq $null){
    $FinalResultMessage = "*** SUCCESS ***"
    IF( $($DeployInfo.Notify) ){
        notify-Teams $DeployInfo "Successful" $ResultsTable
    }
}
Else{
    $ResultsTable | where {$_.OrderValue -eq 3} | Sort-Object @{Expression = "OrderValue"}, @{Expression = "TargetInstance"}, @{Expression = "FinalResults"} | format-Table -Property @{Label="Final Results $($DeployInfo.cmsGroup)"; Expression={ $_.FinalResults }} -wrap  
    $FinalResultMessage = "*** FAILURE ***"
    IF( $($DeployInfo.Notify) ){
        notify-Teams $DeployInfo "Failed" $ResultsTable
    }
}

IF( $($DeployInfo.DryRun) ) {
    Write-Host "[DryRun] Finished Deploying: $($DeployInfo.TargetDB) "
    #IF( $DeployInfo.RepoFolder -eq "EXEC" ){
        $ResultsTable | Sort-Object @{Expression = "OrderValue"}, @{Expression = "TargetInstance"}, @{Expression = "FinalResults"}  | Format-Table -AutoSize
    #}
}
ELSE{
    Write-Host "[$($FinalResultMessage)] Finished Deploying: $($DeployInfo.TargetDB) "
    $DeployInfo | Add-Member -membertype NoteProperty -name EndDateTime -value "$(Get-Date)"
    Write-Host "[] Deploy complete: $($DeployInfo.EndDateTime)"
    $ThrowAway = Merge-DeployInfo $DeployInfo $FinalResultMessage
}
