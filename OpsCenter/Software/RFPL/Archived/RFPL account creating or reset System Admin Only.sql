EXEC [DBA].[rfpl].[CreateRFPLSQLUser] @FirstName = 'Logan', @LastName = 'Benefiel', @DryRun = 0,  @AccountType = 'sa'

select CONCAT('


USE [', name, ']
CREATE USER [PassSQL@alliedsolutions.onmicrosoft.com] FOR LOGIN [PassSQL@alliedsolutions.onmicrosoft.com];

USE [',name,']
ALTER ROLE [db_datareader] ADD MEMBER [PassSQL@alliedsolutions.onmicrosoft.com];

USE [',name,']
ALTER ROLE [db_datawriter] ADD MEMBER [PassSQL@alliedsolutions.onmicrosoft.com];')
--select *
from sys.databases 
where (database_id >=5 AND  name != 'DBA') 


select CONCAT('USE [', name, '] ALTER ROLE [db_owner] ADD MEMBER []')
--select *
from sys.databases 
where (database_id >=5 AND  name not in ('Perfstats','HDTStorage', 'DBA')





select CONCAT('


USE [', name, ']
CREATE USER [PassSQL@alliedsolutions.onmicrosoft.com] FOR LOGIN [PassSQL@alliedsolutions.onmicrosoft.com];

USE [',name,']
ALTER ROLE [db_datareader] ADD MEMBER [PassSQL@alliedsolutions.onmicrosoft.com];

USE [',name,']
ALTER ROLE [db_datawriter] ADD MEMBER [PassSQL@alliedsolutions.onmicrosoft.com];')
--select *
from sys.databases 
where (database_id >=5 AND  name != 'DBA') 
and create_date >= '2021-08-20'
