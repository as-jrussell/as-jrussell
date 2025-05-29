
-------------- Check Work Items Before Update (To Verify Work Item Definition and Status)
-------------- Work Item ID Number(s) should be provided on HDT
----REPLACE XXXXXXX WITH THE THE WI ID

USE UniTrac
SELECT CONTENT_XML.value('(/Content/Lender/Code)[1]', 'varchar (50)') Lender, WD.NAME_TX [Definition], 
WQ.NAME_TX [Queue], WI.*
SELECT WI.ID INTO #tmp
FROM  WORK_ITEM WI
INNER JOIN dbo.WORKFLOW_DEFINITION WD ON WD.ID = WI.WORKFLOW_DEFINITION_ID
INNER JOIN dbo.WORK_QUEUE WQ ON WQ.ID = WI.CURRENT_QUEUE_ID
INNER JOIN dbo.LOAN L ON L.ID = WI.RELATE_ID AND L.BRANCH_CODE_TX <> '36'
WHERE WI.CONTENT_XML.value('(/Content/Lender/Code)[1]', 'varchar (50)') IN ('6162')
AND WI.STATUS_CD NOT IN ('Complete' ,'Withdrawn' ,'ImportCompleted')
AND WI.WORKFLOW_DEFINITION_ID = '8'

SELECT  L.STATUS_CD [Loan_Status] ,
        CONTENT_XML.value('(/Content/Lender/Code)[1]', 'varchar (50)') Lender ,
        WI.*
INTO    UniTracHDStorage..WI_INC0249566_2
FROM    UniTrac..WORK_ITEM WI
        INNER JOIN dbo.LOAN L ON L.ID = WI.RELATE_ID
                                 AND WI.RELATE_TYPE_CD = 'Allied.UniTrac.Loan'
WHERE   WI.ID IN (SELECT * FROM #tmp )


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
WHERE   LENDER.CODE_TX = '6162'
        AND WI.WORKFLOW_DEFINITION_ID = 8
        AND WI.STATUS_CD NOT IN ( 'COMPLETE', 'Withdrawn' )
        AND WI.PURGE_DT IS NULL
        --AND WI.CREATE_DT < '2014-01-01 00:00:00.000'
        AND LOAN.PURGE_DT IS NULL
        AND LOAN.RECORD_TYPE_CD IN ( 'G', 'A' )
        AND WI.ID IN ( SELECT ID FROM UniTracHDStorage..WI_INC0249566_2 )
		
SELECT  *
FROM    #TMPWI

SELECT  *
INTO    UniTracHDStorage..LOAN_INC0249566_2
FROM    dbo.LOAN
WHERE   ID IN ( SELECT  LOAN_ID
                FROM    #TMPWI )


UPDATE  LN
SET     SPECIAL_HANDLING_XML = NULL ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'INC0249566' ,
        LOCK_ID = CASE WHEN LOCK_ID >= 255 THEN 1
                       ELSE LOCK_ID + 1
                  END
--SELECT COUNT(*)
FROM    LOAN LN
        JOIN #TMPWI ON #TMPWI.LOAN_ID = LN.ID


UPDATE  WI
SET     STATUS_CD = 'Withdrawn' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'INC0249566' ,
        LOCK_ID = CASE WHEN LOCK_ID >= 255 THEN 1
                       ELSE LOCK_ID + 1
                  END
--SELECT COUNT(*)
FROM    WORK_ITEM WI
        JOIN #TMPWI ON #TMPWI.WI_ID = WI.ID




SELECT  STATUS_CD ,
        UPDATE_DT ,
        UPDATE_USER_TX ,
        LOCK_ID
FROM    dbo.WORK_ITEM
WHERE   ID IN ( SELECT ID FROM  UniTracHDStorage..WI_INC0249566)



SELECT  SPECIAL_HANDLING_XML ,
        UPDATE_DT ,
        UPDATE_USER_TX ,
        LOCK_ID
FROM    dbo.LOAN
WHERE   ID IN ( SELECT  ID
                FROM    UniTracHDStorage..LOAN_INC0249566)

SELECT * FROM  UniTracHDStorage..LOAN_INC0249566


UPDATE L 
SET L.SPECIAL_HANDLING_XML = LL.SPECIAL_HANDLING_XML
FROM dbo.LOAN L 
JOIN  UniTracHDStorage..LOAN_INC0249566 LL ON LL.ID = L.ID


UPDATE L 
SET L.STATUS_CD = LL.STATUS_CD
FROM dbo.WORK_ITEM L 
JOIN  UniTracHDStorage..WI_INC0249566  LL ON LL.ID = L.ID
