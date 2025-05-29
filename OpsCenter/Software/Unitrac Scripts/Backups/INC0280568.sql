----REPLACE XXXXXXX WITH THE THE WI ID
SELECT  WI.*
INTO UniTracHDStorage..INC0280568
FROM dbo.WORK_ITEM WI
JOIN dbo.LENDER L ON L.ID = WI.LENDER_ID
WHERE WI.ID IN (36804437)


select * from process_log_item
where process_log_ID iN (41361080) and relate_type_cd = 'Allied.UniTrac.Notice'

select *
--INTO UniTracHDStorage..INC0280568_Notice
 from notice
where ID IN (21017248)


update N
set purge_dt= getdate(), lock_id = lock_id+1, update_dt = getdate(), update_user_tx = 'INC0280568'
--select *
 from notice N
where ID IN  (21017248)


/*
-------------- Find Work Items By Update User, Definition Type Create Date, and Lender 'LIKE' Name
SELECT * FROM UniTrac..WORK_ITEM
WHERE UPDATE_USER_TX = 'kharris'
AND WORKFLOW_DEFINITION_ID = 10
AND CREATE_DT > '2013-12-03'
AND CONTENT_XML.value('(/Content/Lender/Name)[1]', 'varchar (50)') LIKE 'Kirtland%' 
ORDER BY UPDATE_DT DESC

-------------- Find Work Items By Status, Create Date, and Definition Type and Lender Code
----REPLACE #### WITH THE Lender Code ID
SELECT  *
FROM    UniTrac..WORK_ITEM
WHERE   STATUS_CD = 'Complete'
        AND CREATE_DT > '2013-12-02'
        AND WORKFLOW_DEFINITION_ID = 10
        AND CONTENT_XML.value('(/Content/Lender/Code)[1]', 'varchar (50)') = '####' 
*/

-------------- Complete CPI Cancel Pending Work Items
----REPLACE XXXXXXX WITH THE THE WI ID
--UPDATE  UniTrac..WORK_ITEM
--SET     STATUS_CD = 'Complete' ,
--        LOCK_ID = LOCK_ID + 1 ,
--        UPDATE_DT = GETDATE() ,
--        UPDATE_USER_TX = 'INCXXXXXX'
--WHERE   ID IN ( SELECT ID FROM UniTracHDStorage..INCXXXXXX )
--        AND WORKFLOW_DEFINITION_ID = 3
--        AND ACTIVE_IN = 'Y'

-------------- Complete Key Image Work Items
--UPDATE  dbo.WORK_ITEM
--SET     STATUS_CD = 'Withdrawn' ,
--        PURGE_DT = GETDATE() ,
--        UPDATE_DT = GETDATE() ,
--        UPDATE_USER_TX = 'INCXXXXXX'
--WHERE   ID IN ( SELECT ID FROM UniTracHDStorage..INCXXXXXX )
--		  AND WORKFLOW_DEFINITION_ID = 4



---------- Clear OBC (- rows)
--UPDATE  UniTrac..WORK_ITEM
--SET     STATUS_CD = 'Complete' ,
--        LOCK_ID = LOCK_ID + 1 ,
--        UPDATE_DT = GETDATE() ,
--        UPDATE_USER_TX = 'INCXXXXXX'
--WHERE   ID IN ( SELECT ID FROM UniTracHDStorage..INCXXXXXX )
--        AND WORKFLOW_DEFINITION_ID = 6
--        AND ACTIVE_IN = 'Y'


-------------- Complete Cycle Processing Work Items
----REPLACE XXXXXXX WITH THE THE WI ID
UPDATE  UniTrac..WORK_ITEM
SET     STATUS_CD = 'Complete' ,
        LOCK_ID = LOCK_ID + 1 ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'INC0280568'
WHERE   ID IN ( SELECT ID FROM UniTracHDStorage..INC0280568 )
        AND WORKFLOW_DEFINITION_ID = 9
        AND ACTIVE_IN = 'Y'