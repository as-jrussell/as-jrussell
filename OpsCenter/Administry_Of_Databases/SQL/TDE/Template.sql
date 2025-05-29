/*
PLEASE EACH STEP SEPERATELY 
SO THAT YOU ALL STEPS WERE 
COMPLETED

*/


--Step 1
IF NOT EXISTS (SELECT 1 FROM sys.symmetric_keys WHERE symmetric_key_id = 101)
BEGIN 
	USE [master]
		CREATE MASTER KEY ENCRYPTION
			   BY PASSWORD='Password in CyberArk';

		BACKUP MASTER KEY TO FILE = 'E:\EncryptionKey\exportedmasterkey'   
			ENCRYPTION BY PASSWORD = 'Password in CyberArk';   

		CREATE CERTIFICATE TDE_Certificate
			   WITH SUBJECT='Certificate for TDE';

		BACKUP CERTIFICATE TDE_Certificate
		TO FILE = 'E:\EncryptionKey\ALLIED_PIMSDB_master_TDE_Certificate.cer'
		WITH PRIVATE KEY (file='E:\EncryptionKey\ALLIED_PIMSDB_master_TDE_Certificate.pvk',
		ENCRYPTION BY PASSWORD='Password in CyberArk');
		PRINT 'SUCCESS: Master Key and Database Certificate Created and Backed up'
END
	ELSE 
BEGIN 
	USE [master]
		CREATE CERTIFICATE TDE_Certificate
			   WITH SUBJECT='Certificate for TDE';

		BACKUP CERTIFICATE TDE_Certificate
		TO FILE = 'E:\EncryptionKey\ALLIED_PIMSDB_master_TDE_Certificate.cer'
		WITH PRIVATE KEY (file='E:\EncryptionKey\ALLIED_PIMSDB_master_TDE_Certificate.pvk',
		ENCRYPTION BY PASSWORD='Password in CyberArk');
		PRINT 'SUCCESS: Database Certificate Created and Backed up'
END

--Step 2 
IF NOT EXISTS (SELECT  1 FROM sys.dm_database_encryption_keys WHERE DB_NAME(database_id) = 'MassMarketingData')
BEGIN 
		CREATE DATABASE ENCRYPTION KEY
		WITH ALGORITHM = AES_256
		ENCRYPTION BY SERVER CERTIFICATE TDE_Certificate;  
			ALTER DATABASE MassMarketingData SET ENCRYPTION ON
		PRINT 'ENCYPTION KEY APPLIED TO DATABASE AND TURNED ON PLEASE CHECK ON STATUS WITH THE FOLLOWING SCRIPT:

		SELECT DB_NAME(database_id) AS DatabaseName, encryption_state, encryption_state_desc = CASE encryption_state
         WHEN ''0''  THEN  ''No database encryption key present, no encryption''
         WHEN ''1''  THEN  ''Unencrypted''
         WHEN ''2''  THEN  ''Encryption in progress''
         WHEN ''3''  THEN  ''Encrypted''
         WHEN ''4''  THEN  ''Key change in progress''
         WHEN ''5''  THEN  ''Decryption in progress''
         WHEN ''6''  THEN  ''Protection change in progress (The certificate or asymmetric key that is encrypting the database encryption key is being changed.)''
         ELSE ''No Status''
         END, percent_complete,encryptor_thumbprint, encryptor_type  FROM sys.dm_database_encryption_keys	'
END 
	ELSE
BEGIN

	PRINT 'WARNING: DATABASE IS ALREADY ENCRYPTED!'

END


	
