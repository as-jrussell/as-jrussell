IF EXISTS (SELECT 1
           FROM   tempdb.sys.database_files
           WHERE  name = 'tempdev')
  BEGIN
      BEGIN TRY
          ALTER DATABASE tempdb MODIFY FILE (NAME='tempdev', SIZE=25GB, FILEGROWTH = 0)
      END TRY
      BEGIN CATCH
          PRINT 'WARNING: TempDB not expanded!'
          RETURN
      END CATCH

      PRINT 'SUCCESS: TempDB expanded!'
  END
ELSE
  BEGIN
      PRINT 'WARNING: TempDB not expanded!'
  END;

IF EXISTS (SELECT 1
           FROM   tempdb.sys.database_files
           WHERE  name = 'tempdev2')
  BEGIN
      BEGIN TRY
          ALTER DATABASE tempdb MODIFY FILE (NAME='tempdev2', SIZE=25GB, FILEGROWTH = 0)
      END TRY
      BEGIN CATCH
          PRINT 'WARNING: TempDB not expanded!'
          RETURN
      END CATCH

      PRINT 'SUCCESS: TempDB expanded!'
  END
ELSE
  BEGIN
      PRINT 'WARNING: TempDB not expanded!'
  END;

IF EXISTS (SELECT 1
           FROM   tempdb.sys.database_files
           WHERE  name = 'tempdev3')
  BEGIN
      BEGIN TRY
          ALTER DATABASE tempdb MODIFY FILE (NAME='tempdev3', SIZE=25GB, FILEGROWTH = 0)
      END TRY
      BEGIN CATCH
          PRINT 'WARNING: TempDB not expanded!'
          RETURN
      END CATCH

      PRINT 'SUCCESS: TempDB expanded!'
  END
ELSE
  BEGIN
      PRINT 'WARNING: TempDB not expanded!'
  END;

IF EXISTS (SELECT 1
           FROM   tempdb.sys.database_files
           WHERE  name = 'tempdev4')
  BEGIN
      BEGIN TRY
          ALTER DATABASE tempdb MODIFY FILE (NAME='tempdev4', SIZE=25GB, FILEGROWTH = 0)
      END TRY
      BEGIN CATCH
          PRINT 'WARNING: TempDB not expanded!'
          RETURN
      END CATCH

      PRINT 'SUCCESS: TempDB expanded!'
  END
ELSE
  BEGIN
      PRINT 'WARNING: TempDB not expanded!'
  END;

IF EXISTS (SELECT 1
           FROM   tempdb.sys.database_files
           WHERE  name = 'tempdev5')
  BEGIN
      BEGIN TRY
          ALTER DATABASE tempdb MODIFY FILE (NAME='tempdev5', SIZE=25GB, FILEGROWTH = 0)
      END TRY
      BEGIN CATCH
          PRINT 'WARNING: TempDB not expanded!'
          RETURN
      END CATCH

      PRINT 'SUCCESS: TempDB expanded!'
  END
ELSE
  BEGIN
      PRINT 'WARNING: TempDB not expanded!'
  END;

IF EXISTS (SELECT 1
           FROM   tempdb.sys.database_files
           WHERE  name = 'tempdev6')
  BEGIN
      BEGIN TRY
          ALTER DATABASE tempdb MODIFY FILE (NAME='tempdev6', SIZE=25GB, FILEGROWTH = 0)
      END TRY
      BEGIN CATCH
          PRINT 'WARNING: TempDB not expanded!'
          RETURN
      END CATCH

      PRINT 'SUCCESS: TempDB expanded!'
  END
ELSE
  BEGIN
      PRINT 'WARNING: TempDB not expanded!'
  END;

IF EXISTS (SELECT 1
           FROM   tempdb.sys.database_files
           WHERE  name = 'tempdev7')
  BEGIN
      BEGIN TRY
          ALTER DATABASE tempdb MODIFY FILE (NAME='tempdev7', SIZE=25GB, FILEGROWTH = 0)
      END TRY
      BEGIN CATCH
          PRINT 'WARNING: TempDB not expanded!'
          RETURN
      END CATCH

      PRINT 'SUCCESS: TempDB expanded!'
  END
ELSE
  BEGIN
      PRINT 'WARNING: TempDB not expanded!'
  END;

IF EXISTS (SELECT 1
           FROM   tempdb.sys.database_files
           WHERE  name = 'tempdev8')
  BEGIN
      BEGIN TRY
          ALTER DATABASE tempdb MODIFY FILE (NAME='tempdev8', SIZE=25GB, FILEGROWTH = 0)
      END TRY
      BEGIN CATCH
          PRINT 'WARNING: TempDB not expanded!'
          RETURN
      END CATCH

      PRINT 'SUCCESS: TempDB expanded!'
  END
ELSE
  BEGIN
      PRINT 'WARNING: TempDB not expanded!'
  END; 
