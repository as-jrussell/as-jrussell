-------------- Check Work Items Before Update (To Verify Work Item Definition and Status)
-------------- Work Item ID Number(s) should be provided on HDT
----REPLACE XXXXXXX WITH THE THE WI ID
USE UniTrac


UPDATE  LN
SET     SPECIAL_HANDLING_XML = B.SPECIAL_HANDLING_XML ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'Bug50453' ,
        LOCK_ID = CASE WHEN LOCK_ID >= 255 THEN 1
                       ELSE LOCK_ID + 1
                  END
--SELECT COUNT(*)
FROM    LOAN LN
        JOIN UniTracHDStorage..LOAN_Bug50453 B ON B.ID = LN.ID


UPDATE  WI
SET     STATUS_CD = B.STATUS_CD,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'Bug50453' ,
        LOCK_ID = CASE WHEN LOCK_ID >= 255 THEN 1
                       ELSE LOCK_ID + 1
                  END
--SELECT COUNT(*)
FROM    WORK_ITEM WI
        JOIN UniTracHDStorage..WI_Bug50453 B ON B.ID = LN.ID



