--Get Versions
SELECT @@VERSION AS 'SQL Server Version'

SELECT @@VERSION AS 'SQL Server Version'

--Product Information
SELECT
SERVERPROPERTY('ProductVersion') AS ProductVersion,
SERVERPROPERTY('ProductLevel') AS ProductLevel,
SERVERPROPERTY('Edition') AS Edition,
SERVERPROPERTY('EngineEdition') AS EngineEdition;
GO
--ServerName
SELECT @@SERVERNAME [DB installed on]


--reboot server
SELECT sqlserver_start_time FROM sys.dm_os_sys_info

select CURRENT_TIMESTAMP  


--exec dba.info.getinstance