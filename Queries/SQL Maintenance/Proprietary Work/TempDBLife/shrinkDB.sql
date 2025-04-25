USE [DBA]
GO
/****** Object:  StoredProcedure [dbo].[shrinkTempDB]    Script Date: 4/24/2025 12:29:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[shrinkTempDB] 
(@maxRunTime int = 120)
-- will finish file it's on if the time expires, but does keep it from running endlessly.
AS
set nocount on
-- DECLARE @maxRunTime int = 120
declare @files as table (name varchar(50), newsize bigint, size bigint ,usedSpace bigint, fileType varchar(4))
declare @name varchar(50), @newSize bigint, @usedSpace bigint, @size bigint, @fileType varchar(4)
declare @sql as varchar(7999)
declare @minDataSize int, @minLogSize int
declare @minTempDBData int, @minTempDBLog int  ---Open to change to something better named 
declare @endTime datetime

create table #space (
fileGroupName sysname,
freeSpaceMB FLOAT,
totalSpaceMB FLOAT,
usedSpacePct FLOAT,
usedSpaceLimitPct FLOAT)

-- BML 11/20/14 add check if log or data > 50% full, skip shrinks
select @sql = 'use tempdb
INSERT #space (fileGroupName, freeSpaceMB, usedSpacePct, totalSpaceMB,usedSpaceLimitPct)
select isnull(fg.name,''LOG''), 
		SUM(f.size/128 - CONVERT(bigint, FILEPROPERTY(f.name, ''SpaceUsed''))/128) freeSpaceMB,
		SUM(cast(FILEPROPERTY(f.name, ''SpaceUsed'') as bigint)) / SUM(1.0 * CASE WHEN f.size > 0 THEN f.size ELSE 1 END)*100.0 usedSpacePct,
		SUM(1.0 * f.size/128) totalSpaceMB,
	50
      FROM sys.database_files f 
		LEFT JOIN sys.filegroups fg 
			ON f.data_space_id = fg.data_space_id
           GROUP BY fg.NAME'

exec (@sql)
IF  EXISTS(SELECT * FROM #space 
		WHERE usedSpacePct > usedSpaceLimitPct)
		begin
			Print 'Cannot shrink, filegroups > 50% full'
			return
		end

select @endTime = dateadd(mi,@maxRunTime,getdate())
print @endTime
-- to set override parameters, use this
-- utility.dbo.setConfig 'TempDBDataSizeMB', '8192'
-- utility.dbo.setDatabaseConfig 'TempDB','maxLogSizeMB', '131072'
       
-- get the instance specific parameters, or use the defaults if none are specified


select @minTempDBData = ISNULL(confvalue, 8192)
FROM DBA.INFO.databaseConfig
WHERE databaseName = 'TEMPDB' AND confkey = 'MaxDataSizeMB'

select @minTempDBLog =  ISNULL(confvalue, 10240)
FROM DBA.INFO.databaseConfig
WHERE databaseName = 'TEMPDB' AND confkey = 'MaxLogSizeMB'

select @minDataSize = DBA.info.getSystemConfig('TempDBDataSizeMB',''+@minTempDBData +''),
       @minLogSize =  DBA.info.getDatabaseConfig ('TempDB', 'maxLogSizeMB',''+ @minTempDBLog+'')


-- get the data files exceeding the max size
select @sql = 'use tempdb
select s.name, '+cast(@minDataSize as varchar(50)) + ', 
size/128, fileproperty(s.name,''spaceUsed'')/128, ''Data''
	 from tempdb.dbo.sysfiles s
where size/128 > '+cast(@minDataSize as varchar(50)) + '
and groupid = 1' -- NOT log files

--print @sql
insert @files
exec (@sql)

/* -- we'll shrink tempdb log at the end by calling the shrinklog sproc
--get the log files exceeding the max size
select @sql = 'use tempdb
select s.name, '+cast(@minLogSize as varchar(50)) + ', 
size/128,fileproperty(s.name,''spaceUsed'')/128, ''Log''
	 from tempdb.dbo.sysfiles s
where size/128 > '+cast(@minLogSize as varchar(50)) + '
and groupid = 0' -- Log files

--print @sql
insert @files
exec (@sql)
*/

-- now shrink them, but not smaller than the space used within the file
while exists (select * from @files) and getdate()<@endTime
begin
	select top 1 @name = name, @newSize = newSize, @size=size, @usedSpace = usedSpace, @filetype = fileType
		 from @files order by size desc, name
	print '-------------------------------'
	if @usedSpace > @newSize
		select @newSize = @usedSpace
	if @size - 1024 > @newsize
		select @newSize = @size - 1024
	print @name + '     SHRINKING ' + cast(@size as varchar(50))+' --- > '+cast(@newSize as varchar(50)) + '  (used '+ cast(@usedSpace as varchar(50))+')'
	select @sql = 'use tempdb
	dbcc shrinkfile ('''+@name+''', '+cast(@newSize as varchar(50))
/*	if @filetype = 'Data'
		select @sql = @sql +',TRUNCATEONLY)'-- this actually ignores the size and removes all empty space at the end of the file
	else
*/ -- this was causing blocking, better to shrink it in small increments
		select @sql = @sql + ') with no_infomsgs'
		
	print @sql
	begin try
	exec (@sql)
	end try
	begin catch
		print error_message()
	end catch
	delete from @files where name = @name
end
-- the truncateonly could have shrank the db files too small, and lets make sure the data files meet the min size
delete from @files

-- get the data files smaller than the max size
select @sql = 'use tempdb
select s.name, '+cast(@minDataSize as varchar(50)) + ', 
size/128, fileproperty(s.name,''spaceUsed'')/128, ''Data''
	 from tempdb.dbo.sysfiles s
where (size/128) + 10 < '+cast(@minDataSize as varchar(50)) + '
and groupid = 1' -- NOT log files


--print @sql
insert @files
exec (@sql)

while exists (select * from @files) and getdate()<@endTime
begin
	select top 1 @name = name, @newSize = newSize, @size=size, @usedSpace = usedSpace, @filetype = fileType
		 from @files order by size, name
	print '-------------------------------'
	print @name + '     GROWING ' + cast(@size as varchar(50))+' --- > '+cast(@newSize as varchar(50)) + '  (used '+ cast(@usedSpace as varchar(50))+')'
	select @sql = 'use tempdb
	alter database tempdb MODIFY FILE (NAME = '''+@name+''', SIZE = '+cast(@newSize as varchar(50)) + 'MB)'
	print @sql
	begin try
	exec (@sql)
	end try
	begin catch
		print error_message()
	end catch
	delete from @files where name = @name
end

-- shrink the log
-------------------exec utility.dba.shrinkLogs @oneDB = 'tempdb'
