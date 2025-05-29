SELECT DISTINCT L.NUMBER_TX [Loan Number] ,
		LO.NAME_TX, --RC.TYPE_CD,
       -- NAME [Insurance Company Name] ,
        --A.NAME_TX [Agency Company Name] ,
        --AGENT_TX [Agency Information] ,
        --A.PHONE_TX [Agent Phone Number] ,
        --A.PHONE_EXT_TX [Agent Extension] ,
        --A.FAX_TX [Agent Fax Number] ,
        --A.FAX_EXT_TX [Agent Fax Extension] ,
       -- A.EMAIL_TX [Agent Email] ,
        CONCAT(O.FIRST_NAME_TX, ' ', O.MIDDLE_INITIAL_TX, ' ', O.LAST_NAME_TX) AS [Owner] ,
        O.HOME_PHONE_TX [Home Phone] ,
        O.WORK_PHONE_TX [Work Phone] ,
        O.CELL_PHONE_TX [Cell Phone] ,
        O.EMAIL_TX [Owner Email] ,
        P.DESCRIPTION_TX , 
        CONCAT(OM.LINE_1_TX, ' ', OM.LINE_2_TX, ' ', OM.CITY_TX, ' ',
               OM.STATE_PROV_TX, ' ', OM.POSTAL_CODE_TX, ' ', OM.COUNTRY_TX) AS [Property Description] ,
        OP.POLICY_NUMBER_TX [Policy Number] ,
        CONCAT(OA.LINE_1_TX, ' ', OA.LINE_2_TX, ' ', oa.CITY_TX, ' ',
               OA.STATE_PROV_TX, ' ', OA.POSTAL_CODE_TX, ' ', OA.COUNTRY_TX) AS [Home Address Description] 
--SELECT * 
FROM    --jcs..INC0300240Insurance I
       -- JOIN jcs..INC0300240Agency A ON A.NUMBER_TX = I.NUMBER_TX
         dbo.LOAN L --ON L.NUMBER_TX = I.NUMBER_TX
        JOIN dbo.COLLATERAL C ON C.LOAN_ID = L.ID
        JOIN dbo.PROPERTY P ON P.ID = C.PROPERTY_ID
		JOIN dbo.REQUIRED_COVERAGE RC ON RC.PROPERTY_ID = P.ID
		JOIN dbo.LENDER_ORGANIZATION lo ON lo.CODE_TX = l.DIVISION_CODE_TX AND lo.TYPE_CD = 'DIV' AND LO.LENDER_ID = 835
		JOIN dbo.OWNER_LOAN_RELATE OL ON OL.LOAN_ID = L.ID
        JOIN dbo.OWNER O ON O.ID = OL.OWNER_ID
        JOIN dbo.OWNER_ADDRESS OA ON OA.ID = O.ADDRESS_ID
        JOIN dbo.OWNER_ADDRESS OM ON OM.ID = P.ADDRESS_ID
        JOIN dbo.PROPERTY_OWNER_POLICY_RELATE POP ON POP.PROPERTY_ID = P.ID
        JOIN dbo.OWNER_POLICY OP ON OP.ID = POP.OWNER_POLICY_ID
WHERE    L.DIVISION_CODE_TX = '4'
        AND L.LENDER_ID = 835 AND OL.OWNER_TYPE_CD = 'B'
		ORDER BY .NUMBER_TX ASC 





SELECT * FROM  jcs..INC0300240Insurance I
   SELECT * FROM jcs..INC0300240Agency A 

   SELECT DISTINCT
   BIC.NAME_TX,
            L.NUMBER_TX [Loan Number] ,
            OP.POLICY_NUMBER_TX [Policy Number] ,
            LO.NAME_TX [Type of Property] ,
            BIC.NAME_TX [Insurance Company Name] ,
            BIC.AGENT_TX [Agent Name] ,
            BIC.EMAIL_TX [Agent Email] ,
            BIC.PHONE_TX [Agent Phone Number] ,
            BIC.PHONE_EXT_TX [Agent Extension] ,
            BIC.FAX_TX [Agent Fax Number] ,
            BIC.FAX_EXT_TX [Agent Fax Extension] ,
		   CONCAT(AA.LINE_1_TX, ' ', AA.LINE_2_TX, ' ', AA.CITY_TX, ' ',
               AA.STATE_PROV_TX, ' ', AA.POSTAL_CODE_TX, ' ', AA.COUNTRY_TX) AS [Agent Address Description] 
			       ,  
       CONCAT(O.FIRST_NAME_TX, ' ', O.MIDDLE_INITIAL_TX, ' ', O.LAST_NAME_TX) AS [Borrower] , RFC.DESCRIPTION_TX [OwnerType],
        --O.HOME_PHONE_TX [Home Phone] ,
        --O.WORK_PHONE_TX [Work Phone] ,
        --O.CELL_PHONE_TX [Cell Phone] ,
        --O.EMAIL_TX [Owner Email] ,
            P.DESCRIPTION_TX ,
            CONCAT(OM.LINE_1_TX, ' ', OM.LINE_2_TX, ' ', OM.CITY_TX, ' ',
                   OM.STATE_PROV_TX, ' ', OM.POSTAL_CODE_TX, ' ',
                   OM.COUNTRY_TX) AS [Property Description] 
			
    
        --,CONCAT(OA.LINE_1_TX, ' ', OA.LINE_2_TX, ' ', oa.CITY_TX, ' ',
        --       OA.STATE_PROV_TX, ' ', OA.POSTAL_CODE_TX, ' ', OA.COUNTRY_TX) AS [Home Address Description] 
        
			
--SELECT * 
--INTO jcs..INC0307954_2
   FROM     dbo.LOAN L
            JOIN dbo.COLLATERAL C ON C.LOAN_ID = L.ID
            JOIN dbo.PROPERTY P ON P.ID = C.PROPERTY_ID
            JOIN dbo.REQUIRED_COVERAGE RC ON RC.PROPERTY_ID = P.ID
            JOIN dbo.LENDER_ORGANIZATION lo ON lo.CODE_TX = l.DIVISION_CODE_TX
                                               AND lo.TYPE_CD = 'DIV'
                                               AND LO.LENDER_ID = 835
            JOIN dbo.OWNER_LOAN_RELATE OL ON OL.LOAN_ID = L.ID
            JOIN dbo.OWNER O ON O.ID = OL.OWNER_ID
            JOIN dbo.OWNER_ADDRESS OA ON OA.ID = O.ADDRESS_ID
            JOIN dbo.OWNER_ADDRESS OM ON OM.ID = P.ADDRESS_ID
            JOIN dbo.PROPERTY_OWNER_POLICY_RELATE POP ON POP.PROPERTY_ID = P.ID
            JOIN dbo.OWNER_POLICY OP ON OP.ID = POP.OWNER_POLICY_ID
			JOIN dbo.BORROWER_INSURANCE_AGENCY BIA ON BIA.ID = RC.BIA_ID
            LEFT JOIN dbo.BORROWER_INSURANCE_AGENCY BIC ON BIC.ID = RC.BIA_ID
            LEFT	JOIN dbo.ADDRESS AA ON AA.ID = BIC.ADDRESS_ID
			JOIN dbo.REF_CODE RFC ON RFC.CODE_CD = OL.OWNER_TYPE_CD AND RFC.DOMAIN_CD = 'OwnerType'
			WHERE BIC.NAME_TX = 'INS AGCY'
   --WHERE    L.DIVISION_CODE_TX = '4'
   --         AND L.LENDER_ID = 835
   --         AND OL.OWNER_TYPE_CD = 'B'
   --         AND L.RECORD_TYPE_CD <> 'D'
   --         AND OP.STATUS_CD = 'F' 
   ORDER BY L.NUMBER_TX ASC 



   SELECT * FROM dbo.BORROWER_INSURANCE_AGENCY bia
   JOIN dbo.ADDRESS A ON A.ID = bia.ADDRESS_ID
   WHERE  CITY_TX LIKE '%newport%' AND STATE_PROV_TX = 'VA'
   AND NAME_TX LIKE '%langley%'


   SELECT TOP 5* FROM dbo.BORROWER_INSURANCE_COMPANY bic
   



   SELECT * FROM dbo.LENDER
   WHERE ID = 835