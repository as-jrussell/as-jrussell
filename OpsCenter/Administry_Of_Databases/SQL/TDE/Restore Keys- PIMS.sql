

USE [master]
GO
SELECT * FROM sys.certificates


SELECT * FROM sys.symmetric_keys WHERE symmetric_key_id = 101




CREATE MASTER KEY
  ENCRYPTION BY PASSWORD = 'BACKUP MASTER KEY (Test & Prod PIMS) On exportedmasterkey';
GO




CREATE CERTIFICATE TDE_Certificate  
  FROM FILE = N'E:\EncryptionKey\ALLIED_PIMSDB_master_TDE_Certificate.cer'
  WITH PRIVATE KEY (
    FILE = N'E:\EncryptionKey\ALLIED_PIMSDB_master_TDE_Certificate.pvk',
  DECRYPTION BY PASSWORD = 'BACKUP CERTIFICATE PIMS (Test & Prod)'
  );
GO