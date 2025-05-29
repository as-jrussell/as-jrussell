use tempDB  
go  
EXEC SP_HELPFILE; 


--SQL instance need a restart 

USE tempdb;  
GO  
DBCC SHRINKFILE('tempdev10', EMPTYFILE)  
GO  
USE master;  
GO  
ALTER DATABASE tempdb  
REMOVE FILE tempdev10; 