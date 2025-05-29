USE UniTrac

SELECT DISTINCT
        L.CODE_TX [Lender Code] ,
        L.NAME_TX [Lender Name] ,
        A.STATE_PROV_TX [Lender State] ,
        IP.CODE_TX [Issue Procedure Code] ,
        lcgct.TYPE_CD [Coverage Type] ,
        CT.DESCRPTION_TX [Certificate Template] ,
        CLT.DESCRPTION_TX [Cover Letter Template] ,
        LO.CODE_TX [Division Code] ,
        MPA.FORM_NUMBER_TX [Form Number]
INTO jcs..MasterPolicyQuery20160908
FROM    LENDER L
        INNER JOIN LENDER_PRODUCT LP ON L.ID = LP.LENDER_ID
                                        AND LP.PURGE_DT IS NULL
        INNER JOIN MASTER_POLICY_LENDER_PRODUCT_RELATE MPLPR ON LP.ID = MPLPR.LENDER_PRODUCT_ID
                                                              AND MPLPR.PURGE_DT IS NULL
        INNER JOIN MASTER_POLICY MP ON MP.ID = MPLPR.MASTER_POLICY_ID
                                       AND MPLPR.PURGE_DT IS NULL
        INNER JOIN MASTER_POLICY_ASSIGNMENT MPA ON MP.ID = MPA.MASTER_POLICY_ID
                                                   AND MPA.PURGE_DT IS NULL
        INNER JOIN TEMPLATE CT ON MPA.CERTIFICATE_TEMPLATE_ID = CT.ID
                                  AND CT.PURGE_DT IS NULL
        INNER JOIN TEMPLATE CLT ON MPA.COVER_LETTER_TEMPLATE_ID = CLT.ID
                                   AND CLT.PURGE_DT IS NULL
        INNER JOIN LENDER_COLLATERAL_GROUP_COVERAGE_TYPE lcgct ON LP.ID = lcgct.LENDER_PRODUCT_ID
        INNER JOIN LENDER_ORGANIZATION LO ON lcgct.DIVISION_LENDER_ORG_ID = LO.ID
                                             AND LO.TYPE_CD = 'DIV'
        INNER JOIN dbo.CARRIER C ON C.ID = MP.CARRIER_ID
        INNER JOIN dbo.ADDRESS A ON A.ID = L.PHYSICAL_ADDRESS_ID
        INNER JOIN dbo.ISSUE_PROCEDURE IP ON IP.ID = MPA.ISSUE_PROCEDURE_ID
WHERE   LO.LENDER_ID <> 199
        AND L.PURGE_DT IS NULL
        AND L.TEST_IN = 'N'
        AND L.CANCEL_DT IS NULL
        AND MP.END_DT > GETDATE()
        AND LO.CODE_TX IN ( 3, 4, 8, 10, 99 ) 
        AND L.PURGE_DT IS NULL
        AND L.TEST_IN = 'N'
        AND L.CANCEL_DT IS NULL
        AND MP.END_DT > GETDATE()
        AND L.STATUS_CD = 'ACTIVE'
        AND C.ACTIVE_IN = 'Y'
ORDER BY L.CODE_TX ASC 

