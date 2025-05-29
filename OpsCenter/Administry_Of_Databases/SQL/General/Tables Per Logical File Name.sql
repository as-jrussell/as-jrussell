DECLARE @sqlcmd       VARCHAR(max),
        @DatabaseName VARCHAR(100) ='Unitrac',
        @name         VARCHAR(100) = '',
		@Table_Name   VARCHAR(250) = 'OWNER_LOAN_RELATE'
DECLARE @DryRun INT = 0

SELECT @sqlcmd = '
use [' + @DatabaseName + ']


;WITH pages_rows AS(
select 
    OBJECT_NAME(p.object_id) as my_table_name, 
    u.type_desc,
    f.file_id,
    f.name,
    f.physical_name,
    f.size,
    f.max_size,
    f.growth,
    u.total_pages,
    u.used_pages,
    u.data_pages,
    p.partition_id,
    p.rows
from sys.allocation_units u 
    join sys.database_files f on u.data_space_id = f.data_space_id 
    join sys.partitions p on u.container_id = p.hobt_id),

	other AS (

 
SELECT  OBJECT_NAME(i.object_id)   AS [Table_Name]
       ----, i.indid
       , i.index_id
	     , d.name AS [Logical Name]
		 
       ----,CASE  i.indid
       ,CASE  i.type
            WHEN 0 THEN ''Heap''
            WHEN 1 THEN ''Clustered''
            WHEN 2 THEN ''Non Clustered''
            WHEN 3 THEN ''XML''
            WHEN 4 THEN ''Spatial''
            WHEN 5 THEN ''Clustered columnstore''
            WHEN 6 THEN ''Nonclustered columnstore''
            WHEN 7 THEN ''Nonclustered hash''
            ELSE ''Non Clustered''
        END AS Type
       , i.[name]           AS [Index_Name]
       ----, i.groupid
       , i.data_space_id
       , f.name             AS [File_Group]
       , d.physical_name    AS [File_Name]
       , s.name             AS [Data_Space]
       , CASE f.is_read_only
            WHEN 1 THEN ''read-only''
            WHEN 0 THEN ''read/write''
        END AS IsReadOnly 
    FROM sys.indexes i
        INNER JOIN sys.filegroups f ON (f.data_space_id = i.data_space_id)
        INNER JOIN sys.database_files d ON (f.data_space_id = d.data_space_id)
        INNER JOIN sys.data_spaces s ON (f.data_space_id = s.data_space_id)
WHERE OBJECTPROPERTY(i.object_id, ''IsUserTable'') = 1)



select DISTINCT Table_Name,Type,name,physical_name,total_pages,used_pages,data_pages,rows,IsReadOnly
from pages_rows P
join other R on P.my_table_name = R.Table_Name
WHERE name  like ''%'+ @Name + '%''
AND 
TABLE_NAME  like ''%'+ @Table_Name + '%''
ORDER BY used_pages DESC 
'

IF @DryRun = 0
  BEGIN
      EXEC ( @SQLcmd)
  END
ELSE
  BEGIN
      PRINT ( @SQLcmd )
  END 
