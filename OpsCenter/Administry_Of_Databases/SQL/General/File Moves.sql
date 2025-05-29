--New Location


SELECT *
FROM sys.master_files f
where (database_id >=5 )
AND physical_name like '%F:%'

--Offline
SELECT CONCAT( 'ALTER DATABASE [',name, '] SET OFFLINE')
				  FROM sys.master_files f
where (database_id >=5 )
AND TYPE = '0'


--Update Data files & Log Files 
DECLARE @LOGS nvarchar(1) = 'G'
DECLARE @DATA nvarchar(1) = 'F'

SELECT CONCAT( 'ALTER DATABASE [',name, '] MODIFY FILE ( NAME = ',name,', FILENAME = '''+@DATA +':SQLDATA\',name,'.mdf'')')
				  FROM sys.master_files f
where (database_id >=5 )
AND TYPE = '0'


SELECT CONCAT( 'ALTER DATABASE [',name, '] MODIFY FILE ( NAME = ',name,', FILENAME = '''+@LOGS +':\SQLLOGS\',name,'_log.ldf'')')
				  FROM sys.master_files f
where (database_id >=5 )
AND TYPE = '1'

--Bring Online
SELECT CONCAT( 'ALTER DATABASE [',name, '] SET ONLINE')
				  FROM sys.master_files f
where (database_id >=5 )
AND TYPE = '0'




