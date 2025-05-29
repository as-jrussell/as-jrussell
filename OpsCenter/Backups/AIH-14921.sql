USE [Pingfederate]

GO

BEGIN TRAN;

/* Declare variables */
DECLARE @Ticket NVARCHAR(15) =N'AIH-14921';
DECLARE @SourceDatabase NVARCHAR(100) = 'Pingfederate' /* This will be the schema in HDTStorage */;
DECLARE @RowsToDelete INT;

/* Step 1 - Calculate rows to be changed */
SELECT @RowsToDelete = Count(*)
FROM   [Pingfederate].[dbo].[channel_user] u
WHERE  u.channel = '7'

/* Existence check for Storage tables - Exit if they exist */
IF NOT EXISTS (SELECT *
               FROM   HDTStorage.sys.tables
               WHERE  Schema_name(SCHEMA_ID) = @SourceDatabase
                      AND NAME LIKE @Ticket + '_%'
                      AND TYPE IN ( N'U' ))
  BEGIN
      /* populate new Storage table from Sources */
      print('SELECT * INTO HDTStorage.'+@SourceDatabase+'.'+@Ticket+'_channel_user
			FROM [Pingfederate].[dbo].[channel_user] u 
			WHERE  u.channel = ''7''')

      /* Does Storage Table meet expectations */
      IF( @@ROWCOUNT = @RowsToDelete )
        BEGIN
            PRINT 'Storage TABLE meets expections - continue'

            /* Step 3 - Perform table update */
            DELETE u
            --SELECT *
            FROM   [Pingfederate].[dbo].[channel_user] u
            WHERE  u.channel = '7';

            /* Step 4 - Inspect results - Commit/Rollback */
            IF ( @@ROWCOUNT = @RowsToDelete )
              BEGIN
                  PRINT 'SUCCESS - Performing Commit'

                  COMMIT;
              END
            ELSE
              BEGIN
                  PRINT 'FAILED TO UPDATE - Performing Rollback'

                  ROLLBACK;
              END
        END
      ELSE
        BEGIN
            PRINT 'Storage does not meet expectations - rollback'

            ROLLBACK;
        END
  END
ELSE
  BEGIN
      PRINT 'HD TABLE EXISTS - Stop work'

      COMMIT;
  END 
