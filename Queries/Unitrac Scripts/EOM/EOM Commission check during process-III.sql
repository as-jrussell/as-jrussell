---GET THE LATEST ACCOUNTING PERIOD FOR ALLIED THAT IS FINALIZED AND NOT YET REPORTED
SELECT * FROM ACCOUNTING_PERIOD WHERE AGENCY_ID = 1
AND FINAL_IN = 'Y' AND REPORTED_IN = 'N'
ORDER BY ID DESC


------ GET COUNT OF THE TXNS. THAT ARE CALCULATED
SELECT COUNT(*) FROM FINANCIAL_REPORT_TXN WHERE ACCOUNTING_PERIOD_ID IN 
(
SELECT TOP 1 ID FROM ACCOUNTING_PERIOD WHERE AGENCY_ID = 1
AND FINAL_IN = 'Y' AND REPORTED_IN = 'N'
)
AND PURGE_DT IS NULL
----- 59492

----- CHECK IF THE COMMISSION IS CREATED FOR ALL TXNS.
----- IF NOT THE SAME - THEN IT MIGHT HAVE RECEIVED ERROR
SELECT COUNT(*) FROM COMMISSION WHERE FRT_ID IN 
(
SELECT ID FROM FINANCIAL_REPORT_TXN WHERE ACCOUNTING_PERIOD_ID IN 
(
SELECT TOP 1 ID FROM ACCOUNTING_PERIOD WHERE AGENCY_ID = 1
AND FINAL_IN = 'Y' AND REPORTED_IN = 'N'
)
AND PURGE_DT IS NULL
)
AND PURGE_DT IS NULL
----- 59492


---- GET THE EOM PROCESSES SETUP
SELECT * FROM PROCESS_DEFINITION WHERE PROCESS_TYPE_CD  = 'EOMRPTG'


---- GET THE LATEST PROCESS LOG ITEM FOR THE EOM PROCESS THAT IS RUNNING
----- CHECK IF ANY ONE OF RECEIVED ERROR IN THE LOG
----- OPEN THE XML TO WHAT THE ERROR IS
SELECT TOP 50 * FROM PROCESS_LOG PL 
JOIN PROCESS_LOG_ITEM PLI ON PLI.PROCESS_LOG_ID = PL.ID
WHERE PROCESS_DEFINITION_ID = 1069
AND PLI.STATUS_CD LIKE 'INPROCESS%'
AND PLI.STATUS_CD = 'ERR' 
ORDER BY PLI.ID DESC
