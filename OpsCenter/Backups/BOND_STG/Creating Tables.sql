USE ROLE SYSADMIN; 

SELECT '
DECLARE TABLE_NAME varchar default (select count(*) FROM SNOWFLAKE.ACCOUNT_USAGE.tables where TABLE_NAME=  '''|| Table_Name ||'''
AND table_catalog = ''BOND_STAGE'' AND TABLE_TYPE = ''BASE TABLE'' AND DELETED IS NULL) ;
BEGIN 
IF (TABLE_NAME = 0)
THEN 
BEGIN
CREATE TABLE  BOND_STAGE'|| '.' || Table_Schema || '.' || Table_Name || ' CLONE '  || Table_Catalog || '.' || Table_Schema || '.' || Table_Name ||';
RETURN ''SUCCESS: Table created'';
END ;
ELSEIF (TABLE_NAME <> 0)
THEN 
BEGIN 
RETURN ''WARNING: Table exists'';
END;
END IF;
END;

GRANT OWNERSHIP ON TABLE  BOND_STAGE'|| '.' || Table_Schema || '.' || Table_Name || ' TO ROLE "OWNER_BOND_STAGE" REVOKE CURRENT GRANTS;

GRANT SELECT ON TABLE  BOND_STAGE'|| '.' || Table_Schema || '.' || Table_Name || ' TO ROLE READ_BOND_STAGE;

GRANT SELECT ON TABLE  BOND_STAGE'|| '.' || Table_Schema || '.' || Table_Name || ' TO ROLE READWRITE_BOND_STAGE;

GRANT UPDATE ON TABLE  BOND_STAGE'|| '.' || Table_Schema || '.' || Table_Name || ' TO ROLE READWRITE_BOND_STAGE;

GRANT INSERT ON TABLE  BOND_STAGE'|| '.' || Table_Schema || '.' || Table_Name || ' TO ROLE READWRITE_BOND_STAGE;

GRANT DELETE ON TABLE  BOND_STAGE'|| '.' || Table_Schema || '.' || Table_Name || ' TO ROLE READWRITE_BOND_STAGE;


'
FROM SNOWFLAKE.ACCOUNT_USAGE.tables where
 table_catalog = 'BOND_PROD' AND TABLE_TYPE = 'BASE TABLE' AND DELETED IS NULL