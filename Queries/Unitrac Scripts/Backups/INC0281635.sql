USE [UniTrac]
GO 


---Finding Collateral Code
SELECT DISTINCT CC.CODE_TX [Lender Collateral Code] ,
        CC.DESCRIPTION_TX [Lender Collateral Code Description], 
		l.CODE_TX [Lender Code], l.NAME_TX [Lender Name], 
		Lo.TYPE_CD [Division], LO.CODE_TX [Lender Division Code], LO.NAME_TX [Lender Division Name]
         FROM dbo.COLLATERAL_CODE CC
INNER JOIN dbo.LCCG_COLLATERAL_CODE_RELATE CCR ON CCR.COLLATERAL_CODE_ID = CC.ID
INNER JOIN dbo.LENDER_COLLATERAL_CODE_GROUP LCCG ON LCCG.ID = CCR.LCCG_ID
INNER JOIN dbo.LENDER L ON L.ID = LCCG.LENDER_ID
INNER JOIN LENDER_ORGANIZATION LO ON L.ID = LO.LENDER_ID AND Lo.TYPE_CD = 'DIV'
WHERE (CC.CODE_TX  LIKE '%-OT' or  CC.CODE_TX  LIKE '%-A')
AND L.STATUS_CD = 'ACTIVE' AND L.TEST_IN = 'N'

