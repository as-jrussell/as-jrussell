USE [UniTrac]
GO

/****** Object:  StoredProcedure [dbo].[Report_DailyCyclePerformanceReport]    Script Date: 8/7/2019 11:32:26 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[Report_DailyCyclePerformanceReport]

   @ProcessToFind AS VARCHAR(MAX) = 'CYCLEPRC',
   @CreateTemporaryTables AS BIT = 1,
   @GetProcessDurationsByHour AS BIT = 0,
   @GetProcessDurationsByDay AS BIT = 1,
   @StartDate AS DATETIME =  '6/1/2018',
   @FindNonProcessesToFind AS BIT = 1,
   @StartHour AS INT = 1,
   @EndHour AS INT = 9,
   @ASROnly AS BIT = 1,
   @UseBusinessDaysOnly AS BIT = 1,
   @ShowServers AS BIT = 0,
   @RemoveOutliers AS BIT = 1,
   @ShowOutliers AS BIT = 0,
   @ShowProcessDefinitions AS BIT = 1

as

BEGIN

---- RUN TIME VARIABLES
/*
DECLARE @ProcessToFind AS VARCHAR(MAX) = 'CYCLEPRC'
DECLARE @CreateTemporaryTables AS BIT = 0
DECLARE @GetProcessDurationsByHour AS BIT = 0
DECLARE @GetProcessDurationsByDay AS BIT = 1
DECLARE @StartDate AS DATETIME =  '7/23/2018'
DECLARE @CycleLenderId AS BIGINT = NULL
DECLARE @FindNonProcessesToFind AS BIT = 1
DECLARE @StartHour AS INT = 1
DECLARE @EndHour AS INT = 9
DECLARE @ASROnly AS BIT = 1
DECLARE @UseBusinessDaysOnly AS BIT = 1
DECLARE @ShowServers AS BIT = 0
DECLARE @RemoveOutliers AS BIT = 1
DECLARE @ShowOutliers AS BIT = 0
DECLARE @ShowProcessDefinitions AS BIT = 1
*/

-- Create Temporary Tables if they have never been created 
-- otherwise look at the CreateTemporaryTables flag
IF OBJECT_ID('tempdb..#PROCESS_DEFINITIONS') IS NULL OR OBJECT_ID('tempdb..#PROCESSES_PER_HOUR') IS NULL
   SET @CreateTemporaryTables = 1

if @CreateTemporaryTables = 1
BEGIN

   -- Show Process Defintions will force the Start Date to Yesterday
   IF @ShowProcessDefinitions = 1 
      SET @StartDate =  CONVERT(date, DATEADD(D, -1, GETDATE()))
   ELSE IF @StartDate IS NULL
      SET @StartDate =  DATEADD(M, -1, GETDATE())

   IF OBJECT_ID('tempdb..#PROCESS_DEFINITIONS') IS NOT NULL
     DROP TABLE #PROCESS_DEFINITIONS

   IF OBJECT_ID('tempdb..#PROCESSES_PER_HOUR') IS NOT NULL
     DROP TABLE #PROCESSES_PER_HOUR
        
   CREATE TABLE #PROCESS_DEFINITIONS (ID BIGINT, LAST_RUN_DT DATETIME, PROCESS_TYPE_CD VARCHAR(MAX))
   CREATE TABLE #PROCESSES_PER_HOUR (PROCESS_LOG_ID BIGINT, PROCESS_DT DATETIME, PROCESS_TYPE_CD VARCHAR(MAX), DURATION_NO DECIMAL(18,2), SERVER_TX VARCHAR(MAX), CYCLE_TYPE_TX VARCHAR(MAX), LENDER_ID BIGINT, IS_OVER_EIGHT_HOURS BIT, IS_SYSTEM_USER_IN VARCHAR(1), START_DT DATETIME, USER_NAME_TX VARCHAR(MAX), CYCLE_MODE VARCHAR(30))
   
   INSERT INTO #PROCESS_DEFINITIONS
   SELECT   ID, DATEADD(HOUR, DATEDIFF(HOUR, 0, LAST_RUN_DT), 0), PROCESS_TYPE_CD
   FROM     PROCESS_DEFINITION
   WHERE    ACTIVE_IN = 'Y'
            AND PURGE_DT IS NULL
            AND LAST_RUN_DT >= @StartDate
            AND PROCESS_TYPE_CD = CASE WHEN @FindNonProcessesToFind = 0 THEN @ProcessToFind ELSE PROCESS_TYPE_CD END
            
   DECLARE  @minLastRunDate DATETIME, @maxLastRunDate DATETIME
   SELECT   @minLastRunDate = MIN(LAST_RUN_DT), 
            @maxLastRunDate = MAX(LAST_RUN_DT)
   FROM     #PROCESS_DEFINITIONS

   INSERT INTO #PROCESSES_PER_HOUR
   SELECT   PL.ID,
            DATEADD(HOUR, DATEDIFF(HOUR, 0, PL.CREATE_DT), 0), 
            PROCESS_TYPE_CD,
            CASE WHEN DATEDIFF(S, START_DT, END_DT) < 28800 THEN
               DATEDIFF(MS, START_DT, END_DT) / 1000.00
            ELSE
               DATEDIFF(S, START_DT, END_DT)
            END,
            SERVER_TX,
            ISNULL(WI.CONTENT_XML.value('(/Content/Cycle/CycleMode)[1]','varchar(10)'), 'Full'),
            WI.LENDER_ID,
            CASE WHEN DATEDIFF(S, START_DT, END_DT) < 28800 THEN 0 ELSE 1 END,
            U.SYSTEM_IN,
            START_DT,
            U.USER_NAME_TX,
			WI.CONTENT_XML.value('(/Content/Cycle/CycleMode/text())[1]','varchar(20)') as CYCLE_MODE
   FROM     #PROCESS_DEFINITIONS PD
            INNER JOIN PROCESS_LOG PL ON PL.PROCESS_DEFINITION_ID = PD.ID
            INNER JOIN USERS U ON PL.UPDATE_USER_TX = U.USER_NAME_TX
            LEFT JOIN WORK_ITEM WI ON PL.ID = WI.RELATE_ID and RELATE_TYPE_CD = 'Osprey.ProcessMgr.ProcessLog'
   WHERE    PL.CREATE_DT >= @minLastRunDate 
            AND PL.CREATE_DT < @maxLastRunDate
            AND END_DT IS NOT NULL
            AND SERVER_TX LIKE 'UTPROD-ASR%'
                                         
   -- Cursor thru the Process Per Hour, if the Update User is NOT a System User
   -- then the end time of the Process Log is invalid, and will need to be determined
   -- 'CYCLEPRC'
   BEGIN

      -- Process Definition Cursor
      DECLARE @etc_pliid BIGINT
      DECLARE @etc_startdate DATETIME
      DECLARE @etcv_max_pli_create_dt DATETIME
      DECLARE END_TIME_CURSOR CURSOR LOCAL FOR
      SELECT   PROCESS_LOG_ID, START_DT
      FROM     #PROCESSES_PER_HOUR
      WHERE    IS_SYSTEM_USER_IN = 'N'
               AND PROCESS_TYPE_CD = 'CYCLEPRC'

      OPEN END_TIME_CURSOR

      FETCH NEXT FROM END_TIME_CURSOR INTO @etc_pliid, @etc_startdate
      WHILE @@FETCH_STATUS = 0  
      BEGIN
   
         SELECT   @etcv_max_pli_create_dt = MAX(PLI.CREATE_DT) 
         FROM     PROCESS_LOG_ITEM PLI
                  INNER JOIN USERS U ON PLI.UPDATE_USER_TX = U.USER_NAME_TX
         WHERE    PROCESS_LOG_ID = @etc_pliid 
                  AND U.SYSTEM_IN = 'Y'
                  AND U.USER_NAME_TX != 'UBSMatchInN'
                  AND LTRIM(RTRIM(Replace(Replace(PLI.INFO_XML.value('(/INFO_LOG/MESSAGE_LOG)[1]','varchar(max)'),CHAR(10),''),CHAR(13),'') )) != 'Automated Outbound Call Message created'

         UPDATE   #PROCESSES_PER_HOUR
         SET      DURATION_NO = DATEDIFF(MS, @etc_startdate, @etcv_max_pli_create_dt) / 1000.00,
                  IS_OVER_EIGHT_HOURS = CASE WHEN DATEDIFF(S, @etc_startdate, @etcv_max_pli_create_dt) > 28800 THEN 1 ELSE 0 END
         WHERE    PROCESS_LOG_ID = @etc_pliid

         FETCH NEXT FROM END_TIME_CURSOR INTO @etc_pliid, @etc_startdate

      END

      CLOSE END_TIME_CURSOR
      DEALLOCATE END_TIME_CURSOR

   END
   
   -- Look at the Process Per Hour, if there are multiple DBCalls for a Billing then
   -- then the end time of the Process Log is invalid, and will need to be determined
   -- 'BILLING'
   BEGIN
      
      DECLARE @processesToInvestigate AS TABLE (PROCESS_LOG_ID BIGINT, IS_SYSTEM_USER_IN VARCHAR(1), USER_NAME_TX VARCHAR(MAX))
      INSERT INTO @processesToInvestigate
         SELECT   TOPMASTER.PROCESS_LOG_ID,
                  TOPMASTER.IS_SYSTEM_USER_IN,
                  TOPMASTER.USER_NAME_TX
         FROM     #PROCESSES_PER_HOUR TOPMASTER
                  INNER JOIN PROCESS_LOG_ITEM PLI ON TOPMASTER.PROCESS_LOG_ID = PLI.PROCESS_LOG_ID
         WHERE    TOPMASTER.PROCESS_TYPE_CD = 'BILLING'
                  AND RELATE_TYPE_CD = 'DBCall'
         GROUP BY TOPMASTER.PROCESS_LOG_ID, TOPMASTER.IS_SYSTEM_USER_IN, TOPMASTER.USER_NAME_TX
         HAVING   COUNT(*) > 1
         UNION
         SELECT   TOPMASTER.PROCESS_LOG_ID,
                  TOPMASTER.IS_SYSTEM_USER_IN,
                  TOPMASTER.USER_NAME_TX
         FROM     #PROCESSES_PER_HOUR TOPMASTER
                  INNER JOIN PROCESS_LOG_ITEM PLI ON TOPMASTER.PROCESS_LOG_ID = PLI.PROCESS_LOG_ID
         WHERE    TOPMASTER.PROCESS_TYPE_CD = 'BILLING'
                  AND (TOPMASTER.IS_SYSTEM_USER_IN = 'Y' AND TOPMASTER.USER_NAME_TX != 'UBSMatchInN')
         GROUP BY TOPMASTER.PROCESS_LOG_ID, TOPMASTER.IS_SYSTEM_USER_IN, TOPMASTER.USER_NAME_TX
         HAVING   COUNT(*) > 1
         
      DECLARE @usePLIsLessThan AS TABLE (PROCESS_LOG_ID BIGINT, PROCESS_LOG_ITEM_ID BIGINT)
      INSERT INTO @usePLIsLessThan
      SELECT   PLIS.PROCESS_LOG_ID,
               PLIS.ID
      FROM     @processesToInvestigate PTI
               OUTER APPLY
               (
                  SELECT   PLI.PROCESS_LOG_ID,
                           PLI.ID,
                           ROW_NUMBER() OVER(ORDER BY PLI.CREATE_DT ASC) AS RowNum
                  FROM     PROCESS_LOG_ITEM PLI        
                           INNER JOIN @processesToInvestigate PTI_T ON PTI_T.PROCESS_LOG_ID = PLI.PROCESS_LOG_ID
                  WHERE    PLI.PROCESS_LOG_ID = PTI.PROCESS_LOG_ID
                           AND 
                           (
                              RELATE_TYPE_CD = 'DBCall'
                              OR
                              (PTI.IS_SYSTEM_USER_IN = 'Y' AND PTI.USER_NAME_TX != 'UBSMatchInN')
                           )
               ) PLIS
      WHERE    PTI.PROCESS_LOG_ID = PLIS.PROCESS_LOG_ID
               AND RowNum = 2
      
      ---- Update the Processes Per Hour
      UPDATE   PPH
      SET      PPH.DURATION_NO = CALC_DATA.DURATION_NO
      FROM     #PROCESSES_PER_HOUR PPH
               OUTER APPLY 
               (
                  SELECT   T.PROCESS_LOG_ID,
                           DATEDIFF(MS, MAX(T.START_DT), MAX(PLI.CREATE_DT)) / 1000.00 AS DURATION_NO
                  FROM     #PROCESSES_PER_HOUR T
                           INNER JOIN @usePLIsLessThan LT ON T.PROCESS_LOG_ID = LT.PROCESS_LOG_ID
                           INNER JOIN  PROCESS_LOG_ITEM PLI ON PLI.ID < LT.PROCESS_LOG_ITEM_ID 
                                       AND PLI.PROCESS_LOG_ID = LT.PROCESS_LOG_ID
                  GROUP BY T.PROCESS_LOG_ID, T.START_DT
               ) CALC_DATA
      WHERE    PPH.PROCESS_LOG_ID = CALC_DATA.PROCESS_LOG_ID

   END

   -- Because of the way PLI times are stored and updated, process time for Escrow cannot be determined
   -- 'ESCROW'
   BEGIN
      UPDATE   PPH
      SET      PPH.DURATION_NO = 0.00
      FROM     #PROCESSES_PER_HOUR PPH
      WHERE    PROCESS_TYPE_CD = 'ESCROW'
   END
      
   -- Billing File Generation Extends the original Billing Item ... we don't want to go back to the original
   -- start of the billing item, so update here accordingly
   -- 'BILFILGEN'
   BEGIN

      DECLARE @bilFilGenProcessesToInvestigate AS TABLE (PROCESS_LOG_ID BIGINT)
      INSERT INTO @bilFilGenProcessesToInvestigate
         SELECT   DISTINCT TOPMASTER.PROCESS_LOG_ID
         FROM     #PROCESSES_PER_HOUR TOPMASTER
         WHERE    TOPMASTER.PROCESS_TYPE_CD = 'BILFILGEN'

      DECLARE @findPLStartDate AS TABLE (PROCESS_LOG_ID BIGINT, START_DT DATETIME)
      INSERT INTO @findPLStartDate
         SELECT   T.PROCESS_LOG_ID,
                  PLI.CREATE_DT
         FROM     #PROCESSES_PER_HOUR T
                  INNER JOIN @bilFilGenProcessesToInvestigate PTI ON T.PROCESS_LOG_ID = PTI.PROCESS_LOG_ID
                  INNER JOIN  PROCESS_LOG_ITEM PLI ON PLI.PROCESS_LOG_ID = T.PROCESS_LOG_ID
         WHERE    PLI.RELATE_TYPE_CD = 'UnitracBusinessService.BillingFileGenerationProcess'
                  AND PLI.INFO_XML.value('(/INFO_LOG/MESSAGE_LOG)[1]','varchar(max)') LIKE 'Query GetBillingFileDetails Start%'

       ------ Update the Processes Per Hour
       UPDATE  PPH
       SET     PPH.DURATION_NO = 
                  CASE WHEN DATEDIFF(S, CALC_DATA.START_DT, CALC_DATA.CREATE_DT) < 28800 THEN
                     DATEDIFF(MS, CALC_DATA.START_DT, CALC_DATA.CREATE_DT) / 1000.00
                  ELSE
                     DATEDIFF(S, CALC_DATA.START_DT, CALC_DATA.CREATE_DT)
                  END,
               PPH.PROCESS_DT = DATEADD(HOUR, DATEDIFF(HOUR, 0, CALC_DATA.START_DT), 0),
               PPH.START_DT = DATEADD(HOUR, DATEDIFF(HOUR, 0, CALC_DATA.START_DT), 0)
       FROM    #PROCESSES_PER_HOUR PPH
               OUTER APPLY 
               (
                  SELECT   TOP 1 T.PROCESS_LOG_ID, T.START_DT, PLI.CREATE_DT
                           CREATE_DT
                  FROM     @findPLStartDate T
                           INNER JOIN PROCESS_LOG_ITEM PLI ON T.PROCESS_LOG_ID = PLI.PROCESS_LOG_ID
                  WHERE    PLI.PROCESS_LOG_ID = PPH.PROCESS_LOG_ID
                           AND CREATE_DT >
                           (
                              SELECT   TOP 1 TT.START_DT
                              FROM     @findPLStartDate TT
                              WHERE    T.PROCESS_LOG_ID = TT.PROCESS_LOG_ID
                           )
                           AND STATUS_CD = 'INFO'
                           AND INFO_XML.value('(/INFO_LOG/MESSAGE_LOG)[1]','varchar(max)') LIKE 'Generate Billing File%'
               ) CALC_DATA
       WHERE   CALC_DATA.PROCESS_LOG_ID = PPH.PROCESS_LOG_ID   
       
   END

END

-- Create Working Table
DECLARE @tempProcessesPerHour AS TABLE (PROCESS_LOG_ID BIGINT, PROCESS_DT DATETIME, PROCESS_TYPE_CD VARCHAR(MAX), DURATION_NO INT, SERVER_TX VARCHAR(MAX), CYCLE_TYPE_TX VARCHAR(MAX), LENDER_ID BIGINT, IS_OVER_EIGHT_HOURS BIT, START_DT DATETIME, CYCLE_MODE varchar(30))
INSERT INTO @tempProcessesPerHour
SELECT   PROCESS_LOG_ID, PROCESS_DT, PROCESS_TYPE_CD, DURATION_NO, SERVER_TX, CYCLE_TYPE_TX, LENDER_ID, IS_OVER_EIGHT_HOURS, START_DT, CYCLE_MODE
FROM     #PROCESSES_PER_HOUR
WHERE    DATEPART(HOUR, START_DT) >= ISNULL(@StartHour, 0)
         AND DATEPART(HOUR, START_DT) <= ISNULL(@EndHour, 24)
         
-- Filter the Working Table
IF @ASROnly = 1
   DELETE FROM @tempProcessesPerHour
   WHERE SERVER_TX NOT LIKE 'UTPROD-ASR%'

IF @UseBusinessDaysOnly = 1
   DELETE FROM @tempProcessesPerHour
   WHERE DATEPART(DW, START_DT) = 1 OR DATEPART(dw, START_DT) = 7  

IF @RemoveOutliers = 1
BEGIN

   IF @ShowOutliers = 1
      SELECT 'Outlier Removed', * FROM @tempProcessesPerHour
      WHERE DURATION_NO > 86400
      ORDER BY PROCESS_DT

   DELETE FROM @tempProcessesPerHour
   WHERE DURATION_NO > 86400

END

-- Show the Process Definitions for Daily Report
IF @ShowProcessDefinitions = 1
BEGIN

   SELECT   PD.NAME_TX, 
            PL.ID, 
			PD.ID as PD_ID,
            convert(date, T.PROCESS_DT) PROCESS_DT, 
            T.START_DT, 
            DATEADD(s, T.DURATION_NO, T.START_DT) AS END_DT,
            T.DURATION_NO,
            T.SERVER_TX,
			T.CYCLE_MODE
   FROM     @tempProcessesPerHour T
            INNER JOIN PROCESS_LOG PL ON T.PROCESS_LOG_ID = PL.ID
            INNER JOIN PROCESS_DEFINITION PD ON PL.PROCESS_DEFINITION_ID = PD.ID
   WHERE    T.PROCESS_TYPE_CD = 'CYCLEPRC'
            AND DATEPART(HOUR, T.START_DT) >= 1
            AND DATEPART(HOUR, T.START_DT) <= 9
   ORDER BY START_DT, SERVER_TX

END
ELSE
BEGIN
   DECLARE @OutputData AS TABLE (SERVER_TX VARCHAR(MAX), PROCESS_DT DATETIME, PROCESS_CD VARCHAR(MAX), PROCESS_DURATION_NO INT, FULL_CYCLE_DURATION_NO INT, DAILY_CYCLE_DURATION_NO INT,
   NON_PROCESS_DURATION_NO INT, PROCESS_COUNT_NO INT, FULL_CYCLE_COUNT_NO INT, DAILY_CYCLE_COUNT_NO INT, NON_PROCESS_COUNT_NO BIGINT, NOT_OVER_EIGHT_HOURS_COUNT_NO INT,
   OVER_EIGHT_HOURS_COUNT_NO INT, NOT_OVER_EIGHT_HOURS_DURATION_NO INT, OVER_EIGHT_HOURS_DURATION_NO INT, NOT_OVER_EIGHT_HOURS_AVG_NO DECIMAL(18,2), OVER_EIGHT_HOURS_AVG_NO DECIMAL(18,2),
   AVG_NO DECIMAL(18,2), ORDER_NO INT)
      
   -- Cycle Durations By Hour 
   IF @GetProcessDurationsByHour = 1
      
      INSERT INTO @OutputData
      SELECT   'All Servers',
               PROCESS_DT, 
               @ProcessToFind,
               SUM(CASE WHEN PROCESS_TYPE_CD = @ProcessToFind THEN DURATION_NO ELSE 0 END) AS PROCESS_DURATION_NO, 
               SUM(CASE WHEN PROCESS_TYPE_CD = @ProcessToFind AND CYCLE_TYPE_TX = 'Full' THEN DURATION_NO ELSE 0 END) AS FULL_DURATION_NO,
               SUM(CASE WHEN PROCESS_TYPE_CD = @ProcessToFind AND CYCLE_TYPE_TX = 'Daily' THEN DURATION_NO ELSE 0 END) AS DAILY_DURATION_NO,        
               SUM(CASE WHEN PROCESS_TYPE_CD != @ProcessToFind THEN DURATION_NO ELSE 0 END) AS NON_PROCESS_DURATION_NO,
               --
               SUM(CASE WHEN PROCESS_TYPE_CD = @ProcessToFind THEN 1 ELSE 0 END) AS PROCESS_COUNT_NO,
               SUM(CASE WHEN PROCESS_TYPE_CD = @ProcessToFind AND CYCLE_TYPE_TX = 'Full' THEN 1 ELSE 0 END) AS FULL_COUNT_NO,
               SUM(CASE WHEN PROCESS_TYPE_CD = @ProcessToFind AND CYCLE_TYPE_TX = 'Daily' THEN 1 ELSE 0 END) AS DAILY_COUNT_NO,
               SUM(CASE WHEN PROCESS_TYPE_CD != @ProcessToFind THEN 1 ELSE 0 END) AS NON_PROCESS_COUNT_NO,
               --
               SUM(CASE WHEN PROCESS_TYPE_CD = @ProcessToFind AND IS_OVER_EIGHT_HOURS = 0 THEN 1 ELSE 0 END) AS NOT_OVER_EIGHT_HOURS_COUNT_NO,
               SUM(CASE WHEN PROCESS_TYPE_CD = @ProcessToFind AND IS_OVER_EIGHT_HOURS = 1 THEN 1 ELSE 0 END) AS OVER_EIGHT_HOURS_COUNT_NO,
               --
               SUM(CASE WHEN PROCESS_TYPE_CD = @ProcessToFind AND IS_OVER_EIGHT_HOURS = 0 THEN DURATION_NO ELSE 0 END) AS NOT_OVER_EIGHT_HOURS_DURATION_NO,
               SUM(CASE WHEN PROCESS_TYPE_CD = @ProcessToFind AND IS_OVER_EIGHT_HOURS = 1 THEN DURATION_NO ELSE 0 END) AS OVER_EIGHT_HOURS_DURATION_NO,
               --
               CASE WHEN SUM(CASE WHEN PROCESS_TYPE_CD = @ProcessToFind AND IS_OVER_EIGHT_HOURS = 0 THEN 1 ELSE 0 END) > 0 THEN
                  SUM(CASE WHEN PROCESS_TYPE_CD = @ProcessToFind AND IS_OVER_EIGHT_HOURS = 0 THEN DURATION_NO * 1.0 ELSE 0.0 END) /
                  SUM(CASE WHEN PROCESS_TYPE_CD = @ProcessToFind AND IS_OVER_EIGHT_HOURS = 0 THEN 1 ELSE 0 END)
               ELSE 0 END
                  AS NOT_OVER_EIGHT_HOURS_AVG_NO,
               CASE WHEN SUM(CASE WHEN PROCESS_TYPE_CD = @ProcessToFind AND IS_OVER_EIGHT_HOURS = 1 THEN 1 ELSE 0 END) > 0 THEN
                  SUM(CASE WHEN PROCESS_TYPE_CD = @ProcessToFind AND IS_OVER_EIGHT_HOURS = 1 THEN DURATION_NO * 1.0 ELSE 0.0 END) /
                  SUM(CASE WHEN PROCESS_TYPE_CD = @ProcessToFind AND IS_OVER_EIGHT_HOURS = 1 THEN 1 ELSE 0 END)
               ELSE 0 END
                  AS OVER_EIGHT_HOURS_AVG_NO,
               CASE WHEN SUM(CASE WHEN PROCESS_TYPE_CD = @ProcessToFind THEN 1 ELSE 0 END) > 0 THEN
                  SUM(CASE WHEN PROCESS_TYPE_CD = @ProcessToFind THEN DURATION_NO * 1.0 ELSE 0.0 END) /
                  SUM(CASE WHEN PROCESS_TYPE_CD = @ProcessToFind THEN 1 ELSE 0 END)
               ELSE 0 END
                  AS AVG_NO,
               2
      FROM     @tempProcessesPerHour
      GROUP BY PROCESS_DT
      ORDER BY PROCESS_DT
   
   -- Cycle Durations By Day
   IF @GetProcessDurationsByDay = 1
      
      INSERT INTO @OutputData
      SELECT   'All Servers',
               CONVERT(date, PROCESS_DT), 
               @ProcessToFind,
               SUM(CASE WHEN PROCESS_TYPE_CD = @ProcessToFind THEN DURATION_NO ELSE 0 END) AS PROCESS_DURATION_NO, 
               SUM(CASE WHEN PROCESS_TYPE_CD = @ProcessToFind AND CYCLE_TYPE_TX = 'Full' THEN DURATION_NO ELSE 0 END) AS FULL_DURATION_NO,
               SUM(CASE WHEN PROCESS_TYPE_CD = @ProcessToFind AND CYCLE_TYPE_TX = 'Daily' THEN DURATION_NO ELSE 0 END) AS DAILY_DURATION_NO,        
               SUM(CASE WHEN PROCESS_TYPE_CD != @ProcessToFind THEN DURATION_NO ELSE 0 END) AS NON_PROCESS_DURATION_NO,
               ----
               SUM(CASE WHEN PROCESS_TYPE_CD = @ProcessToFind THEN 1 ELSE 0 END) AS PROCESS_COUNT_NO,
               SUM(CASE WHEN PROCESS_TYPE_CD = @ProcessToFind AND CYCLE_TYPE_TX = 'Full' THEN 1 ELSE 0 END) AS FULL_COUNT_NO,
               SUM(CASE WHEN PROCESS_TYPE_CD = @ProcessToFind AND CYCLE_TYPE_TX = 'Daily' THEN 1 ELSE 0 END) AS DAILY_COUNT_NO,
               SUM(CASE WHEN PROCESS_TYPE_CD != @ProcessToFind THEN 1 ELSE 0 END) AS NON_PROCESS_COUNT_NO,
               --
               SUM(CASE WHEN PROCESS_TYPE_CD = @ProcessToFind AND IS_OVER_EIGHT_HOURS = 0 THEN 1 ELSE 0 END) AS NOT_OVER_EIGHT_HOURS_COUNT_NO,
               SUM(CASE WHEN PROCESS_TYPE_CD = @ProcessToFind AND IS_OVER_EIGHT_HOURS = 1 THEN 1 ELSE 0 END) AS OVER_EIGHT_HOURS_COUNT_NO,
               --
               SUM(CASE WHEN PROCESS_TYPE_CD = @ProcessToFind AND IS_OVER_EIGHT_HOURS = 0 THEN DURATION_NO ELSE 0 END) AS NOT_OVER_EIGHT_HOURS_DURATION_NO,
               SUM(CASE WHEN PROCESS_TYPE_CD = @ProcessToFind AND IS_OVER_EIGHT_HOURS = 1 THEN DURATION_NO ELSE 0 END) AS OVER_EIGHT_HOURS_DURATION_NO,
               --
               CASE WHEN SUM(CASE WHEN PROCESS_TYPE_CD = @ProcessToFind AND IS_OVER_EIGHT_HOURS = 0 THEN 1 ELSE 0 END) > 0 THEN
                  SUM(CASE WHEN PROCESS_TYPE_CD = @ProcessToFind AND IS_OVER_EIGHT_HOURS = 0 THEN DURATION_NO * 1.0 ELSE 0.0 END) /
                  SUM(CASE WHEN PROCESS_TYPE_CD = @ProcessToFind AND IS_OVER_EIGHT_HOURS = 0 THEN 1 ELSE 0 END)
               ELSE 0 END
                  AS NOT_OVER_EIGHT_HOURS_AVG_NO,
               CASE WHEN SUM(CASE WHEN PROCESS_TYPE_CD = @ProcessToFind AND IS_OVER_EIGHT_HOURS = 1 THEN 1 ELSE 0 END) > 0 THEN
                  SUM(CASE WHEN PROCESS_TYPE_CD = @ProcessToFind AND IS_OVER_EIGHT_HOURS = 1 THEN DURATION_NO * 1.0 ELSE 0.0 END) /
                  SUM(CASE WHEN PROCESS_TYPE_CD = @ProcessToFind AND IS_OVER_EIGHT_HOURS = 1 THEN 1 ELSE 0 END)
               ELSE 0 END
                  AS OVER_EIGHT_HOURS_AVG_NO,
               CASE WHEN SUM(CASE WHEN PROCESS_TYPE_CD = @ProcessToFind THEN 1 ELSE 0 END) > 0 THEN
                  SUM(CASE WHEN PROCESS_TYPE_CD = @ProcessToFind THEN DURATION_NO * 1.0 ELSE 0.0 END) /
                  SUM(CASE WHEN PROCESS_TYPE_CD = @ProcessToFind THEN 1 ELSE 0 END)
               ELSE 0 END
                  AS AVG_NO,
               2
      FROM     @tempProcessesPerHour
      GROUP BY CONVERT(date, PROCESS_DT)
      ORDER BY CONVERT(date, PROCESS_DT)
   
   -- Show ASR Server Information
   IF @ShowServers = 1
   BEGIN
   
      -- Process Log Item Cursor
      DECLARE @pphc_server_tx VARCHAR(MAX)
      DECLARE PROCESSES_PER_HOUR_CURSOR CURSOR LOCAL FOR 
      SELECT DISTINCT SERVER_TX 
      FROM     @tempProcessesPerHour 
      WHERE    PROCESS_TYPE_CD = @ProcessToFind
               
      OPEN PROCESSES_PER_HOUR_CURSOR
      FETCH NEXT FROM PROCESSES_PER_HOUR_CURSOR INTO @pphc_server_tx
      WHILE @@FETCH_STATUS = 0  
      BEGIN
   
         -- Cycle Durations By Hour 
         IF @GetProcessDurationsByHour = 1
            
            INSERT INTO @OutputData
            SELECT   @pphc_server_tx,
                     PROCESS_DT, 
                     @ProcessToFind,
                     SUM(CASE WHEN PROCESS_TYPE_CD = @ProcessToFind THEN DURATION_NO ELSE 0 END) AS PROCESS_DURATION_NO, 
                     SUM(CASE WHEN PROCESS_TYPE_CD = @ProcessToFind AND CYCLE_TYPE_TX = 'Full' THEN DURATION_NO ELSE 0 END) AS FULL_DURATION_NO,
                     SUM(CASE WHEN PROCESS_TYPE_CD = @ProcessToFind AND CYCLE_TYPE_TX = 'Daily' THEN DURATION_NO ELSE 0 END) AS DAILY_DURATION_NO,        
                     SUM(CASE WHEN PROCESS_TYPE_CD != @ProcessToFind THEN DURATION_NO ELSE 0 END) AS NON_PROCESS_DURATION_NO,
                     ----
                     SUM(CASE WHEN PROCESS_TYPE_CD = @ProcessToFind THEN 1 ELSE 0 END) AS PROCESS_COUNT_NO,
                     SUM(CASE WHEN PROCESS_TYPE_CD = @ProcessToFind AND CYCLE_TYPE_TX = 'Full' THEN 1 ELSE 0 END) AS FULL_COUNT_NO,
                     SUM(CASE WHEN PROCESS_TYPE_CD = @ProcessToFind AND CYCLE_TYPE_TX = 'Daily' THEN 1 ELSE 0 END) AS DAILY_COUNT_NO,
                     SUM(CASE WHEN PROCESS_TYPE_CD != @ProcessToFind THEN 1 ELSE 0 END) AS NON_PROCESS_COUNT_NO,
                     --
                     SUM(CASE WHEN PROCESS_TYPE_CD = @ProcessToFind AND IS_OVER_EIGHT_HOURS = 0 THEN 1 ELSE 0 END) AS NOT_OVER_EIGHT_HOURS_COUNT_NO,
                     SUM(CASE WHEN PROCESS_TYPE_CD = @ProcessToFind AND IS_OVER_EIGHT_HOURS = 1 THEN 1 ELSE 0 END) AS OVER_EIGHT_HOURS_COUNT_NO,
                     --
                     SUM(CASE WHEN PROCESS_TYPE_CD = @ProcessToFind AND IS_OVER_EIGHT_HOURS = 0 THEN DURATION_NO ELSE 0 END) AS NOT_OVER_EIGHT_HOURS_DURATION_NO,
                     SUM(CASE WHEN PROCESS_TYPE_CD = @ProcessToFind AND IS_OVER_EIGHT_HOURS = 1 THEN DURATION_NO ELSE 0 END) AS OVER_EIGHT_HOURS_DURATION_NO,
                     --
                     CASE WHEN SUM(CASE WHEN PROCESS_TYPE_CD = @ProcessToFind AND IS_OVER_EIGHT_HOURS = 0 THEN 1 ELSE 0 END) > 0 THEN
                        SUM(CASE WHEN PROCESS_TYPE_CD = @ProcessToFind AND IS_OVER_EIGHT_HOURS = 0 THEN DURATION_NO * 1.0 ELSE 0.0 END) /
                        SUM(CASE WHEN PROCESS_TYPE_CD = @ProcessToFind AND IS_OVER_EIGHT_HOURS = 0 THEN 1 ELSE 0 END)
                     ELSE 0 END
                        AS NOT_OVER_EIGHT_HOURS_AVG_NO,
                     CASE WHEN SUM(CASE WHEN PROCESS_TYPE_CD = @ProcessToFind AND IS_OVER_EIGHT_HOURS = 1 THEN 1 ELSE 0 END) > 0 THEN
                        SUM(CASE WHEN PROCESS_TYPE_CD = @ProcessToFind AND IS_OVER_EIGHT_HOURS = 1 THEN DURATION_NO * 1.0 ELSE 0.0 END) /
                        SUM(CASE WHEN PROCESS_TYPE_CD = @ProcessToFind AND IS_OVER_EIGHT_HOURS = 1 THEN 1 ELSE 0 END)
                     ELSE 0 END
                        AS OVER_EIGHT_HOURS_AVG_NO,
                     CASE WHEN SUM(CASE WHEN PROCESS_TYPE_CD = @ProcessToFind THEN 1 ELSE 0 END) > 0 THEN
                        SUM(CASE WHEN PROCESS_TYPE_CD = @ProcessToFind THEN DURATION_NO * 1.0 ELSE 0.0 END) /
                        SUM(CASE WHEN PROCESS_TYPE_CD = @ProcessToFind THEN 1 ELSE 0 END)
                     ELSE 0 END
                        AS AVG_NO,
                     1
            FROM     @tempProcessesPerHour
            WHERE    SERVER_TX = @pphc_server_tx
            GROUP BY PROCESS_DT
            ORDER BY PROCESS_DT
   
         -- Cycle Durations By Day
         IF @GetProcessDurationsByDay = 1
            INSERT INTO @OutputData
            SELECT   @pphc_server_tx,
                     CONVERT(date, PROCESS_DT), 
                     @ProcessToFind,
                     SUM(CASE WHEN PROCESS_TYPE_CD = @ProcessToFind THEN DURATION_NO ELSE 0 END) AS PROCESS_DURATION_NO, 
                     SUM(CASE WHEN PROCESS_TYPE_CD = @ProcessToFind AND CYCLE_TYPE_TX = 'Full' THEN DURATION_NO ELSE 0 END) AS FULL_DURATION_NO,
                     SUM(CASE WHEN PROCESS_TYPE_CD = @ProcessToFind AND CYCLE_TYPE_TX = 'Daily' THEN DURATION_NO ELSE 0 END) AS DAILY_DURATION_NO,        
                     SUM(CASE WHEN PROCESS_TYPE_CD != @ProcessToFind THEN DURATION_NO ELSE 0 END) AS NON_PROCESS_DURATION_NO,
                     ----
                     SUM(CASE WHEN PROCESS_TYPE_CD = @ProcessToFind THEN 1 ELSE 0 END) AS PROCESS_COUNT_NO,
                     SUM(CASE WHEN PROCESS_TYPE_CD = @ProcessToFind AND CYCLE_TYPE_TX = 'Full' THEN 1 ELSE 0 END) AS FULL_COUNT_NO,
                     SUM(CASE WHEN PROCESS_TYPE_CD = @ProcessToFind AND CYCLE_TYPE_TX = 'Daily' THEN 1 ELSE 0 END) AS DAILY_COUNT_NO,
                     SUM(CASE WHEN PROCESS_TYPE_CD != @ProcessToFind THEN 1 ELSE 0 END) AS NON_PROCESS_COUNT_NO,
                     --
                     SUM(CASE WHEN PROCESS_TYPE_CD = @ProcessToFind AND IS_OVER_EIGHT_HOURS = 0 THEN 1 ELSE 0 END) AS NOT_OVER_EIGHT_HOURS_COUNT_NO,
                     SUM(CASE WHEN PROCESS_TYPE_CD = @ProcessToFind AND IS_OVER_EIGHT_HOURS = 1 THEN 1 ELSE 0 END) AS OVER_EIGHT_HOURS_COUNT_NO,
                     --
                     SUM(CASE WHEN PROCESS_TYPE_CD = @ProcessToFind AND IS_OVER_EIGHT_HOURS = 0 THEN DURATION_NO ELSE 0 END) AS NOT_OVER_EIGHT_HOURS_DURATION_NO,
                     SUM(CASE WHEN PROCESS_TYPE_CD = @ProcessToFind AND IS_OVER_EIGHT_HOURS = 1 THEN DURATION_NO ELSE 0 END) AS OVER_EIGHT_HOURS_DURATION_NO,
                     --
                     CASE WHEN SUM(CASE WHEN PROCESS_TYPE_CD = @ProcessToFind AND IS_OVER_EIGHT_HOURS = 0 THEN 1 ELSE 0 END) > 0 THEN
                        SUM(CASE WHEN PROCESS_TYPE_CD = @ProcessToFind AND IS_OVER_EIGHT_HOURS = 0 THEN DURATION_NO * 1.0 ELSE 0.0 END) /
                        SUM(CASE WHEN PROCESS_TYPE_CD = @ProcessToFind AND IS_OVER_EIGHT_HOURS = 0 THEN 1 ELSE 0 END)
                     ELSE 0 END
                        AS NOT_OVER_EIGHT_HOURS_AVG_NO,
                     CASE WHEN SUM(CASE WHEN PROCESS_TYPE_CD = @ProcessToFind AND IS_OVER_EIGHT_HOURS = 1 THEN 1 ELSE 0 END) > 0 THEN
                        SUM(CASE WHEN PROCESS_TYPE_CD = @ProcessToFind AND IS_OVER_EIGHT_HOURS = 1 THEN DURATION_NO * 1.0 ELSE 0.0 END) /
                        SUM(CASE WHEN PROCESS_TYPE_CD = @ProcessToFind AND IS_OVER_EIGHT_HOURS = 1 THEN 1 ELSE 0 END)
                     ELSE 0 END
                        AS OVER_EIGHT_HOURS_AVG_NO,
                     CASE WHEN SUM(CASE WHEN PROCESS_TYPE_CD = @ProcessToFind THEN 1 ELSE 0 END) > 0 THEN
                        SUM(CASE WHEN PROCESS_TYPE_CD = @ProcessToFind THEN DURATION_NO * 1.0 ELSE 0.0 END) /
                        SUM(CASE WHEN PROCESS_TYPE_CD = @ProcessToFind THEN 1 ELSE 0 END)
                     ELSE 0 END
                        AS AVG_NO,
                     1
            FROM     @tempProcessesPerHour
            WHERE    SERVER_TX = @pphc_server_tx
            GROUP BY CONVERT(date, PROCESS_DT)
            ORDER BY CONVERT(date, PROCESS_DT)
   
         FETCH NEXT FROM PROCESSES_PER_HOUR_CURSOR INTO @pphc_server_tx
      END
      CLOSE PROCESSES_PER_HOUR_CURSOR
      DEALLOCATE PROCESSES_PER_HOUR_CURSOR
   
   END
   
   SELECT   PROCESS_DT,
            PROCESS_COUNT_NO,
            PROCESS_DURATION_NO,
            AVG_NO,
            AVG_NO / 60.0 AS AVG_MINUTES_NO,
            AVG_NO / 60.0 / 60.0 AS AVG_HOURS_NO,
            NON_PROCESS_COUNT_NO,
            NON_PROCESS_DURATION_NO,
            NON_PROCESS_DURATION_NO / 60.0 AS AVG_NP_MINUTES_NO,
            NON_PROCESS_DURATION_NO / 60.0 / 60.0 AS AVG_NP_HOURS_NO
   FROM     @OutputData ORDER BY PROCESS_DT, ORDER_NO ASC
   
   END
END

GO

