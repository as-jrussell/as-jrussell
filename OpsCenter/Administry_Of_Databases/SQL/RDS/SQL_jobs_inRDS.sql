CREATE TABLE #Jobs (
    job_id UNIQUEIDENTIFIER,
    name VARCHAR(128),
    description VARCHAR(512),
    enabled BIT
);

INSERT INTO #Jobs
EXEC msdb.dbo.sp_help_job;

SELECT j.name AS job_name, j.description, js.step_id, js.step_name, js.command
FROM #Jobs j
INNER JOIN msdb.dbo.sysjobsteps js ON j.job_id = js.job_id;

