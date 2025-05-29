DECLARE @SQLcmd VARCHAR(MAX)
DECLARE @DatabaseName NVARCHAR(50) = ''
DECLARE @mode VARCHAR(10)= 'LIMITED'
DECLARE @DryRun INT = 0



--For Disabled AutoGrowth or Unlimited Autogrowth it is set stats are mathematical expression is to the Current Size with the Unlimited it will grow as needed. 


SELECT @sqlcmd = '
use [' + @DatabaseName
                 + ']

SELECT DISTINCT 
OBJECT_NAME(IPS.object_id) TableName
, index_type_desc, index_level
, avg_fragmentation_in_percent,   SI.name                    AS [IndexName]
FROM [sys].[dm_db_index_physical_stats](DB_ID('''+@DatabaseName+'''), NULL, NULL, NULL, '''+@mode+''') IPS
JOIN sys.indexes SI WITH (nolock)
               ON IPS.object_id = SI.object_id
                  AND IPS.index_id = SI.index_id
WHERE avg_fragmentation_in_percent  >= ''30.''
 and IPS.Index_type_desc not in (''HEAP'', ''CLUSTERED INDEX'')'


IF @DryRun = 0
  BEGIN
      EXEC ( @SQLcmd)
  END
ELSE
  BEGIN
      PRINT ( @SQLcmd )
  END 
