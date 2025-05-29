SELECT d.is_master_key_encrypted_by_server,*
FROM sys.databases AS d

USE [master]
GO

SELECT * FROM sys.certificates

select @@SERVERNAME
SELECT * FROM sys.symmetric_keys WHERE symmetric_key_id = 101

USE [master]
GO
SELECT * FROM sys.certificates


/*
If there is not a master key created. 

USE master;
GO
CREATE MASTER KEY ENCRYPTION
       BY PASSWORD='';
GO



BACKUP MASTER KEY TO FILE = 'E:\EncryptionKey\exportedmasterkey'   
    ENCRYPTION BY PASSWORD = '';   
GO


--Creation of Cert
USE master;
GO 
CREATE CERTIFICATE TDE_Certificate
       WITH SUBJECT='Certificate for TDE';
GO

--Select the databases that you want to encrypt can be more than one using the same cert
USE MassMarketingData 
GO
CREATE DATABASE ENCRYPTION KEY
WITH ALGORITHM = AES_256
ENCRYPTION BY SERVER CERTIFICATE TDE_Certificate;  


USE MassMarketingMVCTest 
GO
CREATE DATABASE ENCRYPTION KEY
WITH ALGORITHM = AES_256
ENCRYPTION BY SERVER CERTIFICATE TDE_Certificate;  


--Backup Encryption keys

USE master;
GO
BACKUP CERTIFICATE TDE_Certificate
TO FILE = 'E:\EncryptionKey\ds_sqltest_14_master_TDE_Certificate.cer'
WITH PRIVATE KEY (file='E:\EncryptionKey\ds_sqltest_14_master_TDE_Certificate.pvk',
ENCRYPTION BY PASSWORD='');

*/


--Turn on Encryption (if more than one database; do one at a time) 
ALTER DATABASE MassMarketingMVCTest SET ENCRYPTION ON;
GO

---Monitor Progress 

SELECT DB_NAME(database_id) AS DatabaseName, encryption_state,
encryption_state_desc =
CASE encryption_state
         WHEN '0'  THEN  'No database encryption key present, no encryption'
         WHEN '1'  THEN  'Unencrypted'
         WHEN '2'  THEN  'Encryption in progress'
         WHEN '3'  THEN  'Encrypted'
         WHEN '4'  THEN  'Key change in progress'
         WHEN '5'  THEN  'Decryption in progress'
         WHEN '6'  THEN  'Protection change in progress (The certificate or asymmetric key that is encrypting the database encryption key is being changed.)'
         ELSE 'No Status'
         END,
percent_complete,encryptor_thumbprint, encryptor_type  FROM sys.dm_database_encryption_keys