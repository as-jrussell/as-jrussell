
USE UniTrac 

--DROP TABLE #tmpLCGCTId
SELECT P.TAB.value('.', 'nvarchar(max)') AS LCGCTId, pd.ID AS ProcId
INTO #tmpLCGCTId
FROM PROCESS_DEFINITION pd 
CROSS APPLY pd.SETTINGS_XML_IM.nodes('/ProcessDefinitionSettings/InsuranceDocTypeSettings/LenderList/LenderID') AS P (TAB)
WHERE ID = '39'


select * from process_definition
where id in (39)



select * from LENDER LDR
	left join #tmpLCGCTId tpc  ON LDR.CODE_TX = tpc.LCGCTId
	where tpc.procid is null
	  AND LDR.TEST_IN = 'N' 
        AND LDR.STATUS_CD NOT IN ( 'CANCEL', 'SUSPEND', 'MERGED' )
		order by code_tx ASC 


		select * from LENDER
		where NAME_TX like '%kc%'

--SELECT * FROM dbo.LENDER WHERE CODE_TX IN ('')




/*
DROP TABLE #tmpLCGCTId
DROP TABLE #reprocess

*/
/*
SELECT PD.ID, PLI.* FROM dbo.PROCESS_LOG_ITEM PLI
INNER JOIN dbo.LENDER L ON PLI.RELATE_ID = L.ID AND RELATE_TYPE_CD = 'Allied.UniTrac.Lender'
INNER JOIN dbo.PROCESS_LOG PL ON PL.ID = PLI.PROCESS_LOG_ID
INNER JOIN dbo.PROCESS_DEFINITION PD ON PD.ID = PL.PROCESS_DEFINITION_ID
WHERE CODE_TX = 'XXXX'


SELECT * FROM dbo.PROCESS_LOG
WHERE PROCESS_DEFINITION_ID = '123326'
AND CAST(UPDATE_DT AS DATE) >= CAST(GETDATE()-30 AS DATE)
*/




0100
0101
1114
13102
13103
13104
13105
3 RIVERS
3027
3028
3029
3033
3036
3038
3042
3082
3083
3084
3086
3088
3090
3091
3092
3093
3096
3097
3425
3626
3888
4300
4409
4720
7117
7476
7516
7624
7625
7631
7632
7633
7637
7639
7668
9500
9997
DNA-1994
xx7140

select CODE_TX into #tmpTP
from lender
where code_tx in ('0100',
'0101',
'1114',
'13102',
'13103',
'13104',
'13105',
'3 RIVERS',
'3027',
'3028',
'3029',
'3033',
'3036',
'3038',
'3042',
'3082',
'3083',
'3084',
'3086',
'3088',
'3090',
'3091',
'3092',
'3093',
'3096',
'3097',
'3425',
'3626',
'3888',
'4300',
'4409',
'4720',
'7117',
'7476',
'7516',
'7624',
'7625',
'7631',
'7632',
'7633',
'7637',
'7639',
'7668',
'9500',
'9997',
'DNA-1994',
'xx7140')
order by CODE_TX ASC  


select * from #tmpTP t
left join TRADING_PARTNER tp on t.code_tx = tp.EXTERNAL_ID_TX
where tp.EXTERNAL_ID_TX is null



select * from LENDER
where CODE_TX in ('3 RIVERS', '3042','xx7140')



	exec [UTL 2.0 Verification Report]