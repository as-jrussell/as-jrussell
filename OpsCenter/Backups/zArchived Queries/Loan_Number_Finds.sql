SELECT  L.ID AS 'LoanID' ,
        L.LENDER_ID AS 'Lender ID' ,
        LL.CODE_TX AS 'Lender Code' ,
        L.NUMBER_TX AS 'Loan Number' ,
        L.STATUS_CD AS 'Loan Status Code' ,
        L.BALANCE_AMOUNT_NO AS 'Loan Balance' ,
        L.UPDATE_DT AS 'Loan Update Date'
FROM    UniTrac..LOAN L
        JOIN UniTrac..LENDER LL ON LL.ID = L.LENDER_ID
WHERE   L.ID IN ( 95578640, 113317696, 82361343, 83969007, 109649268, 95578605,
                  95578618, 82361652 )