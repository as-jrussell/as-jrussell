IF EXISTS (SELECT 1
           FROM   tempdb.sys.database_files
           WHERE  name = 'tempdev')
  BEGIN
      BEGIN TRY
          ALTER DATABASE tempdb MODIFY FILE (NAME='tempdev', SIZE=7 GB, FILEGROWTH = 64 MB)
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

IF EXISTS (SELECT 1
           FROM   tempdb.sys.database_files
           WHERE  name = 'templog')
  BEGIN
      BEGIN TRY
          ALTER DATABASE tempdb MODIFY FILE (NAME='templog', SIZE=7 GB, FILEGROWTH = 64 MB)
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

IF EXISTS (SELECT 1
           FROM   tempdb.sys.database_files
           WHERE  name = 'temp2')
  BEGIN
      BEGIN TRY
          ALTER DATABASE tempdb MODIFY FILE (NAME='temp2', SIZE=7 GB, FILEGROWTH = 64 MB)
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

IF EXISTS (SELECT 1
           FROM   tempdb.sys.database_files
           WHERE  name = 'temp3')
  BEGIN
      BEGIN TRY
          ALTER DATABASE tempdb MODIFY FILE (NAME='temp3', SIZE=7 GB, FILEGROWTH = 64 MB)
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

IF EXISTS (SELECT 1
           FROM   tempdb.sys.database_files
           WHERE  name = 'temp4')
  BEGIN
      BEGIN TRY
          ALTER DATABASE tempdb MODIFY FILE (NAME='temp4', SIZE=7 GB, FILEGROWTH = 64 MB)
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
