USE [master]

DECLARE @DBNAME nvarchar(50) = 'HDTStorage'
DECLARE @retVal int

SELECT @retVal = COUNT(*)
FROM sys.databases 
WHERE name like ''+ @DBName+'%'

IF (@retVal = 0)
BEGIN
SELECT 'No HDTStorage' [HDTStorage]
END
ELSE
BEGIN
SELECT 'Yes we have already created a database named HDTStorage here!' [HDTStorage?]
END 



