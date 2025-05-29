--00:05:27.587



SELECT fpc.id as FPC_ID, SUM(ft.AMOUNT_NO) as AMOUNT_NO 
FROM   FORCE_PLACED_CERTIFICATE fpc
       JOIN FINANCIAL_TXN ft ON ft.FPC_ID = fpc.ID --and ft.PURGE_DT is null
       JOIN FORCE_PLACED_CERT_REQUIRED_COVERAGE_RELATE FPCRCR ON FPCRCR.FPC_ID = fpc.ID
                                                                 AND FPCRCR.PURGE_DT IS NULL
       JOIN REQUIRED_COVERAGE RC ON RC.ID = FPCRCR.REQUIRED_COVERAGE_ID
                                    AND RC.PURGE_DT IS NULL
       JOIN PROPERTY p ON p.ID = RC.PROPERTY_ID
                          AND p.PURGE_DT IS NULL
       JOIN COLLATERAL c ON c.PROPERTY_ID = p.ID
                            AND c.PURGE_DT IS NULL
                            AND c.PRIMARY_LOAN_IN = 'Y'
       JOIN LOAN l ON l.ID = c.LOAN_ID
                      AND l.PURGE_DT IS NULL
       JOIN LENDER ldr ON ldr.ID = p.LENDER_ID
                          AND ldr.PURGE_DT IS NULL
                          AND ldr.TEST_IN = 'N'
       JOIN COLLATERAL_CODE CC ON CC.ID = c.COLLATERAL_CODE_ID
                                  AND CC.PURGE_DT IS NULL
 JOIN REF_CODE_ATTRIBUTE RCA ON  RCA.REF_CD = CC.SECONDARY_CLASS_CD AND 
ATTRIBUTE_CD = 'PropertyType'
       AND VALUE_TX IN ( 'BOAT', 'BUS', 'COBLDG', 'COCOND', 'COCONT', 'COEQ' ,
                         'COLAND' ,'COND', 'COVEH', 'EQ', 'LAND', 'MH' ,
                         'ORES' ,'PER', 'RES', 'RV', 'VEH'
                       )
WHERE  (   p.AGENCY_ID IN ( 1, 9 )
           OR (   p.AGENCY_ID = 4
                  AND (  RCA.VALUE_TX = 'RE' OR 
                  ( RCA.VALUE_TX = 'MH' AND 
                  ISNULL(p.ADDRESS_ID, 0) > 0
                  )
                      )
              )
       )
       AND fpc.PURGE_DT IS NULL
       AND CONVERT(DATE, ft.CREATE_DT) <= CONVERT(DATE, GETDATE() - 30)
       AND (   ft.PURGE_DT IS NULL
               OR CONVERT(DATE, ft.PURGE_DT) > CONVERT(DATE, GETDATE() - 30)
           )
 group by fpc.ID
having sum(ft.AMOUNT_NO) <> 0

