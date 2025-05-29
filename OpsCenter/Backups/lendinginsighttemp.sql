IF EXISTS (SELECT 1
           FROM   tempdb.sys.database_files
           WHERE  name = 'templog')
  BEGIN
      BEGIN TRY
          ALTER DATABASE [tempdb] MODIFY FILE (NAME='templog', SIZE=1GB)
      END TRY
      BEGIN CATCH
          PRINT 'WARNING: TempDB not modified!'
          RETURN
      END CATCH



     PRINT 'SUCCESS: TempDB modified!'
  END
ELSE
  BEGIN
      PRINT 'WARNING: TempDB not modified!'
  END;