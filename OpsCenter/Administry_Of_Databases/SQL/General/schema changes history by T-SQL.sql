declare @d1 datetime;
declare @diff int;
declare @curr_tracefilename varchar(500);
declare @base_tracefilename varchar(500);
declare @indx int ;
declare @temp_trace table (
 obj_name nvarchar(256) collate database_default
, database_name nvarchar(256) collate database_default
, start_time datetime
, event_class int
, event_subclass int
, object_type int
, server_name nvarchar(256) collate database_default
, login_name nvarchar(256) collate database_default
, application_name nvarchar(256) collate database_default
, ddl_operation nvarchar(40) collate database_default
);

select @curr_tracefilename = path from sys.traces where is_default = 1 ;
set @curr_tracefilename = reverse(@curr_tracefilename)
select @indx = PATINDEX('%\%', @curr_tracefilename)
set @curr_tracefilename = reverse(@curr_tracefilename)
set @base_tracefilename = LEFT(@curr_tracefilename,len(@curr_tracefilename) - @indx) + '\log.trc';

insert into @temp_trace
select ObjectName
, DatabaseName
, StartTime
, EventClass
, EventSubClass
, ObjectType
, ServerName
, LoginName
, ApplicationName
, 'temp'
from ::fn_trace_gettable( @base_tracefilename, default )
where EventClass in (46,47,164) and EventSubclass = 0 and
DatabaseID <> 2

update @temp_trace set ddl_operation = 'CREATE' where
event_class = 46
update @temp_trace set ddl_operation = 'DROP' where
event_class = 47
update @temp_trace set ddl_operation = 'ALTER' where
event_class = 164

select @d1 = min(start_time) from @temp_trace
set @diff= datediff(hh,@d1,getdate())
set @diff=@diff/24;

select @diff as difference
, @d1 as date
, object_type as obj_type_desc
, *
from @temp_trace where object_type not in (21587)
--AND database_name = 'UniTracArchive'
order by database_name desc