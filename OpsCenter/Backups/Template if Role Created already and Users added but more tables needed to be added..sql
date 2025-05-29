DECLARE @AppRole VARCHAR(100) = 'PIMS_APP_ACCESS'
DECLARE @TargetDB VARCHAR(100) = 'UniTrac_DW'
DECLARE @Type VARCHAR(10) = 'SL'
DECLARE @Permission VARCHAR(100)
DECLARE @sqlcmd nvarchar(max) 

SELECT @Permission = permission_name
FROM   Fn_builtin_permissions(DEFAULT)
WHERE  type = @Type

SELECT  @sqlcmd ='
USE ' + @TargetDB
              + '
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''
              + objName + '''AND TYPE = ''' + @TYPE
              + ''' AND USER_NAME(grantee_principal_id) ='''
              + @AppRole + ''')
BEGIN
		GRANT ' + @Permission
              + ' ON [dbo]. [' + objName + '] TO  [' + @AppRole
              + '] 
	PRINT ''SUCCESS: GRANT ' + @Permission
              + ' was issued to ' + @AppRole + ' on ' + @TargetDB
              + '''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END'
--select * 
FROM   HDTStorage.dbo.[Brett-UniTrac_DW objects in DataStore] B
       LEFT JOIN sys.database_permissions P
              ON Object_name(P.major_id) = B.objName
                 AND User_name(P.grantee_principal_id) = 'PIMS_APP_ACCESS'
--WHERE User_name(P.grantee_principal_id) IS NULL
       


	   EXEC (@sqlcmd)