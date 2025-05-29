USE [InforCRM];
GO

BEGIN TRAN;
DECLARE @AREA1 AS VARCHAR(100)='Delinquency Management Services'

DECLARE @RowsToPreseve bigint;

SELECT @RowsToPreseve = count(AreaCategoryIssueID) --SELECT *
FROM sysdba.AREACATEGORYISSUE
WHERE AREA=@AREA1;

 /* Replace WHERE name='DDDDDDDD' with new Product */;
IF NOT EXISTS (SELECT *
			   FROM InforHDStorage.sys.tables
			   WHERE name='CSH2571_AREACATEGORYISSUE_CSS' AND type IN (N'U')
			   )
	BEGIN
		SELECT *
		INTO InforHDStorage..CSH2571_AREACATEGORYISSUE_CSS
		FROM sysdba.AREACATEGORYISSUE
		WHERE AREA=@AREA1;
	END
ELSE
	BEGIN
		PRINT 'HD TABLE EXISTS - what are you doing?'
		COMMIT;
	END

IF(@@RowCount = @RowsToPreseve)
	BEGIN
		PRINT 'Performing UPDATE - Preserve Row Count = Source Row Count';
		WITH New_Service_Level AS (SELECT AREACATEGORYISSUEID, ISSUE, ISNUMERIC(SUBSTRING(ISSUE, CHARINDEX('(', ISSUE, 1)+1, (CHARINDEX(')', ISSUE, 1)-(CHARINDEX('(', ISSUE, 1)+1)))) AS gg2, CASE WHEN ISNUMERIC(SUBSTRING(ISSUE, CHARINDEX('(', ISSUE, 1)+1, (CHARINDEX(')', ISSUE, 1)-(CHARINDEX('(', ISSUE, 1)+1))))=1 THEN CAST(SUBSTRING(ISSUE, CHARINDEX('(', ISSUE, 1)+1, (CHARINDEX(')', ISSUE, 1)-(CHARINDEX('(', ISSUE, 1)+1))) AS INT)ELSE NULL END AS NewValue
								   FROM sysdba.AREACATEGORYISSUE
								   WHERE AREA=@AREA1 --and issue like '%(%)'
		)
		UPDATE sysdba.AREACATEGORYISSUE
		SET Service_Level_Expectation=NewValue
		FROM sysdba.AREACATEGORYISSUE
			 LEFT OUTER JOIN New_Service_Level ON New_Service_Level.AREACATEGORYISSUEID=sysdba.AREACATEGORYISSUE.AREACATEGORYISSUEID
		WHERE AREA=@AREA1;
		IF(@@RowCount = @RowsToPreseve)
			BEGIN
				PRINT 'SUCCESS - UPDATE Row Count = Source Row Count';
				COMMIT;
			END
		ELSE /* @@RowCount <> @SourceRowCount */
			BEGIN
				PRINT 'Performing ROLLBACKUP - Update Row Count != SourceRow Count';
				UPDATE S SET Service_Level_Expectation=NULL;
				SELECT *
				FROM sysdba.AREACATEGORYISSUE AS S
				WHERE AREA=@AREA1;
			END;

	END;
ELSE 
	BEGIN
		PRINT 'STOPPING - Preserve Row Count != Source Row Count';
		ROLLBACK;
		/*  Manual roll back - historical 

		UPDATE S SET S.Service_Level_Expectation = C.Service_Level_Expectation
		--SELECT C.Service_Level_Expectation, S.Service_Level_Expectation, *    
		FROM [InforCRM].sysdba.AREACATEGORYISSUE S
			JOIN InforHDStorage.dbo.CSH2571_AREACATEGORYISSUE_CSS  C ON C.OWNERID = S.OWNERID  
			AND C.ISSUE = S.ISSUE 
			AND S.AREA = 'Delinquency Management Services'
		*/
	END;

/*
-- CONFIRM Delinquency Management Services BEFORE/AFTER
-- BEFORE
SELECT Service_Level_Expectation, *
FROM InforHDStorage..CSH2571_AREACATEGORYISSUE_CSS;

-- AFTER
DECLARE @AREA1 AS VARCHAR(100);
SET @AREA1='Delinquency Management Services' /* Replace 'DDDDDDDD' with new Product */;
SELECT Service_Level_Expectation, *
FROM sysdba.AREACATEGORYISSUE
WHERE AREA=@AREA1;

*/