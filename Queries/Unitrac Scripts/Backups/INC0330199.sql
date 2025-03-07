USE [UniTrac]
GO 

--Loan Screen Information - LOAN/COLLATERAL/PROPERTY/OWNER/REQUIRED COVERAGE

SELECT * 
--INTO UniTracHDStorage..INC0330199
FROM LOAN L
WHERE L.LENDER_ID = 2238 AND L.STATUS_CD = 'U'
AND L.RECORD_TYPE_CD NOT IN ('A', 'D')
--30631


SELECT L.* 
INTO UniTracHDStorage..INC0330199_A
FROM LOAN L
JOIN dbo.FORCE_PLACED_CERTIFICATE FPC ON FPC.LOAN_ID = L.ID
WHERE L.LENDER_ID = 2238 AND L.STATUS_CD = 'U'
AND L.RECORD_TYPE_CD NOT IN ('A', 'D')
--58


SELECT L.* 
--INTO UniTracHDStorage..INC0330199_D
FROM dbo.LOAN L
WHERE LENDER_ID = 2238
AND L.STATUS_CD = 'U'
AND L.ID NOT IN (SELECT L.ID FROM LOAN L
JOIN dbo.FORCE_PLACED_CERTIFICATE FPC ON FPC.LOAN_ID = L.ID
WHERE L.LENDER_ID = 2238 AND L.STATUS_CD = 'U'
AND L.RECORD_TYPE_CD NOT IN ('A', 'D')) AND L.RECORD_TYPE_CD NOT IN ('A', 'D')
--33334

UPDATE L
SET L.RECORD_TYPE_CD = 'A', L.UPDATE_DT = GETDATE(), L.UPDATE_USER_TX = 'INC0330199', LOCK_ID = CASE WHEN LOCK_ID >= 255 THEN 1 ELSE LOCK_ID + 1 END
--SELECT * 
FROM dbo.LOAN L
WHERE ID IN (SELECT ID FROM  UniTracHDStorage..INC0330199_A)



declare @rowcount int = 1000
while @rowcount >= 1000
BEGIN
 BEGIN TRY
 UPDATE TOP (1000) L
SET L.RECORD_TYPE_CD = 'D', L.UPDATE_DT = GETDATE(), L.UPDATE_USER_TX = 'INC0330199', LOCK_ID = CASE WHEN LOCK_ID >= 255 THEN 1 ELSE LOCK_ID + 1 END
--SELECT * 
FROM dbo.LOAN L
WHERE ID IN (SELECT ID FROM  UniTracHDStorage..INC0330199_D) AND L.RECORD_TYPE_CD NOT IN ('A', 'D')

 select @rowcount = @@rowcount
 END TRY
 BEGIN CATCH
  select Error_number(),
      error_message(),
      error_severity(),
    error_state(),
    error_line()
   THROW
   BREAK
 END CATCH
END







INSERT INTO PROPERTY_CHANGE
 ( ENTITY_NAME_TX , ENTITY_ID , USER_TX , ATTACHMENT_IN , 
 CREATE_DT , AGENCY_ID , DESCRIPTION_TX ,  DETAILS_IN , FORMATTED_IN ,
 LOCK_ID , PARENT_NAME_TX , PARENT_ID , TRANS_STATUS_CD , UTL_IN )
 SELECT DISTINCT 'Allied.UniTrac.Loan' , L.ID , 'INC0330199' , 'N' , 
 GETDATE() ,  1 , 
'Make Loan Archived', 
 'Y' , 'N' , 1 ,  'Allied.UniTrac.Loan' , L.ID , 'PEND' , 'N'
FROM LOAN L 
WHERE L.ID IN (SELECT ID FROM UniTracHDStorage..INC0330199_A)





INSERT INTO PROPERTY_CHANGE
 ( ENTITY_NAME_TX , ENTITY_ID , USER_TX , ATTACHMENT_IN , 
 CREATE_DT , AGENCY_ID , DESCRIPTION_TX ,  DETAILS_IN , FORMATTED_IN ,
 LOCK_ID , PARENT_NAME_TX , PARENT_ID , TRANS_STATUS_CD , UTL_IN )
 SELECT DISTINCT 'Allied.UniTrac.Loan' , L.ID , 'INC0330199' , 'N' , 
 GETDATE() ,  1 , 
'Make Loan Deleted', 
 'Y' , 'N' , 1 ,  'Allied.UniTrac.Loan' , L.ID , 'PEND' , 'N'
FROM LOAN L 
WHERE L.ID IN (SELECT ID FROM UniTracHDStorage..INC0330199_D)



SELECT L.* 
INTO #tmpFPC
FROM LOAN L
JOIN dbo.FORCE_PLACED_CERTIFICATE FPC ON FPC.LOAN_ID = L.ID
WHERE L.LENDER_ID = 2238 AND L.STATUS_CD = 'U'
AND L.RECORD_TYPE_CD NOT IN ('A', 'D')
--58


SELECT L.* 
INTO #tmpNOFPC
FROM dbo.LOAN L
WHERE LENDER_ID = 2238
AND L.STATUS_CD = 'U'
AND L.ID NOT IN (SELECT L.ID FROM LOAN L
JOIN dbo.FORCE_PLACED_CERTIFICATE FPC ON FPC.LOAN_ID = L.ID
WHERE L.LENDER_ID = 2238 AND L.STATUS_CD = 'U'
AND L.RECORD_TYPE_CD NOT IN ('A', 'D')) AND L.RECORD_TYPE_CD NOT IN ('A', 'D')
--33334

UPDATE L
SET L.RECORD_TYPE_CD = 'A', L.UPDATE_DT = GETDATE(), L.UPDATE_USER_TX = 'INC0330199', LOCK_ID = CASE WHEN LOCK_ID >= 255 THEN 1 ELSE LOCK_ID + 1 END
--SELECT * 
FROM dbo.LOAN L
WHERE ID IN (SELECT ID FROM #tmpFPC)



declare @rowcount int = 1000
while @rowcount >= 1000
BEGIN
 BEGIN TRY
 UPDATE TOP (1000) L
SET L.RECORD_TYPE_CD = 'D', L.UPDATE_DT = GETDATE(), L.UPDATE_USER_TX = 'INC0330199', LOCK_ID = CASE WHEN LOCK_ID >= 255 THEN 1 ELSE LOCK_ID + 1 END
--SELECT * 
FROM dbo.LOAN L
WHERE ID IN (SELECT ID FROM #tmpNOFPC) AND L.RECORD_TYPE_CD NOT IN ('A', 'D')

 select @rowcount = @@rowcount
 END TRY
 BEGIN CATCH
  select Error_number(),
      error_message(),
      error_severity(),
    error_state(),
    error_line()
   THROW
   BREAK
 END CATCH
END







INSERT INTO PROPERTY_CHANGE
 ( ENTITY_NAME_TX , ENTITY_ID , USER_TX , ATTACHMENT_IN , 
 CREATE_DT , AGENCY_ID , DESCRIPTION_TX ,  DETAILS_IN , FORMATTED_IN ,
 LOCK_ID , PARENT_NAME_TX , PARENT_ID , TRANS_STATUS_CD , UTL_IN )
 SELECT DISTINCT 'Allied.UniTrac.Loan' , L.ID , 'INC0330199' , 'N' , 
 GETDATE() ,  1 , 
'Make Loan Archived', 
 'Y' , 'N' , 1 ,  'Allied.UniTrac.Loan' , L.ID , 'PEND' , 'N'
FROM LOAN L 
WHERE L.ID IN (SELECT ID FROM #tmpFPC)





INSERT INTO PROPERTY_CHANGE
 ( ENTITY_NAME_TX , ENTITY_ID , USER_TX , ATTACHMENT_IN , 
 CREATE_DT , AGENCY_ID , DESCRIPTION_TX ,  DETAILS_IN , FORMATTED_IN ,
 LOCK_ID , PARENT_NAME_TX , PARENT_ID , TRANS_STATUS_CD , UTL_IN )
 SELECT DISTINCT 'Allied.UniTrac.Loan' , L.ID , 'INC0330199' , 'N' , 
 GETDATE() ,  1 , 
'Make Loan Deleted', 
 'Y' , 'N' , 1 ,  'Allied.UniTrac.Loan' , L.ID , 'PEND' , 'N'
FROM LOAN L 
WHERE L.ID IN (SELECT ID FROM #tmpNOFPC)
