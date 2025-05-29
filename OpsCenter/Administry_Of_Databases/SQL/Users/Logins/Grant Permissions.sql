use dbMaint	

select * from sys.objects
where name ='EMail_RequestsInsert'

	SELECT
		class_desc 
	  , CASE WHEN class = 0 THEN DB_NAME()
			 WHEN class = 1 THEN OBJECT_NAME(major_id)
			 WHEN class = 3 THEN SCHEMA_NAME(major_id) END [Securable]
	  , USER_NAME(grantee_principal_id) [User]
	  , permission_name
	  , state_desc
	FROM sys.database_permissions
	where USER_NAME(grantee_principal_id) ='ELDREDGE_A\SQL_Bond_Mgmt_NP_svc'
	
	--permission_name = 'IMPERSONATE'


	select top 5 * from EMail_Requests
	--where Created >= '2021-08-01'
	order by uid desc 