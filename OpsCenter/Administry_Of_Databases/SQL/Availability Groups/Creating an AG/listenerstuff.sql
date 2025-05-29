--Adding endpoint first

IF NOT EXISTS (SELECT * from sys.endpoints WHERE [name] = 'Hadr_endpoint')
    BEGIN
        CREATE ENDPOINT [Hadr_endpoint]
            STATE=STARTED
            AS TCP (LISTENER_PORT = 5022, LISTENER_IP = ALL)
            FOR DATA_MIRRORING (ROLE = ALL, AUTHENTICATION = WINDOWS NEGOTIATE
        , ENCRYPTION = REQUIRED ALGORITHM AES)
    END;




    use [master]

GO

GRANT CONNECT ON ENDPOINT::[Hadr_endpoint] TO [ELDREDGE_A\acctname]

GO


    IF (SELECT state FROM sys.endpoints WHERE name = N'Hadr_endpoint') <> 0
BEGIN
    ALTER ENDPOINT [Hadr_endpoint] STATE = STARTED
END
 



-- SELECT servicename, process_id, startup_type_desc, status_desc,
--last_startup_time, service_account
--FROM sys.dm_server_services WITH (NOLOCK) OPTION (RECOMPILE);


--- YOU MUST EXECUTE THE FOLLOWING SCRIPT IN SQLCMD MODE.
:Connect OCR-SQLTMP-03

IF (SELECT state FROM sys.endpoints WHERE name = N'Hadr_endpoint') <> 0
BEGIN
	ALTER ENDPOINT [Hadr_endpoint] STATE = STARTED
END


GO

use [master]

GO

GRANT CONNECT ON ENDPOINT::[Hadr_endpoint] TO [ELDREDGE_A\OCRSQL-TEST]

GO

:Connect OCR-SQLTMP-04

IF (SELECT state FROM sys.endpoints WHERE name = N'Hadr_endpoint') <> 0
BEGIN
	ALTER ENDPOINT [Hadr_endpoint] STATE = STARTED
END


GO

use [master]

GO

GRANT CONNECT ON ENDPOINT::[Hadr_endpoint] TO [ELDREDGE_A\OCRSQL-TEST]

GO

:Connect OCR-SQLTMP-03

IF EXISTS(SELECT * FROM sys.server_event_sessions WHERE name='AlwaysOn_health')
BEGIN
  ALTER EVENT SESSION [AlwaysOn_health] ON SERVER WITH (STARTUP_STATE=ON);
END
IF NOT EXISTS(SELECT * FROM sys.dm_xe_sessions WHERE name='AlwaysOn_health')
BEGIN
  ALTER EVENT SESSION [AlwaysOn_health] ON SERVER STATE=START;
END

GO

:Connect OCR-SQLTMP-04

IF EXISTS(SELECT * FROM sys.server_event_sessions WHERE name='AlwaysOn_health')
BEGIN
  ALTER EVENT SESSION [AlwaysOn_health] ON SERVER WITH (STARTUP_STATE=ON);
END
IF NOT EXISTS(SELECT * FROM sys.dm_xe_sessions WHERE name='AlwaysOn_health')
BEGIN
  ALTER EVENT SESSION [AlwaysOn_health] ON SERVER STATE=START;
END

GO

:Connect OCR-SQLTMP-03

USE [master]

GO

CREATE AVAILABILITY GROUP [OCR-TMP-AG2]
WITH (AUTOMATED_BACKUP_PREFERENCE = SECONDARY)
FOR DATABASE [Test_OCR_AG]
REPLICA ON N'OCR-SQLTMP-03' WITH (ENDPOINT_URL = N'TCP://OCR-SQLTMP-03.rd.as.local:5022', FAILOVER_MODE = MANUAL, AVAILABILITY_MODE = ASYNCHRONOUS_COMMIT, BACKUP_PRIORITY = 50, SECONDARY_ROLE(ALLOW_CONNECTIONS = NO)),
	N'OCR-SQLTMP-04' WITH (ENDPOINT_URL = N'TCP://OCR-SQLTMP-04.rd.as.local:5022', FAILOVER_MODE = MANUAL, AVAILABILITY_MODE = ASYNCHRONOUS_COMMIT, BACKUP_PRIORITY = 50, SECONDARY_ROLE(ALLOW_CONNECTIONS = NO));

GO

:Connect OCR-SQLTMP-04

ALTER AVAILABILITY GROUP [OCR-TMP-AG2] JOIN;

GO

:Connect OCR-SQLTMP-04


-- Wait for the replica to start communicating
begin try
declare @conn bit
declare @count int
declare @replica_id uniqueidentifier 
declare @group_id uniqueidentifier
set @conn = 0
set @count = 30 -- wait for 5 minutes 

if (serverproperty('IsHadrEnabled') = 1)
	and (isnull((select member_state from master.sys.dm_hadr_cluster_members where upper(member_name COLLATE Latin1_General_CI_AS) = upper(cast(serverproperty('ComputerNamePhysicalNetBIOS') as nvarchar(256)) COLLATE Latin1_General_CI_AS)), 0) <> 0)
	and (isnull((select state from master.sys.database_mirroring_endpoints), 1) = 0)
begin
    select @group_id = ags.group_id from master.sys.availability_groups as ags where name = N'OCR-TMP-AG2'
	select @replica_id = replicas.replica_id from master.sys.availability_replicas as replicas where upper(replicas.replica_server_name COLLATE Latin1_General_CI_AS) = upper(@@SERVERNAME COLLATE Latin1_General_CI_AS) and group_id = @group_id
	while @conn <> 1 and @count > 0
	begin
		set @conn = isnull((select connected_state from master.sys.dm_hadr_availability_replica_states as states where states.replica_id = @replica_id), 1)
		if @conn = 1
		begin
			-- exit loop when the replica is connected, or if the query cannot find the replica status
			break
		end
		waitfor delay '00:00:10'
		set @count = @count - 1
	end
end
end try
begin catch
	-- If the wait loop fails, do not stop execution of the alter database statement
end catch
ALTER DATABASE [Test_OCR_AG] SET HADR AVAILABILITY GROUP = [OCR-TMP-AG2];

GO


GO

USE [master]
GO
ALTER AVAILABILITY GROUP [OCR-TMP-AG2]
ADD LISTENER N'OCR-TMP-LISTEN2' (
WITH IP
((N'10.8.11.91', N'255.255.255.0')
)
, PORT=1433);
GO
