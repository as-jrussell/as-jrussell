SELECT  RC.* INTO UniTracHDStorage..INC0272961_RC
FROM    dbo.LOAN L
        JOIN dbo.COLLATERAL C ON C.LOAN_ID = L.ID
        JOIN dbo.PROPERTY P ON P.ID = C.PROPERTY_ID
        JOIN dbo.REQUIRED_COVERAGE RC ON RC.PROPERTY_ID = P.ID
WHERE   L.NUMBER_TX IN ( '1010884820002', '7010002157', '1030436120005',
                         '1030812450003', '7000000640', '7010006687',
                         '1030893760003', '7010009475', '1030882300003',
                         '7010006521', '7000000580', '1030904820003',
                         '7000000713', '7010005689', '7000000509',
                         '7000000400', '7010005200', '1030910590003',
                         '1030136650005', '7010008626', '1017861700016',
                         '1030003840008', '7010009079', '7010008352',
                         '7000000762', '1015241000011', '1030128250004',
                         '1013329900006', '7000000055', '1030182360005',
                         '1011900100019', '7010002751', '7010006877',
                         '7000000115', '1030906520002', '7010010036',
                         '7000000612', '1030904610003', '1030794100003',
                         '1030048000006', '7010009822', '1030900260004',
                         '1704390600', '7000000900', '7010009939',
                         '7000000344', '7010008527', '7010010135',
                         '7010011356', '1030947500003', '7010006430',
                         '1014797700006', '1030388350004', '1031027490003',
                         '1030078660005', '1013179410004', '7010009913',
                         '1030667900003', '7010011380', '1013519300005',
                         '7010009624', '7010008634', '1015845900005',
                         '1015087110005', '1030168100005', '1031028570002',
                         '1030627350004', '7000001046', '7000000671',
                         '1014533200005', '1030228110001', '7010009715',
                         '1019688300004', '7010009368', '7000001809',
                         '7010011562', '7010011067', '1013921820006',
                         '7010008766', '1012463700013', '1031037210003',
                         '1030067510006', '1030555050003', '1030831270003',
                         '1011737700012', '1013297830002', '7010013899',
                         '1013682710002', '1030947460003', '7000000357',
                         '7010009285', '7010010606', '7010008741',
                         '1030702320003', '1031022400003', '1017129800005',
                         '1013136100005', '1031040020002', '7000000977',
                         '1031040660003', '7010011869', '1031044050003',
                         '7010014442', '7010014376', '1030939770004',
                         '7010012289', '7010013881', '1017928600005',
                         '1030609740002', '7010013832', '1011333790005',
                         '7010013204', '7010011695', '1018510800008',
                         '7010014863', '7010011679', '1031044280002',
                         '7010012487', '7000001251', '1017949610005',
                         '1031042990002', '1014324000008', '1030813230003',
                         '1016367800010', '7010013873', '7010011554',
                         '1030898210003', '7010014780', '7010015951',
                         '1270850600', '1014708620004', '1031043510003',
                         '7010012172', '7010015977', '1200660600',
                         '7000000988', '1031028070002', '1016117800004',
                         '7000001089', '7000001478', '7000001132',
                         '7010015464', '1030539710004', '1030916240003',
                         '7000001249', '7000001391', '1031061130003',
                         '7010008311', '7010012545', '7010015001',
                         '7010012990', '7010016959', '7010016710',
                         '1030077700007', '1017251500003', '1012237900003',
                         '7000001300', '7010016694', '1031045530002',
                         '1285550600', '7000001280', '7000000955',
                         '1031036520002', '1019583410002', '7010016223',
                         '7000000689', '7010017064', '1031071830002',
                         '1031065000003', '1030900240003', '1031065150003',
                         '1013759800011', '7010011281', '7010018922',
                         '7010015886', '1019323700006', '7010017403',
                         '1031077580003', '7010013766', '7000001121',
                         '1030268800006', '7000001609', '7000001314',
                         '7000001697', '7010017205', '1031055710003',
                         '7000001410', '1030195520007', '1011089710006',
                         '1031084330003', '1031068540004', '7010020100',
                         '1030425420005', '7010018088', '1031039400005',
                         '1540872600', '3052343602', '7000001776',
                         '1031090400002', '3033018600', '1030798920003',
                         '7000002115', '1030466010006', '1923750',
                         '1030453110004', '7000001818', '7000001526',
                         '7000001419', '7000002048', '3014212600',
                         '7000002111', '1712660600', '7000002213',
                         '7000001301', '3027999600', '7000001991',
                         '3062399600', '7000000056', '7000002079',
                         '7000001242', '3051029600', '7000000896',
                         '7000001367', '7000001909', '7000002212',
                         '7000001518', '1013748800006', '7000001371',
                         '1392377601', '7000001986', '7000000120',
                         '3047988601', '7000002207', '7000001711',
                         '7000002245', '7010002934', '1015946200006',
                         '1594620600', '7010001571', '7010003098',
                         '1257990601', '7000000233', '7000002292',
                         '7000000275', '7010002892', '7010003858',
                         '7000002192', '7010001860', '1030853870003',
                         '7010002264', '1030751960003', '1015575300005',
                         '7000000220', '7000000077', '7000001691',
                         '1015814810002', '7010002496', '1030790910003',
                         '7000000075', '7000001309', '1013861100004',
                         '7000001817', '1014312700008', '7000000188',
                         '7010001969', '7010003882', '7000000290',
                         '7010000904', '7010004674', '7010004583',
                         '7000001633', '1016369110003', '7010004476',
                         '1013122600007', '7010004807', '1030408210003',
                         '7010004625', '7010006372', '7010003262',
                         '7000000542', '7000000516', '7000000415',
                         '7010006695', '7000000399', '7010006109',
                         '1017652600005', '7010004450', '1030720840002',
                         '7000002140', '7000000506', '1011903510008',
                         '7010003346', '1014848200023', '7000000217',
                         '7010002959', '7010003148', '7010003437',
                         '1030144360006', '7000000347', '1030883060003',
                         '7010007321', '7010006794', '1030878740003',
                         '7010007578', '7010003676', '7010005697',
                         '7010005721', '7010006505', '1030888430002',
                         '7010001332', '7010004849', '7010003494',
                         '7000000419', '1030886390003', '7010007529',
                         '1030853920003', '1030880750002', '1030890090003',
                         '7010006935', '7000000575', '7000000379',
                         '7000000478' )





-- get all RC's that have Summary Status as 'N' and have Status as 'A'
-- 634
IF OBJECT_ID ( 'tempdb.dbo.#TMP_NEW' ) IS NOT NULL
	DROP TABLE #TMP_NEW

GO

SELECT
DISTINCT
	rc.ID,
	rc.PROPERTY_ID,
	rc.CPI_QUOTE_ID,
	rc.NOTICE_SEQ_NO,
	rc.TYPE_CD,
	rc.STATUS_CD,
	rc.SUMMARY_STATUS_CD,
	rc.SUMMARY_SUB_STATUS_CD,
	rc.INSURANCE_STATUS_CD,
	rc.INSURANCE_SUB_STATUS_CD,
	rc.CPI_STATUS_CD,
	rc.CPI_SUB_STATUS_CD
INTO #TMP_NEW
FROM
	LOAN l
	JOIN COLLATERAL c ON c.LOAN_ID=l.ID AND c.PURGE_DT IS NULL
	JOIN REQUIRED_COVERAGE rc ON rc.PROPERTY_ID= c.PROPERTY_ID AND rc.PURGE_DT IS NULL AND rc.RECORD_TYPE_CD='G'
	JOIN LENDER_ORGANIZATION lo ON lo.TYPE_CD = 'DIV' AND l.LENDER_ID = lo.LENDER_ID AND lo.CODE_TX = l.DIVISION_CODE_TX AND lo.CODE_TX IN ('4','10')
WHERE
	l.EFFECTIVE_DT<DATEADD ( DAY,-90, GETDATE () )
	AND l.RECORD_TYPE_CD='G'
	AND l.PURGE_DT IS NULL
	AND rc.SUMMARY_STATUS_CD IN ('N', 'NC')
	AND rc.STATUS_CD='A' AND RC.ID IN (SELECT ID FROM UniTracHDStorage..INC0272961_RC)
	AND rc.TYPE_CD = 'HAZARD'
	AND l.LENDER_ID = (SELECT TOP 1 ID FROM LENDER WHERE CODE_TX = '3303')

----- GET THE LIST OF RC'S IN #TMPRC
-- 1

IF OBJECT_ID('tempdb..#TMPRC') IS NOT NULL
	DROP TABLE #TMPRC

SELECT
	*
INTO #TMPRC
FROM
	#TMP_NEW
WHERE
	CPI_QUOTE_ID > 0

-- 1

IF OBJECT_ID('tempdb..#tmpIH') IS NOT NULL
	DROP TABLE #tmpIH

SELECT
	IH.ID AS IH_ID
INTO #tmpIH 
FROM
	#TMPRC tmp
	JOIN INTERACTION_HISTORY IH
		ON IH.RELATE_ID = tmp.CPI_QUOTE_ID
WHERE
	IH.TYPE_CD = 'CPI'
	AND IH.RELATE_CLASS_TX = 'ALLIED.UNITRAC.CPIQUOTE'
	AND tmp.ID = ISNULL(IH.SPECIAL_HANDLING_XML.value('(/SH/RC)[1]', 'BIGINT'), 0)
	AND tmp.PROPERTY_ID = IH.property_id
	AND ISNULL(IH.SPECIAL_HANDLING_XML.value('(/SH/Status)[1]', 'varchar(20)'), '') = 'Open'
	AND IH.PURGE_DT IS NULL

-- 634
IF OBJECT_ID('tempdb..#TMP_NEW_RCs') IS NOT NULL
DROP TABLE #TMP_NEW_RCs

SELECT DISTINCT
	tn.ID
INTO #TMP_NEW_RCs
FROM
	#TMP_NEW tn


--634
IF EXISTS (SELECT * 
                 FROM UniTracHDStorage.INFORMATION_SCHEMA.TABLES 
                 WHERE TABLE_SCHEMA = 'dbo' 
                 AND  TABLE_NAME = 'BUG31822_RC_UPDATE_DETAILS')
BEGIN
	DROP TABLE UniTracHDStorage.dbo.BUG31822_RC_UPDATE_DETAILS
END

SELECT
	*
INTO UniTracHDStorage.dbo.BUG31822_RC_UPDATE_DETAILS
FROM
	#TMP_NEW tn

BEGIN TRY
	BEGIN TRANSACTION

		-- 1
		INSERT INTO PROPERTY_CHANGE
				(
					ENTITY_NAME_TX,
					ENTITY_ID,
					USER_TX,
					ATTACHMENT_IN,
					CREATE_DT,
					AGENCY_ID,
					DESCRIPTION_TX,
					DETAILS_IN,
					FORMATTED_IN,
					LOCK_ID,
					PARENT_NAME_TX,
					PARENT_ID,
					TRANS_STATUS_CD,
					UTL_IN
				)
			SELECT DISTINCT
				'Allied.UniTrac.RequiredCoverage',
				tf.ID,
				'UNITRAC',
				'N',
				GETDATE(),
				1,
				'Notice Cycle Cleared',
				'N',
				'Y',
				1,
				'Allied.UniTrac.RequiredCoverage',
				TF.ID,
				'PEND',
				'N'
			FROM
				#TMP_NEW tf
			WHERE
				NOTICE_SEQ_NO > 0


		--1
		UPDATE QT
		SET
			QT.CLOSE_REASON_CD	= 'NCC',
			QT.CLOSE_DT			= GETDATE(),
			QT.UPDATE_DT		= GETDATE(),
			QT.UPDATE_USER_TX	= 'BUG31822',
			QT.LOCK_ID			= (QT.LOCK_ID % 255) + 1
		--SELECT COUNT(*)
		FROM
			CPI_QUOTE QT
			JOIN #TMPRC RC
				ON RC.CPI_QUOTE_ID = QT.ID

		--1
		UPDATE IH
		SET
			SPECIAL_HANDLING_XML.modify('replace value of (/SH/Status/text())[1] with "Closed" '),
			UPDATE_DT		= GETDATE(),
			UPDATE_USER_TX	= 'BUG31822',
			LOCK_ID			= (LOCK_ID % 255) + 1
		--SELECT COUNT(*)
		FROM
			INTERACTION_HISTORY IH
			JOIN #tmpIH
				ON #tmpIH.IH_ID = IH.ID


		-- Update RequiredCoverage Status from Track to Active


		-- 634
		UPDATE RC
		SET
			SUMMARY_STATUS_CD		= 'A',
			INSURANCE_STATUS_CD		= 'A',
			BEGAN_NEW_IN			= 'N',
			GOOD_THRU_DT			= NULL,
			CPI_QUOTE_ID			= NULL,
			NOTICE_DT				= NULL,
			NOTICE_TYPE_CD			= NULL,
			NOTICE_SEQ_NO			= NULL,
			LAST_EVENT_SEQ_ID		= NULL,
			LAST_EVENT_DT			= NULL,
			LAST_SEQ_CONTAINER_ID	= NULL,
			UPDATE_DT				= GETDATE(),
			UPDATE_USER_TX			= 'BUG31822',
			LOCK_ID					= (RC.LOCK_ID % 255) + 1
		---- SELECT COUNT(*)
		FROM
			REQUIRED_COVERAGE RC
			JOIN #TMP_NEW_RCs TMP
				ON TMP.ID = RC.ID

		-- Add Property change log
		-- 634
		INSERT INTO PROPERTY_CHANGE
				(
					ENTITY_NAME_TX,
					ENTITY_ID,
					USER_TX,
					ATTACHMENT_IN,
					CREATE_DT,
					AGENCY_ID,
					DESCRIPTION_TX,
					DETAILS_IN,
					FORMATTED_IN,
					LOCK_ID,
					PARENT_NAME_TX,
					PARENT_ID,
					TRANS_STATUS_CD,
					UTL_IN
				)
			SELECT DISTINCT
				'Allied.UniTrac.RequiredCoverage',
				TMP.ID,
				'UNITRAC',
				'N',
				GETDATE(),
				1,
				'Changed Summary Status from New to Audit',
				'N',
				'Y',
				1,
				'Allied.UniTrac.RequiredCoverage',
				TMP.ID,
				'PEND',
				'N'
			FROM
				#TMP_NEW_RCs TMP

		-- 2491
		UPDATE EVALUATION_EVENT
		SET
			STATUS_CD		= 'CLR',
			UPDATE_DT		= GETDATE(),
			UPDATE_USER_TX	= 'BUG31822',
			LOCK_ID			= (LOCK_ID % 255) + 1
		-- SELECT ee.*
		FROM
			EVALUATION_EVENT ee
			JOIN #TMP_NEW te
				ON ee.REQUIRED_COVERAGE_ID = te.ID
		WHERE
			ee.STATUS_CD = 'PEND'
			AND ee.EVENT_SEQUENCE_ID > 0
			AND ee.PURGE_DT IS NULL
	COMMIT TRANSACTION
END TRY
BEGIN CATCH 
	ROLLBACK TRANSACTION
		SELECT
			'ERROR'				AS RESULT,
			ERROR_NUMBER ()		AS ErrorNumber,
			ERROR_SEVERITY ()	AS ErrorSeverity,
			ERROR_STATE ()		AS ErrorState,
			ERROR_PROCEDURE ()	AS ErrorProcedure,
			ERROR_LINE ()		AS ErrorLine,
			ERROR_MESSAGE ()	AS ErrorMessage;
END CATCH



SELECT  RC.* 
FROM    dbo.LOAN L
        JOIN dbo.COLLATERAL C ON C.LOAN_ID = L.ID
        JOIN dbo.PROPERTY P ON P.ID = C.PROPERTY_ID
        JOIN dbo.REQUIRED_COVERAGE RC ON RC.PROPERTY_ID = P.ID
WHERE  RC.ID IN (SELECT ID FROM UniTracHDStorage..INC0272961_RC)
AND RC.TYPE_CD = 'HAZARD' AND INSURANCE_STATUS_CD = 'A'

--294