USE [master]

DECLARE @DBNAME nvarchar(50) = 'PRL_APLUS_661_PROD'


IF NOT EXISTS (SELECT * FROM sys.databases WHERE name like ''+ @DBName+'%')
BEGIN
	EXEC ('CREATE DATABASE ' + @DBNAME +'
	 CONTAINMENT = NONE')
	 PRINT 'Database Created Successfully! Stand by as we apply permissions.... '
	END
	ELSE
BEGIN 
	PRINT 'WARNING: Database already exist' 
END

