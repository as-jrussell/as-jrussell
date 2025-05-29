-- find the Required Coverages that need to be deleted;
SELECT ln.BRANCH_CODE_TX, ln.NUMBER_TX as 'Loan #', rc.LCGCT_ID, rc.CREATE_DT --, rc.*
FROM LOAN ln
        JOIN COLLATERAL col on col.LOAN_ID = ln.ID AND col.PURGE_DT IS NULL
        JOIN REQUIRED_COVERAGE rc on rc.PROPERTY_ID = col.PROPERTY_ID AND rc.PURGE_DT IS NULL
WHERE ln.LENDER_ID = 2260
AND ln.PURGE_DT IS NULL
AND rc.TYPE_CD = 'REO-LIABILITY'
AND ln.BRANCH_CODE_TX != 'REO'

-- I think this gives confirmation that all of the RCs were created in last two days
-- and shows just 1 for REO 
SELECT ln.BRANCH_CODE_TX, COUNT(*), MIN(rc.CREATE_DT), MAX(rc.CREATE_DT)
FROM LOAN ln
        JOIN COLLATERAL col on col.LOAN_ID = ln.ID AND col.PURGE_DT IS NULL
        JOIN REQUIRED_COVERAGE rc on rc.PROPERTY_ID = col.PROPERTY_ID AND rc.PURGE_DT IS NULL
WHERE ln.LENDER_ID = 2260
AND ln.PURGE_DT IS NULL
AND rc.TYPE_CD = 'REO-LIABILITY'
GROUP by ln.BRANCH_CODE_TX
