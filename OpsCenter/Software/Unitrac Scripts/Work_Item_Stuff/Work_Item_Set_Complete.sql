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


--UPDATE  dbo.WORK_ITEM
--SET     STATUS_CD = 'Withdrawn' ,
--        PURGE_DT = GETDATE() ,
--        UPDATE_DT = GETDATE() ,
--        UPDATE_USER_TX = 'CLEANUP'
--WHERE   ID IN (
--        SELECT  ID
--        FROM    dbo.WORK_ITEM WI ( NOLOCK )
--        WHERE   WORKFLOW_DEFINITION_ID = 4
--                AND STATUS_CD NOT IN ( 'Complete', 'Withdrawn' )
--                AND RELATE_ID NOT IN ( SELECT   ID
--                                       FROM     VUT.dbo.tblImageQueue iq ) )

SELECT  *
FROM    UniTrac..WORK_ITEM
WHERE   ID IN ( 2140285, 2140284, 2140282, 2140281, 2140271, 2140270, 2129964,
                2028460, 2028457, 2028315, 2028310 )

SELECT  *
FROM    UniTrac..WORK_ITEM
WHERE   STATUS_CD = 'Complete'
        AND CREATE_DT > '2013-12-02'
        AND WORKFLOW_DEFINITION_ID = 10
        AND CONTENT_XML.value('(/Content/Lender/Name)[1]', 'varchar (50)') = 'Kirtland' 

SELECT * FROM UniTrac..WORK_ITEM
WHERE UPDATE_USER_TX = 'kharris'
AND WORKFLOW_DEFINITION_ID = 10
AND CREATE_DT > '2013-12-03'
AND CONTENT_XML.value('(/Content/Lender/Name)[1]', 'varchar (50)') LIKE 'Kirtland%' 
ORDER BY UPDATE_DT DESC

SELECT * FROM UniTrac..WORK_ITEM_PROCESS_LOG_ITEM_RELATE
WHERE ID IN (1975366,2890866)

--UPDATE  UniTrac..WORK_ITEM
--SET     STATUS_CD = 'Complete'
--WHERE   ID IN ( 2140285, 2140284, 2140282, 2140281, 2140271, 2140270, 2129964,
--                2028460, 2028457, 2028315, 2028310 )
--        AND WORKFLOW_DEFINITION_ID = 3
--        AND ACTIVE_IN = 'Y'

--UPDATE  UniTrac..WORK_ITEM
--SET     STATUS_CD = 'Complete'
--WHERE   ID IN ( 2140285, 2140284, 2140282, 2140281, 2140271, 2140270, 2129964,
--                2028460, 2028457, 2028315, 2028310 )
--        AND WORKFLOW_DEFINITION_ID = 9
--        AND ACTIVE_IN = 'Y'

--UPDATE  UniTrac..WORK_ITEM
--SET     STATUS_CD = 'Complete'
--WHERE   ID IN ( 2876837,2877669,2877684,2877687,3132329 )
--        AND WORKFLOW_DEFINITION_ID = 10
--        AND ACTIVE_IN = 'Y'

------ Update for Billing Work Item
--UPDATE  UniTrac..WORK_ITEM
--SET     STATUS_CD = 'Initial' ,
--        LOCK_ID = LOCK_ID + 1 ,
--        UPDATE_DT = GETDATE() ,
--        UPDATE_USER_TX = 'Admin'
--WHERE   ID IN ( 2258459 )
--        AND WORKFLOW_DEFINITION_ID = 10
--        AND ACTIVE_IN = 'Y'

------ Update for Cycle Process Work Item
--UPDATE  UniTrac..WORK_ITEM
--SET     STATUS_CD = 'Initial' ,
--        LOCK_ID = LOCK_ID + 1 ,
--        UPDATE_DT = GETDATE() ,
--        UPDATE_USER_TX = 'Admin'
--WHERE   ID = 1603175
--        AND WORKFLOW_DEFINITION_ID = 9
--        AND ACTIVE_IN = 'Y'
