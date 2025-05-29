USE [master]
GO
CREATE LOGIN [ELDREDGE_A\SvcClmIsoImportTest] FROM WINDOWS WITH DEFAULT_DATABASE=[RepoPlusAnalytics]
GO

USE RepoPlusAnalytics

CREATE USER [ELDREDGE_A\SvcClmIsoImportTest] FOR LOGIN [ELDREDGE_A\SvcClmIsoImportTest];

/* Create App Role */
CREATE ROLE [REPO_APP_ACCESS] AUTHORIZATION [dbo];

/* Add object and permissions to role */
GRANT SELECT ON [RepoPlusAnalytics].[dbo].[IsoInsuranceData] TO [REPO_APP_ACCESS];
GRANT SELECT ON [RepoPlusAnalytics].[dbo].[IsoClaimData] TO [REPO_APP_ACCESS];



/* Add members to new role */
ALTER ROLE [REPO_APP_ACCESS] ADD MEMBER [ELDREDGE_A\SvcClmIsoImportTest];

USE RepoPlusAnalytics

select rp.name [Application Role Name] ,rp.type_desc, mp.name [Login Name], mp.type, mp.default_schema_name 
	--select *
	from sys.database_role_members dm
	join  sys.database_principals rp on rp.principal_id = dm.role_principal_id
	join  sys.database_principals mp on mp.principal_id = dm.member_principal_id
	where rp.name = 'REPO_APP_ACCESS'

	SELECT
		class_desc 
	  , CASE WHEN class = 0 THEN DB_NAME()
			 WHEN class = 1 THEN OBJECT_NAME(major_id)
			 WHEN class = 3 THEN SCHEMA_NAME(major_id) END [Securable]
	  , USER_NAME(grantee_principal_id) [User]
	  , permission_name
	  , state_desc
	FROM sys.database_permissions
	where USER_NAME(grantee_principal_id) ='REPO_APP_ACCESS'

/*

USE [master]
GO

/****** Object:  Login [ELDREDGE_A\SvcClmIsoImportTest]    Script Date: 5/11/2021 4:20:09 PM ******/
DROP LOGIN [ELDREDGE_A\SvcClmIsoImportTest]
GO



USE [RepoPlusAnalytics]
GO
ALTER ROLE [REPO_APP_ACCESS] DROP MEMBER [ELDREDGE_A\SvcClmIsoImportTest]
GO

DROP ROLE [REPO_APP_ACCESS]


DROP USER [ELDREDGE_A\SvcClmIsoImportTest]
*/

