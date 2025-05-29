--use tempDB  
--go  
--EXEC SP_HELPFILE; 

use tempdb

 IF EXISTS (select * from sys.database_files where name = 'tempdev10')
BEGIN 
		 PRINT 'SUCCESS: You found me!'
END 
ELSE 
BEGIN
		PRINT 'WARNING: No TempDB name temp10, you are a failure'
END 