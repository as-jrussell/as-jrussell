USE msdb;

GO

DECLARE @job_name NVARCHAR(255) = 'Report: UniTrac Escrow Report'

IF EXISTS (SELECT *
           FROM   sys.databases
           WHERE  name = 'rdsadmin')
  BEGIN
      EXEC msdb.dbo.Sp_help_job
        @job_name = @job_name
  END
ELSE
  BEGIN
      SELECT j.name      AS Job_Name,
             s.step_name AS Step_Name,
             s.step_id,
             CASE s.subsystem -- Identify step type (optional)
               WHEN N'SQL' THEN 'T-SQL Script'
               WHEN N'CmdExec' THEN 'Operating System Command'
               ELSE s.subsystem
             END         AS Step_Type,
             s.command   AS Step_Command
      FROM   msdb.dbo.sysjobs j
             INNER JOIN msdb.dbo.sysjobsteps s
                     ON j.job_id = s.job_id
      WHERE  j.name = @job_name
      ORDER  BY s.step_id ASC,
                j.name;
  END 



