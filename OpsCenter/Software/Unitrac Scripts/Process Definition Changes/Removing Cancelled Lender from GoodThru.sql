USE Unitrac


--
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

SELECT 
     ID INTO #tmpProcess
FROM    PROCESS_DEFINITION P
WHERE   P.ONHOLD_IN = 'N' 
        AND ACTIVE_IN = 'Y' AND P.PROCESS_TYPE_CD = 'GOODTHRUDT'
		AND P.SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/LenderList/LenderID)[1]',
                              'nvarchar(max)') IN (SELECT [Lender Code] FROM #TMPNEWLENDERINFO)




UPDATE PD
SET PD.STATUS_CD = 'Complete', PD.ACTIVE_IN = 'Y', pd.ONHOLD_IN = 'Y'
--SELECT * 
FROM dbo.PROCESS_DEFINITION PD
JOIN #tmpProcess P ON P.ID = PD.ID 
