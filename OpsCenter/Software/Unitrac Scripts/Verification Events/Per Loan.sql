USE UniTrac;


--this is individual loans and how the events shake out 
SELECT   EE.UPDATE_DT ,
         LP.NAME_TX ,
         ESC.DESCRIPTION_TX ,
         ES.ORDER_NO ,
         ES.TIMING_FROM_LAST_EVENT_DAYS_NO ,
         EE.TYPE_CD ,
         RE.MEANING_TX ,
         EE.STATUS_CD ,
         EE.EVENT_DT ,
         EE.CREATE_DT ,
         L.NUMBER_TX ,
         LE.NAME_TX ,
         LE.CODE_TX ,
         EE.MSG_LOG_TX ,
         EE.*
FROM     EVALUATION_EVENT EE
         INNER JOIN EVENT_SEQUENCE ES ON ES.ID = EE.EVENT_SEQUENCE_ID
                                         AND ES.PURGE_DT IS NULL
         INNER JOIN EVENT_SEQ_CONTAINER ESC ON ESC.ID = ES.EVENT_SEQ_CONTAINER_ID
                                               AND ESC.PURGE_DT IS NULL
         INNER JOIN REQUIRED_COVERAGE RC ON RC.ID = EE.REQUIRED_COVERAGE_ID
                                            AND RC.PURGE_DT IS NULL
         INNER JOIN PROPERTY P ON P.ID = RC.PROPERTY_ID
                                  AND P.PURGE_DT IS NULL
         INNER JOIN COLLATERAL C ON C.PROPERTY_ID = P.ID
                                    AND P.PURGE_DT IS NULL
         INNER JOIN LOAN L ON L.ID = C.LOAN_ID
                              AND L.PURGE_DT IS NULL
         INNER JOIN LENDER LE ON LE.ID = L.LENDER_ID
                                 AND LE.PURGE_DT IS NULL
         LEFT JOIN REF_CODE RE ON RE.CODE_CD = EE.TYPE_CD
                                  AND RE.PURGE_DT IS NULL
                                  AND RE.DOMAIN_CD = 'EventSequenceEventType'
         LEFT JOIN LENDER_PRODUCT LP ON LP.ID = ESC.LENDER_PRODUCT_ID
                                        AND LP.PURGE_DT IS NULL
WHERE    L.NUMBER_TX = '1507522-1' /*enter loan #*/

         AND LE.CODE_TX = '2672' /*Enter Lender #*/

         AND EE.PURGE_DT IS NULL

--AND RC.TYPE_CD = 'HAZARD' /*ENTER COVERAGE TYPE*/

ORDER BY EE.CREATE_DT DESC ,
         ES.ORDER_NO DESC;