USE UniTrac

SELECT * FROM dbo.LENDER
WHERE CODE_TX = '2982'

SELECT CONVERT(DATE,CREATE_DT) , COUNT(*) FROM dbo.LOAN
WHERE lender_id = 2257
GROUP BY CONVERT(DATE, CREATE_DT) 
ORDER BY CONVERT(DATE,CREATE_DT) DESC 



SELECT YEAR(L.CREATE_DT) [Year], MONTH(L.CREATE_DT) [Month], COUNT(*)[Loan Count] 
FROM dbo.LOAN L
JOIN dbo.COLLATERAL C ON C.LOAN_ID = L.ID
WHERE L.LENDER_ID = 2257
GROUP BY  YEAR(L.CREATE_DT), MONTH(L.CREATE_DT)
ORDER BY  YEAR(L.CREATE_DT) ASC , MONTH(L.CREATE_DT) ASC 

SELECT YEAR(C.CREATE_DT) [Year], MONTH(C.CREATE_DT) [Month], COUNT(*)[Coll Count] 
FROM dbo.LOAN L
JOIN dbo.COLLATERAL C ON C.LOAN_ID = L.ID
WHERE L.LENDER_ID = 2257
GROUP BY  YEAR(C.CREATE_DT), MONTH(C.CREATE_DT)
ORDER BY  YEAR(C.CREATE_DT) ASC , MONTH(C.CREATE_DT) ASC 

