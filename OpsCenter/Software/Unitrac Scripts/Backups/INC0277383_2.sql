   IF OBJECT_ID('tempdb..#TMP_INSEFFDATE_LOANCNT_BYBRCH_BYAGE') IS NOT NULL
	            DROP TABLE #TMP_INSEFFDATE_LOANCNT_BYBRCH_BYAGE

            CREATE TABLE #TMP_INSEFFDATE_LOANCNT_BYBRCH_BYAGE (
	            LENDER_CD NVARCHAR(50)
            ,	LENDER_NAME NVARCHAR(500)
            ,	BRANCH NVARCHAR(150)
            ,	EFFECTIVE_DATE DATETIME2
            ,	LOAN_TYPE NVARCHAR(50)
            ,	LOAN_ID BIGINT
            ,	CC_RANK INT
            );

            INSERT INTO #TMP_INSEFFDATE_LOANCNT_BYBRCH_BYAGE (	LENDER_CD
												            ,	LENDER_NAME
												            ,	BRANCH
												            ,	EFFECTIVE_DATE
												            ,	LOAN_TYPE
												            ,	LOAN_ID
												            ,	CC_RANK)
	            SELECT
		            LENDER_CD
	            ,	LENDER_NAME
	            ,	L_BRANCH_CODE_TX AS 'BRANCH'
	            ,	op.EFFECTIVE_DT
	            ,	LOAN_TYPE
	            ,	l.LOAN_ID
	            ,	ROW_NUMBER() OVER (PARTITION BY C_PROPERTY_ID, RC_TYPE_CD
		            ORDER BY pcov.END_DT DESC, op.MOST_RECENT_MAIL_DT DESC, op.ID DESC)
		            AS CC_RANK
	            FROM OspreyDashboard.dbo.DATASOURCE_CACHE_STAGING l
		            JOIN dbo.PROPERTY_OWNER_POLICY_RELATE popr ON popr.PROPERTY_ID = l.C_PROPERTY_ID
		            JOIN OWNER_POLICY op ON op.ID = popr.OWNER_POLICY_ID
				            AND (op.UNIT_OWNERS_IN IS NULL
					            OR op.UNIT_OWNERS_IN = 'N')
				            AND (op.EXCESS_IN IS NULL
					            OR op.EXCESS_IN = 'N')
		            JOIN dbo.POLICY_COVERAGE pcov ON pcov.OWNER_POLICY_ID = op.ID
				            AND pcov.PURGE_DT IS NULL
				            AND pcov.TYPE_CD = l.RC_TYPE_CD
	            WHERE popr.PURGE_DT IS NULL
		            AND RC_RECORD_TYPE_CD = 'G'
		            AND RC_STATUS_CD = 'A' AND RC_SUMMARY_STATUS_CD <> 'F'
		            AND C_PRIMARY_LOAN_IN = 'Y' AND LENDER_ID = '2278' 


--SELECT * FROM dbo.REF_CODE
--WHERE DOMAIN_CD LIKE 'requiredcoverageins%'

		
		
					SELECT *
            FROM #TMP_INSEFFDATE_LOANCNT_BYBRCH_BYAGE
            WHERE CC_RANK = 1
		GROUP BY dc.STATUS_CD
		ORDER BY CASE
				WHEN dc.STATUS_CD = '< 6 months' THEN 1
				WHEN dc.STATUS_CD = '< 12 months' THEN 2
				WHEN dc.STATUS_CD = '< 18 months' THEN 3
				WHEN dc.STATUS_CD = '< 24 months' THEN 4
				WHEN dc.STATUS_CD = '< 30 months' THEN 5
				WHEN dc.STATUS_CD = '< 36 months' THEN 6
				ELSE 7
			END





			SELECT CC_RANK, COUNT(CC_RANK) FROM #TMP_INSEFFDATE_LOANCNT_BYBRCH_BYAGE
			GROUP BY CC_RANK
			ORDER BY CC_RANK ASC