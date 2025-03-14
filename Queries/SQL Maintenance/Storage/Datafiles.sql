
SELECT 
	 @@servername as ServerName
    ,[TYPE] = A.TYPE_DESC
	,[Database_Name] = D.name
	, size/128 [File Size MB]
    ,[AutoGrow] = 'By ' + CASE is_percent_growth WHEN 0 THEN CAST(growth/128 AS VARCHAR(10)) + ' MB -' 
        WHEN 1 THEN CAST(growth AS VARCHAR(10)) + '% -' ELSE '' END 
        + CASE max_size WHEN 0 THEN 'DISABLED' WHEN -1 THEN ' Unrestricted' 
            ELSE ' Restricted to ' + CAST(max_size/(128*1024) AS VARCHAR(10)) + ' GB' END 
        + CASE is_percent_growth WHEN 1 THEN ' [autogrowth by percent, BAD setting!]' ELSE '' END
		, [Remaining Space GB ] =  CASE CAST(max_size/(128)  AS VARCHAR(10)) WHEN 0 THEN NULL 
		ELSE
		((CAST(max_size/(128)  AS VARCHAR(10)) - CONVERT(DECIMAL(10,2),A.SIZE/128))/1024) 
		END
		,[FILESIZE_GB] = (CONVERT(DECIMAL(10,2),A.SIZE/128.0)/1024)
	, [Remaining Space %] =cast(round((((CAST(max_size/(128)  AS VARCHAR(10)) - CONVERT(DECIMAL(10,2),A.SIZE/128))/1024) /(CAST(max_size/(128*1024) AS VARCHAR(10)))),6,0) as decimal(10,6))
FROM sys.master_files A LEFT JOIN sys.filegroups fg ON A.data_space_id = fg.data_space_id 
join sys.databases D on D.database_id = A.database_id
where (D.database_id >=5) 
and A.TYPE_DESC != 'FILESTREAM' and max_size != '-1'
and cast(round((((CAST(max_size/(128)  AS VARCHAR(10)) - CONVERT(DECIMAL(10,2),A.SIZE/128))/1024) /(CAST(max_size/(128*1024) AS VARCHAR(10)))),6,0) as decimal(10,6)) <='.15'
order by cast(round((((CAST(max_size/(128)  AS VARCHAR(10)) - CONVERT(DECIMAL(10,2),A.SIZE/128))/1024) /(CAST(max_size/(128*1024) AS VARCHAR(10)))),6,0) as decimal(10,6)) ASC, A.TYPE asc, A.NAME;





/*


select CONCAT('USE [master] ALTER DATABASE [',name, '] MODIFY FILE ( NAME = N''',name,'''',',  FILEGROWTH = 1024KB ) 
 ALTER DATABASE [',name, '] MODIFY FILE ( NAME = N''',name,'_LOG''',',  FILEGROWTH = 1024KB) ')

from sys.databases 
where (database_id >=5 AND  name != 'DBA') 



select CONCAT('USE [master] ALTER DATABASE [',name, '] MODIFY FILE ( NAME = N''',name,'''',', MAXSIZE = 5242880KB) 
 ALTER DATABASE [',name, '] MODIFY FILE ( NAME = N''',name,'_LOG''',', MAXSIZE = 5242880KB) ')

 

from sys.databases 
where (database_id >=5 AND  name != 'DBA') 


DECLARE @Size nvarchar (30) = '5242880KB'

select CONCAT('USE [master] ALTER DATABASE [',name, '] MODIFY FILE ( NAME = N''',name,'''',', MAXSIZE = '+ @Size + ') 
 ALTER DATABASE [',name, '] MODIFY FILE ( NAME = N''',name,'_LOG''',', MAXSIZE = '+ @Size + ') ')
 --select *
from sys.databases 
where (database_id >=5 AND  name != 'DBA') 


*/




