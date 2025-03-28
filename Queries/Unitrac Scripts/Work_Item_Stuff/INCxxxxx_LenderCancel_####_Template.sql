------- Cancelled Lender Determine Cancel Pending, Outbound Call, VerifyData Open WI
----REPLACE XXXXXXX WITH THE THE WI ID
----REPLACE #### WITH THE THE Lender ID
----REPLACE INCXXXXXXX WITH THE TICKET ID
---Checking UTLs WIs
USE UniTrac

--SELECT * FROM dbo.LENDER WHERE CODE_TX IN ('####')

SELECT 
WI.CONTENT_XML.value('(/Content/Lender/Code)[1]', 'varchar (50)') Lender, 
WI.CONTENT_XML.value('(/Content/Collateral/Type)[1]', 'varchar (50)') Collateral,
WI.CONTENT_XML.value('(/Content/Coverage/Type)[1]', 'varchar (50)') [Coverage Type],
WI.CONTENT_XML.value('(/Content/Property/Description)[1]', 'varchar (50)') Property, WI.* 
--INTO UniTracHDStorage..INCXXXXXXX
FROM UniTrac..WORK_ITEM WI
JOIN dbo.LENDER L ON L.ID = WI.LENDER_ID
WHERE L.CODE_TX IN ('####')
AND WI.STATUS_CD NOT IN ('Complete', 'Withdrawn')
ORDER BY WI.WORKFLOW_DEFINITION_ID ASC



-------- Clear UTLs (- rows)
UPDATE  UniTrac..WORK_ITEM
SET     STATUS_CD = 'Complete' ,
        UPDATE_USER_TX = 'INCXXXXXXX',
		 LOCK_ID = CASE WHEN LOCK_ID >= 255 THEN 1
                  ELSE LOCK_ID + 1 END
WHERE   ID IN  (  SELECT ID FROM UniTracHDStorage..INCXXXXXXX)
        AND WORKFLOW_DEFINITION_ID = 2
		AND STATUS_CD = 'Initial'
        AND ACTIVE_IN = 'Y'

-------- Clear Cancel Pending (- rows)
UPDATE  UniTrac..WORK_ITEM
SET     STATUS_CD = 'Complete' ,
        UPDATE_USER_TX = 'INCXXXXXXX'
WHERE   ID IN ( SELECT ID FROM UniTracHDStorage..INCXXXXXXX)
        AND WORKFLOW_DEFINITION_ID = 3
        AND ACTIVE_IN = 'Y'

-------- Clear OBC (- rows)
UPDATE  UniTrac..WORK_ITEM
SET     STATUS_CD = 'Complete' ,
        UPDATE_USER_TX = 'INCXXXXXXX'
WHERE   ID IN ( SELECT ID FROM UniTracHDStorage..INCXXXXXXX)
        AND WORKFLOW_DEFINITION_ID = 6
        AND ACTIVE_IN = 'Y'

-------- Clear VerifyData (- rows)
SELECT DISTINCT
        WI.ID AS WI_ID ,
        LOAN.ID AS LOAN_ID
INTO    #TMPWI
FROM    LOAN
        JOIN LENDER ON LENDER.ID = LOAN.LENDER_ID
        JOIN WORK_ITEM WI ON WI.RELATE_ID = LOAN.ID
WHERE   LENDER.CODE_TX = '####'
        AND WI.WORKFLOW_DEFINITION_ID = 8
        AND WI.STATUS_CD NOT IN ( 'COMPLETE', 'Withdrawn' )
        AND WI.PURGE_DT IS NULL
        AND LOAN.PURGE_DT IS NULL

SELECT * INTO UniTracHDStorage..WI_INCXXXXX
FROM dbo.WORK_ITEM WHERE ID IN (SELECT WI_ID FROM #TMPWI)



UPDATE  LN
SET     SPECIAL_HANDLING_XML = NULL ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'INCXXXXX' ,
        LOCK_ID = CASE WHEN LOCK_ID >= 255 THEN 1
                       ELSE LOCK_ID + 1
                  END
--SELECT COUNT(*)
FROM    LOAN LN
        JOIN #TMPWI ON #TMPWI.LOAN_ID = LN.ID


UPDATE  WI
SET     STATUS_CD = 'Withdrawn' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'INCXXXXX' ,
        LOCK_ID = CASE WHEN LOCK_ID >= 255 THEN 1
                       ELSE LOCK_ID + 1
                  END
--SELECT COUNT(*)
FROM    WORK_ITEM WI
        JOIN #TMPWI ON #TMPWI.WI_ID = WI.ID


SELECT ID,STATUS_CD FROM dbo.WORK_ITEM
WHERE ID IN (SELECT ID FROM UniTracHDStorage..INCXXXXXXX)

SELECT SPECIAL_HANDLING_XML, UPDATE_DT, UPDATE_USER_TX, LOCK_ID
FROM dbo.LOAN WHERE ID IN (SELECT LOAN_ID FROM #TMPWI)
