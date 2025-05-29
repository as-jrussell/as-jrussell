

USE [master]
GO
SELECT * FROM sys.certificates


SELECT * FROM sys.symmetric_keys WHERE symmetric_key_id = 101




CREATE MASTER KEY
  ENCRYPTION BY PASSWORD = '';
GO




CREATE CERTIFICATE TDE_Certificate  
  FROM FILE = N'*.cer'
  WITH PRIVATE KEY (
    FILE = N'*.pvk',
  DECRYPTION BY PASSWORD = ''
  );
GO