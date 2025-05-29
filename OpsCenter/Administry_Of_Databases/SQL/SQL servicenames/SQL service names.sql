-- Step 1: Temp table to store raw service info
IF Object_id('tempdb..#SQLServiceInfo') IS NOT NULL
  DROP TABLE #SQLServiceInfo;

CREATE TABLE #SQLServiceInfo
  (
     RawOutput NVARCHAR(4000)
  );

-- Step 2: Run WMIC via xp_cmdshell to gather service info
INSERT INTO #SQLServiceInfo
            (RawOutput)
EXEC Xp_cmdshell
  'wmic service where "name like ''%%SQL%%''" get Name,DisplayName,State,StartMode,StartName /format:table';

-- Step 3: Create clean final table
IF Object_id('tempdb..#ParsedSQLServiceInfo') IS NOT NULL
  DROP TABLE #ParsedSQLServiceInfo;

CREATE TABLE #ParsedSQLServiceInfo
  (
     ServiceName    NVARCHAR(200),
     DisplayName    NVARCHAR(200),
     State          NVARCHAR(200),
     StartMode      NVARCHAR(50),
     ServiceAccount NVARCHAR(200)
  );

-- Step 4: Do it raw and inline — no CTEs, just the good stuff
INSERT INTO #ParsedSQLServiceInfo
            (ServiceName,
             DisplayName,
             State,
             StartMode,
             ServiceAccount)
SELECT Ltrim(Rtrim(Substring(RawOutput, 1, Charindex('  ', RawOutput)))) AS DisplayName,
       -- ServiceName: between DisplayName and first double space
       CASE
         WHEN Charindex('  ', RawOutput) > 0
              AND Charindex('  ', RawOutput, Charindex('  ', RawOutput) + 2) > 0 THEN Ltrim(Rtrim(Substring(RawOutput, Charindex('  ', RawOutput) + 2, Charindex('  ', RawOutput, Charindex('  ', RawOutput) + 2) - Charindex('  ', RawOutput) - 2)))
         ELSE NULL
       END                                                               AS ServiceName,
       -- State
       CASE
         WHEN Charindex(' Running', RawOutput) > 0 THEN 'Running'
         WHEN Charindex(' Stopped', RawOutput) > 0 THEN 'Stopped'
         ELSE 'Unknown'
       END                                                               AS State,
       -- StartMode
       CASE
         WHEN Charindex(' Auto', RawOutput) > 0 THEN 'Auto'
         WHEN Charindex(' Manual', RawOutput) > 0 THEN 'Manual'
         WHEN Charindex(' Disabled', RawOutput) > 0 THEN 'Disabled'
         ELSE 'Unknown'
       END                                                               AS StartMode,
       Ltrim(Rtrim(Substring(RawOutput,
                   -- Start after StartMode
                   CASE
                     WHEN Charindex(' Auto', RawOutput) > 0 THEN Charindex(' Auto', RawOutput) + Len(' Auto')
                     WHEN Charindex(' Manual', RawOutput) > 0 THEN Charindex(' Manual', RawOutput)
                                                                   + Len(' Manual')
                     WHEN Charindex(' Disabled', RawOutput) > 0 THEN Charindex(' Disabled', RawOutput)
                                                                     + Len(' Disabled')
                     ELSE 0
                   END,
                   -- Length: up to start of State
                   CASE
                     WHEN Charindex(' Running', RawOutput) > 0 THEN Charindex(' Running', RawOutput)
                     WHEN Charindex(' Stopped', RawOutput) > 0 THEN Charindex(' Stopped', RawOutput)
                     ELSE Len(RawOutput)
                   END - CASE
                           WHEN Charindex(' Auto', RawOutput) > 0 THEN Charindex(' Auto', RawOutput) + Len(' Auto')
                           WHEN Charindex(' Manual', RawOutput) > 0 THEN Charindex(' Manual', RawOutput)
                                                                         + Len(' Manual')
                           WHEN Charindex(' Disabled', RawOutput) > 0 THEN Charindex(' Disabled', RawOutput)
                                                                           + Len(' Disabled')
                           ELSE 0
                         END)))                                          AS ServiceAccount
FROM   #SQLServiceInfo
WHERE  RawOutput NOT LIKE '%Name%'
       AND RawOutput NOT LIKE '%====%' -- Exclude header rows
       AND RawOutput IS NOT NULL;

-- Step 5: Show the final output
SELECT *
FROM   #ParsedSQLServiceInfo
WHERE  ServiceAccount <> ''
 
