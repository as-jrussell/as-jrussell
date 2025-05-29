---------------- Who's Processing Now??????
SELECT * FROM UniTrac..PROCESS_DEFINITION
WHERE PROCESS_TYPE_CD IN ('UTLMTCHIB','UTLIBREPRC','UTLMTCHOB') AND ACTIVE_IN = 'Y' ORDER BY PROCESS_TYPE_CD DESC,DESCRIPTION_TX ASC
------------------ In-Bound Roundup ------------------------------------
SELECT * FROM UniTrac..PROCESS_DEFINITION
WHERE PROCESS_TYPE_CD IN ('UTLMTCHIB') AND ACTIVE_IN = 'Y'
------------------ Re-Process Roundup (15)  ------------------------------------
SELECT * FROM UniTrac..PROCESS_DEFINITION
WHERE PROCESS_TYPE_CD IN ('UTLIBREPRC') AND ACTIVE_IN = 'Y' ORDER BY DESCRIPTION_TX ASC
------------------ Re-Process Automatics (6)  ------------------------------------
SELECT * FROM UniTrac..PROCESS_DEFINITION
WHERE PROCESS_TYPE_CD IN ('UTLIBREPRC') AND ACTIVE_IN = 'Y' AND ID IN (33,38,49,50,511,3972) ORDER BY DESCRIPTION_TX ASC
------------------ Re-Process Manuals (9)  ------------------------------------
SELECT * FROM UniTrac..PROCESS_DEFINITION
WHERE PROCESS_TYPE_CD IN ('UTLIBREPRC') AND ACTIVE_IN = 'Y' AND ID IN (48,839,1837,1978,3137,266,3932,69899,83852,114988) ORDER BY DESCRIPTION_TX ASC
----------------- Calling All ReProcessing (In Action) ------------------------
SELECT * FROM UniTrac..PROCESS_DEFINITION
WHERE PROCESS_TYPE_CD IN ('UTLMTCHIB','UTLIBREPRC') AND ACTIVE_IN = 'Y' AND STATUS_CD = 'InProcess' ORDER BY PROCESS_TYPE_CD DESC,DESCRIPTION_TX ASC
------------------ Quick Completion Marking ------------------------------
--UPDATE UniTrac..PROCESS_DEFINITION
--SET STATUS_CD = 'Complete'
--WHERE PROCESS_TYPE_CD = 'UTLIBREPRC' AND ID IN (38,50)

--------------- Check for New Evaluations
--------------- RECORD_TYPE_CD = 'E'(EDI); 'I'(IDR); and 'U' (BSS) -----------
SELECT  COUNT(*)
FROM    UniTrac..UTL_QUEUE
WHERE   LENDER_ID IN (1835 )
        AND EVALUATION_DT > '1900-01-01 00:00:00.000'
        AND CREATE_DT > = '2012-10-15'
        --ORDER BY LENDER_ID        
------------ Check for ProcTheessed Valuations        
SELECT  *
FROM    dbo.UTL_QUEUE
WHERE   LENDER_ID IN ( 1810 )
        AND CREATE_DT >= '2012-09-09'
        AND RECORD_TYPE_CD IN ('E','U','I')
                              
------------ Check for Results
SELECT  *
FROM    UTL_MATCH_RESULT
WHERE   UTL_LOAN_ID IN ( SELECT LOAN_ID
                         FROM   dbo.UTL_QUEUE
                         WHERE  LENDER_ID IN ( 1810 )
                                AND CREATE_DT >= '2012-09-09'
                                AND RECORD_TYPE_CD IN ( 'E', 'U', 'I' ) )
ORDER BY CREATE_DT ASC                                         

------------ Count it Out (Current InBound UTLs)
SELECT  UQ.LENDER_ID AS 'Lender ID' ,
        L.CODE_TX AS 'Lender Code' ,
        L.NAME_TX AS 'Lender Name' ,
        L.TYPE_CD AS 'Lender Type' ,
        L.STATUS_CD AS 'Lender Status Code' ,
        COUNT(*) AS 'UTL No.'
FROM    UniTrac..UTL_QUEUE UQ
        JOIN dbo.LENDER L ON L.ID = UQ.LENDER_ID
WHERE   EVALUATION_DT = '1/1/1900'
        AND L.TEST_IN = 'N'
        AND L.STATUS_CD NOT IN ( 'CANCEL', 'MERGED' )
GROUP BY UQ.LENDER_ID ,
        L.CODE_TX ,
        L.NAME_TX ,
        L.STATUS_CD ,
        L.TYPE_CD
ORDER BY UQ.LENDER_ID


-------- Temp, Update Manual Reprocess Process Definition
--UPDATE UniTrac..PROCESS_DEFINITION
--SET ACTIVE_IN = 'Y', STATUS_CD = 'Complete' WHERE ID in (3137,1978,83852)


-------- ALL IN A DAY'S WORK ----------
SELECT  DISTINCT
        T1.LENDER_ID AS 'UniTrac ID' ,
        L.CODE_TX AS 'LenderID',
        COUNT(*) AS 'Count' 
FROM    dbo.UTL_QUEUE T1
        INNER JOIN dbo.LENDER L ON T1.LENDER_ID = L.ID
WHERE   T1.LENDER_ID = L.ID
        AND T1.EVALUATION_DT > '2013-06-10'
        AND T1.EVALUATION_DT < '2013-06-11'
GROUP BY T1.LENDER_ID,l.CODE_TX
ORDER BY l.CODE_TX