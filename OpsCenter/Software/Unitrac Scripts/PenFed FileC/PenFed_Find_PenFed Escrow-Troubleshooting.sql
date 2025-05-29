
declare @wi as varchar(MAX)
declare @ri as int
DECLARE @LoanNumber AS varchar(MAX)
DECLARE @TID AS int
DECLARE @execquery AS NVARCHAR(MAX)
DECLARE @tablename AS NVARCHAR(128)
DECLARE @TranType AS varchar(max)



set @wi = 43668238 
SET @LoanNumber = '1612187062'

SET @TranType ='UNITRAC'
--SET @TranType ='INFA'



SET @tablename = 'vut.dbo.tblextract_' + @wi

SET @execquery = N'SELECT * FROM ' + @tablename + ' WHERE ContractNumber = ' + ' ''' + @LoanNumber + ''' '

--SELECT @execquery

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
      D.message_id = @ri  and (RELATE_TYPE_CD = @TranType OR T.RELATE_TYPE_CD ='') AND T.PURGE_DT is null

	  --SELECT top 100 validkey, va * FROM vut.dbo.tblextract_42380411
 
SELECT 'InBound Message', m.*
FROM MESSAGE m
JOIN WORK_ITEM wi ON wi.RELATE_ID = m.id
WHERE wi.id = @wi
	  
SELECT 'OutBound Message', m.*
FROM MESSAGE m
JOIN WORK_ITEM wi ON wi.RELATE_ID = m.RELATE_ID_TX
WHERE wi.id = @wi
 
SELECT top 10  LETD.LM_MatchStatus_TX, LETD.LM_MatchLoanId_TX, * 
FROM LOAN_EXTRACT_TRANSACTION_DETAIL LETD (NOLOCK) 
WHERE LETD.TRANSACTION_ID = @TID 

--AND LETD.LM_MatchStatus_TX = 'new'
AND LETD.LoanNumber_TX = @LoanNumber


SELECT 'CETD', cetd.CM_MatchStatus_TX, cetd.CM_MatchCollateralId_TX, cetd.CM_MatchPropertyId_TX, cetd.* 
FROM COLLATERAL_EXTRACT_TRANSACTION_DETAIL cetd  (NOLOCK)
JOIN LOAN_EXTRACT_TRANSACTION_DETAIL LETD ON LETD.SEQUENCE_ID = cetd.SEQUENCE_ID and LETD.TRANSACTION_ID = @TID AND cetd.TRANSACTION_ID = @TID 
AND LETD.LoanNumber_TX = @LoanNumber


SELECT TOP 15 'OETD', oetd.* 
FROM OWNER_EXTRACT_TRANSACTION_DETAIL oetd  (NOLOCK)
JOIN LOAN_EXTRACT_TRANSACTION_DETAIL LETD ON LETD.SEQUENCE_ID = oetd.SEQUENCE_ID and LETD.TRANSACTION_ID = @TID AND oetd.TRANSACTION_ID = @TID AND LETD.LoanNumber_TX = @LoanNumber


SELECT  'PROCESS_LOG_ITEM', 
	pli.info_xml.value('(/INFO_LOG/RELATE_INFO)[1]', 'nvarchar(50)') LoanNumber,
	PLI.*
FROM
	WORK_ITEM WI (NOLOCK)
	CROSS APPLY
	WI.CONTENT_XML.nodes('/Content/Information/ProcessLogs/ProcessLog') AS P (TAB)
	JOIN
	PROCESS_LOG_ITEM PLI (NOLOCK)
		ON P.TAB.value('@Id', 'BIGINT') = PLI.PROCESS_LOG_ID
	CROSS APPLY
	PLI.INFO_XML.nodes('/INFO_LOG/RELATE_INFO') AS PLI_INFO (TAB)
WHERE
	WI.ID = @wi
	AND (PLI.RELATE_TYPE_CD = 'Allied.UniTrac.Loan' or  PLI.RELATE_TYPE_CD = 'Allied.UniTrac.Collateral')
	AND PLI_INFO.TAB.value('.', 'varchar(30)') = @LoanNumber
	and PLI.Purge_dt is not null



--select * from message where id in (11525176, 11525177)

--select * from message where (id = 11525176 or Relate_id_tx = '11525176')


----select * from document where message_id in (11525176, 11525177)
--select * from document where message_Id = 11525177

--select * from [transaction] where document_id in ( select Id from document where message_id in (11525176, 11525177))


