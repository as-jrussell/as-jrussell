DECLARE @DBName NVARCHAR(50)=''
DECLARE @username NVARCHAR(50)=''
DECLARE @ClientHostName NVARCHAR(50)=''
DECLARE @BEGINDATE DATETIME = ''
DECLARE @ENDDATE DATETIME = Getdate()
DECLARE @ClientApp BIT = 1

IF @username <> ''
  BEGIN
      SELECT Dateadd(HOUR, -6, [LastLogin]) [Database Time],
             *
      FROM   DBA.info.LastLogin A
      WHERE  Username LIKE '%' + @username + '%'
             AND ClientHostName LIKE '%' + @ClientHostName + '%'
             AND DatabaseName LIKE '%' + @DBName + '%'
      ORDER  BY [LastLogin] DESC
  END
ELSE IF @DBName <> ''
  BEGIN
      SELECT Dateadd(HOUR, -6, [LastLogin]) [Database Time],
             *
      FROM   DBA.info.LastLogin A
      WHERE  DatabaseName IN ( @DBName )
             AND ClientHostName LIKE '%' + @ClientHostName + '%'
      ORDER  BY [LastLogin] DESC
  END
ELSE IF @BEGINDATE <> ''
  BEGIN
      SELECT Dateadd(HOUR, -6, [LastLogin]) [Database Time],
             *
      FROM   DBA.info.LastLogin A
      WHERE  [LastLogin] BETWEEN @BEGINDATE AND @ENDDATE
             AND ClientHostName LIKE '%' + @ClientHostName + '%'
      ORDER  BY [LastLogin] DESC
  END
ELSE IF @ClientHostName <> ''
  BEGIN
      IF @ClientApp = 0
        BEGIN
            SELECT Dateadd(HOUR, -6, [LastLogin]) [Database Time],
                   *
            FROM   DBA.info.LastLogin A
            WHERE  ClientHostName LIKE '%' + @ClientHostName + '%'
                   AND ClientAppName LIKE '%Microsoft SQL Server Management Studio%'
            ORDER  BY [LastLogin] DESC
        END
      ELSE
        BEGIN
            SELECT Dateadd(HOUR, -6, [LastLogin]) [Database Time],
                   *
            FROM   DBA.info.LastLogin A
            WHERE  ClientHostName LIKE '%' + @ClientHostName + '%'
            ORDER  BY [LastLogin] DESC
        END
  END
ELSE
  BEGIN
      SELECT Dateadd(HOUR, -6, [LastLogin]) [Database Time],
             *
      FROM   DBA.info.LastLogin A
      WHERE  Cast([LastLogin] AS DATE) = Cast(Getdate() AS DATE)
      ORDER  BY [LastLogin] DESC
  END
/*

---Time Zone Check
DECLARE @TimeZone VARCHAR(50)
EXEC MASTER.dbo.xp_regread 'HKEY_LOCAL_MACHINE', 
'SYSTEM\\CurrentControlSet\\Control\\TimeZoneInformation', 
'TimeZoneKeyName', 
@TimeZone OUT 
SELECT @TimeZone





 CONVERT(DATETIME, @utcTimestamp AT TIME ZONE 'UTC' AT TIME ZONE
select CASE WHEN MAX([LastLogin]) is null THEN 'Never been access' ELSE
	CAST(MAX([LastLogin])AS nvarchar(255)) END [Last time DB access], D.name 
	--select *
	from sys.databases D 
	LEFt JOIN DBA.info.LastLogin A on D.name = A.DatabaseName
	WHERE  D.Database_ID >= '5'
	GROUP BY D.name
	ORDER BY MAX([LastLogin]) desc 


	 = CASE max_size
                             WHEN 0 THEN ''DISABLED''
                             WHEN -1 THEN '' Unrestricted''
                             ELSE '' Restricted to ''
                                  + Cast(max_size/(128*1024) AS VARCHAR(10))
                                  + '' GB''

							   
							   

select CASE WHEN MAX([LastLogin]) is null THEN 'Never logged in' ELSE
	CAST(MAX([LastLogin])AS nvarchar(255)) END [Last time DB access], D.name 
	--select *
	from sys.server_principals D 
	LEFt JOIN DBA.info.LastLogin A on D.name = A.UserName 
	WHERE D.type  in ('U', 'S') 
	AND
	is_disabled = '0'
	GROUP BY D.name 
	ORDER BY MAX([LastLogin]) desc 
							   
			SELECT MIN([LastLogin]) 				   
							   FROM  DBA.info.LastLogin 
							   
							   
							   */
