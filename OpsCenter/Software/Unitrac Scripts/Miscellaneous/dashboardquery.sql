USE UniTrac


select fpc.id as FPC_ID, sum(ft.AMOUNT_NO) as AMOUNT_NO
      into #tmpFPC30
	  FROM FORCE_PLACED_CERTIFICATE fpc
         join FINANCIAL_TXN ft on ft.FPC_ID = fpc.ID --and ft.PURGE_DT is null
         join FORCE_PLACED_CERT_REQUIRED_COVERAGE_RELATE FPCRCR ON FPCRCR.FPC_ID = fpc.ID AND FPCRCR.PURGE_DT IS NULL
         join REQUIRED_COVERAGE RC ON RC.ID = FPCRCR.REQUIRED_COVERAGE_ID AND RC.PURGE_DT IS NULL
         join PROPERTY p on p.ID = rc.PROPERTY_ID and p.PURGE_DT is null
         join COLLATERAL c on c.PROPERTY_ID = p.id and c.PURGE_DT is null and c.PRIMARY_LOAN_IN = 'Y'
         join LOAN l on l.id = c.LOAN_ID and l.PURGE_DT is null
         join LENDER ldr on ldr.id = p.LENDER_ID and ldr.PURGE_DT is null and ldr.TEST_IN = 'N'
         JOIN COLLATERAL_CODE CC ON CC.ID = c.COLLATERAL_CODE_ID AND CC.PURGE_DT IS NULL  
	      JOIN REF_CODE_ATTRIBUTE RCA on RCA.DOMAIN_CD = 'SecondaryClassification'  
	      AND RCA.REF_CD = CC.SECONDARY_CLASS_CD
	      AND RCA.ATTRIBUTE_CD = 'PropertyType' 
	      WHERE 
		   (
			     p.AGENCY_ID IN ( 1 , 9) OR 
			     ( p.AGENCY_ID = 4 AND  
			     ( RCA.VALUE_TX = 'RE' OR (RCA.VALUE_TX = 'MH' AND ISNULL(p.ADDRESS_ID, 0) > 0)))
		   ) 		  
         and fpc.PURGE_DT is NULL
         and convert(DATE, ft.CREATE_DT) <= convert(DATE, getdate()-30)
         and (ft.purge_dt is null or convert(DATE, ft.PURGE_DT) > convert(DATE, getdate()-30)) 
      group by fpc.ID
      having sum(ft.AMOUNT_NO) <> 0
