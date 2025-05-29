use UniTrac
---Payment Increase Information

		SELECT  FPC.ID, FPC.QUICK_ISSUE_IN, FPC.ISSUE_DT,
		DATEADD(DAY, CASE WHEN FPC.QUICK_ISSUE_IN = 'Y' THEN 0 
			ELSE ISNULL(RC.PmtOptIncrDelayedBilling,0) 
			END, FPC.ISSUE_DT) NEW_ISSUE_DT INTO #tmpSpecialFPCs
		FROM FORCE_PLACED_CERTIFICATE FPC
		JOIN LOAN L ON FPC.LOAN_ID = L.ID AND L.PURGE_DT IS NULL
		JOIN FORCE_PLACED_CERT_REQUIRED_COVERAGE_RELATE FPCRCR ON FPCRCR.FPC_ID = FPC.ID AND FPCRCR.PURGE_DT IS NULL
		JOIN REQUIRED_COVERAGE RC ON FPCRCR.REQUIRED_COVERAGE_ID = RC.ID AND RC.PURGE_DT IS NULL	
		WHERE 1=1
		AND FPC.PURGE_DT IS NULL
		AND L.LENDER_ID = 75  
		AND FPC.ISSUE_DT between  DATEADD(D, -100, DATEADD(D, 1, DATEDIFF(D, 0, '0001-01-01'))) and  DATEADD(D, 100, DATEADD(D, 1, DATEDIFF(D, 0,'2019-03-01'))) --widens the start and end date by 100 days to only pull a subset of FPCs

---For Loans to run in the PIR report it needs to be in THIS QUERY
		SELECT distinct SFPC.ID 
		FROM #tmpSpecialFPCs SFPC
		WHERE 
      (
       (SFPC.QUICK_ISSUE_IN = 'N' AND SFPC.NEW_ISSUE_DT BETWEEN DATEADD(D, -100,GETDATE()) AND DATEADD(D, 100, GETDATE())) OR --only pulls the FPC IDs that fall between the Start/End date and have the special logic
       (SFPC.QUICK_ISSUE_IN = 'Y' AND SFPC.NEW_ISSUE_DT BETWEEN '0001-01-01' AND GETDATE())  ---use end date of prev & current cycle for QI
      )
		GROUP BY SFPC.ID


		select * from lender 
		where code_tx = '1933'
