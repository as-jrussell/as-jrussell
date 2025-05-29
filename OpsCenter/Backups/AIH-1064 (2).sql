SELECT
             @@SERVERNAME AS TargetServerName,
             SUSER_SNAME() AS ConnectedWith,
             DB_NAME() AS DefaultDB,
             client_net_address AS IPAddress
          FROM
              sys.dm_exec_connections
          WHERE
              session_id = @@SPID

SELECT * FROM OPENQUERY (
         [Unitrac-DB01], 
         'SELECT
             @@SERVERNAME AS TargetServerName,
             SUSER_SNAME() AS ConnectedWith,
             DB_NAME() AS DefaultDB,
             client_net_address AS IPAddress
          FROM
              sys.dm_exec_connections
          WHERE
              session_id = @@SPID
        ')