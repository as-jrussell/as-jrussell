SELECT * FROM dbo.REPORT

WHERE DESCRIPTION_TX LIKE '%Billing%'


SELECT * FROM dbo.REPORT_CONFIG
WHERE CODE_TX like '%28DAYDELAY%'

SELECT  *
FROM    dbo.REPORT_CONFIG
WHERE   REPORT_ID IN ( 35, 47, 55, 57, 80 )



SELECT * FROM dbo.LENDER
WHERE CODE_TX = '8500'
--ID 421
--ID 92

SELECT  *
FROM    dbo.REPORT_HISTORY
WHERE   REPORT_ID = 35
        AND STATUS_CD = 'COMP'
        AND DOCUMENT_CONTAINER_ID IS NOT NULL
        AND UPDATE_DT > '2015-01-01'
        


		SELECT * FROM dbo.REPORT_HISTORY
		WHERE ID = '7831594'

		SELECT  *
FROM    dbo.REPORT_HISTORY
WHERE   REPORT_ID = 35 AND LENDER_ID = 421


		EXEC dbo.Report_BillingStatements @LenderCode = N'1727', -- nvarchar(10)
		    @Branch = N'1727', -- nvarchar(max)
		    @Division = N'4', -- nvarchar(10)
		    @Coverage = N'PHYS-DAMAGE', -- nvarchar(100)
		    @ReportType = N'ECHGBILL', -- nvarchar(50)
		    @ReportConfig = '675', -- varchar(50)
		    @GroupByCode = N'B/D/C', -- nvarchar(50)
		    @SortByCode = N'BorrowerName', -- nvarchar(50)
		    @FilterByCode = N'Bill', -- nvarchar(50)
		    @Report_History_ID = 0, -- bigint
		    @BillingGroupID = 1379823 -- bigint
		
		SELECT * FROM dbo.REF_CODE
		WHERE MEANING_TX LIKE '%reporttype%'

		exec Report_LenderITD @LenderCode=N'2301',@Division=N'3',@Coverage=N'',@ReportType=N'LEND_ITD',@ReportConfig=N'528' 
		
EXEC dbo.Report_BillingStatements @LenderCode = N'1727', @Branch = N'1727',@Division = N'4', @Coverage = N'',@ReportType = N'ECHGBILL', @ReportConfig = '675', @GroupByCode = N'B/D/C', @SortByCode = N'BorrowerName', @FilterByCode = N'Bill'
		
		SELECT * FROM dbo.REPORT
		WHERE DESCRIPTION_TX LIKE '%Activity%'

		SELECT * FROM dbo.REPORT_CONFIG
		WHERE REPORT_ID = 30
	
		SELECT *
FROM REPORT_HISTORY
WHERE REPORT_ID = 30 LENDER_ID = 92  AND CREATE_DT >= '2014-01-01' 


EXEC dbo.Report_UTLActivity @LenderCode = N'8500', -- nvarchar(10)
    @Branch = N'', -- nvarchar(max)
    @Division = N'Mortgage', -- nvarchar(10)
    @Coverage = N'', -- nvarchar(25)
    @FromDate = '2015-09-15 00:00:00', -- datetime
    @ToDate = '2015-09-21 00:00:00', -- datetime
    @User = N'', -- nvarchar(15)
    @ReportType = N'Activity Report', -- nvarchar(50)
    @WorkItemType = 0, -- bigint
    @WorkQueue = 0, -- bigint
    @Report_History_ID = 0 -- bigint

	SELECT DISTINCT RELATE_TYPE_CD FROM dbo.WORK_ITEM


    SELECT  CONTENT_XML.value('(/Content/Lender/Code)[1]', 'varchar (50)') Lender, *
    FROM    dbo.WORK_ITEM
    WHERE   RELATE_TYPE_CD = 'Allied.UniTrac.KeyImage'
     aND CONTENT_XML.value('(/Content/Lender/Code)[1]', 'varchar (50)') = '8500'



	 DECLARE
		  @WorkItemType = 'Key Image'
		
          SELECT *
          FROM LENDER L
          JOIN LENDER_ORGANIZATION LO ON LO.LENDER_ID = L.ID
          AND LO.PURGE_DT IS NULL
          WHERE L.CODE_TX = '8500' AND L.PURGE_DT IS NULL
          AND LO.TYPE_CD = 'BRCH'
         
		   Select *
          from WORKFLOW_DEFINITION
          where ID in (1,2,3,4,5,6,7,8,9,10,11,14)
          AND PURGE_DT IS NULL
          Union
          Select 999, DESCRIPTION_TX + 'XQ' AS DESCRIPTION_TX , DESCRIPTION_TX + 'XQ' as WorkItemSort
          from WORKFLOW_DEFINITION
          where DESCRIPTION_TX = 'Key Image'
          AND PURGE_DT IS NULL

		  select ID, NAME_TX, NAME_TX as WorkQueueSort, *
          from WORK_QUEUE
          where ACTIVE_IN = 'Y'
          and PURGE_DT is null
          and WORKFLOW_DEFINITION_ID = '4'



		  SELECT '1' as BrchValue, 'All' AS BrchLabel
          else
          SELECT LO.CODE_TX as BrchValue, LO.CODE_TX AS BrchLabel
          FROM LENDER L
          JOIN LENDER_ORGANIZATION LO ON LO.LENDER_ID = L.ID
          AND LO.PURGE_DT IS NULL
          WHERE L.CODE_TX = '8500' AND L.PURGE_DT IS NULL
          AND LO.TYPE_CD = 'BRCH'




		  SELECT * FROM dbo.REPORT
		WHERE DESCRIPTION_TX LIKE '%Activity%'


		SELECT * FROM dbo.REF_CODE
		WHERE MEANING_TX like '%Report%'




		SELECT R.ID [Report ID], REPORT_CONFIG_ID [Report Config ID], * FROM dbo.REF_CODE_ATTRIBUTE RCA
INNER JOIN dbo.REF_CODE RRC ON RRC.DOMAIN_CD = RCA.DOMAIN_CD
INNER JOIN dbo.REPORT_CONFIG_ATTRIBUTE RCCA ON RCCA.REPORT_REF_ATTRIBUTE_CD = RCA.ATTRIBUTE_CD
INNER JOIN dbo.REPORT_CONFIG RC ON RCCA.REPORT_CONFIG_ID = RC.ID
INNER JOIN dbo.REPORT R ON R.ID = RC.REPORT_ID
WHERE RCCA.REPORT_CONFIG_ID IN (790, 791) AND RCA.REF_CD LIKE '%28%' AND RRC.MEANING_TX NOT LIKE 'Authorization Past Due'
AND RRC.MEANING_TX NOT LIKE 'Issues Posting Register' AND RRC.MEANING_TX NOT LIKE 'Statement of Charges Earned (Cumulative)'
AND RRC. MEANING_TX NOT LIKE 'Statement of Refunds (Cumulative)' AND RRC.MEANING_TX NOT LIKE 'DEFAULT'
ORDER BY RCA.REF_CD ASC