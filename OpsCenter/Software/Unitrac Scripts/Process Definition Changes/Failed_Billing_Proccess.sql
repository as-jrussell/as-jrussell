USE UniTrac

--drop table #Temp1
select pd.ID as PDId, MAX(pl.id) as PLId
INTO #Temp1
FROM PROCESS_DEFINITION pd
INNER JOIN PROCESS_LOG pl ON pl.PROCESS_DEFINITION_ID = pd.ID
	AND pl.PURGE_DT IS NULL
	AND	CAST(pl.CREATE_DT AS DATE) > CAST(GETDATE() AS DATE)
	AND pl.STATUS_CD != 'RESET'
WHERE
pd.PROCESS_TYPE_CD = 'BILLING'
AND pd.STATUS_CD != 'InProcess'
AND CAST(pd.LAST_RUN_DT AS DATE) > CAST(GETDATE() AS DATE)
--AND pd.ID = 137840
GROUP BY pd.ID
ORDER BY pd.ID

--select 't1',* from #Temp1

--drop table #Temp2

SELECT pli.PROCESS_LOG_ID AS PLId
INTO #Temp2
FROM PROCESS_LOG_ITEM pli
INNER JOIN #Temp1 t1 ON t1.PLId = pli.PROCESS_LOG_ID
WHERE
pli.PURGE_DT IS NULL

--select * from #Temp2



--drop table #Temp3

SELECT pd.ID AS PDId, pl.ID AS PLId, pl.STATUS_CD PLStatus_Cd, pd.OVERRIDE_DT AS PDOverrideDt, 
settings_xml_im.value ('(//ProcessDefinitionSettings/OriginatorWorkItemId)[1]', 'varchar(50)') AS CycleWorkItem,
pd.* 
INTO #Temp3
FROM #Temp1 t1
INNER JOIN PROCESS_DEFINITION pd ON pd.ID = t1.PDId
INNER JOIN PROCESS_LOG pl ON pl.ID = t1.PLId
WHERE
t1.PLId NOT IN (SELECT PLId FROM #Temp2)

--select * from #Temp3
--The following step takes those Billing Process Definitions that resulted
-- in no process log items and looks to see if they got realted to another Billing Work Item
--drop table #Temp4
SELECT List.Col AS CycleWorkItem
INTO #Temp4
FROM work_item_action wia
INNER JOIN work_item wi ON wi.id = wia.work_item_id
	AND wi.relate_type_cd = 'Allied.UniTrac.BillingGroup'
INNER JOIN
    	(
    		SELECT	t3.CycleWorkItem AS Col FROM #Temp3 t3
    	) List ON wia.action_note_tx LIKE '%'+List.Col+'%'

CREATE TABLE #TMP_PDId (
		PD_ID BIGINT
	)

INSERT INTO #TMP_PDId
SELECT t3.PDId FROM #Temp3 t3
WHERE
t3.CycleWorkItem NOT IN (SELECT t4.CycleWorkItem FROM #Temp4 t4)


INSERT INTO #TMP_PDId
SELECT pd.ID AS PDId--, pl.ID as PLId, pl.STATUS_CD PLStatus_Cd, pd.OVERRIDE_DT as PDOverrideDt, pli.ID as PLIId, pli.*
FROM PROCESS_DEFINITION pd
INNER JOIN PROCESS_LOG pl ON pl.PROCESS_DEFINITION_ID = pd.ID
	AND CAST(pl.CREATE_DT AS DATE) > CAST(GETDATE() AS DATE)
	AND pl.PURGE_DT IS NULL
INNER JOIN #Temp1 t1 ON t1.PLId = pl.ID
INNER JOIN PROCESS_LOG_ITEM pli ON pli.PROCESS_LOG_ID = pl.ID
	AND pli.PURGE_DT IS NULL
	AND pli.STATUS_CD = 'ERR'
	AND pli.RELATE_TYPE_CD = 'Allied.UniTrac.BillingGroup'
WHERE
pd.PROCESS_TYPE_CD = 'BILLING'
AND pd.STATUS_CD != 'InProcess'
AND CAST(pd.LAST_RUN_DT AS DATE) > CAST(GETDATE() AS DATE)

--drop table #Temp5
SELECT DISTINCT(pd.ID) 
INTO #Temp5
FROM BILLING_GROUP bg
INNER JOIN PROCESS_LOG_ITEM pli ON pli.RELATE_ID = bg.ID
	AND pli.RELATE_TYPE_CD = 'Allied.UniTrac.BillingGroup'
	AND pli.PURGE_DT IS NULL
INNER JOIN PROCESS_LOG pl ON pl.ID = pli.PROCESS_LOG_ID
	AND pli.PURGE_DT IS NULL
INNER JOIN PROCESS_DEFINITION pd ON pd.ID = pl.PROCESS_DEFINITION_ID
INNER JOIN #Temp1 t1 ON t1.PLId = pl.ID
WHERE CAST(bg.CREATE_DT AS DATE) > CAST(GETDATE() AS DATE) AND bg.TYPE_CD = 'PEND'

INSERT INTO #TMP_PDId
SELECT pd.ID AS PDId--, pl.ID as PLId, pl.STATUS_CD PLStatus_Cd, pd.OVERRIDE_DT as PDOverrideDt
FROM PROCESS_DEFINITION pd
INNER JOIN PROCESS_LOG pl ON pl.PROCESS_DEFINITION_ID = pd.ID
INNER JOIN #Temp5 t5 ON t5.ID = pd.ID
WHERE pd.DESCRIPTION_TX = 'REGENERATE'

SELECT * FROM #TMP_PDId
