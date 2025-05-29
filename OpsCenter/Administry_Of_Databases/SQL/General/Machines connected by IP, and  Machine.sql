use tempdb

DECLARE @UserName NVARCHAR(50)=''
DECLARE @HostName  NVARCHAR(50)=''
DECLARE @DatabaseName NVARCHAR(50)=''
DECLARE @sessionid INT=''
DECLARE @ProgramFiles NVARCHAR(100) = ''
DECLARE @Info NVARCHAR(1) = ''



IF @info = 'Y' AND (@DatabaseName <> '' OR @UserName <> '' OR @HostName <> '')
  BEGIN
      SELECT des.session_id,dec.client_net_address,
             des.host_name,des.login_name,
             dest.text, 
             login_time,last_request_start_time, last_request_end_time, CONCAT('KILL ', des.session_id) [End Session?]
      FROM   sys.dm_exec_sessions AS des
             INNER JOIN sys.dm_exec_connections AS dec
                     ON des.session_id = dec.session_id
             INNER JOIN sys.databases DB
                     ON DB.database_id = des.database_id
             CROSS APPLY sys.Dm_exec_sql_text(dec.most_recent_sql_handle) dest
      WHERE  db.name LIKE '%' + @DatabaseName + '%' 
	  AND des.login_name LIKE '%' + @UserName + '%'
	  AND des.host_name LIKE '%' + @HostName + '%'
	  AND des.program_name LIKE '%' + @ProgramFiles + '%'
      ORDER  BY des.program_name,des.login_name,
                dec.client_net_address
  END
  ELSE
IF @UserName <> ''
  -- Get a count of SQL connections by IP address
  SELECT MIN(dec.connect_time)[Connection],  dec.client_net_address,
         des.program_name,
         des.host_name,
         des.login_name,
         db.name,last_request_start_time, last_request_end_time,
         Count(dec.session_id) AS connection_count
  FROM   sys.dm_exec_sessions AS des
         INNER JOIN sys.dm_exec_connections AS dec
                 ON des.session_id = dec.session_id
         INNER JOIN sys.databases DB
                 ON DB.database_id = des.database_id
  WHERE  des.login_name LIKE '%' + @UserName + '%'
  GROUP  BY dec.client_net_address,
            des.program_name,
            des.host_name,
            des.login_name,
            db.name, last_request_start_time, last_request_end_time
  -- HAVING COUNT(dec.session_id) > 1
  ORDER  BY des.program_name,
            dec.client_net_address
ELSE IF @info <> 'Y' AND @DatabaseName <> ''
  -- Get a count of SQL connections by IP address
  SELECT dec.client_net_address,
         des.program_name,
         des.host_name,
         des.login_name,
         db.name, last_request_start_time, last_request_end_time,
         Count(dec.session_id) AS connection_count
  FROM   sys.dm_exec_sessions AS des
         INNER JOIN sys.dm_exec_connections AS dec
                 ON des.session_id = dec.session_id
         INNER JOIN sys.databases DB
                 ON DB.database_id = des.database_id
  WHERE  db.name = @DatabaseName
  GROUP  BY dec.client_net_address,
            des.program_name,
            des.host_name,
            des.login_name,
            db.name, last_request_start_time, last_request_end_time
  -- HAVING COUNT(dec.session_id) > 1
  ORDER  BY Count(dec.session_id) DESC,
            des.program_name,
            dec.client_net_address
ELSE IF @HostName  <> ''
  -- Get a count of SQL connections by IP address
  SELECT dec.client_net_address,
         des.program_name,
         des.host_name,
         des.login_name,
         db.name,last_request_start_time, last_request_end_time,
         Count(dec.session_id) AS connection_count
  FROM   sys.dm_exec_sessions AS des
         INNER JOIN sys.dm_exec_connections AS dec
                 ON des.session_id = dec.session_id
         INNER JOIN sys.databases DB
                 ON DB.database_id = des.database_id
  WHERE  des.host_name = @HostName
  GROUP  BY dec.client_net_address,
            des.program_name,
            des.host_name,
            des.login_name,
            db.name, last_request_start_time, last_request_end_time
  -- HAVING COUNT(dec.session_id) > 1
  ORDER  BY Count(dec.session_id) DESC,
            des.program_name,
            dec.client_net_address
ELSE IF @ProgramFiles  <> ''
  -- Get a count of SQL connections by IP address
  SELECT dec.client_net_address,
         des.program_name,
         des.host_name,
         des.login_name,
         db.name,last_request_start_time, last_request_end_time,
         Count(dec.session_id) AS connection_count
  FROM   sys.dm_exec_sessions AS des
         INNER JOIN sys.dm_exec_connections AS dec
                 ON des.session_id = dec.session_id
         INNER JOIN sys.databases DB
                 ON DB.database_id = des.database_id
  WHERE  des.program_name LIKE '%' + @ProgramFiles + '%'
  GROUP  BY dec.client_net_address,
            des.program_name,
            des.host_name,
            des.login_name,
            db.name, last_request_start_time, last_request_end_time
  -- HAVING COUNT(dec.session_id) > 1
  ORDER  BY Count(dec.session_id) DESC,
            des.program_name,
            dec.client_net_address
ELSE
  BEGIN
      SELECT dec.client_net_address,
             des.program_name,
             des.host_name,
             des.login_name,
             db.name,last_request_start_time, last_request_end_time,
             Count(dec.session_id) AS connection_count
      FROM   sys.dm_exec_sessions AS des
             INNER JOIN sys.dm_exec_connections AS dec
                     ON des.session_id = dec.session_id
             INNER JOIN sys.databases DB
                     ON DB.database_id = des.database_id
      GROUP  BY dec.client_net_address,
                des.program_name,
                des.host_name,
                des.login_name,
                db.name, last_request_start_time, last_request_end_time
      -- HAVING COUNT(dec.session_id) > 1
      ORDER  BY last_request_start_time asc, 
	  des.program_name,
                dec.client_net_address
  END
/*



							   
							   
							   
							   
							   */
