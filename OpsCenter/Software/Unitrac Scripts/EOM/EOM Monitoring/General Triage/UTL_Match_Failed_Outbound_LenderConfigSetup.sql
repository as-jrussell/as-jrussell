SELECT  *
FROM    UniTrac..UTL_MATCH_RESULT
WHERE   APPLY_STATUS_CD = 'ERR'
AND MSG_LOG_TX LIKE '%Lender configuration%'
        --AND CREATE_DT > '2013-09-15 23:59'
        AND PURGE_DT IS NULL
ORDER BY CREATE_DT ASC


SELECT  L.CODE_TX AS 'Lender Code' ,
        LN.LENDER_ID AS 'Lender ID (UT)' ,
        U.CREATE_DT AS 'UTL Create Date',
        U.ID AS 'UTL ID #',
        U.LOAN_ID AS 'Loan ID' ,
        LN.NUMBER_TX AS 'Loan Number' ,
        LN.STATUS_CD AS 'Loan Status Code' ,
        LN.BALANCE_AMOUNT_NO AS 'Loan Balance' ,
        U.PROPERTY_ID AS 'Property ID' ,
        U.MSG_LOG_TX AS 'Error Message'
FROM    UTL_MATCH_RESULT U
        JOIN dbo.LOAN LN ON LN.ID = U.LOAN_ID
        JOIN dbo.LENDER L ON L.ID = LN.LENDER_ID
WHERE   U.APPLY_STATUS_CD = 'ERR'
        AND U.MSG_LOG_TX LIKE '%Lender configuration%'
        AND u.PURGE_DT IS NULL
ORDER BY L.CODE_TX ASC
       
       
SELECT * FROM UniTrac..UTL_MATCH_RESULT
WHERE APPLY_STATUS_CD = 'PEND'
AND CREATE_DT < '2015-01-14'

SELECT * FROM UniTrac..LOAN
WHERE ID = 90871