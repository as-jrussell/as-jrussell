--Loan Screen Information - LOAN/COLLATERAL/PROPERTY/OWNER/REQUIRED COVERAGE
SELECT  RC.INSURANCE_STATUS_CD, L.*     --INTO UniTracHDStorage..INC0214553
FROM    LOAN L
        INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
        INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
        INNER JOIN REQUIRED_COVERAGE RC ON P.ID = RC.PROPERTY_ID
        INNER JOIN OWNER_LOAN_RELATE OL ON L.ID = OL.LOAN_ID
        INNER JOIN OWNER O ON OL.OWNER_ID = O.ID
        INNER JOIN OWNER_ADDRESS OA ON O.ADDRESS_ID = OA.ID
WHERE   L.LENDER_ID IN ( 2217 )
        AND NUMBER_TX IN ( '194797-2', '223864-1', '223807-1', '202290-2',
                           '223861-1', '218026-2', '162878-1', '223918-1',
                           '223973-1', '124019-1', '223685-1', '140329-4',
                           '223879-1', '182240-4', '224010-1', '42773-1',
                           '223924-1', '173381-1', '224039-1', '224524-1',
                           '119966-1', '197285-3', '224157-1', '224030-1',
                           '223980-1', '211213-1', '189151-1', '224196-1',
                           '186954-1', '165078-2', '37463-1', '224201-1',
                           '224136-1', '202308-1', '218225-1', '224453-1',
                           '224118-1', '224246-1', '197593-2', '224305-1',
                           '151634-2', '224370-1', '195591-2', '224205-1',
                           '224248-1', '224257-1', '224349-1', '188580-2',
                           '211396-4', '208333-3', '113607-1', '154090-3',
                           '188828-1', '224477-1', '223262-1', '224409-1',
                           '224145-1', '176388-7', '224476-1', '224448-1',
                           '224350-1', '180650-3', '224734-1', '224621-1',
                           '11585-1', '224632-1', '164038-1', '221598-1',
                           '224673-1', '191790-1', '222906-1', '129605-14',
                           '224677-1', '224859-1', '225016-1', '224635-1',
                           '224752-1', '224623-1', '200739-1', '62933-4',
                           '224598-1', '224727-1', '141929-5', '168094-1',
                           '224853-1', '110106-3', '224446-1', '114126-2',
                           '224947-1', '225115-1', '202348-1', '225229-1',
                           '224622-1', '225061-1', '185733-3', '224894-1',
                           '225211-1', '224979-1', '175488-2', '171787-2',
                           '178131-3', '178131-2', '154835-2', '224952-1',
                           '115719-1', '224953-1', '225056-1', '202140-1',
                           '213444-2', '97658-2', '225047-1', '99188-8',
                           '104873-7', '225275-1', '225225-1', '225191-1',
                           '171122-3', '80624-3', '224627-1', '220403-2',
                           '225407-1', '225158-1', '225390-1', '225340-1',
                           '225337-1', '180412-2', '225331-1', '190529-2',
                           '195719-2', '179170-4', '225679-1', '209231-2',
                           '225416-1', '225458-1', '225054-1', '199574-1',
                           '225370-1', '189422-1', '192030-3', '154759-1',
                           '212948-2', '171771-2', '225622-1', '204119-1',
                           '206374-2', '195625-2', '225771-1', '225368-1',
                           '225621-1', '226477-1', '225425-1', '225610-1',
                           '130156-1', '226361-1', '225916-1', '167260-4',
                           '225861-1', '217019-2', '219696-2', '225925-1',
                           '225877-1', '225980-1', '226039-1', '225870-1',
                           '225940-1', '226026-1', '41384-3', '225818-1',
                           '224892-1', '225942-1', '226655-1', '226142-1',
                           '225743-1', '226216-1', '178241-5', '95064-2',
                           '198741-1', '226084-1', '187985-3', '72731-3',
                           '211872-2', '207800-3', '202725-3', '220960-1',
                           '226337-1', '71961-1', '157917-6', '39531-1',
                           '206879-2', '226572-1', '225983-1', '226315-1',
                           '226242-1', '148126-1', '171787-3', '216142-1',
                           '226310-1', '226354-1', '207300-1', '92384-1',
                           '226451-1', '216938-2', '54281-4', '167279-4',
                           '120592-1', '215388-1', '129103-2', '225530-2',
                           '161429-1', '155480-1', '226102-1', '226493-1',
                           '226407-1', '211889-1', '226644-1', '226611-1',
                           '226487-1', '181349-1', '226501-1', '226592-1',
                           '226695-1', '226567-1', '226856-1', '227002-1',
                           '226550-1', '133369-2', '226840-1', '226747-1',
                           '226829-1', '201909-2', '214726-2', '214784-3',
                           '218275-2', '227033-1', '178693-4', '227055-1',
                           '141311-2', '168811-4', '226866-1', '227012-1',
                           '226613-1', '227090-1', '227310-1', '205897-1',
                           '177731-2', '198073-2', '227073-1', '34641-1',
                           '139995-4', '169458-1', '150284-1', '144647-2',
                           '227207-1', '225782-1', '227380-1', '227241-1',
                           '166313-1', '226898-1', '170022-3', '227238-1',
                           '227133-1', '189363-1', '227270-1', '227112-1',
                           '227128-1', '182963-2', '80660-6', '227008-1',
                           '182781-2', '227264-1', '227361-1', '227323-1',
                           '208922-2', '184306-1', '227367-1', '51714-3',
                           '227397-1', '221936-1', '226604-1', '226604-2',
                           '83490-2', '182376-1', '227486-1', '227349-1',
                           '180267-1', '220978-2', '227547-1', '221288-3',
                           '227733-1', '213372-1', '227825-1', '172268-1',
                           '107275-7', '194241-1', '227776-1', '227724-1',
                           '227864-1', '105901-1', '195528-1', '227672-1',
                           '162170-17', '63861-1', '196357-2', '191807-5',
                           '300013-1', '162852-2', '173766-8', '225118-2',
                           '300079-1', '182921-3', '227770-1', '211034-1',
                           '300070-1', '300173-1', '300197-1', '7352-3',
                           '300248-1', '300303-1', '300307-1', '208118-1',
                           '140981-4', '185154-3', '162001-6', '215967-3',
                           '300420-1', '154374-3', '210798-2', '300572-1',
                           '213983-4', '221121-3', '300562-1', '300567-1',
                           '182777-4', '96375-8', '155762-6', '226326-1',
                           '300621-1', '300718-1', '221736-1', '300850-1',
                           '300813-1', '104373-8', '300713-1', '220225-2',
                           '300876-1', '300895-1', '300864-1', '300407-1',
                           '300871-1', '189314-2', '300490-1', '301013-1',
                           '130942-1', '300983-1', '58568-3', '301085-1',
                           '300948-1', '301094-1', '301098-1', '48098-3',
                           '300426-1', '301115-1', '173085-3', '143195-6',
                           '139749-1', '301230-1', '221837-2', '216505-1',
                           '301409-1', '225627-1', '301408-1', '74935-1',
                           '140076-3', '301452-1', '152245-1', '301605-1',
                           '300776-1', '167247-5', '98410-1', '177716-3',
                           '301689-1', '301708-1', '301735-1', '141760-4',
                           '301778-1', '301866-1', '301849-1', '300753-2',
                           '175586-2', '205436-1', '182450-11', '302007-1',
                           '301988-1', '84676-1', '302045-1', '302021-1',
                           '69790-1', '205390-3', '302077-1', '302061-1',
                           '214523-4', '189084-1', '179588-7', '302083-1',
                           '162231-10', '301813-1', '86185-8', '302156-1',
                           '302189-1', '195329-7', '141617-1', '176866-6',
                           '302276-1', '302306-1', '302264-1', '29776-1',
                           '302427-1', '302430-1', '302396-1', '302434-1',
                           '302446-1', '194180-2', '183416-3', '300753-3',
                           '215748-1', '302521-1', '302557-1', '214361-2',
                           '222167-1', '218769-3', '302717-1', '13747-2',
                           '302719-1', '302701-1', '302711-1', '302799-1',
                           '302698-1', '302712-1', '215656-2', '187660-2',
                           '185650-3', '302157-3', '302855-1', '159377-4',
                           '184228-4', '104488-4', '206838-2', '303007-1',
                           '302875-1', '302133-1', '303145-1', '222704-3',
                           '211456-2', '303174-1', '303165-2', '203923-2',
                           '303291-1', '303322-1', '303313-1', '303392-1',
                           '303417-1', '209427-1', '201025-3', '169246-6',
                           '303319-1', '162523-2', '303443-1', '303455-1',
                           '303454-1', '198779-3', '224436-2', '303367-2',
                           '303539-1', '303572-1', '192155-3', '173136-3',
                           '222072-2', '66483-3', '203538-6', '186546-1',
                           '220413-2', '303417-2', '303839-1', '195001-3',
                           '303873-1', '185169-1', '156372-1', '37365-9',
                           '303995-1', '185036-1', '227239-2', '197479-2',
                           '182310-3', '303566-1', '304103-1', '301829-1',
                           '304151-1', '304160-1', '304137-1', '192948-7',
                           '60781-3', '304208-1', '95933-4', '177063-1',
                           '186789-2', '304238-1', '304178-1', '304270-1',
                           '168978-3', '304300-1', '304428-1', '92055-5',
                           '90559-4', '304500-1', '223831-1', '221440-1',
                           '304491-1', '304494-1', '304481-1', '304524-1',
                           '184356-3', '304622-1', '304563-1', '202203-4',
                           '304670-1', '203525-1', '304744-1', '304729-1',
                           '304820-1', '304828-1', '197628-2', '304860-1',
                           '304880-1', '304826-1', '104061-2', '225206-2',
                           '96521-1', '192730-2', '305007-1', '222846-2',
                           '180730-3', '146972-3', '300500-2', '305185-1',
                           '305187-1', '222889-3', '57941-1', '110153-3',
                           '305155-1', '183993-1', '304923-1', '305293-1',
                           '211612-2', '174239-4', '195099-1', '305386-1',
                           '305370-1', '305389-1', '305454-1' )


SELECT * FROM dbo.LENDER
WHERE CODE_TX IN ('4198') 

SELECT * FROM dbo.REF_CODE
WHERE DOMAIN_CD = 'RequiredCoverageInsStatus'

----1) Update BRANCH_CODE_TX field in LOAN table
--UPDATE dbo.REQUIRED_COVERAGE 
--SET INSURANCE_STATUS_CD = 'A',UPDATE_DT = GETDATE() , UPDATE_USER_TX = 'INC0214553' ,
--LOCK_ID = CASE WHEN LOCK_ID >= 255 THEN 1 ELSE LOCK_ID + 1 END
----SELECT * FROM dbo.REQUIRED_COVERAGE 
--WHERE ID IN (SELECT DISTINCT ID FROM UnitracHDStorage.dbo.INC0214553)
----559


----2) Update GOOD_THRU_DT field to NULL in REQUIRED_COVERAGE table
--UPDATE RC SET RC.GOOD_THRU_DT = NULL ,RC.UPDATE_DT = GETDATE() , RC.UPDATE_USER_TX = 'INC0214553' ,
--RC.LOCK_ID = CASE WHEN RC.LOCK_ID >= 255 THEN 1 ELSE RC.LOCK_ID + 1 END
----SELECT DISTINCT RC.ID
--FROM REQUIRED_COVERAGE RC 
--INNER JOIN PROPERTY P ON RC.PROPERTY_ID = P.ID
--INNER JOIN COLLATERAL C ON P.ID = C.PROPERTY_ID
--INNER JOIN LOAN L ON L.ID = C.LOAN_ID
--WHERE L.ID IN (SELECT ID FROM UnitracHDStorage.dbo.INC0214553)
----97


----3) Insert History into PROPERTY_CHANGE table
-- INSERT INTO PROPERTY_CHANGE
-- ( ENTITY_NAME_TX , ENTITY_ID , USER_TX , ATTACHMENT_IN , 
-- CREATE_DT , AGENCY_ID , DESCRIPTION_TX ,  DETAILS_IN , FORMATTED_IN ,
-- LOCK_ID , PARENT_NAME_TX , PARENT_ID , TRANS_STATUS_CD , UTL_IN )
-- SELECT DISTINCT 'Allied.UniTrac.Loan' , L.ID , 'UNITRAC' , 'N' , 
-- GETDATE() ,  1 , 
-- 'Moved Loan to Indirect Branch', 
-- 'Y' , 'N' , 1 ,  'Allied.UniTrac.Loan' , L.ID , 'PEND' , 'N'
--FROM REQUIRED_COVERAGE RC 
--INNER JOIN PROPERTY P ON RC.PROPERTY_ID = P.ID
--INNER JOIN COLLATERAL C ON P.ID = C.PROPERTY_ID
--INNER JOIN LOAN L ON L.ID = C.LOAN_ID
--WHERE L.ID IN (SELECT ID FROM UnitracHDStorage.dbo.INC0214553)
----95





SELECT * 
INTO #TMPLOAN
FROM UnitracHDStorage.dbo.INC0214553


SELECT * FROM #TMPLOAN



----47
			



UPDATE EE
SET EE.STATUS_CD = 'CLR',
	EE.UPDATE_DT = GETDATE(),
	EE.UPDATE_USER_TX = 'TASK36311',
	EE.LOCK_ID = (EE.LOCK_ID % 255) + 1
--SELECT ee.*
FROM
	EVALUATION_EVENT ee
	JOIN #TMPLOAN te ON ee.REQUIRED_COVERAGE_ID = te.ID
	WHERE ee.STATUS_CD = 'PEND'
	AND ee.EVENT_SEQUENCE_ID > 0
---- 3024