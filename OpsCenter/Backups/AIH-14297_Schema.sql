USE [AppLog]

GO

IF NOT EXISTS (SELECT *
               FROM   sys.schemas
               WHERE  name = N'archive')
  EXEC sys.Sp_executesql
    N'CREATE SCHEMA [archive]'

GO
