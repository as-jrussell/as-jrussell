USE master

IF EXISTS (SELECT *
           FROM   sys.master_files
           WHERE  name = 'OspreyDashboard'
                  AND physical_name = 'E:\SQL\Data05\OspreyDashboard.mdf')
  BEGIN
      BEGIN TRY
          ALTER DATABASE [OspreyDashboard] MODIFY FILE ( NAME = N'OspreyDashboard', MAXSIZE = 100GB )
      END TRY
      BEGIN CATCH
          PRINT 'WARNING: OspreyDashboard not expanded!'
          RETURN
      END CATCH
      PRINT 'SUCCESS: OspreyDashboard expanded!'
  END
ELSE
  BEGIN
      PRINT 'WARNING: OspreyDashboard not expanded, validate that your path is correct'
  END; 
