USE OspreyDashboard
GO

ALTER PROCEDURE [dbo].[EnableLender](@LENDER_CD VARCHAR(50)  = NULL,
									  @LENDER_SHORT_NAME_TX VARCHAR(50) = NULL,
									  @PASSWORD_TX VARCHAR(MAX) = NULL)
AS

DECLARE @LENDER_NAME_TX VARCHAR(MAX);
DECLARE @TAX_ID_TX VARCHAR(50);
DECLARE @WEB_ADDRESS_TX VARCHAR(50);

BEGIN TRY
	IF @LENDER_CD IS NULL
	BEGIN 
		RAISERROR('Lender Code cannot be NULL',15,1)
	END
	
	ELSE IF NOT EXISTS (SELECT 1 FROM UniTrac.dbo.LENDER WHERE CODE_TX = @LENDER_CD AND PURGE_DT IS NULL)
	BEGIN
		RAISERROR('LENDER CODE ''%s'' does not exsit',0,0,@LENDER_CD)
	END

	ELSE
	BEGIN
		SET @LENDER_NAME_TX = (SELECT NAME_TX FROM UniTrac.DBO.LENDER WHERE CODE_TX = @LENDER_CD AND PURGE_DT IS NULL)
		SET @TAX_ID_TX = (SELECT TAX_ID_TX FROM UniTrac.DBO.LENDER WHERE CODE_TX = @LENDER_CD AND PURGE_DT IS NULL)
		SET @WEB_ADDRESS_TX = (SELECT WEB_ADDRESS_TX FROM UniTrac.DBO.LENDER WHERE CODE_TX = @LENDER_CD AND PURGE_DT IS NULL)

		--DEFAULT TO 'All!ed' IF NO USER DEFINED PWD IS PASSED IN 
		IF @PASSWORD_TX IS NULL
		   SET @PASSWORD_TX = 'hoSUMjeCKepp/tvNj35zmg=='
		
		BEGIN TRANSACTION;
		-- Check if Lender already been enabled
		IF EXISTS (SELECT 1 FROM DATASOURCE_CACHE_LOOKUP WHERE LOOKUP_VALUE = @LENDER_CD AND LOOKUP_KEY_CD = 'LENDER_CODE' AND PURGE_DT IS NULL)
		BEGIN
			RAISERROR('Lender Code ''%s'' had been enabled. Try a different Lender Code.',15,1,@LENDER_CD)
		END
		
		ELSE -- if haven't been enabled, start /*Lender Setup*/
		BEGIN		
			--Insert into DATASOURCE_CACHE_LOOKU
			INSERT INTO [dbo].[DATASOURCE_CACHE_LOOKUP]
					([LOOKUP_KEY_CD]
					,[LOOKUP_VALUE]
					,[CREATE_DT]
					,[UPDATE_DT]
					,[PURGE_DT]
					,[UPDATE_USER_TX]
					,[LOCK_ID])
				VALUES
					('LENDER_CODE'
					,@LENDER_CD
					,GETDATE()
					,GETDATE()
					,NULL
					,'SCRIPT'
					,1)


		--Insert into DATASOURCE_CACHE_LOOKUP
			INSERT INTO [UTPROD-SUB-01].OspreyDashboard.[dbo].[DATASOURCE_CACHE_LOOKUP]
					([LOOKUP_KEY_CD]
					,[LOOKUP_VALUE]
					,[CREATE_DT]
					,[UPDATE_DT]
					,[PURGE_DT]
					,[UPDATE_USER_TX]
					,[LOCK_ID])
				VALUES
					('LENDER_CODE'
					,@LENDER_CD
					,GETDATE()
					,GETDATE()
					,NULL
					,'SCRIPT'
					,1)


		

			-- Insert into AGENCY
			-- TAX_ID_TX COULD BE DUPLICATED, THEREFORE ALSO NEED TO CHECK THE LENDER_NAME_TX
			IF NOT EXISTS (SELECT 1 FROM AGENCY WHERE NAME_TX = @LENDER_NAME_TX AND TAX_ID_TX = @TAX_ID_TX AND PURGE_DT IS NULL)
			BEGIN
				INSERT INTO [dbo].[AGENCY]
					   ([SHORT_NAME_TX]
					   ,[NAME_TX]
					   ,[WEB_ADDRESS_TX]
					   ,[TAX_ID_TX]
					   ,[ACTIVE_IN]
					   ,[CREATE_DT]
					   ,[UPDATE_DT]
					   ,[PURGE_DT]
					   ,[UPDATE_USER_TX]
					   ,[LOCK_ID])
				 VALUES
					   (ISNULL(@LENDER_SHORT_NAME_TX,@LENDER_NAME_TX)
					   ,@LENDER_NAME_TX
					   ,@WEB_ADDRESS_TX
					   ,@TAX_ID_TX
					   ,'Y'
					   ,GETDATE()
					   ,GETDATE()
					   ,NULL
					   ,'SCRIPT'
					   ,1)
			END

			-- Insert into RELATED_DATA
			IF NOT EXISTS (SELECT * FROM RELATED_DATA WHERE RELATE_ID IN (SELECT ID FROM AGENCY WHERE NAME_TX = @LENDER_NAME_TX AND TAX_ID_TX = @TAX_ID_TX AND PURGE_DT IS NULL) AND COMMENT_TX = 'UniTrac lender code')
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
					 VALUES
						   ((select id from RELATED_DATA_DEF where name_tx = 'UT_LENDER_CD') 
						   ,(SELECT ID FROM AGENCY WHERE NAME_TX = @LENDER_NAME_TX AND TAX_ID_TX = @TAX_ID_TX AND PURGE_DT IS NULL)
						   ,@LENDER_CD
						   ,NULL
						   ,NULL
						   ,'UniTrac lender code'
						   ,GETDATE()
						   ,GETDATE()
						   ,'SCRIPT'
						   ,1)
			END

			/*Create Lender User*/
			IF NOT EXISTS (SELECT 1 FROM USERS WHERE USER_NAME_TX = @LENDER_CD AND PURGE_DT IS NULL) 
			BEGIN
				INSERT INTO [dbo].[USERS]
						   ([USER_NAME_TX]
						   ,[PASSWORD_TX]
						   ,[FAMILY_NAME_TX]
						   ,[GIVEN_NAME_TX]
						   ,[ACTIVE_IN]
						   ,[EMAIL_TX]
						   ,[EXTERN_MAINT_IN]
						   ,[LOGIN_COUNT_NO]
						   ,[LAST_LOGIN_DT]
						   ,[DEFAULT_AGENCY_ID]
						   ,[SYSTEM_IN]
						   ,[PASSWORD_SET_DT]
						   ,[IS_LOCKED_OUT_IN]
						   ,[CREATE_DT]
						   ,[UPDATE_DT]
						   ,[PURGE_DT]
						   ,[UPDATE_USER_TX]
						   ,[LOCK_ID])
					 VALUES
						   (@LENDER_CD
						   ,@PASSWORD_TX
						   ,ISNULL(@LENDER_SHORT_NAME_TX,@LENDER_NAME_TX)
						   ,@LENDER_CD
						   ,'Y'
						   ,@LENDER_CD + '@lenderCD.com'
						   ,'N'
						   ,0
						   , GETDATE()
						   ,(SELECT ID FROM AGENCY WHERE NAME_TX = @LENDER_NAME_TX AND TAX_ID_TX = @TAX_ID_TX AND PURGE_DT IS NULL)
						   ,'N'
						   ,GETDATE()
						   ,'N'
						   ,GETDATE()
						   ,GETDATE()
						   ,NULL
						   ,'admin'
						   ,1)
			END

			/*Add Secrity Groups*/
			--BIDDVIEW
			IF NOT EXISTS (select 1 from USER_SECURITY_GROUP_RELATE where SEC_GRP_ID IN (SELECT ID FROM SECURITY_GROUP WHERE name_tx = 'BIDBVIEW') AND 
																	  USER_ID IN (SELECT ID FROM USERS WHERE USER_NAME_TX = @LENDER_CD AND PURGE_DT IS NULL))
			BEGIN
				INSERT INTO [dbo].[USER_SECURITY_GROUP_RELATE]
						   ([SEC_GRP_ID]
						   ,[USER_ID]
						   ,[CREATE_DT]
						   ,[UPDATE_DT]
						   ,[PURGE_DT]
						   ,[UPDATE_USER_TX]
						   ,[LOCK_ID])
					 VALUES
						   ((SELECT ID FROM SECURITY_GROUP WHERE name_tx = 'BIDBVIEW')
						   ,(SELECT ID FROM USERS WHERE USER_NAME_TX = @LENDER_CD AND PURGE_DT IS NULL)
						   ,getdate()
						   ,getdate()
						   ,null
						   ,'admin'
						   ,1)
			END

			--DASH_ACTIVE_LOAN_INS
			IF NOT EXISTS (select 1 from USER_SECURITY_GROUP_RELATE where SEC_GRP_ID IN (SELECT ID FROM SECURITY_GROUP WHERE name_tx = 'DASH_ACTIVE_LOAN_INS') AND 
																	  USER_ID IN (SELECT ID FROM USERS WHERE USER_NAME_TX = @LENDER_CD AND PURGE_DT IS NULL))
			BEGIN
				INSERT INTO [dbo].[USER_SECURITY_GROUP_RELATE]
						   ([SEC_GRP_ID]
						   ,[USER_ID]
						   ,[CREATE_DT]
						   ,[UPDATE_DT]
						   ,[PURGE_DT]
						   ,[UPDATE_USER_TX]
						   ,[LOCK_ID])
					 VALUES
						   ((SELECT ID FROM SECURITY_GROUP WHERE name_tx = 'DASH_ACTIVE_LOAN_INS')
						   ,(SELECT ID FROM USERS WHERE USER_NAME_TX = @LENDER_CD AND PURGE_DT IS NULL)
						   ,getdate()
						   ,getdate()
						   ,null
						   ,'admin'
						   ,1)
			END

			--DASH_CALL_INFO
			IF NOT EXISTS (select 1 from USER_SECURITY_GROUP_RELATE where SEC_GRP_ID IN (SELECT ID FROM SECURITY_GROUP WHERE name_tx = 'DASH_CALL_INFO') AND 
																	  USER_ID IN (SELECT ID FROM USERS WHERE USER_NAME_TX = @LENDER_CD AND PURGE_DT IS NULL))
			BEGIN
				INSERT INTO [dbo].[USER_SECURITY_GROUP_RELATE]
						   ([SEC_GRP_ID]
						   ,[USER_ID]
						   ,[CREATE_DT]
						   ,[UPDATE_DT]
						   ,[PURGE_DT]
						   ,[UPDATE_USER_TX]
						   ,[LOCK_ID])
					 VALUES
						   ((SELECT ID FROM SECURITY_GROUP WHERE name_tx = 'DASH_CALL_INFO')
						   ,(SELECT ID FROM USERS WHERE USER_NAME_TX = @LENDER_CD AND PURGE_DT IS NULL)
						   ,getdate()
						   ,getdate()
						   ,null
						   ,'admin'
						   ,1)
			END

			--DASH_DOC_INS
			IF NOT EXISTS (select 1 from USER_SECURITY_GROUP_RELATE where SEC_GRP_ID IN (SELECT ID FROM SECURITY_GROUP WHERE name_tx = 'DASH_DOC_INS') AND 
																	  USER_ID IN (SELECT ID FROM USERS WHERE USER_NAME_TX = @LENDER_CD AND PURGE_DT IS NULL))
			BEGIN
				INSERT INTO [dbo].[USER_SECURITY_GROUP_RELATE]
						   ([SEC_GRP_ID]
						   ,[USER_ID]
						   ,[CREATE_DT]
						   ,[UPDATE_DT]
						   ,[PURGE_DT]
						   ,[UPDATE_USER_TX]
						   ,[LOCK_ID])
					 VALUES
						   ((SELECT ID FROM SECURITY_GROUP WHERE name_tx = 'DASH_DOC_INS')
						   ,(SELECT ID FROM USERS WHERE USER_NAME_TX = @LENDER_CD AND PURGE_DT IS NULL)
						   ,getdate()
						   ,getdate()
						   ,null
						   ,'admin'
						   ,1)
			END

			--DASH_NOTICE_CERTS
			IF NOT EXISTS (select 1 from USER_SECURITY_GROUP_RELATE where SEC_GRP_ID IN (SELECT ID FROM SECURITY_GROUP WHERE name_tx = 'DASH_NOTICE_CERTS') AND 
																	  USER_ID IN (SELECT ID FROM USERS WHERE USER_NAME_TX = @LENDER_CD AND PURGE_DT IS NULL))
			BEGIN
				INSERT INTO [dbo].[USER_SECURITY_GROUP_RELATE]
						   ([SEC_GRP_ID]
						   ,[USER_ID]
						   ,[CREATE_DT]
						   ,[UPDATE_DT]
						   ,[PURGE_DT]
						   ,[UPDATE_USER_TX]
						   ,[LOCK_ID])
					 VALUES
						   ((SELECT ID FROM SECURITY_GROUP WHERE name_tx = 'DASH_NOTICE_CERTS')
						   ,(SELECT ID FROM USERS WHERE USER_NAME_TX = @LENDER_CD AND PURGE_DT IS NULL)
						   ,getdate()
						   ,getdate()
						   ,null
						   ,'admin'
						   ,1)
			END

			/*Add newly create Lender as an addtional agency for SUSER*/
			IF NOT EXISTS (SELECT 1 FROM USER_RELATE WHERE RELATE_TYPE_CD = 'Osprey.Dashboard.Agency' AND RELATE_ID IN (SELECT ID FROM AGENCY WHERE NAME_TX = @LENDER_NAME_TX AND TAX_ID_TX = @TAX_ID_TX AND PURGE_DT IS NULL) AND USER_ID IN (SELECT ID FROM USERS WHERE USER_NAME_TX = 'suser'))
			BEGIN
				INSERT INTO [dbo].[USER_RELATE]
						   ([USER_ID]
						   ,[RELATE_ID]
						   ,[RELATE_TYPE_CD]
						   ,[CREATE_DT]
						   ,[UPDATE_DT]
						   ,[PURGE_DT]
						   ,[UPDATE_USER_TX]
						   ,[LOCK_ID])
					 VALUES
						   ((SELECT ID FROM USERS WHERE USER_NAME_TX = 'suser')
						   ,(SELECT ID FROM AGENCY WHERE NAME_TX = @LENDER_NAME_TX AND TAX_ID_TX = @TAX_ID_TX AND PURGE_DT IS NULL)
						   ,'Osprey.Dashboard.Agency'
						   ,GETDATE()
						   ,GETDATE()
						   ,NULL
						   ,'SCRIPT'
						   ,1)
			END
		END
		COMMIT TRANSACTION;
	END
END TRY
BEGIN CATCH
	PRINT ERROR_MESSAGE()
	IF @@TRANCOUNT > 0
		ROLLBACK TRANSACTION;
END CATCH;


EXEC dbo.EnableLender @LENDER_CD = 'USDTEST1'


SELECT * FROM [UTPROD-SUB-01].OspreyDashboard.dbo.DATASOURCE_CACHE_LOOKUP
WHERE LOOKUP_VALUE = 'USDTEST1'



			INSERT INTO [UTPROD-SUB-01].OspreyDashboard.[dbo].[DATASOURCE_CACHE_LOOKUP]
					([LOOKUP_KEY_CD]
					,[LOOKUP_VALUE]
					,[CREATE_DT]
					,[UPDATE_DT]
					,[PURGE_DT]
					,[UPDATE_USER_TX]
					,[LOCK_ID])
				VALUES
					('LENDER_CODE'
					,'USDTEST1'
					,GETDATE()
					,GETDATE()
					,NULL
					,'SCRIPT'
					,1)