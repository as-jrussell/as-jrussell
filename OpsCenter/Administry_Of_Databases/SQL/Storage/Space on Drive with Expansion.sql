DECLARE @DBNAME nvarchar(100) = ''
DECLARE @size nvarchar(10) = ''
 
IF @DBNAME <> '' AND @size = ''
BEGIN

    SELECT
        @@servername as ServerName
    , [TYPE] = A.TYPE_DESC
	, [Database_Name] = D.name
    , [Current Size] = (max_size/(128*1000))
	, [Remaining Space GB ] =  CASE CAST(max_size/(128)  AS VARCHAR(10)) WHEN 0 THEN NULL 
		ELSE
		((CAST(max_size/(128)  AS VARCHAR(10)) - CONVERT(DECIMAL(10,2),A.SIZE/128))/1000) 
		END
	, [Used Space] = (CONVERT(DECIMAL(10,2),A.SIZE/128.0)/1000)
	, [Remaining Space %] =(cast(round((((CAST(max_size/(128)  AS VARCHAR(10)) - CONVERT(DECIMAL(10,2),A.SIZE/128))/1000) /(CAST(max_size/(128*1000) AS VARCHAR(10)))),6,0) as decimal(10,2))*100)
    , [Amount to meet threshold] = ((max_size/(128*1000)) *.25 )
    , [New size] =  ((max_size/(128*1000)) *.25 + (max_size/(128*1000)))
    , [When updated %]= CONVERT (INT,( (CONVERT(DECIMAL(10,2),A.SIZE/128.0)/1000)) / ((max_size/(128*1000)) *.25 + (max_size/(128*1000))) *100 )
	, CONCAT ('USE [master] IF EXISTS(select 1 from sys.databases where name = ''',d.name, ''') BEGIN ALTER DATABASE [',  D.name,'] MODIFY FILE ( NAME = N''', D.name,''', MAXSIZE =', CONVERT (INT,(((max_size/(128*1000)) *.25 + (max_size/(128*1000))))), 'GB) END')
    FROM sys.master_files A LEFT JOIN sys.filegroups fg ON A.data_space_id = fg.data_space_id
        join sys.databases D on D.database_id = A.database_id
    WHERE max_size != '-1'
        and D.name = @DBNAME
        order by cast(round((((CAST(max_size/(128)  AS VARCHAR(10)) - CONVERT(DECIMAL(10,2),A.SIZE/128))/1000) /(CAST(max_size/(128*1000) AS VARCHAR(10)))),6,0) as decimal(10,6)) ASC, A.TYPE asc, A.NAME;

END
ELSE IF @size <> '' AND  @DBNAME = ''
BEGIN 
	SELECT 
		 @@servername as ServerName
		,[TYPE] = A.TYPE_DESC
		,[Database_Name] = D.name
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
		, CONCAT ('USE [master] IF EXISTS(select 1 from sys.databases where name = ''',d.name, ''') BEGIN ALTER DATABASE [',  D.name,'] MODIFY FILE ( NAME = N''', D.name,''', MAXSIZE =', CONVERT (INT,(((max_size/(128*1000)) *.25 + (max_size/(128*1000))))), 'GB) END')
 	FROM sys.master_files A LEFT JOIN sys.filegroups fg ON A.data_space_id = fg.data_space_id 
	join sys.databases D on D.database_id = A.database_id
	WHERE max_size != '-1'
	and cast(round((((CAST(max_size/(128)  AS VARCHAR(10)) - CONVERT(DECIMAL(10,2),A.SIZE/128))/1024) /(CAST(max_size/(128*1024) AS VARCHAR(10)))),6,0) as decimal(10,6)) <= @size
		order by cast(round((((CAST(max_size/(128)  AS VARCHAR(10)) - CONVERT(DECIMAL(10,2),A.SIZE/128))/1024) /(CAST(max_size/(128*1024) AS VARCHAR(10)))),6,0) as decimal(10,6)) ASC, A.TYPE asc, A.NAME;
END	
ELSE  
 BEGIN
    SELECT
       @@servername as ServerName
    , [TYPE] = A.TYPE_DESC
	, [Database_Name] = D.name
    , [Current Size] = (max_size/(128*1000))
	, [Remaining Space GB ] =  CASE CAST(max_size/(128)  AS VARCHAR(10)) WHEN 0 THEN NULL 
		ELSE
		((CAST(max_size/(128)  AS VARCHAR(10)) - CONVERT(DECIMAL(10,2),A.SIZE/128))/1000) 
		END
	, [Used Space] = (CONVERT(DECIMAL(10,2),A.SIZE/128.0)/1000)
	, [Remaining Space %] =(cast(round((((CAST(max_size/(128)  AS VARCHAR(10)) - CONVERT(DECIMAL(10,2),A.SIZE/128))/1000) /(CAST(max_size/(128*1000) AS VARCHAR(10)))),6,0) as decimal(10,2))*100)
    , [Amount to meet threshold] = ((max_size/(128*1000)) *.25 )
    , [New size] =  ((max_size/(128*1000)) *.25 + (max_size/(128*1000)))
    , [When updated %]= CONVERT (INT,( (CONVERT(DECIMAL(10,2),A.SIZE/128.0)/1000)) / ((max_size/(128*1000)) *.25 + (max_size/(128*1000))) *100 )
	, CONCAT ('USE [master] IF EXISTS(select 1 from sys.databases where name = ''',d.name, ''') BEGIN ALTER DATABASE [',  D.name,'] MODIFY FILE ( NAME = N''', D.name,''', MAXSIZE =', CONVERT (INT,(((max_size/(128*1000)) *.25 + (max_size/(128*1000))))), 'GB) END')
    FROM sys.master_files A LEFT JOIN sys.filegroups fg ON A.data_space_id = fg.data_space_id
        join sys.databases D on D.database_id = A.database_id
    WHERE max_size != '-1'
         order by cast(round((((CAST(max_size/(128)  AS VARCHAR(10)) - CONVERT(DECIMAL(10,2),A.SIZE/128))/1000) /(CAST(max_size/(128*1000) AS VARCHAR(10)))),6,0) as decimal(10,6)) ASC, A.TYPE asc, A.NAME;
END 
	
