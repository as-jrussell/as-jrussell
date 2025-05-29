USE UniTrac	



SELECT  RC.* FROM LOAN L
INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
INNER JOIN REQUIRED_COVERAGE RC ON P.ID = RC.PROPERTY_ID
INNER JOIN OWNER_LOAN_RELATE OL ON L.ID = OL.LOAN_ID
INNER JOIN OWNER O ON OL.OWNER_ID = O.ID
INNER JOIN OWNER_ADDRESS OA ON O.ADDRESS_ID = OA.ID
JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID 
WHERE LL.CODE_TX = '2164' AND L.NUMBER_TX = '9702821'






SELECT TOP 10    l.NUMBER_TX, dc.CREATE_DT, fpc.* FROM dbo.DOCUMENT_CONTAINER DC
JOIN dbo.FORCE_PLACED_CERTIFICATE FPC ON FPC.ID= DC.RELATE_ID AND DC.RELATE_CLASS_NAME_TX = 'Allied.UniTrac.ForcePlacedCertificate'
JOIN dbo.LOAN L ON FPC.LOAN_ID = L.ID
JOIN dbo.COLLATERAL C ON C.LOAN_ID = L.ID
JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID 
WHERE LL.CODE_TX = '2164'  AND fpc.id NOT IN  (5657167,6050689,5680878)AND 
TEMPLATE_ID = '111' AND COVER_LETTER_TEMPLATE_ID = '39'
AND MASTER_POLICY_ID = '3177' AND MASTER_POLICY_ASSIGNMENT_ID = '11896' AND FPC.STATUS_CD = 'F'
--AND FPC.ACTIVE_IN = 'Y' --AND BILL_CD = 'NRML'-- 
--AND BILLING_STATUS_CD = 'CLSD' AND l.BALANCE_TYPE_CD = '' AND PAYMENT_FREQUENCY_CD = '' AND DEALER_CODE_TX IS NULL
--AND DEPARTMENT_CODE_TX IS NULL AND SERVICECENTER_CODE_TX IS NULL AND CONTRACT_TYPE_CD IS NULL AND NOTE_TX IS NULL
--AND l.FIELD_PROTECTION_XML IS NULL 
 

 --AND RELATE_ID IN (5927777, 5943518)
ORDER BY fpc.UPDATE_DT DESC


--UPDATE fpc
--SET  PDF_GENERATE_CD = FPX.PDF_GENERATE_CD, UPDATE_DT = GETDATE(), FPC.LOCK_ID = FPX.Lock_ID, pir_dt =FPX.pir_dt,
--UPDATE_USER_TX = 'INC0275615', BILL_CD = FPX.BILL_CD, quick_issue_in = fpx.quick_issue_in
----SELECT FPC.PDF_GENERATE_CD, FPC.QUICK_ISSUE_IN,*
--FROM dbo.FORCE_PLACED_CERTIFICATE FPC
--JOIN  UniTracHDStorage..INC0275615_FPC FPX ON FPX.ID = FPC.ID 
--WHERE FPC.ID IN (5943518)

 SELECT * FROM dbo.PROCESS_DEFINITION
 WHERE NAME_TX LIKE '%dash%'



 SELECT * FROM dbo.PROCESS_LOG
 WHERE PROCESS_DEFINITION_ID = '144381' AND UPDATE_DT >= '2016-12-12 '


 

SELECT MASTER_POLICY_ID, * FROM 
 dbo.FORCE_PLACED_CERTIFICATE FPC --ON FPC.ID= DC.RELATE_ID AND DC.RELATE_CLASS_NAME_TX = 'Allied.UniTrac.ForcePlacedCertificate'
JOIN dbo.LOAN L ON FPC.LOAN_ID = L.ID
JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID 
WHERE --LL.CODE_TX = '2164' AND
 FPC.ID IN (5927777, 5943518)

 SELECT * FROM dbo.MASTER_POLICY_ASSIGNMENT
 WHERE MASTER_POLICY_ID = '3177'
 AND ID = '11896'

 SELECT * FROM dbo.LENDER_ORGANIZATION
 WHERE ID = '3097'

 SELECT * FROM dbo.MASTER_POLICY_ENDORSEMENT
 WHERE MASTER_POLICY_ASSIGNMENT_ID IN (11892,11893,11894,11895,11896,11897,11898)


 SELECT * FROM dbo.CARRIER
 WHERE ID = '8'

 SELECT * FROM dbo.CARRIER_PRODUCT
 WHERE ID = '8'

 SELECT * FROM dbo.CARRIER_POLICY_NUMBER_RANGE
 WHERE CARRIER_PRODUCT_ID = 
'8'

SELECT * FROM dbo.ISSUE_PROCEDURE
WHERE ID = '1172'

SELECT * FROM dbo.CANCEL_PROCEDURE
WHERE ID = '131'

--PHN0042667
--PHN0042900
 SELECT * FROM dbo.ISSUE_PROCEDURE
WHERE ID IN (1136,1135,1173,1186,1172)



SELECT L.RECORD_TYPE_CD, P.RECORD_TYPE_CD, RC.RECORD_TYPE_CD,p.id, RC.*
--INTO UniTracHDStorage..INC0275615_FPC
FROM dbo.LOAN L
JOIN dbo.FORCE_PLACED_CERTIFICATE FPC ON FPC.LOAN_ID = L.ID
JOIN dbo.COLLATERAL C ON C.LOAN_ID = L.ID
JOIN dbo.PROPERTY P ON P.ID = C.PROPERTY_ID
JOIN dbo.REQUIRED_COVERAGE RC ON RC.PROPERTY_ID = P.ID
JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID 
WHERE LL.CODE_TX = '2164' AND L.NUMBER_TX = '9696446'

'9702821'


SELECT * FROM dbo.INTERACTION_HISTORY
WHERE PROPERTY_ID = '3763459'

'143311901'

USE UniTrac
SELECT * FROM dbo.CPI_ACTIVITY
WHERE CPI_QUOTE_ID IN (36159459, 37414193)
--2016-06-29 01:40:49.0630000

SELECT * FROM dbo.REF_CODE
WHERE DOMAIN_CD = 'ForcePlacedCertificateBill'


SELECT * FROM dbo.REF_CODE
WHERE DOMAIN_CD = 'CPIActivityIssueReason'




SELECT * FROM dbo.PROCESS_LOG
WHERE ID = '40366364'





exec GetRefDomainsDeep @domain=N'DashboardWidget'


DECLARE @domain NVARCHAR(255)
SET @domain = 'DashboardWidget'

SELECT *
from REF_DOMAIN d
      left outer join REF_CODE c on d.DOMAIN_CD = c.DOMAIN_CD
                                and c.PURGE_DT is null 
      left outer join REF_CODE_ATTRIBUTE ca on c.DOMAIN_CD = ca.DOMAIN_CD
                                           and c.CODE_CD = ca.REF_CD
                                           and ca.PURGE_DT is null 
   where (@domain = '' or d.DOMAIN_CD = @domain)
      and d.PURGE_DT is null
	order by d.domain_cd, c.code_cd, ca.attribute_cd



select *FROM Unitrac_DW.dbo.DASH_CACHE where NAME_TX = 'LENDERS_LN_COUNT'


select top 10
                ASSOC_NAME_TX as LenderName, sum(COUNT_NO) as 'CountNo',
           
		   
		   
		
 *    from Unitrac_DW.dbo.DASH_CACHE where NAME_TX = 'LENDERS_LN_COUNT'
               and SOURCE_CD in ('4','10','99')
          



		  select count(DISTINCT ASSOC_NAME_TX)  as 'COUNT'
            from Unitrac_DW.dbo.DASH_CACHE where NAME_TX = 'CYCLE_DELAY'
               and RECORD_MONTH > 1



SELECT * FROM dbo.PROCESS_DEFINITION
WHERE NAME_TX LIKE '%dash%'



SELECT * FROM dbo.PROCESS_LOG
WHERE PROCESS_DEFINITION_ID = '144381'
AND UPDATE_DT >= '2016-12-14 '



SELECT * FROM dbo.PROCESS_LOG
WHERE PROCESS_DEFINITION_ID = '144381'
AND UPDATE_DT >= '2016-11-25 ' AND UPDATE_DT <= '2016-12-02 '
AND MSG_TX = 'Total WorkItems processed: 21'





SELECT * FROM dbo.PROCESS_LOG
WHERE PROCESS_DEFINITION_ID = '144381'
AND UPDATE_DT >= '2016-12-05 ' AND UPDATE_DT <= '2016-12-14 '

SELECT * FROM dbo.WORK_ITEM WI
JOIN dbo.REQUIRED_COVERAGE RC ON RC.ID = WI.RELATE_ID AND WI.WORKFLOW_DEFINITION_ID = '3'
JOIN dbo.COLLATERAL C ON C.PROPERTY_ID = RC.PROPERTY_ID
JOIN dbo.LOAN L ON L.ID = C.LOAN_ID





SELECT * FROM dbo.WORK_ITEM WI
JOIN dbo.LENDER L ON L.ID = WI.LENDER_ID
WHERE L.CODE_TX = '4422'
AND WI.STATUS_CD = 'Initial'



SELECT t.rank as RANK, COUNT(*) as COUNT
            FROM
            (  select mc.ASSOC_CD, mc.ASSOC_NAME_TX,
                  replace(convert(varchar(20), CAST(SUM(mc.COUNT_NO) AS MONEY), 1), '.00', '') as total_UTL_count, 
                  replace(convert(varchar(20), CAST(SUM(ntmc.no_touch_count) AS MONEY), 1), '.00', '') as no_touch_count,
                  replace(convert(varchar(20), CAST(SUM(tmc.touch_count) AS MONEY), 1), '.00', '') as touch_count,
                  cast((cast(SUM(ntmc.no_touch_count) as decimal)/cast(SUM(mc.COUNT_NO) as decimal)) as decimal(10,5))*100 as percent_no_touch,
                  cast((cast(SUM(tmc.touch_count) as decimal)/cast(SUM(mc.COUNT_NO) as decimal)) as decimal(10,5))*100 as percent_touch,
                  CASE 
                     WHEN cast((cast(SUM(ntmc.no_touch_count) as decimal)/cast(SUM(mc.COUNT_NO) as decimal)) as decimal(10,5))*100 >= 90.00000 THEN '90-100%'
                     WHEN cast((cast(SUM(ntmc.no_touch_count) as decimal)/cast(SUM(mc.COUNT_NO) as decimal)) as decimal(10,5))*100 < 90.00000 AND
                        cast((cast(SUM(ntmc.no_touch_count) as decimal)/cast(SUM(mc.COUNT_NO) as decimal)) as decimal(10,5))*100 >= 50.00000 THEN '50-89%'
                     WHEN cast((cast(SUM(ntmc.no_touch_count) as decimal)/cast(SUM(mc.COUNT_NO) as decimal)) as decimal(10,5))*100 < 50.00000 THEN '0-49%'
                     ELSE '0-49%'
                  END AS 'RANK'
                  from Unitrac_DW.dbo.DASH_CACHE mc
               cross apply 
               (  select SUM(t.COUNT_NO) as no_touch_count
                  from Unitrac_DW.dbo.DASH_CACHE t
                  where (t.ASSOC_CD = mc.ASSOC_CD) and
                     --(t.STATUS_CD = mc.STATUS_CD or (t.STATUS_CD is null and mc.STATUS_CD is null)) and
                     (t.RESULT_CD = mc.RESULT_CD or (t.RESULT_CD is null and mc.RESULT_CD is null)) and 
                     t.TYPE_CD = mc.TYPE_CD and 
                     (T.RESULT_CD IS NULL OR t.RESULT_CD in ('EXACT')) and
                     t.NAME_TX = 'UTL_TOUCHCOUNTS'
               ) ntmc
               cross apply
               (  select 
                     SUM(t.COUNT_NO) as touch_count
                  from Unitrac_DW.dbo.DASH_CACHE t
                  where t.ASSOC_CD = mc.ASSOC_CD and
                     --t.STATUS_CD = mc.STATUS_CD and 
                     t.RESULT_CD = mc.RESULT_CD and 
                     t.TYPE_CD = mc.TYPE_CD and 
                     t.RESULT_CD in ('EXACTRVW', 'INXCTLOW','INXCTHIGH') and
					      t.NAME_TX = 'UTL_TOUCHCOUNTS'
               ) tmc
               WHERE mc.NAME_TX = 'UTL_TOUCHCOUNTS'
               GROUP BY mc.ASSOC_CD, mc.ASSOC_NAME_TX
            ) t
            WHERE t.RANK is not null
            GROUP BY t.RANK
            ORDER BY t.RANK DESC
            

			SELECT * FROM dbo.PROCESS_DEFINITION
			WHERE ID IN (317277, 317276, 317275)



			SELECT * FROM dbo.PROCESS_LOG
WHERE PROCESS_DEFINITION_ID  IN (317277, 317276, 317275)
AND UPDATE_DT >= '2016-12-01 'AND UPDATE_DT >= '2016-11-01 '
ORDER BY PROCESS_DEFINITION_ID ASC 



--RPC:Completed	exec SaveProcessLog @ID=40387398,@PROCESS_DEFINITION_ID=144381,@STATUS_CD='Complete',@MSG_TX='Total WorkItems processed: 21',@UPDATE_USER_TX='DashUsr',@lockId=2	.Net SqlClient Data Provider		UTdbInternalDashWinServiceProd	0	7	0	0	6512	107	2016-12-14 12:34:09.187	2016-12-14 12:34:09.187	0X00000000070000001C005300610076006500500072006F0063006500730073004C006F0067002600000014000C007F1062006900670069006E007400060040004900440046436802000000004C0000	


--utdbinternaldashwinserviceprod

USE UniTrac_DW
exec UniTrac..DashboardCacheRefresh @CacheDBName = N'', -- nvarchar(30)
    @CacheTableName = N'', -- nvarchar(30)
    @CacheName = N'' -- nvarchar(30)
DashboardCacheRefresh @CacheName='DASH_CACHE' ,@CacheDBName = 'Unitrac_DW'



USE UniTrac


SELECT * FROM dbo.WORK_ITEM
WHERE RELATE_ID IN 


UPDATE dbo.MESSAGE
SET PURGE_DT = GETDATE(), LOCK_ID = LOCK_ID+1, RECEIVED_STATUS_CD = 'ERR'
--SELECT * FROM dbo.MESSAGE
WHERE id IN (6523738 , 6523739 )



SELECT * FROM dbo.PROCESS_DEFINITION
WHERE ID = '413469'


SELECT * FROM dbo.PROCESS_LOG
WHERE PROCESS_DEFINITION_ID = '413469'

SELECT * FROM dbo.PROCESS_LOG
WHERE id = '40345316'


SELECT * FROM dbo.WORK_ITEM
WHERE RELATE_ID = '1585140' AND WORKFLOW_DEFINITION_ID = '10'




USE UniTrac
SELECT * FROM dbo.OUTPUT_BATCH
WHERE ID = '1155697'


SELECT * FROM dbo.PROCESS_LOG_ITEM
WHERE PROCESS_LOG_ID = 40375053
AND RELATE_TYPE_CD LIKE '%batch%'


 SELECT *  FROM dbo.OUTPUT_BATCH WHERE STATUS_CD = 'ERR' AND CAST(UPDATE_DT AS DATE) >= CAST(GETDATE() AS DATE)
   AND EXTERNAL_ID not LIKE 'RPT%'




   SELECT * FROM dbo.PROCESS_DEFINITION
   WHERE NAME_TX LIKE '%6155%' AND PROCESS_TYPE_CD = 'CYCLEPRC'
   AND ACTIVE_IN = 'Y'


   SELECT * FROM dbo.PROCESS_LOG
   WHERE PROCESS_DEFINITION_ID IN (14150,14151)
   AND CAST(UPDATE_DT AS DATE) >= CAST(GETDATE()-5 AS DATE)


   SELECT RELATE_ID INTO #tmp FROM dbo.PROCESS_LOG_ITEM
   WHERE RELATE_TYPE_CD LIKE '%reporthistory' AND PROCESS_LOG_ID IN (40256045, 40256362) 


   SELECT * 
   INTO UniTracHDStorage..INC0276323
   FROM dbo.REPORT_HISTORY
   WHERE ID IN (SELECT * FROM #tmp) AND REPORT_ID = '58'


      SELECT * FROM dbo.REPORT
	  WHERE NAME_TX LIKE 'Payment%'



UPDATE  [UniTrac].[dbo].[REPORT_HISTORY]
SET     STATUS_CD = 'PEND' ,
        RETRY_COUNT_NO = 0 ,
        MSG_LOG_TX = NULL ,
        RECORD_COUNT_NO = 2 ,
        ELAPSED_RUNTIME_NO = 0, DOCUMENT_CONTAINER_ID = NULL,
		UPDATE_DT = GETDATE()
--	, REPORT_DATA_XML = ''
--		,REPORT_ID = '27'
--SELECT * FROM dbo.REPORT_HISTORY
WHERE   ID IN (SELECT * FROM #tmp) AND REPORT_ID = '58'



SELECT DISTINCT  sa.name, sj.name, sj.description FROM msdb.dbo.sysjobs sj
JOIN msdb.dbo.sysjobschedules sjs ON sjs.job_id = sj.job_id
JOIN msdb.dbo.sysschedules sa ON sa.schedule_id = sjs.schedule_id
WHERE sj.date_created > '2016-04-18 '



SELECT * FROM msdb.dbo.sysschedules



SELECT * FROM dbo.PROCESS_LOG
WHERE ID = '40418574'

SELECT * FROM dbo.PROCESS_LOG_ITEM
WHERE PROCESS_LOG_ID = '40418574'


SELECT * FROM dbo.OUTPUT_BATCH
WHERE PROCESS_LOG_ID = '40418574'


SELECT * FROM dbo.OUTPUT_BATCH