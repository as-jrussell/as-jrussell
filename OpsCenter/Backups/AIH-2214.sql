

---Implememtation
EXEC sys.sp_configure N'max server memory (MB)', N'117964'
GO
RECONFIGURE WITH OVERRIDE
GO


/*

---Backout 
EXEC sys.sp_configure N'max server memory (MB)', N'61440'
GO
RECONFIGURE WITH OVERRIDE
GO

*/


---Validation
SELECT c.value, c.value_in_use
FROM sys.configurations c WHERE c.[name] = 'max server memory (MB)'