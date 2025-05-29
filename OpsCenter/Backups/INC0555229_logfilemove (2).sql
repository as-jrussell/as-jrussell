--New Location


SELECT *
FROM sys.master_files f
WHERE f.type_desc = 'log'

/*


ALTER DATABASE ReportServer
MODIFY FILE(NAME=[ReportServer_log], FILENAME='F:\SQLLOGS\ReportServer_log.ldf');

ALTER DATABASE ReportServerTempDB
MODIFY FILE(NAME=[ReportServerTempDB_log], FILENAME='F:\SQLLOGS\ReportServerTempDB_log.ldf');

ALTER DATABASE SharePoint_Config
MODIFY FILE(NAME=[SharePoint_Config_log], FILENAME='F:\SQLLOGS\SharePoint_Config_log.ldf');


ALTER DATABASE [SharePoint_AdminContent_1dc1f295-6905-433f-9d76-38caa1c9cdc8]
MODIFY FILE(NAME=[SharePoint_AdminContent_1dc1f295-6905-433f-9d76-38caa1c9cdc8_log], FILENAME='F:\SQLLOGS\SharePoint_AdminContent_1dc1f295-6905-433f-9d76-38caa1c9cdc8_log.ldf');

ALTER DATABASE [WSS_2008_Temp]
MODIFY FILE(NAME=[WSS_2008_Temp_log], FILENAME='F:\SQLLOGS\WSS_2008_Temp_log.ldf');

ALTER DATABASE [WSS_2012_Temp]
MODIFY FILE(NAME=[WSS_2012_Temp_log], FILENAME='F:\SQLLOGS\WSS_2012_Temp_log.ldf');



ALTER DATABASE ReportServer
MODIFY FILE(NAME=[ReportServer_log], FILENAME='F:\SQLLOGS\ReportServer_log.ldf');

ALTER DATABASE ReportServerTempDB
MODIFY FILE(NAME=[ReportServerTempDB_log], FILENAME='F:\SQLLOGS\ReportServerTempDB_log.ldf');

ALTER DATABASE [Tfs_allied-tfs-2k12]
MODIFY FILE(NAME=[Tfs_allied-tfs-2k12_log], FILENAME='F:\SQLLOGS\Tfs_allied-tfs-2k12_log.ldf');

ALTER DATABASE Tfs_Configuration
MODIFY FILE(NAME=[Tfs_Configuration_log], FILENAME='F:\SQLLOGS\Tfs_Configuration_log.ldf');

ALTER DATABASE Tfs_Warehouse
MODIFY FILE(NAME=[Tfs_Warehouse_log], FILENAME='F:\SQLLOGS\Tfs_Warehouse_log.ldf');

ALTER DATABASE WSS_Content
MODIFY FILE(NAME=[WSS_Content_log], FILENAME='F:\SQLLOGS\WSS_Content_log.ldf');

ALTER DATABASE Tfs_DefaultCollection
MODIFY FILE(NAME=[Tfs_DefaultCollection_log], FILENAME='F:\SQLLOGS\Tfs_DefaultCollection_log.ldf');

ALTER DATABASE TFS_Warehouse
MODIFY FILE(NAME=[TFS_Warehouse_log], FILENAME='F:\SQLLOGS\TFS_Warehouse_log.ldf');

ALTER DATABASE WSS_Content
MODIFY FILE(NAME=[WSS_Content_log], FILENAME='F:\SQLLOGS\WSS_Content_log.ldf');

ALTER DATABASE Tfs_Allied2008
MODIFY FILE(NAME=[Tfs_Allied2008_log], FILENAME='F:\SQLLOGS\Tfs_Allied2008_log.ldf');

ALTER DATABASE ReportServer
MODIFY FILE(NAME=[ReportServer_log], FILENAME='F:\SQLLOGS\ReportServer_log.ldf');

ALTER DATABASE ReportServerTempDB
MODIFY FILE(NAME=[ReportServerTempDB_log], FILENAME='F:\SQLLOGS\ReportServerTempDB_log.ldf');

ALTER DATABASE TFS_Warehouse_2008
MODIFY FILE(NAME=[TFS_Warehouse_2008_log], FILENAME='F:\SQLLOGS\TFS_Warehouse_2008_log.ldf');

ALTER DATABASE TfsWarehouse
MODIFY FILE(NAME=[TfsWarehouse_log], FILENAME='F:\SQLLOGS\TfsWarehouse_log.ldf');

ALTER DATABASE Tfs_ASTest
MODIFY FILE(NAME=[Tfs_ASTest_log], FILENAME='F:\SQLLOGS\Tfs_ASTest_log.ldf');

ALTER DATABASE Tfs_ASDev
MODIFY FILE(NAME=[Tfs_ASDev_log], FILENAME='F:\SQLLOGS\Tfs_ASDev_log.ldf');

ALTER DATABASE Tfs_Product_Liability_Refund
MODIFY FILE(NAME=[Tfs_Product_Liability_Refund_log], FILENAME='F:\SQLLOGS\Tfs_Product_Liability_Refund_log.ldf');

ALTER DATABASE Tfs_AlliedTest
MODIFY FILE(NAME=[Tfs_AlliedTest_log], FILENAME='F:\SQLLOGS\Tfs_AlliedTest_log.ldf');

ALTER DATABASE DBA
MODIFY FILE(NAME=[DBA_log], FILENAME='F:\SQLLOGS\DBA_log.ldf');



GO
ALTER DATABASE ReportServer SET OFFLINE;  
GO
ALTER DATABASE ReportServerTempDB SET OFFLINE;  
GO
ALTER DATABASE SharePoint_Config SET OFFLINE;  
GO
ALTER DATABASE [SharePoint_AdminContent_1dc1f295-6905-433f-9d76-38caa1c9cdc8] SET OFFLINE;  
GO
ALTER DATABASE WSS_2008_Temp SET OFFLINE;  
GO
ALTER DATABASE WSS_2012_Temp SET OFFLINE;  
GO
ALTER DATABASE ReportServer SET OFFLINE;  
GO
ALTER DATABASE ReportServerTempDB SET OFFLINE;  
GO
ALTER DATABASE [Tfs_allied-tfs-2k12] SET OFFLINE;  
GO
ALTER DATABASE Tfs_Configuration SET OFFLINE;  
GO
ALTER DATABASE Tfs_Warehouse SET OFFLINE;  
GO
ALTER DATABASE WSS_Content SET OFFLINE;  
GO
ALTER DATABASE Tfs_DefaultCollection SET OFFLINE;  
GO
ALTER DATABASE TFS_Warehouse SET OFFLINE;  
GO
ALTER DATABASE WSS_Content SET OFFLINE;  
GO
ALTER DATABASE Tfs_Allied2008 SET OFFLINE;  
GO
ALTER DATABASE ReportServer SET OFFLINE;  
GO
ALTER DATABASE ReportServerTempDB SET OFFLINE;  
GO
ALTER DATABASE TFS_Warehouse_2008 SET OFFLINE;  
GO
ALTER DATABASE TfsWarehouse SET OFFLINE;  
GO
ALTER DATABASE Tfs_ASTest SET OFFLINE;  
GO
ALTER DATABASE Tfs_ASDev SET OFFLINE;  
GO
ALTER DATABASE Tfs_Product_Liability_Refund SET OFFLINE;  
GO
ALTER DATABASE Tfs_AlliedTest SET OFFLINE;  
GO
ALTER DATABASE DBA SET OFFLINE;  
GO


--Copy Files to F drive

If this error happens stop SQL server service

Msg 5120, Level 16, State 101, Line 13
Unable to open the physical file “E:\New_location\AdventureWorks2014_Data.mdf”. Operating system error 5: “5(Access is denied.)”.

---Validate

SELECT name, physical_name AS NewLocation, state_desc AS OnlineStatus
FROM sys.master_files  



---Enable database

ALTER DATABASE master SET ONLINE;  
GO

ALTER DATABASE model SET ONLINE;  
GO
ALTER DATABASE MSDB SET ONLINE;  
GO
ALTER DATABASE ReportServer SET ONLINE;  
GO
ALTER DATABASE ReportServerTempDB SET ONLINE;  
GO
ALTER DATABASE SharePoint_Config SET ONLINE;  
GO
ALTER DATABASE [SharePoint_AdminContent_1dc1f295-6905-433f-9d76-38caa1c9cdc8] SET ONLINE;  
GO
ALTER DATABASE WSS_2008_Temp SET ONLINE;  
GO
ALTER DATABASE WSS_2012_Temp SET ONLINE;  
GO
ALTER DATABASE ReportServer SET ONLINE;  
GO
ALTER DATABASE ReportServerTempDB SET ONLINE;  
GO
ALTER DATABASE [Tfs_allied-tfs-2k12] SET ONLINE;  
GO
ALTER DATABASE Tfs_Configuration SET ONLINE;  
GO
ALTER DATABASE Tfs_Warehouse SET ONLINE;  
GO
ALTER DATABASE WSS_Content SET ONLINE;  
GO
ALTER DATABASE Tfs_DefaultCollection SET ONLINE;  
GO
ALTER DATABASE TFS_Warehouse SET ONLINE;  
GO
ALTER DATABASE WSS_Content SET ONLINE;  
GO
ALTER DATABASE Tfs_Allied2008 SET ONLINE;  
GO
ALTER DATABASE ReportServer SET ONLINE;  
GO
ALTER DATABASE ReportServerTempDB SET ONLINE;  
GO
ALTER DATABASE TFS_Warehouse_2008 SET ONLINE;  
GO
ALTER DATABASE TfsWarehouse SET ONLINE;  
GO
ALTER DATABASE Tfs_ASTest SET ONLINE;  
GO
ALTER DATABASE Tfs_ASDev SET ONLINE;  
GO
ALTER DATABASE Tfs_Product_Liability_Refund SET ONLINE;  
GO
ALTER DATABASE Tfs_AlliedTest SET ONLINE;  
GO
ALTER DATABASE DBA SET ONLINE;  
GO
*/




