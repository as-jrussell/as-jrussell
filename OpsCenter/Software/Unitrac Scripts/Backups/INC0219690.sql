
--Loan Screen Information - LOAN/COLLATERAL/PROPERTY/OWNER/REQUIRED COVERAGE
SELECT  L.ID[Loans_ID], L.NUMBER_TX [Loan Number], L.CREATE_DT [Loan Create Date],L.EFFECTIVE_DT [Loan Effective Date], IH.*
INTO #tmp
FROM LOAN L
INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
INNER JOIN REQUIRED_COVERAGE RC ON P.ID = RC.PROPERTY_ID
INNER JOIN OWNER_LOAN_RELATE OL ON L.ID = OL.LOAN_ID
INNER JOIN OWNER O ON OL.OWNER_ID = O.ID
INNER JOIN OWNER_ADDRESS OA ON O.ADDRESS_ID = OA.ID
INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
INNER JOIN dbo.INTERACTION_HISTORY IH ON IH.PROPERTY_ID = P.ID
WHERE LL.CODE_TX IN ('1595') --AND L.NUMBER_TX < '2015-09-25'


SELECT L.[Loan Number], L.EFFECTIVE_DT, L. FROM #tmp L
WHERE L.[Loan Create Date] < '2015-09-25' 

SELECT *
INTO #tmpE
FROM #tmp RC
WHERE RC.[Loan Create Date] < '2015-09-25' AND RC.[Loan Create Date] > '2015-03-25'
--96513



SELECT *
INTO #tmpF
FROM #tmp RC
WHERE RC.[Loan Create Date] > '2015-09-25' 
--25052

--DROP TABLE #tmp
--DROP TABLE #tmpE
--DROP TABLE #tmpF



SELECT  [Loan Number] ,
        [Loan Create Date] ,
		[Loan Effective Date],
        TYPE_CD ,
        ISSUE_DT ,
		IH.SPECIAL_HANDLING_XML.value('(SH/MailDate) [1]', 'varchar (50)') [Mail Date]	
		--INTO #tmpEE
        FROM #tmpE IH
WHERE IH.TYPE_CD = 'NOTICE' AND IH.SPECIAL_HANDLING_XML.value('(SH/Sequence) [1]', 'varchar (50)') = '1'
aND IH.SPECIAL_HANDLING_XML.value('(SH/Type) [1]', 'varchar (50)') = 'N' 
ORDER BY IH.[Loan Number]


SELECT * FROM dbo.NOTICE
WHERE LOAN_ID = '120681677'

SELECT  [Loan Number] ,
        [Loan Create Date] ,
		[Loan Effective Date],
        TYPE_CD ,
        ISSUE_DT ,
		IH.SPECIAL_HANDLING_XML.value('(SH/MailDate) [1]', 'varchar (50)') [Mail Date]	
		--INTO #tmpFF
		 FROM #tmpF IH
WHERE IH.TYPE_CD = 'NOTICE' AND IH.SPECIAL_HANDLING_XML.value('(SH/Sequence) [1]', 'varchar (50)') = '1'
aND IH.SPECIAL_HANDLING_XML.value('(SH/Type) [1]', 'varchar (50)') = 'N'
ORDER BY IH.[Loan Number]

--DROP TABLE #tmpEE
--DROP TABLE #tmpFF



SELECT LOAN_ID, NUMBER_TX,pl.ID, PRINT_STATUS_CD,PRINTED_DT, pli.RELATE_ID
INTO #tmpEEE
FROM PROCESS_LOG pl
inner join process_log_item pli on pli.PROCESS_LOG_ID = pl.id and pli.relate_type_cd = 'allied.unitrac.notice'
inner join NOTICE N on N.id = pli.relate_id 
inner join LOAN L on L.ID = n.LOAN_ID
left outer join document_container dc on dc.relate_id = n.id and dc.relate_class_name_tx = 'allied.unitrac.notice' AND DC.PURGE_DT IS NULL	
where L.NUMBER_TX IN (SELECT [Loan Number] FROM #tmpF) AND PRINT_STATUS_CD <> 'EXCLUDE'





SELECT DISTINCT RELATE_ID  --,OUTPUT_BATCH_LOG.*
from OUTPUT_BATCH OB
INNER JOIN OUTPUT_BATCH_LOG OBL ON OB.ID = OBL.OUTPUT_BATCH_ID
INNER JOIN #tmpFF EE ON EE.ID = OB.PROCESS_LOG_ID
WHERE OB.PROCESS_LOG_ID IN (SELECT ID FROM #tmpFF) AND LOG_TXN_TYPE_CD = 'SENT' 
AND OB.EXTERNAL_ID LIKE 'NTC%' AND RELATE_ID = '12656150'

