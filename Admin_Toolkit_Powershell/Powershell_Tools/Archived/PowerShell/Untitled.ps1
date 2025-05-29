
#Load SQL Server snap-in
 ##If not Loaded, Please Load SQLServer Snapins Into PowerShell By Running The Following Cmdlets:
 #Import-Module SQLPS
 param
 (
 [string]$AgentStatus
 )
 $SQLserverDB=@()
 $InstanceName="DBPROX"
 [System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.SMO") | Out-Null
 [System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.Replication") | Out-Null
 [System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.RMO") | Out-Null
 #Add-PSSnapin SqlServerCmdletSnapin100
 # Add-PSSnapin SqlServerProviderSnapin100
 #Set-ExecutionPolicy RemoteSigned
 $RepInstanceObject = New-Object "Microsoft.SqlServer.Replication.ReplicationServer" "$InstanceName"
 $RepInstanceStatus = New-Object "Microsoft.SqlServer.Replication.ReplicationMonitor" "$InstanceName"
 
function Get-SnapshotAgentstatus
 {
 Write-Host ""
 Write-Host "[+]Snapshot Agent Current Status" -BackgroundColor Green -ForegroundColor Black
 Write-Host ""
 foreach($SMonitorServers in $RepInstanceStatus.EnumSnapshotAgents())
 {
 foreach($SMon in $SMonitorServers.Tables)
 {
 foreach($SnapshotAgent in $SMon | SELECT dbname,name,status,publisher,publisher_db,publication,subscriber,subscriber_db,starttime,time,duration,comments)
 {
 
Write-Host "dbname :" $SnapshotAgent.dbname
 Write-Host "Snapshot Agent :" $SnapshotAgent.name -ForegroundColor Green
 write-host "status :" $SnapshotAgent.status
 write-host "publisher :" $SnapshotAgent.publisher
 write-host "publisher_db :" $SnapshotAgent.publisher_db
 write-host "publication :" $SnapshotAgent.publication
 write-host "subscriber :" $SnapshotAgent.subscriber
 write-host "subscriber_db :" $SnapshotAgent.subscriber_db
 write-host "starttime :" $SnapshotAgent.starttime
 write-host "time :" $SnapshotAgent.time
 write-host "duration :" $SnapshotAgent.duration
 write-host "comments :" $SnapshotAgent.comments -ForegroundColor Green
 write-host "*********************************************************************"
 }
 }
 }
 }
 
function Get-LogReaderAgentstatus
 {
 Write-Host ""
 Write-Host "[+]LogReader Agent Current Status" -BackgroundColor Green -ForegroundColor Black
 Write-Host ""
 foreach($PMonitoreServers in $RepInstanceStatus.EnumLogReaderAgents())
 {
 foreach($PubMon in $PMonitoreServers.Tables)
 {
 foreach($LogAgent in $PubMon | SELECT dbname,name,status,publisher,publisher_db,publication,subscriber,subscriber_db,starttime,time,duration,comments)
 {
 Write-Host "dbname :" $LogAgent.dbname
 Write-Host "LogReader Agent :" $LogAgent.name -ForegroundColor Green
 write-host "status :" $LogAgent.status
 write-host "publisher :" $LogAgent.publisher
 write-host "publisher_db :" $LogAgent.publisher_db
 write-host "publication :" $LogAgent.publication
 write-host "subscriber :" $LogAgent.subscriber
 write-host "subscriber_db :" $LogAgent.subscriber_db
 write-host "starttime :" $LogAgent.starttime
 write-host "time :" $LogAgent.time
 write-host "duration :" $LogAgent.duration
 write-host "comments :" $LogAgent.comments -ForegroundColor Green
 write-host "*********************************************************************"
 }
 }
 }
 }
 function Get-DitributorAgentstatus
 {
 Write-Host ""
 Write-Host "[+]Distributor Agent Current Status" -BackgroundColor Yellow -ForegroundColor Black
 Write-Host ""
 foreach($DMonitorervers in $RepInstanceStatus.EnumDistributionAgents())
 {
 
foreach($DisMon in $DMonitorervers.Tables)
 {
 foreach($DisAgent in $DisMon | SELECT dbname,name,status,publisher,publisher_db,publication,subscriber,subscriber_db,starttime,time,duration,comments)
 {
 Write-Host "dbname :" $DisAgent.dbname
 Write-Host "Distributor Agent:" $DisAgent.name -ForegroundColor Yellow
 write-host "status :" $DisAgent.status
 write-host "publisher :" $DisAgent.publisher
 write-host "publisher_db :" $DisAgent.publisher_db
 write-host "publication :" $DisAgent.publication
 write-host "subscriber :" $DisAgent.subscriber
 write-host "subscriber_db :" $DisAgent.subscriber_db
 write-host "starttime :" $DisAgent.starttime
 write-host "time :" $DisAgent.time
 write-host "duration :" $DisAgent.duration
 write-host "comments :" $DisAgent.comments -ForegroundColor Yellow
 write-host "*********************************************************************"
 }
 }
 }
 }
 
if ($AgentStatus -eq "D")
 {
 Get-DitributorAgentstatus
 }
 elseif ($AgentStatus -eq "L")
 {
 Get-LogReaderAgentstatus
 }
 elseif ($AgentStatus -eq "S")
 {
 Get-SnapshotAgentstatus
 }
 else
 {
 Get-DitributorAgentstatus
 Get-LogReaderAgentstatus
 Get-SnapshotAgentstatus
 
}
