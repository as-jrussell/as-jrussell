USE Unitrac 
GO

BEGIN TRAN;

/* Declare variables */
DECLARE @Ticket NVARCHAR(15) =N'AIH_6666';
DECLARE @SourceDatabase NVARCHAR(100) = 'Unitrac' /* This will be the schema in HDTStorage */;
DECLARE @RowsToChange INT;

/* Step 1 - Calculate rows to be changed - same query as populate Storage table */
SELECT @RowsToChange = Count(ID)
FROM   PROCESS_DEFINITION
WHERE  ID IN ( 39 );

/* Existence check for Storage tables - Exit if they exist */
IF NOT EXISTS (SELECT *
               FROM   HDTStorage.sys.tables
               WHERE  Schema_name(SCHEMA_ID) = @SourceDatabase
                      AND NAME LIKE @Ticket + '_%'
                      AND TYPE IN ( N'U' ))
  BEGIN
      /* populate new Storage table from Sources */
      EXEC('SELECT * into HDTStorage.'+@SourceDatabase+'.'+@Ticket+'_PROCESS_DEFINITION
  		from PROCESS_DEFINITION  
where ID IN (39)')

      /* Does Storage Table meet expectations */
      IF( @@ROWCOUNT = @RowsToChange )
        BEGIN
            PRINT 'Storage table meets expections - continue'

            /* Step 3 - Perform table update */
            UPDATE PROCESS_DEFINITION
            SET    SETTINGS_XML_IM.modify('insert <LenderID>4359</LenderID> into (/ProcessDefinitionSettings/InsuranceDocTypeSettings/LenderList)[1]')
            WHERE  ID = 39

            /* Step 4 - Inspect results - Commit/Rollback */
            IF ( @@ROWCOUNT = @RowsToChange )
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
SET @Ticket =N'AIH_6666_2';

/* Step 1 - Calculate rows to be changed - same query as populate Storage table */
SELECT @RowsToChange = Count(ID)
FROM   PROCESS_DEFINITION
WHERE  ID IN ( 39 );

/* Existence check for Storage tables - Exit if they exist */
IF NOT EXISTS (SELECT *
               FROM   HDTStorage.sys.tables
               WHERE  Schema_name(SCHEMA_ID) = @SourceDatabase
                      AND NAME LIKE @Ticket +  '_%'
                      AND TYPE IN ( N'U' ))
  BEGIN
      /* populate new Storage table from Sources */
      EXEC('SELECT * into HDTStorage.'+@SourceDatabase+'.'+@Ticket+'_PROCESS_DEFINITION
  		  		from PROCESS_DEFINITION  
where ID IN (39)')

      /* Does Storage Table meet expectations */
      IF( @@ROWCOUNT = @RowsToChange )
        BEGIN
            PRINT 'Storage table meets expections - continue'

            /* Step 3 - Perform table update */
            UPDATE PROCESS_DEFINITION
            SET    SETTINGS_XML_IM.modify('insert <LenderID>4359</LenderID> into (/ProcessDefinitionSettings/InsuranceDocTypeSettings/LenderList)[2]')
            WHERE  ID = 39

            /* Step 4 - Inspect results - Commit/Rollback */
            IF ( @@ROWCOUNT = @RowsToChange )
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
SET @Ticket =N'AIH_6666_3';

/* Step 1 - Calculate rows to be changed - same query as populate Storage table */
SELECT @RowsToChange = Count(ID)
FROM   PROCESS_DEFINITION
WHERE  ID IN ( 336 );

/* Existence check for Storage tables - Exit if they exist */
IF NOT EXISTS (SELECT *
               FROM   HDTStorage.sys.tables
               WHERE  Schema_name(SCHEMA_ID) = @SourceDatabase
                      AND NAME LIKE @Ticket + '_%'
                      AND TYPE IN ( N'U' ))
  BEGIN
      /* populate new Storage table from Sources */
      EXEC('SELECT * into HDTStorage.'+@SourceDatabase+'.'+@Ticket+'_PROCESS_DEFINITION
  		from PROCESS_DEFINITION  
where ID IN (336)')

      /* Does Storage Table meet expectations */
      IF( @@ROWCOUNT = @RowsToChange )
        BEGIN
            PRINT 'Storage table meets expections - continue'

            /* Step 3 - Perform table update */
            UPDATE PROCESS_DEFINITION
            SET    SETTINGS_XML_IM.modify('insert <LenderID>4359</LenderID> into (/ProcessDefinitionSettings/LenderList)[1]')
            WHERE  ID = 336

            /* Step 4 - Inspect results - Commit/Rollback */
            IF ( @@ROWCOUNT = @RowsToChange )
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
SET @Ticket =N'AIH_6666_4';

/* Step 1 - Calculate rows to be changed - same query as populate Storage table */
SELECT @RowsToChange = Count(ID)
FROM   PROCESS_DEFINITION
WHERE  ID IN ( 199525 );

/* Existence check for Storage tables - Exit if they exist */
IF NOT EXISTS (SELECT *
               FROM   HDTStorage.sys.tables
               WHERE  Schema_name(SCHEMA_ID) = @SourceDatabase
                      AND NAME LIKE @Ticket + '_%'
                      AND TYPE IN ( N'U' ))
  BEGIN
      /* populate new Storage table from Sources */
      EXEC('SELECT * into HDTStorage.'+@SourceDatabase+'.'+@Ticket+'_PROCESS_DEFINITION
  		from PROCESS_DEFINITION  
where ID IN (199525)')

      /* Does Storage Table meet expectations */
      IF( @@ROWCOUNT = @RowsToChange )
        BEGIN
            PRINT 'Storage table meets expections - continue'

            /* Step 3 - Perform table update */
            UPDATE PROCESS_DEFINITION
            SET    SETTINGS_XML_IM.modify('insert <LenderID>4359</LenderID> into (/ProcessDefinitionSettings/LenderList)[1]')
            WHERE  ID = 199525

            /* Step 4 - Inspect results - Commit/Rollback */
            IF ( @@ROWCOUNT = @RowsToChange )
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
SET @Ticket =N'AIH_6666_5';

/* Step 1 - Calculate rows to be changed - same query as populate Storage table */
SELECT @RowsToChange = Count(ID)
FROM   PROCESS_DEFINITION
WHERE  ID IN ( 1177069 );

/* Existence check for Storage tables - Exit if they exist */
IF NOT EXISTS (SELECT *
               FROM   HDTStorage.sys.tables
               WHERE  Schema_name(SCHEMA_ID) = @SourceDatabase
                      AND NAME LIKE @Ticket + '_%'
                      AND TYPE IN ( N'U' ))
  BEGIN
      /* populate new Storage table from Sources */
      EXEC('SELECT * into HDTStorage.'+@SourceDatabase+'.'+@Ticket+'_PROCESS_DEFINITION
  		from PROCESS_DEFINITION  
where ID IN (1177069)')

      /* Does Storage Table meet expectations */
      IF( @@ROWCOUNT = @RowsToChange )
        BEGIN
            PRINT 'Storage table meets expections - continue'

            /* Step 3 - Perform table update */
            UPDATE PROCESS_DEFINITION
            SET    SETTINGS_XML_IM.modify('insert <LenderID>4359</LenderID> into (/ProcessDefinitionSettings/LenderList)[1]')
            WHERE  ID = 1177069

            /* Step 4 - Inspect results - Commit/Rollback */
            IF ( @@ROWCOUNT = @RowsToChange )
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



