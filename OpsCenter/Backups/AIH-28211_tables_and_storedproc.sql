USE [UniTrac_Maintenance]

---CREATE SCHEMA
     Declare  @query      NVARCHAR(1000), @SchemaName VARCHAR(255),  @DatabaseName VARCHAR(255) ='Unitrac_Tools',   @WhatIf       INT = 0
              IF( @DatabaseName = '' )
                BEGIN
                    SET @SchemaName = 'dbo'
                END
              ELSE
                BEGIN
                    SET @SchemaName = @DatabaseName

                    SELECT @query = 'CREATE SCHEMA [' + @SchemaName + '];';

                    IF NOT EXISTS (SELECT *
                                   FROM   sys.schemas
                                   WHERE  NAME = @SchemaName)
                      BEGIN
                          PRINT @query

                          IF( @WhatIf = 0 )
                            EXEC( @query)
                      END
                END
---TABLE
IF NOT EXISTS (SELECT *
               FROM   sys.objects
               WHERE  object_id = Object_id(N'[Unitrac_Tools].[LFP_MatchingStats]')
                      AND type IN ( N'U' ))
  BEGIN
      CREATE TABLE [Unitrac_Tools].[LFP_MatchingStats]
        (
           [LenderCode]                [NVARCHAR](10) NULL,
           [WI_ID]                     [BIGINT] NOT NULL,
           [TRANSACTION_ID]            [BIGINT] NOT NULL,
           [MessageServerUserName]     [NVARCHAR](15) NULL,
           [CountLetd]                 [INT] NULL,
           [MessageServerStartTime]    [DATETIME] NULL,
           [first_letd]                [DATETIME] NULL,
           [last_letd]                 [DATETIME] NULL,
           [delta_time_Start_First]    [DATETIME] NULL,
           [delta_time_First_Last]     [DATETIME] NULL,
           [CacheLoadTransformSeconds] [INT] NULL,
           [MatchingSeconds]           [INT] NULL,
           [loans_per_sec]             [DECIMAL](37, 19) NULL
           PRIMARY KEY CLUSTERED(TRANSACTION_ID) WITH( PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = ROW) ON [PRIMARY]
        )
      ON [PRIMARY]

      PRINT 'SUCCESS: TABLE [Unitrac_Tools].[LFP_MatchingStats] HAS BEEN CREATED!!!'
  END
ELSE
  BEGIN
      PRINT 'WARNING: TABLE [Unitrac_Tools].[LFP_MatchingStats] HAVE ALREADY BEEN CREATED.'
  END

---2nd TABLE
IF NOT EXISTS (SELECT *
               FROM   sys.objects
               WHERE  object_id = Object_id(N'[Unitrac_Tools].[LFP_PostingStats]')
                      AND type IN ( N'U' ))
  BEGIN
      CREATE TABLE [Unitrac_Tools].[LFP_PostingStats]
        (
           [LenderCode]     [NVARCHAR](10) NULL,
           [WI_ID]          [BIGINT] NULL,
           [CreateDate]     [DATE] NULL,
           [process_log_id] [BIGINT] NOT NULL,
           [pli_count]      [INT] NULL,
           [first_pli]      [DATETIME] NULL,
           [last_pli]       [DATETIME] NULL,
           [delta_time]     [DATETIME] NULL,
           [seconds]        [INT] NULL,
           [loans_per_sec]  [DECIMAL](37, 19) NULL,
           [Min_UpdateUser] [NVARCHAR](15) NULL,
           [Max_UpdateUser] [NVARCHAR](15) NULL
           PRIMARY KEY CLUSTERED(process_log_id) WITH( PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = ROW) ON [PRIMARY]
        )
      ON [PRIMARY]

      PRINT 'SUCCESS: TABLE [Unitrac_Tools].[LFP_PostingStats] HAS BEEN CREATED!!!'
  END
ELSE
  BEGIN
      PRINT 'WARNING: TABLE [Unitrac_Tools].[LFP_PostingStats] HAVE ALREADY BEEN CREATED.'
  END

--1 STORED PROCEDURE 
USE [UniTrac_Maintenance]

GO

/****** Object:  StoredProcedure [dbo].[Generate_LFP_MatchingStats]    Script Date: 12/14/2023 1:44:26 PM ******/
SET ANSI_NULLS ON

GO

SET QUOTED_IDENTIFIER ON

GO

IF NOT EXISTS (SELECT *
               FROM   sys.objects
               WHERE  object_id = Object_id(N'[Unitrac_Tools].[Generate_LFP_MatchingStats]')
                      AND type IN ( N'P', N'PC' ))
  BEGIN
      /* Create Empty Stored Procedure */
      EXEC dbo.Sp_executesql
        @statement = N'CREATE PROCEDURE [Unitrac_Tools].[Generate_LFP_MatchingStats] AS RETURN 0;';
  END;

GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [Unitrac_Tools].[Generate_lfp_matchingstats] (@WhatIF BIT = 1)
AS
  BEGIN
      -- SET NOCOUNT ON added to prevent extra result sets from
      -- interfering with SELECT statements.
      SET NOCOUNT ON;

      DECLARE @TranType AS VARCHAR(max)

      SET @TranType ='UNITRAC'

      --SET @TranType ='INFA'
      BEGIN
          SELECT wi.ID              AS WI_ID,
                 wi.CREATE_DT,
                 t.ID               AS trans_id,
                 tpl.UPDATE_USER_TX AS MessageServerUserName,
                 Min(tpl.CREATE_DT) AS MessageServerStartTime,
                 Min(ldr.CODE_TX)   AS LenderCode
          INTO   #tmpWI
          FROM   UniTrac.dbo.WORK_ITEM wi
                 JOIN UniTrac.dbo.DOCUMENT D
                   ON wi.RELATE_ID = D.MESSAGE_ID
                 JOIN UniTrac.dbo.[TRANSACTION] t
                   ON T.document_id = D.ID
                 JOIN UniTrac.dbo.TRADING_PARTNER_LOG tpl
                   ON tpl.MESSAGE_ID = wi.RELATE_ID
                 JOIN UniTrac.dbo.LENDER ldr
                   ON ldr.id = wi.LENDER_ID
          WHERE  wi.WORKFLOW_DEFINITION_ID = 1
                 AND Cast(wi.CREATE_DT AS DATE) = Cast(Getdate() - 1 AS DATE)
                 AND wi.STATUS_CD NOT IN ( 'error', 'withdrawn', 'late' )
                 AND ( t.RELATE_TYPE_CD = @TranType
                        OR T.RELATE_TYPE_CD = '' )
                 AND T.PURGE_DT IS NULL
                 AND wi.PURGE_DT IS NULL
                 AND D.PURGE_DT IS NULL
                 AND tpl.LOG_MESSAGE = 'Started Processing Message'
          GROUP  BY wi.ID,
                    wi.CREATE_DT,
                    t.ID,
                    tpl.UPDATE_USER_TX

          IF( @WhatIF = 0 )
            BEGIN
                INSERT INTO UniTrac_Maintenance.[Unitrac_Tools].LFP_MatchingStats
                            (LenderCode,
                             WI_ID,
                             TRANSACTION_ID,
                             MessageServerUserName,
                             CountLetd,
                             MessageServerStartTime,
                             first_letd,
                             last_letd,
                             delta_time_Start_First,
                             delta_time_First_Last,
                             CacheLoadTransformSeconds,
                             MatchingSeconds,
                             loans_per_sec)
                SELECT Min (LenderCode)                                                                                          AS LenderCode,
                       w.WI_ID,
                       letd.TRANSACTION_ID,
                       Min(MessageServerUserName)                                                                                AS MessageServerUserName,
                       Count(*)                                                                                                  AS CountLetd,
                       Min(w.MessageServerStartTime)                                                                             AS MessageServerStartTime,
                       Min(letd.CREATE_DT)                                                                                       AS first_letd,
                       Max(letd.CREATE_DT)                                                                                       AS last_letd,
                       Max(letd.CREATE_DT) - Min(MessageServerStartTime)                                                         AS delta_time_Start_First,
                       Max(letd.CREATE_DT) - Min(letd.CREATE_DT)                                                                 AS delta_time_First_Last,
                       Datediff(second, Min(MessageServerStartTime), Min(letd.CREATE_DT))                                        AS 'CacheLoadTransformSeconds',
                       Datediff(second, Min(letd.CREATE_DT), Max(letd.CREATE_DT))                                                AS 'MatchingSeconds',
                       CONVERT(DECIMAL, Count(*)) / CONVERT(DECIMAL, Datediff(second, Min(letd.CREATE_DT), Max(letd.CREATE_DT))) AS 'loans/per-sec'
                FROM   #tmpWI w
                       JOIN UniTrac.dbo.LOAN_EXTRACT_TRANSACTION_DETAIL letd
                         ON letd.TRANSACTION_ID = w.trans_id
                GROUP  BY w.WI_ID,
                          letd.TRANSACTION_ID
                HAVING Datediff(second, Min(UPDATE_DT), Max(UPDATE_DT)) > 1
            END
          ELSE
            BEGIN
                /* Invoke changes */
                SELECT Min (LenderCode)                                                                                          AS LenderCode,
                       w.WI_ID,
                       letd.TRANSACTION_ID,
                       Min(MessageServerUserName)                                                                                AS MessageServerUserName,
                       Count(*)                                                                                                  AS CountLetd,
                       Min(w.MessageServerStartTime)                                                                             AS MessageServerStartTime,
                       Min(letd.CREATE_DT)                                                                                       AS first_letd,
                       Max(letd.CREATE_DT)                                                                                       AS last_letd,
                       Max(letd.CREATE_DT) - Min(MessageServerStartTime)                                                         AS delta_time_Start_First,
                       Max(letd.CREATE_DT) - Min(letd.CREATE_DT)                                                                 AS delta_time_First_Last,
                       Datediff(second, Min(MessageServerStartTime), Min(letd.CREATE_DT))                                        AS 'CacheLoadTransformSeconds',
                       Datediff(second, Min(letd.CREATE_DT), Max(letd.CREATE_DT))                                                AS 'MatchingSeconds',
                       CONVERT(DECIMAL, Count(*)) / CONVERT(DECIMAL, Datediff(second, Min(letd.CREATE_DT), Max(letd.CREATE_DT))) AS 'loans/per-sec'
                FROM   #tmpWI w
                       JOIN UniTrac.dbo.LOAN_EXTRACT_TRANSACTION_DETAIL letd
                         ON letd.TRANSACTION_ID = w.trans_id
                GROUP  BY w.WI_ID,
                          letd.TRANSACTION_ID
                HAVING Datediff(second, Min(UPDATE_DT), Max(UPDATE_DT)) > 1
            END
      END
  END

GO 


---STORED PROC 2

USE [UniTrac_Maintenance]
GO

/****** Object:  StoredProcedure [dbo].[Generate_LFP_PostingRate]    Script Date: 12/14/2023 1:44:59 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Unitrac_Tools].[Generate_LFP_PostingRate]') AND type in (N'P', N'PC'))
BEGIN
	/* Create Empty Stored Procedure */
	EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [Unitrac_Tools].[Generate_LFP_PostingRate] AS RETURN 0;';
END;
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [Unitrac_Tools].[Generate_LFP_PostingRate] ( @WhatIF BIT = 1 )
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
DECLARE @TranType AS varchar(max)

SET @TranType ='UNITRAC'
--SET @TranType ='INFA'

SELECT  
WI.CONTENT_XML.value('(/Content/Information/ProcessLogs/ProcessLog/@Id)[1]','nvarchar(max)') AS pl_id,ldr.CODE_TX, wi.ID as wi_id
INTO #tmp
FROM UniTrac.dbo.WORK_ITEM wi
JOIN UniTrac.dbo.LENDER ldr ON ldr.ID = wi.LENDER_ID
JOIN UniTrac.dbo.WORK_ITEM_ACTION wia ON wia.WORK_ITEM_ID = wi.ID 
WHERE wia.TO_STATUS_CD = 'ImportCompleted'
and wi.WORKFLOW_DEFINITION_ID = 1
AND wi.STATUS_CD NOT IN ( 'FileMaintenance','Approve','Withdrawn','Failed Validation', 'error')
AND wia.FROM_STATUS_CD != 'ImportCompleted'
--AND ldr.CODE_TX = '5044'
AND CAST(wi.CREATE_DT AS DATE) = CAST(GETDATE() - 1 AS date)
--AND wia.UPDATE_USER_TX = 'LDHPCRA'

IF( @WhatIF = 0 )
        BEGIN
INSERT INTO UniTrac_Maintenance.[Unitrac_Tools].LFP_PostingStats 
	(LenderCode, 
	 WI_ID,
	 CreateDate,
	  process_log_id,
	  pli_count,
	  first_pli, 
	  last_pli, 
	  delta_time, 
	  seconds, 
	  loans_per_sec, 
	  Min_UpdateUser, 
	  Max_UpdateUser)
	SELECT

		MIN(t.CODE_TX) AS LenderCode
	   ,MIN(t.WI_ID) AS WI_ID
	   ,MIN(CAST(pli.CREATE_DT AS DATE)) CreateDate
	   ,process_log_id
	   ,COUNT(*) AS pli_count
	   ,MIN(UPDATE_DT) AS first_pli
	   ,MAX(UPDATE_DT) AS last_pli
	   ,MAX(UPDATE_DT) - MIN(UPDATE_DT) AS delta_time
	   ,DATEDIFF(SECOND, MIN(UPDATE_DT), MAX(UPDATE_DT)) AS 'seconds'
	   ,CONVERT(DECIMAL, COUNT(*)) / CONVERT(DECIMAL, DATEDIFF(SECOND, MIN(UPDATE_DT), MAX(UPDATE_DT))) AS 'loans/per-sec'
	   ,MIN(pli.UPDATE_USER_TX) AS Min_UpdateUser
	   ,MAX(pli.UPDATE_USER_TX) AS Max_UpdateUser
	FROM UniTrac.dbo.PROCESS_LOG_ITEM pli
	JOIN #tmp t
		ON t.pl_id = pli.process_log_id
	WHERE RELATE_TYPE_CD = 'allied.unitrac.loan'
	AND pli.STATUS_CD != 'GENERIC'
	GROUP BY process_log_id
	HAVING DATEDIFF(SECOND, MIN(UPDATE_DT), MAX(UPDATE_DT)) > 1
	ORDER BY MIN(CAST(pli.CREATE_DT AS DATE)), WI_ID  
END
ELSE 
BEGIN 
	SELECT

		MIN(t.CODE_TX) AS LenderCode
	   ,MIN(t.WI_ID) AS WI_ID
	   ,MIN(CAST(pli.CREATE_DT AS DATE)) CreateDate
	   ,process_log_id
	   ,COUNT(*) AS pli_count
	   ,MIN(UPDATE_DT) AS first_pli
	   ,MAX(UPDATE_DT) AS last_pli
	   ,MAX(UPDATE_DT) - MIN(UPDATE_DT) AS delta_time
	   ,DATEDIFF(SECOND, MIN(UPDATE_DT), MAX(UPDATE_DT)) AS 'seconds'
	   ,CONVERT(DECIMAL, COUNT(*)) / CONVERT(DECIMAL, DATEDIFF(SECOND, MIN(UPDATE_DT), MAX(UPDATE_DT))) AS 'loans/per-sec'
	   ,MIN(pli.UPDATE_USER_TX) AS Min_UpdateUser
	   ,MAX(pli.UPDATE_USER_TX) AS Max_UpdateUser
	FROM UniTrac.dbo.PROCESS_LOG_ITEM pli
	JOIN #tmp t
		ON t.pl_id = pli.process_log_id
	WHERE RELATE_TYPE_CD = 'allied.unitrac.loan'
	AND pli.STATUS_CD != 'GENERIC'
	GROUP BY process_log_id
	HAVING DATEDIFF(SECOND, MIN(UPDATE_DT), MAX(UPDATE_DT)) > 1
	ORDER BY MIN(CAST(pli.CREATE_DT AS DATE)), WI_ID  
END
END; 
