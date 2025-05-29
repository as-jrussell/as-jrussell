

USE MSDB
SELECT name AS [Job Name]
         ,CONVERT(VARCHAR,DATEADD(S,(run_time/10000)*60*60 /* hours */  
          +((run_time - (run_time/10000) * 10000)/100) * 60 /* mins */  
          + (run_time - (run_time/100) * 100)  /* secs */
           ,CONVERT(DATETIME,RTRIM(run_date),113)),100) AS [Time Run]
         ,CASE WHEN enabled=1 THEN 'Enabled'  
               ELSE 'Disabled'  
          END [Job Status]
         ,CASE WHEN SJH.run_status=0 THEN 'Failed'
                     WHEN SJH.run_status=1 THEN 'Succeeded'
                     WHEN SJH.run_status=2 THEN 'Retry'
                     WHEN SJH.run_status=3 THEN 'Cancelled'
               ELSE 'Unknown'  
          END [Job Outcome]
FROM   sysjobhistory SJH  
JOIN   sysjobs SJ  
ON     SJH.job_id=sj.job_id  
WHERE  step_id=0  
AND    DATEADD(S,  
  (run_time/10000)*60*60 /* hours */  
  +((run_time - (run_time/10000) * 10000)/100) * 60 /* mins */  
  + (run_time - (run_time/100) * 100)  /* secs */,  
  CONVERT(DATETIME,RTRIM(run_date),113)) >= DATEADD(d,-1,GetDate())  
ORDER BY name,run_date,run_time  



IF OBJECT_ID('tempdb.dbo.#RunningJobs') IS NOT NULL
      DROP TABLE #RunningJobs
CREATE TABLE #RunningJobs (   
Job_ID UNIQUEIDENTIFIER,   
Last_Run_Date INT,   
Last_Run_Time INT,   
Next_Run_Date INT,   
Next_Run_Time INT,   
Next_Run_Schedule_ID INT,   
Requested_To_Run INT,   
Request_Source INT,   
Request_Source_ID VARCHAR(100),   
Running INT,   
Current_Step INT,   
Current_Retry_Attempt INT,   
State INT )     
      
INSERT INTO #RunningJobs EXEC master.dbo.xp_sqlagent_enum_jobs 1,garbage   
  
SELECT     
  name AS [Job Name]
 ,CASE WHEN next_run_date=0 THEN '[Not scheduled]' ELSE
   CONVERT(VARCHAR,DATEADD(S,(next_run_time/10000)*60*60 /* hours */  
  +((next_run_time - (next_run_time/10000) * 10000)/100) * 60 /* mins */  
  + (next_run_time - (next_run_time/100) * 100)  /* secs */,  
  CONVERT(DATETIME,RTRIM(next_run_date),112)),100) END AS [Start Time]
FROM     #RunningJobs JSR  
JOIN     msdb.dbo.sysjobs  
ON       JSR.Job_ID=sysjobs.job_id  
WHERE    Running=1 -- i.e. still running  
ORDER BY name,next_run_date,next_run_time 