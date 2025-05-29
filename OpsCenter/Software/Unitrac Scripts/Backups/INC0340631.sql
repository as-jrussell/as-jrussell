USE [UniTrac]
GO 

--Loan Screen Information - LOAN/COLLATERAL/PROPERTY/OWNER/REQUIRED COVERAGE
SELECT  RC.* INTO UniTracHDStorage..INC0340631
FROM    LOAN L
        INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
        INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
        INNER JOIN REQUIRED_COVERAGE RC ON P.ID = RC.PROPERTY_ID
        INNER JOIN OWNER_LOAN_RELATE OL ON L.ID = OL.LOAN_ID
        INNER JOIN OWNER O ON OL.OWNER_ID = O.ID
        INNER JOIN OWNER_ADDRESS OA ON O.ADDRESS_ID = OA.ID
        INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
WHERE   LL.CODE_TX IN ( '3255' )
        AND L.NUMBER_TX IN ( '22383', '22384', '22385', '22386', '22387',
                             '400061', '100081', '1000242', '1000243',
                             '1000244', '2000588', '2000685', '400012',
                             '400013', '400016', '400017', '400018', '400019',
                             '400020', '400027', '400031', '400037', '400038',
                             '400046', '400053', '400055', '400056', '400057',
                             '400064', '400065', '400066', '400067', '400076',
                             '400092', '400114', '400181', '400203', '400211',
                             '400262', '400408', '400424', '22023', '2000473',
                             '2000652', '2000677', '22616', '2001101', '22188',
                             '22190', '22192', '22213', '22246', '22249',
                             '22341', '22342', '22721', '23450', '24813',
                             '1000093', '2000545', '5000586', '22325', '22378',
                             '22379', '22438', '22896', '22698', '23922',
                             '24139', '24155', '24163', '24791', '1000258',
                             '1000373', '1001000', '22133', '22135', '22180',
                             '22187', '22216', '22232', '22281', '22470',
                             '24783', '1000118', '1000124', '60006381',
                             '22241', '22242', '1000188', '2000589', '2000638',
                             '3090254', '23329', '22408', '22748', '23345',
                             '23345', '23345', '23345', '23345', '22403',
                             '22408', '22756', '22748', '22375', '22375',
                             '22375', '22375', '22375', '22409', '22409',
                             '22409', '2002078', '2002078', '2002078',
                             '2002078', '2000681' )

	
UPDATE dbo.REQUIRED_COVERAGE
SET  UPDATE_DT = GETDATE(),UPDATE_USER_TX = 'INC0340631', LOCK_ID = CASE WHEN LOCK_ID >= 255 THEN 1 ELSE LOCK_ID + 1 END, STATUS_CD = 'T'
--SELECT * FROM dbo.REQUIRED_COVERAGE
WHERE ID IN (SELECT ID FROM UniTracHDStorage..INC0340631)
	
	
	
INSERT INTO PROPERTY_CHANGE
 ( ENTITY_NAME_TX , ENTITY_ID , USER_TX , ATTACHMENT_IN , 
 CREATE_DT , AGENCY_ID , DESCRIPTION_TX ,  DETAILS_IN , FORMATTED_IN ,
 LOCK_ID , PARENT_NAME_TX , PARENT_ID , TRANS_STATUS_CD , UTL_IN )
 SELECT DISTINCT 'Allied.UniTrac.RequiredCoverage' , L.ID , 'INC0340631' , 'N' , 
 GETDATE() ,  1 , 
'Moved to Track Status', 
 'Y' , 'N' , 1 ,  'Allied.UniTrac.RequiredCoverage' , L.ID , 'PEND' , 'N'
FROM dbo.REQUIRED_COVERAGE L 
WHERE L.ID IN (SELECT ID FROM UniTracHDStorage..INC0340631)

