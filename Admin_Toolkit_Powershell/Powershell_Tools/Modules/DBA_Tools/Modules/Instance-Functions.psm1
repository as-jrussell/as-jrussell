#
# Script1.psm1
#
function get-SQLServiceStatus{
	param( [string] $targetInstance, [object[]] $serviceName )

    IF($targetInstance.indexOf('\') -gt 0){
        write-Verbose "Named Instnace"
        $targetServer = $targetInstance.substring(0,$targetInstance.IndexOf('\')) #+ $f_domain
        $targetInstance = $targetInstance.substring($targetInstance.IndexOf('\')+1,$targetInstance.length-($targetInstance.IndexOf('\')+1))
    }
    ELSEIF($targetInstance.indexOf('.net') -gt 0){
        Write-Verbose "[Warning] Skipping .NET targets"
        #needs SQL authentication - just return false?
        $targetServer = $targetInstance
        return $false
    }
    ELSE{
        $targetServer = $targetInstance #+ $f_domain
        $targetInstance = 'MSSQLSERVER'
    }

    write-Verbose "Target Host: $($targetServer)"
    write-Verbose "Target Inst: $($targetInstance)"
    write-Verbose "Target Services:"

    $whereCounter = 0
    $whereStatement = " "
     ForEach($svc in $serviceName){
        write-Verbose `t"$($svc)"
        If($whereCounter -gt 0){$whereStatement = $whereStatement +" -or "}
        switch ($svc){
            "Instance"  { $whereStatement = $whereStatement +"(`$_.DisplayName -like 'SQL Server ($($targetInstance))')"; break}
            "Agent"     { $whereStatement = $whereStatement +"(`$_.DisplayName -like 'SQL Server Agent ($($targetInstance))')"; break}
            "MSDTC"     { $whereStatement = $whereStatement +"(`$_.Name -like 'MSDTC')"; break}
            "Full-Text" { $whereStatement = $whereStatement +"(`$_.Name -like 'MSSQLFDLauncher')"; break}
            "Browser"   { $whereStatement = $whereStatement +"(`$_.Name -like 'SQLBrowser')"; break}
            "SSIS"      { $whereStatement = $whereStatement +"(`$_.Name -like 'MsDtsServer*')"; break}
        default {Write-Host "Service unrecognized";}
      }
      $whereCounter++
    }

    $command = "get-service -computername $targetServer | select  name, DisplayName, status | where { $whereStatement } "
    write-verbose `t"$($command)"
    try{
        Write-Verbose `t"invoke-expression $command"
        invoke-expression $command
    }
    catch{
        Write-Host `t"[ALERT] FAILED TO QUERY $($f_currentInst.DisplayName) -f $MyInvocation.MyCommand" -ForegroundColor Red 
        Write-Host `t"$($command)"
        ### record information or raise alert?
        Write-Host `t"error: $_"
    }
}
Export-ModuleMember -Function get-SQLServiceStatus

function set-SQLServiceStatus{ 
    param( [string] $TargetInstance, [object[]] $ServiceName, [string] $TargetStatus )

    IF($targetInstance.indexOf('\') -gt 0){
        write-Verbose "Named Instance"
        $targetServer = $targetInstance.substring(0,$targetInstance.IndexOf('\')) #+ $f_domain
        $targetInstance = $targetInstance.substring($targetInstance.IndexOf('\')+1,$targetInstance.length-($targetInstance.IndexOf('\')+1))
    }
    ELSEIF($targetInstance.indexOf('.net') -gt 0){
        Write-Verbose "[Warning] Skipping .NET targets"
        #needs SQL authentication - just return false?
        $targetServer = $targetInstance
        return $false
    }
    ELSE{
        $targetServer = $targetInstance #+ $f_domain
        $targetInstance = 'MSSQLSERVER'
    }

    write-Verbose "Target Host: $($targetServer)"
    write-Verbose "Target Inst: $($targetInstance)"
    write-Verbose "Target Services:"
    forEach( $svc in $ServiceName ){
        Write-Verbose "Target: $() Service: $($svc) Status: $($TargetStatus)"

        switch ($svc){
            "Instance"  { $remoteCommand = "net $($TargetStatus) 'SQL Server ($($TargetInstance))'"; break}
            "Agent"     { $remoteCommand = "net $($TargetStatus) 'SQL Server Agent ($($TargetInstance))'"; break}
            #"MSDTC"     { $remoteCommand = $whereStatement +"(`$_.Name -like 'MSDTC')"; break}
            #"Full-Text" { $remoteCommand = $whereStatement +"(`$_.Name -like 'MSSQLFDLauncher')"; break}
            "Browser"   { $remoteCommand = "net $($TargetStatus) 'SQL Server Browser'"; break}
            #"SSIS"      { $remoteCommand = $whereStatement +"(`$_.Name -like 'MsDtsServer*')"; break}
            default {Write-Host "Service unrecognized";}
        }

        $command = "invoke-command -computername $($targetServer) -Scriptblock { $remoteCommand }"
        write-Verbose `t"$($command)"
        try{
            invoke-expression $command
        }
        catch{
            Write-Host `t"[ALERT] FAILED TO QUERY $($f_currentInst.DisplayName) -f $MyInvocation.MyCommand" -ForegroundColor Red 
            Write-Host `t"$($command)"
            ### record information or raise alert?
            Write-Host `t"error: $_"
        }
    }
}
Export-ModuleMember -Function set-SQLServiceStatus

function get-InstanceID ([string] $InvInstance, [string] $InvDB, [string] $targetInstance, [int] $dryRun ){
    $selectSQL = "
    IF EXISTS( SELECT ID FROM inv.SQLInstances where SQLServerName = '$($targetInstance)' )
	    BEGIN
		    SELECT ID FROM inv.SQLInstances AS ID where SQLServerName = '$($targetInstance)'
	    END
    ELSE
	    BEGIN
            IF( 1 = $($dryRun))
                BEGIN
                    SELECT isNull(ident_current('inv.SQLInstances') + ident_incr('inv.SQLInstances'),1) AS ID
                END
	    END;"

    TRY{
        Write-verbose "
        $($selectSQL)"
        Invoke-Sqlcmd -ServerInstance $InvInstance -Database $InvDB -Query $selectSQL -QueryTimeout 65535 -ErrorAction 'Stop' | select -exp ID
    }
    CATCH{
        Write-Host `t"[ALERT] FAILED TO MERGE !!!!" -ForegroundColor Red 
        Write-Host `t"$($selectSQL)"
        ### record information or raise alert?
        Write-Host `t"error: $_"
    }
}
Export-ModuleMember -Function get-InstanceID

function add-PrimaryAG {
    [cmdletbinding(SupportsShouldProcess=$True)] 
    PARAM(
        [string] $serverNamePrimary, 
        [string] $serverNameSecondary,
        [string] $databaseName,
        [string] $agName,
        [string] $compatibilityLevel = 130, # compute based on MSDB or MASTER?
        [bool] $dryRun = $true
    )

    #Variables - SQL Statements
    $setRecovery = "RESTORE DATABASE $databaseName WITH RECOVERY;"
    $setAuthorization = "ALTER AUTHORIZATION ON DATABASE::[$databaseName] TO [sa];"
    $setCompatibilityLevel = "ALTER DATABASE [$databaseName] SET COMPATIBILITY_LEVEL = $compatibilityLevel;"
    $addDatabaseToAG = "ALTER AVAILABILITY GROUP [$agName] ADD DATABASE [$databaseName];"
    $addSecondaryDatabaseToAG = "ALTER DATABASE [$databaseName] SET HADR AVAILABILITY GROUP = [$agName];"
    $checkStatus = "SELECT sd.name, 
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
    WHERE sd.name = '$databaseName'"


    IF($dryRun){
        Write-Host "Setting Recovery On $databaseName Primary"
    }
    ELSE{
        try{    
            Write-Verbose "Setting Recovery On $databaseName Primary" -Verbose
            Invoke-Sqlcmd -ServerInstance $serverNamePrimary -Query $setRecovery -QueryTimeout 0 -ConnectionTimeout 0 -Verbose
        }
        catch {
            Write-Verbose "An error occurred in setting recovery mode on database $databaseName" -Verbose
            Write-Verbose $_ -Verbose
            break   
        }
    }

    IF($dryRun){
        Write-Host "Setting Owner to sa On $databaseName Primary"
    }
    ELSE{
        try {
            Write-Verbose "Setting Owner to sa On $databaseName Primary" -Verbose
            Invoke-Sqlcmd -ServerInstance $serverNamePrimary -Query $setAuthorization -QueryTimeout 0 -ConnectionTimeout 0 -Verbose
        }
        catch {
            Write-Verbose "An error occurred in setting owner to sa on database $databaseName" -Verbose
            Write-Verbose $_ -Verbose
            break   
        }
    }

    IF($dryRun){
        Write-Host "Setting Compatibility Level to $compatibilityLevel On $databaseName Primary"
    }
    ELSE{
        try {
            Write-Verbose "Setting Compatibility Level to $compatibilityLevel On $databaseName Primary" -Verbose
            Invoke-Sqlcmd -ServerInstance $serverNamePrimary -Query $setCompatibilityLevel -QueryTimeout 0 -ConnectionTimeout 0 -Verbose
        }
        catch {
            Write-Verbose "An error occurred in setting compatibility level on database $databaseName" -Verbose
            Write-Verbose $_ -Verbose
            break   
        }
    }

    IF($dryRun){
        Write-Host "Add database to $agName On Primary"
    }
    ELSE{
        try {
                Write-Verbose "Add database to $agName On Primary" -Verbose
                Invoke-Sqlcmd -ServerInstance $serverNamePrimary -Query $addDatabaseToAG  -QueryTimeout 0 -ConnectionTimeout 0 -Verbose
        }
        catch {
            Write-Verbose "An error occurred in adding database $databaseName to AG $agName" -Verbose
            Write-Verbose $_ -Verbose
            break    
        }
    }
}
Export-ModuleMember -Function add-PrimaryAG

function add-SecondaryAG {
    [cmdletbinding(SupportsShouldProcess=$True)] 
    PARAM(
        [string] $serverNamePrimary, 
        [string] $serverNameSecondary,
        [string] $databaseName,
        [string] $agName,
        [string] $compatibilityLevel = 130, # compute based on MSDB or MASTER?
        [bool] $dryRun = $true
    )

    #Variables - SQL Statements
    $setRecovery = "RESTORE DATABASE $databaseName WITH RECOVERY;"
    $setAuthorization = "ALTER AUTHORIZATION ON DATABASE::[$databaseName] TO [sa];"
    $setCompatibilityLevel = "ALTER DATABASE [$databaseName] SET COMPATIBILITY_LEVEL = $compatibilityLevel;"
    $addDatabaseToAG = "ALTER AVAILABILITY GROUP [$agName] ADD DATABASE [$databaseName];"
    $addSecondaryDatabaseToAG = "ALTER DATABASE [$databaseName] SET HADR AVAILABILITY GROUP = [$agName];"
    $checkStatus = "SELECT sd.name, 
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
    WHERE sd.name = '$databaseName'"

    IF($dryRun){
        Write-Host "Starting Add Database $databaseName To Secondary"
    }
    ELSE{
        try {
            Write-Verbose "Starting Add Database $databaseName To Secondary" -Verbose
            Invoke-Sqlcmd -ServerInstance $serverNameSecondary -Query $addSecondaryDatabaseToAG -QueryTimeout 0 -ConnectionTimeout 0 -Verbose 
        }
        catch {
            Write-Verbose "An error occurred in adding database $databaseName to secondary" -Verbose
            Write-Verbose $_ -Verbose
            break     
        }
    }

    IF($dryRun){
        Write-Host "Checking database $databaseName for AG status"
    }
    ELSE{
        try {
            #Check status of database
            Start-Sleep -Seconds 10

            Write-Verbose "Checking database $databaseName for AG status" -Verbose
            $results = Invoke-Sqlcmd -ServerInstance $serverNamePrimary -Query $checkStatus -QueryTimeout 0 -ConnectionTimeout 0 -Verbose
        }
        catch {
            Write-Verbose "An error occurred in checking database $databaseName for AG status" -Verbose
            Write-Verbose $_ -Verbose
            break     
        }
    }

    IF($dryRun){
        Write-Host "[DryRun] No data for database $databaseName for AG status"
    }
    ELSE{
        if (!$results) {
            Write-Host "STATUS PROBLEM" -ForegroundColor Red 
            Write-Verbose "No data for database $databaseName for AG status" -Verbose
        }
        else {
            ForEach ($item in $results) {
                $results = New-Object PSObject -Property @{
                    name                        = $item.name
                    AGName                      = $item.AGName
                    replica_server_name         = $item.replica_server_name
                    synchronization_health_desc = $item.synchronization_health_desc
                    synchronization_state_desc  = $item.synchronization_state_desc
                    database_state_desc         = $item.database_state_desc
                    is_primary_replica          = $item.is_primary_replica
                }
    
                #$results | Select-Object name, AGName,replica_server_name,synchronization_health_desc,synchronization_state_desc,database_state_desc,is_primary_replica | Format-Table -AutoSize

                ForEach ($status in $results) {
                    If ($status.synchronization_health_desc -eq "HEALTHY" -and $status.synchronization_state_desc -eq "SYNCHRONIZED" ) {
                        Write-Host $status.name, $status.AGName, $status.replica_server_name, $status.synchronization_health_desc, $status.synchronization_state_desc, $status.database_state_desc, $status.is_primary_replica -ForeGroundColor Green
                    }
                    else {
                        Write-Host "CHECK DATABASE STATUS" -ForegroundColor Red
                        Write-Host $status.name, $status.AGName, $status.replica_server_name, $status.synchronization_health_desc, $status.synchronization_state_desc, $status.database_state_desc, $status.is_primary_replica -ForeGroundColor Red 
                    }
                } #  ForEach ($status in $results)
            } # ForEach ($item in $results)
        }
    }
}
Export-ModuleMember -Function add-SecondaryAG

#[System.Reflection.Assembly]::LoadWithPartialName('Microsoft.SqlServer.SqlWmiManagement')| Out-Null
function Set-SQLStartupParameters{
    [cmdletbinding(SupportsShouldProcess=$true)]
    Param(  [string[]] $InstanceList,
            [string[]] $StartupParameters
        )
    [bool]$SystemPaths = $false

    #Loop through and change instances
    foreach( $instance in $InstanceList ){
        if( $StartupParameters.Count -eq 0  ){
            $selectSQL = "SELECT TraceFlag FROM DBA.info.traceFlag"
            try{ 
                $StartupParameters = @(Invoke-Sqlcmd -ServerInstance $instance -Query $selectSQL -QueryTimeout 65535 -ErrorAction 'Stop' | select -exp TraceFlag )
            }
            catch{
                Write-Host `t"[ALERT] FAILED TO QUERY !!!!" -ForegroundColor Red 
                Write-Host `t"$($selectSQL)"
                ### record information or raise alert?
                Write-Host `t"error: $_"
            }
        }

        if( $StartupParameters.Count -ne 0  ){
            Write-Verbose "[] No Parameters Supplied - getting values from [DBA]"
           
            #Parse host and instance names
            $HostName = ($instance.Split('\'))[0]
            $InstanceName = ($instance.Split('\'))[1]

            #Get service account names, set service account for change
            $ServiceName = if($InstanceName){"MSSQL`$$InstanceName"}else{'MSSQLSERVER'}
            TRY{
                #Use wmi to change account
                $smowmi = New-Object Microsoft.SqlServer.Management.Smo.Wmi.ManagedComputer $HostName
                $wmisvc = $smowmi.Services | Where-Object {$_.Name -eq $ServiceName}

                Write-verbose "[] Old Parameters for $instance :"
                Write-verbose $wmisvc.StartupParameters

                #Wrangle updated params with existing startup params (-d,-e,-l)
                $oldparams = $wmisvc.StartupParameters -split ';'
                $newparams = @()
                foreach($param in $StartupParameters){
                    if($param.Substring(0,2) -match '-d|-e|-l'){
                        $SystemPaths = $true
                        $newparams += $param
                        $oldparams = $oldparams | Where-Object {$_.Substring(0,2) -ne $param.Substring(0,2)}
                    }
                    else{
                        $newparams += "-T$param"
                    }
                }

                Write-Host "[] Values defined for this instance."
                $newparams += $oldparams | Where-Object {$_.Substring(0,2) -match '-d|-e|-l'}
                foreach( $param in $($newparams | Sort-Object) ){
                    write-host `t"$param" 
                }
                $paramstring = ($newparams | Sort-Object) -join ';'

                Write-Verbose "[] New Parameters for $instance :"
                Write-Verbose $paramstring
                Write-Verbose " "

                #If not -WhatIf, apply the change. Otherwise display an informational message.
                if($PSCmdlet.ShouldProcess($instance,$paramstring)){
                    $wmisvc.StartupParameters = "$paramstring"
                    $wmisvc.Alter()

                    Write-Warning "Startup Parameters for $instance updated. You will need to restart the service for these changes to take effect."
                    If($SystemPaths){Write-Warning "You have changed the system paths for $instance. Please make sure the paths are valid before restarting the service"}
                    RETURN 1
                }
            }
            Catch{
                 Write-Host `t"error: $_" -ForegroundColor Red 
                 RETURN 3
            }
        }
        else{
            Write-Verbose "No Trace Flags defined [DBA].[INFO].[TraceFlag]"
            RETURN 1
        }
    } # foreach($instance in $InstanceList)
}
Export-ModuleMember -Function Set-SQLStartupParameters

function set-jobOwner {
    [cmdletbinding(SupportsShouldProcess=$True)]
    PARAM(
        [string] $targetDB, 
        [string] $targetInstance, 
        [boolean] $dryRun 
    )
$updateSQL = "
USE master;
GO
?
DECLARE @jobName VARCHAR(1000)
DECLARE jobCursor CURSOR
FOR
SELECT [name] FROM msdb.dbo.sysjobs 
?
OPEN jobCursor
FETCH NEXT FROM jobCursor INTO @jobName
WHILE (@@FETCH_STATUS = 0)
	BEGIN
        if( 'true' = '$($dryRun)')
            begin
                print ' msdb..sp_update_job @job_name = '+ @jobName +', @owner_login_name = ''sa'''
            end
        else
            begin
		        exec msdb..sp_update_job @job_name = @jobName, @owner_login_name = 'sa'
            end
		FETCH NEXT FROM jobCursor INTO @jobName
	END 
CLOSE jobCursor
DEALLOCATE jobCursor
"
    WRITE-VERBOSE "Invoke-Sqlcmd -ServerInstance $targetInstance -Database MASTER -Query $updateSQL -ErrorAction SilentlyContinue -verbose"
    TRY
        {
	        Invoke-Sqlcmd -ServerInstance $targetInstance -Database MASTER -Query $updateSQL -ErrorAction SilentlyContinue 
        }
    CATCH
        {
            Write-Host `t"[ALERT] FAILED TO UPDATE!!!!" -ForegroundColor Red 
            Write-Host `t"$($updateSQL)"
            ### record information or raise alert?
            Write-Host `t"error: $_"
        }

}
#Export-ModuleMember -Function Set-SQLStartupParameters

function get-InstInfo( [string] $TargetInstance, [Object[]]$ProcessInfo ){

    $selectSQL = "EXEC DBA.info.GetInstance; SELECT * FROM DBA.info.Instance --lazy coding"
    TRY{
        write-verbose "
        $($selectSQL)"
        Invoke-Sqlcmd -ServerInstance $TargetInstance -Database MASTER -Query $selectSQL -QueryTimeout 65535 -ErrorAction 'Stop' 
    }
    CATCH{
        Write-Host `t"[ALERT] FAILED TO QUERY INSTANCE!!!!" -ForegroundColor Red 
        Write-Host `t"$($updateSQL)"
        ### record information or raise alert?
        Write-Host `t"error: $_"
    }

}

