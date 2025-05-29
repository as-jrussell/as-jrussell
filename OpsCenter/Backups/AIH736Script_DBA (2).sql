/*	
Target SQL Instance: UT-PRD-LISTENER

Set Target CarrieID 
Manually calculate rows to insert  :(
Check for Storage table Existence and create
Insert new data into Storage table
Move data into Target table
Compare and Commit/Rollback

*/

Use UniTrac;

BEGIN TRAN;
DECLARE @ticket NVARCHAR(15) =N'CSH_2633';
DECLARE @lenderID BIGINT=651;
DECLARE @agency BIGINT=1;
DECLARE @old_prop BIGINT=84646956;
DECLARE @old_collat BIGINT=245637565;
DECLARE @new_prop BIGINT;
DECLARE @old_collat2 BIGINT=251802857; --this is the NON-primary collateral
DECLARE @line1 NVARCHAR(100) =N'W10764 Shakey Lake Rd';
DECLARE @line2 NVARCHAR(100) =N'';
DECLARE @city NVARCHAR(40) =N'Hortonville';
DECLARE @state NVARCHAR(30) =N'WI';
DECLARE @zip NVARCHAR(30) =N'54944';
DECLARE @new_addr BIGINT;

/* Step 1 - Calculate rows to be changed */
DECLARE @AddrToInsert bigint = 1; -- ??? confirm - Need this for Each Table to be inserted into for new data
DECLARE @PropToInsert bigint = 1;

/* Existence check for Storage tables */;
IF NOT EXISTS (SELECT *
			   FROM UniTracHDStorage.sys.tables
			   WHERE name like  @ticket+'_%' AND type IN (N'U')
			   )
	BEGIN
		/* populate new Storage table from Sources */
		SELECT C.*
		INTO UniTracHDStorage.dbo.CSH_2633_COLLATERAL_21
		FROM COLLATERAL AS C
		WHERE C.ID IN (@old_collat, @old_collat2);

		SELECT SFT.*
		INTO UniTracHDStorage.dbo.CSH_2633_SEARCH_FULLTEXT_21
		FROM SEARCH_FULLTEXT AS SFT
		WHERE SFT.PROPERTY_ID IN (@old_prop);

		/* Create Empty table for new Data */
		SELECT  LENDER_ID, AGENCY_ID, ADDRESS_ID, DESCRIPTION_TX, ACV_NO, ACV_DT, ACV_VALUATION_REQUIRED_IN, ASSET_NUMBER_TX, RECORD_TYPE_CD, SOURCE_CD, YEAR_TX, MAKE_TX, MODEL_TX, BODY_TX, VIN_TX, REVERSE_VIN_TX, TITLE_CD, FIELD_PROTECTION_XML, CREATE_DT, UPDATE_DT, UPDATE_USER_TX, PURGE_DT, LOCK_ID, SPECIAL_HANDLING_XML, REPLACEMENT_COST_VALUE_NO, LAND_VALUE_NO, VACANT_IN, ACRES_AMOUNT_NO, TIED_DOWN_IN, IN_PARK_IN, ACV_INCLUDES_LAND_IN, IN_CONSTRUCTION_IN, ZONE_ASSUMED_IN, COASTAL_BARRIER_IN, PARTICIPATING_COMMUNITY_IN, FLOOD_ZONE_TX, WIND_ZONE_TX, PROPERTY_ASSOC_ID, ALT_MATCH_XML, UCC_CD, CALCULATED_COLL_BALANCE_NO, FLOOD_ACTIVE_IN, VEHICLETYPE_TX, VEHICLECLASS_TX 
		INTO UniTracHDStorage.dbo.CSH_2633_PROPERTY
		FROM dbo.PROPERTY
		WHERE 1=0;

		SELECT  LINE_1_TX, LINE_2_TX, CITY_TX, STATE_PROV_TX, COUNTRY_TX, POSTAL_CODE_TX, CREATE_DT, UPDATE_DT, UPDATE_USER_TX, PURGE_DT, LOCK_ID, ATTENTION_TX, ADDRESS_TYPE_CD, PO_BOX_TX, RURAL_ROUTE_TX, UNIT_TX, PARSED_STATUS_CD, CERTIFIED_IN
		INTO UniTracHDStorage.dbo.CSH_2633_OWNER_ADDRESS
		from OWNER_ADDRESS
		WHERE 1=0;

		/* UPLOAD NEW DATA to Storage table */
		INSERT INTO UniTracHDStorage.dbo.CSH_2633_OWNER_ADDRESS ( LINE_1_TX, LINE_2_TX, CITY_TX, STATE_PROV_TX, COUNTRY_TX, POSTAL_CODE_TX, CREATE_DT, UPDATE_DT, UPDATE_USER_TX, PURGE_DT, LOCK_ID, ATTENTION_TX, ADDRESS_TYPE_CD, PO_BOX_TX, RURAL_ROUTE_TX, UNIT_TX, PARSED_STATUS_CD, CERTIFIED_IN)
		SELECT LINE_1_TX=@line1, LINE_2_TX=NULLIF(@line2, ''), CITY_TX=@city, STATE_PROV_TX=@state,  COUNTRY_TX='US', POSTAL_CODE_TX=@zip, CREATE_DT=GETDATE(),  UPDATE_DT=GETDATE(), UPDATE_USER_TX=@ticket, NULL, LOCK_ID=1, NULL, NULL, NULL, NULL, NULL, NULL, CERTIFIED_IN='N';
 
		/* Does Storage Table meet expectations */
		IF( @@RowCount = @AddrToInsert )
			BEGIN
				PRINT 'Storage table meets expections - continue'
			END
		ELSE
			BEGIN
				PRINT 'Storage does not meet expectations - rollback'
				ROLLBACK;
			END

		INSERT INTO UniTracHDStorage.dbo.CSH_2633_PROPERTY (LENDER_ID, AGENCY_ID, ADDRESS_ID, UPDATE_USER_TX, UPDATE_DT, CREATE_DT, LOCK_ID, RECORD_TYPE_CD, SOURCE_CD, VACANT_IN, TIED_DOWN_IN, IN_PARK_IN, ACV_VALUATION_REQUIRED_IN, ACV_INCLUDES_LAND_IN, IN_CONSTRUCTION_IN, FLOOD_ACTIVE_IN)
		SELECT LENDER_ID=@lenderID, AGENCY_ID=@agency, ADDRESS_ID=@new_addr, UPDATE_USER_TX=@ticket, UPDATE_DT=GETDATE(), CREATE_DT=GETDATE(), LOCK_ID=1, RECORD_TYPE_CD='G', SOURCE_CD='', VACANT_IN='N', TIED_DOWN_IN='N', IN_PARK_IN='N', ACV_VALUATION_REQUIRED_IN='N', ACV_INCLUDES_LAND_IN='N', IN_CONSTRUCTION_IN='N', FLOOD_ACTIVE_IN='N';

		/* Does Storage Table meet expectations */
		IF( @@RowCount = @PropToInsert )
			BEGIN
				PRINT 'Storage table meets expections - continue'
			END
		ELSE
			BEGIN
				PRINT 'Storage does not meet expectations - rollback'
				ROLLBACK;
			END

		/* Step 3 - Perform table INSERT */
		INSERT INTO OWNER_ADDRESS 
		SELECT  LINE_1_TX, LINE_2_TX, CITY_TX, STATE_PROV_TX, COUNTRY_TX, POSTAL_CODE_TX, CREATE_DT, UPDATE_DT, UPDATE_USER_TX, PURGE_DT, LOCK_ID, ATTENTION_TX, ADDRESS_TYPE_CD, PO_BOX_TX, RURAL_ROUTE_TX, UNIT_TX, PARSED_STATUS_CD, CERTIFIED_IN
		FROM UniTracHDStorage.dbo.CSH_2633_OWNER_ADDRESS
		-- WHERE statement makes this safer
		
		IF(@@RowCount = @AddrToInsert)
			BEGIN
				PRINT 'SUCCESS - INSERT Row Count = Source Row Count';
				SET @new_addr = SCOPE_IDENTITY()
			END
		ELSE /* @@RowCount <> @RowsToInsert */
			BEGIN
				/* Step 4 - perform Rollback */
				PRINT 'Performing ROLLBACKUP - INSERT Row Count != Source Row Count';
				ROLLBACK;
			END

		INSERT INTO dbo.PROPERTY
		SELECT LENDER_ID, AGENCY_ID, ADDRESS_ID=@new_addr, DESCRIPTION_TX, ACV_NO, ACV_DT, ACV_VALUATION_REQUIRED_IN, ASSET_NUMBER_TX, RECORD_TYPE_CD, SOURCE_CD, YEAR_TX, MAKE_TX, MODEL_TX, BODY_TX, VIN_TX, REVERSE_VIN_TX, TITLE_CD, FIELD_PROTECTION_XML, CREATE_DT, UPDATE_DT, UPDATE_USER_TX, PURGE_DT, LOCK_ID, SPECIAL_HANDLING_XML, REPLACEMENT_COST_VALUE_NO, LAND_VALUE_NO, VACANT_IN, ACRES_AMOUNT_NO, TIED_DOWN_IN, IN_PARK_IN, ACV_INCLUDES_LAND_IN, IN_CONSTRUCTION_IN, ZONE_ASSUMED_IN, COASTAL_BARRIER_IN, PARTICIPATING_COMMUNITY_IN, FLOOD_ZONE_TX, WIND_ZONE_TX, PROPERTY_ASSOC_ID, ALT_MATCH_XML, UCC_CD, CALCULATED_COLL_BALANCE_NO, FLOOD_ACTIVE_IN, VEHICLETYPE_TX, VEHICLECLASS_TX
		FROM UniTracHDStorage.dbo.CSH_2633_PROPERTY 
		-- WHERE statement makes this safer
			
		IF(@@RowCount = @PropToInsert)
			BEGIN
				PRINT 'SUCCESS - INSERT Row Count = Source Row Count';
				SET @new_prop = SCOPE_IDENTITY()
			END
		ELSE /* @@RowCount <> @RowsToInsert */
			BEGIN
				/* Step 4 - perform Rollback */
				PRINT 'Performing ROLLBACKUP - INSERT Row Count != Source Row Count';
				Rollback;
			END;

		/* Perform Update */
		UPDATE TOP(2) C -- Using TOP 2 indicates your where statement is incomplete without an order by it can return randomn results.
		SET
			 PROPERTY_ID = iif(C.ID=@old_collat, @new_prop, C.PROPERTY_ID)
			,PRIMARY_LOAN_IN = 'Y'
			,EXTRACT_UNMATCH_COUNT_NO = 0
			,STATUS_CD = iif(C.STATUS_CD = 'U', 'A', C.STATUS_CD)
			,UPDATE_DT = GETDATE()
			,UPDATE_USER_TX = @ticket
			,LOCK_ID = C.LOCK_ID % 255 + 1
		FROM COLLATERAL as C
		WHERE C.ID in (@old_collat, @old_collat2)

		IF(@@RowCount = @PropToInsert + @AddrToInsert)
			BEGIN
				PRINT 'SUCCESS - INSERT Row Count = Source Row Count';
				COMMIT; -- this should be after the EXEC statements if we knew what they returned for success.
			END
		ELSE /* @@RowCount <> @RowsToInsert */
			BEGIN
				/* Step 4 - perform Rollback */
				PRINT 'Performing ROLLBACKUP - INSERT Row Count != Source Row Count';
				ROLLBACK;
			END;

		EXEC SaveSearchFullText @old_prop
		--Does this return row count for validation?

		EXEC SaveSearchFullText @new_prop
		--Does this return row count for validation?

	END
ELSE
	BEGIN
		PRINT 'HD TABLE EXISTS - Stop work'
		COMMIT;
	END

