

select CONCAT('ALTER DATABASE [', name, '] SET  READ_ONLY WITH NO_WAIT')
--select *
from sys.databases 
where (database_id >=5 AND  name not in ('Perfstats','HDTStorage', 'DBA'))



