---- Check VUT..tblCenter Assignment First
SELECT  L.CODE_TX AS 'Lender Code',
		L.NAME_TX AS 'Lender Name',
		L.STATUS_CD AS 'Lender Status',
        Q.CenterID AS 'Service Center ID',
        Q.CenterName AS 'Service Center Name'
FROM    VUT.dbo.tblLender P
        INNER JOIN dbo.tblCenter Q ON P.CenterKey = Q.CenterKey
        JOIN UniTrac.dbo.LENDER L ON P.LenderID = L.CODE_TX        
WHERE   L.TEST_IN = 'N'
        AND L.STATUS_CD NOT IN ( 'CANCEL', 'SUSPEND', 'MERGED' )
        ORDER BY Q.CenterID ASC, L.CODE_TX ASC

		SELECT * FROM dbo.tblCenter



		SELECT * FROM UNitrac..SERVICE_CENTER