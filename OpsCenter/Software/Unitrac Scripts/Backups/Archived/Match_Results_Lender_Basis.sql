USE UniTrac

---------------- UTL Queue and UTL Match Results by Lender
SELECT  LD.CODE_TX AS 'Lender Code',
		Q.LENDER_ID AS 'Lender ID',
		LN.NUMBER_TX AS 'Loan Number',
        Q.LOAN_ID AS 'UTL Queue Loan ID',
        R.UTL_LOAN_ID 'UTL Result Loan ID',
        R.LOAN_ID ,
        R.SCORE_NO AS 'Score' ,
        R.CREATE_DT AS 'Create Date',
        R.UPDATE_DT,
        R.MATCH_RESULT_CD AS 'Match Result'
FROM    UniTrac..UTL_QUEUE Q
        JOIN dbo.UTL_MATCH_RESULT R ON R.UTL_LOAN_ID = Q.LOAN_ID
        JOIN dbo.LENDER LD ON LD.ID = Q.LENDER_ID
        JOIN dbo.LOAN LN ON LN.ID = Q.LOAN_ID
WHERE   ld.CODE_TX = '7530'
AND CAST(q.CREATE_DT AS DATE) >= CAST(GETDATE()-1 AS DATE)
