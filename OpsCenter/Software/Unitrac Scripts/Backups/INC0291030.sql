USE UniTrac

SELECT   DISTINCT L.CODE_TX [Lender Code], L.NAME_TX [Lender Name], A.NAME_TX [Agency],
        CT.DESCRPTION_TX [Template Name] ,
        MPA.START_DT [Master Policy Assignment Start Date],
        MPA.END_DT [Master Policy Assignment End Date], 
        MPA.FORM_NUMBER_TX ,
        MPA.COVERAGE_TYPE_CD [Coverage]
		INTO jcs..INC0291030_NonAuto
FROM    LENDER L
        INNER JOIN LENDER_PRODUCT LP ON L.ID = LP.LENDER_ID
                                        AND LP.PURGE_DT IS NULL
        INNER JOIN MASTER_POLICY_LENDER_PRODUCT_RELATE MPLPR ON LP.ID = MPLPR.LENDER_PRODUCT_ID
                                                              AND MPLPR.PURGE_DT IS NULL
        INNER JOIN MASTER_POLICY MP ON MP.ID = MPLPR.MASTER_POLICY_ID
                                       AND MPLPR.PURGE_DT IS NULL
        INNER JOIN MASTER_POLICY_ASSIGNMENT MPA ON MP.ID = MPA.MASTER_POLICY_ID
                                                   AND MPA.PURGE_DT IS NULL
        INNER JOIN TEMPLATE CT ON  MPA.COVER_LETTER_TEMPLATE_ID= CT.ID
                                  AND CT.PURGE_DT IS NULL
		INNER JOIN dbo.AGENCY A ON A.ID = L.AGENCY_ID
								  WHERE  
         L.PURGE_DT IS NULL
        AND L.TEST_IN = 'N' AND COVERAGE_TYPE_CD != 'PHYS-DAMAGE'
        AND L.CANCEL_DT IS NULL
       AND CT.TYPE_CD = 'CL'AND A.ID IN (1,4)
ORDER BY L.CODE_TX, CT.DESCRPTION_TX ASC 



--SELECT * FROM dbo.AGENCY