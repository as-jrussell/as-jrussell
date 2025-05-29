USE [UniTrac]
GO 

/* Can be ran on DB01 but best ran on PROD1 */

SELECT CONVERT(Month,umr.update_dt) AS [UMR Create Date], COUNT(umr.id) [UTL Matches for Day]
FROM WORK_ITEM umr
WHERE workflow_definition_id = 9 and update_user_tx = 'CYCLEBACKOFF' and 
CAST(umr.UPDATE_DT AS DATE) >= CAST(GETDATE()-1 AS DATE)
  group by CONVERT(DATE,umr.UPDATE_DT)
order by CONVERT(DATE,umr.update_dt) ASC 



/* Can be ran on DB01 */
SELECT COUNT(*) [UTL Matches for Day]
FROM UTL_MATCH_RESULT umr
WHERE CAST(umr.CREATE_DT AS DATE) >= CAST(GETDATE() AS DATE)
  AND umr.UTL_VERSION_NO = 2



