--New Location


SELECT *
FROM sys.master_files f
WHERE f.type_desc = 'log'


/*

 
ALTER DATABASE MSDB   
    MODIFY FILE ( NAME = MSDBLog,   
                  FILENAME = 'C:\SQL\SQLLOGS\MSDBLog.ldf');  
GO
 
ALTER DATABASE master   
    MODIFY FILE ( NAME = mastlog,   
                  FILENAME = 'C:\SQL\SQLLOGS\mastlog.ldf');  
GO
 
ALTER DATABASE model   
    MODIFY FILE ( NAME = modellog,   
                  FILENAME = 'C:\SQL\SQLLOGS\modellog.ldf');  
GO



ALTER DATABASE master SET OFFLINE;  
GO

ALTER DATABASE msdb SET OFFLINE;  
GO


ALTER DATABASE model SET OFFLINE;  
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

ALTER DATABASE master SET ONLINE;  
GO

ALTER DATABASE msdb SET ONLINE;  
GO


ALTER DATABASE model SET ONLINE;  
GO


*/





