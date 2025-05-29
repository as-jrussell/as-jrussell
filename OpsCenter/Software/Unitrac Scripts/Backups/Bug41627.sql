USE UniTrac


SELECT * FROM dbo.PROCESS_DEFINITION
WHERE NAME_TX = 'Test-JC' 

SELECT * FROM
 dbo.PROCESS_LOG
WHERE PROCESS_DEFINITION_ID = 495583


SELECT * FROM dbo.WORK_ITEM
WHERE RELATE_ID = 46764582


SELECT * FROM dbo.WORKFLOW_DEFINITION
WHERE ID = 16

exec GetProcessDefinition @id=15263

SELECT * FROM dbo.PROCESS_LOG_ITEM
WHERE PROCESS_LOG_ID = 46764582


SELECT * FROM dbo.REF_CODE
WHERE CODE_CD = 'LENDERPAY'



 select distinct mp.LENDER_ID, mp.POLICY_ENDORSEMENT_BILLING_FREQ_CD, mp.LENDER_PAY_ENDORSEMENT_ACTIVE_IN, pe.LENDER_PAY_IN 
   from MASTER_POLICY mp
      join MASTER_POLICY_ASSIGNMENT mpa on mpa.MASTER_POLICY_ID = mp.ID and mpa.PURGE_DT is null
      join MASTER_POLICY_ENDORSEMENT mpe on mpe.MASTER_POLICY_ASSIGNMENT_ID = mpa.ID and mpe.PURGE_DT is null 
	  JOIN POLICY_ENDORSEMENT pe ON pe.ID = mpe.POLICY_ENDORSEMENT_ID  AND pe.PURGE_DT IS NULL
      join LENDER ldr on ldr.ID = mp.LENDER_ID and ldr.PURGE_DT is NULL
         where ldr.AGENCY_ID = '1'
	  and ldr.TEST_IN = 'N'
      and mp.LENDER_PAY_ENDORSEMENT_ACTIVE_IN = 'Y'
      --AND mp.POLICY_ENDORSEMENT_BILLING_FREQ_CD = @billingFrequency
      and mp.PURGE_DT is null
      and GetDate() between mp.START_DT and mp.END_DT
      and GetDate() between mpa.START_DT and mpa.END_DT
      and GetDate() between mpe.START_DT and mpe.END_DT
	  

	  SELECT * FROM dbo.LENDER
	  WHERE ID = 970

	  
 select distinct mp.LENDER_ID, mp.POLICY_ENDORSEMENT_BILLING_FREQ_CD 
   from MASTER_POLICY mp
      join MASTER_POLICY_ASSIGNMENT mpa on mpa.MASTER_POLICY_ID = mp.ID and mpa.PURGE_DT is null
      join MASTER_POLICY_ENDORSEMENT mpe on mpe.MASTER_POLICY_ASSIGNMENT_ID = mpa.ID and mpe.PURGE_DT is null 
	  JOIN POLICY_ENDORSEMENT pe ON pe.ID = mpe.POLICY_ENDORSEMENT_ID and pe.LENDER_PAY_IN = 'Y' AND pe.PURGE_DT IS NULL
      join LENDER ldr on ldr.ID = mp.LENDER_ID and ldr.PURGE_DT is null
   where ldr.AGENCY_ID = '1'
	  and ldr.TEST_IN = 'N'
      and mp.LENDER_PAY_ENDORSEMENT_ACTIVE_IN = 'Y'
     -- and mp.POLICY_ENDORSEMENT_BILLING_FREQ_CD = @billingFrequency
      and mp.PURGE_DT is null
      and GetDate() between mp.START_DT and mp.END_DT
      and GetDate() between mpa.START_DT and mpa.END_DT
      and GetDate() between mpe.START_DT and mpe.END_DT




	   select distinct mp.LENDER_ID, mp.POLICY_ENDORSEMENT_BILLING_FREQ_CD, mp.LENDER_PAY_ENDORSEMENT_ACTIVE_IN, pe.LENDER_PAY_IN , Pe.id
   from MASTER_POLICY mp
      join MASTER_POLICY_ASSIGNMENT mpa on mpa.MASTER_POLICY_ID = mp.ID and mpa.PURGE_DT is null
      join MASTER_POLICY_ENDORSEMENT mpe on mpe.MASTER_POLICY_ASSIGNMENT_ID = mpa.ID and mpe.PURGE_DT is null 
	  JOIN POLICY_ENDORSEMENT pe ON pe.ID = mpe.POLICY_ENDORSEMENT_ID  AND pe.PURGE_DT IS NULL
      join LENDER ldr on ldr.ID = mp.LENDER_ID and ldr.PURGE_DT is NULL
         where ldr.AGENCY_ID = '1'
	  and ldr.TEST_IN = 'N'
      and mp.LENDER_PAY_ENDORSEMENT_ACTIVE_IN = 'Y'
      --AND mp.POLICY_ENDORSEMENT_BILLING_FREQ_CD = @billingFrequency
      and mp.PURGE_DT is null
      and GetDate() between mp.START_DT and mp.END_DT
      and GetDate() between mpa.START_DT and mpa.END_DT
      and GetDate() between mpe.START_DT and mpe.END_DT
	  


	  SELECT * FROM dbo.POLICY_ENDORSEMENT
	  WHERE ID IN (812,
53,
1497,
1122,
481,
1091,
241)
