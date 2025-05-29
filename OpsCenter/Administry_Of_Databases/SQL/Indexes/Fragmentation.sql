DECLARE @dynamic_sql NVARCHAR(MAX);
DECLARE @cmd NVARCHAR(MAX)
DECLARE @DatabaseName VARCHAR(100)= '' --required
DECLARE @tablename NVARCHAR(100)= ''  --required or silent failure
DECLARE @index_name VARCHAR(100)= ''
DECLARE @MIN VARCHAR(10) ='5';
DECLARE @MAX VARCHAR(10) = '35';
DECLARE @mode VARCHAR(10) ='LIMITED'; --modes are (LIMITED/SAMPLED/DETAILED)
DECLARE @DryRun INT = 0;

SELECT @dynamic_sql = '
use [' + @DatabaseName
                      + ']
DECLARE @object_id INT;
DECLARE @index_name VARCHAR(100)= '''
                      + @index_name + '''
DECLARE @MIN INT =''' + @MIN
                      + ''';
DECLARE @MAX INT = ''' + @MAX
                      + ''';
DECLARE @db_id SMALLINT= Db_id('''
                      + @DatabaseName
                      + ''');
DECLARE @mode VARCHAR(10) =''' + @mode
                      + ''';--modes are (LIMITED/SAMPLED/DETAILED)


-- Replace ''YourTableName'' with the actual table name you want to query
SELECT @object_id = OBJECT_ID('''
                      + @tablename + ''');

IF @object_id IS NULL
BEGIN
    PRINT N''Invalid object'';
END
ELSE
  BEGIN
      SELECT Object_name(IPS.object_id) AS [TableName],
             SI.name                    AS [IndexName],
             IPS.Index_type_desc,
             IPS.avg_fragmentation_in_percent,
                 ISNULL(IPS.fragment_count,0) AS fragment_count, 
            ISNULL(IPS.avg_fragment_size_in_pages,0) AS avg_fragment_size_in_pages, 
             CASE
               WHEN IPS.Index_type_desc IN (''NONCLUSTERED INDEX'', ''CLUSTERED INDEX'')
                    AND IPS.avg_fragmentation_in_percent BETWEEN @MIN AND @MAX THEN Concat(''BEGIN TRY   ALTER INDEX ['', SI.name, ''] ON ['', Object_name(IPS.object_id), ''] REORGANIZE 	  END TRY  
    BEGIN CATCH  PRINT ''''WARNING:  ['', SI.name, ''] ON ['', Object_name(IPS.object_id), ''] was not added either not in the correct database or index itself failed.'''' RETURN  END CATCH  '')
               WHEN IPS.Index_type_desc IN (''NONCLUSTERED INDEX'', ''CLUSTERED INDEX'')
                    AND IPS.avg_fragmentation_in_percent > @MAX THEN Concat(''BEGIN TRY ALTER INDEX ['', SI.name, ''] ON ['', Object_name(IPS.object_id), ''] REBUILD WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = ON, SORT_IN_TEMPDB = ON, ONLINE = ON, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)  END TRY  
    BEGIN CATCH  PRINT ''''WARNING:  ['', SI.name, ''] ON ['', Object_name(IPS.object_id), ''] was not added either not in the correct database or index itself failed.'''' RETURN  END CATCH  '')
        
		WHEN IPS.Index_type_desc = ''HEAP'' THEN Concat(''CANNOT REORGANIZE HEAPS on '', Object_name(IPS.object_id), ''!!!'')
                           ELSE Concat(''['', si.NAME, ''] DOES NOT CURRENTLY NEED TO BE REORGANIZED!!!'')
             END AS [Script to use], 
			  CASE
			 WHEN IPS.Index_type_desc = ''CLUSTERED INDEX'' AND IPS.avg_fragmentation_in_percent >= @MIN THEN Concat(''DO WE REALLY NEED TO REORG A CLUSTERED INDEX ON '', Object_name(IPS.object_id),''---'' ,''ALTER INDEX ['', SI.name, ''] ON ['',Object_name(IPS.object_id), ''] REORGANIZE'')
			 WHEN IPS.Index_type_desc = ''HEAP'' THEN Concat(''CANNOT REORGANIZE HEAPS on '', Object_name(IPS.object_id), ''!!!'')
			 ELSE 
			 CASE WHEN IPS.avg_fragmentation_in_percent >= @MIN  THEN 
			 ''Good Luck with your rebuild or REORG on ''+ Object_name(IPS.object_id)+'''' 	
			 ELSE Concat(''['', si.NAME, ''] DOES NOT CURRENTLY NEED TO BE REORGANIZED!!!'')
				END	 END AS [Suggestion]
      FROM   sys.Dm_db_index_physical_stats(@db_id, @object_id, NULL, NULL, @mode) AS IPS
             JOIN sys.tables ST WITH (nolock)
               ON IPS.object_id = ST.object_id
             JOIN sys.indexes SI WITH (nolock)
               ON IPS.object_id = SI.object_id
                  AND IPS.index_id = SI.index_id
      WHERE  ST.is_ms_shipped = 0
	  AND SI.name LIKE ''%''+ @index_name +''%''
      ORDER  BY 1,
                5
  END

';

IF @DryRun = 0
  BEGIN
      -- To execute the entire dynamic SQL block:
      EXEC (@dynamic_sql);
  END
ELSE
  BEGIN
      PRINT ( @dynamic_sql );
  END 
