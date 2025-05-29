/* (inserted by DPA)
Procedure: Unitrac_Reports.dbo.Report_ExtractReports
*/
WITH CollNum AS  
   ( 
   SELECT LM_MatchLoanId, 
      CM_MatchCollateralId, 
      ROWNUMBER=ROW_NUMBER() OVER (PARTITION BY LM_MatchLoanId ORDER BY CM_MatchCollateralId)  
   FROM #Loans 
   )  
UPDATE Loans  
   SET C_CollateralNumberFix =  
   CASE --When CM_MatchStatus = 'Unmatch'
  
         --	Then 0
  
      WHEN col.STATUS_CD = 'I'  
      OR col.PURGE_DT IS NOT NULL                                                  THEN 0  
      WHEN Loans.LM_MatchLoanId = 0                                                THEN 1  
      WHEN Loans.CM_MatchCollateralId = 0                                          THEN 1  
      WHEN 1 <> IsNumeric(IsNull(RTrim(Loans.C_CollateralNumber), ''))             THEN CollNum.ROWNUMBER  
      WHEN Cast(Loans.C_CollateralNumber As Int) NOT BETWEEN 1 AND CollCount.value THEN  
         CollNum.ROWNUMBER  
      WHEN Exists 
         ( 
         SELECT 1  
         FROM #Loans As Loans2  
         WITH 
            ( 
               NoLock)  
            WHERE Loans2.LM_MatchLoanId = Loans.LM_MatchLoanId  
           AND Loans2.CM_MatchCollateralId <> Loans.CM_MatchCollateralId  
           AND Loans2.C_CollateralNumber = CollCount.value 
            ) THEN CollNum.ROWNUMBER  
         WHEN LM_MatchStatus = 'Match'  
        AND CM_MatchStatus = 'New' THEN CollCount.value  
         WHEN Exists 
            ( 
            SELECT 1  
            FROM #Loans As Loans2  
            WITH 
               ( 
                  NoLock)  
               WHERE Loans2.LM_MatchLoanId = Loans.LM_MatchLoanId  
              AND Loans2.CM_MatchCollateralId <> Loans.CM_MatchCollateralId  
              AND Loans2.C_CollateralNumber = Loans.C_CollateralNumber 
               )                                                               THEN CollNum.ROWNUMBER  
            WHEN Cast(C_CollateralNumber As Int) BETWEEN 1 AND CollCount.value THEN Cast( 
               C_CollateralNumber As Int)  
            ELSE Coalesce(CollNum.ROWNUMBER, Loans.C_CollateralNumber, CollCount.value, 0)  
         END  
      FROM  
         ( 
         SELECT Top 100 Percent *  
         FROM #Loans As Loans  
         ORDER BY Loans.LM_MatchLoanId, 
            CASE Loans.CM_MatchStatus  
               WHEN 'Unmatch' THEN 3  
               WHEN 'New'     THEN 2  
               WHEN 'Match'   THEN 1  
               ELSE 0  
            END, 
            Loans.C_CollateralNumber, 
            Loans.CM_MatchCollateralId 
         ) As Loans CROSS APPLY  
         ( 
         SELECT value=COUNT(*)  
         FROM COLLATERAL As c2  
         WITH 
            ( 
               NOLOCK 
            )  
         LEFT JOIN PROPERTY As p2  
         WITH 
            ( 
               NOLOCK 
            )  
         ON p2.ID = c2.PROPERTY_ID  
         WHERE c2.LOAN_ID = LM_MatchLoanId  
        AND  
            /*c2.EXTRACT_UNMATCH_COUNT_NO = 0 and c2.STATUS_CD <> 'U' and*/  
            c2.STATUS_CD <> 'I'  
        AND p2.RECORD_TYPE_CD <> 'D'  
        AND p2.PURGE_DT IS NULL  
        AND c2.PURGE_DT IS NULL 
         ) As CollCount  
      LEFT JOIN COLLATERAL As col  
      WITH 
         ( 
            NoLock 
         )  
      ON col.LOAN_ID = LM_MatchLoanId  
     AND col.ID = CM_MatchCollateralId  
      LEFT JOIN CollNum  
      WITH 
         ( 
            NOLOCK 
         )  
      ON CollNum.LM_MatchLoanId = Loans.LM_MatchLoanId  
     AND CollNum.CM_MatchCollateralId = Loans.CM_MatchCollateralId --WHERE Exists(Select 1 From  
         -- #Loans As Loans2 Where Loans2.LM_MatchLoanId = Loans.LM_MatchLoanId
  
         --And (Loans.C_CollateralNumber > CollCount.value OR (Loans2.C_CollateralNumber =  
         -- Loans.C_CollateralNumber And Loans2.CM_MatchCollateralId <> Loans.CM_MatchCollateralId) 
         --  OR CollStat.C_STATUS_CD <> 'A')
  
         --)
   
         /* now update CollateralNumber with CollateralNumberFix: */  