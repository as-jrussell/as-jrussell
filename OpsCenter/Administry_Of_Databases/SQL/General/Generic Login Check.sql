

	SELECT
		MAX(login_time)AS[Last Login Time],login_name [Login]
	--SELECT LOGIN_Name, *
	FROM
		sys.dm_exec_sessions
	WHERE LOGIN_Name in ('')
		GROUP BY login_name;



		SELECT LOGIN_Name, *
	FROM
		sys.dm_exec_sessions
		where LOGIN_Name <> 'SA'
	order by login_time desc 

