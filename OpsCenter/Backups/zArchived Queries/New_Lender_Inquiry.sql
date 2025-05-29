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
------------- Newbie, Entry on Lender, No Products Yet (END) ---------------------

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
FROM    LENDER L
        JOIN dbo.LENDER_PRODUCT LP ON LP.LENDER_ID = L.ID
WHERE   L.CREATE_DT > GETDATE() - 30
        AND L.TEST_IN = 'N'
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
SELECT  *
FROM    #TMPNEWLENDERINFO

DROP TABLE #TMPNEWLENDERINFO