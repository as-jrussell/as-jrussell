USE QCModule


select * from users
where user_name_tx = 'SBevelhymer'



insert USERS
(USER_NAME_TX, PASSWORD_TX, SALT_TX, PERSON_ID,ACTIVE_IN, EXTERN_MAINT_IN,LOGIN_COUNT_NO, LAST_LOGIN_DT, DEFAULT_AGENCY_ID,SYSTEM_IN,PASSWORD_SET_DT, IS_LOCKED_OUT_IN, INVALID_LOGIN_COUNT_NO, INVALID_LOGIN_DT, LOCKED_COUNT_NO, LOCKED_DT, USER_NAME_BIN, PURGE_DT, CREATE_DT,UPDATE_DT, UPDATE_USER_TX, LOCK_ID)
select 'Kalel', PASSWORD_TX, SALT_TX, PERSON_ID,ACTIVE_IN, EXTERN_MAINT_IN,null, null, DEFAULT_AGENCY_ID,SYSTEM_IN,PASSWORD_SET_DT, IS_LOCKED_OUT_IN, INVALID_LOGIN_COUNT_NO, INVALID_LOGIN_DT, LOCKED_COUNT_NO, LOCKED_DT, USER_NAME_BIN, NULL, GETDATE(),GETDATE(), 'INC0452954', LOCK_ID
from USERS
where id = '2'





select pd.* from QC_BATCH_DEFINITION bd
join qc_rule_definition rd on bd.qc_rule_definition_id = rd.id
join PROCESS_DEFINITION pd on pd.id = bd.process_definition_id
where START_DT >= '2018-11-26'


select * from qc_batch q
join PROCESS_LOG pl on pl.id = q.process_log_id
join PROCESS_DEFINITION pd on pd.id = pl.process_definition_id
where pl.create_Dt >= '2018-11-20' and process_type_cd ='QCFILEIMP'



select * from QC_BATCH_DEFINITION bd
join qc_rule_definition rd on bd.qc_rule_definition_id = rd.id
join PROCESS_DEFINITION pd on pd.id = bd.process_definition_id
where START_DT >= '2018-11-19'


select * from PROCESS_DEFINITION
where process_type_cd ='QCFILEIMP'



select * from REF_CODE
where code_cd = 'QCFILEIMP'



select * from unitrac..connection_descriptor
where server_tx like '%.%'




update U 
set password_tx = 'wXpcQd9N7SbGCE+FZHMMozkxY0gJAGHtoJ1yDPv7ztD2BEJdeqE7IMW5zdvnQ6T7lU21ApHgWxSWF0jbUksrwib4UA9AKUhZmaqUZbRou/zSvccP28sE0nn0O0mZ8ZKnukhCZicRoi+XCQHd2O+fvHtlWSLJk0DGt5fJ7VObzlQ='
from USERS U
where id in (18)


