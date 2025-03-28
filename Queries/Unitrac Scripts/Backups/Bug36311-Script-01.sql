---- DROP TABLE #TMPLOAN
SELECT  l.BRANCH_CODE_TX , l.DIVISION_CODE_TX , l.NUMBER_TX , 
l.ID AS LOAN_ID , c.ID AS COLL_ID , RC.ID AS RC_ID , 
RC.* 
INTO #TMPLOAN
FROM    LOAN L
        INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
        AND L.PURGE_DT IS NULL
        AND C.PURGE_DT IS NULL
        INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
        AND P.PURGE_DT IS NULL
        INNER JOIN REQUIRED_COVERAGE RC ON P.ID = RC.PROPERTY_ID
        AND RC.PURGE_DT IS NULL
        --INNER JOIN OWNER_LOAN_RELATE OL ON L.ID = OL.LOAN_ID
        --AND OL.PURGE_DT IS NULL
        --INNER JOIN OWNER O ON OL.OWNER_ID = O.ID
        --AND O.PURGE_DT IS NULL
        --INNER JOIN OWNER_ADDRESS OA ON O.ADDRESS_ID = OA.ID
WHERE   L.LENDER_ID = '423' AND 
RC.SUMMARY_STATUS_CD = 'N' AND
RC.INSURANCE_STATUS_CD = 'N' AND
L.NUMBER_TX IN ( '129519L55', '153422L17', '155262L17', '146835L55',
                         '128208L21', '157407L55', '157771L24', '158449L55',
                         '100487L17', '14025L17 ', '137175L55', '112337L55',
                         '703L51 ', '161292L17', '77472L17.1 ', '44019L9',
                         '146551L17', '100373L58', '134519L17', '119447L58.1',
                         '76078L55 ', '163894L58', '7380L24', '7380L58',
                         '94140L36.1 ', '32091L58 ', '2975L58', '127107L9 ',
                         '36875L55 ', '106237L51', '106737L58', '85538L58 ',
                         '160209L17', '103518L36', '87758L36.1 ', '72600L17 ',
                         '154252L58', '19334L58 ', '123631L55.1', '20828L8',
                         '160871L22', '166951L55', '20483L55.2 ', '118252L55',
                         '96821L58 ', '119508L24', '11210L17.1 ', '93244L58 ',
                         '129419L58', '85763L58 ', '104046L58', '34345L36 ',
                         '144195L17', '168092L36', '168081L24', '28998L55 ',
                         '163225L55', '168218L55', '168297L17', '132239L51.1',
                         '133099L17', '1427L9 ', '79022L58.2 ', '124816L58',
                         '99706L58 ', '168827L36', '168765L17', '112445L51.1',
                         '108792L9.1 ', '71693L51 ', '12774L58 ', '24477L51 ',
                         '36004L58 ', '19534L58 ', '169184L17', '26090L58 ',
                         '123307L55.1', '102816L55.1', '76378L55.1 ',
                         '21150L55.1 ', '42824L58.1 ', '4085L55', '118390L51',
                         '123582L24', '86988L55 ', '118796L58', '27706L58.2 ',
                         '109961L58', '91870L58.1 ', '113435L24',
                         '42123L36.1 ', '96823L51 ', '74953L51 ', '163125L58',
                         '82015L55 ', '95648L55 ', '144432L55', '111994L55',
                         '161946L58', '170178L36', '124159L58', '124159L58.1',
                         '82325L55.1 ', '102755L51.1', '153653L55',
                         '22845L55 ', '103411L55.1', '29458L22 ', '8516L17',
                         '962L17 ', '73363L22 ', '37507L51 ', '133163L58',
                         '163049L55', '169287L17', '128040L58', '170853L58',
                         '70904L9', '170811L24', '166901L58.1', '166901L58',
                         '12976L58 ', '1167L58', '27865L55 ', '95669L36.1 ',
                         '90248L55 ', '76202L58 ', '109426L17', '149167L55',
                         '156352L58', '118725L55', '150329L58.2',
                         '18581L51.1 ', '171666L51', '100475L58', '171033L51',
                         '28469L55.1 ', '172016L22', '131365L17', '172213L58',
                         '114894L17', '101933L55', '104817L58', '24636L51.1 ',
                         '92470L58 ', '153548L51', '166287L17', '18695L58.1 ',
                         '172604L58', '172362L58.1', '26204L58 ',
                         '130794L55.1', '87507L58.2 ', '87507L58.1 ',
                         '128087L55.1', '116652L17', '107456L55', '129996L55',
                         '164969L55', '9214L55.1', '107278L21', '131440L58.1',
                         '155691L55', '157318L55.1', '129273L58', '99020L22 ',
                         '101314L21.1', '92164L58 ', '32010L17 ', '91469L17 ',
                         '99020L58.2 ', '44345L55 ', '151870L58', '173644L58',
                         '92840L21 ', '135884L21', '35194L58 ', '54289L51 ',
                         '154072L55', '173868L9 ', '129716L22', '152136L55',
                         '40179L24 ', '72105L58 ', '122315L55', '174172L51',
                         '22673L58 ', '135884L51', '162861L22', '127937L51.1',
                         '166674L58.2', '103742L58', '31113L58 ', '50415L36 ',
                         '174455L55', '162258L24', '93483L17.1 ', '149898L36',
                         '167430L17.1', '161423L51.1', '132099L51',
                         '90788L51 ', '174744L36', '3241L58.1', '114894L58.2',
                         '161883L17', '109858L58', '174898L51', '174903L24',
                         '116235L17', '108247L17', '170414L58', '170414L58.1',
                         '1413L58', '146324L51', '72452L58.1 ', '39775L36 ',
                         '167444L58', '106193L58', '94593L24 ', '157310L58',
                         '155002L51', '90664L51 ', '175474L51', '106251L51',
                         '150025L58', '151601L36', '4736L36', '34875L51 ',
                         '115701L51', '16935L36 ', '141249L36', '128839L58',
                         '42390L51.1 ', '17608L58 ', '170424L58',
                         '142383L21.1', '105873L51', '281298L36',
                         '21354L58.1 ', '129617L58', '157045L58.1', '8074L51',
                         '158084L51', '160862L36', '123407L58', '147516L55',
                         '763L51 ', '12752L51 ', '6602L36', '43172L51 ',
                         '7371L58', '12976L36 ', '107660L55', '158994L58.1',
                         '154405L58.1', '131212L51', '74678L17 ', '161946L36',
                         '125169L51.1', '80602L51 ', '150150L55.1',
                         '14456L55.1 ', '962L51 ', '173177L51', '11970L51 ',
                         '25293L58.1 ', '127631L51', '176780L55', '25293L24 ',
                         '113365L58', '510L58 ', '23550L21 ', '170352L58.1',
                         '168141L51.1', '72712L9', '176960L36', '79560L58 ',
                         '6887L36.1', '156025L58.1', '219539L21', '176386L55',
                         '157526L58', '148517L22', '94477L17 ', '98290L9',
                         '140681L36', '99957L51.1 ', '75306L51 ', '157991L17',
                         '2807L24', '2807L58.1', '103090L51', '97585L51 ',
                         '97290L55 ', '100535L21', '177398L51', '117889L58',
                         '12832L51 ', '75167L58.1 ', '118725L58', '98817L58 ',
                         '129485L24', '126765L51', '177470L24', '177505L58',
                         '148365L36', '62045L58.2 ', '96296L17 ', '109762L24',
                         '18442L36 ', '39108L58.1 ', '154931L58.2',
                         '177647L24', '177657L55', '152550L58', '24702L36 ',
                         '43641L36 ', '39817L51 ', '156924L55', '177692L58',
                         '92202L51 ', '169861L58', '177811L58', '177811L58.1',
                         '166060L58', '19809L55 ', '155289L36.1', '161632L55',
                         '107180L58', '177557L22', '114647L58.1', '132361L51',
                         '107198L36', '76239L24 ', '121025L55', '177981L51',
                         '177945L36', '107655L51', '178120L24', '25304L36 ',
                         '137762L55', '90517L58 ', '134851L21.1', '90117L36 ',
                         '14065L58 ', '3162L21', '15621L21 ', '178248L58',
                         '148250L51', '61109L21 ', '3422L24', '85143L21 ',
                         '178411L58', '158868L58', '111121L21', '28643L58.1 ',
                         '73087L17 ', '42331L58 ', '87005L21.1 ', '172361L36',
                         '163303L36.1', '178385L51', '120700L58.1',
                         '102123L51', '20921L55 ', '109103L58', '167792L36',
                         '25293L21 ', '133369L58', '177684L36', '153880L36',
                         '39754L51 ', '85241L51 ', '2295L9 ', '15471L9',
                         '106516L51', '149842L17', '159242L81.1', '216199L17',
                         '52530L58.1 ', '162558L51.1', '178832L24',
                         '158595L58', '103090L58.1', '124361L58', '178850L58',
                         '130148L17', '173796L22', '177790L58', '175702L24',
                         '141993L55', '102839L58', '83248L36.1 ',
                         '75133L55.1 ', '178853L17', '74133L58.1 ',
                         '146995L58.1', '177231L58', '120455L55', '92075L58 ',
                         '92195L21 ', '155555L55', '34884L21 ', '178879L58',
                         '38553L58 ', '178877L55', '178820L51', '145312L36',
                         '178065L17', '178877L36', '134518L58', '90104L51 ',
                         '133827L17', '113531L36', '178891L58', '178922L58',
                         '178794L24', '81386L58 ', '152891L58.2', '178931L51',
                         '178931L58', '118054L55', '178928L36', '178933L17',
                         '168249L58', '159705L51', '15039L24 ', '155578L55.1',
                         '174261L36', '178942L36', '281848L36', '167070L58.3',
                         '173714L81.1', '178947L24', '178312L55',
                         '121935L58.2', '178675L17', '72231L58.2 ',
                         '171787L51.3', '178961L36', '37060L51.1 ',
                         '178976L58', '115099L55', '178965L58', '112145L58.1',
                         '176507L58', '171749L17', '178887L58.1', '139665L17',
                         '156650L17', '208201L58', '127687L58', '82624L55 ',
                         '178916L58', '165332L24', '144831L55', '179006L58',
                         '122470L22', '149375L58.1', '173832L17.1',
                         '98535L51.1 ', '179032L58', '102238L58', '105532L51',
                         '173797L36', '5678L22', '130804L58.1', '178976L58.1',
                         '179053L51', '179048L51', '15844L36 ', '172241L55',
                         '179045L36', '178362L58.1', '173441L17', '17160L24 ',
                         '177047L81.8', '121709L58', '179059L58', '158373L58',
                         '132533L58', '75627L58 ', '120273L24', '19063L36 ',
                         '30537L51 ', '164953L36', '108843L58', '154740L36',
                         '179103L58', '113149L22', '146545L24', '3848L58',
                         '142748L58', '102836L58', '166697L51.1', '124550L22',
                         '170271L21', '179101L58', '170594L51', '170594L58.1',
                         '176748L58', '177155L58', '149324L9 ', '37160L51 ',
                         '179109L58', '179109L58.1', '148574L36', '168294L81',
                         '95590L24 ', '177590L58', '88865L22 ', '118834L58',
                         '171505L58', '179130L58', '36089L21 ', '120492L55',
                         '120492L58', '178975L55', '133101L58', '2229L51',
                         '95475L58 ', '163050L51', '175683L55', '179157L58',
                         '134585L17', '151559L24', '151559L51', '27838L17 ',
                         '19578L9', '124262L22', '179164L51', '179164L51.1',
                         '162144L17', '81824L55 ', '11371L51.1 ', '178522L51',
                         '169195L22', '176145L36', '176499L58', '178862L58.1',
                         '177577L17', '141480L51', '108469L58', '154517L51',
                         '99049L21 ', '2295L51', '160695L24', '177767L58',
                         '74707L55 ', '176362L55.2', '179249L58', '101093L58',
                         '147324L58.2', '37577L51 ', '179258L36', '170352L17',
                         '111544L55', '175636L58', '179268L36', '154854L58',
                         '171241L58', '37423L36 ', '170529L81', '115186L58',
                         '179238L24', '112728L58', '77018L17 ', '83548L55 ',
                         '8824L36', '169810L51', '169810L58.1', '132504L24.1',
                         '178100L51', '131304L17', '179292L17', '106587L22',
                         '179151L58  ' )
 ---- 514              

----- GET THE LIST OF RC'S IN #TMPRC
---- DROP TABLE #TMPRC
SELECT  *
INTO #TMPRC
FROM #TMPLOAN
WHERE CPI_QUOTE_ID > 0
----47

---- DROP TABLE #tmpIH
SELECT IH.ID AS IH_ID
INTO #tmpIH
FROM #TMPRC tmp
		JOIN INTERACTION_HISTORY IH ON IH.RELATE_ID = tmp.CPI_QUOTE_ID
WHERE
		IH.TYPE_CD = 'CPI'
		AND IH.RELATE_CLASS_TX = 'ALLIED.UNITRAC.CPIQUOTE'
		AND tmp.RC_ID = ISNULL(IH.SPECIAL_HANDLING_XML.value('(/SH/RC)[1]', 'BIGINT'),0 )
		and tmp.PROPERTY_ID = IH.property_id     
		AND ISNULL(IH.SPECIAL_HANDLING_XML.value('(/SH/Status)[1]', 'varchar(20)'),'') = 'Open'
		AND IH.PURGE_DT IS NULL
----- 47


SELECT * 
INTO UnitracHDStorage.dbo.tmpTask36311_Loan
FROM #TMPLOAN


SELECT * 
INTO UnitracHDStorage.dbo.tmpTask36311_IH
FROM #tmpIH

	
INSERT INTO
	PROPERTY_CHANGE (
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
		UTL_IN)
SELECT DISTINCT
	'Allied.UniTrac.RequiredCoverage',
	tf.RC_ID,
	'TASK36311',
	'N',
	GETDATE(),
	1,
	'Notice Cycle Cleared',
	'N',
	'Y',
	1,
	'Allied.UniTrac.RequiredCoverage',
	TF.RC_ID,
	'PEND',
	'N'
FROM
	 #TMPLOAN tf
WHERE
	NOTICE_SEQ_NO > 0
----47


UPDATE QT
	SET	QT.CLOSE_REASON_CD = 'NCC',
		QT.CLOSE_DT = GETDATE(),
		QT.UPDATE_DT = GETDATE(),
		QT.UPDATE_USER_TX = 'TASK36311',
		QT.LOCK_ID = (QT.LOCK_ID % 255) + 1
	--SELECT COUNT(*)
	FROM CPI_QUOTE QT
	JOIN #TMPRC RC
		ON RC.CPI_QUOTE_ID = QT.ID
----47
			
			
UPDATE IH
SET	SPECIAL_HANDLING_XML.modify('replace value of (/SH/Status/text())[1] with "Closed" '),
	UPDATE_DT = GETDATE(),
	UPDATE_USER_TX = 'TASK36311',
	LOCK_ID = (LOCK_ID % 255) + 1
--SELECT COUNT(*)
FROM INTERACTION_HISTORY IH
JOIN #tmpIH
	ON #tmpIH.IH_ID = IH.ID
----- 47



-- Update RequiredCoverage Status from Track to Active
UPDATE RC SET SUMMARY_STATUS_CD = 'A' , 
INSURANCE_STATUS_CD = 'A' , 
BEGAN_NEW_IN = 'N' ,
GOOD_THRU_DT = NULL , 
CPI_QUOTE_ID = NULL , NOTICE_DT = NULL , NOTICE_TYPE_CD = NULL , 
NOTICE_SEQ_NO = NULL , LAST_EVENT_SEQ_ID = NULL , LAST_EVENT_DT = NULL ,
LAST_SEQ_CONTAINER_ID = NULL ,
UPDATE_DT = GETDATE() , UPDATE_USER_TX = 'TASK36311' , 
LOCK_ID = RC.LOCK_ID % 255 + 1
---SELECT * 
FROM REQUIRED_COVERAGE RC JOIN #TMPLOAN TMP 
ON TMP.RC_ID = RC.ID WHERE RC.SUMMARY_STATUS_CD = 'N'
---- 514


 INSERT INTO PROPERTY_CHANGE
 (
 ENTITY_NAME_TX , ENTITY_ID , USER_TX , ATTACHMENT_IN , 
 CREATE_DT , AGENCY_ID , DESCRIPTION_TX ,  DETAILS_IN , FORMATTED_IN ,
 LOCK_ID , PARENT_NAME_TX , PARENT_ID , TRANS_STATUS_CD , UTL_IN
 )
 SELECT DISTINCT 'Allied.UniTrac.RequiredCoverage' , TMP.RC_ID , 'UNITRAC' , 'N' ,
 GETDATE(),  1 ,
 'Changed Summary Status from New to Audit' ,
 'N' , 'Y' , 1 ,  'Allied.UniTrac.RequiredCoverage' , TMP.RC_ID , 'PEND' , 'N'
 FROM #TMPLOAN TMP
---- 514


UPDATE EVALUATION_EVENT
SET STATUS_CD = 'CLR',
	UPDATE_DT = GETDATE(),
	UPDATE_USER_TX = 'TASK36311',
	LOCK_ID = (LOCK_ID % 255) + 1
--SELECT ee.*
FROM
	EVALUATION_EVENT ee
	JOIN #TMPLOAN te ON ee.REQUIRED_COVERAGE_ID = te.RC_ID
	WHERE ee.STATUS_CD = 'PEND'
	AND ee.EVENT_SEQUENCE_ID > 0
---- 1907





