USE [CenterPointComp]
GO

BEGIN TRAN;
/* Declare variables */
DECLARE @Ticket NVARCHAR(15) =N'AIH1002';
DECLARE @RowsToInsert bigint =1

/* Step 1 - Calculate rows to be Inserted */
--SET @RowsToInsert = [#]; -- If the rows are not contained in an existing table

/* Existence check for Storage tables - Exit if they exist */
IF NOT EXISTS (SELECT *
               FROM DBA.sys.tables  -- Someday this will be the standard 
               WHERE name like  @Ticket+'_%' AND type IN (N'U') )
	BEGIN
				/* Step 1 - Backup Original Table per ticket desires */
		SELECT Name, Menu, Path, Icon, ServiceEndpoint, SecurityFunction, Type, ServicePath, IsActive, DisplayOrder
          		INTO DBA..AIH1002_ContentDiscoverybackup
          		FROM [CenterPointComp].[dbo].[ContentDiscovery];

    		/* Step 2 - Create EMPTY Storage Table  */
		SELECT Name, Menu, Path, Icon, ServiceEndpoint, SecurityFunction, Type, ServicePath, IsActive, DisplayOrder
          		INTO DBA..AIH1002_ContentDiscovery
          		FROM [CenterPointComp].[dbo].[ContentDiscovery]
          		WHERE 1=0;  -- WHERE 1=0 creates table without moving data
    
		/* populate new Storage table from Sources */
		INSERT INTO DBA..AIH1002_ContentDiscovery ([Name],[Menu],[Path],[Icon],[ServiceEndpoint],[SecurityFunction],[Type],[ServicePath],[IsActive],[DisplayOrder])--Specify columns to avoid identity columns
		VALUES
		('SystemAdmin','System Admin','systemadmin','search.svg','https://SystemAdminUI.centerpoint.alliedsolutions.net','Security Admin,System Admin',NULL,NULL,1,11);



    		/* Does Storage Table meet expectations */
		IF( @@RowCount = @RowsToInsert )
			BEGIN
				PRINT 'Storage table meets expections - continue'

				/* Step 3 - Perform table INSERT */
				INSERT INTO [dbo].[ContentDiscovery]([Name],[Menu],[Path],[Icon],[ServiceEndpoint],[SecurityFunction],[Type],[ServicePath],[IsActive],[DisplayOrder])
				select [Name],[Menu],[Path],[Icon],[ServiceEndpoint],[SecurityFunction],[Type],[ServicePath],[IsActive],[DisplayOrder]
				FROM DBA..AIH1002_ContentDiscovery
				where [Name] = 'SystemAdmin'
				



				/* Step 4 - Inspect results - Commit/Rollback */
				IF ( @@ROWCOUNT = @RowsToInsert )
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