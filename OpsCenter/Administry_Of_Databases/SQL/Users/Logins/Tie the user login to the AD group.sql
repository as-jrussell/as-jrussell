DECLARE @cmd VARCHAR(500),
@account VARCHAR(100) = 'ELDREDGE_A\IT Sys Admins'
,@members VARCHAR(1) = 0 --- 0 - Shows members of the group (only works with AD groups) 
,@DryRun              INT = 0



IF Object_id(N'tempdb..#1') IS NOT NULL
  DROP TABLE #1

CREATE TABLE #1
  (		
	
     [Account Name] VARCHAR(250),
     [Type] VARCHAR(20),
     [Privilege] VARCHAR(20),
	 [Mapped login Name] VARCHAR(250),
     [permission path]       VARCHAR(max)
  )



IF @account <> '' AND @members = 1
BEGIN 
SET @cmd='exec xp_logininfo  ''' + @account+''''
  END

ELSE IF @account = '' AND @members = 1
BEGIN 

SET @cmd='exec xp_logininfo'

END 

ELSE IF @account <> '' AND @members = 0
BEGIN 

SET @cmd='exec xp_logininfo  ''' + @account+''', ''members'';'

END 



IF @DryRun = 0
 BEGIN
INSERT INTO #1
EXEC (@cmd )


SELECT *
FROM   #1
  END
ELSE
  BEGIN
      PRINT ( @cmd )
  END 


