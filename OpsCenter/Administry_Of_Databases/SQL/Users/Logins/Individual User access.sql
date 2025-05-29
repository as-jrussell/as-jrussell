
SELECT [UserName]=CASE memberprinc.[type] WHEN 'S' THEN memberprinc.[name]
                  WHEN 'U' THEN ulogin.[name] COLLATE Latin1_General_CI_AI END, [UserType]=CASE memberprinc.[type] WHEN 'S' THEN 'SQL User'
                                                                                           WHEN 'U' THEN 'Windows User' END, [DatabaseUserName]=memberprinc.[name], [Role]=roleprinc.[name], [PermissionType]=perm.[permission_name], [PermissionState]=perm.[state_desc], [ObjectType]=obj.type_desc, --perm.[class_desc],   
    [ObjectName]=OBJECT_NAME(perm.major_id), [ColumnName]=col.[name]
FROM
    --Role/member associations
    sys.database_role_members members
    JOIN
    --Roles
    sys.database_principals roleprinc ON roleprinc.[principal_id]=members.[role_principal_id]
    JOIN
    --Role members (database users)
    sys.database_principals memberprinc ON memberprinc.[principal_id]=members.[member_principal_id]
    LEFT JOIN
    --Login accounts
    sys.login_token ulogin ON memberprinc.[sid]=ulogin.[sid]
    LEFT JOIN
    --Permissions
    sys.database_permissions perm ON perm.[grantee_principal_id]=roleprinc.[principal_id]
    LEFT JOIN
    --Table columns
    sys.columns col ON col.[object_id]=perm.major_id AND col.[column_id]=perm.[minor_id]
    LEFT JOIN sys.objects obj ON perm.[major_id]=obj.[object_id]
	where memberprinc.[name] like '%sa%'
	order by roleprinc.[name] asc 