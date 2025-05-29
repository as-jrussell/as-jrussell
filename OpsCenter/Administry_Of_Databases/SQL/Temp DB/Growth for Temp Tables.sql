USE [master]; 
GO 
 
 DECLARE @TempDBFile VARCHAR(MAX) 
 DECLARE @Size varchar(10) = '2GB'
 DECLARE @Growth varchar(10) = '10 MB'
 DECLARE @Max varchar(10) = '10 GB'
 Declare @FileType varchar(10) = 'log'

 IF @FileType = 'Log'
    SET @FileType = 1;
ELSE IF @FileType = 'DATA'
    SET @FileType = 0;
ELSE
    SET @FileType = 1;

 select @TempDBFile = CONCAT('IF EXISTS (select 1 from tempdb.sys.database_files where name =''',name,''') BEGIN  BEGIN TRY 
 ALTER DATABASE tempdb MODIFY FILE (NAME=''',name,''', SIZE=' +@Size+', FILEGROWTH = ' +@Growth+', MAXSIZE = ' +@Max +')  END TRY  
    BEGIN CATCH 
	 PRINT ''WARNING: TempDB not modified!''
 RETURN
    END CATCH  
	 PRINT ''SUCCESS: TempDB modified!''
 END
 ELSE
 BEGIN 
 PRINT ''WARNING: TempDB not modified!''
 END ;')
 --SELECT *
 from tempdb.sys.database_files
 where type = @FileType

 

 PRINT (@TempDBFile)
