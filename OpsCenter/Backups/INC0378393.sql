use UniTrac				



select * 
--into unitrachdstorage..
from LOAN L 
join COLLATERAL c on c.LOAN_ID = L.ID
join LENDER LL on LL.ID = L.LENDER_ID
where LL.CODE_TX IN ('1615') and C.Collateral_code_id in (select id from #tmpCC2)


select * from lender
where CODE_TX = '1615'



select CC.CODE_TX, COUNT(*) from LOAN L 
join COLLATERAL c on c.LOAN_ID = L.ID
join LENDER LL on LL.ID = L.LENDER_ID
join COLLATERAL_CODE CC on CC.ID = C.Collateral_CODE_ID 
where LL.CODE_TX IN ('1615') and (CC.CODE_tx like '%-OT' OR CC.CODE_TX LIKE '%-A')
group by CC.CODE_TX 




select CC.CODE_TX, CC.ID, COUNT(*) from LOAN L 
join COLLATERAL c on c.LOAN_ID = L.ID
join LENDER LL on LL.ID = L.LENDER_ID
join COLLATERAL_CODE CC on CC.ID = C.Collateral_CODE_ID 
where LL.CODE_TX IN ('1615') and (CC.CODE_tx like '%-OT'
OR CC.CODE_tx like '%-A')
group by CC.CODE_TX, CC.ID
order by CC.CODE_TX ASC


---Finding Collateral Code
SELECT  CC.ID ,
        CC.CODE_TX ,
        CC.DESCRIPTION_TX 
		into #tmpCC2
         FROM dbo.COLLATERAL_CODE CC
INNER JOIN dbo.LCCG_COLLATERAL_CODE_RELATE CCR ON CCR.COLLATERAL_CODE_ID = CC.ID
INNER JOIN dbo.LENDER_COLLATERAL_CODE_GROUP LCCG ON LCCG.ID = CCR.LCCG_ID
INNER JOIN dbo.LENDER L ON L.ID = LCCG.LENDER_ID
WHERE L.CODE_TX = '1615' and  (CC.CODE_tx like '%-OT'
OR CC.CODE_tx like '%-A')


SELECT  CC.ID ,
        CC.CODE_TX ,
        CC.DESCRIPTION_TX 
		into #tmpCC
         FROM dbo.COLLATERAL_CODE CC
INNER JOIN dbo.LCCG_COLLATERAL_CODE_RELATE CCR ON CCR.COLLATERAL_CODE_ID = CC.ID
INNER JOIN dbo.LENDER_COLLATERAL_CODE_GROUP LCCG ON LCCG.ID = CCR.LCCG_ID
INNER JOIN dbo.LENDER L ON L.ID = LCCG.LENDER_ID
WHERE L.CODE_TX = '1615' and cc.id not in ( select id from #tmpCC2)



select DISTINCT TT.ID, T.CODE_TX, TT.CODE_TX from #tmpCC2 T
cross join #tmpCC TT --on T.CODE_TX = TT.CODE_TX






select id, 'NULL' [NULL],CODE_TX, DESCRIPTION_TX from #tmpCC2

select  'NULL'[NULL] ,id,CODE_TX, DESCRIPTION_TX from #tmpCC
 

select * from #tmpCC 

create table #tmpPD
(OLD_ID NVARCHAR(4000) , NEW_ID NVARCHAR(4000) ,CODE_TX NVARCHAR(4000), DESCRIPTION_TX NVARCHAR(4000))
insert into #tmpPD
select id, 'NULL' [NULL],CODE_TX, DESCRIPTION_TX from #tmpCC2
--select  'NULL'[NULL] ,id,CODE_TX, DESCRIPTION_TX from #tmpCC


insert into #tmpPD
select  'NULL'[NULL] ,id,CODE_TX, DESCRIPTION_TX from #tmpCC






select * from #tmpPD
where  code_tx like '%-OT' or code_tx like '%-A' 


UPDATE C
set COLLATERAL_CODE_ID = 525
--select *
from COLLATERAL C
join LOAN L on L.ID = C.LOAN_ID
join #tmpPD T on  T.OLD_ID = C.COLLATERAL_CODE_ID
where L.LENDER_ID = 12

UPDATE C SET COLLATERAL_CODE_ID = 10
--select *
from COLLATERAL C
join LOAN L on L.ID = C.LOAN_ID
join #tmpPD T on  T.OLD_ID = C.COLLATERAL_CODE_ID
where L.LENDER_ID = 12 and  (T.CODE_tx like 'RV-OT'
OR T.CODE_tx like 'RV-A')
--735


UPDATE C SET COLLATERAL_CODE_ID = 15
--select *
from COLLATERAL C
join LOAN L on L.ID = C.LOAN_ID
join #tmpPD T on  T.OLD_ID = C.COLLATERAL_CODE_ID
where L.LENDER_ID = 12 and  (T.CODE_tx like 'ATV-OT'
OR T.CODE_tx like 'ATV-A')


UPDATE C SET COLLATERAL_CODE_ID = 9
--select *
from COLLATERAL C
join LOAN L on L.ID = C.LOAN_ID
join #tmpPD T on  T.OLD_ID = C.COLLATERAL_CODE_ID
where L.LENDER_ID = 12 and  (T.CODE_tx like 'MCYCLE-OT'
OR T.CODE_tx like 'MCYCLE-A')



UPDATE C SET COLLATERAL_CODE_ID = 16
--select *
from COLLATERAL C
join LOAN L on L.ID = C.LOAN_ID
join #tmpPD T on  T.OLD_ID = C.COLLATERAL_CODE_ID
where L.LENDER_ID = 12 and  (T.CODE_tx like 'JETSKI-OT'
OR T.CODE_tx like 'JETSKI-A')


UPDATE C SET COLLATERAL_CODE_ID = 14
--select *
from COLLATERAL C
join LOAN L on L.ID = C.LOAN_ID
join #tmpPD T on  T.OLD_ID = C.COLLATERAL_CODE_ID
where L.LENDER_ID = 12 and  (T.CODE_tx like 'FMEQ-OT'
OR T.CODE_tx like 'FMEQ-A')



UPDATE C SET COLLATERAL_CODE_ID = 7
--select *
from COLLATERAL C
join LOAN L on L.ID = C.LOAN_ID
join #tmpPD T on  T.OLD_ID = C.COLLATERAL_CODE_ID
where L.LENDER_ID = 12 and  (T.CODE_tx like 'MTRHM-OT'
OR T.CODE_tx like 'MTRHM-A')


UPDATE C SET COLLATERAL_CODE_ID = 9
--select *
from COLLATERAL C
join LOAN L on L.ID = C.LOAN_ID
join #tmpPD T on  T.OLD_ID = C.COLLATERAL_CODE_ID
where L.LENDER_ID = 12 and  (T.CODE_tx like 'MOBHM-OT'
OR T.CODE_tx like 'MOBHM-A')



UPDATE C SET COLLATERAL_CODE_ID = 11
--select *
from COLLATERAL C
join LOAN L on L.ID = C.LOAN_ID
join #tmpPD T on  T.OLD_ID = C.COLLATERAL_CODE_ID
where L.LENDER_ID = 12 and  (T.CODE_tx like 'TRLR-OT'
OR T.CODE_tx like 'TRLR-A')


UPDATE C SET COLLATERAL_CODE_ID = 61
--select *
from COLLATERAL C
join LOAN L on L.ID = C.LOAN_ID
join #tmpPD T on  T.OLD_ID = C.COLLATERAL_CODE_ID
where L.LENDER_ID = 12 and  (T.CODE_tx like 'TRVLTRL-A'
OR T.CODE_tx like 'TRVLTRL-OT')



select CC.CODE_TX, COUNT(*) from LOAN L 
join COLLATERAL c on c.LOAN_ID = L.ID
join LENDER LL on LL.ID = L.LENDER_ID
join COLLATERAL_CODE CC on CC.ID = C.Collateral_CODE_ID 
where LL.CODE_TX IN ('1615') and (CC.CODE_tx like '%-OT' OR CC.CODE_TX LIKE '%-A')
group by CC.CODE_TX 

UPDATE C SET COLLATERAL_CODE_ID = 16
--select *
from COLLATERAL C
join LOAN L on L.ID = C.LOAN_ID
join #tmpPD T on  T.OLD_ID = C.COLLATERAL_CODE_ID
where L.LENDER_ID = 12 and  (T.CODE_tx like 'JETSKI -A'
OR T.CODE_tx like 'JETSKI-OT')



select CC.CODE_TX, COUNT(*) from LOAN L 
join COLLATERAL c on c.LOAN_ID = L.ID
join LENDER LL on LL.ID = L.LENDER_ID
join COLLATERAL_CODE CC on CC.ID = C.Collateral_CODE_ID 
where LL.CODE_TX IN ('1615') and (CC.CODE_tx like '%-OT' OR CC.CODE_TX LIKE '%-A')
group by CC.CODE_TX 
