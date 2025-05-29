use master
GO

/*

http://theadeptdba.blogspot.com/2013/01/how-fast-is-my-sql-server-database.html 

https://docs.microsoft.com/en-us/previous-versions/sql/sql-server-2008-r2/ms188233(v=sql.105)?redirectedfrom=MSDN


*/


DECLARE @dbname as sysname
DECLARE @select_string as varchar(4000)
DECLARE @for_string as varchar(4000)
DECLARE @init as bit

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

PRINT @select_string
PRINT 'SET RECOVERY FULL WITH NO_WAIT'


