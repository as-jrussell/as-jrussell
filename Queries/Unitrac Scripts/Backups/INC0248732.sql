USE [UniTrac]
GO 

--Loan Screen Information - LOAN/COLLATERAL/PROPERTY/OWNER/REQUIRED COVERAGE
SELECT L.*
--INTO Jcs..INC0248732_Loan
 FROM LOAN L
INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
INNER JOIN REQUIRED_COVERAGE RC ON P.ID = RC.PROPERTY_ID
INNER JOIN OWNER_LOAN_RELATE OL ON L.ID = OL.LOAN_ID
INNER JOIN OWNER O ON OL.OWNER_ID = O.ID
INNER JOIN OWNER_ADDRESS OA ON O.ADDRESS_ID = OA.ID
INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
WHERE LL.CODE_TX IN ('2221') AND L.NUMBER_TX IN (  '268443-42')
AND L.RECORD_TYPE_CD = 'D'


SELECT C.ID, L.ID, L.NUMBER_TX,C.*
--INTO Jcs..INC0248732_Collateral
 FROM LOAN L
INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
INNER JOIN REQUIRED_COVERAGE RC ON P.ID = RC.PROPERTY_ID
INNER JOIN OWNER_LOAN_RELATE OL ON L.ID = OL.LOAN_ID
INNER JOIN OWNER O ON OL.OWNER_ID = O.ID
INNER JOIN OWNER_ADDRESS OA ON O.ADDRESS_ID = OA.ID
INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
WHERE LL.CODE_TX IN ('2221') AND L.ID IN (169964624,
169964817)


SELECT RC.*
--INTO Jcs..INC0248732_RequiredCoverage
 FROM LOAN L
INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
INNER JOIN REQUIRED_COVERAGE RC ON P.ID = RC.PROPERTY_ID
INNER JOIN OWNER_LOAN_RELATE OL ON L.ID = OL.LOAN_ID
INNER JOIN OWNER O ON OL.OWNER_ID = O.ID
INNER JOIN OWNER_ADDRESS OA ON O.ADDRESS_ID = OA.ID
INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
WHERE LL.CODE_TX IN ('2221') AND  L.ID IN  (169964624,
169964817)


SELECT P.*
--INTO Jcs..INC0248732_Property
 FROM LOAN L
INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
INNER JOIN REQUIRED_COVERAGE RC ON P.ID = RC.PROPERTY_ID
INNER JOIN OWNER_LOAN_RELATE OL ON L.ID = OL.LOAN_ID
INNER JOIN OWNER O ON OL.OWNER_ID = O.ID
INNER JOIN OWNER_ADDRESS OA ON O.ADDRESS_ID = OA.ID
INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
WHERE LL.CODE_TX IN ('2221')  AND L.ID IN (169964624,
169964817)




UPDATE dbo.LOAN
SET RECORD_TYPE_CD = 'D', PURGE_DT = GETDATE(), UPDATE_DT = GETDATE(), LOCK_ID=LOCK_ID+1, UPDATE_USER_TX = 'INC0248732'
WHERE ID IN (169964624,169964658,169964798)


UPDATE dbo.COLLATERAL
SET  PURGE_DT = GETDATE(), UPDATE_DT = GETDATE(), LOCK_ID=LOCK_ID+1, UPDATE_USER_TX = 'INC0248732'
WHERE ID IN (144148875,144148909,144149051)

UPDATE dbo.REQUIRED_COVERAGE
SET RECORD_TYPE_CD = 'D', PURGE_DT = GETDATE(), UPDATE_DT = GETDATE(), LOCK_ID=LOCK_ID+1, UPDATE_USER_TX = 'INC0248732'
WHERE ID IN (24201822,
144222971,
144223196)

UPDATE dbo.PROPERTY
SET RECORD_TYPE_CD = 'D', PURGE_DT = GETDATE(), UPDATE_DT = GETDATE(), LOCK_ID=LOCK_ID+1, UPDATE_USER_TX = 'INC0248732'
WHERE ID IN (24925164,142675922,142676051)


INSERT  INTO PROPERTY_CHANGE
        ( ENTITY_NAME_TX ,
          ENTITY_ID ,
          USER_TX ,
          ATTACHMENT_IN ,
          CREATE_DT ,
          AGENCY_ID ,
          DESCRIPTION_TX ,
          DETAILS_IN ,
          FORMATTED_IN ,
          LOCK_ID ,
          PARENT_NAME_TX ,
          PARENT_ID ,
          TRANS_STATUS_CD ,
          UTL_IN
        )
        SELECT DISTINCT
                'Allied.UniTrac.Collateral' ,
                ID ,
                'INC0248732' ,
                'N' ,
                GETDATE() ,
                1 ,
                'Removed Duplicate' ,
                'N' ,
                'Y' ,
                1 ,
                'Allied.UniTrac.Collateral' ,
                ID ,
                'PEND' ,
                'N'
        FROM    dbo.COLLATERAL
        WHERE   ID IN ( 144148875,144148909,144149051 )




INSERT  INTO PROPERTY_CHANGE
        ( ENTITY_NAME_TX ,
          ENTITY_ID ,
          USER_TX ,
          ATTACHMENT_IN ,
          CREATE_DT ,
          AGENCY_ID ,
          DESCRIPTION_TX ,
          DETAILS_IN ,
          FORMATTED_IN ,
          LOCK_ID ,
          PARENT_NAME_TX ,
          PARENT_ID ,
          TRANS_STATUS_CD ,
          UTL_IN
        )
        SELECT DISTINCT
                'Allied.UniTrac.Loan' ,
                ID ,
               'INC0248732' ,
                'N' ,
                GETDATE() ,
                1 ,
                'Removed Duplicate' ,
                'N' ,
                'Y' ,
                1 ,
                'Allied.UniTrac.Loan' ,
                ID ,
                'PEND' ,
                'N'
        FROM    dbo.LOAN 
        WHERE   ID IN (169964624,169964658,169964798)



INSERT  INTO PROPERTY_CHANGE
        ( ENTITY_NAME_TX ,
          ENTITY_ID ,
          USER_TX ,
          ATTACHMENT_IN ,
          CREATE_DT ,
          AGENCY_ID ,
          DESCRIPTION_TX ,
          DETAILS_IN ,
          FORMATTED_IN ,
          LOCK_ID ,
          PARENT_NAME_TX ,
          PARENT_ID ,
          TRANS_STATUS_CD ,
          UTL_IN
        )
        SELECT DISTINCT
                'Allied.UniTrac.RequiredCoverage' ,
                ID ,
               'INC0248732' ,
                'N' ,
                GETDATE() ,
                1 ,
                'Removed Duplicate' ,
                'N' ,
                'Y' ,
                1 ,
                'Allied.UniTrac.RequiredCoverage' ,
                ID ,
                'PEND' ,
                'N'
        FROM    dbo.REQUIRED_COVERAGE 
        WHERE   ID IN (24201822,144222971,144223196)




INSERT  INTO PROPERTY_CHANGE
        ( ENTITY_NAME_TX ,
          ENTITY_ID ,
          USER_TX ,
          ATTACHMENT_IN ,
          CREATE_DT ,
          AGENCY_ID ,
          DESCRIPTION_TX ,
          DETAILS_IN ,
          FORMATTED_IN ,
          LOCK_ID ,
          PARENT_NAME_TX ,
          PARENT_ID ,
          TRANS_STATUS_CD ,
          UTL_IN
        )
        SELECT DISTINCT
                'Allied.UniTrac.Property' ,
                ID ,
               'INC0248732' ,
                'N' ,
                GETDATE() ,
                1 ,
                'Removed Duplicate',
                'N' ,
                'Y' ,
                1 ,
                'Allied.UniTrac.Property' ,
                ID ,
                'PEND' ,
                'N'
        FROM   dbo.PROPERTY
        WHERE   ID IN (24925164,142675922,142676051)







SELECT  P.RECORD_TYPE_CD, C.PRIMARY_LOAN_IN,  .*
--INTO Jcs..INC0248732_RequiredCoverage
 FROM LOAN L
INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
INNER JOIN REQUIRED_COVERAGE RC ON P.ID = RC.PROPERTY_ID
INNER JOIN OWNER_LOAN_RELATE OL ON L.ID = OL.LOAN_ID
INNER JOIN OWNER O ON OL.OWNER_ID = O.ID
INNER JOIN OWNER_ADDRESS OA ON O.ADDRESS_ID = OA.ID
INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
WHERE LL.CODE_TX IN ('2221') AND L.NUMBER_TX = '268443-42'




UPDATE dbo.COLLATERAL
SET  PURGE_DT = NULl, UPDATE_DT = GETDATE(), LOCK_ID=LOCK_ID+1, UPDATE_USER_TX = 'INC0248732'
WHERE ID IN (144148875,144149070)

UPDATE dbo.REQUIRED_COVERAGE
SET RECORD_TYPE_CD = 'G', PURGE_DT = NULL, UPDATE_DT = GETDATE(), LOCK_ID=LOCK_ID+1, UPDATE_USER_TX = 'INC0248732'
WHERE ID IN (24201822)

UPDATE dbo.PROPERTY
SET RECORD_TYPE_CD = 'G', PURGE_DT = NULL, UPDATE_DT = GETDATE(), LOCK_ID=LOCK_ID+1, UPDATE_USER_TX = 'INC0248732'
WHERE ID IN (24925164)


UPDATE dbo.LOAN
SET RECORD_TYPE_CD = 'G', PURGE_DT = NULL, UPDATE_DT = GETDATE(), LOCK_ID=LOCK_ID+1, UPDATE_USER_TX = 'INC0248732'
WHERE ID IN (169964624,
169964817)



SELECT DISTINCT RC.ID, RC.TYPE_CD FROM UniTracHDStorage..INC0248732_Loan L
INNER JOIN UniTracHDStorage..INC0248732_Collateral C ON C.LOAN_ID = L.ID
INNER JOIN UniTracHDStorage..INC0248732_Property P ON P.ID = C.PROPERTY_ID
INNER JOIN UniTracHDStorage..INC0248732_RequiredCoverage RC ON RC.PROPERTY_ID = P.ID
INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
WHERE LL.CODE_TX IN ('2221') AND L.NUMBER_TX = '268443-42'

 SELECT C.*
 FROM LOAN L
INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
INNER JOIN REQUIRED_COVERAGE RC ON P.ID = RC.PROPERTY_ID
INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
WHERE LL.CODE_TX IN ('2221') AND L.NUMBER_TX = '268443-42'

 SELECT C.*
 FROM LOAN L
INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
INNER JOIN REQUIRED_COVERAGE RC ON P.ID = RC.PROPERTY_ID
INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
WHERE LL.CODE_TX IN ('2221') AND L.NUMBER_TX = '268443-65'


SELECT * FROM dbo.PROPERTY
WHERE ID = '24925164'


SELECT * FROM dbo.COLLATERAL
WHERE PROPERTY_ID = '24925164'

EXEC dbo.SaveSearchFullText @propertyId = 24925164 -- bigint
