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



SELECT  rc.*
INTO    UniTracHDStorage..INC0251535L
FROM    LOAN L
        INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
        INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
        INNER JOIN REQUIRED_COVERAGE RC ON P.ID = RC.PROPERTY_ID
        INNER JOIN OWNER_LOAN_RELATE OL ON L.ID = OL.LOAN_ID
        INNER JOIN OWNER O ON OL.OWNER_ID = O.ID
        INNER JOIN OWNER_ADDRESS OA ON O.ADDRESS_ID = OA.ID
        INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
WHERE   LL.CODE_TX IN ( '1832' )
        AND L.NUMBER_TX IN ( '117100080', '117100978', '117101109',
                             '117101222', '117101265', '117102261',
                             '217028241', '317042254', '20001571989',
                             '317042610', '317042629', '317042696',
                             '317042750', '317043795', '317043838',
                             '317043846', '20001572044', '417029594',
                             '417029705', '417029721', '417029780',
                             '417029799', '417029802', '417029810',
                             '417030835', '20001572077', '417030894',
                             '417030908', '417030916', '20001572088',
                             '20001572099', '517022176', '517022273',
                             '517022311', '517022346', '517022362',
                             '517022389', '517023385', '517023393',
                             '517023445', '717035719', '717035891',
                             '717036049', '717036073', '717036111',
                             '717037258', '717037274', '717037415',
                             '717037479', '817009183', '817009426',
                             '817009485', '817009604', '817009639',
                             '817009663', '817009671', '817009736',
                             '817009744', '817009825', '817009833',
                             '817009981', '817010025', '817010130',
                             '817010165', '817010386', '817010505',
                             '817011595', '817011617', '817011684',
                             '817011722', '817011846', '817011854',
                             '817011889', '817011897', '817011965',
                             '817012028', '817012044', '817012095',
                             '817012362', '917051696', '1017014531',
                             '1017014566', '1017015686', '1117015718',
                             '1117016072', '1117017087', '1117017133',
                             '1117017141', '1117017155', '1517238714',
                             '1517241650', '1517242258', '1517242355',
                             '1517242762', '1517243475', '1517245648',
                             '1517246040', '1517246105', '1617062812',
                             '1617063835', '1617063894', '1617063959',
                             '1717018173', '1717018289', '1717018661',
                             '1917023030', '1917023138', '1917023146',
                             '1917023154', '1917023170', '1917024185',
                             '1917024789', '2017068985', '2017069655',
                             '2017070300', '2017070335', '2017070742',
                             '2017070750', '2017070866', '2017071129',
                             '2017071145', '2017071285', '2017071471',
                             '2017071498', '2017072575', '2017072605',
                             '2017072656', '2017072737', '2017072923',
                             '2117015646', '2117015670', '2117015700',
                             '2117016731', '2117016758', '2117016790',
                             '2117016812', '2117017622', '2317047827',
                             '2317048114', '2317048122', '2317048149',
                             '2317048203', '2317048238', '2317048270',
                             '2317049412', '2317049439', '2317049544',
                             '2317049587', '2317049676', '2317049951',
                             '2517034079', '2517034087', '2517035253',
                             '2517035305', '2517035431', '2517035652',
                             '2817083024', '2817083466', '2817083660',
                             '2817083695', '2817084735', '2817084772',
                             '2817084837', '3017017400', '3017017567',
                             '3017017672', '3017017958', '3017107582',
                             '3017107604', '3017107620', '3117010629',
                             '3117010645', '3117010661', '3117010688',
                             '3117011749', '3117011757', '3217090403',
                             '3217091477', '3217092791', '3217092805',
                             '3217092813', '3217092961', '3217092996',
                             '3217094174', '3217094239', '3217094263',
                             '3217094298', '3817014945', '3817014953',
                             '3817015992', '3817016005', '3817016018',
                             '3817016026', '3817016034', '3817016085',
                             '3817016093', '3917054876', '3917054965',
                             '3917055074', '3917055260', '3917055309',
                             '3917055376', '3917055422', '3917056429',
                             '3917056461', '3917056550', '3917056569',
                             '3917056585', '3917056607', '3917056615',
                             '3917056623', '3917056879', '4017025722',
                             '4017025811', '4017026192', '4017026206',
                             '4017026273', '4017027288', '4017027305',
                             '4117024639', '4117025007', '4117025015',
                             '4117025325', '4117025376', '4117025406',
                             '4117025422', '4117025449', '4117026475',
                             '4117026505', '4117026542', '4117026569',
                             '4117026623', '4217013086', '4217013094',
                             '4317021986', '4317022095', '4317023393',
                             '4317023445', '4717015991', '4717016535',
                             '4817017406', '4917010853', '4917011450',
                             '4917011469', '4917011515', '4917012538',
                             '4917012562', '4917012570', '5017038779',
                             '5017039430', '5017039538', '5017039740',
                             '5017039759', '5017039775', '5017039783',
                             '5017039821', '5017039864', '5017039902',
                             '5017039945', '5017040005', '5017040013',
                             '5017040021', '5017041079', '5017041087',
                             '5017041095', '5017041117', '5017041249',
                             '5017041257', '5017041265', '5017041273',
                             '5017041295', '5017041311', '5017041325',
                             '5017041370', '5017041427', '5017041435',
                             '5017041635', '5017041702', '5117006186',
                             '5117006224', '5117006283', '5117006372',
                             '5117006380', '5117006496', '5117006518',
                             '5117006534', '5117007565', '5117007595',
                             '5117007662', '5317001676', '5417005622',
                             '5417005797', '5417006920', '5617035045',
                             '5617035096', '5617035142', '5617035231',
                             '5617035274', '5717007654', '5717043600',
                             '5717043651', '5717043694', '5717043708',
                             '5717044712', '5717044720', '5717044739',
                             '5717044747', '5717044785', '5717044801',
                             '5717044815', '5717044844', '5717044887',
                             '5917036497', '5917036829', '5917036845',
                             '5917036918', '6017041061', '6017041150',
                             '6017041177', '6017041185', '6017042238',
                             '6117038453', '6217058952', '6217059037',
                             '6217059185', '6217060965', '6217060973',
                             '6217061007', '6217061031', '6217061120',
                             '6217061236', '6217061244', '6217061252',
                             '6217062275', '6217062291', '6217062348',
                             '6217062356', '6217062364', '6217062410',
                             '6217062429', '6217062488', '6217062550',
                             '6217062631', '6217062925', '6317049521',
                             '6317049858', '6317050201', '6317050880',
                             '6317050996', '6317051062', '6317051089',
                             '6317051208', '6317051232', '6317052298',
                             '6317052315', '6317052344', '6317052352',
                             '6317052409', '6317052433', '6317052565',
                             '6417034461', '6417034488', '6417034534',
                             '6517037004', '6517037039', '6517037209',
                             '6617036697', '6617036832', '6617036875',
                             '6617036883', '6617036891', '6717041919',
                             '6717042052', '6717042133', '6717042168',
                             '6717042184', '6717042192', '6717042206',
                             '6717042230', '6717042249', '6717042311',
                             '6717042370', '6717043377', '6717043393',
                             '6717043407', '6717043458', '6717043474',
                             '6717043482', '6717043520', '7117008598',
                             '7117009640', '7117009683', '7117009713',
                             '7217005604', '7217005612', '7217006694',
                             '7217006716', '7317005096', '7417003109',
                             '7417003575', '7517002694', '7517002716',
                             '8017002203', '8017002734', '8017002777',
                             '8017002785', '8017003795', '8017003803',
                             '8617021691', '8617022175', '8617022191',
                             '8617022221', '8617022248', '8617022264',
                             '8617022272', '8617023295', '8617023317',
                             '8617023333', '8617023341', '8617023384',
                             '8617023511', '8717021642', '8717021685',
                             '8717022770', '8717022797', '8717022800',
                             '20005710200' )


SELECT  rc.*
INTO    UniTracHDStorage..INC0251535RC
FROM    LOAN L
        INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
        INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
        INNER JOIN REQUIRED_COVERAGE RC ON P.ID = RC.PROPERTY_ID
        INNER JOIN OWNER_LOAN_RELATE OL ON L.ID = OL.LOAN_ID
        INNER JOIN OWNER O ON OL.OWNER_ID = O.ID
        INNER JOIN OWNER_ADDRESS OA ON O.ADDRESS_ID = OA.ID
        INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
WHERE   LL.CODE_TX IN ( '1832' )
        AND L.NUMBER_TX IN ( '117100080', '117100978', '117101109',
                             '117101222', '117101265', '117102261',
                             '217028241', '317042254', '20001571989',
                             '317042610', '317042629', '317042696',
                             '317042750', '317043795', '317043838',
                             '317043846', '20001572044', '417029594',
                             '417029705', '417029721', '417029780',
                             '417029799', '417029802', '417029810',
                             '417030835', '20001572077', '417030894',
                             '417030908', '417030916', '20001572088',
                             '20001572099', '517022176', '517022273',
                             '517022311', '517022346', '517022362',
                             '517022389', '517023385', '517023393',
                             '517023445', '717035719', '717035891',
                             '717036049', '717036073', '717036111',
                             '717037258', '717037274', '717037415',
                             '717037479', '817009183', '817009426',
                             '817009485', '817009604', '817009639',
                             '817009663', '817009671', '817009736',
                             '817009744', '817009825', '817009833',
                             '817009981', '817010025', '817010130',
                             '817010165', '817010386', '817010505',
                             '817011595', '817011617', '817011684',
                             '817011722', '817011846', '817011854',
                             '817011889', '817011897', '817011965',
                             '817012028', '817012044', '817012095',
                             '817012362', '917051696', '1017014531',
                             '1017014566', '1017015686', '1117015718',
                             '1117016072', '1117017087', '1117017133',
                             '1117017141', '1117017155', '1517238714',
                             '1517241650', '1517242258', '1517242355',
                             '1517242762', '1517243475', '1517245648',
                             '1517246040', '1517246105', '1617062812',
                             '1617063835', '1617063894', '1617063959',
                             '1717018173', '1717018289', '1717018661',
                             '1917023030', '1917023138', '1917023146',
                             '1917023154', '1917023170', '1917024185',
                             '1917024789', '2017068985', '2017069655',
                             '2017070300', '2017070335', '2017070742',
                             '2017070750', '2017070866', '2017071129',
                             '2017071145', '2017071285', '2017071471',
                             '2017071498', '2017072575', '2017072605',
                             '2017072656', '2017072737', '2017072923',
                             '2117015646', '2117015670', '2117015700',
                             '2117016731', '2117016758', '2117016790',
                             '2117016812', '2117017622', '2317047827',
                             '2317048114', '2317048122', '2317048149',
                             '2317048203', '2317048238', '2317048270',
                             '2317049412', '2317049439', '2317049544',
                             '2317049587', '2317049676', '2317049951',
                             '2517034079', '2517034087', '2517035253',
                             '2517035305', '2517035431', '2517035652',
                             '2817083024', '2817083466', '2817083660',
                             '2817083695', '2817084735', '2817084772',
                             '2817084837', '3017017400', '3017017567',
                             '3017017672', '3017017958', '3017107582',
                             '3017107604', '3017107620', '3117010629',
                             '3117010645', '3117010661', '3117010688',
                             '3117011749', '3117011757', '3217090403',
                             '3217091477', '3217092791', '3217092805',
                             '3217092813', '3217092961', '3217092996',
                             '3217094174', '3217094239', '3217094263',
                             '3217094298', '3817014945', '3817014953',
                             '3817015992', '3817016005', '3817016018',
                             '3817016026', '3817016034', '3817016085',
                             '3817016093', '3917054876', '3917054965',
                             '3917055074', '3917055260', '3917055309',
                             '3917055376', '3917055422', '3917056429',
                             '3917056461', '3917056550', '3917056569',
                             '3917056585', '3917056607', '3917056615',
                             '3917056623', '3917056879', '4017025722',
                             '4017025811', '4017026192', '4017026206',
                             '4017026273', '4017027288', '4017027305',
                             '4117024639', '4117025007', '4117025015',
                             '4117025325', '4117025376', '4117025406',
                             '4117025422', '4117025449', '4117026475',
                             '4117026505', '4117026542', '4117026569',
                             '4117026623', '4217013086', '4217013094',
                             '4317021986', '4317022095', '4317023393',
                             '4317023445', '4717015991', '4717016535',
                             '4817017406', '4917010853', '4917011450',
                             '4917011469', '4917011515', '4917012538',
                             '4917012562', '4917012570', '5017038779',
                             '5017039430', '5017039538', '5017039740',
                             '5017039759', '5017039775', '5017039783',
                             '5017039821', '5017039864', '5017039902',
                             '5017039945', '5017040005', '5017040013',
                             '5017040021', '5017041079', '5017041087',
                             '5017041095', '5017041117', '5017041249',
                             '5017041257', '5017041265', '5017041273',
                             '5017041295', '5017041311', '5017041325',
                             '5017041370', '5017041427', '5017041435',
                             '5017041635', '5017041702', '5117006186',
                             '5117006224', '5117006283', '5117006372',
                             '5117006380', '5117006496', '5117006518',
                             '5117006534', '5117007565', '5117007595',
                             '5117007662', '5317001676', '5417005622',
                             '5417005797', '5417006920', '5617035045',
                             '5617035096', '5617035142', '5617035231',
                             '5617035274', '5717007654', '5717043600',
                             '5717043651', '5717043694', '5717043708',
                             '5717044712', '5717044720', '5717044739',
                             '5717044747', '5717044785', '5717044801',
                             '5717044815', '5717044844', '5717044887',
                             '5917036497', '5917036829', '5917036845',
                             '5917036918', '6017041061', '6017041150',
                             '6017041177', '6017041185', '6017042238',
                             '6117038453', '6217058952', '6217059037',
                             '6217059185', '6217060965', '6217060973',
                             '6217061007', '6217061031', '6217061120',
                             '6217061236', '6217061244', '6217061252',
                             '6217062275', '6217062291', '6217062348',
                             '6217062356', '6217062364', '6217062410',
                             '6217062429', '6217062488', '6217062550',
                             '6217062631', '6217062925', '6317049521',
                             '6317049858', '6317050201', '6317050880',
                             '6317050996', '6317051062', '6317051089',
                             '6317051208', '6317051232', '6317052298',
                             '6317052315', '6317052344', '6317052352',
                             '6317052409', '6317052433', '6317052565',
                             '6417034461', '6417034488', '6417034534',
                             '6517037004', '6517037039', '6517037209',
                             '6617036697', '6617036832', '6617036875',
                             '6617036883', '6617036891', '6717041919',
                             '6717042052', '6717042133', '6717042168',
                             '6717042184', '6717042192', '6717042206',
                             '6717042230', '6717042249', '6717042311',
                             '6717042370', '6717043377', '6717043393',
                             '6717043407', '6717043458', '6717043474',
                             '6717043482', '6717043520', '7117008598',
                             '7117009640', '7117009683', '7117009713',
                             '7217005604', '7217005612', '7217006694',
                             '7217006716', '7317005096', '7417003109',
                             '7417003575', '7517002694', '7517002716',
                             '8017002203', '8017002734', '8017002777',
                             '8017002785', '8017003795', '8017003803',
                             '8617021691', '8617022175', '8617022191',
                             '8617022221', '8617022248', '8617022264',
                             '8617022272', '8617023295', '8617023317',
                             '8617023333', '8617023341', '8617023384',
                             '8617023511', '8717021642', '8717021685',
                             '8717022770', '8717022797', '8717022800',
                             '20005710200' )


							 
UPDATE dbo.REQUIRED_COVERAGE
SET STATUS_CD = 'B', UPDATE_DT = GETDATE(),
UPDATE_USER_TX = 'INC0251535', LOCK_ID = LOCK_ID+1
--SELECT * FROM dbo.REQUIRED_COVERAGE
WHERE ID IN (SELECT ID FROM UniTracHDStorage..INC0251535RC)


INSERT INTO PROPERTY_CHANGE
 ( ENTITY_NAME_TX , ENTITY_ID , USER_TX , ATTACHMENT_IN , 
 CREATE_DT , AGENCY_ID , DESCRIPTION_TX ,  DETAILS_IN , FORMATTED_IN ,
 LOCK_ID , PARENT_NAME_TX , PARENT_ID , TRANS_STATUS_CD , UTL_IN )
 SELECT DISTINCT 'Allied.UniTrac.RequiredCoverage' , RC.ID , 'INC0251535' , 'N' , 
 GETDATE() ,  1 , 
 'Placed in Blanket Status', 
 'Y' , 'N' , 1 ,  'Allied.UniTrac.RequiredCoverage' , RC.ID , 'PEND' , 'N'
FROM REQUIRED_COVERAGE RC 
WHERE RC.ID IN (SELECT ID FROM UniTracHDStorage..INC0251535RC)