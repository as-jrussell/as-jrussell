USE [UniTrac]
GO 

--drop table unitrachdstorage..INC0365666
SELECT L.* 
into unitrachdstorage..INC0365666
FROM LOAN L
INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
WHERE LL.CODE_TX = '1931' and division_code_tx <> '99'


declare @rowcount int = 10000
while @rowcount >= 10000
BEGIN
 BEGIN TRY

 UPDATE TOP (10000) L
SET division_code_tx = '99'
--SELECT division_code_tx,  *
FROM LOAN L
WHERE l.id in (select id from unitrachdstorage..INC0365666)
--119900

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
		



declare @rowcount int = 10000
while @rowcount >= 10000
BEGIN
 BEGIN TRY
			
	
INSERT INTO PROPERTY_CHANGE
 ( ENTITY_NAME_TX , ENTITY_ID , USER_TX , ATTACHMENT_IN , 
 CREATE_DT , AGENCY_ID , DESCRIPTION_TX ,  DETAILS_IN , FORMATTED_IN ,
 LOCK_ID , PARENT_NAME_TX , PARENT_ID , TRANS_STATUS_CD , UTL_IN )
 SELECT DISTINCT 'Allied.UniTrac.Loan' , L.ID , 'INC0365666' , 'N' , 
 GETDATE() ,  1 , 
'Moved to Division 99', 
 'Y' , 'N' , 1 ,  'Allied.UniTrac.Loan' , L.ID , 'PEND' , 'N'
FROM LOAN L 
WHERE L.ID IN (SELECT ID FROM UniTracHDStorage..INC0365666)


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
		