--To display the lead blocking session, execute the following code. 

EXEC [PerfStats].[dbo].[CaptureBlockingInfo] 

 
 /*
If the lead blocker is a person:   

Contact the individual 

Confirm they are having problems 

Kill session - submit Emergency Request for Change  

If the lead blocker is an application account: 

Research into how performance can be improved 

Contact application owner or sysadmin 

If the lead blocker is a system SQL account: 

Contact the DBA team 

 

 Was the Lead blocker recorded  */ 
SELECT TOP 1 * 
FROM [PerfStats].[dbo].[BlockingSession] 
ORDER BY Capture_DT DESC 
 
/*  Did the blocked sessions get recorded  */ 
SELECT * 
FROM [PerfStats].[dbo].[BlockedSession] 
WHERE Capture_DT = (SELECT TOP 1 Capture_DT 
                                         FROM [PerfStats].[dbo].[BlockingSession] 
  	                               ORDER BY Capture_DT DESC ) 
ORDER BY Capture_DT DESC 

 
/*
Quick peek at blocking History: 

 Shows lead blocker and blocked session counts for all databases */ 
SELECT BINGS.Capture_DT, BINGS.DBName, BINGS.login_name  

              , BEDS.DBName, Count(BEDS.Session_ID) AS BLOCKED_SESSIONS 

FROM [PerfStats].[dbo].[BlockingSession] AS BINGS 

    LEFT JOIN [PerfStats].[dbo].[BlockedSession] AS BEDS ON (BINGS.Capture_DT = BEDS.Capture_DT) 

Group by BINGS.Capture_DT, BINGS.DBName, BINGS.login_name, BEDS.DBName 

Order BY BINGS.Capture_DT DESC 
