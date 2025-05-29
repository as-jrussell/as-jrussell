
--add username where the username field is and run on each database (script for one database)
sp_change_users_login 'AUTO_FIX', 'username'

--add username where the username field is and run on each database (script for multiple database)
SELECT CONCAT('USE ',name, ' sp_change_users_login ''AUTO_FIX'', ''','username''')
    FROM sys.databases
	where (database_id >=5 AND  name != 'DBA') 