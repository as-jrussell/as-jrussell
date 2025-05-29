USE [Pingfederate]

GO

BEGIN TRAN;

/* Declare variables */
DECLARE @Ticket NVARCHAR(15) =N'AIH_16206'; --Ticket Number 
DECLARE @SourceDatabase NVARCHAR(100) = 'Pingfederate' /* This will be the schema in HDTStorage */;
DECLARE @channelid NVARCHAR(3) = '19' --Channel Id Provided by User
DECLARE @saasGroupName NVARCHAR(100) = 'aws - billing administrators' --Channel Id Provided by User
DECLARE @RowsToDelete INT;

/* Step 1 - Calculate rows to be changed */
SELECT @RowsToDelete = Count(*)
--select *
FROM   [Pingfederate].[dbo].[channel_group]
WHERE  channel = @channelid
       AND saasGroupName = @saasGroupName



/* Existence check for Storage tables - Exit if they exist */
IF NOT EXISTS (SELECT *
               FROM   HDTStorage.sys.tables
               WHERE  Schema_name(SCHEMA_ID) = @SourceDatabase
                      AND NAME LIKE @Ticket + '_%'
                      AND TYPE IN ( N'U' ))
  BEGIN
      /* populate new Storage table from Sources */
      EXEC('SELECT * INTO HDTStorage.'+@SourceDatabase+'.'+@Ticket+'_channel_group
			FROM   [Pingfederate].[dbo].[channel_group]
			WHERE  channel = '''+@channelid+''' AND 
			saasGroupName = '''+@saasGroupName+'''')

      /* Does Storage Table meet expectations */
      IF( @@ROWCOUNT = @RowsToDelete )
        BEGIN
            PRINT 'Storage TABLE meets expections - continue'

            /* Step 3 - Perform table update */
            DELETE u
            --SELECT *
            FROM   [Pingfederate].[dbo].[channel_group] u
            WHERE  channel = @channelid
                   AND saasGroupName = @saasGroupName;

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

BEGIN TRAN;
/* Declare variables */
DECLARE @saasUsername NVARCHAR(100) = 'Noah.Foster@alliedsolutions.net' --Channel Id Provided by User
/* Step 1 - Calculate rows to be changed */
SELECT @RowsToDelete = Count(*)
FROM   [Pingfederate].[dbo].[channel_user] u
WHERE  channel = @channelid
       AND saasUsername = @saasUsername

/* Existence check for Storage tables - Exit if they exist */
IF NOT EXISTS (SELECT *
               FROM   HDTStorage.sys.tables
               WHERE  Schema_name(SCHEMA_ID) = @SourceDatabase
                      AND NAME LIKE @Ticket + '__channel_user%'
                      AND TYPE IN ( N'U' ))
  BEGIN
      /* populate new Storage table from Sources */
      EXEC('SELECT * INTO HDTStorage.'+@SourceDatabase+'.'+@Ticket+'_channel_user
			FROM   [Pingfederate].[dbo].[channel_user]
			WHERE  channel = '''+@channelid+''' AND 
			saasUsername = '''+@saasUsername+'''')

      /* Does Storage Table meet expectations */
      IF( @@ROWCOUNT = @RowsToDelete )
        BEGIN
            PRINT 'Storage TABLE meets expections - continue'

            /* Step 3 - Perform table update */
            DELETE u
            --SELECT *
            FROM   [Pingfederate].[dbo].[channel_user] u
            WHERE  channel = @channelid
                   AND saasUsername = @saasUsername;

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
