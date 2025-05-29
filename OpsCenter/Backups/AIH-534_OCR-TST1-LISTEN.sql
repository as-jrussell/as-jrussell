--OCR-TST1-LISTEN

--Full
BACKUP DATABASE [OCR] TO
DISK = '\\IGNITE-SQL14\i$\Restores\OCR-SQLTST-01\OCR.Bak'
WITH INIT , NOUNLOAD , NAME = 'OCR_Backup', NOSKIP , STATS = 10, COMPRESSION, NOFORMAT



--Logs
BACKUP LOG [OCR]
TO DISK = '\\IGNITE-SQL14\i$\Restores\OCR-SQLTST-01\OCR.LOG'




--OCR-SQLTMP-01

---Fulls
  RESTORE DATABASE [OCR]
  FROM  DISK = N'\\IGNITE-SQL14\i$\Restores\OCR-SQLTST-01\OCR.Bak' --WITH  FILE = 1,  NOUNLOAD,  STATS = 5
WITH  FILE = 1, RECOVERY,  NOUNLOAD,  STATS = 5
  GO


BACKUP DATABASE [OCR] TO
DISK = '\\IGNITE-SQL14\i$\Restores\OCR-SQLTST-01\OCR.Bak'
WITH INIT , NOUNLOAD , NAME = 'OCR_Backup', NOSKIP , STATS = 10, COMPRESSION, NOFORMAT



--Logs
BACKUP LOG [OCR]
TO DISK = '\\IGNITE-SQL14\i$\Restores\OCR-SQLTST-01\OCR.LOG'



 --OCR-SQLTMP-02

 

---Fulls
  RESTORE DATABASE [OCR]
  FROM  DISK = N'\\IGNITE-SQL14\i$\Restores\OCR-SQLTST-01\OCR.Bak' --WITH  FILE = 1,  NOUNLOAD,  STATS = 5
WITH  FILE = 1, NORECOVERY,  NOUNLOAD,  STATS = 5
  GO




---LOGS

RESTORE LOG [OCR] FROM DISK =  '\\IGNITE-SQL14\i$\Restores\OCR-SQLTST-01\OCR.LOG' WITH NORECOVERY;


--OCR-TST1-LISTEN
--- YOU MUST EXECUTE THE FOLLOWING SCRIPT IN SQLCMD MODE.
:Connect OCR-TMP-LISTEN1

USE [master]

GO

ALTER AVAILABILITY GROUP [OCR-TMP-AG]
ADD DATABASE [OCR];

GO


GO


---OCR-SQLTMP-02

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
    select @group_id = ags.group_id from master.sys.availability_groups as ags where name = N'OCR-TMP-AG'
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
ALTER DATABASE [OCR] SET HADR AVAILABILITY GROUP = [OCR-TMP-AG];

GO


