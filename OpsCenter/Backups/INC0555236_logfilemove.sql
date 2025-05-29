--New Location


SELECT CONCAT('ALTER DATABASE ',name,' MODIFY FILE ( NAME = ',name, '  FILENAME = ''F:\SQLLOGS\',name,'.mdf'')')
--SELECT *
FROM sys.master_files f
WHERE f.type_desc = 'rows'
and database_id >= '5'




ALTER DATABASE AdventureWorks2014   
    MODIFY FILE ( NAME = AdventureWorks2014_Data,   
                  FILENAME = 'E:\New_location\AdventureWorks2014_Data.mdf');  
GO

ALTER DATABASE UTL MODIFY FILE ( NAME = UTL,  FILENAME = 'F:\SQLDATA\UTL.mdf')
ALTER DATABASE UTL_Backup MODIFY FILE ( NAME = UTL_Backup,  FILENAME = 'F:\SQLDATA\UTL_Backup.mdf')
--ALTER DATABASE DBA MODIFY FILE ( NAME = DBA , FILENAME = 'F:\SQLDATA\DBA.mdf')
ALTER DATABASE UniTracHDStorage MODIFY FILE ( NAME = UniTracHDStorage , FILENAME = 'F:\SQLDATA\UniTracHDStorage.mdf')

/*

 




ALTER DATABASE Tfs_Configuration  
    MODIFY FILE ( NAME = Tfs_Configuration_log,   
                  FILENAME = F:\SQLLOGS\Tfs_Configuration_log.ldf');  
GO
 
ALTER DATABASE Tfs_DefaultCollection   
    MODIFY FILE ( NAME = Tfs_DefaultCollection_log,   
                  FILENAME = F:\SQLLOGS\Tfs_DefaultCollection_log.ldf');  
GO
 
ALTER DATABASE Tfs_Product_Liability_Refund   
    MODIFY FILE ( NAME = Tfs_Product_Liability_Refund_log,   
                  FILENAME = F:\SQLLOGS\Tfs_Product_Liability_Refund_log.ldf');  
GO


ALTER DATABASE DBA_log   
    MODIFY FILE ( NAME = Tfs_Product_Liability_Refund_log,   
                  FILENAME = F:\SQLLOGS\DBA_log.ldf');  
GO






ALTER DATABASE Tfs_Configuration SET OFFLINE WITH ROLLBACK IMMEDIATE;  
GO

ALTER DATABASE Tfs_DefaultCollection SET OFFLINE WITH ROLLBACK IMMEDIATE;  
GO

ALTER DATABASE Tfs_Product_Liability_Refund SET OFFLINE WITH ROLLBACK IMMEDIATE;  
GO

ALTER DATABASE DBA SET OFFLINE WITH ROLLBACK IMMEDIATE;  
GO



--Copy Files to F drive

If this error happens stop SQL server service

Msg 5120, Level 16, State 101, Line 13
Unable to open the physical file “E:\New_location\AdventureWorks2014_Data.mdf”. Operating system error 5: “5(Access is denied.)”.

---Validate

SELECT name, physical_name AS NewLocation, state_desc AS OnlineStatus
FROM sys.master_files  
WHERE database_id = DB_ID(N'master')  

SELECT name, physical_name AS NewLocation, state_desc AS OnlineStatus
FROM sys.master_files  
WHERE database_id = DB_ID(N'msdb')  


SELECT name, physical_name AS NewLocation, state_desc AS OnlineStatus
FROM sys.master_files  
WHERE database_id = DB_ID(N'model')  
GO


---Enable database



ALTER DATABASE Tfs_Configuration SET ONLINE ;  
GO

ALTER DATABASE Tfs_DefaultCollection SET ONLINE;  
GO

ALTER DATABASE Tfs_Product_Liability_Refund SET ONLINE;  
GO

ALTER DATABASE DBA SET ONLINE;  
GO

*/




