SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





create  PROCEDURE [dbo].[UT_DailyUTL]


as

SET NOCOUNT ON

SELECT

pd.id AS pd_id

,pd.name_tx AS pd_name_tx

,

-- pd.SETTINGS_XML_IM,

t1.nodevalues.value('.', 'nvarchar(30)') AS pd_lender_id

,l.name_tx

,l.code_tx

,l.LAST_SYNC_DT

,(SELECT

COUNT(q.id)

FROM loan q

WHERE q.lender_id = l.id

AND q.evaluation_dt > '1900-01-01'

AND q.evaluation_dt < l.last_sync_dt

AND q.purge_dt IS NULL)

AS cnt_pend_rematch

,(SELECT

DATEDIFF(DAY, MIN(q.evaluation_dt), GETDATE())

FROM loan q

WHERE q.lender_id = l.id

AND q.evaluation_dt > '1900-01-01'

AND q.evaluation_dt < l.last_sync_dt

AND q.purge_dt IS NULL)

AS days_pend_rematch_now

,(SELECT

DATEDIFF(DAY, MIN(q.evaluation_dt), l.last_sync_dt)

FROM loan q

WHERE q.lender_id = l.id

AND q.evaluation_dt > '1900-01-01'

AND q.evaluation_dt < l.last_sync_dt

AND q.purge_dt IS NULL)

AS days_pend_rematch_last_sync

,(SELECT

COUNT(q.id)

FROM loan q

WHERE q.lender_id = l.id

AND CAST(q.EVALUATION_DT AS DATE) = (SELECT

CAST(MIN(qq.evaluation_dt) AS DATE)

FROM loan qq

WHERE qq.lender_id = l.id

AND qq.EVALUATION_DT > '1900-01-01'

AND qq.EVALUATION_DT < l.last_sync_dt

AND qq.purge_dt IS NULL)

AND q.evaluation_dt > '1900-01-01'

AND q.evaluation_dt < l.last_sync_dt

AND q.purge_dt IS NULL)

AS cnt_oldest_date

,(SELECT

MAX(q.EVALUATION_DT)

FROM loan q

WHERE q.lender_id = l.id

AND q.evaluation_dt > '1900-01-01'

AND q.purge_dt IS NULL

AND q.EVALUATION_DT < '12/31/9999')

AS last_evaluation_date INTO #specificlenders

FROM process_definition pd

CROSS APPLY SETTINGS_XML_IM.nodes('/ProcessDefinitionSettings/LenderList/LenderID') AS t1 (nodevalues)

LEFT OUTER JOIN LENDER l

ON l.CODE_TX = t1.nodevalues.value('.', 'nvarchar(10)')

AND l.PURGE_DT IS NULL

AND l.ENABLE_MATCHING_IN = 'Y'

AND l.NAME_TX IS NOT NULL

WHERE pd.PROCESS_TYPE_CD = 'UTL20REMAT'

AND pd.ACTIVE_IN = 'Y'

ORDER BY 1, 9 DESC

SELECT

(SELECT

id

FROM process_definition

WHERE id = 9)

AS pd_id

,(SELECT

name_tx

FROM process_definition

WHERE id = 9)

AS pd_name_tx

,

-- pd.SETTINGS_XML_IM,

'' AS pd_lender_id

,l.name_tx

,l.code_tx

,l.LAST_SYNC_DT

,(SELECT

COUNT(q.id)

FROM loan q

WHERE q.lender_id = l.id

AND q.evaluation_dt > '1900-01-01'

AND q.evaluation_dt < l.last_sync_dt

AND q.purge_dt IS NULL)

AS cnt_pend_rematch

,(SELECT

DATEDIFF(DAY, MIN(q.evaluation_dt), GETDATE())

FROM loan q

WHERE q.lender_id = l.id

AND q.evaluation_dt > '1900-01-01'

AND q.evaluation_dt < l.last_sync_dt

AND q.purge_dt IS NULL)

AS days_pend_rematch_now

,(SELECT

DATEDIFF(DAY, MIN(q.evaluation_dt), l.last_sync_dt)

FROM loan q

WHERE q.lender_id = l.id

AND q.evaluation_dt > '1900-01-01'

AND q.evaluation_dt < l.last_sync_dt

AND q.purge_dt IS NULL)

AS days_pend_rematch_last_sync

,(SELECT

COUNT(q.id)

FROM loan q

WHERE q.lender_id = l.id

AND CAST(q.EVALUATION_DT AS DATE) = (SELECT

CAST(MIN(qq.evaluation_dt) AS DATE)

FROM loan qq

WHERE qq.lender_id = l.id

AND qq.EVALUATION_DT > '1900-01-01'

AND qq.EVALUATION_DT < l.last_sync_dt

AND qq.purge_dt IS NULL)

AND q.evaluation_dt > '1900-01-01'

AND q.evaluation_dt < l.last_sync_dt

AND q.purge_dt IS NULL)

AS cnt_oldest_date

,(SELECT

MAX(q.EVALUATION_DT)

FROM loan q

WHERE q.lender_id = l.id

AND q.evaluation_dt > '1900-01-01'

AND q.purge_dt IS NULL

AND q.EVALUATION_DT < '12/31/9999')

AS last_evaluation_date INTO #defaultlenders

FROM LENDER l

WHERE l.code_tx NOT IN (SELECT

pd_lender_id

FROM #specificlenders)

AND l.PURGE_DT IS NULL

AND l.ENABLE_MATCHING_IN = 'Y'

ORDER BY 1, 9 DESC

SELECT

*

FROM #specificlenders

UNION ALL

SELECT

*

FROM #defaultlenders

ORDER BY 1, 9 DESC
GO
