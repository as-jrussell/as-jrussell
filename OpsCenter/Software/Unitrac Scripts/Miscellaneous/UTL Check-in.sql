USE UTL

select COUNT(*) from process_definition
where STATUS_CD = 'Error'


select count(*)[Open UTLs from Lender that have added], LL.CODE_TX [Lender Code], LL.NAME_TX [Lender Name]
from loan L
join [utqa-sql-14].Unitrac.dbo.Lender LL on LL.ID = L.lender_id
join [utqa-sql-14].Unitrac.dbo.RELATED_DATA rd ON l.ID = rd.RELATE_ID AND rd.DEF_ID = '183' and rd.value_tx = 'true'
where L.PURGE_DT IS NULL  and   l.EVALUATION_DT < '1/1/1901'
group by  LL.CODE_TX, LL.NAME_TX
order by count(*) DESC



select * from PROCESS_LOG
where process_definition_id in (1,5,6,7,8,9,10,13)
and UPDATE_DT >= '2019-01-01 00:00'
order by UPDATE_DT desc 



EXEC [utl-sql-01].UTL.dbo.ReportSupport_UTLSummary DECLARE @utls NVARCHAR(MAX), @idValuesDelimited = @utls '1'
