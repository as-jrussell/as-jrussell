----------- Loan Counts By Lender ----------
SELECT  ldr.ID AS UT_ID ,
        ldr.CODE_TX AS LENDER_ID ,
        ldr.NAME_TX AS LENDER_NAME,
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
GROUP BY ldr.ID ,
        ldr.CODE_TX,
        ldr.NAME_TX