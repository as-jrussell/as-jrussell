
SELECT dpr.name [User name], obj.name,obj.type_desc [Type of Program],dp.permission_name, dp.state_desc, dpr.type_desc [Window or SQL Account]
    FROM sys.objects obj
    INNER JOIN sys.database_permissions dp ON dp.major_id = obj.object_id
	INNER JOIN sys.database_principals dpr on dp.grantee_principal_id = dpr.principal_id
	