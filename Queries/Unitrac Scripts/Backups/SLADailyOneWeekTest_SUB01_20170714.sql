USE [Unitrac_Reports]
GO
/****** Object:  StoredProcedure [dbo].[SLADailyOneWeekTest]    Script Date: 7/15/2017 12:54:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[SLADailyOneWeekTest]
AS

---- declare PERIOD value
declare @MondayDT VARCHAR(50);
declare @TuesdayDT VARCHAR(50);
declare @WednesdayDT VARCHAR(50);
declare @ThursdayDT VARCHAR(50);
declare @FridayDT VARCHAR(50);

declare @CurrentReleaseDT VARCHAR(50);
declare @LastReleaseDT VARCHAR(50);
declare @CurrentReleaseTX VARCHAR(20);
declare @LastReleaseTX VARCHAR(20);

declare @RetriveDT VARCHAR(50) = GETDATE() - 3;

BEGIN
SELECT RLO.*
INTO #ReleaseOrdered
FROM (
	  SELECT ROW_NUMBER() OVER (ORDER BY RELEASE_DT DESC) AS RowNumber, OperationalDashboard.dbo.RELEASE_CONFIG.*
								FROM OperationalDashboard.dbo.RELEASE_CONFIG
								WHERE APPLICATION_NAME_TX = 'Unitrac'
								AND DB_INSTANCE = 'PRODUCTION'
								AND ACTIVE_IND = 1
								AND PURGE_DT IS NULL
)RLO

	SET @CurrentReleaseDT = (SELECT release_dt
						FROM #ReleaseOrdered ordered
						WHERE RowNumber = 1)
	SET @LastReleaseDT = (SELECT release_dt
						FROM #ReleaseOrdered ordered
						WHERE RowNumber = 2)
	SET @CurrentReleaseTX = (SELECT RELEASE_NAME_TX
						FROM #ReleaseOrdered ordered
						WHERE RowNumber = 1)
	SET @LastReleaseTX = (SELECT RELEASE_NAME_TX
						FROM #ReleaseOrdered ordered
						WHERE RowNumber = 2)

	SET @MondayDT = (SELECT DATEADD(wk, DATEDIFF(wk,0,@RetriveDT), 0))
	SET @TuesdayDT = (SELECT DATEADD(wk, DATEDIFF(wk,0,@RetriveDT), 1))
	SET @WednesdayDT = (SELECT DATEADD(wk, DATEDIFF(wk,0,@RetriveDT), 2))
	SET @ThursdayDT = (SELECT DATEADD(wk, DATEDIFF(wk,0,@RetriveDT), 3))
	SET @FridayDT = (SELECT DATEADD(wk, DATEDIFF(wk,0,@RetriveDT), 4))

   IF OBJECT_ID('tempdb..#tmpUserIds') IS NOT NULL
	DROP TABLE #tmpUserIds

---- users currently configured for perf logging
select distinct id 
into #tmpUserIds
from (
      select distinct
             u.id
             --, u.family_name_tx + ', ' + u.given_name_tx
      from
             users u
             join security_container sc on sc.user_id = u.id
             join security_function sf on sf.id = sc.security_func_id and sf.CODE_TX = 'PERFLOG' and (ENABLE_ATTRIBUTE_1_IN = 'Y' OR ENABLE_ATTRIBUTE_2_IN = 'Y' OR ENABLE_ATTRIBUTE_3_IN = 'Y' OR ENABLE_ATTRIBUTE_4_IN = 'Y')
      --where
      --    u.family_name_tx like 'paqu%'
      UNION
      SELECT distinct U.ID
      FROM
             USERS U
             join USER_SECURITY_GROUP_RELATE usgr ON usgr.user_id = u.id
             join SECURITY_GROUP sg on sg.id = usgr.sec_grp_id
             join SECURITY_CONTAINER sc on sc.SECURITY_GRP_ID = sg.id
             join SECURITY_FUNCTION sf on sf.id = sc.SECURITY_FUNC_ID and sf.CODE_TX = 'PERFLOG' and (ENABLE_ATTRIBUTE_1_IN = 'Y' OR ENABLE_ATTRIBUTE_2_IN = 'Y' OR ENABLE_ATTRIBUTE_3_IN = 'Y' OR ENABLE_ATTRIBUTE_4_IN = 'Y')
      --where
      --    u.family_name_tx like 'paqu%'
      ) tmp


   IF OBJECT_ID('tempdb..#DailyTb') IS NOT NULL
	DROP TABLE #DailyTb

Select t.* 
into #DailyTb
from (
	SELECT 'Monday' AS WEEK_DAY, CONVERT(CHAR,(CONVERT(date, @MondayDT))) as Daily, 2 AS NUMBER, case when CONVERT(date, @MondayDT) > CONVERT(date, @CurrentReleaseDT) then @CurrentReleaseTX else @LastReleaseTX end as Release
	UNION 
	SELECT 'Tuesday' AS WEEK_DAY, CONVERT(CHAR,(CONVERT(date, @TuesdayDT))) as Daily, 3 AS NUMBER, case when CONVERT(date, @TuesdayDT) > CONVERT(date, @CurrentReleaseDT) then @CurrentReleaseTX else @LastReleaseTX end as Release
	union 
	select 'Wednesday' AS WEEK_DAY, CONVERT(CHAR,(CONVERT(date, @WednesdayDT))) as Daily, 4 AS NUMBER, case when CONVERT(date, @WednesdayDT) > CONVERT(date, @CurrentReleaseDT) then @CurrentReleaseTX else @LastReleaseTX end as Release
	UNION 
	SELECT 'Thursday' AS WEEK_DAY, CONVERT(CHAR,(CONVERT(date, @ThursdayDT))) as Daily, 5 AS NUMBER, case when CONVERT(date, @ThursdayDT) > CONVERT(date, @CurrentReleaseDT) then @CurrentReleaseTX else @LastReleaseTX end as Release
	union 
	select 'Friday' AS WEEK_DAY, CONVERT(CHAR,(CONVERT(date, @FridayDT))) as Daily, 6 AS NUMBER, case when CONVERT(date, @FridayDT) > CONVERT(date, @CurrentReleaseDT) then @CurrentReleaseTX else @LastReleaseTX end as Release
)t

--Notice & Certification GEN temp table
SELECT pli.CREATE_DT as startdate,
		dc.CREATE_DT as enddate,
		pli.RELATE_TYPE_CD
INTO #NoCerGen
FROM 
	PROCESS_DEFINITION (NOLOCK) pd 
	JOIN PROCESS_LOG (NOLOCK) pl ON pl.PROCESS_DEFINITION_ID = pd.ID AND pd.PURGE_DT is null
	JOIN PROCESS_LOG_ITEM (NOLOCK) pli ON pli.PROCESS_LOG_ID = pl.ID and pli.PURGE_DT is null
	JOIN DOCUMENT_CONTAINER (NOLOCK) dc  ON dc.RELATE_ID = pli.RELATE_ID and dc.RELATE_CLASS_NAME_TX = pli.RELATE_TYPE_CD and dc.PURGE_DT is NULL
	JOIN NOTICE n ON pli.RELATE_ID = n.ID
	JOIN LOAN l on l.ID = n.LOAN_ID AND l.PURGE_DT is NULL
	JOIN lender ldr ON ldr.ID = l.LENDER_ID and ldr.PURGE_DT is null AND ldr.TEST_IN = 'N'
	JOIN EVALUATION_EVENT ee on  ee.id = pli.EVALUATION_EVENT_ID 
WHERE pd.PROCESS_TYPE_CD = 'cycleprc'
	 AND dc.PURGE_DT is NULL
	 AND pli.RELATE_TYPE_CD in ('Allied.UniTrac.Notice','Allied.UniTrac.ForcePlacedCertificate')
	 AND pl.create_dt >= @MondayDT
	 AND pli.CREATE_DT >= @MondayDT
	 AND dc.CREATE_DT >= @MondayDT
	 AND (CAST(ee.EVENT_DT AS DATE) = CAST(dc.CREATE_DT as DATE) OR CAST(ee.EVENT_DT AS DATE) = CAST(dc.CREATE_DT -1 as DATE)) -- this account for day change after when executed before midnight

-- Notice Print temp table
SELECT
	ob.ID AS OUTPUT_BATCH_ID,
	min(dc.create_dt) as CreateDate,
	getdate() as ResolvedDate,
	MIN(dc.PRINTED_DT) AS MinPrintDate
INTO #NoticePrint
FROM
	PROCESS_DEFINITION (NOLOCK) pd
	JOIN PROCESS_LOG (NOLOCK) pl ON pl.PROCESS_DEFINITION_ID = pd.ID AND pd.PURGE_DT is null
	JOIN PROCESS_LOG_ITEM (NOLOCK) pli ON pli.PROCESS_LOG_ID = pl.ID and pli.PURGE_DT is null
	JOIN DOCUMENT_CONTAINER (NOLOCK) dc  ON dc.RELATE_ID = pli.RELATE_ID and dc.RELATE_CLASS_NAME_TX = pli.RELATE_TYPE_CD and dc.PURGE_DT is NULL
	JOIN OUTPUT_BATCH ob ON ob.PROCESS_LOG_ID = pl.ID AND ob.PURGE_DT is NULL
WHERE pd.PROCESS_TYPE_CD = 'cycleprc'
	AND dc.PURGE_DT is NULL
	AND pl.create_dt >= @MondayDT
	AND pli.CREATE_DT >= @MondayDT
	AND dc.CREATE_DT >= @MondayDT
	AND LEFT(ob.EXTERNAL_ID,3) = 'NTC'
	AND dc.RECIPIENT_TYPE_CD != 'BIA'
	AND ob.SUB_TYPE_CD = 'CYC'   
	AND pli.RELATE_TYPE_CD = 'Allied.UniTrac.Notice'
GROUP BY  ob.ID

update #NoticePrint
set ResolvedDate = t.ResolveDate
FROM
(select ob.id, max(dc.print_status_assigned_dt) as ResolveDate
from
      OUTPUT_BATCH ob
      join #NoticePrint tnp on tnp.OUTPUT_BATCH_ID = ob.id
    JOIN PROCESS_LOG_ITEM (NOLOCK) pli ON pli.PROCESS_LOG_ID = ob.PROCESS_LOG_ID and pli.PURGE_DT is null AND Pli.RELATE_TYPE_CD = 'Allied.UniTrac.Notice'
    JOIN DOCUMENT_CONTAINER (NOLOCK) dc  ON dc.RELATE_ID = pli.RELATE_ID and dc.RELATE_CLASS_NAME_TX = pli.RELATE_TYPE_CD and dc.PURGE_DT is NULL
                                            AND dc.PRINT_STATUS_ASSIGNED_DT <= ISNULL(tnp.MinPrintDate,'9999-01-01') and dc.PURGE_DT is null and dc.RECIPIENT_TYPE_CD != 'BIA'
group by
      ob.id
      ) t
where
      t.id = #NoticePrint.OUTPUT_BATCH_ID

-- Certification Print temp table
SELECT
	ob.ID AS OUTPUT_BATCH_ID,
	min(dc.create_dt) as CreateDate,
	getdate() as ResolvedDate,
	MIN(dc.PRINTED_DT) AS MinPrintDate
INTO #CertificationPrint
FROM
	PROCESS_DEFINITION (NOLOCK) pd
	JOIN PROCESS_LOG (NOLOCK) pl ON pl.PROCESS_DEFINITION_ID = pd.ID AND pd.PURGE_DT is null
	JOIN PROCESS_LOG_ITEM (NOLOCK) pli ON pli.PROCESS_LOG_ID = pl.ID and pli.PURGE_DT is null
	JOIN DOCUMENT_CONTAINER (NOLOCK) dc  ON dc.RELATE_ID = pli.RELATE_ID and dc.RELATE_CLASS_NAME_TX = pli.RELATE_TYPE_CD and dc.PURGE_DT is NULL
	JOIN OUTPUT_BATCH ob ON ob.PROCESS_LOG_ID = pl.ID AND ob.PURGE_DT is NULL
WHERE pd.PROCESS_TYPE_CD = 'cycleprc'
	AND dc.PURGE_DT is NULL
	AND pl.create_dt >= @MondayDT
	AND pli.CREATE_DT >= @MondayDT
	AND dc.CREATE_DT >= @MondayDT
	AND LEFT(ob.EXTERNAL_ID,3) = 'FPC'
	AND dc.RECIPIENT_TYPE_CD != 'BIA'
	AND ob.SUB_TYPE_CD = 'CYC'   
	AND pli.RELATE_TYPE_CD = 'Allied.UniTrac.ForcePlacedCertificate'
	AND UPPER(ob.STATUS_CD) != 'EMPTY'
GROUP BY  ob.ID

update #CertificationPrint
set ResolvedDate = t.ResolveDate
FROM
(select ob.id, max(dc.print_status_assigned_dt) as ResolveDate
from
      OUTPUT_BATCH ob
      join #CertificationPrint tnp on tnp.OUTPUT_BATCH_ID = ob.id
    JOIN PROCESS_LOG_ITEM (NOLOCK) pli ON pli.PROCESS_LOG_ID = ob.PROCESS_LOG_ID and pli.PURGE_DT is null AND Pli.RELATE_TYPE_CD = 'Allied.UniTrac.ForcePlacedCertificate'
    JOIN DOCUMENT_CONTAINER (NOLOCK) dc  ON dc.RELATE_ID = pli.RELATE_ID and dc.RELATE_CLASS_NAME_TX = pli.RELATE_TYPE_CD and dc.PURGE_DT is NULL
                                            AND dc.PRINT_STATUS_ASSIGNED_DT <= ISNULL(tnp.MinPrintDate,'9999-01-01') and dc.PURGE_DT is null and dc.RECIPIENT_TYPE_CD != 'BIA'  
group by
      ob.id
      ) t
where
      t.id = #CertificationPrint.OUTPUT_BATCH_ID

--MP temp tables
SELECT TPL.MESSAGE_ID, max(TPL.CREATE_DT) AS create_dt,TP.TYPE_CD
INTO #MP2HrMessage
FROM TRADING_PARTNER_LOG TPL (NOLOCK) 
	join TRADING_PARTNER TP on TP.ID = TPL.TRADING_PARTNER_ID
WHERE  
	tpl.create_dt >= @MondayDT
	AND TPL.PROCESS_CD = 'DW' 
	AND TP.TYPE_CD in ('LFP_TP','IDR_TP','EDI_TP')
	AND TPL.LOG_MESSAGE = 'Work Item processed and status set to Received'
GROUP by TPL.MESSAGE_ID,tp.type_cd

SELECT wi.ID AS WorkItemId, min(wia.CREATE_DT) AS CompletedDate, MIN(m.create_dt) AS CreateDate, MIN(m.MESSAGE_ID) AS messageid
INTO #LFPResults
FROM WORK_ITEM wi
	JOIN #MP2HrMessage m ON m.MESSAGE_ID = wi.RELATE_ID 
	JOIN WORK_ITEM_ACTION wia ON wia.WORK_ITEM_ID = wi.ID
WHERE RELATE_TYPE_CD = 'LDHLib.Message'
	AND wia.TO_STATUS_CD in ('received')
	AND m.type_cd = 'LFP_TP'
GROUP BY wi.id

SELECT  min(m1.UPDATE_DT) AS CompletedDate, MIN(m.create_dt) AS CreateDate, MIN(m.MESSAGE_ID) AS messageid, m.type_cd
INTO #IDR_EDI_Results
FROM #MP2HrMessage m 
	JOIN MESSAGE m1 ON m.MESSAGE_ID = m1.RELATE_ID_TX
WHERE m1.PROCESSED_IN = 'Y' and m.type_cd != 'LFP_TP'
GROUP BY m1.id,m.type_cd

--MP LPF Posting 4/8 Hrs temp tables
SELECT wia.WORK_ITEM_ID, max(wia.CREATE_DT) AS CreateDate -- using MAX to account for WIs that have been approved multiple times
INTO #tmpApproval
FROM WORK_ITEM wi 
	JOIN WORK_ITEM_ACTION wia ON wia.WORK_ITEM_ID = wi.ID
WHERE  wia.TO_STATUS_CD IN ('Approve')
	AND ACTION_CD != 'Add Note Only'
	AND wi.WORKFLOW_DEFINITION_ID = 1
	AND wi.CREATE_DT >= @MondayDT
GROUP BY wia.WORK_ITEM_ID

SELECT t.WORK_ITEM_ID AS WorkItemId, max(wia.CREATE_DT) AS CompletedDate, MIN(t.CreateDate) AS CreateDate -- using MAX to account for WIs that have been approved multiple times
INTO #48Results
FROM #tmpApproval t
	JOIN WORK_ITEM_ACTION wia ON wia.WORK_ITEM_ID = t.WORK_ITEM_ID
WHERE wia.TO_STATUS_CD in ('ImportCompleted','DataMaintenance')
	AND ACTION_CD != 'Add Note Only'
GROUP BY t.WORK_ITEM_ID

--MP Outbound GL temp table
SELECT mInbound.CREATE_DT AS StartDate, mOut.UPDATE_DT as EndDate, mInbound.id
INTO #tmpOutboundGL
FROM RELATED_DATA_DEF rdd
JOIN RELATED_DATA rd on rd.DEF_ID = rdd.ID 
JOIN DELIVERY_INFO di ON di.ID = rd.RELATE_ID AND di.PURGE_DT IS null
JOIN TRADING_PARTNER tp ON tp.ID = di.TRADING_PARTNER_ID  AND tp.PURGE_DT IS null
JOIN MESSAGE mInbound ON mInbound.RECIPIENT_TRADING_PARTNER_ID = tp.ID and mInbound.PURGE_DT is null
JOIN MESSAGE mOut ON mOut.RELATE_ID_TX = mInbound.ID and mOut.PURGE_DT is NULL
LEFT JOIN WORK_ITEM wi ON wi.RELATE_ID = mInbound.ID and wi.RELATE_TYPE_CD ='LDHLib.Message'
WHERE rdd.RELATE_CLASS_NM = 'DeliveryInfo' 
AND rdd.NAME_TX = 'UniTracDeliveryType' 
AND rd.VALUE_TX = 'GLBCKFD' 
AND mInbound.create_dt >= @MondayDT
AND wi.ID IS NULL

--MP InsuranceBackfee temp table
SELECT mInbound.CREATE_DT AS StartDate, mOut.UPDATE_DT as EndDate, mInbound.id
INTO #tmpInsBackFeed
FROM RELATED_DATA_DEF rdd
JOIN RELATED_DATA rd on rd.DEF_ID = rdd.ID 
JOIN DELIVERY_INFO di ON di.ID = rd.RELATE_ID AND di.PURGE_DT IS null
JOIN TRADING_PARTNER tp ON tp.ID = di.TRADING_PARTNER_ID  AND tp.PURGE_DT IS NULL 
JOIN MESSAGE mInbound ON mInbound.RECIPIENT_TRADING_PARTNER_ID = tp.ID and mInbound.PURGE_DT is null
JOIN MESSAGE mOut ON mOut.RELATE_ID_TX = mInbound.ID and mOut.PURGE_DT is NULL
JOIN WORK_ITEM wi on wi.RELATE_ID = mInbound.id and wi.RELATE_TYPE_CD ='LDHLib.Message' AND wi.WORKFLOW_DEFINITION_ID = 13
WHERE rdd.RELATE_CLASS_NM = 'DeliveryInfo' 
AND rdd.NAME_TX = 'UniTracDeliveryType' 
AND rd.VALUE_TX = 'INSBCKFD' 
AND mInbound.create_dt >= @MondayDT

--MP EOM temp table
SELECT TPL.MESSAGE_ID, MIN(mInbound.CREATE_DT) AS StartDate, MAX(mOutbound.UPDATE_DT) AS EndDate
INTO #tmpEOMMP
FROM TRADING_PARTNER_LOG TPL (NOLOCK) 
	join TRADING_PARTNER TP on TP.ID = TPL.TRADING_PARTNER_ID and TP.PURGE_DT is NULL
	JOIN MESSAGE mInbound ON mInbound.ID = TPL.MESSAGE_ID AND mInbound.PURGE_DT is NULL
	JOIN MESSAGE mOutbound ON mOutbound.RELATE_ID_TX = mInbound.ID AND mOutbound.PURGE_DT is null
WHERE  
	tpl.create_dt >= @MondayDT
	AND TP.TYPE_CD = 'carrier_TP'
GROUP by TPL.MESSAGE_ID

--EOM Report temp table
SELECT rh.ID, MAX(rh.CREATE_DT) AS StartDate, MAX(dc.CREATE_DT) AS EndDate
INTO #tmpEOMReports
FROM REPORT_HISTORY rh
	JOIN PROCESS_LOG_ITEM pli ON pli.RELATE_ID = rh.ID AND pli.RELATE_TYPE_CD = 'Allied.UniTrac.ReportHistory' and rh.PURGE_DT is NULL and pli.PURGE_DT is null
	JOIN WORK_ITEM wi ON wi.RELATE_ID = pli.PROCESS_LOG_ID and wi.PURGE_DT is null AND wi.WORKFLOW_DEFINITION_ID = 12
	JOIN PROCESS_LOG pl on wi.RELATE_ID = pl.ID AND wi.RELATE_TYPE_CD = 'Osprey.ProcessMgr.ProcessLog' AND pl.PURGE_DT IS null
	JOIN PROCESS_DEFINITION pd ON pd.ID = pl.PROCESS_DEFINITION_ID AND pd.PURGE_DT is NULL and pd.PURGE_DT is null
	LEFT JOIN DOCUMENT_CONTAINER dc ON dc.ID = rh.DOCUMENT_CONTAINER_ID 
WHERE rh.create_dt >= @MondayDT
	AND dc.PURGE_DT is NULL
GROUP BY rh.ID

--get all result
-- get all kpi section result
   IF OBJECT_ID('tempdb..#datatemp') IS NOT NULL
	DROP TABLE #datatemp

select newtb.*
into  #datatemp
from  (select DimTime.Daily,
			   DimTime.WEEK_DAY,
			   DimTime.Release,
			   PerformanceLogFunction.TRANSACTION_GROUP_NAME_TX,
			   PerformanceLogFunction.Transaction_name_tx, 
			   PerformanceLogFunction.TIER_NO,
			   vPerfLog.FUNCTION_NAME_TX,
			   vPerfLog.FUNCTION_QUALIFIER_1_TX,
			   vPerfLog.PL_COUNT,
			   vPerfLog.AVERAGE_MS,
			   vPerfLog.PER_SEVEN,
			   vPerfLog.PER_THREE
		from
			(select * from 
				OperationalDashboard.dbo.Transaction_config
				where purge_dt is null
				and application_name_tx = 'Unitrac') PerformanceLogFunction
			CROSS JOIN
				(
				select	*
				from #DailyTb
				WHERE NUMBER < = DATEPART(DW,@RetriveDT)			
				)	DimTime
			left outer join 
				(
				select
					datepart(DW,PL.CREATE_DT) AS 'PERIOD',
					pl.FUNCTION_NAME_TX, 
					pl.FUNCTION_QUALIFIER_1_TX,
					count(pl.id) AS PL_COUNT,
					AVG(pl.elapsed_ms) AS AVERAGE_MS,
					CONVERT(float,COUNT(CASE WHEN pl.elapsed_ms <= 3000 THEN 1 ELSE NULL END))*100/CONVERT(float,COUNT(PL.id)) PER_THREE,
					CONVERT(float,COUNT(CASE WHEN pl.elapsed_ms <= 7000 THEN 1 ELSE NULL END))*100/CONVERT(float,COUNT(PL.id)) PER_SEVEN
				from
					(SELECT 
						CASE
							WHEN pl1.FUNCTION_QUALIFIER_1_TX = 'Allied.UniTrac.Workflow.CPICancelPendingWorkItem'
							OR pl1.FUNCTION_QUALIFIER_1_TX = 'Allied.UniTrac.Workflow.VerifyDataWorkItem'
							OR pl1.FUNCTION_QUALIFIER_1_TX = 'Allied.UniTrac.Workflow.ActionRequestWorkItem'
							THEN 'WorkItemSave'
							ELSE pl1.FUNCTION_NAME_TX
						END AS FUNCTION_NAME_TX,
						CASE
							WHEN pl1.FUNCTION_QUALIFIER_1_TX = 'Allied.UniTrac.Workflow.CPICancelPendingWorkItem' THEN 'CPICancelPendingWorkItem'
							WHEN pl1.FUNCTION_QUALIFIER_1_TX = 'Allied.UniTrac.Workflow.VerifyDataWorkItem' THEN 'VerifyDataWorkItem'
							WHEN pl1.FUNCTION_QUALIFIER_1_TX = 'Allied.UniTrac.Workflow.ActionRequestWorkItem' THEN 'ActionRequestWorkItem'		
							ELSE pl1.FUNCTION_QUALIFIER_1_TX
						END AS FUNCTION_QUALIFIER_1_TX,
							pl1.id,
							pl1.elapsed_ms,
							pl1.create_dt
						from PERFORMANCE_LOG pl1
							left outer join USERS U on u.id = pl1.user_id
							join #tmpUserIds t on t.id = u.id
						where pl1.CREATE_DT >= @MondayDT
						and pl1.FUNCTION_QUALIFIER_1_TX not in ('TreeView')
						and FUNCTION_QUALIFIER_1_TX != 'ExecuteImpl'
					) pl
				group by
					datepart(DW,PL.CREATE_DT),
					pl.FUNCTION_NAME_TX, 
					pl.FUNCTION_QUALIFIER_1_TX

				union all

				select
		
					datepart(DW,PL.CREATE_DT) AS 'PERIOD',
					pl.FUNCTION_NAME_TX, 
					pl.FUNCTION_QUALIFIER_1_TX,
					count(pl.id) AS PL_COUNT,
					AVG(pl.elapsed_ms) AS AVERAGE_MS,
					CONVERT(float,COUNT(CASE WHEN pl.elapsed_ms <= 3000 THEN 1 ELSE NULL END))*100/CONVERT(float,COUNT(PL.id)) PER_THREE,
					CONVERT(float,COUNT(CASE WHEN pl.elapsed_ms <= 7000 THEN 1 ELSE NULL END))*100/CONVERT(float,COUNT(PL.id)) PER_SEVEN
				from
					performance_log pl
					left outer join USERS U on u.id = pl.user_id
					join #tmpUserIds t on t.id = u.id
				where
					pl.CREATE_DT >= @MondayDT
					and pl.FUNCTION_QUALIFIER_1_TX in ('TreeView')
					and FUNCTION_QUALIFIER_4_TX like '%WorkItem Id%'
					and FUNCTION_QUALIFIER_1_TX != 'ExecuteImpl'
				group by
					datepart(DW,PL.CREATE_DT),
					pl.FUNCTION_NAME_TX, 
					pl.FUNCTION_QUALIFIER_1_TX

				union all
	
				select
					datepart(DW,PL.CREATE_DT) AS 'PERIOD',
					pl.FUNCTION_NAME_TX, 
					'Save New Loan' as FUNCTION_QUALIFIER_1_TX,
					count(pl.id) AS PL_COUNT,
					AVG(pl.elapsed_ms) AS AVERAGE_MS,
					CONVERT(float,COUNT(CASE WHEN pl.elapsed_ms <= 3000 THEN 1 ELSE NULL END))*100/CONVERT(float,COUNT(PL.id)) PER_THREE,
					CONVERT(float,COUNT(CASE WHEN pl.elapsed_ms <= 7000 THEN 1 ELSE NULL END))*100/CONVERT(float,COUNT(PL.id)) PER_SEVEN
				from
					performance_log pl
					left outer join USERS U on u.id = pl.user_id
					join #tmpUserIds t on t.id = u.id
				where
					pl.CREATE_DT >= @MondayDT
					AND FUNCTION_NAME_TX = 'PropertyHandler.Save'
					AND FUNCTION_QUALIFIER_2_TX like '%Id: 0%'
					and FUNCTION_QUALIFIER_1_TX != 'ExecuteImpl'
				group by
					datepart(DW,PL.CREATE_DT),
					pl.FUNCTION_NAME_TX

				union all
	
				select
					datepart(DW,PL.CREATE_DT) AS 'PERIOD',
					pl.FUNCTION_NAME_TX, 
					FUNCTION_QUALIFIER_1_TX,
					count(pl.id) AS PL_COUNT,
					AVG(pl.elapsed_ms) AS AVERAGE_MS,
					CONVERT(float,COUNT(CASE WHEN pl.elapsed_ms <= 28800000 THEN 1 ELSE NULL END))*100/CONVERT(float,COUNT(PL.id)) PER_THREE,
					0 PER_SEVEN
				from
					performance_log pl
					left outer join USERS U on u.id = pl.user_id
					join #tmpUserIds t on t.id = u.id
				where
					pl.CREATE_DT >= @MondayDT
					and FUNCTION_NAME_TX = 'UTLMatchProcess' and FUNCTION_QUALIFIER_3_TX = 'Exact:1'
				group by
					datepart(DW,PL.CREATE_DT),
					pl.FUNCTION_NAME_TX,
					FUNCTION_QUALIFIER_1_TX

				union all
	
				select
					datepart(DW,PL.CREATE_DT) AS 'PERIOD',
					pl.FUNCTION_NAME_TX, 
					FUNCTION_QUALIFIER_1_TX,
					count(pl.id) AS PL_COUNT,
					AVG(pl.elapsed_ms) AS AVERAGE_MS,
					CONVERT(float,COUNT(CASE WHEN pl.elapsed_ms <= 1800000 THEN 1 ELSE NULL END))*100/CONVERT(float,COUNT(PL.id)) PER_THREE,
					0 PER_SEVEN
				from
					performance_log pl
					left outer join USERS U on u.id = pl.user_id
					join #tmpUserIds t on t.id = u.id
				where
					pl.CREATE_DT >= @MondayDT
					and FUNCTION_NAME_TX = 'UTLOutboundProcess'
				group by
					datepart(DW,PL.CREATE_DT),
					pl.FUNCTION_NAME_TX,
					FUNCTION_QUALIFIER_1_TX

				union all 

				select	
				    datepart(DW,PL.CREATE_DT) AS 'PERIOD',
					'Daily Cycle' AS FUNCTION_NAME_TX,
					'Process Completion' AS FUNCTION_QUALIFIER_1_TX,
					count(*) AS PL_COUNT,
					cast (AVG(datediff(SECOND, pl.start_dt,pl.end_dt))*1000 as decimal(10,2)) as AVERAGE_MS,
					CAST(SUM (CASE WHEN  convert(decimal,datediff(SECOND, pl.start_dt,pl.end_dt))*1000 < 1800000 then 1 else 0 END )*100/ COUNT(*)  AS DECIMAL(100)) as PER_THREE,
					0 AS PER_SEVEN
				from PROCESS_LOG pl 
					JOIN PROCESS_DEFINITION pd ON pd.ID = pl.PROCESS_DEFINITION_ID AND pd.PURGE_DT is NULL AND pl.PURGE_DT is null
				WHERE pd.PROCESS_TYPE_CD = 'CYCLEPRC'
					AND pl.CREATE_DT >=  @MondayDT
				group by
					datepart(DW,PL.CREATE_DT)

				union all 

				SELECT 
					datepart(DW,rh.create_dt) AS 'PERIOD',
					'Daily Cycle' AS FUNCTION_NAME_TX,
					'Report Generation' AS FUNCTION_QUALIFIER_1_TX,
					count(*) AS PL_COUNT,
					AVG(NULLIF(convert(DECIMAL,datediff(MILLISECOND, rh.CREATE_DT, dc.CREATE_DT)),0)) as AVERAGE_MS,			
					CAST(SUM (CASE WHEN  NULLIF(convert(DECIMAL,datediff(MILLISECOND, rh.create_dt,dc.CREATE_DT)),0) <= 14400000 then 1 else 0 END )*100 / COUNT(*)  AS DECIMAL(100)) as PER_THREE,
					0 AS PER_SEVEN
				FROM REPORT_HISTORY rh
					JOIN PROCESS_LOG_ITEM pli ON pli.RELATE_ID = rh.ID AND pli.RELATE_TYPE_CD = 'Allied.UniTrac.ReportHistory' and rh.PURGE_DT is NULL and pli.PURGE_DT is null
					JOIN WORK_ITEM wi ON wi.RELATE_ID = pli.PROCESS_LOG_ID and wi.PURGE_DT is null
					JOIN PROCESS_LOG pl on wi.RELATE_ID = pl.ID AND wi.RELATE_TYPE_CD = 'Osprey.ProcessMgr.ProcessLog' AND pl.PURGE_DT IS null
					JOIN PROCESS_DEFINITION pd ON pd.ID = pl.PROCESS_DEFINITION_ID AND pd.PURGE_DT is NULL and pd.PURGE_DT is null
					LEFT JOIN DOCUMENT_CONTAINER dc ON dc.ID = rh.DOCUMENT_CONTAINER_ID 
				WHERE pd.PROCESS_TYPE_CD = 'CYCLEPRC'
					AND rh.create_dt >=  @MondayDT
					AND dc.PURGE_DT is NULL
				group by
					datepart(DW,rh.create_dt)
					
				union all 

				SELECT 
					datepart(DW,rh.create_dt) AS 'PERIOD',
					'Daily Billing' AS FUNCTION_NAME_TX,
					'Report Generation 15 mins' AS FUNCTION_QUALIFIER_1_TX,
					count(*) AS PL_COUNT,
					AVG(NULLIF(convert(DECIMAL,datediff(MILLISECOND, rh.CREATE_DT, dc.CREATE_DT)),0)) as AVERAGE_MS,			
					CAST(SUM (CASE when datediff(MINUTE, rh.CREATE_DT,dc.CREATE_DT)  <= 15 then 1 else 0 END )*100 / COUNT(*)  AS DECIMAL(100)) as PER_THREE,
					0 AS PER_SEVEN
				FROM PROCESS_DEFINITION (NOLOCK) pd 
					JOIN PROCESS_LOG (NOLOCK) pl ON pl.PROCESS_DEFINITION_ID = pd.ID AND pd.PURGE_DT is null
					JOIN PROCESS_LOG_ITEM (NOLOCK) pli ON pli.PROCESS_LOG_ID = pl.ID and pli.PURGE_DT is null
					JOIN REPORT_HISTORY (NOLOCK) rh ON rh.ID = pli.RELATE_ID AND pli.RELATE_TYPE_CD = 'Allied.UniTrac.ReportHistory' AND rh.PURGE_DT is null
					LEFT JOIN DOCUMENT_CONTAINER (NOLOCK) dc ON dc.ID = rh.DOCUMENT_CONTAINER_ID 
				WHERE pd.PROCESS_TYPE_CD = 'billing'
					AND rh.create_dt >=  @MondayDT -- should we be using pl.create date here?
					AND dc.PURGE_DT is NULL
					AND (dc.ID is NULL or CAST(dc.CREATE_DT AS DATE) = CAST(rh.CREATE_DT AS DATE) ) 
				group by
					datepart(DW,rh.create_dt)	
					
				union all 

				SELECT 
					datepart(DW,enddate) AS 'PERIOD',
					'Letter Gen' AS FUNCTION_NAME_TX,
					'Notice Gen' AS FUNCTION_QUALIFIER_1_TX,
					count(*) AS PL_COUNT,
					AVG(NULLIF(convert(DECIMAL,datediff(millisecond, startdate, enddate)),0)) as AVERAGE_MS,				
					CAST(SUM (CASE WHEN NULLIF(convert(DECIMAL,datediff(millisecond, startdate,enddate)),0) <= 14400000   then 1 else 0 END ) *100 / COUNT(enddate)  AS DECIMAL(100)) as PER_THREE,
					0 AS PER_SEVEN
				FROM #NoCerGen
				WHERE RELATE_TYPE_CD = 'Allied.UniTrac.Notice'
				group by
					datepart(DW,enddate)

				union all 

				SELECT 
					datepart(DW,enddate) AS 'PERIOD',
					'Letter Gen' AS FUNCTION_NAME_TX,
					'Certificate Gen' AS FUNCTION_QUALIFIER_1_TX,
					count(*) AS PL_COUNT,
					AVG(NULLIF(convert(DECIMAL,datediff(millisecond, startdate, enddate)),0)) as AVERAGE_MS,		
					CAST(SUM (CASE WHEN NULLIF(convert(DECIMAL,datediff(millisecond, startdate,enddate)),0) <= 14400000   then 1 else 0 END ) *100 / COUNT(enddate)  AS DECIMAL(100)) as PER_THREE,
					0 AS PER_SEVEN
				FROM #NoCerGen
				WHERE RELATE_TYPE_CD = 'Allied.UniTrac.ForcePlacedCertificate'
				group by
					datepart(DW,enddate)

				union all 

				SELECT 
					datepart(DW,ob.CREATE_DT) AS 'PERIOD',
					'Letter Gen' AS FUNCTION_NAME_TX,
					'Notice Print' AS FUNCTION_QUALIFIER_1_TX,
					count(*) AS PL_COUNT,
					AVG(NULLIF(convert(DECIMAL,datediff(SECOND, t.ResolvedDate,t.MinPrintDate))*1000,0)) as AVERAGE_MS,		
					CAST(SUM (CASE WHEN NULLIF(convert(DECIMAL,datediff(SECOND, t.ResolvedDate,t.MinPrintDate))*1000,0) <= 1800000   then 1 else 0 END ) *100 / COUNT(ob.id)  AS DECIMAL(100)) as PER_THREE,
					0 AS PER_SEVEN
				FROM #NoticePrint t
					JOIN OUTPUT_BATCH ob on ob.ID = t.OUTPUT_BATCH_ID
				group by
					datepart(DW,ob.CREATE_DT)

				union all 

				SELECT 
					datepart(DW,ob.CREATE_DT) AS 'PERIOD',
					'Letter Gen' AS FUNCTION_NAME_TX,
					'Certificate Print' AS FUNCTION_QUALIFIER_1_TX,
					count(*) AS PL_COUNT,
					AVG(NULLIF(convert(DECIMAL,datediff(MILLISECOND, t.ResolvedDate,t.MinPrintDate)),0)) as AVERAGE_MS,					
					CAST(SUM (CASE WHEN NULLIF(convert(DECIMAL,datediff(SECOND, t.ResolvedDate,t.MinPrintDate))*1000,0) <= 1800000   then 1 else 0 END ) *100 / COUNT(ob.id)  AS DECIMAL(100)) as PER_THREE,
					0 AS PER_SEVEN
				FROM #CertificationPrint t
					JOIN OUTPUT_BATCH ob on ob.ID = t.OUTPUT_BATCH_ID
				group by
					datepart(DW,ob.CREATE_DT)
				
				union all 

				SELECT 
					datepart(DW,t.CreateDate) AS 'PERIOD',
					'TwoHourProcessing' AS FUNCTION_NAME_TX,
					'MP: IDR' AS FUNCTION_QUALIFIER_1_TX,
					count(*) AS PL_COUNT,
					AVG(NULLIF(convert(DECIMAL,datediff(MILLISECOND, t.CreateDate, CompletedDate)),0)) as AVERAGE_MS,				
					CAST(SUM (CASE WHEN  NULLIF(convert(DECIMAL,datediff(MILLISECOND, t.CreateDate,CompletedDate)),0) <= 7200000 then 1 else 0 END ) *100 / COUNT(*)  AS DECIMAL(100)) as PER_THREE,
					0 AS PER_SEVEN
				FROM #IDR_EDI_Results t
				WHERE t.type_cd = 'IDR_TP'
				group by
					datepart(DW,t.CreateDate)

				union all 

				SELECT 
					datepart(DW,t.CreateDate) AS 'PERIOD',
					'TwoHourProcessing' AS FUNCTION_NAME_TX,
					'MP: EDI' AS FUNCTION_QUALIFIER_1_TX,
					count(*) AS PL_COUNT,
					AVG(NULLIF(convert(DECIMAL,datediff(MILLISECOND, t.CreateDate, CompletedDate)),0)) as AVERAGE_MS,				
					CAST(SUM (CASE WHEN  NULLIF(convert(DECIMAL,datediff(MILLISECOND, t.CreateDate,CompletedDate)),0) <= 7200000 then 1 else 0 END ) *100 / COUNT(*)  AS DECIMAL(100)) as PER_THREE,
					0 AS PER_SEVEN
				FROM #IDR_EDI_Results t
				WHERE t.type_cd = 'EDI_TP'
				group by
					datepart(DW,t.CreateDate)

				union all 

				SELECT 
					datepart(DW,t.CreateDate) AS 'PERIOD',
					'TwoHourProcessing' AS FUNCTION_NAME_TX,
					'Message Processing' AS FUNCTION_QUALIFIER_1_TX,
					count(*) AS PL_COUNT,
					AVG(NULLIF(convert(DECIMAL,datediff(MILLISECOND, t.CreateDate, CompletedDate)),0)) as AVERAGE_MS,					
					CAST(SUM (CASE WHEN  NULLIF(convert(DECIMAL,datediff(MILLISECOND, t.CreateDate,CompletedDate)),0) <= 7200000 then 1 else 0 END ) *100 / COUNT(*)  AS DECIMAL(100)) as PER_THREE,
					0 AS PER_SEVEN
				FROM #LFPResults t
				group by
					datepart(DW,t.CreateDate)

				union all 

				SELECT 
					datepart(DW,t.CreateDate) AS 'PERIOD',
					'48HourProcessing' AS FUNCTION_NAME_TX,
					'4 Hour Message Processing' AS FUNCTION_QUALIFIER_1_TX,
					count(*) AS PL_COUNT,
					AVG(NULLIF(convert(DECIMAL,datediff(MILLISECOND, t.CreateDate, CompletedDate)),0)) as AVERAGE_MS,					
					CAST(SUM (CASE WHEN  NULLIF(convert(DECIMAL,datediff(MILLISECOND, t.CreateDate,CompletedDate)),0) <= 14400000 then 1 else 0 END ) *100 / COUNT(*)  AS DECIMAL(100)) as PER_THREE,
					0 AS PER_SEVEN
				FROM #48Results t
				group by
					datepart(DW,t.CreateDate)

				union all 

				SELECT 
					datepart(DW,t.CreateDate) AS 'PERIOD',
					'48HourProcessing' AS FUNCTION_NAME_TX,
					'8 Hour Message Processing' AS FUNCTION_QUALIFIER_1_TX,
					count(*) AS PL_COUNT,
					AVG(NULLIF(convert(DECIMAL,datediff(MILLISECOND, t.CreateDate, CompletedDate)),0)) as AVERAGE_MS,				
					CAST(SUM (CASE WHEN  NULLIF(convert(DECIMAL,datediff(MILLISECOND, t.CreateDate,CompletedDate)),0) <= 28800000 then 1 else 0 END ) *100 / COUNT(*)  AS DECIMAL(100)) AS PER_THREE,
					0 AS PER_SEVEN
				FROM #48Results t
				group by
					datepart(DW,t.CreateDate)

				union all 

				SELECT 
					datepart(DW,t.StartDate) AS 'PERIOD',
					'MP' AS FUNCTION_NAME_TX,
					'Outbound GL' AS FUNCTION_QUALIFIER_1_TX,
					count(*) AS PL_COUNT,
					AVG(NULLIF(convert(DECIMAL,datediff(MILLISECOND, t.StartDate,t.EndDate)),0)) as AVERAGE_MS,		
					CAST(SUM (CASE WHEN NULLIF(convert(DECIMAL,datediff(MILLISECOND, t.StartDate,t.EndDate)),0) <= 1800000   then 1 else 0 END ) *100 / COUNT(*)  AS DECIMAL(100)) AS PER_THREE,
					0 AS PER_SEVEN
				FROM #tmpOutboundGL t
				group by
					datepart(DW,t.StartDate)

				union all 

				SELECT 
					datepart(DW,t.StartDate) AS 'PERIOD',
					'MP' AS FUNCTION_NAME_TX,
					'Insurance Backfeed' AS FUNCTION_QUALIFIER_1_TX,
					count(*) AS PL_COUNT,
					AVG(NULLIF(convert(DECIMAL,datediff(MILLISECOND, t.StartDate,t.EndDate)),0)) as AVERAGE_MS,				
					CAST(SUM (CASE WHEN NULLIF(convert(DECIMAL,datediff(MILLISECOND, t.StartDate,t.EndDate)),0) <= 1800000   then 1 else 0 END ) *100 / COUNT(*)  AS DECIMAL(100)) AS PER_THREE,
					0 AS PER_SEVEN
				FROM #tmpInsBackFeed t
				group by
					datepart(DW,t.StartDate)

				union all 

				SELECT 
					datepart(DW,t.StartDate) AS 'PERIOD',
					'MP' AS FUNCTION_NAME_TX,
					'EOM' AS FUNCTION_QUALIFIER_1_TX,
					count(*) AS PL_COUNT,
					AVG(NULLIF(convert(DECIMAL,datediff(MILLISECOND, t.StartDate,t.EndDate)),0)) as AVERAGE_MS,						
					CAST(SUM (CASE WHEN NULLIF(convert(DECIMAL,datediff(MILLISECOND, t.StartDate,t.EndDate)),0) <= 3600000   then 1 else 0 END ) *100 / COUNT(*)  AS DECIMAL(100)) AS PER_THREE,
					0 AS PER_SEVEN
				FROM #tmpEOMMP t
				group by
					datepart(DW,t.StartDate)
				)vPerfLog
				on	vPerfLog.FUNCTION_NAME_TX		= PerformanceLogFunction.method_tx
								and vPerfLog.FUNCTION_QUALIFIER_1_TX	= PerformanceLogFunction.cs_uri_stem_tx
								and vPerfLog.PERIOD			= DimTime.number
			)newtb




select 
			   dt.Daily,
			   dt.WEEK_DAY,
			   dt.Release,
			   dt.TRANSACTION_GROUP_NAME_TX,
			   dt.Transaction_name_tx, 
			   dt.TIER_NO,
			   dt.FUNCTION_NAME_TX,
			   dt.FUNCTION_QUALIFIER_1_TX,
			   dt.PL_COUNT,
			   dt.AVERAGE_MS,
			   CASE
					WHEN dt.TIER_NO = 3
					THEN dt.PER_SEVEN
					ELSE dt.PER_THREE
			   END AS SLA_PER
, tgc.SEQUENCE_NO from #datatemp dt
join OperationalDashboard.dbo.TRANSACTION_GROUP_CONFIG tgc
on dt.TRANSACTION_GROUP_NAME_TX = tgc.TRANSACTION_GROUP_NAME_TX
where tgc.PURGE_DT is null and tgc.APPLICATION_NAME_TX = 'Unitrac'
AND dt.TRANSACTION_GROUP_NAME_TX != 'Backoffice Processes'

UNION ALL
select 
			   dt.Daily,
			   dt.WEEK_DAY,
			   dt.Release,
			   dt.TRANSACTION_GROUP_NAME_TX,
			   dt.Transaction_name_tx, 
			   dt.TIER_NO,
			   dt.FUNCTION_NAME_TX,
			   dt.FUNCTION_QUALIFIER_1_TX,
			   dt.PL_COUNT,
			   dt.AVERAGE_MS,
			   dt.PER_THREE AS SLA_PER
, tgc.SEQUENCE_NO from #datatemp dt
join OperationalDashboard.dbo.TRANSACTION_GROUP_CONFIG tgc
on dt.TRANSACTION_GROUP_NAME_TX = tgc.TRANSACTION_GROUP_NAME_TX
where tgc.PURGE_DT is null and tgc.APPLICATION_NAME_TX = 'Unitrac'
AND dt.TRANSACTION_GROUP_NAME_TX = 'Backoffice Processes'
end
