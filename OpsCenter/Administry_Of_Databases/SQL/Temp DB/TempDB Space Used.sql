--use tempdb
SELECT DB_NAME() 'db_name',
	df.[NAME] 'logical_name',
	--fg.[Name] AS 'FileGroup',
	(CONVERT(float,size)) / 128 'file_size_MB',
	df.growth / 128 'Growth',
	(CONVERT(float,FILEPROPERTY(df.name,'SpaceUsed'))) / 128 'MB_used',
	((CONVERT(float,size)) / 128 - (CONVERT(float,FILEPROPERTY(df.name,'SpaceUsed'))) / 128) 'MB_free',
	(CONVERT(float,FILEPROPERTY(df.name,'SpaceUsed')))/(CONVERT(float,size)) * 100 'percent_used',
	(CONVERT(float,max_size)) / 128 as Maximum_File_Size_MB,
	df.physical_name
FROM sys.database_files df WITH(NOLOCK)
--LEFT OUTER JOIN sys.filegroups fg WITH(NOLOCK) on df.data_space_id = fg.data_space_id
--WHERE fg.[Name] = 'FG1'
--WHERE df.[NAME] like '%LOG'
ORDER BY FILEPROPERTY(df.name,'IsLogFile')

dbcc opentran

--USE [tempdb] DBCC SHRINKFILE (N'templog' , 0)

---I may have the wrong path folder for the tempdb

SELECT 'ALTER DATABASE tempdb MODIFY FILE (NAME = [' + f.name + '],'
 + ' FILENAME = ''G:\SQL\TempDB\' + f.name
 + CASE WHEN f.type = 1 THEN '.ldf' ELSE '.mdf' END
 + ''');'
FROM sys.master_files f
WHERE f.database_id = DB_ID(N'tempdb');
