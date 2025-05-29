--- To shrink the UniTrac Log File (need to change database properties first from "Full" to "Simple" before running
DBCC SHRINKFILE(unitrac_log, TRUNCATEONLY) 

DBCC SHRINKFILE(unitrac_dw_log, TRUNCATEONLY) 

DBCC SHRINKFILE('templog', TRUNCATEONLY) 

DBCC SHRINKFILE('tempdev', 1024)

DBCC SHRINKFILE(edi_log, TRUNCATEONLY)

SELECT * FROM SYS.dm_exec_requests WHERE database_id = 2

DBCC SHRINKFILE(vut_log, TRUNCATEONLY) 

EXEC sys.sp_who2
GO
----------------- Maintenance --------------------------

------- Move Tempdb
USE master;
GO
ALTER DATABASE tempdb
MODIFY FILE
(NAME = tempdev, FILENAME = 'G:\MSSQL\DATA\TEMPDB\tempdb.mdf');
go
ALTER DATABASE tempdb
MODIFY FILE
(NAME = templog, FILENAME = 'G:\MSSQL\DATA\TEMPDB\templog.ldf');
go

----- Move UniTrac
USE master;
GO
ALTER DATABASE UniTrac
MODIFY FILE
(NAME = UniTrac, FILENAME = 'E:\MSSQL\DATA\UniTrac.mdf');
go
ALTER DATABASE UniTrac
MODIFY FILE
(NAME = UniTrac2, FILENAME = 'F:\MSSQL\DATA\UniTrac2.ndf');
go
ALTER DATABASE UniTrac
MODIFY FILE
(NAME = UniTrac3, FILENAME = 'G:\MSSQL\DATA\UniTrac3.ndf');
go
ALTER DATABASE UniTrac
MODIFY FILE
(NAME = UniTrac_log, FILENAME = 'G:\MSSQL\DATA\UniTrac_log.ldf');
go






