USE UniTrac


--Finding WI via Number
SELECT CONTENT_XML.value('(/Content/Lender/Code)[1]', 'varchar (50)') Lender, WD.NAME_TX [Definition], 
WQ.NAME_TX [Queue], WI.*
FROM  WORK_ITEM WI
INNER JOIN dbo.WORKFLOW_DEFINITION WD ON WD.ID = WI.WORKFLOW_DEFINITION_ID
INNER JOIN dbo.WORK_QUEUE WQ ON WQ.ID = WI.CURRENT_QUEUE_ID
WHERE WI.ID = '32677062'


SELECT * FROM dbo.REQUIRED_COVERAGE
WHERE ID = '129144210'

SELECT * FROM dbo.PROPERTY
WHERE ID = '127787467'


SELECT L.* FROM dbo.LOAN L
INNER JOIN dbo.COLLATERAL C ON C.LOAN_ID = L.ID
WHERE C.PROPERTY_ID = '127787467'




----REPLACE XXXXXXX WITH THE THE WI ID
SELECT  *
INTO UniTracHDStorage..INC0242303
FROM    UniTrac..WORK_ITEM
WHERE   ID IN ( 32677062 )

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

-------------- Complete CPI Cancel Pending Work Items
----REPLACE XXXXXXX WITH THE THE WI ID
UPDATE  UniTrac..WORK_ITEM
SET     STATUS_CD = 'Initial', UPDATE_DT = GETDATE(), UPDATE_USER_TX = 'INC0242303', LOCK_ID = LOCK_ID+1
WHERE   ID IN (32677062  )
        AND WORKFLOW_DEFINITION_ID = 3
        AND ACTIVE_IN = 'Y'



SELECT * FROM dbo.WORK_ITEM_ACTION
WHERE WORK_ITEM_ID IN (32677062  )