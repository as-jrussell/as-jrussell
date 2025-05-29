USE [master]
GO

GRANT VIEW SERVER STATE TO  [QCdbIISQCModuleProd];

GRANT VIEW SERVER STATE TO  [UTdbQCMBS-Prod];



----Password Change 






use QCModule

ALTER ROLE [db_owner] ADD MEMBER [QCdbIISQCModuleProd]


