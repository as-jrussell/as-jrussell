USE [HDTStorage]

DECLARE @DBNAME NVARCHAR(50) = 'HDTStorage'
DECLARE @DryRun INT = 0

IF EXISTS (SELECT *
           FROM   sys.databases
           WHERE  name LIKE '' + @DBName + '%')
  BEGIN
      DECLARE @permissionadd VARCHAR(300);
      DECLARE @accountcount VARCHAR(10);

      SET @accountcount = (SELECT Count(*)
                           FROM   sys.tables)

      IF @accountcount <> 0
        WHILE ( (SELECT Count(*)
                 FROM   sys.tables) <> 0 )
          BEGIN
              SELECT @permissionadd = Concat('DROP TABLE [', name, ']')
              -- select * 
              FROM   sys.tables

              IF @DryRun = 0
                BEGIN
                    EXEC ( @permissionadd)

                    PRINT 'Table has dropped ' + @permissionadd
                END
              ELSE
                BEGIN
                    SELECT Concat('DROP TABLE [', name, ']')
                    -- select * 
                    FROM   sys.tables

                    BREAK
                END

              SET @accountcount = 0
          END
  END
