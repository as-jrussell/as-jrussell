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
	, CONCAT ('USE [master] ALTER DATABASE ',  D.name,' MODIFY FILE ( NAME = N''', D.name,''', MAXSIZE =', CONVERT (INT,(((max_size/(128*1000)) *.25 + (max_size/(128*1000))))), 'GB)')
FROM sys.master_files A LEFT JOIN sys.filegroups fg ON A.data_space_id = fg.data_space_id
    join sys.databases D on D.database_id = A.database_id
WHERE max_size != '-1'
    and cast(round((((CAST(max_size/(128)  AS VARCHAR(10)) - CONVERT(DECIMAL(10,2),A.SIZE/128))/1000) /(CAST(max_size/(128*1000) AS VARCHAR(10)))),6,0) as decimal(10,6)) <='.25'
order by cast(round((((CAST(max_size/(128)  AS VARCHAR(10)) - CONVERT(DECIMAL(10,2),A.SIZE/128))/1000) /(CAST(max_size/(128*1000) AS VARCHAR(10)))),6,0) as decimal(10,6)) ASC, A.TYPE asc, A.NAME;
  
