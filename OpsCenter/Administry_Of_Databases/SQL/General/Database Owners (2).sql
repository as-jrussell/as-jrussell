SELECT suser_sname( owner_sid ) [owner], name [database name] FROM sys.databases
where  (suser_sname( owner_sid ) <> 'sa' OR suser_sname( owner_sid ) IS NULL)
AND (database_id >=5 AND  name != 'DBA') 




select CONCAT('USE',' [', name,'] ','ALTER AUTHORIZATION ON DATABASE::',name,' ', 'TO [SA]')
FROM sys.databases
where  (suser_sname( owner_sid ) <> 'sa' OR suser_sname( owner_sid ) IS NULL)
AND (database_id >=5 AND  name != 'DBA') 
