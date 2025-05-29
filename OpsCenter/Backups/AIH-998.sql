use [CenterPointComp]

BEGIN TRAN

DECLARE @path nvarchar(10) = 'users';     -- Incident (ticket) number
DECLARE @RowsToPreserveWI bigint;
DECLARE @ticket NVARCHAR(15) ='AIH998';    

SELECT @RowsToPreserveWI = Count(DISTINCT IsActive) 
FROM [CenterPointComp].[dbo].[ContentDiscovery]
where [Path] = @path



IF NOT EXISTS (SELECT *
               FROM CenterPointHDStorage.sys.tables
               WHERE name LIKE @ticket+'_%' AND type IN (N'U'))

		BEGIN
				SELECT * INTO CenterPointHDStorage.[dbo].[AIH998_ContentDiscovery]
				FROM [CenterPointComp].[dbo].[ContentDiscovery]
				where [Path] = @path



		IF(@@RowCount=@RowsToPreserveWI)
		BEGIN
			PRINT 'Performing UPDATE - Preserve Row Count = Source Row Count';
				UPDATE [CenterPointComp].[dbo].[ContentDiscovery] 
				set IsActive = 0
				where [Path] = @path

			 IF(@@RowCount=@RowsToPreserveWI)
				BEGIN
					PRINT 'SUCCESS - UPDATE Row Count = Source Row Count';
					COMMIT;
				END;
			ELSE /* @@RowCount <> @SourceRowCount */
    			BEGIN
					PRINT 'Performing ROLLBACKUP - Update Row Count != SourceRow Count';
					ROLLBACK;
					/*
					
					--Third is to Change the field back to what it was in case this script needs reverted.

					UPDATE [CenterPointComp].[dbo].[ContentDiscovery] set IsActive = 1
					where [Path] =  @path
					
					*/

					END;
						END;

END;			

ELSE 
	BEGIN
		PRINT 'HD TABLE EXISTS - what are you doing?';
		ROLLBACK;
	
	END; 