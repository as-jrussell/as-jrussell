USE [UniTrac]
GO 

--Loan Screen Information - LOAN/COLLATERAL/PROPERTY/OWNER/REQUIRED COVERAGE
SELECT  rc.* INTO UniTracHDStorage..INC0249623RC
FROM    LOAN L
        INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
        INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
        INNER JOIN REQUIRED_COVERAGE RC ON P.ID = RC.PROPERTY_ID
        INNER JOIN OWNER_LOAN_RELATE OL ON L.ID = OL.LOAN_ID
        INNER JOIN OWNER O ON OL.OWNER_ID = O.ID
        INNER JOIN OWNER_ADDRESS OA ON O.ADDRESS_ID = OA.ID
        INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
WHERE   LL.CODE_TX IN ( '1832' )
        AND L.NUMBER_TX IN ( '317042696', '317043795', '417029799',
                             '417030894', '20001572088', '20001572099',
                             '517023393', '717037415', '817009485',
                             '817009604', '817009639', '817009663',
                             '817009833', '817010130', '817010165',
                             '817011595', '817011846', '817011897',
                             '817012362', '917051696', '1017014531',
                             '1117017141', '1517242258', '1617063894',
                             '1917023170', '1917024185', '1917024789',
                             '2017071498', '2017072575', '2017072605',
                             '2017072923', '2117015646', '2117015670',
                             '2117016731', '2117016790', '2117017622',
                             '2317048149', '2317048203', '2317048270',
                             '2517035431', '2517035652', '3017107604',
                             '3117011757', '3217092791', '3817015992',
                             '3817016026', '3817016034', '3817016085',
                             '3817016093', '3917054876', '3917055260',
                             '3917055309', '3917056569', '3917056607',
                             '4017026206', '4017026273', '4017027305',
                             '4117024639', '4117025007', '4117025376',
                             '4117025422', '4117025449', '4117026475',
                             '4117026505', '4317023445', '4917011515',
                             '4917012538', '4917012562', '4917012570',
                             '5017039430', '5017039740', '5017039821',
                             '5017039902', '5017040013', '5017041087',
                             '5017041370', '5017041427', '5017041435',
                             '5117006186', '5117006372', '5117006518',
                             '5117007595', '5117007662', '5317001676',
                             '5417006920', '5617035096', '5717043600',
                             '5717043694', '5717044739', '5717044785',
                             '5717044887', '5917036829', '5917036845',
                             '6017041185', '6217060965', '6217060973',
                             '6217061236', '6217061244', '6217061252',
                             '6217062348', '6217062356', '6217062364',
                             '6217062410', '6217062488', '6217062631',
                             '6217062925', '6317051089', '6317051232',
                             '6317052344', '6317052352', '6317052409',
                             '6617036891', '6717042133', '6717042168',
                             '6717042192', '6717042206', '6717042249',
                             '6717043458', '6717043474', '6717043482',
                             '7117009683', '7217005604', '7217006694',
                             '7217006716', '7517002716', '8017002734',
                             '8017002785', '8617022248', '8617023295',
                             '8617023317', '8617023341', '8717021642',
                             '8717022770', '8717022800', '20005710200' )



--Loan Screen Information - LOAN/COLLATERAL/PROPERTY/OWNER/REQUIRED COVERAGE
SELECT  l.* INTO UniTracHDStorage..INC0249623L
FROM    LOAN L
        INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
        INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
        INNER JOIN REQUIRED_COVERAGE RC ON P.ID = RC.PROPERTY_ID
        INNER JOIN OWNER_LOAN_RELATE OL ON L.ID = OL.LOAN_ID
        INNER JOIN OWNER O ON OL.OWNER_ID = O.ID
        INNER JOIN OWNER_ADDRESS OA ON O.ADDRESS_ID = OA.ID
        INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
WHERE   LL.CODE_TX IN ( '1832' )
        AND L.NUMBER_TX IN ( '317042696', '317043795', '417029799',
                             '417030894', '20001572088', '20001572099',
                             '517023393', '717037415', '817009485',
                             '817009604', '817009639', '817009663',
                             '817009833', '817010130', '817010165',
                             '817011595', '817011846', '817011897',
                             '817012362', '917051696', '1017014531',
                             '1117017141', '1517242258', '1617063894',
                             '1917023170', '1917024185', '1917024789',
                             '2017071498', '2017072575', '2017072605',
                             '2017072923', '2117015646', '2117015670',
                             '2117016731', '2117016790', '2117017622',
                             '2317048149', '2317048203', '2317048270',
                             '2517035431', '2517035652', '3017107604',
                             '3117011757', '3217092791', '3817015992',
                             '3817016026', '3817016034', '3817016085',
                             '3817016093', '3917054876', '3917055260',
                             '3917055309', '3917056569', '3917056607',
                             '4017026206', '4017026273', '4017027305',
                             '4117024639', '4117025007', '4117025376',
                             '4117025422', '4117025449', '4117026475',
                             '4117026505', '4317023445', '4917011515',
                             '4917012538', '4917012562', '4917012570',
                             '5017039430', '5017039740', '5017039821',
                             '5017039902', '5017040013', '5017041087',
                             '5017041370', '5017041427', '5017041435',
                             '5117006186', '5117006372', '5117006518',
                             '5117007595', '5117007662', '5317001676',
                             '5417006920', '5617035096', '5717043600',
                             '5717043694', '5717044739', '5717044785',
                             '5717044887', '5917036829', '5917036845',
                             '6017041185', '6217060965', '6217060973',
                             '6217061236', '6217061244', '6217061252',
                             '6217062348', '6217062356', '6217062364',
                             '6217062410', '6217062488', '6217062631',
                             '6217062925', '6317051089', '6317051232',
                             '6317052344', '6317052352', '6317052409',
                             '6617036891', '6717042133', '6717042168',
                             '6717042192', '6717042206', '6717042249',
                             '6717043458', '6717043474', '6717043482',
                             '7117009683', '7217005604', '7217006694',
                             '7217006716', '7517002716', '8017002734',
                             '8017002785', '8617022248', '8617023295',
                             '8617023317', '8617023341', '8717021642',
                             '8717022770', '8717022800', '20005710200' )


SELECT * FROM dbo.REF_CODE
WHERE MEANING_TX LIKE '%blanket%'

SELECT TOP 1 * FROM dbo.REQUIRED_COVERAGE


UPDATE dbo.REQUIRED_COVERAGE
SET STATUS_CD = 'B', UPDATE_DT = GETDATE(),
UPDATE_USER_TX = 'INC0249623', LOCK_ID = LOCK_ID+1
--SELECT * FROM dbo.REQUIRED_COVERAGE
WHERE ID IN (SELECT ID FROM UniTracHDStorage..INC0249623RC)


INSERT INTO PROPERTY_CHANGE
 ( ENTITY_NAME_TX , ENTITY_ID , USER_TX , ATTACHMENT_IN , 
 CREATE_DT , AGENCY_ID , DESCRIPTION_TX ,  DETAILS_IN , FORMATTED_IN ,
 LOCK_ID , PARENT_NAME_TX , PARENT_ID , TRANS_STATUS_CD , UTL_IN )
 SELECT DISTINCT 'Allied.UniTrac.RequiredCoverage' , RC.ID , 'INC0249623' , 'N' , 
 GETDATE() ,  1 , 
 'Placed in Blanket Status', 
 'Y' , 'N' , 1 ,  'Allied.UniTrac.RequiredCoverage' , RC.ID , 'PEND' , 'N'
FROM REQUIRED_COVERAGE RC 
WHERE RC.ID IN (SELECT ID FROM UniTracHDStorage..INC0249623RC)