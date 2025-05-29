DECLARE @SQL VARCHAR(max)
DECLARE @Share NVARCHAR(100)
DECLARE @multipleShare VARCHAR(1) = 'N'

IF @Share is NULL or  @Share  =''
BEGIN 
SELECT @Share = confvalue
  FROM   DBA.INFO.databaseConfig
            WHERE confkey  ='StorageGatewayPath'
END 


IF @multipleShare = 'N'
  BEGIN
      SELECT Concat('if (Test-Path -Path  "' + @Share + '\', SQLServerName, '"-PathType Container) { Write-Host "Folder exists for '
                                                                           + @Share + '\', SQLServerName, '"  } else {New-Item -ItemType Directory -Path "'
                                                                                                         + @Share + '', SQLServerName, '"}')
      FROM   DBA.INFO.INSTANCE
      UNION
      SELECT Concat('if (Test-Path -Path  "' + @Share + '\', SQLServerName, '\', DatabaseName, '"-PathType Container) { Write-Host "Folder exists for '
                                                                                              + @Share +  '\', SQLServerName, '\', DatabaseName, '"  } else {New-Item -ItemType Directory -Path "'
                                                                                                                                               + @Share + '\', SQLServerName, '\', DatabaseName, '"}')
      FROM   DBA.INFO.INSTANCE
             CROSS JOIN DBA.INFO.[DATABASE]
      UNION
      SELECT Concat('if (Test-Path -Path  "' + @Share + '\', SQLServerName, '\', DatabaseName, '\FULL"-PathType Container) { Write-Host "Folder exists for '
                                                                                              + @Share +  '\', SQLServerName, '\', DatabaseName, '\FULL"  } else {New-Item -ItemType Directory -Path "'
                                                                                                                                               + @Share + '\', SQLServerName, '\', DatabaseName, '\FULL"}')
      FROM   DBA.INFO.INSTANCE
             CROSS JOIN DBA.INFO.[DATABASE]
      UNION
      SELECT Concat('if (Test-Path -Path  "' + @Share + '\', SQLServerName, '\', DatabaseName, '\LOG"-PathType Container) { Write-Host "Folder exists for '
                                                                                              + @Share +  '\', SQLServerName, '\', DatabaseName, '\LOG"  } else {New-Item -ItemType Directory -Path "'
                                                                                                                                               + @Share + '\', SQLServerName, '\', DatabaseName, '\LOG"}')
      FROM   DBA.INFO.INSTANCE
             CROSS JOIN DBA.INFO.[DATABASE]

      UNION
      SELECT Concat('if (Test-Path -Path  "' + @Share + '\', SQLServerName, '\', DatabaseName, '\DIFF"-PathType Container) { Write-Host "Folder exists for '
                                                                                              + @Share +  '\', SQLServerName, '\', DatabaseName, '\DIFF"  } else {New-Item -ItemType Directory -Path "'
                                                                                                                                               + @Share + '\', SQLServerName, '\', DatabaseName, '\DIFF"}')
      FROM   DBA.INFO.INSTANCE
             CROSS JOIN DBA.INFO.[DATABASE]
  END
ELSE
  BEGIN
      IF Object_id(N'tempdb..#Shares') IS NOT NULL
        DROP TABLE #Shares

      CREATE TABLE #Shares
        (
           [Shares]    NVARCHAR(100),
           IsProcessed BIT
        )

      INSERT INTO #Shares
                  ([Shares],
                   IsProcessed)
      VALUES --IF THERE ARE OTHER MULTIPLE SHARE YOU WILL NEED TO UPDATE 
	  ('\\dbbkprdawstgy11.as.local\alss3sqlsprd01\',
                   0),
                  ('\\dbbkprdawstgy10.as.local\alss3sqlsprd01\',
                   0),
                  ('\\dbbkprdawstgy09.as.local\alss3sqlsprd01\',
                   0),
                  ('\\dbbkprdawstgy08.as.local\alss3sqlsprd01\',
                   0),
                  ('\\dbbkprdawstgy07.as.local\alss3sqlsprd01\',
                   0),
                  ('\\dbbkprdawstgy06.as.local\alss3sqlsprd01\',
                   0),
                  ('\\dbbkprdawstgy05.as.local\alss3sqlsprd01\',
                   0),
                  ('\\dbbkprdawstgy04.as.local\alss3sqlsprd01\',
                   0),
                  ('\\dbbkprdawstgy01.as.local\alss3sqlsprd01\',
                   0)

      WHILE EXISTS(SELECT *
                   FROM   #Shares
                   WHERE  IsProcessed = 0)
        BEGIN
            SELECT TOP 1 @Share = [Shares]
            FROM   #Shares
            WHERE  IsProcessed = 0

            SELECT @SQL = '
 select CONCAT(''if (Test-Path -Path  "'
                          + @Share
                          + ''',SQLServerName,''"-PathType Container) { Write-Host "Folder exists for '
                          + @Share
                          + ''',SQLServerName,''"  } else {New-Item -ItemType Directory -Path "'
                          + @Share
                          + ''',SQLServerName,''"}'') 
  from DBA.INFO.INSTANCE
  UNION
    select CONCAT(''if (Test-Path -Path  "'
                          + @Share
                          + ''',SQLServerName,''\'',DatabaseName,''"-PathType Container) { Write-Host "Folder exists for '
                          + @Share
                          + ''',SQLServerName,''\'',DatabaseName,''"  } else {New-Item -ItemType Directory -Path "'
                          + @Share
                          + ''',SQLServerName,''\'',DatabaseName,''"}'')  
from DBA.INFO.INSTANCE
CROSS JOIN DBA.INFO.[DATABASE]  
UNION
 select CONCAT(''if (Test-Path -Path  "'
                          + @Share
                          + ''',SQLServerName,''\'',DatabaseName,''\FULL"-PathType Container) { Write-Host "Folder exists for '
                          + @Share
                          + ''',SQLServerName,''\'',DatabaseName,''\FULL"  } else {New-Item -ItemType Directory -Path "'
                          + @Share
                          + ''',SQLServerName,''\'',DatabaseName,''\FULL"}'')  
  from DBA.INFO.INSTANCE
CROSS JOIN DBA.INFO.[DATABASE]  
UNION 
 select CONCAT(''if (Test-Path -Path  "'
                          + @Share
                          + ''',SQLServerName,''\'',DatabaseName,''\LOG"-PathType Container) { Write-Host "Folder exists for '
                          + @Share
                          + ''',SQLServerName,''\'',DatabaseName,''\LOG"  } else {New-Item -ItemType Directory -Path "'
                          + @Share + ''',SQLServerName,''\'',DatabaseName,''\LOG"}'')  
  from DBA.INFO.INSTANCE
CROSS JOIN DBA.INFO.[DATABASE]  
'

            EXEC ( @SQL )

            -- Update table
            UPDATE #Shares
            SET    IsProcessed = 1
            WHERE  Shares = @Share
        END
  END 
