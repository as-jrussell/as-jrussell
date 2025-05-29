--New Location


SELECT *
FROM sys.master_files f
WHERE f.type_desc = 'log'



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




