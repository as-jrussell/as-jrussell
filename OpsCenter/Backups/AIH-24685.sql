
IF EXISTS (select 1 from sys.databases where name = 'PRL_APLUS_661_PROD_OLD') 
BEGIN
ALTER DATABASE [PRL_APLUS_661_PROD_OLD] SET  OFFLINE
PRINT 'SUCCESS: PRL_APLUS_661_PROD_OLD Database is offline'
END
ELSE
BEGIN 


PRINT 'FAIL: Contact a DBA'

END 








------- After 7 days 

IF EXISTS (select 1 from sys.databases where name = 'PRL_APLUS_661_PROD_OLD') 
BEGIN
DROP DATABASE [PRL_APLUS_661_PROD_OLD]
PRINT 'SUCCESS: PRL_APLUS_661_PROD_OLD Database has been dropped'
END
ELSE
BEGIN 


PRINT 'FAIL: Contact a DBA'

END 

