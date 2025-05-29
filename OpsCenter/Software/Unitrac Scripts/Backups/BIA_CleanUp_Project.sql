use unitrac


--drop table #tmpBIA
select id into #tmpBIA
--select * 
from BORROWER_INSURANCE_AGENCY
where NAME_TX like '%21st Century Insurance%'





select  BIA_ID [BIA], * from owner_policy
where BIA_ID in (select * from #tmpBIA)
order by BIA_ID ASC