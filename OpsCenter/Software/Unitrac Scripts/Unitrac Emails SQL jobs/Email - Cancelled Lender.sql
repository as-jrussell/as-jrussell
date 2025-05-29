USE UniTrac	


 BEGIN
 
 
 --drop table #TMPNEWLENDERINFO
 SELECT  L.CODE_TX AS 'Lender Code' ,
        L.NAME_TX AS 'Lender Name' ,
        L.AGENCY_ID AS 'Agency' ,
        L.TAX_ID_TX AS 'Tax ID' ,
        L.CREATE_DT AS 'Create Date' ,
        L.STATUS_CD AS 'Lender Status' ,
        L.ACTIVE_DT AS 'Active Date' ,
        L.CANCEL_DT AS 'Cancelled Date' ,
        L.ID AS 'UniTrac Code' 
INTO    #TMPNEWLENDERINFO
FROM    LENDER L
WHERE   L.UPDATE_DT > GETDATE() - 30
        AND L.TEST_IN = 'N'
        AND L.STATUS_CD IN ( 'CANCEL', 'SUSPEND', 'MERGED' )
ORDER BY L.CREATE_DT ,
        L.CODE_TX DESC

 --drop table #tmpEmptyPL
CREATE TABLE #tmpEmptyPL (PD_ID BIGINT)

INSERT INTO #tmpEmptyPL
SELECT 
     ID
FROM    PROCESS_DEFINITION P
WHERE   P.ONHOLD_IN = 'Y' 
        AND ACTIVE_IN = 'Y' AND P.PROCESS_TYPE_CD = 'GOODTHRUDT'
		AND P.SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/LenderList/LenderID)[1]',
                              'nvarchar(max)') IN (SELECT [Lender Code] FROM #TMPNEWLENDERINFO)


IF ((select count(*) from #tmpEmptyPL)>= 1)

BEGIN

DECLARE @EmailSubject AS VARCHAR(1000)
declare @EmailSubjectCount AS VARCHAR(1000)
DECLARE @body NVARCHAR(MAX)

 select @EmailSubjectCount = 
   (SELECT COUNT(PD_ID) FROM #tmpEmptyPL)
 

 if @EmailSubjectCount >= 1 
 
 BEGIN
SELECT NAME_TX INTO #tmpOP FROM dbo.PROCESS_DEFINITION
WHERE ID IN (SELECT * FROM #tmpEmptyPL)
		
 

 	SELECT 
					(SELECT 
						  CAST(NAME_TX AS NVARCHAR(1000)) + '; ' 
					FROM #tmpOP
					FOR XML PATH ('')) AS OutBatchID
		INTO #tmpO

 	SELECT 
					(SELECT 
						  CAST(PD_ID AS NVARCHAR(1000)) + ', ' 
					FROM #tmpEmptyPL
					FOR XML PATH ('')) AS PD_ID
		INTO #tmpOO


select @body = 'These Good Thru process are showing as active but the lender has been cancelled: 
'  + (SELECT * FROM #tmpO)+'

The Process Ids are: ' + (SELECT * FROM #tmpOO)  + '
Please move those to items to inactive and restart the service that it is using.'

   END 

select @EmailSubject = 'Cancelled Lender with Active GoodThru Process'  
		 

 
		 EXEC msdb.dbo.sp_send_dbmail @profile_name = 'Unitrac-prod',
						@recipients ='joseph.russell@alliedsolutions.net',
						@subject = @EmailSubject,
						@body = @body
					RETURN

					END END 



/*
drop table #TMPNEWLENDERINFO
drop table #tmpEmptyPL
drop table  #tmpOO
drop table #tmpO
drop table #tmpOP

*/