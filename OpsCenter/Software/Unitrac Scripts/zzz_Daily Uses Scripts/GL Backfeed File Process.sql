USE UniTrac

--1) Carrier TPs
SELECT *
FROM TRADING_PARTNER TP
INNER JOIN DELIVERY_INFO DI ON TP.ID = DI.TRADING_PARTNER_ID
INNER JOIN DELIVERY_INFO_GROUP DIG ON DI.ID = DIG.DELIVERY_INFO_ID
INNER JOIN DELIVERY_DETAIL DD ON DIG.ID = DD.DELIVERY_INFO_GROUP_ID
WHERE DIG.NAME_TX LIKE '%820%'

--2) GL Backfeed Lenders
SELECT *
FROM TRADING_PARTNER TP
INNER JOIN DELIVERY_INFO DI ON TP.ID = DI.TRADING_PARTNER_ID
INNER JOIN DELIVERY_INFO_GROUP DIG ON DI.ID = DIG.DELIVERY_INFO_ID
INNER JOIN DELIVERY_DETAIL DD ON DIG.ID = DD.DELIVERY_INFO_GROUP_ID
WHERE  external_id_tx = '7150'
--16

    SELECT *
FROM TRADING_PARTNER TP
INNER JOIN DELIVERY_INFO DI ON TP.ID = DI.TRADING_PARTNER_ID
INNER JOIN DELIVERY_INFO_GROUP DIG ON DI.ID = DIG.DELIVERY_INFO_ID
INNER JOIN DELIVERY_DETAIL DD ON DIG.ID = DD.DELIVERY_INFO_GROUP_ID
WHERE TP.EXTERNAL_ID_TX IN ('7117') and dig.name_tx like '%*%xlsx'
 


--3) Query TPL for GP File
SELECT *
FROM TRADING_PARTNER_LOG
--WHERE MESSAGE_ID = 13534433
WHERE LOG_MESSAGE LIKE '%GREATPLAINS%' AND CREATE_dT >= '2018-05-21'

--4) IB Message (processed by default MS - Using LFP TP)
SELECT *
FROM MESSAGE
WHERE ID = 13534433

--5) OB Message (processed by GLBackfeed process)
SELECT *
FROM MESSAGE
WHERE RELATE_ID_TX = 13534433

--6) GL Backfeed PD
SELECT *
FROM PROCESS_DEFINITION
WHERE ID = 92379 

--7) GL Backfeed process log
SELECT *
FROM PROCESS_LOG
WHERE PROCESS_DEFINITION_ID = 92379 AND START_DT >= '2018-05-23 10:24:32.500'  AND START_DT <= '2018-05-23 10:44:32.500'

--8) Escrow Payment Process created
SELECT *
FROM PROCESS_DEFINITION
WHERE PROCESS_TYPE_CD = 'ESCPAYPRC' AND CREATE_DT >= '2018-05-23 10:33:45.860' AND CREATE_DT <= '2018-05-23 10:35:45.860'

--9) Escrow Payment process log
SELECT *
FROM PROCESS_LOG
WHERE PROCESS_DEFINITION_ID = 743852 AND START_DT >= '2018-05-23 10:34:18.030'

--10) Escrow records included and new message created by Escrow Payment Process
SELECT *
FROM PROCESS_LOG_ITEM
WHERE PROCESS_LOG_ID = 60701089

--12) Escrow records from Escrow table
SELECT e.CREATE_USER_TX,e.*
FROM ESCROW e
JOIN PROCESS_LOG_ITEM pli ON pli.RELATE_ID = e.ID
WHERE pli.PROCESS_LOG_ID = 60701089

--13) New IB Message (Processed by EDI/IDR MS - Using Carrier TP)
SELECT *
FROM MESSAGE
WHERE ID = 13534518

--14) OB Message (Processed by DW Outbound)
SELECT *
FROM MESSAGE
WHERE RELATE_ID_TX= 13534518

--15) TP Log entry for output file (use IB message)
SELECT *
FROM TRADING_PARTNER_LOG
WHERE MESSAGE_ID = 13534518

--16) If  multiple files being ignored, insert row into RELATED_DATA to allow
INSERT INTO RELATED_DATA (DEF_ID,RELATE_ID,VALUE_TX,COMMENT_TX,CREATE_DT,UPDATE_DT,UPDATE_USER_TX,LOCK_ID)
VALUES (71,3809,'Y','AcceptMultipleFiles',GETDATE(),GETDATE(),'Script',1)

INSERT INTO RELATED_DATA (DEF_ID,RELATE_ID,VALUE_TX,COMMENT_TX,CREATE_DT,UPDATE_DT,UPDATE_USER_TX,LOCK_ID)
VALUES (71,14117,'Y','AcceptMultipleFiles',GETDATE(),GETDATE(),'Script',1)

INSERT INTO RELATED_DATA (DEF_ID,RELATE_ID,VALUE_TX,COMMENT_TX,CREATE_DT,UPDATE_DT,UPDATE_USER_TX,LOCK_ID)
VALUES (71,4023,'Y','AcceptMultipleFiles',GETDATE(),GETDATE(),'Script',1)


--16) Common problems
--1) GP File picked up by wrong TP (Folder mapping in Delivery details incorrect)
--2) File not picked up (Folder mapping wrong)
--3) File picked up but not in TP Log (verify not picked up by other environment)
--4) Generate 820 file Related Data not setup for lender (Must have Generate 820 Response file entry in Addtl Data on Lender Tab)
--5) Escrow record created by user and not service account (lender only wants to know about those created by service, not in UI)
--6) Payment in GP file is not EFT (Verify in Check Number, starts with EFT)
--7) Carrier TP is not setup (no 820 process will be created)--)Multiple Files being Ignored
