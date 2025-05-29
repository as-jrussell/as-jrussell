


---Free Space

SELECT DB_NAME() AS DbName, 
    name AS FileName, 
    type_desc,
    size/128.0/1024 AS CurrentSizeMB, 
	size/128.0 AS CurrentSizeMB, 
    size/128.0/1024  - CAST(FILEPROPERTY(name, 'SpaceUsed') AS INT)/128.0/1024 AS FreeSpaceMB
FROM sys.database_files
WHERE type IN (0,1);
