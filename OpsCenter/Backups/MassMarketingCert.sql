USE master;
GO
--Creating a master key
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'qBwxAeV95LiLEbJfiuEW';
go



--Creating a certificate in the master database
CREATE CERTIFICATE MassMarketingCert  WITH SUBJECT = 'MassMarketing Data Certificate';
go



USE MassMarketingData ;
GO

CREATE DATABASE ENCRYPTION KEY
WITH ALGORITHM = AES_256
ENCRYPTION BY SERVER CERTIFICATE MassMarketingCert;
GO

ALTER DATABASE MassMarketingData 
SET ENCRYPTION ON;
GO


use master
---Backup the certificate on the source server
BACKUP CERTIFICATE MassMarketingCert   
TO FILE = 'E:\SQL\MassMarketingData.cert'  
WITH PRIVATE KEY   
(  
    FILE = 'E:\SQL\MassMarketingDataPrivateKey.key',  
    ENCRYPTION BY PASSWORD = '8iFQpyBY3F3fjgmiLfjS'  
);  
GO 



--Validation 
select is_encrypted, is_master_key_encrypted_by_server, * from sys.databases 
where (is_encrypted <> '0' OR is_master_key_encrypted_by_server <> '0')

SELECT DB_NAME(database_id)
  ,encryption_state = CASE 
    WHEN encryption_state = 1
      THEN 'Unencrypted'
    WHEN encryption_state = 2
      THEN 'Encryption in progress'
    WHEN encryption_state = 3
      THEN 'Encrypted'
    WHEN encryption_state = 4
      THEN 'Key change in progress'
    WHEN encryption_state = 5
      THEN 'Decryption in progress'
    WHEN encryption_state = 6
      THEN 'Protection change in progress'
    WHEN encryption_state = 0
      THEN 'No database encryption key present, no encryption'
    END
  ,create_date
  ,encryptor_type, *
FROM sys.dm_database_encryption_keys


