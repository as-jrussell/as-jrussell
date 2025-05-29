use UniTrac



select * from RELATED_DATA_DEF
where DESC_TX like '%escrow%'

select L.NAME_TX,  rd.* from related_data rd
join RELATED_DATA_DEF rdd on rd.def_id = rdd.id 
join LENDER L on L.ID = rd.relate_id
where DEF_id = 195



select rdd.NAME_TX, rd.* from related_data rd
join RELATED_DATA_DEF rdd on rd.def_id = rdd.id 
where DEF_id = 188


select * from CONTENT_DISCOVERY 



--Insert for Manual Pay
insert into RELATED_DATA (DEF_ID, RELATE_ID, VALUE_TX, START_DT,END_DT,COMMENT_TX,CREATE_DT,UPDATE_DT,UPDATE_USER_TX, LOCK_ID)
select  DEF_ID, , 'ManualPay', START_DT,END_DT,COMMENT_TX, GETDATE(),GETDATE(),'', '1'
from related_data rd
join RELATED_DATA_DEF rdd on rd.def_id = rdd.id 
join LENDER L on L.ID = rd.relate_id
where DEF_id = 195
and rd.id in (285192141)



--Insert for Direct Pay
insert into RELATED_DATA (DEF_ID, RELATE_ID, VALUE_TX, START_DT,END_DT,COMMENT_TX,CREATE_DT,UPDATE_DT,UPDATE_USER_TX, LOCK_ID)
select  DEF_ID, 2447, 'DirectPay', START_DT,END_DT,COMMENT_TX, GETDATE(),GETDATE(),'INC0419914', '1'
from related_data rd
join RELATED_DATA_DEF rdd on rd.def_id = rdd.id 
join LENDER L on L.ID = rd.relate_id
where DEF_id = 195
and rd.id in (285191767)
insert into RELATED_DATA (DEF_ID, RELATE_ID, VALUE_TX, START_DT,END_DT,COMMENT_TX,CREATE_DT,UPDATE_DT,UPDATE_USER_TX, LOCK_ID)
select  DEF_ID,2333 , 'DirectPay', START_DT,END_DT,COMMENT_TX, GETDATE(),GETDATE(),'INC0419914', '1'
from related_data rd
join RELATED_DATA_DEF rdd on rd.def_id = rdd.id 
join LENDER L on L.ID = rd.relate_id
where DEF_id = 195
and rd.id in (285191767)
insert into RELATED_DATA (DEF_ID, RELATE_ID, VALUE_TX, START_DT,END_DT,COMMENT_TX,CREATE_DT,UPDATE_DT,UPDATE_USER_TX, LOCK_ID)
select  DEF_ID,651 , 'DirectPay', START_DT,END_DT,COMMENT_TX, GETDATE(),GETDATE(),'INC0419914', '1'
from related_data rd
join RELATED_DATA_DEF rdd on rd.def_id = rdd.id 
join LENDER L on L.ID = rd.relate_id
where DEF_id = 195
and rd.id in (285191767)
insert into RELATED_DATA (DEF_ID, RELATE_ID, VALUE_TX, START_DT,END_DT,COMMENT_TX,CREATE_DT,UPDATE_DT,UPDATE_USER_TX, LOCK_ID)
select  DEF_ID,2402 , 'DirectPay', START_DT,END_DT,COMMENT_TX, GETDATE(),GETDATE(),'INC0419914', '1'
from related_data rd
join RELATED_DATA_DEF rdd on rd.def_id = rdd.id 
join LENDER L on L.ID = rd.relate_id
where DEF_id = 195
and rd.id in (285191767)




--Insert for Auto Direct Pay
insert into RELATED_DATA (DEF_ID, RELATE_ID, VALUE_TX, START_DT,END_DT,COMMENT_TX,CREATE_DT,UPDATE_DT,UPDATE_USER_TX, LOCK_ID)
select  DEF_ID,1810 , 'AutoDirectPay', START_DT,END_DT,COMMENT_TX, GETDATE(),GETDATE(),'', '1'
from related_data rd
join RELATED_DATA_DEF rdd on rd.def_id = rdd.id 
join LENDER L on L.ID = rd.relate_id
where DEF_id = 195
and rd.id in (285191767)


--Insert for Legacy
insert into RELATED_DATA (DEF_ID, RELATE_ID, VALUE_TX, START_DT,END_DT,COMMENT_TX,CREATE_DT,UPDATE_DT,UPDATE_USER_TX, LOCK_ID)
select  DEF_ID,1810 , 'Legacy', START_DT,END_DT,COMMENT_TX, GETDATE(),GETDATE(),'', '1'
from related_data rd
join RELATED_DATA_DEF rdd on rd.def_id = rdd.id 
join LENDER L on L.ID = rd.relate_id
where DEF_id = 195
and rd.id in (285191767)




select * from lender
where code_tx IN ('1244','1940','3769','4407')

