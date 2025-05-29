-------------- Check Work Items Before Update (To Verify Work Item Definition and Status)
-------------- Work Item ID Number(s) should be provided on HDT
----REPLACE XXXXXXX WITH THE THE WI ID


SELECT L.STATUS_CD [Loan_Status], CONTENT_XML.value('(/Content/Lender/Code)[1]', 'varchar (50)') Lender, WI.*  --INTO UniTracHDStorage..WI_INCXXXXX
FROM    UniTrac..WORK_ITEM WI 
INNER JOIN dbo.LOAN L ON L.ID = WI.RELATE_ID AND WI.RELATE_TYPE_CD = 'Allied.UniTrac.Loan'
WHERE WI.CONTENT_XML.value('(/Content/Lender/Code)[1]', 'varchar (50)') IN ('1695')
AND WI.STATUS_CD NOT IN ('Complete' ,'Withdrawn' ,'ImportCompleted')
AND WI.WORKFLOW_DEFINITION_ID = '8' AND  L.STATUS_CD <> 'a'

SELECT * FROM dbo.REF_CODE
WHERE DOMAIN_CD = 'LoanStatus'
-------- Verify Data Work Item Clean Up for Cancelled Lender or update initial Select if only specific WI's being closed out.
----REPLACE XXXXXXX WITH THE THE WI ID
----REPLACE #### WITH THE THE Lender ID

SELECT RELATE_ID INTO #tmp2
FROM    UniTrac..WORK_ITEM WI 
INNER JOIN dbo.LOAN L ON L.ID = WI.RELATE_ID AND WI.RELATE_TYPE_CD = 'Allied.UniTrac.Loan'
WHERE WI.CONTENT_XML.value('(/Content/Lender/Code)[1]', 'varchar (50)') IN ('1695')
AND WI.STATUS_CD NOT IN ('Complete' ,'Withdrawn' ,'ImportCompleted')
AND WI.WORKFLOW_DEFINITION_ID = '8' 
ORDER BY WI.RELATE_ID ASC, WI.STATUS_CD desc 




SELECT RELATE_ID INTO #tmp2
FROM    UniTrac..WORK_ITEM WI 
INNER JOIN dbo.LOAN L ON L.ID = WI.RELATE_ID AND WI.RELATE_TYPE_CD = 'Allied.UniTrac.Loan'
WHERE WI.CONTENT_XML.value('(/Content/Lender/Code)[1]', 'varchar (50)') IN ('1832')
AND WI.STATUS_CD NOT IN ('Complete' ,'Withdrawn' ,'ImportCompleted')
AND WI.WORKFLOW_DEFINITION_ID = '8' 
ORDER BY WI.RELATE_ID ASC, WI.STATUS_CD desc 


SELECT CONTENT_XML.value('(/Content/Lender/Code)[1]', 'varchar (50)') Lender,* 
INTO JCs..INC0247924_Lender1695
FROM dbo.WORK_ITEM WI
WHERE WI.RELATE_ID IN (SELECT * FROM #tmp) 
AND WI.WORKFLOW_DEFINITION_ID = '8' --AND WI.STATUS_CD NOT IN ('Complete')
ORDER BY WI.RELATE_ID ASC, WI.STATUS_CD desc 


SELECT CONTENT_XML.value('(/Content/Lender/Code)[1]', 'varchar (50)') Lender,* 
INTO JCs..INC0247924_Lender1832
FROM dbo.WORK_ITEM WI
WHERE WI.RELATE_ID IN (SELECT * FROM #tmp2) 
AND WI.WORKFLOW_DEFINITION_ID = '8' --AND WI.STATUS_CD NOT IN ('Complete')
ORDER BY WI.RELATE_ID ASC, WI.STATUS_CD desc 


