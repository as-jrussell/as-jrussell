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
WHERE   L.TEST_IN = 'N' and L.PURGE_DT is null	
        AND L.STATUS_CD NOT  IN ( 'CANCEL', 'SUSPEND', 'MERGED' )
ORDER BY L.CREATE_DT ,
        L.CODE_TX DESC

SELECT 
 P.SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/LenderList/LenderID)[1]',
                              'nvarchar(max)') [LenderCode],  *
INTO #GoodTHruPD
FROM  dbo.PROCESS_DEFINITION P
WHERE P.PROCESS_TYPE_CD = 'GOODTHRUDT'
AND P.LOAD_BALANCE_IN = 'Y'
AND P.PURGE_DT is null




SELECT *
 FROM #TMPNEWLENDERINFO T
LEFT JOIN #GoodTHruPD G ON T.[Lender Code] = G.LenderCode
WHERE G.ID IS NULL
ORDER BY T.[Create Date] ASC 



