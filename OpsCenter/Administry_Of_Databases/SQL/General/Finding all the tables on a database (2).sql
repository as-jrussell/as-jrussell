use unitrachdstorage

SELECT name, create_date,max_column_id_used FROM Sys.Tables
where name like '%'
ORDER BY create_date DESC 


use unitrachdstorage
select
concat('DROP TABLE',' ','UnitracHDStorage..',name), create_date
FROM SYS.TABLES 
where name like '%CSH2845%'
ORDER BY create_date DESC 

DROP TABLE UnitracHDStorage..INC0574772_COLLATERAL_1
DROP TABLE UnitracHDStorage..INC0574772_OWNER_ADDRESS
DROP TABLE UnitracHDStorage..INC0574772_SEARCH_FULLTEXT_2a2
DROP TABLE UnitracHDStorage..INC0574772_COLLATERAL_2a
DROP TABLE UnitracHDStorage..INC0574772_SEARCH_FULLTEXT_2b
DROP TABLE UnitracHDStorage..INC0574772_COLLATERAL_2b