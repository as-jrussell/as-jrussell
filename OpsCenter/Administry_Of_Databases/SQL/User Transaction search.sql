SELECT
	[Current LSN],
	[Operation],
	[Context],
	[Transaction ID],
	[Description],
	[Begin Time],
	(SELECT SUSER_SNAME ([Transaction SID])) [User],
	[Transaction SID]
FROM
	fn_dblog (NULL, NULL)
	WHERE 	(SELECT SUSER_SNAME ([Transaction SID])) is not null





	SELECT [Current LSN]
		,[Operation]
		,[Context]
		,[Transaction ID]
		,[Description]
		,[Begin Time]
			,(SELECT SUSER_SNAME ([Transaction SID])) [User]
		,[Transaction SID]
FROM fn_dblog (NULL,NULL)
INNER JOIN(SELECT [Transaction ID] AS tid
FROM fn_dblog(NULL,NULL)
WHERE [Transaction Name] LIKE 'DROPOBJ%')fd ON [Transaction ID] = fd.tid
AND
	(SELECT SUSER_SNAME ([Transaction SID])) is not null




SELECT [Current LSN]
		,[Operation]
		,[Context]
		,[Transaction ID]
		,[Description]
		,[Begin Time]
		,[Transaction SID]
		,SUSER_SNAME ([Transaction SID]) AS WhoDidIt
FROM fn_dblog (NULL,NULL)
INNER JOIN(SELECT [Transaction ID] AS tid
FROM fn_dblog(NULL,NULL)
WHERE [Transaction Name] LIKE 'DROPOBJ%')fd ON [Transaction ID] = fd.tid