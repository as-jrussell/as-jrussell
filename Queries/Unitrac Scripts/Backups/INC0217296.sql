USE [UniTrac]
GO 

--Loan Screen Information - LOAN/COLLATERAL/PROPERTY/OWNER/REQUIRED COVERAGE
SELECT RC.* FROM LOAN L
INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
INNER JOIN REQUIRED_COVERAGE RC ON P.ID = RC.PROPERTY_ID
INNER JOIN OWNER_LOAN_RELATE OL ON L.ID = OL.LOAN_ID
INNER JOIN OWNER O ON OL.OWNER_ID = O.ID
INNER JOIN OWNER_ADDRESS OA ON O.ADDRESS_ID = OA.ID
INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
WHERE NUMBER_TX = '351000442589' AND CODE_TX = '2965'  

SELECT TOP 100 IH.*
FROM INTERACTION_HISTORY IH
INNER JOIN dbo.PROPERTY P ON P.ID = IH.PROPERTY_ID
INNER JOIN dbo.LENDER L ON L.ID = P.LENDER_ID
WHERE P.ID IN (56046135)
IH.RELATE_ID = '15997371'
ORDER BY PROPERTY_ID ASC

SELECT TOP 100 IH.*
FROM INTERACTION_HISTORY IH
INNER JOIN dbo.PROPERTY P ON P.ID = IH.PROPERTY_ID
INNER JOIN dbo.LENDER L ON L.ID = P.LENDER_ID
WHERE P.ID = '56762601'

SELECT * FROM dbo.PROCESS_LOG_ITEM
WHERE RELATE_ID IN (15917765,15911320)

SELECT * FROM dbo.PROCESS_LOG_ITEM
WHERE PROCESS_LOG_ID IN (29939061,29938172) 

SELECT CONTENT_XML.value('(/Content/Lender/Code)[1]', 'varchar (50)'),
CONTENT_XML.value('(/Content/Collateral/Type)[1]', 'varchar (50)'),
* FROM dbo.WORK_ITEM
WHERE ID IN (28807154, 28807731)

SELECT * FROM dbo.WORK_ITEM_ACTION
WHERE WORK_ITEM_ID = '28807154'

SELECT * FROM dbo.WORK_ITEM
WHERE --UPDATE_USER_TX = 'UBSCycle' AND 
WORKFLOW_DEFINITION_ID = '9' AND CAST(CREATE_DT AS DATE) > CAST(GETDATE()-15 AS DATE)
AND CONTENT_XML.value('(/Content/Lender/Code)[1]', 'varchar (50)') = '2965'

SELECT * FROM dbo.WORK_ITEM_ACTION
WHERE WORK_ITEM_ID IN (28807154, 28807731, 28808175) ORDER BY WORK_ITEM_ID

SELECT * FROM dbo.PROCESS_DEFINITION
WHERE ID IN (44568,
44567)

SELECT PD.Id,PD.NAME_TX, PD.EXECUTION_FREQ_CD, PD.UPDATE_DT, PD.UPDATE_USER_TX, PLI.* FROM dbo.PROCESS_LOG PL
INNER JOIN dbo.PROCESS_DEFINITION PD ON PD.ID = PL.PROCESS_DEFINITION_ID
INNER JOIN dbo.PROCESS_LOG_ITEM pli ON pli.PROCESS_LOG_ID = PL.ID
WHERE PL.ID IN (29938172, 29939061,29940170) AND 
ORDER BY PROCESS_LOG_ID ASC



SELECT 
        L.NUMBER_TX ,
        IH.ID ,
        IH.TYPE_CD ,
        IH.LOAN_ID ,
        IH.PROPERTY_ID ,
        IH.REQUIRED_COVERAGE_ID ,
        IH.DOCUMENT_ID ,
        IH.EFFECTIVE_DT ,
        IH.EFFECTIVE_ORDER_NO ,
        IH.ISSUE_DT ,
        IH.NOTE_TX ,
        IH.ALERT_IN ,
        IH.PENDING_IN ,
        IH.IN_HOUSE_ONLY_IN ,
        IH.RELATE_CLASS_TX ,
        IH.RELATE_ID ,
        IH.CREATE_DT ,
        IH.CREATE_USER_TX ,
        IH.UPDATE_DT ,
        IH.UPDATE_USER_TX ,
        IH.PURGE_DT ,
        IH.LOCK_ID ,
        IH.DELETE_ID ,
        IH.ARCHIVED_IN
FROM    dbo.PROCESS_LOG_ITEM PLI
        INNER JOIN dbo.INTERACTION_HISTORY IH ON IH.RELATE_ID = PLI.RELATE_ID
        INNER JOIN PROPERTY P ON IH.PROPERTY_ID = P.ID
        INNER JOIN COLLATERAL C ON C.PROPERTY_ID = P.ID
        INNER JOIN dbo.LOAN L ON L.ID = C.LOAN_ID
WHERE   PLI.PROCESS_LOG_ID IN ( 29938172, 29939061, 29940170 ) 
AND L.NUMBER_TX IN ('200087612043',
'351000442589',
'200106433049',
'200129401039',
'202418100054')


SELECT * FROM dbo.PROCESS_LOG_ITEM
WHERE PROCESS_LOG_ID IN 

SELECT * FROM dbo.PROCESS_LOG_ITEM
WHERE PROCESS_LOG_ID IN (SELECT PL.ID FROM dbo.PROCESS_LOG PL
INNER JOIN dbo.PROCESS_DEFINITION PD ON PD.ID = PL.PROCESS_DEFINITION_ID
WHERE PL.ID IN (SELECT ID FROM dbo.WORK_ITEM
WHERE UPDATE_USER_TX = 'UBSCycle' 
AND WORKFLOW_DEFINITION_ID = '9' AND CAST(CREATE_DT AS DATE) = CAST(GETDATE()-8 AS DATE)))