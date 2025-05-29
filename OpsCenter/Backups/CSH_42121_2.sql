USE [InforCRM]
GO

BEGIN TRAN
/* Declare variables */
DECLARE @RowsToChange INT;
DECLARE @AREA as varchar(200)= 'Subscription Protection Products'
DECLARE @Ticket NVARCHAR(15) =N'CSH_42121_2';
DECLARE @DryRun NVARCHAR(1) = 1

IF @DryRun = 0

BEGIN
/* Step 1 - Calculate rows to be changed - same query as populate Storage table */
SELECT @RowsToChange = count(*)
FROM sysdba.AREACATEGORYISSUE
WHERE ISNUMERIC(Substring(AREACATEGORYISSUE.ISSUE,CHARINDEX('(',AREACATEGORYISSUE.ISSUE,1)+1,(CHARINDEX(')',AREACATEGORYISSUE.ISSUE,1) -(CHARINDEX('(',AREACATEGORYISSUE.ISSUE,1)+1)))) <> '0'
AND AREA = @AREA ;


/* Existence check for Storage tables - Exit if they exist */
IF NOT EXISTS (SELECT *
               FROM HDTStorage.sys.tables  -- Someday this will be the standard 
               WHERE name like  @Ticket+'_%' AND type IN (N'U') )
	BEGIN

    	/* populate new Storage table from Sources */
    	EXEC ('SELECT * into HDTStorage.InforCRM.'+@Ticket+'_AREACATEGORYISSUE
  		FROM sysdba.AREACATEGORYISSUE
		WHERE ISNUMERIC(Substring(AREACATEGORYISSUE.ISSUE,CHARINDEX(''('',AREACATEGORYISSUE.ISSUE,1)+1,(CHARINDEX('')'',AREACATEGORYISSUE.ISSUE,1) -(CHARINDEX(''('',AREACATEGORYISSUE.ISSUE,1)+1)))) <> ''0''
		AND AREA ='''+ @AREA + '''')
 
    	/* Does Storage Table meet expectations */
	IF( @@RowCount = @RowsToChange )
		BEGIN
			PRINT 'Storage table meets expections - continue'

			/* Step 3 - Perform table update */
			;WITH New_Service_Level as (
				Select 
				AREACATEGORYISSUEID,
				ISSUE,
				ISNUMERIC(Substring(ISSUE,CHARINDEX('(',ISSUE,1)+1,(CHARINDEX(')',ISSUE,1) -(CHARINDEX('(',ISSUE,1)+1)))) as gg2,
				CASE WHEN ISNUMERIC(Substring(ISSUE,CHARINDEX('(',ISSUE,1)+1,(CHARINDEX(')',ISSUE,1) -(CHARINDEX('(',ISSUE,1)+1)))) = 1
					THEN CAST(Substring(ISSUE,CHARINDEX('(',ISSUE,1)+1,(CHARINDEX(')',ISSUE,1) -(CHARINDEX('(',ISSUE,1)+1))) as int)
					ELSE NULL END as NewValue
					--select *
				from sysdba.AREACATEGORYISSUE
				where AREA = @AREA --and issue like '%(%)'
				)

				Update sysdba.AREACATEGORYISSUE
				Set Service_Level_Expectation = NewValue
				FROM sysdba.AREACATEGORYISSUE 
				LEFT OUTER JOIN New_Service_Level on New_Service_Level.AREACATEGORYISSUEID = sysdba.AREACATEGORYISSUE.AREACATEGORYISSUEID
				where AREA = @AREA	
				and ISNUMERIC(Substring(AREACATEGORYISSUE.ISSUE,CHARINDEX('(',AREACATEGORYISSUE.ISSUE,1)+1,(CHARINDEX(')',AREACATEGORYISSUE.ISSUE,1) -(CHARINDEX('(',AREACATEGORYISSUE.ISSUE,1)+1)))) <> '0'

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
END 

ELSE 

BEGIN 


WITH New_Service_Level as (
Select 
AREACATEGORYISSUEID,
ISSUE,
ISNUMERIC(Substring(ISSUE,CHARINDEX('(',ISSUE,1)+1,(CHARINDEX(')',ISSUE,1) -(CHARINDEX('(',ISSUE,1)+1)))) as gg2,
CASE WHEN ISNUMERIC(Substring(ISSUE,CHARINDEX('(',ISSUE,1)+1,(CHARINDEX(')',ISSUE,1) -(CHARINDEX('(',ISSUE,1)+1)))) = 1
	THEN CAST(Substring(ISSUE,CHARINDEX('(',ISSUE,1)+1,(CHARINDEX(')',ISSUE,1) -(CHARINDEX('(',ISSUE,1)+1))) as int)
	ELSE NULL END as NewValue
from sysdba.AREACATEGORYISSUE
where AREA = @AREA --and issue like '%(%)'
)

SELECT Service_Level_Expectation , NewValue, *
FROM sysdba.AREACATEGORYISSUE 
LEFT OUTER JOIN New_Service_Level on New_Service_Level.AREACATEGORYISSUEID = sysdba.AREACATEGORYISSUE.AREACATEGORYISSUEID
where AREA = @AREA	
and ISNUMERIC(Substring(AREACATEGORYISSUE.ISSUE,CHARINDEX('(',AREACATEGORYISSUE.ISSUE,1)+1,(CHARINDEX(')',AREACATEGORYISSUE.ISSUE,1) -(CHARINDEX('(',AREACATEGORYISSUE.ISSUE,1)+1)))) <> '0'
COMMIT;

END




--select * from HDTSTORAGE.sys.tables 