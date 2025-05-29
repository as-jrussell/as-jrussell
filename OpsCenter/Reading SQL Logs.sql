IF Object_id(N'tempdb..#IOWarningResults') IS NOT NULL
  DROP TABLE #IOWarningResults

CREATE TABLE #IOWarningResults
  (
     LogDate     DATETIME,
     ProcessInfo SYSNAME,
     LogText     NVARCHAR(max)
  );

IF EXISTS (SELECT *
           FROM   sys.databases
           WHERE  name = 'rdsadmin')
  BEGIN
      INSERT INTO #IOWarningResults
      EXEC rdsadmin.dbo.Rds_read_error_log
        @index = 0,
        @type = 1;

      INSERT INTO #IOWarningResults
      EXEC rdsadmin.dbo.Rds_read_error_log
        @index = 1,
        @type = 1;

      INSERT INTO #IOWarningResults
      EXEC rdsadmin.dbo.Rds_read_error_log
        @index = 2,
        @type = 1;

      INSERT INTO #IOWarningResults
      EXEC rdsadmin.dbo.Rds_read_error_log
        @index = 0,
        @type = 2;
  END
ELSE IF EXISTS (select * from sys.database_files  where physical_name like 'https%')
  BEGIN
      INSERT INTO #IOWarningResults
        EXEC Xp_readerrorlog
        0,
        1,
        N'';

      INSERT INTO #IOWarningResults
      EXEC Xp_readerrorlog
        1,
        1,
        N'';

      INSERT INTO #IOWarningResults
      EXEC Xp_readerrorlog
        0,
        2,
        N'';
 END
ELSE
  BEGIN
      INSERT INTO #IOWarningResults
      EXEC Xp_readerrorlog
        0,
        1,
        N'';

      INSERT INTO #IOWarningResults
      EXEC Xp_readerrorlog
        1,
        1,
        N'';

      INSERT INTO #IOWarningResults
      EXEC Xp_readerrorlog
        2,
        1,
        N'';

      INSERT INTO #IOWarningResults
      EXEC Xp_readerrorlog
        3,
        1,
        N'';

		      INSERT INTO #IOWarningResults
      EXEC Xp_readerrorlog
        4,
        1,
        N'';

		      INSERT INTO #IOWarningResults
      EXEC Xp_readerrorlog
        5,
        1,
        N'';
		      INSERT INTO #IOWarningResults
      EXEC Xp_readerrorlog
        6,
        1,
        N'';		       





  END

SELECT  
  --FORMAT(LogDate, 'dddd, MMMM dd, yyyy hh:mm tt'),
  logdate,
 ProcessInfo, LogText
--SELECT  LogText, COUNT(*)
FROM   #IOWarningResults
--WHERE ProcessInfo not in ('Logon','Backup')
--WHERE processinfo in ('Logon') 
--GROUP BY LogText 
order by logdate desc 




--Login failed for user 'ELDREDGE_A\SQL2000'. Reason: Failed to open the explicitly specified database. [CLIENT: <local machine>]  






/*




SELECT *
FROM #IOWarningResults
Where logtext in ('') 
ORDER BY LogDate DESC 

select GETDATE()

SELECT MIN(LogDate)
FROM #IOWarningResults
ORDER BY LogDate DESC 



SELECT DISTINCT 
    FORMAT(LogDate, 'yyyy-MM-dd') AS [Date], 
    LEFT(LogText, CHARINDEX(' database', LogText) - 1) AS [LogText], 
    COUNT(*) AS [Count]
FROM #IOWarningResults
WHERE ProcessInfo IN ('Logon') 
    AND LogText LIKE '%quorum%'
GROUP BY FORMAT(LogDate, 'yyyy-MM-dd'), 
         LEFT(LogText, CHARINDEX(' database', LogText) - 1)
		 ORDER BY FORMAT(LogDate, 'yyyy-MM-dd') ASC
*/

		  

/*
		 SELECT CASE logtext
   
    WHEN 'Error: 35206, Severity: 16.' THEN 'Error 35206: Availability Group Manager detected a problem. Check the SQL Server error log and the Always On Availability Groups health events.'
    WHEN 'Error: 35250, Severity: 16.' THEN 'Error 35250: Availability Group join process encountered an issue. Review the SQL Server error logs on both primary and secondary replicas, and verify network connectivity.'
    WHEN 'Error: 701, Severity: 17, State: 123.' THEN 'Error 701: Insufficient memory to run the query. Investigate memory pressure on the server and consider increasing available memory or optimizing the query.'
    WHEN 'Error: 845, Severity: 17.' THEN 'Error 845: Database startup or recovery failed. Examine the SQL Server error log for detailed reasons and potential corruption issues.'
    WHEN 'Error: 35264, Severity: 16.' THEN 'Error 35264: An issue occurred with an Availability Group replica. Check the health status of the Availability Group and the SQL Server error log on the affected replica.'
    WHEN 'Error: 35273, Severity: 16.' THEN 'Error 35273: A problem was detected within the Availability Group. Review the Always On Availability Groups dashboard and the SQL Server error logs on all replicas.'
    WHEN 'Error: 1069.' THEN 'Error 1069: An internal error occurred in the database engine. Consult the SQL Server error log for specific details and consider applying the latest cumulative updates.'
    WHEN 'Error: 1254.' THEN 'Error 1254: An error occurred while accessing a file. Verify file permissions and ensure the file path is correct and accessible.'
    WHEN 'Error: 17120.' THEN 'Error 17120: SQL Server could not start one or more services. Check the Windows Event Viewer and the SQL Server Configuration Manager for service status and error details.'
    WHEN 'Error: 18456, Severity: 14, State: 38.' THEN 'Error 18456 (State 38): Login failed due to a problem with the server SPN. Verify the correct SPNs are registered for the SQL Server service account using `setspn -L <domain\account>`.'
    WHEN 'Error: 41009.' THEN 'Error 41009: An error occurred while communicating with the SQL Server Reporting Services server. Check the SSRS configuration and logs for connectivity issues.'
    WHEN 'Error: 19421, Severity: 16, State: 1.' THEN 'Error 19421: Write operation attempted on a read-only secondary replica. Ensure write operations are directed to the primary replica of the Availability Group.'
    WHEN 'Error: 35250, Severity: 16, State: 11.' THEN 'Error 35250 (State 11): Error occurred while joining a secondary replica to the Availability Group. Review the SQL Server error logs on both servers and check network connectivity and firewall rules.'
    WHEN 'Error: 19407, Severity: 16, State: 1.' THEN 'Error 19407: Attempted to access a resource requiring the primary replica when not connected to it. Verify the current primary replica and ensure connections are routed correctly.'
	ELSE 'Unknown Error' 
END, COUNT(*) [Count], FORMAT(LogDate, 'yyyy-MM-dd hh:mm:ss tt') AS [Date],
case when logtext like 'Error%' then 'DOWN'
WHEN LOGTEXT LIKE 'A connection for availability group%' then 'UP'
else null
end [Status]
FROM #IOWarningResults
WHERE 
logtext IN  (
    'Error: 35206, Severity: 16.',
    'Error: 35250, Severity: 16.',
    'Error: 701, Severity: 17, State: 123.',
    'Error: 845, Severity: 17.',
    'Error: 35264, Severity: 16.',
    'Error: 35273, Severity: 16.',
    'Error: 1069.',
    'Error: 1254.',
    'Error: 17120.',
    'Error: 18456, Severity: 14, State: 38.',
    'Error: 41009.',     'Error: 19421, Severity: 16, State: 1.',
    'Error: 35250, Severity: 16, State: 11.',
    'Error: 19407, Severity: 16, State: 1.'
) 
GROUP BY LogText , FORMAT(LogDate, 'yyyy-MM-dd hh:mm:ss tt')
UNION

SELECT LEFT(LogText, CHARINDEX(' This', LogText) - 1), 
COUNT(*) [Count],FORMAT(LogDate, 'yyyy-MM-dd hh:mm:ss tt') AS [Date],
case when logtext like 'Error%' then 'DOWN'
WHEN LOGTEXT LIKE 'A connection for availability group%' then 'UP'
else null
end [Status]
FROM #IOWarningResults
WHERE LogText LIKE '%has been successfully established.  This is an informational message only. No user action is required.'
GROUP BY LogText , FORMAT(LogDate, 'yyyy-MM-dd hh:mm:ss tt')
ORDER BY FORMAT(LogDate, 'yyyy-MM-dd hh:mm:ss tt')
;



SELECT
    CASE logtext
        WHEN 'Error: 35201, Severity: 16, State: 11.' THEN 'Error 35201: The connection to the primary replica is inactive. The command cannot be processed. Check network connectivity between replicas.'
        WHEN 'Error: 19407, Severity: 16, State: 1.' THEN 'Error 19407: The state of the local availability replica in availability group has changed from ''PRIMARY_NORMAL'' to ''RESOLVING_NORMAL''. Investigate network issues or primary replica health.'
        WHEN 'Error: 35202, Severity: 16, State: 14.' THEN 'Error 35202: A connection timeout occurred while attempting to establish a connection to the secondary replica. Verify the secondary server is running and accessible.'
        WHEN 'Error: 14421.' THEN 'Error 14421: The server network address cannot be reached or does not exist. Check the network name and endpoint configuration.'
        WHEN 'Error: 1135.' THEN 'Error 1135: Cluster node was removed from the active failover cluster membership. Investigate cluster health and network stability.'
        WHEN 'Error: 41021, Severity: 16.' THEN 'Error 41021: The Windows Server Failover Clustering (WSFC) cluster quorum was lost. Address quorum issues in the WSFC cluster.'
        WHEN 'Error: 41001, Severity: 16.' THEN 'Error 41001: The Windows Server Failover Clustering (WSFC) service is stopping. Availability Group Manager is shutting down. Investigate WSFC service health.'
        WHEN 'Error: 41066, Severity: 16.' THEN 'Error 41066: The lease between availability group and Windows Server Failover Clustering (WSFC) cluster has expired. Check primary replica health and WSFC communication.'
        WHEN 'AlwaysOn: The local replica of availability group ‘AGName’ is in a failed state. The replica will be removed from the availability group.' THEN 'Error: Local replica of availability group is in a failed state. The replica will be removed from the availability group. Investigate the health of the local replica.'
        WHEN 'Error: 917.' THEN 'Error 917: The server instance participated in an availability group and is now restarting. Verify other instances in the AG are running.'
        WHEN 'Error: 1469.' THEN 'Error 1469: The SQL Server service terminated unexpectedly. Review the SQL Server error logs and Windows Event Viewer for details.'
        WHEN 'Error: 35206, Severity: 16.' THEN 'Error 35206: The connection to the secondary replica is inactive. Check network connectivity to the secondary replica.'
        WHEN 'Error: 29016, Severity: 16, State: 1.' THEN 'Error 29016: The remote copy of database is not available. Try the operation later and check the secondary replica health.'
        WHEN 'Error: 701, Severity: 17, State: 123.' THEN 'Error 701: There is insufficient system memory in resource pool ''internal'' to run this query. Investigate memory pressure on the server.'
        WHEN 'Error: 845, Severity: 17.' THEN 'Error 845: Time-out occurred while waiting for buffer latch. Investigate potential I/O bottlenecks or memory pressure.'
        WHEN 'Error: 35264, Severity: 16.' THEN 'Error 35264: AlwaysOn Availability Groups connection with primary database terminated. Check network connectivity and primary replica health.'
        WHEN 'Error: 35273, Severity: 16.' THEN 'Error 35273: The connection between availability replicas is no longer available. Investigate network issues between replicas.'
        WHEN 'Error: 9003, Severity: 20, State: 1.' THEN 'Error 9003: The log scan number (LSN) passed to log scan in database is not valid. This may indicate data corruption or log file mismatch. Consider restoring from backup.'
        WHEN 'Error: 35251, Severity: 16.' THEN 'Error 35251: Availability replica for availability group is not receiving data. It is waiting to receive log records. Check network connectivity and synchronization status.'
        WHEN 'Error: 17310, Severity: 16, State: 1.' THEN 'Error 17310: The database has been marked suspect and is in a state which prevents recovery, or a file access error has occurred. Diagnose and correct the error, and recover the database.'
        WHEN 'Error: 1069.' THEN 'Error 1069: Cluster resource failed. Review the Failover Cluster Manager for details on the failed resource.'
        WHEN 'Error: 1254.' THEN 'Error 1254: Clustered role has exceeded its failover threshold. Investigate the underlying causes of the repeated failures.'
        WHEN 'Error: 1001.' THEN 'Error 1001: The Cluster service terminated unexpectedly. Review the System event log for details on the cluster service failure.'
        WHEN 'Error: 17120.' THEN 'Error 17120: SQL Server could not spawn AlwaysOn Lease Worker thread. This may indicate resource issues or problems with the SQL Server instance.'
        WHEN 'Error: 18456, Severity: 14, State: 38.' THEN 'Error 18456 (State 38): Login failed for user. Reason: Failed to open the explicitly specified database. Verify database availability and user permissions.'
        WHEN 'Error: 17189.' THEN 'Error 17189: SQL Server is terminating in response to a system shutdown event.'
        WHEN 'Error: 41009.' THEN 'Error 41009: The lease of availability group has expired due to unavailability of lease renewal messages. Check primary replica health and network communication with the WSFC cluster.'
        WHEN 'Error: 41305, Severity: 16.' THEN 'Error 41305: Availability Group Manager has detected that the local availability replica is not healthy. The replica is trying to rejoin the availability group. Investigate the health of the local replica.'
        WHEN 'Error: 35258, Severity: 16.' THEN 'Error 35258: Availability Group Manager has detected that the availability replica has not sent a heartbeat within the timeout period. The replica will be marked as disconnected. Check network connectivity and replica health.'
        WHEN 'Error: 35250, Severity: 16.' THEN 'Error 35250: The availability group failed to start because the local availability replica is not ready. Ensure the local replica is started and in a healthy state.'
        WHEN 'Error: 15019, Severity: 16.' THEN 'Error 15019: The server principal is not correctly configured as an availability replica member. Verify the AG replica configuration.'
        WHEN 'Error: 35242, Severity: 16.' THEN 'Error 35242: The availability replica could not change its role. The operation failed because of an underlying issue. Review the SQL Server error log for details.'
        WHEN 'Error: 19406, Severity: 16, State: 1.' THEN 'Error 19406: The state of database in availability group has changed. Monitor database health and synchronization status.'
        WHEN 'Error: 945, Severity: 14, State: 2.' THEN 'Error 945: Database cannot be opened due to inaccessible files or insufficient memory or disk space. See the SQL Server error log for details.'
        WHEN 'Error: 4101, Severity: 16.' THEN 'Error 4101: Recovery failed for database on the local availability replica. The replica will be removed from the availability group. Investigate database recovery issues.'
        WHEN 'Error: 26023, Severity: 16.' THEN 'Informational: The server instance is listening on endpoint. While not an error, ensure the endpoint is configured correctly for AG communication.'
        WHEN 'Error: 26014, Severity: 16.' THEN 'Error 26014: Failed to start the listener for virtual network name on IP address and TCP port. Verify endpoint configuration and port availability.'
        WHEN 'Error: 3013, Severity: 16, State: 1.' THEN 'Error 3013: BACKUP DATABASE is terminating abnormally. Investigate backup failures as they can impact log truncation and AG health.'
        WHEN 'Error: 3167, Severity: 16, State: 1.' THEN 'Error 3167: The restore operation failed because of a mismatched LSN. Ensure restore sequence is correct on secondary replicas.'
        WHEN 'Error: 8645, Severity: 17.' THEN 'Error 8645: A time-out occurred while waiting for a thread to acquire its needed resources. This may indirectly impact AG stability due to resource contention.'
        WHEN 'Error: 9694, Severity: 20.' THEN 'Error 9694: An internal error occurred in the processing of the availability group command. Restart the SQL Server instance.'
        WHEN 'Error: 39999, Severity: 16.' THEN 'Error 39999: Distributed transaction completed. Ensure distributed transactions are handled correctly within the AG environment.'
        WHEN 'Error: 927, Severity: 14, State: 1.' THEN 'Error 927: Database cannot be opened. It is recovering. Prolonged recovery on a replica may indicate an issue.'
        ELSE 'Unknown Error'
    END AS ErrorDescription,
    COUNT(*) AS [Count],
   FORMAT(LogDate, 'yyyy-MM-dd hh:mm:ss tt') AS [Date],
   case when logtext like 'Error%' then 'DOWN'
WHEN LOGTEXT LIKE 'A connection for availability group%' then 'UP'
else null
end [Status]
FROM
    #IOWarningResults -- Assuming your log data is in this temporary table
WHERE
    logtext IN (
        'Error: 35201, Severity: 16, State: 11.',
        'Error: 19407, Severity: 16, State: 1.',
        'Error: 35202, Severity: 16, State: 14.',
        'Error: 14421.',
        'Error: 1135.',
        'Error: 41021, Severity: 16.',
        'Error: 41001, Severity: 16.',
        'Error: 41066, Severity: 16.',
        'AlwaysOn: The local replica of availability group ‘AGName’ is in a failed state. The replica will be removed from the availability group.',
        'Error: 917.',
        'Error: 1469.',
        'Error: 35206, Severity: 16.',
        'Error: 29016, Severity: 16, State: 1.',
        'Error: 701, Severity: 17, State: 123.',
        'Error: 845, Severity: 17.',
        'Error: 35264, Severity: 16.',
        'Error: 35273, Severity: 16.',
        'Error: 9003, Severity: 20, State: 1.',
        'Error: 35251, Severity: 16.',
        'Error: 17310, Severity: 16, State: 1.',
        'Error: 1069.',
        'Error: 1254.',
        'Error: 1001.',
        'Error: 17120.',
        'Error: 18456, Severity: 14, State: 38.',
        'Error: 17189.',
        'Error: 41009.',
        'Error: 41305, Severity: 16.',
        'Error: 35258, Severity: 16.',
        'Error: 35250, Severity: 16.',
        'Error: 15019, Severity: 16.',
        'Error: 35242, Severity: 16.',
        'Error: 19406, Severity: 16, State: 1.',
        'Error: 945, Severity: 14, State: 2.',
        'Error: 4101, Severity: 16.',
        'Error: 26023, Severity: 16.',
        'Error: 26014, Severity: 16.',
        'Error: 3013, Severity: 16, State: 1.',
        'Error: 3167, Severity: 16, State: 1.',
        'Error: 8645, Severity: 17.',
        'Error: 9694, Severity: 20.',
        'Error: 39999, Severity: 16.',
        'Error: 927, Severity: 14, State: 1.'
    )
GROUP BY LogText ,FORMAT(LogDate, 'yyyy-MM-dd hh:mm:ss tt')
UNION

SELECT LEFT(LogText, CHARINDEX(' This', LogText) - 1), 
COUNT(*) [Count],FORMAT(LogDate, 'yyyy-MM-dd hh:mm:ss tt') AS [Date],
case when logtext like 'Error%' then 'DOWN'
WHEN LOGTEXT LIKE 'A connection for availability group%' then 'UP'
else null
end [Status]
FROM #IOWarningResults
WHERE LogText LIKE '%has been successfully established.  This is an informational message only. No user action is required.'
GROUP BY LogText , FORMAT(LogDate, 'yyyy-MM-dd hh:mm:ss tt')
ORDER BY FORMAT(LogDate, 'yyyy-MM-dd hh:mm:ss tt') DESC






*/


	




