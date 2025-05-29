USE [master]

DECLARE @DBNAME nvarchar(50) = 'HDTStoragenew2'


IF NOT EXISTS (SELECT * FROM sys.databases WHERE name like ''+ @DBName+'%')
BEGIN
EXEC ('CREATE DATABASE ' + @DBNAME +'')
 PRINT 'Database Created Successfully! Stand by as we apply permissions.... '
END
ELSE
BEGIN 
	PRINT 'WARNING: Database already exist' 
END


