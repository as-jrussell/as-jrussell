DECLARE @DBName NVARCHAR(50)=''
DECLARE @username NVARCHAR(50)='svc'
DECLARE @ClientHostName NVARCHAR(50)=''
DECLARE @ClientApp NVARCHAR(50)='jTDS'
DECLARE @BEGINDATE DATETIME = '2023-02-10'
DECLARE @ENDDATE DATETIME = Getdate()


IF @username <> ''
  BEGIN
      SELECT *
      FROM   dba.info.AuditLogin A
      WHERE  Username LIKE '%' + @username + '%'
             AND ClientHostName LIKE '%' + @ClientHostName + '%'
             AND ClientAppName LIKE '%' + @ClientApp + '%'
			 AnD TimeStampUTC BETWEEN @BEGINDATE AND @ENDDATE
      ORDER  BY TimeStampUTC DESC
  END
ELSE IF @DBName <> ''
  BEGIN
      SELECT *
      FROM   dba.info.AuditLogin A
      WHERE  DatabaseName IN ( @DBName )
             AND ClientHostName LIKE '%' + @ClientHostName + '%'
      ORDER  BY TimeStampUTC DESC
  END
ELSE IF @BEGINDATE <> ''
  BEGIN
      SELECT *
      FROM   dba.info.AuditLogin A
      WHERE  TimeStampUTC BETWEEN @BEGINDATE AND @ENDDATE
             AND ClientHostName LIKE '%' + @ClientHostName + '%'
      ORDER  BY TimeStampUTC DESC
  END
ELSE
  BEGIN
      SELECT TOP 10 *
      FROM   dba.info.AuditLogin A
      WHERE  ClientHostName LIKE '%' + @ClientHostName + '%'
      ORDER  BY TimeStampUTC DESC
  END
/*


select CASE WHEN MAX(TimeStampUTC) is null THEN 'Never been access' ELSE
	CAST(MAX(TimeStampUTC)AS nvarchar(255)) END [Last time DB access], D.name 
	--select *
	from sys.databases D 
	LEFt JOIN dba.info.AuditLogin A on D.name = A.DatabaseName
	WHERE  D.Database_ID >= '5'
	GROUP BY D.name
	ORDER BY MAX(TimeStampUTC) desc 


	 = CASE max_size
                             WHEN 0 THEN ''DISABLED''
                             WHEN -1 THEN '' Unrestricted''
                             ELSE '' Restricted to ''
                                  + Cast(max_size/(128*1024) AS VARCHAR(10))
                                  + '' GB''

							   
							   

select CASE WHEN MAX(TimeStampUTC) is null THEN 'Never logged in' ELSE
	CAST(MAX(TimeStampUTC)AS nvarchar(255)) END [Last time DB access], D.name 
	--select *
	from sys.server_principals D 
	LEFt JOIN dba.info.AuditLogin A on D.name = A.UserName 
	WHERE D.type  in ('U', 'S') 
	AND
	is_disabled = '0'
	GROUP BY D.name 
	ORDER BY MAX(TimeStampUTC) desc 
							   
							   
							   
							   
							   
							   */






