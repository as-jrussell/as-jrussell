--------- WORK_ITEM DEFINITIONS ------------
--NAME_TX		WORKFLOW_DEFINITION_ID
--LenderExtract			1
--UTLMatch				2
--CPICancelPending		3
--KeyImage				4
--InboundCall			5
--OutboundCall			6
--ActionRequest			7
--VerifyData			8
--Cycle					9
--BillingGroup			10
--Escrow				11
--EOMReporting			12
--InsuranceBackfeed		13

----- Initial Cycle Work Item (from HDT, look for Loan ID or other data elements)
SELECT  *
FROM    UniTrac..WORK_ITEM
WHERE   ID IN ( 27945864)

------ Get Process Log Information from Work Item Relate ID
SELECT * FROM UniTrac..PROCESS_LOG
WHERE ID = 28493157

------ Get Process Log Item (same ID = Process Log ID)
SELECT * FROM UniTrac..PROCESS_LOG_ITEM
WHERE PROCESS_LOG_ID = 28493157

------ Find the Specific Notices, scroll to right to find status (Look for PDF_GENERATE_CD error)
SELECT * FROM UniTrac..NOTICE
WHERE id IN (SELECT RELATE_ID FROM UniTrac..PROCESS_LOG_ITEM
WHERE PROCESS_LOG_ID = 16250537 AND RELATE_TYPE_CD = 'allied.unitrac.notice')


SELECT * FROM dbo.ESCROW
WHERE id IN (624211, 624219, 624015)

SELECT * FROM dbo.LOAN
WHERE id IN (67118945, 67117008, 67118098)


SELECT * FROM dbo.REPORT_HISTORY
WHERE id IN (8344763,
8344764,
8344765,
8344766,
8344767,
8344768)