select CPI_QUOTE_ID , L.NUMBER_TX, *--INTO #tmp
from PROCESS_LOG pl
inner join process_log_item pli on pli.PROCESS_LOG_ID = pl.id and pli.relate_type_cd = 'allied.unitrac.notice'
inner join NOTICE N on N.id = pli.relate_id 
inner join LOAN L on L.ID = n.LOAN_ID
left outer join document_container dc on dc.relate_id = n.id and dc.relate_class_name_tx = 'allied.unitrac.notice' AND DC.PURGE_DT IS NULL	
where L.NUMBER_TX IN ('269031-1', '269267-1', '265202-1', '113142-2')
ORDER BY L.NUMBER_TX ASC 



SELECT MASTER_POLICY_ASSIGNMENT_ID, * FROM dbo.CPI_QUOTE C
JOIN dbo.CPI_ACTIVITY CA ON CA.CPI_QUOTE_ID = C.ID
WHERE C.ID IN (34247144,
34247144,
34708064,
34708064,
35030683,
35030683,
35472595,
35689510,
36038031,
36038031,
36038031,
36890657)



(36695706,
36695692)
 (SELECT * FROM #tmp)
ORDER BY C.ID DESC 






SELECT * FROM dbo.MASTER_POLICY
WHERE --ID = '7655'
LENDER_ID = '2169'

SELECT * FROM dbo.MASTER_POLICY_ASSIGNMENT
WHERE ID = '28224'

