--UNITRAC-WH02	Dashboard
--UNITRAC-WH18	LenderDashboard
--UNITRAC-WH18	OperationalDashboard

USE OspreyDashboard

--utdashprod

	SELECT
				DATENAME(MONTH, dc.RECORD_DATE)
				,dc.STATUS_CD		AS StatusCd
				,SUM(dc.COUNT_NO)	AS TotalCount
				,MONTH(dc.RECORD_DATE)
            ,	CASE dc.STATUS_CD
		         WHEN 'Notice 1' THEN 1
		         WHEN 'Notice 2' THEN 2
		         WHEN 'Outbound Call' THEN 3
		         WHEN 'Issue Certificate' THEN 4
		         ELSE 5
	         END AS EventRank
			FROM dbo.DATASOURCE_CACHE dc (NOLOCK)
			JOIN dbo.DATASOURCE d (NOLOCK) ON dc.DATASOURCE_ID = d.ID AND d.TYPE_CD = '3MONTH_EVENTSUCCESS_RATE_BYBRANCH_BYSEQUENCE'
			WHERE dc.STATUS_CD NOT IN ('Repeat') and dc.PURGE_DT is null
                and (dc.RESULT_CD NOT IN ('Pending') or dc.RESULT_CD is null)
                AND dc.SOURCE_CD LIKE  '%Vehicle%'
                AND dc.ASSOCIATION_CD = '1729'
			GROUP BY	DATENAME(MONTH, dc.RECORD_DATE)
						,dc.STATUS_CD
						,MONTH(dc.RECORD_DATE)
			ORDER BY MONTH(dc.RECORD_DATE), EventRank ASC
			


			
						SELECT
							DATENAME(MONTH, dc.RECORD_DATE)
							,dc.STATUS_CD
							,SUM(dc.COUNT_NO)
							,MONTH(dc.RECORD_DATE)
							,YEAR(dc.RECORD_DATE)
							FROM dbo.DATASOURCE_CACHE dc (NOLOCK)
							JOIN dbo.DATASOURCE d (NOLOCK) ON dc.DATASOURCE_ID = d.ID
						WHERE d.TYPE_CD = '3MONTH_MAILED_LETTERCNT_BYBRANCH_BYTYPE' 
                        AND dc.PURGE_DT IS NULL
                        AND dc.SOURCE_CD like '%Vehicle%'
                        AND dc.ASSOCIATION_CD = '1729'
						GROUP BY	DATENAME(MONTH, dc.RECORD_DATE)
									,dc.STATUS_CD
									,YEAR(dc.RECORD_DATE)
									,MONTH(dc.RECORD_DATE)
							ORDER BY YEAR(dc.RECORD_DATE), MONTH(dc.RECORD_DATE),
							CASE 
								WHEN dc.STATUS_CD = 'Notice 1' THEN 1
								WHEN dc.STATUS_CD = 'Notice 2' THEN 2
								WHEN dc.STATUS_CD = 'Issue Certificate' THEN 3
								ELSE 4
							END
						


		SELECT
			 dc.STATUS_CD
			,SUM(dc.COUNT_NO)	AS Total
		FROM dbo.DATASOURCE_CACHE dc  (NOLOCK)
		JOIN dbo.DATASOURCE d  (NOLOCK) ON dc.DATASOURCE_ID = d.ID
		WHERE d.TYPE_CD = 'INSEFFDATE_LOANCNT_BYBRCH_BYAGE' 
            AND dc.PURGE_DT IS NULL
            AND dc.SOURCE_CD = 'Vehicle'
            and dc.ASSOCIATION_CD = '8448'
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
		