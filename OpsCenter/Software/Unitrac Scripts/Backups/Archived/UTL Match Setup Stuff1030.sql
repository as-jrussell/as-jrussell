---UTL Match Setup Stuff!!!!!!!

------- Find the Lender ID
SELECT  *
FROM    UniTrac..LENDER
WHERE   CODE_TX = '1968'

----- Count the UTLs To Be Picked Up Initially
SELECT  *
FROM    UniTrac..UTL_QUEUE
WHERE   LENDER_ID = 933 AND RECORD_TYPE_CD = 'U'

--62

------ Count # of Loans (if want further review of Lender size)
----------- Loan Counts By Lender ----------
--Added AND ldr.CODE_TX = '2970' - (07/10/15) jcr
SELECT  ldr.ID AS UT_ID ,
        ldr.CODE_TX AS LENDER_ID ,
        ldr.NAME_TX AS LENDER_NAME ,
        COUNT(DISTINCT lon.ID) AS 'Loan Count'
--INTO    #ldr
FROM    LENDER ldr
        JOIN RELATED_DATA rd ON ldr.ID = rd.RELATE_ID
                                AND rd.VALUE_TX = 'UniTrac'
        JOIN RELATED_DATA_DEF rdd ON rd.DEF_ID = rdd.ID
                                     AND rdd.NAME_TX = 'TrackingSource'
                                     AND rdd.RELATE_CLASS_NM = 'Lender'
        JOIN dbo.LOAN lon ON ldr.ID = lon.LENDER_ID
WHERE   ldr.PURGE_DT IS NULL
        AND ldr.TEST_IN = 'N'
        AND ldr.CANCEL_DT IS NULL
        AND lon.STATUS_CD = 'A'
        AND lon.RECORD_TYPE_CD = 'G'
		AND ldr.CODE_TX = '6285'
GROUP BY ldr.ID ,
        ldr.CODE_TX ,
        ldr.NAME_TX


		SELECT * FROM dbo.PROCESS_DEFINITION
		WHERE EXECUTION_FREQ_CD LIKE '%UBS%'