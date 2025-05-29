DECLARE @Role varchar(100) = 'OCR_DCS_ACCESS'
DECLARE @permissionType varchar(100)='EXECUTE'



SELECT 
    pr.name AS PrincipalName,
    pr.type_desc AS PrincipalType,
    dp.state_desc AS PermissionState,
    dp.permission_name AS PermissionName,
    o.name AS ObjectName,
    o.type_desc AS ObjectType
FROM 
    sys.database_permissions AS dp
INNER JOIN 
    sys.database_principals AS pr
    ON dp.grantee_principal_id = pr.principal_id
LEFT JOIN 
    sys.objects AS o
    ON dp.major_id = o.object_id
	where dp.permission_name =  @permissionType
	and pr.name like '%'+ @Role+ '%' 
ORDER BY 
    pr.name, dp.permission_name, o.name;


	


IF @Role != '' OR @Role IS NOT NULL

BEGIN
SELECT 
    dp.name AS UserName,
    dp.type_desc AS UserType,
    dr.name AS RoleName
FROM 
    sys.database_role_members AS drm
INNER JOIN 
    sys.database_principals AS dp
    ON drm.member_principal_id = dp.principal_id
INNER JOIN 
    sys.database_principals AS dr
    ON drm.role_principal_id = dr.principal_id
WHERE 
    dr.name IN( @Role)
ORDER BY 
    dp.name;
	END

