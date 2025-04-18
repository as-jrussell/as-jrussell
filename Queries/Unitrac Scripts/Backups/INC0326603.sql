--1) Main Service Center Query (SERVICE_CENTER_FUNCTION_LENDER_RELATE)
USE UniTrac
---Check to see if it's in the database
SELECT C.CODE_TX, C.NAME_TX, SCFLR.ID as SCFLR_ID,*
FROM LENDER L
INNER JOIN SERVICE_CENTER_FUNCTION_LENDER_RELATE SCFLR ON L.ID = SCFLR.LENDER_ID AND SCFLR.PURGE_DT IS NULL
INNER JOIN SERVICE_CENTER_FUNCTION SCF ON SCFLR.SERVICE_CENTER_FUNCTION_ID = SCF.ID AND SCF.PURGE_DT IS NULL
INNER JOIN SERVICE_CENTER C ON SCF.SERVICE_CENTER_ID = C.ID  AND C.PURGE_DT IS NULL
WHERE L.CODE_TX = '5353'

--SCFLR ROW
SELECT *
FROM SERVICE_CENTER_FUNCTION_LENDER_RELATE
WHERE ID IN (XXXXX)


--Available Service Centers
SELECT *
FROM SERVICE_CENTER 
WHERE CODE_TX NOT LIKE '%/%' AND PURGE_DT IS NULL


SELECT * FROM dbo.LENDER
WHERE CODE_TX = '5353'


--For new lender add to Service Center
INSERT dbo.SERVICE_CENTER_FUNCTION_LENDER_RELATE
        ( SERVICE_CENTER_FUNCTION_ID ,
          LENDER_ID ,
          CREATE_DT ,
          PURGE_DT ,
          UPDATE_DT ,
          UPDATE_USER_TX ,
          LOCK_ID
        )
VALUES  ( '54' , -- SERVICE_CENTER_FUNCTION_ID - bigint
          '2405' , -- LENDER_ID - bigint
          GETDATE() , -- CREATE_DT - datetime
          NULL , -- PURGE_DT - datetime
          GETDATE() , -- UPDATE_DT - datetime
          N'' , -- UPDATE_USER_TX - nvarchar(15)
          1  -- LOCK_ID - tinyint
        )


--Update to Service Center
UPDATE SCFLR
SET SERVICE_CENTER_FUNCTION_ID = 'XX', UPDATE_DT = GETDATE(), UPDATE_USER_TX = 'INC0XXXXXX'
--SELECT  C.CODE_TX, C.NAME_TX,SCFLR.* 
FROM LENDER L
INNER JOIN SERVICE_CENTER_FUNCTION_LENDER_RELATE SCFLR ON L.ID = SCFLR.LENDER_ID AND SCFLR.PURGE_DT IS NULL
INNER JOIN SERVICE_CENTER_FUNCTION SCF ON SCFLR.SERVICE_CENTER_FUNCTION_ID = SCF.ID AND SCF.PURGE_DT IS NULL
INNER JOIN SERVICE_CENTER C ON SCF.SERVICE_CENTER_ID = C.ID  AND C.PURGE_DT IS NULL
WHERE SCFLR.ID = 'XXXX'



--2) Service Center Setup by Division
SELECT RD.VALUE_TX,LO.NAME_TX,RD.ID as RD_ID,*
FROM LENDER L
INNER JOIN LENDER_ORGANIZATION LO ON L.ID = LO.LENDER_ID
INNER JOIN RELATED_DATA RD ON LO.ID = RD.RELATE_ID AND RD.DEF_ID = '105'
WHERE L.CODE_TX = 'XXXX'

--RELATED_DATA ROW(S)
SELECT *
FROM RELATED_DATA
WHERE ID IN (XXXXXXXX)

---Finding Branch
SELECT DISTINCT lo.id, LO.NAME_TX
FROM LENDER L
INNER JOIN LENDER_ORGANIZATION LO ON L.ID = LO.LENDER_ID
INNER JOIN RELATED_DATA RD ON LO.ID = RD.RELATE_ID 
WHERE Lo.TYPE_CD = 'DIV' AND L.CODE_TX = 'XXX' 

--Available Service Centers
SELECT *
FROM SERVICE_CENTER 
WHERE CODE_TX NOT LIKE '%/%'  AND PURGE_DT IS NULL

----Inserting a new Lender row
USE UniTrac
INSERT dbo.RELATED_DATA
        ( DEF_ID ,
          RELATE_ID ,
          VALUE_TX ,
          START_DT ,
          END_DT ,
          COMMENT_TX ,
          CREATE_DT ,
          UPDATE_DT ,
          UPDATE_USER_TX ,
          LOCK_ID
        )
VALUES  ( 105 , -- DEF_ID - bigint
           XXXXX, -- RELATE_ID - bigint
          N'XXXXX' , -- VALUE_TX - nvarchar(4000)
          GETDATE() , -- START_DT - datetime
          GETDATE() , -- END_DT - datetime
          N'AssociatedServiceCenter' , -- COMMENT_TX - nvarchar(4000)
          GETDATE() , -- CREATE_DT - datetime
          GETDATE() , -- UPDATE_DT - datetime
          N'INC0XXXXXX' , -- UPDATE_USER_TX - nvarchar(15)
          1  -- LOCK_ID - numeric
        )

--Available Service Centers
SELECT *
FROM SERVICE_CENTER 
WHERE CODE_TX NOT LIKE '%/%'  AND PURGE_DT IS NULL

--Update existing 
UPDATE RELATED_DATA
SET VALUE_TX = 'XXXXXXX', UPDATE_DT = GETDATE(), UPDATE_USER_TX = 'INC0XXXXX'
WHERE ID IN (XXXXXXXXX)





