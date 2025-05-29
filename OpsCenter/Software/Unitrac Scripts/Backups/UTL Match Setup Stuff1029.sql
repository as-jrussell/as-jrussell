---UTL Match Setup Stuff!!!!!!!

------- Find the Lender ID
SELECT  *
FROM    UniTrac..LENDER
WHERE   CODE_TX = '1630'

----- Count the UTLs To Be Picked Up Initially
SELECT  *
FROM    UniTrac..UTL_QUEUE
WHERE   LENDER_ID = 13 AND RECORD_TYPE_CD = 'U'

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
		AND ldr.CODE_TX = '4444'
GROUP BY ldr.ID ,
        ldr.CODE_TX ,
        ldr.NAME_TX


		SELECT CONTENT_XML.value('(/Content/Lender/Code)[1]', 'varchar (50)') Lender_ID,* FROM dbo.WORK_ITEM
		WHERE ID IN (27421816,27422571,27420257,27421785)


		SELECT * FROM dbo.MESSAGE 
		WHERE ID IN (SELECT RELATE_ID FROM dbo.WORK_ITEM
		WHERE ID IN (27421816,27422571,27420257,27421785))


		SELECT * FROM dbo.REF_CODE
		WHERE DOMAIN_CD LIKE '%record%'



		SELECT * FROM dbo.UTL_MATCH_RESULT
		WHERE UTL_LOAN_ID IN ((SELECT  LOAN_ID
FROM    UniTrac..UTL_QUEUE
WHERE   LENDER_ID = 13 AND RECORD_TYPE_CD = 'U'))




	SELECT * FROM dbo.REPORT_HISTORY
	WHERE REPORT_ID = '63'