USE [RepoPlusAnalytics]
GO

PRINT 'Creating Temp Table Standby....'

--Create a table of the data that you need
SELECT *
	INTO #tmpRepoInsurance 
	FROM RepoInsurance
	WHERE UID in (
	'0ACFB960-F317-429D-952A-4CBB7350F3E8',
	'A75CA97C-550C-4465-8806-76A548AA57FB',
	'5C8EEEEE-2F16-43AC-B81F-15F3B019E606',
	'8953EE02-C269-4DA8-9D29-FB158C3DDF13',
	'0B8A5324-ECC8-42DD-ABB0-74656C5802A3',
	'9DBFA7A1-EC5C-4D23-B61D-77066AC1E7FA',
	'41CD8E19-A4A6-4170-A8AA-3A8443C6C352',
	'B36BA5D3-9202-4167-B2E7-5F96D1C889BC',
	'7E916847-AB94-4F07-9EF6-65C3BC246CCF',
	'14BC47EF-C299-454B-A6EE-E312003BA046',
	'1DFBEBE7-6D0C-4194-972C-AB4B374ED5C7',
	'E84357A4-A6FB-4EDA-8D38-6442A89B4F56',
	'982463DC-5FD0-44EF-B734-86B65E9467D3',
	'0E77AC2A-C079-4E49-97F3-CC77C4F0A5BF',
	'3D44DE4A-9799-4DC7-9B7B-D91963478FF5',
	'D89DA631-8534-44FF-9CD4-747B66479AE0',
	'8A4860E0-1BF9-47F5-9546-87E7FAE02C42',
	'0775A6B6-C3DD-426A-BB67-E8A039FDFDE3',
	'C47E2A86-5318-4214-8033-03533029B243',
	'20DBC18A-7B0B-4FD2-85D4-52634E81CEFE',
	'CC9CE294-D5FA-4092-A41A-ECF50D1E2E91',
	'8B3F7A82-8E4B-46AC-89CA-467B7154039F',
	'99B473F6-1DD8-45B8-9E24-AA21FCC549E8',
	'19B7434F-E45C-428B-A0FD-77342D869745',
	'511A72F1-80E0-444D-B6B9-7921D870F278',
	'69C1741F-D32B-4AF5-AD12-C878FB1F0D58',
	'B0BA4323-A951-4C70-8D69-AD9A84EBE596',
	'08FDCC06-DBE8-46F4-AAFB-7F4BCA527563',
	'51531842-D19D-443E-9659-C4DD0EC898D2',
	'29386BE2-CADC-435C-BA38-B529500B8D67',
	'EB4186D4-C8BD-4081-91C5-3FBA8BE3AC47',
	'9E36527B-E317-4CD6-B90F-B06503895F6C',
	'53CA9999-7112-45B1-B1B8-97D2CD217A71',
	'A58B6887-4392-4C42-8B3D-7E3FFD10217F',
	'FDD9D1C1-DD4B-4A4E-9973-448AE56FA23F',
	'84C64FCC-74CA-4E38-8CF4-F5AE6DB41FA4',
	'22065140-BDF4-44C6-8CA3-5E637D58BC6B',
	'E7E43920-B310-494E-B0A5-FA2E336B64FC',
	'73B5C265-A792-493A-9B34-42BB005D6757',
	'4535CEE3-FDA2-4518-A3AD-743C8E8DF6F1',
	'27D45C94-CF08-4D8D-B359-C38F7D6361AF',
	'F9B7A884-EB04-43E9-95F9-B5DB5C9A1EAB',
	'23C38243-5C2C-4400-BE12-23B26D85E8E9',
	'554DF0C7-BCDA-4529-9FF5-DFDEB68C62F8',
	'76490FA4-3BA2-4495-847E-3ECB9A2312B8',
	'97297345-22C3-477C-BF14-10DB1456FD4D',
	'A438015B-8153-4C62-94B4-54AB0CC714A3',
	'C70D92F1-A384-44DE-995C-1B58E2992287',
	'78D7319B-5385-42BD-B841-45A91DA5301D',
	'F4B2D5E2-0957-4A38-8356-7826886024BD',
	'D47FBF83-07AA-46BD-AC18-2EA2ABDDEC77',
	'76A38096-B98F-49D9-8D4A-1FFC7E4F2718',
	'D671EFAC-9875-47D8-9C71-F8EED0B80F0A',
	'52A40CED-6CEB-4263-9640-940832DD190F',
	'EEAD87C2-1066-43A9-8E03-4C7181EC998F',
	'CE4A2721-876E-45E0-B6A2-27BA80A32F17',
	'07CFFF31-30BB-4AF9-8CEA-A8444BBD6D6C',
	'B8D4D3B1-EDE9-41CA-9816-6211AC940221',
	'86B1F142-CF62-4C88-A59D-4C4B1D9460E3',
	'B23D1EB0-F612-4F64-B11E-BF8EADC5D262',
	'2A565AB9-E24F-47E0-B420-9778566B5439',
	'62A3872B-5FB2-4AEF-BAEC-823DBC930744',
	'2E1AD1F1-00BA-4C9D-8BEA-4F65EEEED135'
)

PRINT 'Updating with Temp Table with information....'
		--Update it to a temp table
		Update #tmpRepoInsurance
		Set Claim_ID = '1393155' Where UID = '0ACFB960-F317-429D-952A-4CBB7350F3E8'

		Update #tmpRepoInsurance
		Set Claim_ID = '1393155' Where UID = 'A75CA97C-550C-4465-8806-76A548AA57FB'

		Update #tmpRepoInsurance
		Set Claim_ID = '1326657' Where UID = '5C8EEEEE-2F16-43AC-B81F-15F3B019E606'

		Update #tmpRepoInsurance
		Set Claim_ID = '1381352' Where UID = '8953EE02-C269-4DA8-9D29-FB158C3DDF13'

		Update #tmpRepoInsurance
		Set Claim_ID = '1376882' Where UID = '0B8A5324-ECC8-42DD-ABB0-74656C5802A3'

		Update #tmpRepoInsurance
		Set Claim_ID = '1387977' Where UID = '9DBFA7A1-EC5C-4D23-B61D-77066AC1E7FA'

		Update #tmpRepoInsurance
		Set Claim_ID = '1391845' Where UID = '41CD8E19-A4A6-4170-A8AA-3A8443C6C352'

		Update #tmpRepoInsurance
		Set Claim_ID = '1376208' Where UID = 'B36BA5D3-9202-4167-B2E7-5F96D1C889BC'

		Update #tmpRepoInsurance
		Set Claim_ID = '1390213' Where UID = '7E916847-AB94-4F07-9EF6-65C3BC246CCF'

		Update #tmpRepoInsurance
		Set Claim_ID = '1390329' Where UID = '14BC47EF-C299-454B-A6EE-E312003BA046'

		Update #tmpRepoInsurance
		Set Claim_ID = '1390329' Where UID = '1DFBEBE7-6D0C-4194-972C-AB4B374ED5C7'

		Update #tmpRepoInsurance
		Set Claim_ID = '1390329' Where UID = 'E84357A4-A6FB-4EDA-8D38-6442A89B4F56'

		Update #tmpRepoInsurance
		Set Claim_ID = '1390329' Where UID = '982463DC-5FD0-44EF-B734-86B65E9467D3'

		Update #tmpRepoInsurance
		Set Claim_ID = '1390329' Where UID = '0E77AC2A-C079-4E49-97F3-CC77C4F0A5BF'

		Update #tmpRepoInsurance
		Set Claim_ID = '1390329' Where UID = '3D44DE4A-9799-4DC7-9B7B-D91963478FF5'

		Update #tmpRepoInsurance
		Set Claim_ID = '1393787' Where UID = 'D89DA631-8534-44FF-9CD4-747B66479AE0'

		Update #tmpRepoInsurance
		Set Claim_ID = '1384631' Where UID = '8A4860E0-1BF9-47F5-9546-87E7FAE02C42'

		Update #tmpRepoInsurance
		Set Claim_ID = '1394656' Where UID = '0775A6B6-C3DD-426A-BB67-E8A039FDFDE3'

		Update #tmpRepoInsurance
		Set Claim_ID = '1384649' Where UID = 'C47E2A86-5318-4214-8033-03533029B243'

		Update #tmpRepoInsurance
		Set Claim_ID = '1394175' Where UID = '20DBC18A-7B0B-4FD2-85D4-52634E81CEFE'

		Update #tmpRepoInsurance
		Set Claim_ID = '1393501' Where UID = 'CC9CE294-D5FA-4092-A41A-ECF50D1E2E91'

		Update #tmpRepoInsurance
		Set Claim_ID = '1380308' Where UID = '8B3F7A82-8E4B-46AC-89CA-467B7154039F'

		Update #tmpRepoInsurance
		Set Claim_ID = '1393797' Where UID = '99B473F6-1DD8-45B8-9E24-AA21FCC549E8'

		Update #tmpRepoInsurance
		Set Claim_ID = '1395173' Where UID = '19B7434F-E45C-428B-A0FD-77342D869745'

		Update #tmpRepoInsurance
		Set Claim_ID = '1388612' Where UID = '511A72F1-80E0-444D-B6B9-7921D870F278'

		Update #tmpRepoInsurance
		Set Claim_ID = '1390792' Where UID = '69C1741F-D32B-4AF5-AD12-C878FB1F0D58'

		Update #tmpRepoInsurance
		Set Claim_ID = '1393019' Where UID = 'B0BA4323-A951-4C70-8D69-AD9A84EBE596'

		Update #tmpRepoInsurance
		Set Claim_ID = '1393207' Where UID = '08FDCC06-DBE8-46F4-AAFB-7F4BCA527563'

		Update #tmpRepoInsurance
		Set Claim_ID = '1393804' Where UID = '51531842-D19D-443E-9659-C4DD0EC898D2'

		Update #tmpRepoInsurance
		Set Claim_ID = '1382907' Where UID = '29386BE2-CADC-435C-BA38-B529500B8D67'

		Update #tmpRepoInsurance
		Set Claim_ID = '1388341' Where UID = 'EB4186D4-C8BD-4081-91C5-3FBA8BE3AC47'

		Update #tmpRepoInsurance
		Set Claim_ID = '1380297' Where UID = '9E36527B-E317-4CD6-B90F-B06503895F6C'

		Update #tmpRepoInsurance
		Set Claim_ID = '1394499' Where UID = '53CA9999-7112-45B1-B1B8-97D2CD217A71'

		Update #tmpRepoInsurance
		Set Claim_ID = '1394835' Where UID = 'A58B6887-4392-4C42-8B3D-7E3FFD10217F'

		Update #tmpRepoInsurance
		Set Claim_ID = '1374560' Where UID = 'FDD9D1C1-DD4B-4A4E-9973-448AE56FA23F'

		Update #tmpRepoInsurance
		Set Claim_ID = '1381868' Where UID = '84C64FCC-74CA-4E38-8CF4-F5AE6DB41FA4'

		Update #tmpRepoInsurance
		Set Claim_ID = '1394277' Where UID = '22065140-BDF4-44C6-8CA3-5E637D58BC6B'

		Update #tmpRepoInsurance
		Set Claim_ID = '1397522' Where UID = 'E7E43920-B310-494E-B0A5-FA2E336B64FC'

		Update #tmpRepoInsurance
		Set Claim_ID = '1388907' Where UID = '73B5C265-A792-493A-9B34-42BB005D6757'

		Update #tmpRepoInsurance
		Set Claim_ID = '1394449' Where UID = '4535CEE3-FDA2-4518-A3AD-743C8E8DF6F1'

		Update #tmpRepoInsurance
		Set Claim_ID = '1393736' Where UID = '27D45C94-CF08-4D8D-B359-C38F7D6361AF'

		Update #tmpRepoInsurance
		Set Claim_ID = '1393857' Where UID = 'F9B7A884-EB04-43E9-95F9-B5DB5C9A1EAB'

		Update #tmpRepoInsurance
		Set Claim_ID = '1391141' Where UID = '23C38243-5C2C-4400-BE12-23B26D85E8E9'

		Update #tmpRepoInsurance
		Set Claim_ID = '1394420' Where UID = '554DF0C7-BCDA-4529-9FF5-DFDEB68C62F8'

		Update #tmpRepoInsurance
		Set Claim_ID = '1395357' Where UID = '76490FA4-3BA2-4495-847E-3ECB9A2312B8'

		Update #tmpRepoInsurance
		Set Claim_ID = '1394780' Where UID = '97297345-22C3-477C-BF14-10DB1456FD4D'

		Update #tmpRepoInsurance
		Set Claim_ID = '1383295' Where UID = 'A438015B-8153-4C62-94B4-54AB0CC714A3'

		Update #tmpRepoInsurance
		Set Claim_ID = '1383295' Where UID = 'C70D92F1-A384-44DE-995C-1B58E2992287'

		Update #tmpRepoInsurance
		Set Claim_ID = '1383295' Where UID = '78D7319B-5385-42BD-B841-45A91DA5301D'

		Update #tmpRepoInsurance
		Set Claim_ID = '1383295' Where UID = 'F4B2D5E2-0957-4A38-8356-7826886024BD'

		Update #tmpRepoInsurance
		Set Claim_ID = '1383295' Where UID = 'D47FBF83-07AA-46BD-AC18-2EA2ABDDEC77'

		Update #tmpRepoInsurance
		Set Claim_ID = '1383295' Where UID = '76A38096-B98F-49D9-8D4A-1FFC7E4F2718'

		Update #tmpRepoInsurance
		Set Claim_ID = '1348023' Where UID = 'D671EFAC-9875-47D8-9C71-F8EED0B80F0A'

		Update #tmpRepoInsurance
		Set Claim_ID = '1390820' Where UID = '52A40CED-6CEB-4263-9640-940832DD190F'

		Update #tmpRepoInsurance
		Set Claim_ID = '1388631' Where UID = 'EEAD87C2-1066-43A9-8E03-4C7181EC998F'

		Update #tmpRepoInsurance
		Set Claim_ID = '1394826' Where UID = 'CE4A2721-876E-45E0-B6A2-27BA80A32F17'

		Update #tmpRepoInsurance
		Set Claim_ID = '1394846' Where UID = '07CFFF31-30BB-4AF9-8CEA-A8444BBD6D6C'

		Update #tmpRepoInsurance
		Set Claim_ID = '1393098' Where UID = 'B8D4D3B1-EDE9-41CA-9816-6211AC940221'

		Update #tmpRepoInsurance
		Set Claim_ID = '1397470' Where UID = '86B1F142-CF62-4C88-A59D-4C4B1D9460E3'

		Update #tmpRepoInsurance
		Set Claim_ID = '1393617' Where UID = 'B23D1EB0-F612-4F64-B11E-BF8EADC5D262'

		Update #tmpRepoInsurance
		Set Claim_ID = '1395260' Where UID = '2A565AB9-E24F-47E0-B420-9778566B5439'

		Update #tmpRepoInsurance
		Set Claim_ID = '1392459' Where UID = '62A3872B-5FB2-4AEF-BAEC-823DBC930744'

		Update #tmpRepoInsurance
		Set Claim_ID = '1387172' Where UID = '2E1AD1F1-00BA-4C9D-8BEA-4F65EEEED135'

PRINT 'Placing it in a format to use in the request'
		--Move them into a Storage Table to reference
IF NOT EXISTS (SELECT *
               FROM PIMSHDStorage.sys.tables  -- Someday this will be the standard 
               WHERE  name= 'AIH_9007Updates' )
BEGIN
		SELECT UID, Claim_ID into 
		PIMSHDStorage.dbo.AIH_9007Updates
		FROM #tmpRepoInsurance
END
ELSE 
BEGIN 

PRINT 'WARNING: This work has been done already'

END

PRINT 'Starting transaction....'

BEGIN TRAN;
/* Declare variables */
DECLARE @Ticket NVARCHAR(15) =N'AIH9007';
DECLARE @RowsToChange INT;

/* Step 1 - Calculate rows to be changed - same query as populate Storage table */
SELECT @RowsToChange = count(A.UID)
FROM RepoInsurance R
JOIN PIMSHDStorage.dbo.AIH_9007Updates A on R.UID = A.UID


/* Existence check for Storage tables - Exit if they exist */
IF NOT EXISTS (SELECT *
               FROM PIMSHDStorage.sys.tables  -- Someday this will be the standard 
               WHERE name like  @Ticket+'_%' AND type IN (N'U') )
	BEGIN

    	/* populate new Storage table from Sources */
    	EXEC('SELECT R.* into PIMSHDStorage..'+@Ticket+'_RepoInsurance
  		FROM RepoInsurance R
		JOIN PIMSHDStorage.dbo.AIH_9007Updates A on R.UID = A.UID ')
  
    	/* Does Storage Table meet expectations */
	IF( @@RowCount = @RowsToChange )
		BEGIN
			PRINT 'Storage table meets expections - continue'

			/* Step 3 - Perform table update */
			UPDATE R 
			SET R.Claim_ID = A.Claim_ID
			FROM RepoInsurance R
			JOIN PIMSHDStorage.dbo.AIH_9007Updates A on R.UID = A.UID

        		/* Step 4 - Inspect results - Commit/Rollback */
			IF ( @@ROWCOUNT = @RowsToChange )
		  		BEGIN
		    			PRINT 'SUCCESS - Performing Commit'
		    			COMMIT;
						DROP TABLE #tmpRepoInsurance;
		  		END
			ELSE
		  		BEGIN
		    			PRINT 'FAILED TO UPDATE - Performing Rollback'
		    			ROLLBACK;
						DROP TABLE #tmpRepoInsurance;
		  		END
		END
	ELSE
      		BEGIN
        		PRINT 'Storage does not meet expectations - rollback'
			;ROLLBACK
			DROP TABLE #tmpRepoInsurance;
		END
	END
ELSE
	BEGIN
		PRINT 'HD TABLE EXISTS - Stop work'
		COMMIT;
		DROP TABLE #tmpRepoInsurance
	END
