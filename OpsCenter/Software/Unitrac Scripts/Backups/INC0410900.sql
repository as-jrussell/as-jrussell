-------------- Check Work Items Before Update (To Verify Work Item Definition and Status)
-------------- Work Item ID Number(s) should be provided on HDT
----REPLACE XXXXXXX WITH THE THE WI ID
USE UniTrac

SELECT L.STATUS_CD [Loan_Status], CONTENT_XML.value('(/Content/Lender/Code)[1]', 'varchar (50)') Lender, WI.* INTO 
#tmp 
FROM    UniTrac..WORK_ITEM WI 
INNER JOIN dbo.LOAN L ON L.ID = WI.RELATE_ID AND WI.RELATE_TYPE_CD = 'Allied.UniTrac.Loan'
WHERE  WI.ID IN  (53106347,50847155) AND WI.STATUS_CD NOT IN ( 'COMPLETE', 'Withdrawn' )

select * from #tmp

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
WHERE   WI.WORKFLOW_DEFINITION_ID = 8
        AND WI.STATUS_CD NOT IN ( 'COMPLETE', 'Withdrawn' )
        AND WI.PURGE_DT IS NULL
        --AND WI.CREATE_DT < '2014-01-01 00:00:00.000'
		AND WI.ID IN (SELECT ID FROM #tmp)
		

SELECT * INTO UniTracHDStorage..LOAN_INC0410900
FROM dbo.LOAN WHERE ID IN (SELECT LOAN_ID FROM #TMPWI)

SELECT * INTO UniTracHDStorage..WI_INC0410900
FROM dbo.WORK_ITEM WHERE ID IN (SELECT WI_ID FROM #TMPWI)



UPDATE  LN
SET     SPECIAL_HANDLING_XML = NULL ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'INC0410900' ,
        LOCK_ID = CASE WHEN LOCK_ID >= 255 THEN 1
                       ELSE LOCK_ID + 1
                  END
--SELECT COUNT(*)
FROM    LOAN LN
        JOIN #TMPWI ON #TMPWI.LOAN_ID = LN.ID


UPDATE  WI
SET     STATUS_CD = 'Withdrawn' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'INC0410900' ,
        LOCK_ID = CASE WHEN LOCK_ID >= 255 THEN 1
                       ELSE LOCK_ID + 1
                  END
--SELECT COUNT(*)
FROM    WORK_ITEM WI
        JOIN #TMPWI ON #TMPWI.WI_ID = WI.ID


SELECT STATUS_CD, UPDATE_DT, UPDATE_USER_TX, LOCK_ID FROM dbo.WORK_ITEM
WHERE ID IN (SELECT WI_ID FROM #TMPWI)



SELECT SPECIAL_HANDLING_XML, UPDATE_DT, UPDATE_USER_TX, LOCK_ID
FROM dbo.LOAN WHERE ID IN (SELECT LOAN_ID FROM #TMPWI)




