\


BACKUP DATABASE [UniTrac] 
to disk = 'F:\SQLBackups\Unitrac-Full-1.bak'
,disk = 'F:\SQLBackups\Unitrac-Full-2.bak'
,disk = 'F:\SQLBackups\Unitrac-Full-3.bak'
,disk = 'F:\SQLBackups\Unitrac-Full-4.bak'
,disk = 'F:\SQLBackups\Unitrac-Full-5.bak'
,disk = 'F:\SQLBackups\Unitrac-Full-6.bak'
,disk = 'F:\SQLBackups\Unitrac-Full-7.bak'
,disk = 'F:\SQLBackups\Unitrac-Full-8.bak'
WITH NOFORMAT, INIT,  NAME = N'UniTrac-Full Database Backup', 
SKIP, NOREWIND, NOUNLOAD, COMPRESSION,  STATS = 10
GO
