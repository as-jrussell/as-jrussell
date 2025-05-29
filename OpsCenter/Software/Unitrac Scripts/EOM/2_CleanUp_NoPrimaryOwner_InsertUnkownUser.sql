
  
  BEGIN transaction


DECLARE @newid TABLE (ID bigint)
DECLARE @ownerid AS bigint
DECLARE @loanid AS BIGINT


DECLARE db_cursor CURSOR FOR  
SELECT loan_id as id
FROM #noOwner



OPEN db_cursor   
FETCH NEXT FROM db_cursor INTO @loanid   

WHILE @@FETCH_STATUS = 0   
BEGIN   
       


INSERT INTO [UniTrac].[dbo].[OWNER]
           ([ADDRESS_ID]
           ,[NAME_TX]
           ,[LAST_NAME_TX]
           ,[FIRST_NAME_TX]
           ,[MIDDLE_INITIAL_TX]
           ,[CREDIT_SCORE_TX]
           ,[PREFERRED_CUSTOMER_IN]
           ,[SPECIAL_PERSON_IN]
           ,[HOME_PHONE_TX]
           ,[WORK_PHONE_TX]
           ,[CELL_PHONE_TX]
           ,[EMAIL_TX]
           ,[ALLOW_EMAIL_IN]
           ,[CUSTOMER_NUMBER_TX]
           ,[FIELD_PROTECTION_XML]
           ,[CREATE_DT]
           ,[UPDATE_DT]
           ,[UPDATE_USER_TX]
           ,[PURGE_DT]
           ,[LOCK_ID]
           ,[SPECIAL_HANDLING_XML])
             OUTPUT INSERTED.id  INTO @newid
     VALUES
           (null
           ,NULL
           ,'UNKNOWN'
           ,'UNKNOWN'
           ,' '
           ,NULL
           ,'N'
           ,'N'
           ,NULL
           ,NULL
           ,NULL
           ,NULL
           ,'N'
           ,' '
           ,NULL
           ,GETDATE()
           ,GETDATE()
           ,'EOMClnUp'
           ,NULL
           ,1
           ,NULL )


SELECT @ownerid = id FROM @newid


INSERT INTO [UniTrac].[dbo].[OWNER_LOAN_RELATE]
           ([OWNER_ID]
           ,[LOAN_ID]
           ,[OWNER_TYPE_CD]
           ,[PRIMARY_IN]
           ,[RECEIVE_NOTICES_IN]
           ,[TAKE_UPDATES_IN]
           ,[CREATE_DT]
           ,[UPDATE_DT]
           ,[UPDATE_USER_TX]
           ,[PURGE_DT]
           ,[LOCK_ID]
           ,[EXPIRATION_DT])
     VALUES
           (@ownerid
           ,@loanid 
           ,'B'
           ,'Y'
           ,'Y'
           ,'Y'
           ,GETDATE()
           ,GETDATE()
           ,'EOMClnUp'
           ,NULL
           ,1
           ,NULL )



--SELECT @loanid
--SELECT ID FROM @newid

DELETE FROM @newid

 FETCH NEXT FROM db_cursor INTO @loanid
 
END   
CLOSE db_cursor
DEALLOCATE db_cursor
--ROLLBACK