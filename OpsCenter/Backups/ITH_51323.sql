USE MassMarketingData
GO

DECLARE @sqlcmd nvarchar(MAX)
DECLARE @sqlcmd2 nvarchar(MAX)
DECLARE @Ticket NVARCHAR(15) =N'ITH_51323_3';
DECLARE @TokenID NVARCHAR(2) = '10'
DECLARE @AccessToken NVARCHAR(730) = 'eyJhbGciOiJSUzI1NiIsImtpZCI6Im9hdXRoc2lnbmluZ2NlcnQiLCJwaS5hdG0iOiIxIn0.eyJzY29wZSI6WyJzZXNzaW9uOnJvbGU6cmVhZF9tYnBfZWR3X3Byb2QiXSwiY2xpZW50X2lkIjoiU25vd2ZsYWtlLVNub3dDTEkiLCJpc3MiOiJhbGxpZWRfc29sdXRpb25zX29hdXRoMl9hcyIsImF1ZCI6Imh0dHBzOi8vc3M1Mzk2My5lYXN0LXVzLTIuYXp1cmUuc25vd2ZsYWtlY29tcHV0aW5nLmNvbSIsInN1YmplY3QiOiJNQlBGUk9NU05PV0ZMQUtFUFJPRCIsImV4cCI6MTcwMzIwODk1NH0.USHfMMSWGNYsrMvopDHYGiHmSJuty96fzulfEfUSrWT4tovFzrGaSKRpIEYHJG5obln8LwUYAZd3ScFGQW3eC9MTT8FqVDmshzwjUlkIE8QcYPMAXxvTfkQDarMGT4L1i5-_Y2Zl8KfSVxE61fmahbnWyKzIktRo1JOX_XyXmLprcpwRr2bGajuEubpJEWy5UL5XGsFEnLChpqyGDcIXMFMIjUvWbrVkK4MGfbb-OAF7qyn9P78ZpFLsxBJrLmchY5dHw7lyKeiHkYWlbx2oUXzB60ksqN8NB3qgbBlJIC3BW07tR5hAwrtYQFLB90uWG8ZcfAUHAblz3Y1dQMe2Qw'
DECLARE @SourceDatabase NVARCHAR(100) = 'MassMarketingData' /* This will be the schema in HDTStorage */;
DECLARE @StartDate nvarchar(100) = CAST(GETDATE()-6 AS DATE)
DECLARE @ExpireDate nvarchar(100)=  CAST(GETDATE()+84 AS DATE)
DECLARE @RowsToInsert nvarchar(1) = 1
DECLARE @Flag nvarchar(1) ='Y'
DECLARE @DryRun INT = 0


select @sqlcmd ='
DECLARE @RowsToInsert bigint =' + @RowsToInsert+'  
BEGIN TRAN;

USE [HDTStorage]
/* Existence check for Storage tables - Exit if they exist */
IF NOT EXISTS (
		SELECT SCHEMA_NAME(SCHEMA_ID), *
		FROM HDTStorage.sys.tables
		WHERE SCHEMA_NAME(SCHEMA_ID) = '''+@SourceDatabase+'''
			AND NAME LIKE '''+@Ticket + '_%''
			AND TYPE IN (N''U'')
		)

	BEGIN
USE [' + @SourceDatabase +']
    		/* Step 2 - Create EMPTY Storage Table  */
		SELECT [TokenID]
           ,[AccessToken]
           ,[StartDate]
           ,[ExpireDate]
           ,[ActiveFlag]
          		INTO HDTStorage.'+@SourceDatabase+'.'+ @Ticket+'_SnowflakeAccessTokens
          		FROM [dbo].[SnowflakeAccessTokens]
          		WHERE 1=0;  /*WHERE 1=0 creates table without moving data*/
    
		/* populate new Storage table from Sources */
		INSERT INTO HDTStorage.'+@SourceDatabase+'.'+ @Ticket+'_SnowflakeAccessTokens([TokenID] ,[AccessToken] ,[StartDate] ,[ExpireDate],[ActiveFlag])/*Specify columns to avoid identity columns*/
     VALUES
           ('''+@TokenID+'''
           ,'''+@AccessToken+'''           
		   ,'''+@StartDate+'''
           ,'''+@ExpireDate+''' 
           ,0);
  
    		/* Does Storage Table meet expectations */
		IF( @@RowCount = '+@RowsToInsert+' )
			BEGIN
				PRINT ''Storage table meets expections - continue''

				/* Step 3 - Perform table INSERT */
				INSERT INTO [dbo].[SnowflakeAccessTokens]
				SELECT [TokenID] ,[AccessToken] ,[StartDate],[ExpireDate] ,[ActiveFlag]
				FROM HDTStorage.'+@SourceDatabase+'.'+ @Ticket+'_SnowflakeAccessTokens


				/* Step 4 - Inspect results - Commit/Rollback */
				IF ( @@ROWCOUNT = @RowsToInsert )
		  			BEGIN
			    			PRINT ''SUCCESS - Performing Commit''

							select * from [dbo].[SnowflakeAccessTokens]
			    			COMMIT;
			  		END
				ELSE
			  		BEGIN
		    				PRINT ''FAILED TO UPDATE - Performing Rollback''
						ROLLBACK;
	  				END
			END
		ELSE
			BEGIN
				PRINT ''Storage does not meet expectations - rollback''
				ROLLBACK;
			END
	END
ELSE
	BEGIN
		PRINT ''HD TABLE EXISTS - Stop work''
		COMMIT;
	END
'


IF @Flag = 'Y' 
BEGIN 
select @sqlcmd2 ='

USE ['+ @SourceDatabase+']

IF EXISTS(select 1 from sys.objects where name = ''SnowflakeAccessTokens'')
BEGIN
IF EXISTS (select 1 from SnowflakeAccessTokens  WHERE TokenID = '''+ @TokenID+''' AND ActiveFlag = ''0 '')
BEGIN
update S set ActiveFlag = ''0''
--select * 
from [dbo].[SnowflakeAccessTokens] S
WHERE ActiveFlag = ''1''

update S set ActiveFlag = ''1''
--select * 
from [dbo].[SnowflakeAccessTokens] S
WHERE TokenID = '''+ @TokenID+'''

select * 
from [dbo].[SnowflakeAccessTokens] S
END

END'



END

IF @DryRun = 0 
BEGIN 

exec  (@SQLCMD2)
END

	ELSE
BEGIN 



PRINT (@SQLCMD2)

END

