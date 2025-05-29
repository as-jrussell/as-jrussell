SELECT L.NUMBER_TX,
        RC.* --INTO UniTracHDStorage..Bug36095_110415
FROM    LOAN L
        INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
        INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
        INNER JOIN REQUIRED_COVERAGE RC ON P.ID = RC.PROPERTY_ID
        INNER JOIN OWNER_LOAN_RELATE OL ON L.ID = OL.LOAN_ID
        INNER JOIN OWNER O ON OL.OWNER_ID = O.ID
        INNER JOIN OWNER_ADDRESS OA ON O.ADDRESS_ID = OA.ID
WHERE   L.LENDER_ID IN ('968' , '1810')
        AND L.OFFICER_CODE_TX = '382'
        AND NUMBER_TX NOT IN ( '30235680-81-3', '30235791-81-8',
                               '30235436-81-0', '30235751-81-2',
                               '30235576-81-3', '30235259-81-6',
                               '30235526-81-8', '30235737-81-1',
                               '30235722-81-3', '30235648-81-0',
                               '30235711-81-6', '30235787-81-6',
                               '30235225-81-7', '30235611-81-8',
                               '30235383-81-4', '30235356-81-0',
                               '30235400-81-6', '30235626-81-6',
                               '30235390-81-9', '30235768-80-8',
                               '30235756-81-1', '30235460-81-0',
                               '30235686-81-0', '30235617-81-5',
                               '30235358-81-6', '30235675-81-3',
                               '30235330-81-5', '30235623-81-3',
                               '30235236-83-0', '30235446-81-9',
                               '30235426-80-3', '30235583-81-9',
                               '30235692-81-8', '30235216-81-6',
                               '30235475-80-0', '30235716-81-5',
                               '30235749-81-6', '30235289-81-3',
                               '30235331-83-9', '30235702-81-5',
                               '30235297-80-8', '30235315-81-6',
                               '30235533-81-4', '30235448-81-5',
                               '30235599-81-5', '30235788-81-4',
                               '30235773-81-6', '30235616-81-7',
                               '30235492-81-3', '30235559-81-9',
                               '30235219-80-2', '30235762-81-9',
                               '30235499-81-8', '30235759-81-5',
                               '30235632-81-4', '30235776-80-1',
                               '30235417-81-0', '30235745-80-6',
                               '30235257-81-0', '30235793-81-4',
                               '30235539-80-3', '30235541-80-9',
                               '30235215-81-8', '30235800-81-7',
                               '30235224-80-2', '30235408-80-1',
                               '30235650-80-8', '30235494-81-9',
                               '30235469-81-1', '30235470-81-9',
                               '30235767-81-8', '30235497-81-2',
                               '30235684-81-5', '30235284-81-4',
                               '30235440-81-2', '30235808-81-0',
                               '30235580-81-5', '30235795-81-9',
                               '30235253-80-1', '30235510-81-2',
                               '30235779-81-3', '30235707-81-4',
                               '30235671-81-2', '30235653-81-0',
                               '30235308-81-1', '30235771-81-0',
                               '30235803-81-1', '30235789-81-2',
                               '30235503-81-7', '30235339-81-6',
                               '30235578-81-9', '30235352-81-9',
                               '30235631-81-6', '30235341-81-2',
                               '30235237-81-2', '30235554-80-2',
                               '30235205-80-1', '30235805-81-6',
                               '30235396-81-6', '30235495-80-8',
                               '30235538-80-5', '30235807-81-2',
                               '30235371-80-1', '30235581-81-3',
                               '30235508-81-6', '30235252-80-3',
                               '30235380-80-2', '30235465-81-9',
                               '30235261-81-2', '30235394-80-3',
                               '30235365-81-1', '30235544-81-1',
                               '30235262-81-0', '30235279-81-4',
                               '30235277-80-0', '30235695-80-3',
                               '30235577-80-3', '30235550-81-8',
                               '30235664-81-7', '30235486-80-7',
                               '30235414-81-7', '30235669-80-8',
                               '30235697-80-9', '30235428-80-9',
                               '30235326-80-5' )


 --AND NUMBER_TX = '30235262-81-0', '30235213-80-5'



SELECT * FROM UniTracHDStorage..Bug36095_110415


SELECT * FROM dbo.REF_CODE
WHERE DESCRIPTION_TX LIKE '%blanket%'


SELECT * FROM dbo.REF_CODE
WHERE DOMAIN_CD = 'RequiredCoverageStatus'


SELECT * FROM dbo.REF_CODE
WHERE CODE_CD = 'Waive'


SELECT * FROM dbo.REF_CODE	
WHERE DOMAIN_CD = 'WaiveTrackReason'

SELECT * FROM dbo.REF_CODE	
WHERE DOMAIN_CD = 'TrackingReqCovStatusChange'

SELECT  *  FROM dbo.PROPERTY
WHERE VIN_TX = '45C1FA0' AND LENDER_ID = '968'


SELECT * FROM UniTracHDStorage..Bug36095_110415


--1) Update INSURANCE_STATUS_CD field in REQUIRED_COVERAGE table
UPDATE dbo.REQUIRED_COVERAGE 
SET STATUS_CD = 'B', INSURANCE_STATUS_CD = 'A', UPDATE_DT = GETDATE() , UPDATE_USER_TX = 'Bug36095' ,
LOCK_ID = CASE WHEN LOCK_ID >= 255 THEN 1 ELSE LOCK_ID + 1 END
--SELECT * FROM REQUIRED_COVERAGE
WHERE ID IN (SELECT ID FROM UniTracHDStorage..Bug36095_110415)
--144
--

--2) Update GOOD_THRU_DT field to NULL in REQUIRED_COVERAGE table
UPDATE RC SET RC.GOOD_THRU_DT = NULL ,RC.UPDATE_DT = GETDATE() , RC.UPDATE_USER_TX = 'Bug36095' ,
RC.LOCK_ID = CASE WHEN RC.LOCK_ID >= 255 THEN 1 ELSE RC.LOCK_ID + 1 END
--SELECT *
FROM REQUIRED_COVERAGE RC 
INNER JOIN PROPERTY P ON RC.PROPERTY_ID = P.ID
INNER JOIN COLLATERAL C ON P.ID = C.PROPERTY_ID
INNER JOIN LOAN L ON L.ID = C.LOAN_ID
WHERE L.ID IN (SELECT ID FROM UniTracHDStorage..Bug36095_110415)
--12


--3) Insert History into PROPERTY_CHANGE table
 INSERT INTO PROPERTY_CHANGE
 ( ENTITY_NAME_TX , ENTITY_ID , USER_TX , ATTACHMENT_IN , 
 CREATE_DT , AGENCY_ID , DESCRIPTION_TX ,  DETAILS_IN , FORMATTED_IN ,
 LOCK_ID , PARENT_NAME_TX , PARENT_ID , TRANS_STATUS_CD , UTL_IN )
 SELECT DISTINCT 'Allied.UniTrac.Loan' , L.ID , 'UNITRAC' , 'N' , 
 GETDATE() ,  1 , 
 'Moved RC to Blanket Status', 
 'Y' , 'N' , 1 ,  'Allied.UniTrac.Loan' , L.ID , 'PEND' , 'N'
FROM REQUIRED_COVERAGE RC 
INNER JOIN PROPERTY P ON RC.PROPERTY_ID = P.ID
INNER JOIN COLLATERAL C ON P.ID = C.PROPERTY_ID
INNER JOIN LOAN L ON L.ID = C.LOAN_ID
WHERE L.ID IN (SELECT ID FROM UniTracHDStorage..Bug36095_110415)
--12



EXEC sp_who3

