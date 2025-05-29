/*

Restore takes about 30 seconds that includes upgrading to 2016

*/

use master

RESTORE DATABASE archiveEDI FROM DISK = N'\\IGNITE-SQL14\Restores\jrussell\archiveEDI.Bak'    WITH    MOVE N'archiveEDI' TO N'E:\MSSQL\Data\archiveEDI.mdf',    MOVE N'archiveEDI_log' TO N'F:\MSSQL\LOGS\archiveEDI_log.ldf',    NORECOVERY, NOUNLOAD, STATS = 5
RESTORE DATABASE EDI FROM DISK = N'\\IGNITE-SQL14\Restores\jrussell\EDI.Bak'    WITH    MOVE N'EDI' TO N'E:\MSSQL\Data\EDI.mdf',    MOVE N'EDI_log' TO N'F:\MSSQL\LOGS\EDI_log.ldf',    NORECOVERY, NOUNLOAD, STATS = 5



RESTORE LOG archiveEDI FROM DISK = N'\\IGNITE-SQL14\Restores\jrussell\archiveEDI.LOG'  WITH NORECOVERY, STATS = 5
RESTORE LOG EDI FROM DISK = N'\\IGNITE-SQL14\Restores\jrussell\EDI.LOG'  WITH NORECOVERY, STATS = 5



RESTORE DATABASE [archiveEDI] WITH RECOVERY;
GO

RESTORE DATABASE [EDI] WITH RECOVERY;
GO