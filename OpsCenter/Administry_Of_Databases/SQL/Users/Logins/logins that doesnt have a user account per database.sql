DECLARE @cmd1 VARCHAR(max)

SET @cmd1=' use [?]
SELECT DB_NAME(), d.[name]            AS ''DB User'',
       d.sid               AS ''DB SID'',
       s.[name]            AS ''Login'',
       s.sid               AS ''Server SID'',
       Max(A.TimeStampUTC) [Last Login],
       A.DatabaseName
--select S.*
FROM   sys.database_principals d
       RIGHT JOIN sys.server_principals s
               ON d.sid = s.sid
       JOIN dba.info.auditlogin A
         ON A.UserName = S.name
WHERE  DatabaseName = Db_name()
       AND s.type NOT IN ( ''R'', ''C'', ''K'' )
       AND s.is_disabled = ''0''
       AND d.[name] IS NULL
       AND s.[name] NOT IN (SELECT m.name AS Principal
                            FROM   master.sys.server_role_members rm
                                   INNER JOIN master.sys.server_principals r
                                           ON r.principal_id = rm.role_principal_id
                                              AND r.type = ''R''
                                   INNER JOIN master.sys.server_principals m
                                           ON m.principal_id = rm.member_principal_id)
       AND s.name NOT IN ((SELECT p.name
                           FROM   sys.database_role_members rm
                                  INNER JOIN sys.database_principals r
                                          ON r.principal_id = rm.role_principal_id
                                             AND r.type = ''R''
                                  INNER JOIN sys.database_principals p
                                          ON p.principal_id = member_principal_id))
GROUP  BY d.[name],
          d.sid,
          s.[name],
          s.sid,
          A.DatabaseName '

 EXEC Sp_msforeachdb @cmd1