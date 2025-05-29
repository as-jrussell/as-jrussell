



--43717 
----------------------------------
-- OCR Inbound Process not visible in UI
DECLARE @def_id bigint, @processDef_id bigint,
@name_Tx nvarchar(20) = 'AgencyFilter' 
SELECT @def_id = ID FROM RELATED_DATA_DEF WHERE NAME_TX = @name_Tx 
SELECT @processDef_id = ID FROM PROCESS_DEFINITION WHERE PROCESS_TYPE_CD = 'OCRINPRCPA' 


IF NOT EXISTS (select 1	from RELATED_DATA where Relate_id = @processDef_id and DEF_ID = @def_id)
BEGIN
INSERT INTO [dbo].[RELATED_DATA]
           ([DEF_ID]
           ,[RELATE_ID]
           ,[VALUE_TX]
           ,[START_DT]
           ,[END_DT]
           ,[COMMENT_TX]
           ,[CREATE_DT]
           ,[UPDATE_DT]
           ,[UPDATE_USER_TX]
           ,[LOCK_ID])
SELECT		
		@def_id as DEF,
        ID as RELATE_ID,
        '1' as VALUE_TX,
		NULL as START_DT,
		NULL as END_DT,
		@name_Tx as COMMENT_TX,
		GETDATE() AS CREATE_DT,
		GETDATE() AS UPDATE_DT,
		'ADMIN' AS UPDATE_USER_TX,
		1 AS LOCK_ID 
FROM 
	PROCESS_DEFINITION 
WHERE 
	PURGE_DT IS NULL AND
	PROCESS_TYPE_CD = 'OCRINPRCPA' and
	ID not IN 
	(SELECT
		PD.ID
	 FROM
		PROCESS_DEFINITION PD
		JOIN RELATED_DATA RD ON RD.RELATE_ID = PD.ID
		JOIN RELATED_DATA_DEF RDD ON RDD.ID = RD.DEF_ID AND RDD.DOMAIN_CD = 'AgencyFilter')
		   ORDER BY LAST_SCHEDULED_DT DESC

END

--43753
IF NOT EXISTS (select 1 from REF_CODE where CODE_CD = 'OCR' and DOMAIN_CD = 'SourceType')
BEGIN
	INSERT INTO REF_CODE
	(
		CODE_CD , DOMAIN_CD , MEANING_TX , DESCRIPTION_TX , 
		ACTIVE_IN , CREATE_DT , UPDATE_DT , UPDATE_USER_TX , LOCK_ID , AGENCY_ID
	)
	VALUES
	(
		'OCR' ,'SourceType' , 'New OCR' ,'New OCR' ,	
		'Y' , GETDATE() , GETDATE() , 'Task43753' , 1 , 0
	)
END
GO

