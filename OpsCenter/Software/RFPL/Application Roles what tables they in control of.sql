DECLARE @TargetDB nvarchar(100) = '' 

DECLARE @sqlcmd varchar(MAX)

--SELECT @DBNAME = name from sys.databases WHERE database_id in (SELECT max(database_id) from sys.databases)

   SELECT @sqlcmd = 'USE '+ @TargetDB +';


select rp.name [Application Role Name] ,rp.type_desc, mp.name [Login Name], mp.type, mp.default_schema_name
	from sys.database_role_members dm
	join  sys.database_principals rp on rp.principal_id = dm.role_principal_id
	join  sys.database_principals mp on mp.principal_id = dm.member_principal_id
	WHERE rp.name = ''DB_OWNER'' OR  MP.type = ''X''
	
SELECT @@SERVERNAME [Server Name], * from sys.databases 
where name = '''+ @TargetDB +'''
	
	'


	EXEC (@sqlcmd)




