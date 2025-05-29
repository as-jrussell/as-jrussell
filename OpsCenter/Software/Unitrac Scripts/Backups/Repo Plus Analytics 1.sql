With 
_ivos_referrals as (
Select 
Row_Number() over(Partition By Claim_ID order by add_date desc) as myRank,* from [IVOS-DB01].[IVOS].[dbo].referral
),
ivos_referrals as (
Select * from _ivos_referrals
where myRank = 1
),
Claim_data as (
Select 
claim.claim_id,
claim.claim_number,
claim.claim_status_code,
claim_status.claim_status_desc,
claimant.claimant_type_code,
claimant_type.claimant_type_desc,
vehicle_recovery.vehicle_recovery_method_code,
vehicle_recovery_method.vehicle_recovery_method_desc,
insured.insured_name1 as lender_name,
vehicle_identification_number as VIN,
claim.incident_date as 'loss_date',
claim.incident_reported_date,
claim.file_transfer_date as claim_setup_date,
CASE When outside_examiner = 'Repo Plus'
  Then 'Auto'
  else 'Manual' end as Setup_Type,
claim.file_loc_code as Setup_specialist_code,
file_loc.file_loc_desc as Setup_Specialist,
claimant.examiner2_code as Adjuster,
 vehicle_recovery_max.vehicle_recovery_status_code,
 vehicle_recovery_status.vehicle_recovery_status_desc,
 referral.referral_type_code as Carrier_Name_code,
referral_type.referral_type_desc as Carrier_Name,
referral.state_code as Carrier_State_Code,
referral.zip_code as Carrier_Zip_Code,
referral.provider_name as Claim_Handler,
vehicle_recovery_allocation.loss_amount1 as damage_amount,
vehicle_recovery_allocation.maximum_claimant_billed_amount as demand_amount,
vehicle_recovery.amount as recovery_amount,
vehicle_recovery.check_date as recovery_date,  /* I believe that add_date is correct */
vehicle.assigned_asset_owner,
claimant.delayed_decision_date as closed_date

 from [IVOS-DB01].[IVOS].[dbo].claim claim
 left outer join [IVOS-DB01].[IVOS].[dbo].claim_status claim_status on claim_status.claim_status_code = claim.claim_status_code
left outer join [IVOS-DB01].[IVOS].[dbo].claimant claimant on claimant.claim_id = claim.claim_id
left outer join [IVOS-DB01].[IVOS].[dbo].claimant_type claimant_type on claimant_type.claimant_type_code = claimant.claimant_type_code
left outer join [IVOS-DB01].[IVOS].[dbo].vehicle_recovery_max vehicle_recovery_max on vehicle_recovery_max.claim_id = claim.claim_id
left outer join [IVOS-DB01].[IVOS].[dbo].vehicle_recovery vehicle_recovery on vehicle_recovery.claim_id = claim.claim_id
left outer join [IVOS-DB01].[IVOS].[dbo].vehicle vehicle on vehicle.claim_id = claim.claim_id

left outer join [IVOS-DB01].[IVOS].[dbo].vehicle_recovery_method vehicle_recovery_method on vehicle_recovery_method.vehicle_recovery_method_code = vehicle_recovery.vehicle_recovery_method_code
left outer join [IVOS-DB01].[IVOS].[dbo].vehicle_recovery_status vehicle_recovery_status on vehicle_recovery_status.vehicle_recovery_status_code = vehicle_recovery_max.vehicle_recovery_status_code

left outer join [IVOS-DB01].[IVOS].[dbo].file_loc file_loc on file_loc.file_loc_code = claim.file_loc_code

left outer join ivos_referrals referral on referral.claim_id = claim.claim_id
left outer join [IVOS-DB01].[IVOS].[dbo].referral_type referral_type on referral_type.referral_type_code = referral.referral_type_code

left outer join [IVOS-DB01].[IVOS].[dbo].vehicle_recovery_allocation vehicle_recovery_allocation on vehicle_recovery_allocation.claim_id = claim.claim_id

LEFT OUTER JOIN [IVOS-DB01].[IVOS].[dbo].coverage coverage ON claimant.coverage_id = coverage.coverage_id
LEFT OUTER JOIN [IVOS-DB01].[IVOS].[dbo].policy policy ON coverage.policy_id = policy.policy_id
LEFT OUTER JOIN [IVOS-DB01].[IVOS].[dbo].insured_name_type insured_name_type ON policy.policy_id = insured_name_type.policy_id
LEFT OUTER JOIN [IVOS-DB01].[IVOS].[dbo].insured insured ON insured_name_type.insured_id = insured.insured_id

where 1=1   
and vehicle_recovery.vehicle_recovery_method_code = 4
and claimant.claimant_type_code in (69,50,71,73,75,83)
and claim.claim_status_code in (5,1,2)
and claim.incident_reported_date > '6/30/2014'
and vehicle_recovery_max.vehicle_recovery_status_code NOT in (35,37)

),
recovery_data as (
Select 
claim_id,
sum (Coalesce(recovery_amount,0)) as sum_recovery_amount,
max(recovery_date) as  Last_recovery_date,
min(recovery_date) as  first_recovery_date

from claim_data
Where Coalesce(recovery_amount,0) != 0

group by claim_id
), ivos_data as (
Select DISTINCT 
claim_data.claim_id,
claim_number,
claim_status_code,
claim_status_desc,
claimant_type_code,
claimant_type_desc,
vehicle_recovery_method_code,
vehicle_recovery_method_desc,
lender_name,
VIN,
loss_date,
incident_reported_date,
claim_setup_date,
Setup_Type,
Setup_specialist_code,
Setup_Specialist,
Adjuster,
vehicle_recovery_status_code,
vehicle_recovery_status_desc,
Carrier_Name_code,
Carrier_Name,
Carrier_State_Code,
Carrier_Zip_Code,
Claim_Handler,
damage_amount,
demand_amount,
sum_recovery_amount,
first_recovery_date,
Last_recovery_date,
assigned_asset_owner,
closed_date

From claim_data
Left outer join recovery_data on recovery_data.claim_id = claim_data.claim_id
/* order by claim_id   */
)

Select DISTINCT
/* ivos_data.claim_id as Claim_ID,   */
ivos_data.claim_number as Claim_Number,
/* ivos_data.claim_status_code,  */
ivos_data.claim_status_desc as Claim_Status,
/* ivos_data.claimant_type_code,  */
ivos_data.claimant_type_desc as Claim_Type,
/* ivos_data.vehicle_recovery_method_code,  */
/* ivos_data.vehicle_recovery_method_desc as Recovery_Method,  */
ivos_data.lender_name as Lender_Name,
COALESCE(HLID.Lender_Branch,'') as Lender_Branch,
COALESCE(HLID.Lender_Dealer,'') as Lender_Dealer,
HLID.Loan_Effective_Date,
CASE WHEN (ISDATE(Loan_Effective_Date) = 1 AND ISDATE(Claim_setup_Date) = 1)
 Then Cast(DateDiff(d,cast(Loan_effective_date as date),cast(claim_setup_date as date)) as nvarchar(10))
 Else  ''  end as Loan_Inception_Days,
HLID.Loan_Balance, 
COALESCE(ivos_data.VIN,'') as VIN,
COALESCE(HLID.Vehicle_Year,'') as Vehicle_Year,
COALESCE(HLID.Vehicle_Make,'') as Vehicle_Make,
COALESCE(HLID.Vehicle_Model,'') as Vehicle_Model,
COALESCE(BorrReg.Default_Region,'') as Borrower_Region,
COALESCE(HLID.Borrowers_State,'') as Borrowers_State,
COALESCE(HLID.Borrowers_Postal_Code,'') as Borrowers_Postal_Code,
/*  ivos_data.loss_date as Loss_Date_old,    */
Case WHEN ISDATE(ivos_data.loss_date) = 1
 THEN Cast(Cast(ivos_data.loss_date as DATE) as nvarchar(10)) 
 ELSE ''   End as Loss_Date,  

/* ivos_data.incident_reported_date as Report_Date_old,   */
Case WHEN ISDATE(ivos_data.incident_reported_date) = 1
 THEN Cast(Cast(ivos_data.incident_reported_date as DATE) as nvarchar(10)) 
 ELSE ''   End as Report_Date,  

COALESCE(HLID.Auction_Name,'') as Auction_Name,
COALESCE(HLID.Auction_State,'') as Auction_State,
COALESCE(HLID.Auction_ZipCode,'') as Auction_ZipCode,
COALESCE(HLID.Damage_Amount,'') as Damage_Estimate,
/* COALESCE(HLID.Vehicle_Grade,'') as Vehicle_Grade_Old,   */
/*VEHICLE GRADE - stripping out numeric value) */
case coalesce(patindex('%[^0-9.-]%', stuff(HLID.Vehicle_Grade, 1, patindex('%[0-9]%', HLID.Vehicle_Grade)-1, '')), 0)
when 0 then coalesce(stuff(HLID.Vehicle_Grade, 1, patindex('%[0-9]%', HLID.Vehicle_Grade)-1, ''), '')
else LEFT(stuff(HLID.Vehicle_Grade, 1, patindex('%[0-9]%', HLID.Vehicle_Grade)-1, ''), coalesce(patindex('%[^0-9.-]%', stuff(HLID.Vehicle_Grade, 1, patindex('%[0-9]%', HLID.Vehicle_Grade)-1, '')), 0) - 1)
end as Vehicle_Grade,

/* ivos_data.claim_setup_date as Claim_Setup_Date_old,   */
Case WHEN ISDATE(ivos_data.claim_setup_date) = 1
 THEN Cast(Cast(ivos_data.claim_setup_date as DATE) as nvarchar(10)) 
 ELSE ''   End as Claim_Setup_Date ,         
Case WHEN ISDATE(ivos_data.claim_setup_date) = 1
 THEN cast(DATEPART(YYYY,ivos_data.claim_setup_date) as nvarchar(10))
 ELSE ''   End as Claim_Setup_Date_YEAR, 
Case WHEN ISDATE(ivos_data.claim_setup_date) = 1
 THEN cast(DATEPART(MM,ivos_data.claim_setup_date) as nvarchar(10))
 ELSE ''   End as Claim_Setup_Date_MONTH ,

ivos_data.Setup_Type as Claim_Setup_Type,
/* ivos_data.Setup_specialist_code,  */
COALESCE(ivos_data.Setup_Specialist,'') as Setup_Specialist,
COALESCE(ivos_data.Adjuster,'') as Adjuster,
/* ivos_data.vehicle_recovery_status_code,  */
ivos_data.vehicle_recovery_status_desc as Recovery_Status,
/* ivos_data.Carrier_Name_code,  */
ivos_data.Carrier_Name,
CarrReg.Default_Region as Carrier_Region,
COALESCE(cast(ivos_data.Carrier_State_Code as nvarchar(20)),'') as Carrier_State_Code,
COALESCE(cast(ivos_data.Carrier_Zip_Code as nvarchar(20)),'') as Carrier_Zip_Code,
COALESCE(ivos_data.Claim_Handler,'')  as Claim_Handler,
/* COALESCE(Convert(varchar,HLID.Policy_Effective_Date,101),'') as Policy_Effective_Date_old,   */
Case WHEN ISDATE(HLID.Borrowers_Insurance_Effective_Date) = 1
 THEN Cast(Cast(HLID.Borrowers_Insurance_Effective_Date as DATE) as nvarchar(10)) 
 ELSE ''   End as Policy_Effective_Date, 
/* COALESCE(Convert(varchar,HLID.Policy_Cancellation_Date,101),'') as HLID.Policy_Cancellation_Date_old,  */
Case WHEN ISDATE(HLID.Borrowers_Insurance_Cancellation_Date) = 1
 THEN Cast(Cast(HLID.Borrowers_Insurance_Cancellation_Date as DATE) as nvarchar(10)) 
 ELSE ''   End as Policy_Cancellation_Date, 


/* COALESCE(Convert(varchar,HLID.Policy_Expiration_Date,101),'') as Policy_Expiration_Date_old,  */
Case WHEN ISDATE(HLID.Borrowers_Insurance_Expiration_Date) = 1
 THEN Cast(Cast(HLID.Borrowers_Insurance_Expiration_Date as DATE) as nvarchar(10)) 
 ELSE ''   End as Policy_Expiration_Date, 


COALESCE(cast(ivos_data.damage_amount as nvarchar(20)),'') as Damage_Amount,
COALESCE(cast(ivos_data.demand_amount as nvarchar(20)),'') as Demand_Amount,
COALESCE(cast(ivos_data.sum_recovery_amount as nvarchar(20)),'') as Recovery_Amount,
/*  COALESCE(Convert(varchar,ivos_data.assigned_asset_owner,101),'') as Appraisal_Rec_Date_old,  */
Case WHEN ISDATE(ivos_data.assigned_asset_owner) = 1
 THEN Cast(Cast(ivos_data.assigned_asset_owner as DATE) as nvarchar(10)) 
 ELSE ''   End as Appraisal_Rec_Date, 


/* COALESCE(Convert(varchar,ivos_data.first_recovery_date,101),'') as First_Recovery_Date_old,  */
Case WHEN ISDATE(ivos_data.first_recovery_date) = 1
 THEN Cast(Cast(ivos_data.first_recovery_date as DATE) as nvarchar(10)) 
 ELSE ''   End as First_Recovery_Date ,         
Case WHEN ISDATE(ivos_data.first_recovery_date) = 1
 THEN cast(DATEPART(YYYY,ivos_data.first_recovery_date) as nvarchar(10))
 ELSE ''   End as First_Recovery_Date_YEAR, 
Case WHEN ISDATE(ivos_data.first_recovery_date) = 1
 THEN cast(DATEPART(MM,ivos_data.first_recovery_date) as nvarchar(10))
 ELSE ''   End as First_Recovery_Date_MONTH ,
COALESCE(Convert(varchar,ivos_data.Last_recovery_date,101),'') as Last_Recovery_Date,
/* COALESCE(cast(DATEDIFF(D,ivos_data.claim_setup_date,ivos_data.first_recovery_date)as varchar(10)),'')  as Cycle_Time_Days_old,   */
Case WHEN (ISDATE(ivos_data.claim_setup_date) = 1 AND ISDATE(ivos_data.first_recovery_date) = 1)
 THEN cast(DATEDIFF(D,ivos_data.claim_setup_date,ivos_data.first_recovery_date)as varchar(10))
 WHEN (ISDATE(ivos_data.claim_setup_date) = 1 AND ISDATE(ivos_data.closed_date) = 1)
 THEN cast(DATEDIFF(D,ivos_data.claim_setup_date,ivos_data.closed_date)as varchar(10))
 ELSE '' END as Cycle_Time_Days,

/* COALESCE(Convert(varchar,ivos_data.closed_date,101),'') as Closed_Date_old,  */
Case WHEN ISDATE(ivos_data.closed_date) = 1
 THEN Cast(Cast(ivos_data.closed_date as DATE) as nvarchar(10)) 
 ELSE ''   End as Close_Date ,         
Case WHEN ISDATE(ivos_data.closed_date) = 1
 THEN cast(DATEPART(YYYY,ivos_data.closed_date) as nvarchar(10))
 ELSE ''   End as Close_Date_YEAR, 
Case WHEN ISDATE(ivos_data.closed_date) = 1
 THEN cast(DATEPART(MM,ivos_data.closed_date) as nvarchar(10))
 ELSE ''   End as Close_Date_MONTH 



FROM ivos_data
Left outer join [ALLIED-PIMSDB].RepoPlusAnalytics.dbo.HistoricalLoanInsData HLID on HLID.Claim_ID = ivos_data.claim_id

Left outer join State_Codes BorrReg on BorrReg.State_Code = HLID.Borrowers_State
Left outer join State_Codes CarrReg on CarrReg.State_Code = ivos_data.Carrier_State_Code


order by Claim_Number