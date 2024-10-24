USE ROLE OWNER_BOND_STAGE;

CREATE OR REPLACE VIEW STG.ETL_LOAD_STATUS_BOND_VW    (   PROCESS_NM,   STATUS_CD,   PROC_DT,   START_TM,   END_TM,   RUN_TM  ) AS 
SELECT DISTINCT   CASE   WHEN PROCESS_NM LIKE '%STG%' THEN Substr(PROCESS_NM, 8,99)   ELSE Substr(PROCESS_NM, 0,99)   END       
AS PROCESS_NM  ,NULL                                              AS STATUS_CD  ,NULL                                              AS PROC_DT  ,
NULL                                              AS START_TM  ,NULL                                              AS END_TM  ,
NULL                                              AS RUN_TM  FROM BOND_TEST.LND.ETL_PROCESS_CONTROL 
WHERE PROCESS_START_DT > CURRENT_DATE - 7    AND PROCESS_START_DT < CURRENT_DATE -1    
AND PROCESS_NM NOT IN (SELECT DISTINCT PROCESS_NM                           
FROM LND.ETL_PROCESS_CONTROL                           
WHERE PROCESS_START_DT::DATE = CURRENT_DATE                              
OR PROCESS_START_DT::DATE - CURRENT_DATE -1)    
UNION    
SELECT   CASE   WHEN PROCESS_NM LIKE '%STG%' THEN Substr(PROCESS_NM, 8,99)   ELSE Substr(PROCESS_NM, 0,99)   END                                               AS PROCESS_NM,
CASE   WHEN STATUS_CD = 'C' THEN 'COMPLETE'   
WHEN STATUS_CD = 'F' THEN 'FAILED'   WHEN STATUS_CD = 'R' THEN 'RE-RUN'   ELSE STATUS_CD   END                                                     AS STATUS_CD  ,
Max(PROCESS_START_DT::DATE)                             AS PROC_DT  ,Min(PROCESS_END_DT)::TIME                               AS START_TM  ,
MAX(PROCESS_END_DT)::TIME                               AS END_TM  ,MAX(DATEDIFF(MINUTE, PROCESS_START_DT, PROCESS_END_DT)) AS RUN_TM    
FROM LND.ETL_PROCESS_CONTROL    WHERE (   (    PROCESS_END_DT::DATE = CURRENT_DATE -1             AND PROCESS_END_DT::TIME > '18:00')         
OR (    PROCESS_END_DT::DATE = CURRENT_DATE             AND PROCESS_END_DT::TIME < '18:00'))    AND PROCESS_END_DT IS NOT NULL    
GROUP BY   PROCESS_NM  ,CASE   WHEN STATUS_CD = 'C' THEN 'COMPLETE'   WHEN STATUS_CD = 'F' THEN 'FAILED'   WHEN STATUS_CD = 'R' THEN 'RE-RUN'   
ELSE STATUS_CD   END    ORDER BY 1,2,3,4;



GRANT SELECT ON VIEW  BOND_STAGE.STG.ETL_LOAD_STATUS_BOND_VW TO ROLE READ_BOND_STAGE;

GRANT SELECT ON VIEW   BOND_STAGE.STG.ETL_LOAD_STATUS_BOND_VW  TO ROLE READWRITE_BOND_STAGE;


