-------------- Check Work Items Before Update (To Verify Work Item Definition and Status)
-------------- Work Item ID Number(s) should be provided on HDT
----REPLACE XXXXX WITH THE THE WI ID


SELECT CONTENT_XML.value('(/Content/Lender/Code)[1]', 'varchar (50)') Lender, * --INTO UniTracHDStorage..INC0214291
FROM    UniTrac..WORK_ITEM
WHERE   ID IN ( 26616760 , 26616762  )


-------- Verify Data Work Item Clean Up for Cancelled Lender or update initial Select if only specific WI's being closed out.
----REPLACE XXXXXXX WITH THE THE WI ID
----REPLACE #### WITH THE THE Lender ID

SELECT DISTINCT
        WI.ID AS WI_ID ,
        LOAN.ID AS LOAN_ID
INTO    #TMPWI
FROM    LOAN
        JOIN LENDER ON LENDER.ID = LOAN.LENDER_ID
        JOIN WORK_ITEM WI ON WI.RELATE_ID = LOAN.ID
WHERE   LENDER.CODE_TX = '1615'
        AND WI.WORKFLOW_DEFINITION_ID = 8
        AND WI.STATUS_CD NOT IN ( 'COMPLETE', 'Withdrawn' )
        AND WI.PURGE_DT IS NULL
        --AND WI.CREATE_DT < '2014-01-01 00:00:00.000'
        AND LOAN.PURGE_DT IS NULL
        AND LOAN.RECORD_TYPE_CD IN ('G','A')
		AND WI.ID IN (SELECT ID FROM UniTracHDStorage..INC0214291)
		
--SELECT * FROM #TMPWI

UPDATE  LN
SET     SPECIAL_HANDLING_XML = NULL ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'INC0214291' ,
        LOCK_ID = CASE WHEN LOCK_ID >= 255 THEN 1
                       ELSE LOCK_ID + 1
                  END
--SELECT COUNT(*)
FROM    LOAN LN
        JOIN #TMPWI ON #TMPWI.LOAN_ID = LN.ID


UPDATE  WI
SET     STATUS_CD = 'Withdrawn' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'INC0214291' ,
        LOCK_ID = CASE WHEN LOCK_ID >= 255 THEN 1
                       ELSE LOCK_ID + 1
                  END
--SELECT COUNT(*)
FROM    WORK_ITEM WI
        JOIN #TMPWI ON #TMPWI.WI_ID = WI.ID

