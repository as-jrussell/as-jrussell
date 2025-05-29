--Finding WI via CODE_TX
----REPLACE #### WITH THE THE Lender ID
USE UniTrac

SELECT CONTENT_XML.value('(/Content/Lender/Name)[1]', 'varchar (50)') Lender,
CONTENT_XML.value('(/Content/Collateral/Type)[1]', 'varchar (50)') Type, Wi.*
--INTO UniTracHDStorage..INC0223241
FROM    UniTrac..WORK_ITEM WI
INNER JOIN dbo.LOAN L ON L.ID = WI.RELATE_ID AND RELATE_TYPE_CD = 'Allied.UniTrac.Loan' 
WHERE    Wi.CONTENT_XML.value('(/Content/Lender/Code)[1]', 'varchar (50)') = '3585' 
AND WI.STATUS_CD NOT IN ('Complete' ,'Withdrawn' ,'ImportCompleted')
AND WORKFLOW_DEFINITION_ID = '8'

SELECT * FROM UniTracHDStorage..INC0223241

SELECT DISTINCT
        WI.ID AS WI_ID ,
        LOAN.ID AS LOAN_ID
INTO    #TMPWI
FROM    LOAN
        JOIN LENDER ON LENDER.ID = LOAN.LENDER_ID
        JOIN WORK_ITEM WI ON WI.RELATE_ID = LOAN.ID
WHERE   LENDER.CODE_TX = '3585'
        AND WI.WORKFLOW_DEFINITION_ID = 8
        AND WI.STATUS_CD NOT IN ( 'COMPLETE', 'Withdrawn' )
        AND WI.PURGE_DT IS NULL
        --AND WI.CREATE_DT < '2014-01-01 00:00:00.000'
        AND LOAN.PURGE_DT IS NULL
        AND LOAN.RECORD_TYPE_CD IN ('G','A')
		AND WI.ID IN (SELECT ID FROM UniTracHDStorage..INC0223241)
		
SELECT * FROM #TMPWI

SELECT * INTO UniTracHDStorage..LOAN_INC0223241
FROM dbo.LOAN WHERE ID IN (SELECT LOAN_ID FROM #TMPWI)


UPDATE  LN
SET     SPECIAL_HANDLING_XML = NULL ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'INC0223241' ,
        LOCK_ID = CASE WHEN LOCK_ID >= 255 THEN 1
                       ELSE LOCK_ID + 1
                  END
--SELECT COUNT(*)
FROM    LOAN LN
        JOIN #TMPWI ON #TMPWI.LOAN_ID = LN.ID


UPDATE  WI
SET     STATUS_CD = 'Withdrawn' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'INC0223241' ,
        LOCK_ID = CASE WHEN LOCK_ID >= 255 THEN 1
                       ELSE LOCK_ID + 1
                  END
--SELECT COUNT(*)
FROM    WORK_ITEM WI
        JOIN #TMPWI ON #TMPWI.WI_ID = WI.ID
