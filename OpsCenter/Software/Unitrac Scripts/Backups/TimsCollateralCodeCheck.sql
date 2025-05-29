USE UniTrac

declare @wi as varchar(MAX)
declare @ri as int
DECLARE @TID AS int
DECLARE @TranType AS varchar(max)

set @wi = XXXXXXXX

SET @TranType ='UNITRAC'
--SET @TranType ='INFA'

SELECT
      @ri = RELATE_ID 
FROM
      dbo.WORK_ITEM WI
WHERE
      WI.id = @wi
 
SELECT
   @TID =   T.ID
FROM
      dbo.[TRANSACTION] T
      JOIN
      dbo.DOCUMENT D
            ON T.document_id = D.id
WHERE
      D.message_id = @ri  and (RELATE_TYPE_CD = @TranType OR T.RELATE_TYPE_CD ='')

 
--SELECT count(*) FROM LOAN_EXTRACT_TRANSACTION_DETAIL LETD (NOLOCK) WHERE LETD.TRANSACTION_ID = @TID 


SELECT LETD.LoanNumber_TX,
Collaterals_XML.value('(/Collaterals/Collateral/CollateralCode/@ID)[1]', 'varchar (50)') [XML Collateral Code ID],
Collaterals_XML.value('(/Collaterals/Collateral/CollateralCode)[1]', 'varchar (50)') [XML Collateral Code Name]
INTO #tmp
FROM LOAN_EXTRACT_TRANSACTION_DETAIL LETD 



SELECT 
LETD.LoanNumber_TX,
Collaterals_XML.value('(/Collaterals/Collateral/CollateralCode/@ID)[1]', 'varchar (50)') [XML Collateral Code ID],
Collaterals_XML.value('(/Collaterals/Collateral/CollateralCode)[1]', 'varchar (50)') [XML Collateral Code Name],
CD.DESCRIPTION_TX [XML Collateral Code Description],
C.COLLATERAL_CODE_ID [Database Collateral Code ID], CC.CODE_TX  [Database Collateral Code Name],
CC.DESCRIPTION_TX [Database Collateral Code Description]
FROM #tmp LETD
JOIN dbo.COLLATERAL C ON C.ID = LETD.Collaterals_XML.value('(/Collaterals/Collateral/CollateralMatchResult/MatchCollateralId)[1]', 'nvarchar (50)')
LEFT JOIN dbo.COLLATERAL_CODE CC ON CC.ID = C.COLLATERAL_CODE_ID
LEFT JOIN dbo.COLLATERAL_CODE CD ON CD.ID = LETD.Collaterals_XML.value('(/Collaterals/Collateral/CollateralCode/@ID)[1]', 'varchar (50)')
WHERE LETD.TRANSACTION_ID = @TID 


