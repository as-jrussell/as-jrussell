

USE [UniTrac]
GO

select *
from UniTrac..users
where user_name_tx = 'admin'

update UniTrac..users
set password_tx = 'OOo2uY6cqEVRVagK2TRCCg=='
where user_name_tx = 'admin'

