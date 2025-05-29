


---I may have the wrong path folder for the tempdb

SELECT 'ALTER DATABASE tempdb MODIFY FILE (NAME = [' + f.name + '],'
 + ' FILENAME = ''G:\SQL\TempDB\' + f.name
 + CASE WHEN f.type = 1 THEN '.ldf' ELSE '.mdf' END
 + ''');'
FROM sys.master_files f
WHERE f.database_id = DB_ID(N'tempdb');


