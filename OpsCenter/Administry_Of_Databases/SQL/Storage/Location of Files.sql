DECLARE @SQLcmd VARCHAR(500),
        @DryRun INT = 0,
        @TYPE   VARCHAR (10) = ''

SET @SQLcmd='USE [?] select DB_NAME(), name, physical_name,type_desc, size/128.00 from sys.database_files

'

IF @DryRun = 0
  BEGIN
      IF Object_id(N'tempdb..#1') IS NOT NULL
        DROP TABLE #1

      CREATE TABLE #1
        (
           [databasename] VARCHAR(250),
           [filename]     VARCHAR(250),
           [Location]     VARCHAR(max),
           [Type]         VARCHAR (10),
           [size MB]      INT
        )

      INSERT INTO #1
      EXEC Sp_msforeachdb
        @SQLcmd

      IF @Type <> ''
        BEGIN
            SELECT *
            FROM   #1
            WHERE  [type] = @type
        END
      ELSE
        BEGIN
            SELECT *
            FROM   #1
        END
  END
ELSE
  BEGIN
      PRINT ( @SQLcmd )
  END 
