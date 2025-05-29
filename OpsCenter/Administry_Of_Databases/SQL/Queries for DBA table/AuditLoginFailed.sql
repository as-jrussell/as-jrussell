DECLARE @DBName NVARCHAR(50)=''
DECLARE @username NVARCHAR(50)=''
DECLARE @ClientHostName NVARCHAR(50)=''
DECLARE @BEGINDATE DATETIME = ''
DECLARE @ENDDATE DATETIME = Getdate()


IF @username <> ''
  BEGIN
        SELECT   FORMAT(DATEADD(HOUR, -5, TimeStampUTC), 'dddd, MMMM dd, yyyy hh:mm tt'),*
      FROM   dba.info.AuditLoginFailed A
      WHERE  ErrorMessage LIKE '%' + @username + '%'
      ORDER  BY TimeStampUTC DESC
  END
ELSE IF @BEGINDATE <> ''
  BEGIN
        SELECT   FORMAT(DATEADD(HOUR, -5, TimeStampUTC), 'dddd, MMMM dd, yyyy hh:mm tt'),*
      FROM   dba.info.AuditLoginFailed A
      WHERE  TimeStampUTC BETWEEN @BEGINDATE AND @ENDDATE
             AND ClientHostName LIKE '%' + @ClientHostName + '%'
      ORDER  BY TimeStampUTC DESC
  END
ELSE IF @ClientHostName <> ''
  BEGIN
        SELECT   FORMAT(DATEADD(HOUR, -5, TimeStampUTC), 'dddd, MMMM dd, yyyy hh:mm tt'),*
      FROM   dba.info.AuditLoginFailed A
      WHERE  ClientHostName LIKE '%' + @ClientHostName + '%'
      ORDER  BY TimeStampUTC DESC
  END
  ELSE
  BEGIN
        SELECT   FORMAT(DATEADD(HOUR, -5, TimeStampUTC), 'dddd, MMMM dd, yyyy hh:mm tt'),*
      FROM   dba.info.AuditLoginFailed A
	  WHERE CAST(TimeStampUTC AS DATE) >= CAST(GETDATE()-3 AS DATE) 
      ORDER  BY TimeStampUTC DESC
  END

   