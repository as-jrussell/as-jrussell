USE UniTrac 

DECLARE  
@START_DT  
as  
   date =  
   case cast('Dec  7 1902 12:00AM'  
   as  
      date)  
   when cast('1/1/1900'  
   as  
      date) then  
      cast('1/1/1900'  
   as  
      date)  
      else  
      cast('Dec  7 1902 12:00AM'  
   as  
      date)  
   end;  
   DECLARE  
   @END_DT  
as  
   date =  
   case cast('Jan  5 2034 12:00AM'  
   as  
      date)  
   when cast('1/1/1900'  
   as  
      date) then  
      cast('1/1/2099'  
   as  
      date)  
      else  
      cast('Jan  5 2034 12:00AM'  
   as  
      date)  
   end; 
/* BEGIN ACTIVE SECTION (comment inserted by DPA) */  
   WITH rd1 as  
      (  
      SELECT RELATE_ID,  
         VALUE_TX  
      FROM RELATED_DATA  
      LEFT OUTER JOIN RELATED_DATA_DEF  
      ON RELATED_DATA_DEF.ID = RELATED_DATA.DEF_ID  
      WHERE 1=1  
     AND RELATED_DATA_DEF.RELATE_CLASS_NM = 'Loan'  
     AND RELATED_DATA_DEF.Name_tx = 'Misc1'  
      ) 
      ,  
      rd2 as  
      (  
      SELECT RELATE_ID,  
         VALUE_TX  
      FROM RELATED_DATA  
      LEFT OUTER JOIN RELATED_DATA_DEF  
      ON RELATED_DATA_DEF.ID = RELATED_DATA.DEF_ID  
      WHERE 1=1  
     AND RELATED_DATA_DEF.RELATE_CLASS_NM = 'Loan'  
     AND RELATED_DATA_DEF.Name_tx = 'Misc2'  
      ) 
      ,  
      data as  
      (  
      SELECT LENDER.CODE_TX as [Lender ID|TextFormat],  
         LENDER.NAME_TX as [Lender Name|TextFormat],  
         coalesce(loan.BRANCH_CODE_TX,'') AS [Branch Number|TextFormat],  
         '''' + LOAN.NUMBER_TX AS [Account Number|TextFormat],  
         coalesce(BALANCE_AMOUNT_NO, 0) as [Loan Balance|CurrencyFormat],  
         coalesce(convert(varchar(10), LOAN.EFFECTIVE_DT, 101), '') as  
         [Origination Date|DateFormat],  
         coalesce(convert(varchar(10), LOAN.MATURITY_DT, 101), '') as [Maturity Date|DateFormat],  
         coalesce(LOAN.OFFICER_CODE_TX,'') as [Loan Officer|TextFormat],  
         coalesce('''' + cast(c.COLLATERAL_CODE_ID as varchar(max)), '') as  
         [Collateral ID|TextFormat],  
         coalesce('''' + cast(C.COLLATERAL_NUMBER_NO as varchar(max)), '') AS  
         [Collateral Number|TextFormat],  
         coalesce(cc.description_tx, '') as [Collateral Type|TextFormat],  
         coalesce(O.LAST_NAME_TX, '') AS [Borrower Last Name|TextFormat],  
         coalesce(O.MIDDLE_INITIAL_TX,'') AS [Borrower Middle Name|TextFormat],  
         coalesce(O.FIRST_NAME_TX,'') AS [Borrower First Name|TextFormat],  
         coalesce(AO.LINE_1_TX, '') AS [Borrower Address 1|TextFormat],  
         coalesce(AO.LINE_2_TX, '') AS [Borrower Address 2|TextFormat],  
         coalesce(AO.CITY_TX, '') AS [Borrower City|TextFormat],  
         coalesce(AO.STATE_PROV_TX, '') AS [Borrower State|TextFormat],  
         coalesce('''' + AO.POSTAL_CODE_TX, '') AS [Borrower Zip|TextFormat],  
         coalesce(O.HOME_PHONE_TX,'') AS [Borrower Home Phone|Phone Number],  
         coalesce(O.CELL_PHONE_TX,'') AS [Borrower Cell Phone|Phone Number],  
         coalesce(O.EMAIL_TX,'') AS [Borrower Email|TextFormat],  
         coalesce(NTC.sequence_no, 0) as [Notice Sequence|WholeNumberFormatBlankZero],  
         coalesce(NTC.Name_TX, '') as [Notice Type|TextFormat],  
         coalesce(P.YEAR_TX, '') as [Collateral Year|TextFormat],  
         coalesce(P.MAKE_TX, '') as [Collateral Make|TextFormat],  
         coalesce(P.MODEL_TX, '') as [Collateral Model|TextFormat],  
         coalesce(P.VIN_TX, '') as [VIN|TextFormat],  
         coalesce(ap.line_1_tx, '') as [Property Address 1|TextFormat],  
         coalesce(ap.line_2_tx, '') as [Property Address 2|TextFormat],  
         coalesce(ap.city_tx, '') as [Property City|TextFormat],  
         coalesce(ap.STATE_PROV_TX, '') as [Property State|TextFormat],  
         coalesce('''' + ap.Postal_code_tx, '') as [Property Zip|TextFormat],  
         RC.Type_CD as [Required Coverage|TextFormat],  
         coalesce('''' + owner_policy.POLICY_NUMBER_TX, '') as [Policy Number|TextFormat],  
         coalesce(convert(varchar(10), coalesce(owner_policy.MOST_RECENT_EFFECTIVE_DT,  
         owner_policy.EFFECTIVE_DT), 101), '') as [Policy Effective Date|DateFormat],  
         coalesce(convert(varchar(10), owner_policy.cancellation_DT, 101), '') as  
         [Policy Cancel Date|DateFormat],  
         coalesce(convert(varchar(10),  
         CASE year(owner_policy.EXPIRATION_DT)  
            WHEN 9999 THEN null  
            ELSE owner_policy.EXPIRATION_DT  
         END, 101), '') as [Policy Expiration Date|DateFormat],  
         coalesce(convert(varchar(10), OWNER_POLICY.MOST_RECENT_MAIL_DT, 101), '') AS  
         [Policy Doc Date|DateFormat],  
         coalesce(convert(varchar(10), OWNER_POLICY.CREATE_DT, 101), '') AS  
         [Policy Batch Date|DateFormat],  
         coalesce(RCOPS.MEANING_TX, '') as [Policy Status|TextFormat],  
         coalesce(BIC.NAME, owner_policy.BIC_NAME_TX, '') AS [Insurer|TextFormat],  
         coalesce(RC03.MEANING_TX,'') as [Required Coverage Status|TextFormat],  
         CASE RC01.CODE_CD  
            WHEN 'X'  THEN ''  
            WHEN 'XH' THEN ''  
            ELSE coalesce(RC01.MEANING_TX,'')  
         END as [Required Coverage Ins Status|TextFormat],  
         coalesce(RC02.MEANING_TX,'') as [Required Coverage Ins Sub Status|TextFormat],  
         CASE  
            WHEN RC.STATUS_CD = 'W' THEN RC.UPDATE_USER_TX  
            ELSE ''  
         END AS [Waived|TextFormat],  
         RC.REQUIRED_AMOUNT_NO AS [Required Coverage Amount|CurrencyFormat],  
         replace(ISNULL(ISNULL(BIA.AGENT_TX,BIA.NAME_TX),''), '~', '-') AS [Agent Name|TextFormat], 
         ISNULL(BIA.PHONE_TX,'') AS [Agent Phone|Phone Number],  
         ISNULL(BIA.EMAIL_TX,'') AS [Agent Email|TextFormat],  
         CollCoverage.Amount_no as [Insurance Coverage Amount (Coll)|CurrencyFormat],  
         CompCoverage.Amount_no as [Insurance Coverage Amount (Comp)|CurrencyFormat],  
         BuildCoverage.Amount_no as [Insurance Coverage Amount (Dwelling)|CurrencyFormat],  
         CollCoverage.DEDUCTIBLE_NO as [Deductible Amount (Coll)|CurrencyFormat],  
         CompCoverage.DEDUCTIBLE_NO as [Deductible Amount (Comp)|CurrencyFormat],  
         BuildCoverage.DEDUCTIBLE_NO as [Deductible Amount (Dwelling)|CurrencyFormat],  
         coalesce(P.FLOOD_ZONE_TX,'') AS [Flood Zone|TextFormat],  
         CASE  
            WHEN coalesce(owner_policy.id, 0) = 0 THEN ''  
            WHEN owner_policy.LIENHOLDER_STATUS_CD = 'INCRT'  
            OR owner_policy.LIENHOLDER_STATUS_CD = 'NOTLIST' THEN 'N'  
            ELSE 'Y'  
         END as [Insurance Lienholder|TextFormat],  
         coalesce(LOAN.ESCROW_IN,'') AS [Escrow|TextFormat],  
         LOAN.ID as ID  
      FROM LOAN  
      INNER JOIN LENDER  
      ON LENDER.ID = LOAN.Lender_ID  
      INNER JOIN COLLATERAL C  
      ON LOAN.ID = C.LOAN_ID  
     AND C.PURGE_DT is null  
     AND C.EXTRACT_UNMATCH_COUNT_NO = 0  
     AND C.Status_cd <> 'U'  
      INNER JOIN COLLATERAL_CODE CC  
      ON cc.ID = c.COLLATERAL_CODE_ID  
      INNER JOIN PROPERTY P  
      ON P.ID = C.PROPERTY_ID  
     AND P.PURGE_DT IS NULL  
     AND P.RECORD_TYPE_CD = 'G'  
      INNER JOIN OWNER_LOAN_RELATE OL  
      ON OL.LOAN_ID = LOAN.ID  
     AND OL.OWNER_TYPE_CD = 'B'  
     AND OL.PRIMARY_IN = 'Y'  
     AND OL.PURGE_DT IS NULL  
      INNER JOIN [OWNER] O  
      ON O.ID = OL.OWNER_ID  
     AND O.PURGE_DT IS NULL  
      LEFT OUTER JOIN [OWNER_ADDRESS] AO  
      ON AO.ID = O.ADDRESS_ID  
     AND AO.PURGE_DT IS NULL  
      LEFT OUTER JOIN [OWNER_ADDRESS] AP  
      ON AP.ID = P.ADDRESS_ID  
     AND AP.PURGE_DT IS NULL  
      INNER JOIN REQUIRED_COVERAGE RC  
      ON RC.PROPERTY_ID = P.ID  
     AND RC.RECORD_TYPE_CD = 'G'  
     AND RC.PURGE_DT IS NULL  
      OUTER apply GetCurrentCoverage(P.ID, RC.ID, RC.TYPE_CD) OP  
      LEFT OUTER JOIN owner_policy  
      ON owner_policy.Id = OP.ID  
      LEFT OUTER JOIN REF_CODE RCOPS  
      ON RCOPS.CODE_CD = owner_policy.STATUS_CD  
     AND RCOPS.DOMAIN_CD = 'OwnerPolicyStatus'  
     AND RCOPS.PURGE_DT IS NULL  
      LEFT JOIN REF_CODE RC01  
      ON RC01.CODE_CD = RC.SUMMARY_STATUS_CD  
     AND RC01.DOMAIN_CD = 'RequiredCoverageInsStatus'  
      LEFT JOIN REF_CODE RC02  
      ON RC02.CODE_CD = RC.SUMMARY_SUB_STATUS_CD  
     AND RC02.DOMAIN_CD = 'RequiredCoverageInsSubStatus'  
      LEFT JOIN REF_CODE RC03  
      ON RC03.CODE_CD = RC.STATUS_CD  
     AND RC03.DOMAIN_CD = 'RequiredCoverageStatus'  
      LEFT JOIN NOTICE NTC  
      ON NTC.CPI_QUOTE_ID = RC.CPI_QUOTE_ID  
     AND NTC.TYPE_CD = RC.NOTICE_TYPE_CD  
     AND NTC.SEQUENCE_NO = RC.NOTICE_SEQ_NO  
     AND DATEDIFF( DAY , NTC.EXPECTED_ISSUE_DT , RC.NOTICE_DT ) = 0  
     AND NTC.PURGE_DT is null  
      LEFT OUTER JOIN BORROWER_INSURANCE_COMPANY BIC  
      ON BIC.ID = owner_policy.BIC_ID  
     AND BIC.PURGE_DT IS NULL  
      LEFT OUTER JOIN BORROWER_INSURANCE_AGENCY BIA  
      ON BIA.ID = owner_policy.BIA_ID  
     AND BIA.PURGE_DT IS NULL  
      LEFT OUTER JOIN policy_coverage as CollCoverage  
      ON CollCoverage.Owner_policy_id = owner_policy.ID  
     AND CollCoverage.purge_dt is null  
     AND CollCoverage.Sub_type_cd = 'COLL'  
     AND CollCoverage.TYPE_CD = Rc.TYPE_CD  
     AND CollCoverage.ID =  
         ( 
         SELECT top 1 ID  
         FROM policy_coverage pc  
         WHERE pc.SUB_TYPE_CD = 'COLL'  
        AND pc.PURGE_DT is null  
        AND pc.OWNER_POLICY_ID = owner_policy.ID  
        AND pc.TYPE_CD = rc.TYPE_CD  
        AND getdate() BETWEEN coalesce(pc.start_dt, '1/1/1900') AND coalesce(pc.end_dt, '1/1/9999') 
         ORDER BY pc.END_DT desc 
         )  
      LEFT OUTER JOIN policy_coverage as CompCoverage  
      ON CompCoverage.Owner_policy_id = owner_policy.ID  
     AND CompCoverage.purge_dt is null  
     AND CompCoverage.Sub_type_cd = 'COMP'  
     AND CompCoverage.TYPE_CD = Rc.TYPE_CD  
     AND CompCoverage.ID =  
         ( 
         SELECT top 1 ID  
         FROM policy_coverage pc  
         WHERE pc.SUB_TYPE_CD = 'COMP'  
        AND pc.PURGE_DT is null  
        AND pc.OWNER_POLICY_ID = owner_policy.ID  
        AND pc.TYPE_CD = rc.TYPE_CD  
        AND getdate() BETWEEN coalesce(pc.start_dt, '1/1/1900') AND coalesce(pc.end_dt, '1/1/9999') 
         ORDER BY pc.END_DT desc 
         )  
      LEFT OUTER JOIN policy_coverage as BuildCoverage  
      ON BuildCoverage.Owner_policy_id = OP.ID  
     AND BuildCoverage.Sub_type_cd = 'CADW'  
     AND BuildCoverage.purge_dt is null  
     AND BuildCoverage.TYPE_CD = RC.Type_Cd  
     AND BuildCoverage.ID =  
         ( 
         SELECT top 1 ID  
         FROM policy_coverage pc  
         WHERE Sub_type_cd = 'CADW'  
        AND pc.PURGE_DT is null  
        AND pc.OWNER_POLICY_ID = owner_policy.ID  
        AND pc.TYPE_CD = rc.Type_Cd  
        AND getdate() BETWEEN coalesce(pc.start_dt, '1/1/1900') AND coalesce(pc.end_dt, '1/1/9999') 
         ORDER BY pc.END_DT desc 
         )  
      WHERE LOAN.Lender_ID = 2385  
     AND ( 1=0  
      OR CC.VEHICLE_LOOKUP_IN = 'Y' )  
     AND LOAN.PURGE_DT IS NULL  
     AND LOAN.EXTRACT_UNMATCH_COUNT_NO = 0  
     AND LOAN.Status_cd <> 'U'  
     AND LOAN.RECORD_TYPE_CD = 'G'  
     AND ( (LOAN.CREATE_DT >= @START_DT  
     AND LOAN.CREATE_DT < @END_DT)  
      OR (LOAN.UPDATE_DT >= @START_DT  
     AND LOAN.UPDATE_DT <= @END_DT)  
      OR (C.CREATE_DT >= @START_DT  
     AND C.CREATE_DT <= @END_DT)  
      OR (C.UPDATE_DT >= @START_DT  
     AND C.UPDATE_DT <= @END_DT)  
      OR (P.CREATE_DT >= @START_DT  
     AND P.CREATE_DT <= @END_DT)  
      OR (P.UPDATE_DT >= @START_DT  
     AND P.UPDATE_DT <= @END_DT) )  
      )  
   SELECT DISTINCT [Branch Number|TextFormat] ,[Account Number|TextFormat]  
      ,[Origination Date|DateFormat]  
      ,[Loan Balance|CurrencyFormat]  
      ,[Loan Officer|TextFormat]  
      ,[Collateral ID|TextFormat]  
      ,[Collateral Type|TextFormat]  
      ,[Borrower First Name|TextFormat]  
      ,[Borrower Middle Name|TextFormat]  
      ,[Borrower Last Name|TextFormat]  
      ,[Borrower Address 1|TextFormat]  
      ,[Borrower Address 2|TextFormat]  
      ,[Borrower City|TextFormat]  
      ,[Borrower State|TextFormat]  
      ,[Borrower Zip|TextFormat]  
      ,[Borrower Home Phone|Phone Number]  
      ,[Borrower Cell Phone|Phone Number]  
      ,[Borrower Email|TextFormat]  
      ,[Collateral Year|TextFormat]  
      ,[Collateral Make|TextFormat]  
      ,[Collateral Model|TextFormat]  
      ,[VIN|TextFormat]  
      ,[Required Coverage|TextFormat]  
      ,[Required Coverage Status|TextFormat]  
      ,[Required Coverage Ins Status|TextFormat]  
      ,[Required Coverage Ins Sub Status|TextFormat]  
      ,[Waived|TextFormat]  
      ,[Insurer|TextFormat]  
      ,[Policy Number|TextFormat]  
      ,[Policy Effective Date|DateFormat]  
      ,[Policy Cancel Date|DateFormat]  
      ,[Policy Expiration Date|DateFormat]  
      ,[Policy Batch Date|DateFormat]  
      ,[Policy Doc Date|DateFormat]  
      ,[Deductible Amount (Coll)|CurrencyFormat]  
      ,[Deductible Amount (Comp)|CurrencyFormat]  
      ,[Agent Name|TextFormat]  
      ,[Agent Phone|Phone Number]  
      ,[Agent Email|TextFormat]  
   FROM data  
   ORDER BY [Account Number|TextFormat] 
/* END ACTIVE SECTION (comment inserted by DPA) */  