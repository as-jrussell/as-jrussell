USE Unitrac


SELECT  L.NUMBER_TX, L.ID [LoanID], RC.* INTO UniTracHDStorage..Task41502_RC
FROM    LOAN L
        INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
        INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
        INNER JOIN REQUIRED_COVERAGE RC ON P.ID = RC.PROPERTY_ID
        INNER JOIN OWNER_LOAN_RELATE OL ON L.ID = OL.LOAN_ID
        INNER JOIN OWNER O ON OL.OWNER_ID = O.ID
        INNER JOIN OWNER_ADDRESS OA ON O.ADDRESS_ID = OA.ID
        INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
WHERE   LL.CODE_TX IN ( '2005' )
        AND L.ID IN ( '4826673', '4936145', '5153859', '49332593',
                             '69431283', '81044969', '148693563', '150295577',
                             '81921329', '49202408', '124964822', '49718624',
                             '51229990', '52514997', '57951002', '58288485',
                             '59684943', '60519860', '60840911', '61231938',
                             '63880508', '66987563', '68669008', '69431262',
                             '107299786', '70578107', '70690500', '97625544',
                             '71291508', '107299641', '71870693', '72433805',
                             '73915576', '123508362', '74760207', '77493397',
                             '79124849', '80060246', '81061848', '81921180',
                             '81921637', '82871494', '82871655', '82871658',
                             '83299520', '88161409', '89543546', '90244495',
                             '153686292', '90244559', '90247278', '90897767',
                             '91530373', '92205180', '93773884', '93773998',
                             '95072145', '95072177', '95072330', '96604193',
                             '107299328', '96606111', '107299992', '98416929',
                             '107299373', '98416942', '107299464', '107300067',
                             '98416992', '107299269', '107299308', '107299315',
                             '107299388', '107299400', '107299446',
                             '107299564', '107299748', '111365643',
                             '111365644', '111365654', '111367393',
                             '111367459', '111367521', '111367536',
                             '111367638', '111367654', '114637787',
                             '114637852', '114637883', '114638281',
                             '114638308', '114638321', '114638550',
                             '114638612', '114913335', '114914044',
                             '114914112', '114914469', '114914601',
                             '115635919', '115636064', '129829556',
                             '116362646', '117707063', '117707121',
                             '117707137', '117707158', '117707173',
                             '117707182', '118975930', '118976250',
                             '118976285', '118976295', '118976364',
                             '118976378', '118976383', '119292782',
                             '120575532', '120575767', '120575806',
                             '120575934', '122071121', '122071247',
                             '122071317', '123508004', '123508182',
                             '123508195', '123508261', '123508275',
                             '123508295', '123508306', '123508332',
                             '123508370', '123508395', '123508411',
                             '124964874', '124965082', '124965082',
                             '124965120', '124965166', '124965200',
                             '126209105', '126214222', '126214226',
                             '126214385', '126538939', '129829232',
                             '129829244', '129829265', '129829286',
                             '129829306', '129829373', '129829383',
                             '129829402', '129829434', '129830430',
                             '129831399', '129831483', '129831486',
                             '130509428', '130509457', '130853067',
                             '130853083', '130853164', '130853165',
                             '130853174', '130853227', '132407398',
                             '132407795', '132407913', '132408678',
                             '132408909', '132408926', '132408997',
                             '155368053', '132409026', '132409093',
                             '132409137', '129831547', '132409207',
                             '132409252', '132409255', '136886988',
                             '136887058', '136887113', '136887208',
                             '136887319', '136887324', '136887509',
                             '136887518', '136887550', '1602361', '136887688',
                             '136887712', '136887727', '136887743',
                             '136887839', '136887881', '136888011',
                             '136888039', '136888148', '136888149',
                             '136888154', '136888161', '136888175',
                             '136888198', '136888227', '136888233',
                             '139225161', '139225645', '139227324',
                             '139227333', '139227857', '139228094',
                             '139228099', '139228099', '139228104',
                             '139228105', '139228111', '139228145',
                             '139228149', '139228158', '139228159',
                             '139228198', '139775450', '139775535',
                             '141189609', '141192682', '141194175',
                             '141202752', '141205567', '63880472', '76964793',
                             '77494300', '88818203', '89543414', '107299323',
                             '114638333', '114914516', '126214402',
                             '136886970', '139228110', '141205824',
                             '155368259', '141208547', '141208548',
                             '141208648', '141209207', '141209210',
                             '141209221', '141209223', '141209230',
                             '141209285', '141209314', '143070737', '5147214',
                             '143070879', '143070905', '143070906',
                             '146734915', '146735090', '146735189',
                             '146735330', '146736370', '114914538',
                             '146736401', '146736413', '146736415',
                             '146736424', '146736597', '147026156',
                             '147026266', '147026451', '147026456',
                             '147026490', '147026503', '148693566',
                             '148693573', '148693767', '148694174',
                             '148694186', '148694200', '148694230',
                             '148694332', '148694818', '148695839',
                             '148695842', '148695872', '148695891',
                             '150295548', '150297178', '150297195',
                             '150297221', '150297229', '150297230',
                             '150297394', '150297424', '150297477',
                             '151958775', '151958783', '151958789',
                             '151958797', '151958810', '151958826',
                             '151958846', '151958902', '151959774',
                             '151959789', '151959795', '153685953',
                             '153685961', '153686178', '153686194',
                             '153686203', '153686217', '153686216',
                             '153686291', '153686399', '155365759',
                             '155366097', '155366625', '155367140',
                             '155368172', '155368181', '155368241',
                             '155368263', '155368267', '155368283',
                             '155368300', '155368306', '155368316',
                             '157012052', '157012074', '157012135',
                             '157012197', '157012342', '157012349',
                             '157012364', '158497314', '157012424',
                             '157012437', '157012469', '166660110',
                             '157012474', '157012480', '157012484',
                             '158497427', '158497509', '158497562',
                             '158497582', '158497599', '158497613',
                             '158497658', '158497666', '158497671',
                             '158497697', '158497700', '158497783',
                             '158497830', '160065063', '160065193',
                             '160065259', '160065276', '160065322',
                             '160065354', '160065370', '160065382',
                             '160065550', '160065562', '160065590',
                             '161724746', '161724798', '161724824',
                             '161724827', '161724829', '161724847',
                             '161724850', '161724869', '161724880',
                             '161724980', '161725078', '161725863',
                             '161725871', '161725876', '161725880',
                             '161725896', '163263591', '163263650',
                             '163263934', '163263936', '163263951',
                             '163264026', '163264031', '163264036',
                             '163264038', '163264039', '163264050',
                             '163264056', '164957176', '164957247',
                             '164957313', '114638224', '164957698',
                             '164958741', '164958753', '164958760',
                             '164958764', '164958772', '164958776',
                             '164958804', '164958820', '166659722',
                             '166659755', '166659923', '166659930',
                             '166659980', '166660000', '166660013',
                             '166660150', '166660255', '168367813',
                             '168367911', '168368244', '168368288',
                             '168368305', '168368312', '168368362',
                             '169911438', '169911482', '169911781',
                             '169911790', '169911912', '169911924',
                             '169911927', '169916316', '169916400',
                             '169916399', '169916471', '169916529',
                             '171614136', '171614198', '171614308',
                             '171614309', '171614784', '171615006',
                             '171615018', '55352518', '171615599', '171615882',
                             '171615911' )

SELECT * INTO UniTracHDStorage..Task41502_L
FROM dbo.NOTICE
WHERE LOAN_ID IN (SELECT LoanID FROM UniTracHDStorage..Task41502_RC)

UPDATE  rc
SET     NOTICE_DT = NULL ,
        NOTICE_SEQ_NO = ( NOTICE_SEQ_NO - 1 ) ,
        LAST_EVENT_DT = NULL ,
        LAST_EVENT_SEQ_ID = NULL ,
        LAST_SEQ_CONTAINER_ID = NULL ,
        GOOD_THRU_DT = NULL ,
        UPDATE_DT = GETDATE() ,
        LOCK_ID = ( LOCK_ID % 255 ) + 1 ,
        UPDATE_USER_TX = 'Task41502'
				  --SELECT NOTICE_DT, NOTICE_SEQ_NO,* 
FROM    dbo.REQUIRED_COVERAGE rc
WHERE   ID IN (SELECT ID FROM UniTracHDStorage..Task41502_RC)
				AND NOTICE_DT IS NOT NULL
			
			
UPDATE  IH
SET     PURGE_DT = GETDATE() ,
        UPDATE_USER_TX = 'Task41502' ,
        UPDATE_DT = GETDATE() ,
        LOCK_ID = ( IH.LOCK_ID % 255 ) + 1		
		          --SELECT * 
FROM    INTERACTION_HISTORY IH
        JOIN NOTICE NTC ON NTC.CPI_QUOTE_ID = IH.RELATE_ID
WHERE   IH.RELATE_CLASS_TX = 'Allied.Unitrac.CPIQuote'
        AND IH.TYPE_CD = 'CPI'
        AND NTC.id IN (SELECT ID FROM UniTracHDStorage..Task41502_L)
		AND IH.UPDATE_DT >= '2017-06-22 '


	
INSERT INTO PROPERTY_CHANGE
 ( ENTITY_NAME_TX , ENTITY_ID , USER_TX , ATTACHMENT_IN , 
 CREATE_DT , AGENCY_ID , DESCRIPTION_TX ,  DETAILS_IN , FORMATTED_IN ,
 LOCK_ID , PARENT_NAME_TX , PARENT_ID , TRANS_STATUS_CD , UTL_IN )
 SELECT DISTINCT 'Allied.UniTrac.RequiredCoverage' , ID , 'Task41502' , 'N' , 
 GETDATE() ,  1 , 
'Cleared Notice Cycle', 
 'Y' , 'N' , 1 ,  'Allied.UniTrac.RequiredCoverage' , ID , 'PEND' , 'N'
FROM    dbo.REQUIRED_COVERAGE rc
WHERE   ID IN (SELECT ID FROM UniTracHDStorage..Task41502_RC)
				AND NOTICE_DT IS NOT NULL