--Add users

USE [Bond_Main]
GO
CREATE USER [CP-SQL-DEV] FOR LOGIN [CP-SQL-DEV]
GO
USE [Bond_Main]
GO
ALTER ROLE [db_datareader] ADD MEMBER [CP-SQL-DEV]
GO
USE [Bond_Main]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [CP-SQL-DEV]
GO



---Remove User

USE [Bond_Main]
GO
ALTER ROLE [db_datawriter] DROP MEMBER [CP-SQL-DEV]
GO

USE [Bond_Main]
GO
ALTER ROLE [db_datareader] DROP MEMBER [CP-SQL-DEV]
GO

USE [Bond_Main]
GO
DROP USER [CP-SQL-DEV]
GO
