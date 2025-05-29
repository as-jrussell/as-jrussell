use IVOS


--SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED; 
/* BEGIN ACTIVE SECTION (comment inserted by DPA) */  
--WITH data as  
  -- (  
   SELECT vehicle_recovery_alloc_log.claim_ID as id,  
      insured.insured_name1 as LenderName,  
      claim.claim_number as ClaimNumber,  
      vehicle_recovery_status.vehicle_recovery_status_desc as RecoveryStatus,  
      claim.examiner_code AS Adjuster,  
      claimant.claimant_name as BorrowerName,  
      vehicle.vehicle_identification_number as VIN,  
      insurer.insurer_name as InsuranceCarrier,  
      policy.policy_number as PolicyNumber,  
      vehicle_recovery_allocation.loss_amount as DamageAmount,  
      vehicle_recovery_allocation.maximum_claimant_billed_amount as DemandAmount,  
      coalesce(vehicle_recovery_alloc_log.vehicle_recovery_status_code, -1) as status,  
      vehicle_recovery_alloc_log.edit_date as date,  
      ROW_NUMBER() over (partition by vehicle_recovery_alloc_log.claim_ID order by  
      vehicle_recovery_alloc_log.edit_date, log_ID) as rn 
INTO #data	  
   FROM vehicle_recovery_alloc_log  
   INNER JOIN claim  
   ON vehicle_recovery_alloc_log.claim_id = claim.claim_id  
   LEFT OUTER JOIN examiner  
   ON claim.examiner_code = examiner.examiner_code  
   LEFT OUTER JOIN jurisdiction  
   ON claim.jurisdiction_code = jurisdiction.jurisdiction_code  
   INNER JOIN claimant  
   ON claim.claim_id = claimant.claim_id  
   LEFT OUTER JOIN employment  
   ON claimant.claimant_id = employment.claimant_id  
   LEFT OUTER JOIN work_comp_claimant  
   ON claimant.claimant_id = work_comp_claimant.claimant_id  
   LEFT OUTER JOIN claimant_status  
   ON claimant.claimant_status_code = claimant_status.claimant_status_code  
   LEFT OUTER JOIN claimant_type  
   ON claimant.claimant_type_code = claimant_type.claimant_type_code  
  AND claimant.client_code = claimant_type.client_code  
  AND claimant.insurance_type = claimant_type.insurance_type  
   INNER JOIN multiple_policy_claim  
   ON claim.claim_id = multiple_policy_claim.claim_id  
   LEFT OUTER JOIN file_loc  
   ON claim.file_loc_code = file_loc.file_loc_code  
   INNER JOIN policy  
   ON multiple_policy_claim.policy_id = policy.policy_id  
   LEFT OUTER JOIN insurer  
   ON policy.insurer_number = insurer.insurer_number  
   INNER JOIN insured_name_type  
   ON policy.policy_id = insured_name_type.policy_id  
   INNER JOIN insured  
   ON insured_name_type.insured_id = insured.insured_id  
   LEFT OUTER JOIN insured_group  
   ON insured.insured_group_id = insured_group.insured_group_id  
   LEFT OUTER JOIN vehicle_recovery  
   ON claimant.claimant_id = vehicle_recovery.claimant_id  
   LEFT OUTER JOIN vehicle_recovery_allocation  
   ON claim.claim_id = vehicle_recovery_allocation.claim_id  
   LEFT OUTER JOIN vehicle_recovery_closing  
   ON vehicle_recovery_allocation.vehicle_recovery_closing_code =  
      vehicle_recovery_closing.vehicle_recovery_closing_code  
   LEFT OUTER JOIN vehicle_recovery_method  
   ON vehicle_recovery.vehicle_recovery_method_code =  
      vehicle_recovery_method.vehicle_recovery_method_code  
   LEFT OUTER JOIN vehicle_recovery_status  
   ON vehicle_recovery_allocation.vehicle_recovery_status_code =  
      vehicle_recovery_status.vehicle_recovery_status_code  
   LEFT OUTER JOIN vehicle  
   ON claim.claim_id = vehicle.claim_id  
   WHERE claimant.claimant_type_code in (50,69,71,73,75)  
  AND claim.insurance_type = 6  
  AND claim.claim_status_code in (1,2)  
  AND claimant.claimant_status_code in (1,2)  
  -- ) 
   --,  
   --data_filtered as  
   --(  
   SELECT d1.id,  
      d1.LenderName, 
      d1.ClaimNumber, 
      d1.RecoveryStatus, 
      d1.Adjuster, 
      d1.BorrowerName, 
      d1.VIN, 
      d1.InsuranceCarrier, 
      d1.PolicyNumber, 
      d1.DamageAmount, 
      d1.DemandAmount, 
      d1.status,  
      d1.date,  
      ROW_NUMBER() over (partition by d1.id order by d1.date, d1.rn) as rn  
 INTO #data_filtered
 FROM #data d1  
   LEFT OUTER JOIN #data d2  
   ON d1.id = d2.id  
  AND d1.rn - 1= d2.rn  
   WHERE d1.status <> coalesce(d2.status, -2)  
--   )  
SELECT df1.id as [ID|TextFormat],  
   df1.LenderName as [Lender Name|TextFormat],  
   '' + df1.ClaimNumber as [Claim Number|TextFormat],  
   df1.RecoveryStatus as [Recovery Status|TextFormat],  
   df1.Adjuster as [Adjuster|TextFormat],  
   df1.BorrowerName [Borrower Name|TextFormat],  
   df1.VIN as [VIN|TextFormat],  
   df1.InsuranceCarrier as [Insurance Carrier|TextFormat],  
   '' + df1.PolicyNumber as [Policy Number|TextFormat],  
   coalesce(df1.DamageAmount, 0) as [Damage Amount|CurrencyFormatBlankZero],  
   coalesce(df1.DemandAmount, 0) as [Demand Amount|CurrencyFormatBlankZero],  
   coalesce(vrs.vehicle_recovery_status_desc, 'No status assigned') as [Status|TextFormat],  
   convert(varchar(10), df1.date, 101) as [Status_Begin|DateFormat],  
   coalesce(convert(varchar(max), df2.date, 101), 'Currently in this status') as  
   [Status_End|DateFormat],  
   CAST(DATEDIFF(DAY, df1.date, coalesce(df2.date, getdate())) as varchar(max)) as  
   [Days_In_Status|TextFormat]  
FROM #data_filtered df1  
LEFT OUTER JOIN #data_filtered df2  
ON df1.id = df2.id  
AND df1.rn + 1= df2.rn  
LEFT OUTER JOIN vehicle_recovery_status vrs  
ON vrs.vehicle_recovery_status_code = df1.status  
WHERE 1=1  
AND (df1.LenderName like '%American Credit Acceptance%'  
OR df1.LenderName like '%United Auto Credit%'  
OR df1.LenderName like '%Santander%'  
OR df1.LenderName like '%Global Lending Services%'  
OR df1.LenderName like '%Skopos%')  
ORDER BY df1.id,  
   df1.rn 
/* END ACTIVE SECTION (comment inserted by DPA) */  
   ;  
--SET TRANSACTION ISOLATION LEVEL READ COMMITTED;


DROP TABLE #data
DROP TABLE #data_filtered