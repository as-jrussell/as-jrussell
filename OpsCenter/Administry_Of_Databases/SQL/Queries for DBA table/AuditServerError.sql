
DECLARE @username NVARCHAR(50)=''
DECLARE @ClientHostName NVARCHAR(50)=''
DECLARE @Error NVARCHAR(20) = ''
DECLARE @BEGINDATE DATETIME = ''
DECLARE @ENDDATE DATETIME = Getdate()
DECLARE @DatabaseIncluded INT  --- 0 only gives you specific DB and 1 excludes specific DB
DECLARE @DBName NVARCHAR(50)=''

IF @username <> '' 
  BEGIN
      SELECT *
      FROM   dba.info.AuditServerError A
      WHERE  Username LIKE '%' + @username + '%'
             AND @DBName LIKE '%' + @DBName + '%'
      ORDER  BY TimeStampUTC DESC
  END
ELSE IF @DBName <> '' AND @DatabaseIncluded = 0
  BEGIN
      SELECT *
      FROM   dba.info.AuditServerError A
      WHERE  DatabaseName IN ( @DBName )
      ORDER  BY TimeStampUTC DESC
  END
ELSE IF @DBName <> '' AND @DatabaseIncluded = 1 
  BEGIN
      SELECT *
      FROM   dba.info.AuditServerError A
      WHERE  DatabaseName NOT IN ( @DBName )
      ORDER  BY TimeStampUTC DESC
  END
ELSE IF @BEGINDATE <> '' 
  BEGIN
      SELECT *
      FROM   dba.info.AuditServerError A
      WHERE  TimeStampUTC BETWEEN @BEGINDATE AND @ENDDATE
             AND @DBName LIKE '%' + @DBName + '%'
      ORDER  BY TimeStampUTC DESC
  END
  ELSE IF @Error <> '' AND @DatabaseIncluded = 0
  BEGIN
      SELECT *
      FROM   dba.info.AuditServerError A
      WHERE  ErrorMessage like '%' + @Error + '%'
             AND @DBName LIKE '%' + @DBName + '%'
      ORDER  BY TimeStampUTC DESC
  END
    ELSE IF @Error <> '' AND @DatabaseIncluded = 1
  BEGIN
      SELECT *
      FROM   dba.info.AuditServerError A
      WHERE  ErrorMessage like '%' + @Error + '%'
             AND @DBName NOT LIKE '%' + @DBName + '%'
      ORDER  BY TimeStampUTC DESC
  END
ELSE
  BEGIN
      SELECT         DATEADD(HOUR, -6, TimeStampUTC) [Database Time],*
      FROM   dba.info.AuditServerError A
      WHERE  @DBName LIKE '%' + @DBName + '%'
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






