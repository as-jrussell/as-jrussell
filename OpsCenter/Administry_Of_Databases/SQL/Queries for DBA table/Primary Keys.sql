DECLARE @sqlcmd       VARCHAR(max),
        @DatabaseName VARCHAR(100) ='',
        @TableName    VARCHAR(255) ='',
        @SchemaName   VARCHAR(255) ='',
        @DryRun       INT = 0

SELECT @sqlcmd = '
USE [' + @DatabaseName
                 + ']

     select t.name, D.DatabaseName, D.SchemaName, C.CONSTRAINT_NAME, d.maxUserSeek
   from [sys].[tables] t
   join [DBA].[info].[TableUsage] D  on T.name  = D.TableName
   left join [INFORMATION_SCHEMA].[TABLE_CONSTRAINTS]  c on t.name= c.TABLE_NAME
   where t.name like ''%' + @TableName
                 + '%''
    AND D.SchemaName like ''%'
                 + @SchemaName + '%'' 
   
'

IF @DryRun = 0
  BEGIN
      IF @DatabaseName = '?'
        BEGIN
            IF Object_id(N'tempdb..#1') IS NOT NULL
              DROP TABLE #1

            CREATE TABLE #1
              (
                 [TABLE_NAME]      VARCHAR(250),
                 [DATABASE_NAME]   VARCHAR(250),
                 [SCHEMA_NAME]     VARCHAR(250),
                 [CONSTRAINT_NAME] VARCHAR(250),
                 [maxUserSeek]     DATETIME
              )

            INSERT INTO #1
            EXEC Sp_msforeachdb
              @sqlcmd

            SELECT *
            FROM   #1
        END
      ELSE
        BEGIN
            EXEC ( @SQLcmd)
        END
  END
ELSE
  BEGIN
      PRINT ( @SQLcmd )
  END 
