-- Create a temporary table to store the output
--DROP TABLE #CmdOutput;
DECLARE @InstanceName NVARCHAR(100) = 'SQLSPRDAWEC14.COLO.AS.LOCAL'
DECLARE @DatabaseName NVARCHAR(100) = 'DBA'
DECLARE @AccountName NVARCHAR(100) = 'eldredge_a\cclark'
DECLARE @sqlcmd NVARCHAR(MAX)
DECLARE @DryRun INT = 0

IF Object_id(N'tempdb..#CmdOutput ') IS NOT NULL
  DROP TABLE #CmdOutput

CREATE TABLE #CmdOutput
  (
     OutputLine VARCHAR(8000)
  );

SELECT @sqlcmd = '
INSERT INTO #CmdOutput (OutputLine)
EXEC xp_cmdshell ''powershell.exe -Command " Invoke-SQLcmd -QueryTimeout 0 -Server '''''
                 + @InstanceName + ''''' -Database '
                 + @DatabaseName + ' ''''select groupname, accountname from info.GroupMembership where AccountName = MappedLoginName" '''' "''

SELECT ''' + @InstanceName
                 + ''' [Server], LTRIM(SUBSTRING(OutputLine, 1, 40)) AS [groupname],
LTRIM(SUBSTRING(OutputLine, 41, 100)) AS [accountname]
FROM #CmdOutput
where OutputLine like ''%' + @AccountName
                 + '%''
UNION 
select  '''+@@SERVERNAME+''',groupname, accountname from dba.info.GroupMembership
where AccountName = ''' + @AccountName
                 + '''
and AccountName = MappedLoginName'

IF @DryRun = 0
  BEGIN
      EXEC ( @sqlcmd)
  END
ELSE
  BEGIN
      PRINT ( @sqlcmd )
  END 
