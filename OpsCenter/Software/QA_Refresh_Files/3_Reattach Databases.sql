USE [master]
GO

CREATE DATABASE [archiveEDI] ON 
( FILENAME = N'F:\SQL\DATA05\archiveEDI.mdf' ),
( FILENAME = N'F:\SQL\SQLLogs\archiveEDI_log.ldf' )
FOR ATTACH
GO

CREATE DATABASE [EDI] ON 
( FILENAME = N'F:\SQL\DATA05\EDI.mdf' ),
( FILENAME = N'F:\SQL\SQLLogs\EDI_log.ldf' )
FOR ATTACH
GO

CREATE DATABASE [LetterGen] ON 
( FILENAME = N'F:\SQL\DATA05\LetterGen.mdf' ),
( FILENAME = N'F:\SQL\SQLLogs\LetterGen_log.ldf' )
FOR ATTACH
GO


CREATE DATABASE [OperationalDashboard] ON 
( FILENAME = N'F:\SQL\Data05\OperationalDashboard.mdf' ),
( FILENAME = N'F:\SQL\SQLLogs\Operational.Dashboard_log.ldf' )
FOR ATTACH
GO

CREATE DATABASE [OspreyDashboard] ON 
( FILENAME = N'F:\SQL\Data05\OspreyDashboard.mdf' ),
( FILENAME = N'F:\SQL\SQLLogs\OspreyDashboard_log.ldf' )
FOR ATTACH
GO

CREATE DATABASE [QCModule] ON 
( FILENAME = N'F:\SQL\Data05\QCModule_Primary.mdf' ),
( FILENAME = N'F:\SQL\SQLLogs\QCModule_Primary_Log.ldf' )
FOR ATTACH
GO

CREATE DATABASE [SADashboard] ON 
( FILENAME = N'F:\SQL\Data05\SADashboard.mdf' ),
( FILENAME = N'F:\SQL\SQLLogs\SADashboard_log.ldf' )
FOR ATTACH
GO

CREATE DATABASE [UniTrac_DW] ON 
( FILENAME = N'F:\SQL\Data05\UniTrac_DW.mdf' ),
( FILENAME = N'F:\SQL\SQLLogs\UniTrac_DW_log.ldf' )
FOR ATTACH
GO

CREATE DATABASE [UniTracArchive] ON 
( FILENAME = N'F:\SQL\Data05\UniTracArchive.mdf' ),
( FILENAME = N'F:\SQL\SQLLogs\UniTracArchive_log.ldf' )
FOR ATTACH
GO

CREATE DATABASE [VUT] ON 
( FILENAME = N'F:\SQL\Data05\VUT.mdf' ),
( FILENAME = N'F:\SQL\SQLLogs\VUT_log.ldf' )
FOR ATTACH
GO

CREATE DATABASE [UniTrac] ON 
( FILENAME = N'F:\SQL\Data01\UniTrac.mdf' ),
( FILENAME = N'F:\SQL\Data02\UniTrac2.ndf' ),
( FILENAME = N'F:\SQL\Data03\UniTrac3.ndf' ),
( FILENAME = N'F:\SQL\Data04\UniTrac4.ndf' ),
( FILENAME = N'F:\SQL\SQLLogs\UniTrac_Log.ldf' )
FOR ATTACH
GO



--Databases that are not being re-attached from prod
--Need to copy over to F: drive first and then assign UTQA-SQL-14\Administrators group full control first!!!!

CREATE DATABASE [BSSMessageQueue] ON 
( FILENAME = N'F:\SQL\DATA05\BSSMessageQueue.mdf' ),
( FILENAME = N'F:\SQL\SQLLogs\BSSMessageQueue_log.ldf' )
FOR ATTACH
GO

CREATE DATABASE [DBA] ON 
( FILENAME = N'F:\SQL\DATA01\DBA.mdf' ),
( FILENAME = N'F:\SQL\SQLLogs\DBA_log.ldf' )
FOR ATTACH
GO

CREATE DATABASE [HDTStorage] ON 
( FILENAME = N'F:\SQL\Data05\HDTStorage.mdf' ),
( FILENAME = N'F:\SQL\SQLLogs\HDTStorage_log.ldf' )
FOR ATTACH
GO

CREATE DATABASE [LFP] ON 
( FILENAME = N'F:\SQL\Data05\LFP.mdf' ),
( FILENAME = N'F:\SQL\SQLLogs\LFP_log.ldf' )
FOR ATTACH
GO

CREATE DATABASE [LIMC] ON 
( FILENAME = N'F:\SQL\Data05\LIMC.mdf' ),
( FILENAME = N'F:\SQL\SQLLogs\LIMC_log.ldf' )
FOR ATTACH
GO

CREATE DATABASE [PerfStats] ON 
( FILENAME = N'F:\SQL\DATA05\PerfStats.mdf' ),
( FILENAME = N'F:\SQL\SQLLogs\PerfStats_log.ldf' )
FOR ATTACH
GO

CREATE DATABASE [VehicleCT] ON 
( FILENAME = N'F:\SQL\DATA05\VehicleCT.mdf' ),
( FILENAME = N'F:\SQL\SQLLogs\VehicleCT_log.ldf' )
FOR ATTACH
GO

CREATE DATABASE [VehicleUC] ON 
( FILENAME = N'F:\SQL\DATA05\VehicleUC.mdf' ),
( FILENAME = N'F:\SQL\SQLLogs\VehicleUC_log.ldf' )
FOR ATTACH
GO

CREATE DATABASE [UniTracHDStorage] ON 
( FILENAME = N'F:\SQL\Data05\UniTracHDStorage.mdf' ),
( FILENAME = N'F:\SQL\SQLLogs\UniTracHDStorage_log.ldf' )
FOR ATTACH
GO


--Cannot attach a database that was being restored.
CREATE DATABASE [PerfStats] ON 
( FILENAME = N'F:\SQL\Data05\PerfStats.mdf' ),
( FILENAME = N'F:\SQL\SQLLogs\PerfStats_log.ldf' )
FOR ATTACH
GO


CREATE DATABASE [VehicleCT] ON 
( FILENAME = N'F:\SQL\Data05\VehicleCT.mdf' ),
( FILENAME = N'F:\SQL\SQLLogs\VehicleCT_log.ldf' )
FOR ATTACH
GO

CREATE DATABASE [VehicleUC] ON 
( FILENAME = N'F:\SQL\Data05\VehicleUC.mdf' ),
( FILENAME = N'F:\SQL\SQLLogs\VehicleUC_log.ldf' )
FOR ATTACH
GO


