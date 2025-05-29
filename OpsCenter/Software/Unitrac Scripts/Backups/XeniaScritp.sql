/* (inserted by DPA)
Character Range: 0 to 5307
Waiting on statement: 

WITH lenders as 
   ( 
   SELECT DISTINCT id, 
      name_tx as Lender_Name, 
      code_tx as Lender_Code 
   FROM lender 
   WHERE lender.test_in = 'N' 
  AND lender.Status_cd in ( 'Audit', 'Active' ) 
  AND lender.purge_dt is null 
   )
   , 
   data as 
   ( 
   SELECT lender.id as lender_id, 
      loan.id as loan_id, 
      c.id as collateral_id, 
      rc.id as coverage_id, 
      loan.balance_amount_no as balance, 
      rc.type_cd as coverage, 
      rc.SUMMARY_STATUS_CD, 
      rc.SUMMARY_SUB_STATUS_CD, 
      cc.ADDRESS_LOOKUP_IN, 
      primary_class_cd, 
      sum(
      CASE cc.primary_class_cd 
         WHEN 'COM' THEN 1000 
         ELSE 
            CASE cc.ADDRESS_LOOKUP_IN 
               WHEN 'Y' THEN 1 
               ELSE 0 
            END 
      END) over (partition by loan.id) as loan_type 
   FROM lender 
   LEFT OUTER JOIN loan 
   ON lender.id = loan.lender_id 
   LEFT OUTER JOIN collateral c 
   ON c.loan_id = loan.id 
   LEFT OUTER JOIN collateral_code cc 
   ON cc.id = c.collateral_code_id 
   LEFT OUTER JOIN PROPERTY p 
   ON c.PROPERTY_ID = p.ID 
   LEFT OUTER JOIN REQUIRED_COVERAGE rc 
   ON rc.PROPERTY_ID = p.id 
   WHERE loan.record_type_cd = 'G' 
  AND p.Record_type_cd = 'G' 
  AND rc.RECORD_TYPE_CD = 'G' 
  AND loan.purge_dt is null 
  AND c.PURGE_DT is null 
  AND p.PURGE_DT is null 
  AND rc.PURGE_DT is null 
  AND loan.status_cd in ('A','B','L','N','T') 
  AND c.Status_cd in ('A','F','K','S','T','X') 
  AND loan.EXTRACT_UNMATCH_COUNT_NO = 0 
  AND c.EXTRACT_UNMATCH_COUNT_NO = 0 
  AND rc.Status_cd <>'I' 
  AND lender.test_in = 'N' 
  AND lender.Status_cd in ( 'Audit', 'Active' ) 
  AND lender.purge_dt is null 
   )
   , 
   Loans as 
   ( 
   SELECT lender_id, 
      count (DISTINCT loan_id) as Total_Loans 
   FROM data 
   GROUP BY lender_id 
   )
   , 
   Collaterals as 
   ( 
   SELECT lender_id, 
      count (DISTINCT collateral_id) as Total_Collateral 
   FROM data 
   GROUP BY lender_id 
   )
   , 
   Coverages as 
   ( 
   SELECT lender_id, 
      count (coverage_id) as Total_Coverages, 
      sum(
      CASE 
         WHEN ADDRESS_LOOKUP_IN <> 'Y' 
        AND primary_class_cd = 'PER' THEN 1 
         ELSE 0 
      END) as Total_Coverages_Vehicle, 
      sum(
      CASE 
         WHEN ADDRESS_LOOKUP_IN <> 'Y' 
        AND primary_class_cd = 'PER' 
        AND SUMMARY_STATUS_CD = 'F' 
        AND SUMMARY_SUB_STATUS_CD = 'C' THEN 1 
         ELSE 0 
      END) as Total_Coverages_Vehicle_Inforce, 
      sum(
      CASE 
         WHEN ADDRESS_LOOKUP_IN = 'Y' 
        AND primary_class_cd = 'PER' THEN 1 
         ELSE 0 
      END) as Total_Coverages_Mortgage, 
      sum(
      CASE 
         WHEN ADDRESS_LOOKUP_IN = 'Y' 
        AND primary_class_cd = 'PER' 
        AND SUMMARY_STATUS_CD = 'F' 
        AND SUMMARY_SUB_STATUS_CD = 'C' THEN 1 
         ELSE 0 
      END) as Total_Coverages_Mortgage_Inforce, 
      sum(
      CASE 
         WHEN coverage = 'HAZARD' THEN 1 
         ELSE 0 
      END) as Total_Coverages_Hazard, 
      sum(
      CASE 
         WHEN coverage = 'HAZARD' 
        AND SUMMARY_STATUS_CD = 'F' 
        AND SUMMARY_SUB_STATUS_CD = 'C' THEN 1 
         ELSE 0 
      END) as Total_Coverages_Hazard_Inforce, 
      sum(
      CASE 
         WHEN coverage = 'FLOOD' THEN 1 
         ELSE 0 
      END) as Total_Coverages_Flood, 
      sum(
      CASE 
         WHEN coverage = 'FLOOD' 
        AND SUMMARY_STATUS_CD = 'F' 
        AND SUMMARY_SUB_STATUS_CD = 'C' THEN 1 
         ELSE 0 
      END) as Total_Coverages_Flood_Inforce 
   FROM data 
   GROUP BY lender_id 
   )
   , 
   Vehicle_Balance_ as 
   ( 
   SELECT DISTINCT lender_id, 
      loan_id, 
      coalesce(balance, 0) as balance 
   FROM data 
   WHERE loan_type = 0 
   )
   , 
   Mortgage_Balance_ as 
   ( 
   SELECT DISTINCT lender_id, 
      loan_id, 
      coalesce(balance, 0) as balance 
   FROM data 
   WHERE loan_type > 0 
  AND loan_type < 1000 
   )
   , 
   Commercial_Balance_ as 
   ( 
   SELECT DISTINCT lender_id, 
      loan_id, 
      coalesce(balance, 0) as balance 
   FROM data 
   WHERE loan_type >= 1000 
   )
   , 
   Vehicle_Balance as 
   ( 
   SELECT lender_id, 
      sum(balance) as Balance, 
      count(loan_id) as cnt 
   FROM Vehicle_Balance_ 
   GROUP BY lender_id 
   )
   , 
   Mortgage_Balance as 
   ( 
   SELECT lender_id, 
      sum(balance) as Balance, 
      count(loan_id) as cnt 
   FROM Mortgage_Balance_ 
   GROUP BY lender_id 
   )
   , 
   Commercial_Balance as 
   ( 
   SELECT lender_id, 
      sum(balance) as Balance, 
      count(loan_id) as cnt 
   FROM Commercial_Balance_ 
   GROUP BY lender_id 
   ) 
SELECT Lender_Name, 
   Lender_Code id, 
   coalesce(Total_Loans, 0) as Total_Loans, 
   coalesce(Total_Collateral, 0) as Total_Collateral, 
   coalesce(Total_Coverages, 0) as Total_Coverages, 
   coalesce(Vehicle_Balance.balance, 0) as Vehicle_Loan_Balance, 
   coalesce(Vehicle_Balance.cnt, 0) as Vehicle_Loan_Count, 
   coalesce(Mortgage_Balance.balance, 0) as Mortgage_Loan_Balance, 
   coalesce(Mortgage_Balance.cnt, 0) as Mortgage_Loan_Count, 
   coalesce(Commercial_Balance.balance, 0) as Commercial_Loan_Balance, 
   coalesce(Commercial_Balance.cnt, 0) as Commercial_Loan_Count, 
   coalesce(Total_Coverages_Vehicle, 0) as Total_Coverages_Vehicle, 
   coalesce(Total_Coverages_Vehicle_Inforce, 0) as Total_Coverages_Vehicle_Inforce, 
   coalesce(Total_Coverages_Mortgage, 0) as Total_Coverages_Mortgage, 
   coalesce(Total_Coverages_Mortgage_Inforce, 0) as Total_Coverages_Mortgage_Inforce, 
   coalesce(Total_Coverages_Hazard, 0) as Total_Coverages_Hazard, 
   coalesce(Total_Coverages_Hazard_Inforce, 0) as Total_Coverages_Hazard_Inforce, 
   coalesce(Total_Coverages_Flood, 0) as Total_Coverages_Flood, 
   coalesce(Total_Coverages_Flood_Inforce, 0) as Total_Coverages_Flood_Inforce 
FROM lenders 
LEFT OUTER JOIN Loans 
ON lenders.id = Loans.lender_id 
LEFT OUTER JOIN Collaterals 
ON lenders.id = Collaterals.lender_id 
LEFT OUTER JOIN Coverages 
ON lenders.id = Coverages.lender_id 
LEFT OUTER JOIN Vehicle_Balance 
ON lenders.id = Vehicle_Balance.lender_id 
LEFT OUTER JOIN Mortgage_Balance 
ON lenders.id = Mortgage_Balance.lender_id 
LEFT OUTER JOIN Commercial_Balance 
ON lenders.id = Commercial_Balance.lender_id 
ORDER BY Lender_Name

*/
 
/* BEGIN ACTIVE SECTION (inserted by DPA) */  
WITH lenders as  
   (  
   SELECT DISTINCT id,  
      name_tx as Lender_Name,  
      code_tx as Lender_Code  
   FROM lender  
   WHERE lender.test_in = 'N'  
  AND lender.Status_cd in ( 'Audit', 'Active' )  
  AND lender.purge_dt is null  
   ) 
   ,  
   data as  
   (  
   SELECT lender.id as lender_id,  
      loan.id as loan_id,  
      c.id as collateral_id,  
      rc.id as coverage_id,  
      loan.balance_amount_no as balance,  
      rc.type_cd as coverage,  
      rc.SUMMARY_STATUS_CD,  
      rc.SUMMARY_SUB_STATUS_CD,  
      cc.ADDRESS_LOOKUP_IN,  
      primary_class_cd,  
      sum( 
      CASE cc.primary_class_cd  
         WHEN 'COM' THEN 1000  
         ELSE  
            CASE cc.ADDRESS_LOOKUP_IN  
               WHEN 'Y' THEN 1  
               ELSE 0  
            END  
      END) over (partition by loan.id) as loan_type  
   FROM lender  
   LEFT OUTER JOIN loan  
   ON lender.id = loan.lender_id  
   LEFT OUTER JOIN collateral c  
   ON c.loan_id = loan.id  
   LEFT OUTER JOIN collateral_code cc  
   ON cc.id = c.collateral_code_id  
   LEFT OUTER JOIN PROPERTY p  
   ON c.PROPERTY_ID = p.ID  
   LEFT OUTER JOIN REQUIRED_COVERAGE rc  
   ON rc.PROPERTY_ID = p.id  
   WHERE loan.record_type_cd = 'G'  
  AND p.Record_type_cd = 'G'  
  AND rc.RECORD_TYPE_CD = 'G'  
  AND loan.purge_dt is null  
  AND c.PURGE_DT is null  
  AND p.PURGE_DT is null  
  AND rc.PURGE_DT is null  
  AND loan.status_cd in ('A','B','L','N','T')  
  AND c.Status_cd in ('A','F','K','S','T','X')  
  AND loan.EXTRACT_UNMATCH_COUNT_NO = 0  
  AND c.EXTRACT_UNMATCH_COUNT_NO = 0  
  AND rc.Status_cd <>'I'  
  AND lender.test_in = 'N'  
  AND lender.Status_cd in ( 'Audit', 'Active' )  
  AND lender.purge_dt is null  
   ) 
   ,  
   Loans as  
   (  
   SELECT lender_id,  
      count (DISTINCT loan_id) as Total_Loans  
   FROM data  
   GROUP BY lender_id  
   ) 
   ,  
   Collaterals as  
   (  
   SELECT lender_id,  
      count (DISTINCT collateral_id) as Total_Collateral  
   FROM data  
   GROUP BY lender_id  
   ) 
   ,  
   Coverages as  
   (  
   SELECT lender_id,  
      count (coverage_id) as Total_Coverages,  
      sum( 
      CASE  
         WHEN ADDRESS_LOOKUP_IN <> 'Y'  
        AND primary_class_cd = 'PER' THEN 1  
         ELSE 0  
      END) as Total_Coverages_Vehicle,  
      sum( 
      CASE  
         WHEN ADDRESS_LOOKUP_IN <> 'Y'  
        AND primary_class_cd = 'PER'  
        AND SUMMARY_STATUS_CD = 'F'  
        AND SUMMARY_SUB_STATUS_CD = 'C' THEN 1  
         ELSE 0  
      END) as Total_Coverages_Vehicle_Inforce,  
      sum( 
      CASE  
         WHEN ADDRESS_LOOKUP_IN = 'Y'  
        AND primary_class_cd = 'PER' THEN 1  
         ELSE 0  
      END) as Total_Coverages_Mortgage,  
      sum( 
      CASE  
         WHEN ADDRESS_LOOKUP_IN = 'Y'  
        AND primary_class_cd = 'PER'  
        AND SUMMARY_STATUS_CD = 'F'  
        AND SUMMARY_SUB_STATUS_CD = 'C' THEN 1  
         ELSE 0  
      END) as Total_Coverages_Mortgage_Inforce,  
      sum( 
      CASE  
         WHEN coverage = 'HAZARD' THEN 1  
         ELSE 0  
      END) as Total_Coverages_Hazard,  
      sum( 
      CASE  
         WHEN coverage = 'HAZARD'  
        AND SUMMARY_STATUS_CD = 'F'  
        AND SUMMARY_SUB_STATUS_CD = 'C' THEN 1  
         ELSE 0  
      END) as Total_Coverages_Hazard_Inforce,  
      sum( 
      CASE  
         WHEN coverage = 'FLOOD' THEN 1  
         ELSE 0  
      END) as Total_Coverages_Flood,  
      sum( 
      CASE  
         WHEN coverage = 'FLOOD'  
        AND SUMMARY_STATUS_CD = 'F'  
        AND SUMMARY_SUB_STATUS_CD = 'C' THEN 1  
         ELSE 0  
      END) as Total_Coverages_Flood_Inforce  
   FROM data  
   GROUP BY lender_id  
   ) 
   ,  
   Vehicle_Balance_ as  
   (  
   SELECT DISTINCT lender_id,  
      loan_id,  
      coalesce(balance, 0) as balance  
   FROM data  
   WHERE loan_type = 0  
   ) 
   ,  
   Mortgage_Balance_ as  
   (  
   SELECT DISTINCT lender_id,  
      loan_id,  
      coalesce(balance, 0) as balance  
   FROM data  
   WHERE loan_type > 0  
  AND loan_type < 1000  
   ) 
   ,  
   Commercial_Balance_ as  
   (  
   SELECT DISTINCT lender_id,  
      loan_id,  
      coalesce(balance, 0) as balance  
   FROM data  
   WHERE loan_type >= 1000  
   ) 
   ,  
   Vehicle_Balance as  
   (  
   SELECT lender_id,  
      sum(balance) as Balance,  
      count(loan_id) as cnt  
   FROM Vehicle_Balance_  
   GROUP BY lender_id  
   ) 
   ,  
   Mortgage_Balance as  
   (  
   SELECT lender_id,  
      sum(balance) as Balance,  
      count(loan_id) as cnt  
   FROM Mortgage_Balance_  
   GROUP BY lender_id  
   ) 
   ,  
   Commercial_Balance as  
   (  
   SELECT lender_id,  
      sum(balance) as Balance,  
      count(loan_id) as cnt  
   FROM Commercial_Balance_  
   GROUP BY lender_id  
   )  
SELECT Lender_Name,  
   Lender_Code id,  
   coalesce(Total_Loans, 0) as Total_Loans,  
   coalesce(Total_Collateral, 0) as Total_Collateral,  
   coalesce(Total_Coverages, 0) as Total_Coverages,  
   coalesce(Vehicle_Balance.balance, 0) as Vehicle_Loan_Balance,  
   coalesce(Vehicle_Balance.cnt, 0) as Vehicle_Loan_Count,  
   coalesce(Mortgage_Balance.balance, 0) as Mortgage_Loan_Balance,  
   coalesce(Mortgage_Balance.cnt, 0) as Mortgage_Loan_Count,  
   coalesce(Commercial_Balance.balance, 0) as Commercial_Loan_Balance,  
   coalesce(Commercial_Balance.cnt, 0) as Commercial_Loan_Count,  
   coalesce(Total_Coverages_Vehicle, 0) as Total_Coverages_Vehicle,  
   coalesce(Total_Coverages_Vehicle_Inforce, 0) as Total_Coverages_Vehicle_Inforce,  
   coalesce(Total_Coverages_Mortgage, 0) as Total_Coverages_Mortgage,  
   coalesce(Total_Coverages_Mortgage_Inforce, 0) as Total_Coverages_Mortgage_Inforce,  
   coalesce(Total_Coverages_Hazard, 0) as Total_Coverages_Hazard,  
   coalesce(Total_Coverages_Hazard_Inforce, 0) as Total_Coverages_Hazard_Inforce,  
   coalesce(Total_Coverages_Flood, 0) as Total_Coverages_Flood,  
   coalesce(Total_Coverages_Flood_Inforce, 0) as Total_Coverages_Flood_Inforce  
FROM lenders  
LEFT OUTER JOIN Loans  
ON lenders.id = Loans.lender_id  
LEFT OUTER JOIN Collaterals  
ON lenders.id = Collaterals.lender_id  
LEFT OUTER JOIN Coverages  
ON lenders.id = Coverages.lender_id  
LEFT OUTER JOIN Vehicle_Balance  
ON lenders.id = Vehicle_Balance.lender_id  
LEFT OUTER JOIN Mortgage_Balance  
ON lenders.id = Mortgage_Balance.lender_id  
LEFT OUTER JOIN Commercial_Balance  
ON lenders.id = Commercial_Balance.lender_id  
ORDER BY Lender_Name 
/* END ACTIVE SECTION (inserted by DPA) */  