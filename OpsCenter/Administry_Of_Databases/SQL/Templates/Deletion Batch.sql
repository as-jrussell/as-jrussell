

-- Declare variables for database and table
DECLARE @DatabaseName SYSNAME = '';
DECLARE @TableName NVARCHAR(128) = ''; --schema.tablename
DECLARE @BatchSize INT = 10;
DECLARE @RowsAffected INT;
DECLARE @SQL NVARCHAR(MAX);
DECLARE @DryRun INT = 0 --1 preview / 0 executes it 
-- Check if the database exists
IF Db_id(@DatabaseName) IS NULL
  BEGIN
      PRINT 'Database does not exist.';

      RETURN;
  END

-- Switch to the specified database
EXEC ('USE [' + @DatabaseName +']');

-- Check if the table exists in the database
IF Object_id(@TableName, 'U') IS NULL
  BEGIN
      PRINT 'Table does not exist.';

      RETURN;
  END

SELECT @SQL = CASE
                WHEN @DryRun = 1 THEN 'DELETE TOP '
                                      + Cast(@BatchSize AS NVARCHAR (100))
                                      + ' FROM ' +@TableName
                ELSE 'DELETE TOP (@BatchSize) FROM '
                     + @TableName
              END

-- lets add some clauses here
-- +' where ';
IF @DryRun = 0
  BEGIN
      -- Loop to delete rows in batches
      WHILE 1 = 1
        BEGIN
            -- Create the delete statement
            -- Execute the delete statement
            EXEC Sp_executesql
              @SQL,
              N'@BatchSize INT',
              @BatchSize;

            -- Get the number of rows affected
            SET @RowsAffected = @@ROWCOUNT;

            -- Exit the loop if no rows were deleted
            IF @RowsAffected = 0
              BREAK;
        END
  -- You know what we do here if it's 1 then it'll give us code and 0 executes it
  END
ELSE
  BEGIN
      PRINT ( @SQL )
  END 
