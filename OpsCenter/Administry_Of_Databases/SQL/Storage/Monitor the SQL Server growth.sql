use master
GO

/*

http://theadeptdba.blogspot.com/2013/01/how-fast-is-my-sql-server-database.html 

https://docs.microsoft.com/en-us/previous-versions/sql/sql-server-2008-r2/ms188233(v=sql.105)?redirectedfrom=MSDN

Results in GB

*/


DECLARE @dbname as sysname
DECLARE @select_string as varchar(4000)
DECLARE @for_string as varchar(4000)
DECLARE @body as varchar(4000)
DECLARE @suffix as varchar(4000)
DECLARE @init as bit
DECLARE @type as varchar(3) = 'D' --D - Database Full, I - Incremental, L - Log
DECLARE @DryRun INT = 0 


DECLARE curs CURSOR FOR
SELECT name FROM sysdatabases

OPEN CURS

FETCH NEXT FROM curs INTO @dbname

SELECT      @select_string = 'SELECT DISTINCT backup_date',
      @for_string = 'FOR database_name IN (',
      @init = 0

WHILE @@FETCH_STATUS = 0
BEGIN
      IF @init = 0
      BEGIN
            SET @init = 1

            SELECT      @select_string = @select_string + ', [' + @dbname + '] as ' + '"' + @dbname +'"',
            @for_string = @for_string +  @dbname
      END
      ELSE
      BEGIN
            SELECT      @select_string = @select_string + ', [' + @dbname + '] as ' + '"' + @dbname +'"',
                  @for_string = @for_string + ', ' + @dbname
      END
      FETCH NEXT FROM curs INTO @dbname
END

CLOSE curs
DEALLOCATE curs


set @body =  'from
      (select isnull(backup_size / (1024 * 1024 * 1024), 0) as backup_size,
      database_name,
      cast(cast(backup_finish_date as varchar(12)) as datetime) as backup_date
      from msdb.dbo.backupset
      where USER_NAME != ''NT AUTHORITY\SYSTEM''
	  AND type = '''+@TYPE+''') p
pivot
      (
      sum(backup_size)'
 
set @suffix = ')) as pvt 
order by backup_date'





IF @DryRun = 0
	BEGIN 
		EXEC (@select_string + @body + @for_string + @suffix)
	END
ELSE
	BEGIN 
		PRINT (@select_string + @body + @for_string + @suffix)
	END







