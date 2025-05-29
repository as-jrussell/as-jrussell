USE [UniTrac]
GO 

--Loan Screen Information - LOAN/COLLATERAL/PROPERTY/OWNER/REQUIRED COVERAGE
SELECT count(*)
--into UnitracHDStorage..INC0381236_2
 FROM LOAN L
INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
INNER JOIN REQUIRED_COVERAGE RC ON P.ID = RC.PROPERTY_ID
INNER JOIN OWNER_LOAN_RELATE OL ON L.ID = OL.LOAN_ID
INNER JOIN OWNER O ON OL.OWNER_ID = O.ID
INNER JOIN OWNER_ADDRESS OA ON O.ADDRESS_ID = OA.ID
INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
INNER JOIN dbo.PROPERTY_OWNER_POLICY_RELATE POP ON POP.PROPERTY_ID = P.ID
INNER JOIN dbo.OWNER_POLICY OP ON OP.ID = POP.OWNER_POLICY_ID
INNER JOIN dbo.POLICY_COVERAGE PC ON PC.OWNER_POLICY_ID = OP.ID
WHERE LL.CODE_TX = '0108' --AND OP.update_user_tx ='LDHPCRA' --and op.cancellation_dt is null
and op.update_user_tx ='LDHPCRA' and op.Purge_dt is null

update OP
set purge_dt = GETDATE(), update_dt = GETDATE(), LOCK_ID = LOCK_ID+1, UPDATE_USER_TX = 'INC0381236'
--select *
from dbo.OWNER_POLICY OP
where id iN (select id from UniTracHDStorage..INC0381236_2)



INSERT INTO PROPERTY_CHANGE
 ( ENTITY_NAME_TX , ENTITY_ID , USER_TX , ATTACHMENT_IN , 
 CREATE_DT , AGENCY_ID , DESCRIPTION_TX ,  DETAILS_IN , FORMATTED_IN ,
 LOCK_ID , PARENT_NAME_TX , PARENT_ID , TRANS_STATUS_CD , UTL_IN )
 SELECT DISTINCT 'Allied.UniTrac.OwnerPolicy' , L.ID , 'INC0381236' , 'N' , 
 GETDATE() ,  1 , 
'Purged per ticket INC0381236', 
 'Y' , 'N' , 1 ,  'Allied.UniTrac.OwnerPolicy' , L.ID , 'PEND' , 'N'
FROM OWNER_POLICY L 
WHERE L.ID IN (SELECT ID FROM UniTracHDStorage..INC0381236)


-- select * from UniTracHDStorage..INC0381236_ih

select * from  UniTracHDStorage..INC0381236_2_ih

UPDATE ih set purge_dt = GETDATE(), update_dt = GETDATE(), update_user_tx = 'INC0381236', lock_id= lock_id+1
--select * 
from interaction_history ih
where relate_id in (SELECT ID FROM UniTracHDStorage..INC0381236)
and relate_class_tx = 'Allied.UniTrac.OwnerPolicy'


UPDATE ih set purge_dt = GETDATE(), update_dt = GETDATE(), update_user_tx = 'INC0381236', lock_id= lock_id+1
--select * 
from interaction_history ih
where relate_id in (SELECT ID FROM UniTracHDStorage..INC0381236_2)
and relate_class_tx = 'Allied.UniTrac.OwnerPolicy'





UPDATE ih set ih.purge_dt = GETDATE(), ih.update_dt = GETDATE(), ih.update_user_tx = 'INC0381236', ih.lock_id= ih.lock_id+1
--select top 100 ih.* 
from interaction_history ih
join property p on p.id = ih.property_id
where --relate_id in (246869257,246869258,246869260,246869262,246869464,246869466)
 relate_class_tx = 'Allied.UniTrac.OwnerPolicy' and ih.create_user_tx ='LDHPCRA' and P.LENDER_ID = 2422
 and ih.Purge_dt is null


 select ih.* 
from interaction_history ih
join property p on p.id = ih.property_id
where ih.id in (select id from  UniTracHDStorage..INC0381236_ih) or ih.id in (select id from UniTracHDStorage..INC0381236_2_ih)

-- UniTracHDStorage..INC0381236_2_ih)
 

 select * from owner_policy
 where id in (select ih.relate_id
from interaction_history ih
where ih.id in (select id from  UniTracHDStorage..INC0381236_ih) or ih.id in (select id from UniTracHDStorage..INC0381236_2_ih))
and purge_dt is null



update OP
set purge_dt = '2018-11-14 06:55:42.500', update_dt = '2018-11-14 06:55:42.500', LOCK_ID = LOCK_ID+1, UPDATE_USER_TX = 'INC0381236'
--select *
from dbo.OWNER_POLICY OP
where id iN (243987961,246682076,246682093,243989206,243989200,243989483,243989497,243990323)


UPDATE ih set purge_dt = '2018-11-14 06:55:42.500', update_dt = '2018-11-14 06:55:42.500', ih.update_user_tx = 'INC0381236', ih.lock_id= ih.lock_id+1
--select top 100 ih.* 
from interaction_history ih
join property p on p.id = ih.property_id
where relate_id in(243987961,246682076,246682093,243989206,243989200,243989483,243989497,243990323) and
 relate_class_tx = 'Allied.UniTrac.OwnerPolicy' and ih.create_user_tx ='LDHPCRA' and P.LENDER_ID = 2422
 and ih.Purge_dt is null


select ih.relate_id into #tmpOP
from interaction_history ih
join property p on p.id = ih.property_id
where  --relate_id in (246208573) and relate_class_tx = 'Allied.UniTrac.OwnerPolicy'
 relate_class_tx = 'Allied.UniTrac.OwnerPolicy' and ih.create_user_tx ='LDHPCRA' and P.LENDER_ID = 2422
 and ih.purge_dt is null




 SELECT distinct OP.id
 FROM LOAN L
INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
INNER JOIN REQUIRED_COVERAGE RC ON P.ID = RC.PROPERTY_ID
INNER JOIN OWNER_LOAN_RELATE OL ON L.ID = OL.LOAN_ID
INNER JOIN OWNER O ON OL.OWNER_ID = O.ID
INNER JOIN OWNER_ADDRESS OA ON O.ADDRESS_ID = OA.ID
INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
INNER JOIN dbo.PROPERTY_OWNER_POLICY_RELATE POP ON POP.PROPERTY_ID = P.ID
INNER JOIN dbo.OWNER_POLICY OP ON OP.ID = POP.OWNER_POLICY_ID
INNER JOIN dbo.POLICY_COVERAGE PC ON PC.OWNER_POLICY_ID = OP.ID
WHERE LL.CODE_TX = '0108' AND L.NUMBER_TX IN ('366273820','335872433','336273643')
and op.purge_dt is null



drop table #tmpOP
select * from interaction_history
where relate_id in (245605052,
246123258,
247040534,
247099212) and relate_class_tx = 'Allied.UniTrac.OwnerPolicy'


update OP
set purge_dt = '2018-11-14 07:14:23.513'
--select *
from dbo.OWNER_POLICY OP
where id in (245605052,
246123258,
247040534,
247099212) and purge_dt is null





select *
--select ih.property_id into #tmpProperty
from interaction_history ih
join property p on p.id = ih.property_id
where  --relate_id in (246208573) and relate_class_tx = 'Allied.UniTrac.OwnerPolicy'
 relate_class_tx = 'Allied.UniTrac.OwnerPolicy' and ih.create_user_tx ='LDHPCRA' and P.LENDER_ID = 2422

update rc set good_thru_dt = NULL,  update_dt = GETDATE(), update_user_tx = 'INC0381236', rc.lock_id= rc.lock_id+1
--select good_thru_dt, * 
from REQUIRED_COVERAGE RC
 join #tmpProperty T on T.Property_id = RC.Property_id