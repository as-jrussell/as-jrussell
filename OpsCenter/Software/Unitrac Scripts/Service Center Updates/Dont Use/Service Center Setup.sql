select *
from service_center
where CODE_TX not like '%/%'

--insert one record into Service_Center and service_center_function tables
-- ADDRESS table and setting the IDs into (BILLING_ADDRESS_ID, PHYSICAL_ADDRESS_ID, MAILING_ADDRESS_ID, CONTACT_ID)

--1) Insert Address into ADDRESS table
insert into ADDRESS (LINE_1_TX, CITY_TX, STATE_PROV_TX, COUNTRY_TX, POSTAL_CODE_TX, CREATE_DT, UPDATE_DT,UPDATE_USER_TX, LOCK_ID)
VALUES ('576 Gateway Drive', 'Napa', 'CA','US','94558',getdate(), getdate(),'MBREITSCH',1)

--2) Pull Address ID from table
select *
from ADDRESS
where UPDATE_USER_TX = 'MBREITSCH'

--3)Insert center info into SERVICE_CENTER table
insert into service_center (CODE_TX, NAME_TX, PHONE_TX, FAX_TX, PHYSICAL_ADDRESS_ID, MAILING_ADDRESS_ID, CREATE_DT, UPDATE_DT,UPDATE_USER_TX, LOCK_ID)
values ('Calif Mortgage', 'Calif Mortgage','800-542-7900','707-603-2837',169241,169241,getdate(),getdate(),'MBREITSCH',1)

--3)Insert center info into SERVICE_CENTER_FUNCTION table

insert into SERVICE_CENTER_FUNCTION (SERVICE_CENTER_ID, SERVICE_CENTER_CODE_TX, CREATE_DT, UPDATE_DT, UPDATE_USER_TX, LOCK_ID)
values (109,'',GETDATE(),GETDATE(),'MBREITSCH',1)


