use unitrac


select * from users


insert into users 
(USER_NAME_TX, PASSWORD_TX, FAMILY_NAME_TX, GIVEN_NAME_TX, ACTIVE_IN, EMAIL_TX, EXTERN_MAINT_IN, LOGIN_COUNT_NO, LAST_LOGIN_DT, CREATE_DT, UPDATE_DT, PURGE_DT, UPDATE_USER_TX, lock_id, default_agency_id, system_in)
select 'RPAOrchDev', PASSWORD_TX, 'RPAOrchDev', 'RPAOrchDev', ACTIVE_IN, 'RPAOrchDev@alliedsolutions.net', EXTERN_MAINT_IN, LOGIN_COUNT_NO, LAST_LOGIN_DT, GETDATE(), GETDATE(), PURGE_DT, UPDATE_USER_TX, lock_id, default_agency_id, system_in
from users 
where id in (3774)
