DECLARE @allocation_unit_id1 VARCHAR(100) ='72060894499569664',
        @allocation_unit_id2 VARCHAR(100) ='72060894482792448',
        @DBName              VARCHAR(255)= 'Unitrac',
        @sqlcmd              VARCHAR(max),
        @DryRun              INT = 0

SELECT @sqlcmd = 'USE ' + @DBName
                 + '


SELECT au.allocation_unit_id, OBJECT_NAME(p.object_id) AS table_name, fg.name AS filegroup_name,  

au.type_desc AS allocation_type, au.data_pages, partition_number  

FROM sys.allocation_units AS au  

JOIN sys.partitions AS p ON au.container_id = p.partition_id  

JOIN sys.filegroups AS fg ON fg.data_space_id = au.data_space_id  

WHERE au.allocation_unit_id = '''
                 + @allocation_unit_id1
                 + ''' OR au.allocation_unit_id = '''
                 + @allocation_unit_id2
                 + '''

ORDER BY au.allocation_unit_id;'

IF @DryRun = 0
  BEGIN
      EXEC ( @SQLcmd)
  END
ELSE
  BEGIN
      PRINT ( @SQLcmd )
  END 
