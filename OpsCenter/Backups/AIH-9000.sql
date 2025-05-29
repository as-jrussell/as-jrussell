USE [VehicleCT]

CREATE USER [UniTracAppUser] FOR LOGIN [UniTracAppUser]
ALTER ROLE [db_datareader] ADD MEMBER [UniTracAppUser]
GRANT EXECUTE TO [UniTracAppUser]



USE [VehicleUC]
GO
CREATE USER [UniTracAppUser] FOR LOGIN [UniTracAppUser]
ALTER ROLE [db_datareader] ADD MEMBER [UniTracAppUser]
GRANT EXECUTE TO [UniTracAppUser]


USE VehicleCT sp_change_users_login 'AUTO_FIX', 'UniTracAppUser'
USE VehicleUC sp_change_users_login 'AUTO_FIX', 'UniTracAppUser'

