use HDTStorage

select CONCAT('SELECT * FROM HDTSTORAGE.dbo.[',name,']') 
--select *
from sys.tables 
where create_date >= '2022-01-10'



select CONCAT('drop table HDTSTORAGE.dbo.[',name,']') 
--select *
from sys.tables 
where create_date >= '2022-01-10'

SELECT * FROM HDTSTORAGE.dbo.[UTDB Updates P3]



