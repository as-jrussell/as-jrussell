

--Setting fill factor to values 0 or 100 has the same effect (in SQL Server 2005 and later).
SELECT DB_NAME() AS Database_Name
, sc.name AS Schema_Name
, o.name AS Table_Name
, o.type_desc
, i.name AS Index_Name
, i.type_desc AS Index_Type
, i.fill_factor, *
FROM sys.indexes i
INNER JOIN sys.objects o ON i.object_id = o.object_id
INNER JOIN sys.schemas sc ON o.schema_id = sc.schema_id
WHERE o.type = 'U'
AND i.fill_factor not in (0, 100)
ORDER BY i.fill_factor DESC, o.name