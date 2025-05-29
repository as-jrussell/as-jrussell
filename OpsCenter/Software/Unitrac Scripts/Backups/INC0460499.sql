use unitrac


--0.5) Verify Import Data Looks Correct
SELECT *
FROM UnitracHDStorage..INC0460499



--1) INSERT INTO ADDRESS TABLE
INSERT INTO ADDRESS (LINE_1_TX,LINE_2_TX,CITY_TX,STATE_PROV_TX,COUNTRY_TX,POSTAL_CODE_TX,CREATE_DT,UPDATE_DT,UPDATE_USER_TX,LOCK_ID)
SELECT DISTINCT pc.Primary_Address1,pc.Primary_Address2,pc.Primary_City,IsNull(pc.Primary_State,''),'US',Right('000'+RTrim(LTrim(IsNull(Str(pc.Primary_ZipCode),'')))+'-'+RTrim(LTrim(IsNull(Str(pc.Primary_ZipCode4),'0000'))),10) AS zip,
GETDATE(), GETDATE(),'INC0460499',1
FROM UnitracHDStorage..INC0460499 pc
--39143



--2) VALIDATE ADDRSSES MATCH BEFORE INSERTINGINTO BIA
SELECT LINE_1_TX,LINE_2_TX,CITY_TX,STATE_PROV_TX,COUNTRY_TX,POSTAL_CODE_TX,pc.*
FROM UnitracHDStorage..INC0460499 pc
LEFT JOIN ADDRESS ad ON pc.Primary_Address1 = ad.line_1_TX
and IsNull(pc.Primary_Address2,'') = IsNull(ad.line_2_TX,'')
and pc.Primary_City = ad.CITy_TX
and IsNull(pc.Primary_State,'') = ad.STATE_PROV_TX
and Right('000'+RTrim(LTrim(IsNull(Str(pc.Primary_ZipCode),'')))+'-'+RTrim(LTrim(IsNull(Str(pc.Primary_ZipCode4),'0000'))),10) = ad.POSTAL_CODE_TX
AND AD.UPDATE_USER_TX = 'INC0460499' AND AD.UPDATE_DT = GETDATE()
--48976

--3) INSERT INTO BIA TABLE
INSERT INTO BORROWER_INSURANCE_AGENCY (NAME_TX,AGENT_TX,PHONE_TX, EMAIL_TX,ACTIVE_IN, CREATE_DT,UPDATE_DT,UPDATE_USER_TX, LOCK_ID, AGENCY_ID,ADDRESS_ID,DO_NOT_EMAIL_IN,DO_NOT_FAX_IN,NPN_TX)
SELECT fullname,'',Replace([primary_ phone],'-',''),email_businesstype,'Y',GETDATE(),GETDATE(),'INC0460499',1,1,AD.ID,'N','N',NPN
FROM UnitracHDStorage..INC0460499 pc
LEFT JOIN ADDRESS ad ON pc.Primary_Address1 = ad.line_1_TX
and IsNull(pc.Primary_Address2,'') = IsNull(ad.line_2_TX,'')
and pc.Primary_City = ad.CITy_TX
and IsNull(pc.Primary_State,'') = ad.STATE_PROV_TX
and Right('000'+RTrim(LTrim(IsNull(Str(pc.Primary_ZipCode),'')))+'-'+RTrim(LTrim(IsNull(Str(pc.Primary_ZipCode4),'0000'))),10) = ad.POSTAL_CODE_TX
AND AD.UPDATE_USER_TX = 'INC0460499' AND AD.UPDATE_DT = GETDATE()
--48976




update a
set purge_dt = GETDATE()
--select *
from address a 
where update_user_tx = 'INC0460499'


update bia
set purge_dt = GETDATE()
--select *
from BORROWER_INSURANCE_AGENCYbia 
where update_user_tx = 'INC0460499'