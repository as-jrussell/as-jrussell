USE AppLog

IF EXISTS (SELECT 1
           FROM   sys.tables
           WHERE  name = 'Applog')
  BEGIN
      BEGIN TRY
          EXEC Sp_rename
            'dbo.Applog',
            'Applog_old';
      END TRY
      BEGIN CATCH
          PRINT 'WARNING: Table was not renamed either not in the correct database or name convention itself failed.'
          RETURN
      END CATCH

      PRINT 'SUCCESS: Table Renamed '
  END
ELSE
  BEGIN
      PRINT 'WARNING: Table was not added either table does not exist or table name already exists'
  END

IF EXISTS (SELECT 1
           FROM   sys.tables
           WHERE  name = 'Applog_New')
  BEGIN
      BEGIN TRY
          EXEC Sp_rename
            'dbo.Applog_New',
            'Applog';
      END TRY
      BEGIN CATCH
          PRINT 'WARNING: Table was not renamed either not in the correct database or name convention itself failed.'
          RETURN
      END CATCH

      PRINT 'SUCCESS: Table Renamed '
  END
ELSE
  BEGIN
      PRINT 'WARNING: Table was not added either table does not exist or table name already exists'
  END 
