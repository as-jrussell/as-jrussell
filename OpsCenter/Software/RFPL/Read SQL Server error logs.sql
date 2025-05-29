--EXEC xp_ReadErrorLog 0, 1, N'Database',N'Initialization'

/*https://www.sqlshack.com/read-sql-server-error-logs-using-the-xp_readerrorlog-command/ */

EXEC xp_ReadErrorLog 0, 1, N''


	
EXEC xp_readerrorlog 
    0, 
    1, 
    N'', 
    N'', 
    N'2000-01-01 00:00:01.000',
    N'2023-01-01 00:00:01.000', 
    N'desc'



	EXEC xp_ReadErrorLog 0, 1, N'sql2000'
