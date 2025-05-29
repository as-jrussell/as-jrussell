USE [UniTrac]
GO

/****** Object:  StoredProcedure [dbo].[GetUTLQueues20]    Script Date: 3/26/2018 4:16:12 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[GetUTLQueues20]
(
	@processDefinitionId	  BIGINT
)
AS
BEGIN
   SET NOCOUNT ON

	CREATE TABLE #tempLenders(LenderId BIGINT)
	
	DECLARE @processTypeCode NVARCHAR(10)
	SELECT @processTypeCode = process_type_cd
	FROM PROCESS_DEFINITION pd
	WHERE id = @processDefinitionId


   IF(SELECT COUNT(*)
		FROM PROCESS_DEFINITION pd
		cross apply SETTINGS_XML_IM.nodes('/ProcessDefinitionSettings/LenderList/LenderID') as t1(nodevalues)
		WHERE id = @processDefinitionId) > 0
		/* The process definition has lenders in it so just return UTL_QUEUES for those lenders */
		BEGIN
		   INSERT INTO #tempLenders
	  		SELECT l.ID LenderId
			FROM PROCESS_DEFINITION pd
			cross apply SETTINGS_XML_IM.nodes('/ProcessDefinitionSettings/LenderList/LenderID') as t1(nodevalues)
			INNER JOIN LENDER l ON l.CODE_TX = t1.nodevalues.value('.', 'nvarchar(10)')
			WHERE pd.id = @processDefinitionId
		END
		ELSE
		/* The process definition has no lenders in it so we need to get all lenders for UTL2.0 and remove UTL20 Lenders in another Process Definition */
		BEGIN
			/* Get All UTL20 Lenders */
			SELECT l.CODE_TX LenderCode
			INTO	#tempAllUTL20Lenders
			FROM LENDER l
			INNER join RELATED_DATA rd ON rd.RELATE_ID = l.ID AND rd.VALUE_TX = 'true' 
			INNER JOIN RELATED_DATA_DEF rdd ON rdd.id = rd.DEF_ID AND rdd.NAME_TX = 'UTL2.0'
			WHERE l.PURGE_DT IS NULL
			  AND l.STATUS_CD = 'ACTIVE'

			/* Get All UTL20 Lenders in a different UTL20 Process definition, are active and not purged*/
			SELECT t1.nodevalues.value('.', 'nvarchar(10)') LenderCode
			INTO #tempLendersInAnotherPD
			FROM PROCESS_DEFINITION pd
			cross apply SETTINGS_XML_IM.nodes('/ProcessDefinitionSettings/LenderList/LenderID') as t1(nodevalues)
			WHERE pd.PROCESS_TYPE_CD = @processTypeCode
			AND id != @processDefinitionId
			AND pd.PURGE_DT IS NULL
			AND pd.ACTIVE_IN = 'Y'

			/* Get All UTL20 Lenders that aren't in another utl20 process definition */
		   INSERT INTO #tempLenders
			SELECT l.ID LenderId
			FROM #tempAllUTL20Lenders aul
			LEFT JOIN #tempLendersInAnotherPD liap ON liap.LenderCode = aul.LenderCode
			INNER JOIN LENDER l ON l.CODE_TX = aul.LenderCode
			WHERE liap.LenderCode IS null
		END
		
   	IF(@processTypeCode = 'UTL20MAT')
		BEGIN
			SELECT TOP 10000 LOAN_ID, uq.LENDER_ID,  uq.RECORD_TYPE_CD,  uq.EVALUATION_DT,  uq.CREATE_DT,  uq.LOCK_ID
			FROM UTL_QUEUE uq	
			INNER JOIN #tempLenders l ON l.LenderId = uq.LENDER_ID
			WHERE EVALUATION_DT = CONVERT(DATE, '1/1/1900')   
			  AND uq.PURGE_DT IS NULL
			ORDER BY CREATE_DT ASC
		END
		ELSE
		BEGIN
			SELECT TOP 10000 q.LOAN_ID,  q.LENDER_ID,  q.RECORD_TYPE_CD,  q.EVALUATION_DT,  q.CREATE_DT,  q.LOCK_ID, UTLM.APPLY_STATUS_CD
			FROM UTL_QUEUE q
				OUTER APPLY
					  (
						 SELECT TOP 1
						 APPLY_STATUS_CD = 
						 CASE WHEN UTL1.APPLY_STATUS_CD IN ( 'PEND', 'HOLD' ) THEN 'PEND' 
								WHEN UTL1.APPLY_STATUS_CD = 'APP' AND 
								  (UTL1.MATCH_RESULT_CD = 'EXACT' OR UTL1.USER_MATCH_RESULT_CD = 'EXACT') THEN 
									'EXACT' 
								ELSE NULL END                       
						  FROM UTL_MATCH_RESULT UTL1
						  WHERE UTL1.UTL_LOAN_ID = q.LOAN_ID
						  AND UTL1.PURGE_DT IS NULL
						  ORDER BY 
							CASE WHEN UTL1.APPLY_STATUS_CD IN ( 'PEND', 'HOLD' ) THEN 1 
								WHEN UTL1.APPLY_STATUS_CD = 'APP' AND 
								  (UTL1.MATCH_RESULT_CD = 'EXACT' OR UTL1.USER_MATCH_RESULT_CD = 'EXACT') THEN 2                         
								ELSE 3 END ASC 
					  ) AS UTLM
			WHERE
			  q.EVALUATION_DT > CONVERT(DATE, '1/1/1900') AND q.EVALUATION_DT < CONVERT(DATE,getdate()) 
			  AND q.PURGE_DT IS NULL
			  AND q.LENDER_ID IN (SELECT LenderId FROM #tempLenders)
			  GROUP BY q.LOAN_ID,q.LENDER_ID,q.RECORD_TYPE_CD,q.EVALUATION_DT, q.CREATE_DT, q.LOCK_ID , UTLM.APPLY_STATUS_CD
			  ORDER BY q.EVALUATION_DT ASC
		END
END


GO

