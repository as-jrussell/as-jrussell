USE UniTrac



SELECT WI.* 
--INTO UniTracHDStorage..INC0339053
FROM dbo.WORK_ITEM WI
JOIN dbo.LENDER L ON L.ID = WI.LENDER_ID
WHERE L.CODE_TX= '3551' AND wi.CURRENT_QUEUE_ID = 388





-------------- Complete Billing Process Work Items
----REPLACE XXXXXXX WITH THE THE WI ID
UPDATE  UniTrac..WORK_ITEM
SET     STATUS_CD = 'Withdrawn' , PURGE_DT = GETDATE(),
        LOCK_ID = LOCK_ID + 1 ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'INC0339053'
WHERE   ID IN ( SELECT ID FROM UniTracHDStorage..INC0339053 )
       