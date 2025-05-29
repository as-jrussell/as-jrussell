----------- The Related Data Definition for Lender Administrator ----------
SELECT  *
FROM    RELATED_DATA_DEF
WHERE   ID = 86

----------- Find the Lender Administrator By Lender Code ---------------
SELECT  LENDER.CODE_TX ,
        LENDER.NAME_TX ,
        USERS.GIVEN_NAME_TX ,
        USERS.FAMILY_NAME_TX
FROM    RELATED_DATA RD
        JOIN LENDER ON LENDER.ID = RD.RELATE_ID
        JOIN USERS ON USERS.ID = RD.VALUE_TX
WHERE   DEF_ID = 86
        AND LENDER.CODE_TX = '1894'
        
----------- Find the Lender Administrator By Lender Admin Last Name -----------
SELECT  LENDER.CODE_TX ,
        LENDER.NAME_TX ,
        USERS.GIVEN_NAME_TX ,
        USERS.FAMILY_NAME_TX
FROM    RELATED_DATA RD
        JOIN LENDER ON LENDER.ID = RD.RELATE_ID
        JOIN USERS ON USERS.ID = RD.VALUE_TX
WHERE   DEF_ID = 86
        AND FAMILY_NAME_TX = 'raddatz'
ORDER BY CODE_TX ASC

---- Straight Dump of Specific Lender Related Data Row(s) ------

SELECT * FROM UniTrac..RELATED_DATA
WHERE DEF_ID = 86
AND	RELATE_ID = 948

----- Find Duplicate Entries -------
SELECT  RD.RELATE_ID ,
        L.CODE_TX AS 'Lender Code',
        COUNT(*) AS '# of Rows'
FROM    dbo.RELATED_DATA RD
        JOIN LENDER L ON L.ID = RD.RELATE_ID
WHERE   DEF_ID = 86
GROUP BY RELATE_ID ,
        L.CODE_TX
HAVING  COUNT(*) > 1