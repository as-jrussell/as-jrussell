
declare @wi as varchar(MAX)
declare @ri as int
DECLARE @TID AS int
DECLARE @TranType AS varchar(max)

set @wi = 34527955

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


SELECT Collaterals_XML.value('(/Collaterals/Collateral/RealEstateProperty/CollateralAddress/Line1) [1]', 'nvarchar(500)') [RealEstate Collateral Address],
Collaterals_XML.value('(/Collaterals/Collateral/CollateralMatchResult/AddressLine1) [1]', 'nvarchar(500)') [CollateralMatchResult Collateral Address], 
Collaterals_XML.value('(/Collaterals/Collateral/Equipment/EquipmentDescription) [1]', 'nvarchar(500)') [Equipment Collateral Address], 
 LoanNumber_TX INTO #tmp
  FROM LOAN_EXTRACT_TRANSACTION_DETAIL LETD (NOLOCK) WHERE LETD.TRANSACTION_ID = @TID 



  SELECT * FROM #tmp



  
--Loan Screen Information - LOAN/COLLATERAL/PROPERTY/OWNER/REQUIRED COVERAGE
SELECT P.ADDRESS_ID, L.NUMBER_TX
INTO #tmpA
FROM LOAN L
INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
INNER JOIN REQUIRED_COVERAGE RC ON P.ID = RC.PROPERTY_ID
INNER JOIN OWNER_LOAN_RELATE OL ON L.ID = OL.LOAN_ID
INNER JOIN OWNER O ON OL.OWNER_ID = O.ID
INNER JOIN OWNER_ADDRESS OA ON O.ADDRESS_ID = OA.ID
INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
WHERE LL.CODE_TX IN ('4422') AND L.NUMBER_TX IN ( SELECT LoanNumber_TX FROM #tmp)

SELECT T.NUMBER_TX, OA.LINE_1_TX
INTO #tmpB
FROM #tmpA T
LEFT JOIN dbo.OWNER_ADDRESS OA ON OA.ID = T.ADDRESS_ID




SELECT DISTINCT [RealEstate Collateral Address] ,
        [CollateralMatchResult Collateral Address] ,
        [Equipment Collateral Address] ,
        LoanNumber_TX ,
        LINE_1_TX FROM #tmp T
LEFT JOIN #tmpB TT ON T.LoanNumber_TX = TT.NUMBER_TX AND T.[CollateralMatchResult Collateral Address] <> TT.LINE_1_TX
WHERE TT.NUMBER_TX IS NOT NULL


