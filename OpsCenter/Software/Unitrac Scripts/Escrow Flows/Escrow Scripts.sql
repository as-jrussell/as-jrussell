use UniTrac

--GetBillMissingRequiredCoverageIds
--GetEscrowExceptionReasons


select l.number_tx, wi. * 
from work_item wi 
join escrow_verification ev on ev.id = wi.relate_id and wi.relate_type_cd = 'Allied.UniTrac.EscrowVerification'
join escrow e on e.id = ev.escrow_id 
join loan l on l.id = e.loan_id
join lender le on le.id = l.LENDER_ID
where le.CODE_TX = '3551'
and NUMBER_TX like '%0001085762%'
--where wi.id = ''


SELECT  SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/TargetServiceList/TargetService)[1]',
                              'nvarchar(max)') [Target Service] ,
SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/AnticipatedNextScheduledDate)[1]',
                                    'varchar(50)'),
 *
 from process_definition
where process_type_cd IN ('ESCEXPPRC','ESCBMPRC')



select * from escrow_verification
where id in (16519211,
17075561,
10351316)


select * from ESCROW
where id in (3195870,
4351621,
4480928)

select * from property
where id in (247365062)


select * from loan
where id in (276066834)

select L.NUMBER_TX, * from escrow_queue eq
join ESCROW e on e.id = eq.ESCROW_ID
join LOAN L on l.id = E.LOAN_ID
join escrow_verification ev on e.id = ev.escrow_id 
where  l.number_tx IN ('30468', '121511')


select L.NUMBER_TX, * from escrow_queue eq
join ESCROW e on e.id = eq.ESCROW_ID
join LOAN L on l.id = E.LOAN_ID
where  l.number_tx like ('%30468%')



select id into #tmp
from PROCESS_LOG
where CREATE_DT >= '2021-06-16' and  PROCESS_DEFINITION_ID in (846420)


select top 1* 
from PROCESS_LOG_ITEM
where PROCESS_LOG_ID in (select id from #tmp)
and RELATE_ID = '247365062'

USE UniTrac	
select le.code_tx, le.name_tx, eed.function_name_tx, ee.*
from escrow_exception_definition_Lender_relate ee
join escrow_exception_definition eed on eed.id =ee.escrow_exception_definition_id
join lender le on le.id = ee.lender_id

select * from escrow_exception

select * from escrow_exception_definition


select * from ref_code
where domain_cd=  'EscrowExceptionReason'

select * from RELATED_DATA_DEF
where ID = 195

select L.NAME_TX, L.CODE_TX, rd.* from related_data rd
join RELATED_DATA_DEF rdd on rd.def_id = rdd.id 
join LENDER L on L.ID = rd.relate_id
where DEF_id = 195 and END_DT is not null 
--and CODE_TX IN ('3551',  '2771'


select * from CONTENT_DISCOVERY 


SELECT L.CODE_TX [Lender Code], L.NAME_TX [Lender Name], rd.VALUE_TX [EscrowFlowType], rd.CREATE_DT [Date Creation]
FROM dbo.RELATED_DATA rd
INNER JOIN LENDER l ON l.id = rd.RELATE_ID AND rd.DEF_ID = 195
ORDER BY rd.CREATE_DT ASC       
	   
WHERE rdd.NAME_TX = 'EscrowFlowType'


/*

Adding lender

SELECT rdd.ID RelatedDataId,
       l.ID LenderId
INTO #temp20Lenders
FROM RELATED_DATA_DEF rdd
    INNER JOIN LENDER l
        ON 1 = 1
WHERE rdd.NAME_TX = 'EscrowFlowType'
      AND l.CODE_TX IN ('')
      AND l.TEST_IN = 'N'
      AND l.PURGE_DT IS NULL;
GO

--Insert for Manual Pay
insert into RELATED_DATA (DEF_ID, RELATE_ID, VALUE_TX, START_DT,END_DT,COMMENT_TX,CREATE_DT,UPDATE_DT,UPDATE_USER_TX, LOCK_ID)
select  RelatedDataId, LenderId, 'ManualPay', NULL,NULL,'EscrowFlowType', GETDATE(),GETDATE(),'INC0426510', '1'
FROM #temp20Lenders
GO 


SELECT rdd.ID RelatedDataId,
       l.ID LenderId
INTO #temp20Lenders2
FROM RELATED_DATA_DEF rdd
    INNER JOIN LENDER l
        ON 1 = 1
WHERE rdd.NAME_TX = 'EscrowFlowType'
      AND l.CODE_TX IN ('')
      AND l.TEST_IN = 'N'
      AND l.PURGE_DT IS NULL;
GO

--Insert for Direct Pay
insert into RELATED_DATA (DEF_ID, RELATE_ID, VALUE_TX, START_DT,END_DT,COMMENT_TX,CREATE_DT,UPDATE_DT,UPDATE_USER_TX, LOCK_ID)
select  RelatedDataId, LenderId,'DirectPay', NULL,NULL,'EscrowFlowType', GETDATE(),GETDATE(),'INC0426510', '1'
FROM #temp20Lenders2
GO 




SELECT rdd.ID RelatedDataId,
       l.ID LenderId
INTO #temp20Lenders3
FROM RELATED_DATA_DEF rdd
    INNER JOIN LENDER l
        ON 1 = 1
WHERE rdd.NAME_TX = 'EscrowFlowType'
      AND l.CODE_TX IN ('')
      AND l.TEST_IN = 'N'
      AND l.PURGE_DT IS NULL;
GO

--Insert for AutoDirectPay Pay
insert into RELATED_DATA (DEF_ID, RELATE_ID, VALUE_TX, START_DT,END_DT,COMMENT_TX,CREATE_DT,UPDATE_DT,UPDATE_USER_TX, LOCK_ID)
select  RelatedDataId, LenderId, 'AutoDirectPay', NULL,NULL,'EscrowFlowType', GETDATE(),GETDATE(),'INC0426510', '1'
FROM #temp20Lenders3
GO 


SELECT rdd.ID RelatedDataId,
       l.ID LenderId
INTO #temp20Lenders4
FROM RELATED_DATA_DEF rdd
    INNER JOIN LENDER l
        ON 1 = 1
WHERE rdd.NAME_TX = 'EscrowFlowType'
      AND l.CODE_TX IN ('')
      AND l.TEST_IN = 'N'
      AND l.PURGE_DT IS NULL;
GO

--Insert for Legacy Pay
insert into RELATED_DATA (DEF_ID, RELATE_ID, VALUE_TX, START_DT,END_DT,COMMENT_TX,CREATE_DT,UPDATE_DT,UPDATE_USER_TX, LOCK_ID)
select  RelatedDataId, LenderId,'Legacy', NULL,NULL,'EscrowFlowType', GETDATE(),GETDATE(),'INC0426510', '1'
FROM #temp20Lenders4
GO 



select * from lender
where code_tx =''

update rd set END_DT = GETDATE()-1, LOCK_ID = CASE WHEN LOCK_ID >= 255 THEN 1 ELSE LOCK_ID + 1 END
--select * 
from RELATED_DATA rd
where id in (309171122)


*/

select id
from lender
where code_tx IN( '3663', '1695')

insert escrow_exception_definition_Lender_relate
(escrow_exception_definition_id, lender_id, create_dt, update_dt, update_user_tx, purge_dt, lock_id)
select '','' , GETDATE(), GETDATE(), '', null, 1





select * from escrow_exception_definition
where standard_in = 'Y'