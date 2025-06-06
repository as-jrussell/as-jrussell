use tempdb


IF EXISTS (select 1  FROM sys.master_files AS m
JOIN tempdb.sys.database_files AS d ON m.file_id = d.file_id
WHERE DB_NAME(m.database_id) = 'tempdb' AND M.TYPE_DESC = 'LOG'AND  (d.size * 8) / 1024 <> '4000')
BEGIN 
    BEGIN TRY   
	DBCC SHRINKFILE('templog',0)
		  END TRY  
    BEGIN CATCH  
		PRINT 'WARNING: TEMP LOG FILE HAS NOT BEEN SHRUNK!'
   RETURN
    END CATCH  
	PRINT 'SUCCESS: TEMP LOG FILE HAS BEEN SHRUNK!'
END 
	ELSE
BEGIN
		PRINT 'WARNING: FILE DOES NOT EXIST OR FILE DOES NOT NEED TO BE SHRUNK!'
END



SELECT
    CASE m.type_desc WHEN 'ROWS' THEN 'DATA' ELSE 'LOG' END AS [Type],
    d.file_id AS [File ID],
    d.name AS [Logical name],
    (m.size * 8) / 1024 AS [Starting size (MB)],
    (d.size * 8) / 1024 AS [Current size (MB)],
    CASE WHEN (d.size > m.size)
        THEN '*** GROWN ***'
        ELSE 'Not grown'
        END AS [Status],
    CASE WHEN (d.size > m.size)
        THEN 'ALTER DATABASE TempDB MODIFY FILE (NAME = ''' + d.name + ''', SIZE = '
        + CAST((d.size * 8)/1024 AS varchar(10)) + 'MB);'
        ELSE 'No need to modify'
        END AS [Modify statement],
    d.physical_name AS [Filename]
FROM sys.master_files AS m
JOIN tempdb.sys.database_files AS d ON m.file_id = d.file_id
WHERE DB_NAME(m.database_id) = 'tempdb'
AND M.TYPE_DESC = 'LOG'
ORDER BY [Type], [File ID];