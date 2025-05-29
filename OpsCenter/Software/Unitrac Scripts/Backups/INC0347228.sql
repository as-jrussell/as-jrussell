use unitrac





SELECT exposure_dt, RC.* 
--INTO UnitracHDStorage..INC0347228_RC
FROM LOAN L
INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
INNER JOIN REQUIRED_COVERAGE RC ON P.ID = RC.PROPERTY_ID
INNER JOIN OWNER_LOAN_RELATE OL ON L.ID = OL.LOAN_ID
INNER JOIN OWNER O ON OL.OWNER_ID = O.ID
INNER JOIN OWNER_ADDRESS OA ON O.ADDRESS_ID = OA.ID
INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
WHERE LL.CODE_TX IN ('2845') and exposure_dt <> '9999-12-31 23:59:59.9999999'



declare @rowcount int = 10000
while @rowcount >= 10000
BEGIN
 BEGIN TRY


 UPDATE TOP (10000) rc 
SET rc.NOTICE_DT =NULL, rc.NOTICE_SEQ_NO = '0', exposure_dt = '2018-01-09 23:59:59.9999999'
--SELECT count(*)
FROM dbo.REQUIRED_COVERAGE rc
WHERE ID IN (SELECT id FROM UniTracHDStorage..INC0347228_RC)
and exposure_dt <> '9999-12-31 23:59:59.9999999'


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
		
     
	 select * from UnitracHDStorage..INC0347228_RC