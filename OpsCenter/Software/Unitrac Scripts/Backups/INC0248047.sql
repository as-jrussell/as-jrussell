USE [UniTrac]
GO 

--Loan Screen Information - LOAN/COLLATERAL/PROPERTY/OWNER/REQUIRED COVERAGE
SELECT IH.*
INTO UniTracHDStorage..INC0248047_IH
 FROM LOAN L
INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
INNER JOIN REQUIRED_COVERAGE RC ON P.ID = RC.PROPERTY_ID
INNER JOIN OWNER_LOAN_RELATE OL ON L.ID = OL.LOAN_ID
INNER JOIN OWNER O ON OL.OWNER_ID = O.ID
INNER JOIN OWNER_ADDRESS OA ON O.ADDRESS_ID = OA.ID
INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
INNER JOIN dbo.PROPERTY_OWNER_POLICY_RELATE POP ON POP.PROPERTY_ID = P.ID
INNER JOIN dbo.OWNER_POLICY OP ON OP.ID = POP.OWNER_POLICY_ID
INNER JOIN dbo.POLICY_COVERAGE PC ON PC.OWNER_POLICY_ID = OP.ID
INNER JOIN dbo.INTERACTION_HISTORY IH ON IH.PROPERTY_ID = P.ID
WHERE LL.CODE_TX IN ('2202') AND L.NUMBER_TX = '2274670L4'

SELECT * FROM UniTracHDStorage..INC0248047_IH

UPDATE dbo.OWNER_POLICY
SET PURGE_DT = GETDATE(), LOCK_ID = LOCK_ID+1, 
UPDATE_USER_TX = 'INC0248047'
--SELECT * FROM dbo.OWNER_POLICY
WHERE ID IN (SELECT ID FROM UniTracHDStorage..INC0248047_OP)


UPDATE dbo.POLICY_COVERAGE
SET PURGE_DT = GETDATE(), LOCK_ID = LOCK_ID+1, 
UPDATE_USER_TX = 'INC0248047'
--SELECT * FROM POLICY_COVERAGE
WHERE ID IN (SELECT ID FROM UniTracHDStorage..INC0248047_PC)



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
                'Allied.UniTrac.OwnerPolicy' ,
                ID ,
                'INC0248047' ,
                'N' ,
                GETDATE() ,
                1 ,
                'Remove incorrect insurance' ,
                'N' ,
                'Y' ,
                1 ,
                'Allied.UniTrac.OwnerPolicy' ,
                ID ,
                'PEND' ,
                'N'
        FROM    dbo.OWNER_POLICY
        WHERE   ID IN ( SELECT  ID
                        FROM    UniTracHDStorage..INC0248047_OP )



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
                'Allied.UniTrac.PolicyCoverage' ,
                ID ,
                'INC0248047' ,
                'N' ,
                GETDATE() ,
                1 ,
                'Remove incorrect insurance' ,
                'N' ,
                'Y' ,
                1 ,
                 'Allied.UniTrac.PolicyCoverage' ,
                ID ,
                'PEND' ,
                'N'
        FROM    dbo.POLICY_COVERAGE
        WHERE   ID IN ( SELECT  ID
                        FROM    UniTracHDStorage..INC0248047_PC)


UPDATE dbo.INTERACTION_HISTORY
SET PURGE_DT = GETDATE(), LOCK_ID = LOCK_ID+1, 
UPDATE_USER_TX = 'INC0248047'
--SELECT * FROM dbo.INTERACTION_HISTORY
WHERE ID IN ( SELECT  ID
                        FROM    UniTracHDStorage..INC0248047_IH WHERE TYPE_CD = 'OWNERPOLICY')