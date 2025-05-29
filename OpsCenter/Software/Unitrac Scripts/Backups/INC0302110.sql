SELECT  *
FROM    LENDER
WHERE   CODE_TX = '7016'

SELECT  PAYEE_ADDRESS_ID INTO #tmpA
FROM    dbo.LENDER_PAYEE_CODE_FILE
WHERE  LENDER_ID = 789 AND 
 PAYEE_CODE_TX NOT IN ( '2480', '3178', '2521', '2737', '787', '2116',
                               '3184', '2383', '2194', '3179', '2320', '2820',
                               '1976', '2068', '2817', '3188', '2185', '2088',
                               '2951', '2144', '2212', '2146', '3187', '3180',
                               '1797', '2251', '2785', '2143', '2369', '1948',
                               '3183', '3181', '2495', '2313', '3182', '1647',
                               '2204', '1874', '2324', '2135', '2214', '2341',
                               '2142', '2315', '2865', '2210', '2329', '2326',
                               '1890', '2136', '2217', '2134', '2198', '1193',
                               '2695', '2344' )


	UPDATE dbo.LENDER_PAYEE_CODE_FILE
	SET PURGE_DT =GETDATE()
	WHERE ID IN (SELECT * FROM #tmp)


	UPDATE dbo.ADDRESS
		SET PURGE_DT =GETDATE()
	WHERE ID IN (SELECT * FROM #tmpA)



	SELECT *
FROM    dbo.LENDER_PAYEE_CODE_FILE
WHERE  LENDER_ID = 789  AND purge_dt IS NULL