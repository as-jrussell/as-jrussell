USE UniTrac
/*
------------- Newbie, Entry on Lender, No Products Yet ---------------------------
SELECT  L.CODE_TX AS 'Lender Code' ,
        L.NAME_TX AS 'Lender Name' ,
        L.AGENCY_ID AS 'Agency' ,
        L.TAX_ID_TX AS 'Tax ID' ,
        L.CREATE_DT AS 'Create Date' ,
        L.STATUS_CD AS 'Lender Status' ,
        L.ACTIVE_DT AS 'Active Date' ,
        L.CANCEL_DT AS 'Cancelled Date',
        L.ID AS 'UniTrac Code'
FROM    LENDER L
        LEFT JOIN dbo.LENDER_PRODUCT LP ON LP.LENDER_ID = L.ID
WHERE   L.CREATE_DT > GETDATE() - 30
        AND L.TEST_IN = 'N'
        AND L.STATUS_CD NOT IN ( 'CANCEL', 'SUSPEND', 'MERGED' )
        AND LP.ID IS NULL
ORDER BY L.CREATE_DT ,
        L.CODE_TX DESC
------------- Newbie, Entry on Lender, No Products Yet (END) ---------------------*/

------------- Entry on Lender and Has Products Assigned --------------------------
IF OBJECT_ID(N'tempdb..#TMPNEWLENDERINFO', N'U') IS NOT NULL
    DROP TABLE #TMPNEWLENDERINFO

SELECT  L.CODE_TX AS 'Lender Code' ,
        L.NAME_TX AS 'Lender Name' ,
        L.AGENCY_ID AS 'Agency' ,
        L.TAX_ID_TX AS 'Tax ID' ,
        L.CREATE_DT AS 'Create Date' ,
        L.STATUS_CD AS 'Lender Status' ,
        L.ACTIVE_DT AS 'Active Date' ,
        L.CANCEL_DT AS 'Cancelled Date' ,
        LP.NAME_TX AS 'Product Name' ,
        LP.BASIC_TYPE_CD AS 'Product Tracking Type',
        L.ID AS 'UniTrac Code' 
INTO    #TMPNEWLENDERINFO
--SELECT L.* 
FROM    LENDER L
        JOIN dbo.LENDER_PRODUCT LP ON LP.LENDER_ID = L.ID
WHERE   L.TEST_IN = 'N'
        AND L.STATUS_CD NOT IN ( 'CANCEL', 'SUSPEND', 'MERGED' )
ORDER BY L.CREATE_DT ,
        L.CODE_TX DESC
        
        
ALTER TABLE #TMPNEWLENDERINFO
ALTER COLUMN Agency VARCHAR(255)
        
UPDATE  #TMPNEWLENDERINFO
SET     [Agency] = CASE #TMPNEWLENDERINFO.[Agency]
                     WHEN '1' THEN 'Allied'
                     WHEN '4' THEN 'Passmore'
                     WHEN '8' THEN 'Comm Loc'
                     WHEN '9' THEN 'Freimark'
                   END   


--SELECT  DISTINCT [Lender Code]
--FROM    #TMPNEWLENDERINFO
--WHERE [Product Tracking Type] <> 'ORDERUP'



--DROP TABLE #tmpLCGCTId
SELECT P.TAB.value('.', 'nvarchar(max)') AS LCGCTId, pd.ID AS ProcId
INTO #tmpLCGCTId
FROM PROCESS_DEFINITION pd 
CROSS APPLY pd.SETTINGS_XML_IM.nodes('/ProcessDefinitionSettings/InsuranceDocTypeSettings/LenderList/LenderID') AS P (TAB)
WHERE-- ID = '39'
pd.PROCESS_TYPE_CD = 'INSDOCPA'

--DROP TABLE #tmpLCPRCAId
SELECT P.TAB.value('.', 'nvarchar(max)') AS tmpLCPRCAId, pd.ID AS ProcId
INTO #tmpLCPRCAId
FROM PROCESS_DEFINITION pd 
CROSS APPLY pd.SETTINGS_XML_IM.nodes('/ProcessDefinitionSettings/LenderList/LenderID') AS P (TAB)
WHERE  pd.PROCESS_TYPE_CD = 'LOANPRCPA'

--DROP TABLE #tmpMSGinfo
SELECT P.TAB.value('.', 'nvarchar(max)') AS tmpLCPRCAId, pd.ID AS ProcId
INTO #tmpMSGinfo
FROM PROCESS_DEFINITION pd 
CROSS APPLY pd.SETTINGS_XML_IM.nodes('/ProcessDefinitionSettings/LenderList/LenderID') AS P (TAB)
WHERE pd.PROCESS_TYPE_CD = 'MSGSRV'





---Ones not here need adding to process
SELECT
DISTINCT
TNL.Agency,
	 TNL.[Lender Code] ,
	TNL.[Lender Name] ,
	LDR.CODE_TX,
	LDR.NAME_TX,
	tpc.ProcId [ProcessId 39], tpd.ProcId[ProcessId 336], tpe.ProcId[MessageServer],PD.STATUS_CD [Staus]
	--SELECT DISTINCT LDR.* 
FROM #TMPNEWLENDERINFO TNL
LEFT JOIN #tmpLCGCTId tpc ON TNL.[Lender Code] = TPC.LCGCTId
LEFT JOIN #tmpLCPRCAId tpd ON TNL.[Lender Code] = TPD.tmpLCPRCAId
LEFT JOIN #tmpMSGinfo tpe ON TNL.[Lender Code] = TPE.tmpLCPRCAId
LEFT JOIN PROCESS_DEFINITION PD ON  tpc.ProcId = PD.ID
LEFT JOIN LENDER LDR ON LDR.CODE_TX = tpc.LCGCTId
WHERE [Product Tracking Type] <> 'ORDERUP'
AND (tpc.ProcId IS NULL  OR tpd.ProcId  IS NULL OR tpe.ProcId  IS NULL)
ORDER BY  TNL.[Lender Code] ASC 




/*
DROP TABLE #tmpLCPRCAId
DROP TABLE #TMPNEWLENDERINFO
DROP TABLE #tmpLCGCTId
DROP TABLE #tmpMSGinfo

SELECT  DISTINCT [Lender Code]
FROM    #TMPNEWLENDERINFO
WHERE [Product Tracking Type] <> 'ORDERUP'

----Checking Process Definitions
SELECT * FROM UniTrac..PROCESS_DEFINITION
WHERE PROCESS_TYPE_CD IN ('VUTPA','BSSPA','INSDOCPA','LOANPRCPA','LDHPRCPA')  AND ACTIVE_IN = 'Y'


SELECT * FROM UniTrac..PROCESS_DEFINITION
WHERE PROCESS_TYPE_CD = 'msgsrv' AND ACTIVE_IN = 'Y'

SELECT * FROM UniTrac..PROCESS_DEFINITION
WHERE PROCESS_TYPE_CD = 'GOODTHRUDT' AND ACTIVE_IN = 'Y' 

SELECT L.* 
FROM    LENDER L
WHERE   L.CREATE_DT > GETDATE() - 30
        AND L.TEST_IN = 'N'
        AND L.STATUS_CD NOT IN ( 'CANCEL', 'SUSPEND', 'MERGED' )

SELECT * FROM #tmpLCPRCAId
WHERE tmpLCPRCAId = ''


SELECT * FROM #tmpLCGCTId
WHERE LCGCTId = ''

SELECT * FROM #tmpMSGinfo
WHERE tmpLCPRCAId	 = '' 

SELECT * FROM  #tmpMSGGT	
WHERE tmpLCPRCAId = ''


*/
