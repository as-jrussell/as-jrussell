SELECT suser_sname( owner_sid ) [owner], name [database name] FROM sys.databases
where  (suser_sname( owner_sid ) <> 'SA' OR suser_sname( owner_sid ) IS NULL)
AND (database_id >=5 AND  name NOT IN ('DBA', 'Perfstats', 'HDTStorage') )





select CONCAT('USE',' [', name,'] ','ALTER AUTHORIZATION ON DATABASE::',name,' ', 'TO [SA]')
FROM sys.databases
where  (suser_sname( owner_sid ) <> 'SA' OR suser_sname( owner_sid ) IS NULL)
AND (database_id >=5 AND  name NOT IN ('DBA', 'Perfstats', 'HDTStorage') )
