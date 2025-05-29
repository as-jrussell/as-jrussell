--Update Data files & Log Files 
DECLARE @sqlcmd varchar(MAX)
DECLARE @LOGS nvarchar(1) = 'F'
DECLARE @DATA nvarchar(1) = 'F'



SELECT @sqlcmd ='
 CONCAT( ''ALTER DATABASE [''',name, '''] SET OFFLINE'')
				  FROM sys.master_files f
where (database_id >=5 )
AND type = ''0''

'

--PRINT ( @SQLcmd)




SELECT CONCAT( 'ALTER DATABASE [',name, '] MODIFY FILE ( NAME = ',name,', FILENAME = '''+@DATA +':SQLDATA\',name,'.mdf'')')
				  FROM sys.master_files f
where (database_id >=5 )
AND TYPE = '0'



SELECT CONCAT( 'ALTER DATABASE [',A.name, '] MODIFY FILE ( NAME = ',F.name,', FILENAME = '''+@LOGS +':\SQLLOGS\',A.name,'_log.ldf'')')
				  FROM sys.master_files f
				  Join  sys.master_files a on A.database_id = F.database_id
where (F.database_id >=5 )
AND F.TYPE = '1'
AND A.TYPE = '0'


--Bring Online
SELECT CONCAT( 'ALTER DATABASE [',name, '] SET ONLINE')
				  FROM sys.master_files f
where (database_id >=5 )
AND type = '0'




