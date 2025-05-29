SELECT  L.CODE_TX AS 'Lender Code' ,
        L.NAME_TX AS 'Lender Name' ,
        Q.LENDER_ID AS 'UniTrac ID' ,
        Q.RECORD_TYPE_CD AS 'Record Source' ,
        COUNT(*) AS 'UTL No.'
INTO    #TMPLENDER
FROM    UniTrac..UTL_QUEUE Q
        JOIN dbo.LENDER L ON L.ID = Q.LENDER_ID
WHERE   Q.EVALUATION_DT = '1/1/1900'
        AND Q.LENDER_ID IN ( 2184 )
GROUP BY Q.LENDER_ID ,
        L.CODE_TX ,
        L.NAME_TX ,
        Q.RECORD_TYPE_CD 

ALTER TABLE #TMPLENDER
ALTER COLUMN [Record Source] VARCHAR(255)

UPDATE  #TMPLENDER
SET     [Record Source] = CASE #TMPLENDER.[Record Source]
                            WHEN 'E' THEN 'EDI'
                            WHEN 'I' THEN 'IDR'
                            WHEN 'U' THEN 'BSS'
                          END   
SELECT  *
FROM    #TMPLENDER

DROP TABLE #TMPLENDER     
     
