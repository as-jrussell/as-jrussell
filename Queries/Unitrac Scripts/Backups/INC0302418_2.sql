USE unitrac

SELECT * FROM dbo.LOAN
WHERE NUMBER_TX = '450247787-30'


EXEC dbo.Support_BackoffNotice @noticeId = 23157807 -- bigint


SELECT * FROM dbo.NOTICE
WHERE LOAN_ID = 201503231

SELECT * FROM dbo.COLLATERAL
WHERE LOAN_ID = 201503231

UPDATE IH SET PURGE_DT = GETDATE()
--SELECT * 
FROM dbo.INTERACTION_HISTORY IH
WHERE PROPERTY_ID = 174019849
AND ID IN (320109391,
320109392)


UPDATE C SET PURGE_DT = NULL
--SELECT * 
FROM dbo.CPI_QUOTE C
WHERE id IN (38786602)




SELECT * 
FROM CPI_ACTIVITY A
JOIN UniTracHDStorage..INC0302418_A AA ON AA.ID = A.ID
WHERE A.UPDATE_USER_TX = 'INC0302418'


SELECT * FROM dbo.CPI_QUOTE
WHERE ID IN (SELECT * FROM #tmp)


SELECT * from UniTracHDStorage..INC0302418_Q

WHERE ID IN (SELECT * FROM #tmp)




SELECT   R.NOTICE_DT  , R.NOTICE_SEQ_NO ,    R.NOTICE_TYPE_CD  , R.UPDATE_DT,      
 R.UPDATE_USER_TX , *  FROM UniTracHDStorage..INC0302418_RC R


