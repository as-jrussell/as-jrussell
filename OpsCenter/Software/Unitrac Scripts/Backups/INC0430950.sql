use unitrac


select * from unitrachdstorage..INC0430950


select * from ref_code
where domain_cd = 'NFIPCompany'

insert REF_DOMAIN (DOMAIN_CD, DESCRIPTION_TX, REF_CODE_MAX_LENGTH_NO, CREATE_DT, UPDATE_DT, purge_dt, update_user_tx, lock_id, agency_based_in, preload_group_cd)
select 'FloodCompanyPrivate', 'FloodCompanyPrivate List', 100, GETDATE(), GETDATE(), NULL, 'INC0430950', 1, 'N', 'UI'
--select *

update rd set domain_cd = 'FloodCompanyNFIP'
--select * 
from REF_DOMAIN rd
where id in (534) 

Flood CompanyNFIP

insert ref_code (CODE_CD, DOMAIN_CD, MEANING_TX, DESCRIPTION_TX, ACTIVE_IN, CREATE_DT, UPDATE_DT, PURGE_DT, UPDATE_USER_TX, LOCK_ID, AGENCY_ID,  ORDER_NO)
select '', 'FloodCompanyPrivate', '', '', 'Y', GETDATE(), GETDATE(), NULL, 'INC0430950', 1, 0, 999
from unitrachdstorage..INC0430950 i on bic.id = i.BIC_ID


select * from borrower_insurance_company
where id in (16778
)

select *
from borrower_insurance_company bic
join  unitrachdstorage..INC0430950 i on bic.id != i.BIC_ID




update rc set domain_cd = 'FloodCompanyNFIP'
--select * 
from REF_CODE rc
where UPDATE_USER_TX = 'INC0430950'
and DOMAIN_CD = 'NFIPCompany'