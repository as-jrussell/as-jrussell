	USE UniTrac
			
declare @wi as varchar(MAX)
declare @ri as int
DECLARE @TID AS int
DECLARE @TranType AS varchar(max)



set @wi = 42217202


SET @TranType ='UNITRAC'
--SET @TranType ='INFA'


SELECT
@ri = RELATE_ID 
FROM
dbo.WORK_ITEM WI
WHERE
WI.id = @wi
SELECT
@TID = T.ID
FROM
dbo.[TRANSACTION] T
JOIN
dbo.DOCUMENT D
ON T.document_id = D.id
WHERE
D.message_id = @ri and (RELATE_TYPE_CD = @TranType OR T.RELATE_TYPE_CD ='')



SELECT LETD.LM_MatchLoanId_TX INTO #tmpLoanID FROM LOAN_EXTRACT_TRANSACTION_DETAIL LETD (NOLOCK) WHERE LETD.TRANSACTION_ID = @TID 
AND LETD.LM_MatchStatus_TX = 'Unmatch'


SELECT * FROM dbo.LOAN
WHERE ID IN (SELECT * FROM #tmpLoanID)

SELECT * FROM dbo.REF_CODE
WHERE DOMAIN_CD = 'LoanStatus'
AND CODE_CD = 'P'