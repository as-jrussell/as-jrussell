USE [UniTrac]
GO 

--Loan Screen Information - LOAN/COLLATERAL/PROPERTY/OWNER/REQUIRED COVERAGE
SELECT L.NUMBER_TX, concat(O.First_NAME_TX,' ',O.LAST_NAME_TX ) as  [Owner]    , OA.* 
--into UnitracHDStorage..INC0366380
FROM LOAN L
INNER JOIN OWNER_LOAN_RELATE OL ON L.ID = OL.LOAN_ID
INNER JOIN OWNER O ON OL.OWNER_ID = O.ID
INNER JOIN OWNER_ADDRESS OA ON O.ADDRESS_ID = OA.ID
INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
WHERE LL.CODE_TX ='1695' and LINE_2_TX = ''


SELECT   *  
FROM OWNER_ADDRESS OA
JOIN UnitracHDStorage..INC0366380 L on OA.ID= L.ID


declare @rowcount int = 15000
while @rowcount >= 15000
BEGIN
 BEGIN TRY

 UPDATE OA
SET LINE_2_TX = NULL
--SELECT   count(*)  
FROM OWNER_ADDRESS OA
JOIN UnitracHDStorage..INC0366380 L on OA.ID= L.ID
--112248

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
				 
