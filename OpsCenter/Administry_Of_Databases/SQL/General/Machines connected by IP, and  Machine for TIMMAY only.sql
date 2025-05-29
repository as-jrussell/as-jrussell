use tempdb

DECLARE @username NVARCHAR(50)='disuser'
DECLARE @DBNAME NVARCHAR(50)=''
DECLARE @sessionid INT=''
DECLARE @Info NVARCHAR(1) = 'Y'



IF @info = 'Y' AND @DBNAME <> ''
  BEGIN
      SELECT dec.client_net_address,
             des.host_name,des.login_name,
             dest.text
           --  des.session_id, CONCAT('KILL ', des.session_id)
   --select *
   FROM   sys.dm_exec_sessions AS des
             INNER JOIN sys.dm_exec_connections AS dec
                     ON des.session_id = dec.session_id
           --  INNER JOIN sys.databases DB
                     --ON DB.database_id = des.database_id
             CROSS APPLY sys.Dm_exec_sql_text(dec.most_recent_sql_handle) dest
      WHERE -- db.name = @DBNAME
	   des.login_name LIKE '%' + @username + '%'
--	  AND dest.text LIKE '%INSERT%'
--	  AND des.session_id = @sessionid
      ORDER  BY des.program_name,des.login_name,
                dec.client_net_address
  END
  ELSE
IF @username <> ''
  -- Get a count of SQL connections by IP address
  SELECT MIN(dec.connect_time)[Connection],  dec.client_net_address,
         des.program_name,
         des.host_name,
         des.login_name,
      --   db.name,
         Count(dec.session_id) AS connection_count
  FROM   sys.dm_exec_sessions AS des
         INNER JOIN sys.dm_exec_connections AS dec
                 ON des.session_id = dec.session_id
         --INNER JOIN sys.databases DB
         --        ON DB.database_id = des.database_id
  WHERE  des.login_name LIKE '%' + @username + '%'
  GROUP  BY dec.client_net_address,
            des.program_name,
            des.host_name,
            des.login_name
  -- HAVING COUNT(dec.session_id) > 1
  ORDER  BY des.program_name,
            dec.client_net_address
ELSE IF @info <> 'Y' AND @DBNAME <> ''
  -- Get a count of SQL connections by IP address
  SELECT dec.client_net_address,
         des.program_name,
         des.host_name,
         des.login_name,
       --  db.name,
         Count(dec.session_id) AS connection_count
  FROM   sys.dm_exec_sessions AS des
         INNER JOIN sys.dm_exec_connections AS dec
                 ON des.session_id = dec.session_id
         --INNER JOIN sys.databases DB
         --        ON DB.database_id = des.database_id
--  WHERE  db.name = @DBNAME
  GROUP  BY dec.client_net_address,
            des.program_name,
            des.host_name,
            des.login_name
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
        --     db.name,
             Count(dec.session_id) AS connection_count
      FROM   sys.dm_exec_sessions AS des
             INNER JOIN sys.dm_exec_connections AS dec
                     ON des.session_id = dec.session_id
             --INNER JOIN sys.databases DB
             --        ON DB.database_id = des.database_id
      GROUP  BY dec.client_net_address,
                des.program_name,
                des.host_name,
                des.login_name
     --           db.name
      -- HAVING COUNT(dec.session_id) > 1
      ORDER  BY des.program_name,
                dec.client_net_address
  END
/*



							   
							   
							   
							   
							   */
