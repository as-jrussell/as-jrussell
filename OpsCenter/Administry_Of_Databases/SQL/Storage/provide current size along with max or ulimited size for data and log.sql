if object_id('tempdb..#dbsize') is not null
drop table #dbsize;
GO
create table #dbsize (database_name sysname, 
currrent_size int, 
max_size int, 
is_unlimited int, 
current_log_size int, 
max_log_size int, 
is_log_unlimited int);

exec sp_msforeachdb '
insert #dbsize
select ''?'',
    sum(case when filename like ''%.ldf'' then 0 else size end),
    sum(case when filename like ''%.ldf'' then 0 else maxsize end),
    min(case when filename like ''%.ldf'' then 0 else maxsize end),
    sum(case when filename like ''%.ldf'' then size else 0 end),
    sum(case when filename like ''%.ldf'' then maxsize else 0 end),
    min(case when filename like ''%.ldf'' then maxsize else 0 end)
from [?].sys.sysfiles';

select database_name as DatabaseName, 
currrent_size / 128.0 as CurrentDBSize,
    case when is_unlimited = -1 then 'unlimited' else str(max_size/128.0) end as MaxDBSize, 
current_log_size/128.0 as CurrentLogSize,
    case when is_log_unlimited = -1 then 'unlimited' else str(max_log_size/128.0) end as MaxLogSize
from #dbsize
order by current_log_size desc ;
GO
if object_id('tempdb..#dbsize') is not null
drop table #dbsize;
GO

