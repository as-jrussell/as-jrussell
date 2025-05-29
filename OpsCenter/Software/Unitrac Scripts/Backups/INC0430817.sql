USE [UniTrac]
GO 

--Loan Screen Information - LOAN/COLLATERAL/PROPERTY/OWNER/REQUIRED COVERAGE
SELECT L.NUMBER_TX, ih.SPECIAL_HANDLING_XML.value('(/SH/Desc)[1]', 'varchar (50)') [SmartVideo],
IH.* 
into #tmpIH
FROM LOAN L
INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
inner join dbo.REQUIRED_COVERAGE RC on RC.PROPERTY_ID = P.ID
INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
INNER JOIN dbo.INTERACTION_HISTORY IH ON IH.PROPERTY_ID = P.ID 
WHERE LL.CODE_TX IN ('2252')  and ih.TYPE_CD = 'NOTICE'
--AND L.NUMBER_TX IN ( '8100004746764')
and ih.SPECIAL_HANDLING_XML.value('(/SH/Desc)[1]', 'varchar (50)') = 'SmartVideo'

select IH.* 
into unitrachdstorage..INC0430817_IH
from dbo.INTERACTION_HISTORY IH
join #tmpIH t on t.id = ih.id


select n.* 
into unitrachdstorage..INC0430817_Notice
from NOTICE n 
join #tmpIH t on n.id = t.relate_id


update IH
set purge_dt = GETDATE(), UPDATE_dt =GETDATE(), update_user_tx = 'INC0430817',LOCK_ID = CASE WHEN ih.LOCK_ID >= 255 THEN 1 ELSE ih.LOCK_ID + 1 END
from dbo.INTERACTION_HISTORY IH
join #tmpIH t on t.id = ih.id


update n
set purge_dt = GETDATE(), UPDATE_dt =GETDATE(), update_user_tx = '',LOCK_ID = CASE WHEN n.LOCK_ID >= 255 THEN 1 ELSE n.LOCK_ID + 1 END
from NOTICE n 
join #tmpIH t on n.id = t.relate_id

drop table #tmpIH

--Loan Screen Information - LOAN/COLLATERAL/PROPERTY/OWNER/REQUIRED COVERAGE
SELECT L.NUMBER_TX, ih.SPECIAL_HANDLING_XML.value('(/SH/Desc)[1]', 'varchar (50)') [SmartVideo], ih.*
into #tmpIH
FROM LOAN L
INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
inner join dbo.REQUIRED_COVERAGE RC on RC.PROPERTY_ID = P.ID
INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
INNER JOIN dbo.INTERACTION_HISTORY IH ON IH.PROPERTY_ID = P.ID 
WHERE LL.CODE_TX IN ('1936')  and ih.TYPE_CD = 'NOTICE'
--AND L.NUMBER_TX IN ( '8100004746764')
and ih.SPECIAL_HANDLING_XML.value('(/SH/Desc)[1]', 'varchar (50)') = 'SmartVideo'


select * from #tmpIH
where NUMBER_TX like '8100%764'

select ih.* 
into unitrachdstorage..INC0430817_IH_1936
from dbo.INTERACTION_HISTORY IH
join #tmpIH t on t.id = ih.id



select n.* 
into unitrachdstorage..INC0430817_Notice_1936
from NOTICE n 
join #tmpIH t on n.id = t.relate_id




update IH
set purge_dt = GETDATE(), UPDATE_dt =GETDATE(), update_user_tx = 'INC0430817',LOCK_ID = CASE WHEN ih.LOCK_ID >= 255 THEN 1 ELSE ih.LOCK_ID + 1 END
from dbo.INTERACTION_HISTORY IH
join #tmpIH t on t.id = ih.id


update n
set purge_dt = GETDATE(), UPDATE_dt =GETDATE(), update_user_tx = '',LOCK_ID = CASE WHEN n.LOCK_ID >= 255 THEN 1 ELSE n.LOCK_ID + 1 END
from NOTICE n 
join #tmpIH t on n.id = t.relate_id
