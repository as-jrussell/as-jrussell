IF EXISTS (SELECT *
           FROM   sys.databases
           WHERE  name = 'Perfstats')
  BEGIN
      BEGIN TRY
          USE [PerfStats]

          DBCC SHRINKFILE (N'PerfStats', 2048)

          USE [master]

          ALTER DATABASE [PerfStats] MODIFY FILE ( NAME = N'PerfStats', MAXSIZE = 10GB )
      END TRY
      BEGIN CATCH
          PRINT 'WARNING: PerfStats database untouched!'
          RETURN
      END CATCH

      PRINT 'SUCCESS: PerfStats database file shrunk and maxsize increased!'
  END
ELSE
  BEGIN
      PRINT 'WARNING: PerfStats database untouched, please validate the database exists!'
  END; 
