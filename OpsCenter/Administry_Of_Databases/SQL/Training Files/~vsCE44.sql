CREATE ROLE CreateObjects
GRANT CREATE TABLE TO CreateObjects
GRANT CREATE VIEW TO CreateObjects
GRANT CREATE FUNCTION TO CreateObjects
GRANT CREATE PROCEDURE TO CreateObjects
GRANT ALTER ANY SCHEMA TO CreateObjects

use master
SELECT * FROM sys.database_principals

use testdb 
SELECT * FROM sys.database_principals