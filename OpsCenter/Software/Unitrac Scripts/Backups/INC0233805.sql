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

----------- Check to find "previous" Work Item status
SELECT DISTINCT
        wi.ID ,
        wia.FROM_STATUS_CD,
        wia.TO_STATUS_CD
FROM    WORK_ITEM wi
        INNER JOIN PROCESS_LOG_ITEM pli ON pli.RELATE_ID = wi.RELATE_ID
                                           --AND pli.RELATE_TYPE_CD = 'Allied.UniTrac.BillingGroup'
        INNER JOIN PROCESS_LOG pl ON pl.id = pli.PROCESS_LOG_ID
        INNER JOIN PROCESS_DEFINITION pd ON pd.id = pl.PROCESS_DEFINITION_ID
        INNER JOIN WORK_ITEM_ACTION wia ON wia.ID = wi.LAST_WORK_ITEM_ACTION_ID
WHERE   wi.ID = 30292286  
 
---------- Check the status of Work Item before making update 
SELECT * FROM UniTrac..WORK_ITEM
WHERE ID IN (30292286 )

--------- Make the update (Billing and Cycle Process Work Items, Types 9 and 10)
UPDATE  wi
SET     wi.LOCK_ID = wi.LOCK_ID + 1 ,
        wi.UPDATE_DT = GETDATE() , wi.UPDATE_USER_TX = '',
        wi.STATUS_CD = 'Initial'
FROM    WORK_ITEM wi
WHERE   wi.ID = 30017085 



UPDATE  wi
SET     wi.LOCK_ID = wi.LOCK_ID + 1 ,
        wi.UPDATE_DT = GETDATE() , wi.UPDATE_USER_TX = 'INC0233805',
        wi.STATUS_CD = 'Initial'
FROM    WORK_ITEM wi
WHERE   wi.ID = 30292286 
