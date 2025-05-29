---Run THIS script first
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
						   ('XXXX'
						   ,'hoSUMjeCKepp/tvNj35zmg=='
						   ,'SafeFCU'
						   ,'XXXX'
						   ,'Y'
						   ,'SafeFCU@lenderCD.com'
						   ,'N'
						   ,0
						   , GETDATE()
						   , '##'
						   ,'N'
						   ,GETDATE()
						   ,'N'
						   ,NULL
						   ,GETDATE()
						   ,GETDATE()
						   ,'admin'
						   ,1)


----

INSERT dbo.USER_SECURITY_GROUP_RELATE
        ( SEC_GRP_ID ,
          USER_ID ,
          CREATE_DT ,
          UPDATE_DT ,
          PURGE_DT ,
          UPDATE_USER_TX ,
          LOCK_ID
        )
VALUES  ( '2', -- SEC_GRP_ID - bigint
          '239' , -- USER_ID - bigint
          GETDATE() , -- CREATE_DT - datetime
          GETDATE() , -- UPDATE_DT - datetime
          NULL, -- PURGE_DT - datetime
          N'suser' , -- UPDATE_USER_TX - nvarchar(15)
          1  -- LOCK_ID - tinyint
        )

INSERT dbo.USER_SECURITY_GROUP_RELATE
        ( SEC_GRP_ID ,
          USER_ID ,
          CREATE_DT ,
          UPDATE_DT ,
          PURGE_DT ,
          UPDATE_USER_TX ,
          LOCK_ID
        )
VALUES  ( '7' , -- SEC_GRP_ID - bigint
          '239' , -- USER_ID - bigint
          GETDATE() , -- CREATE_DT - datetime
          GETDATE() , -- UPDATE_DT - datetime
          NULL, -- PURGE_DT - datetime
          N'suser' , -- UPDATE_USER_TX - nvarchar(15)
          1  -- LOCK_ID - tinyint
        )


		INSERT dbo.USER_SECURITY_GROUP_RELATE
        ( SEC_GRP_ID ,
          USER_ID ,
          CREATE_DT ,
          UPDATE_DT ,
          PURGE_DT ,
          UPDATE_USER_TX ,
          LOCK_ID
        )
VALUES  (  '6', -- SEC_GRP_ID - bigint
          '239' , -- USER_ID - bigint
          GETDATE() , -- CREATE_DT - datetime
          GETDATE() , -- UPDATE_DT - datetime
          NULL, -- PURGE_DT - datetime
          N'suser' , -- UPDATE_USER_TX - nvarchar(15)
          1  -- LOCK_ID - tinyint
        )


		INSERT dbo.USER_SECURITY_GROUP_RELATE
        ( SEC_GRP_ID ,
          USER_ID ,
          CREATE_DT ,
          UPDATE_DT ,
          PURGE_DT ,
          UPDATE_USER_TX ,
          LOCK_ID
        )
VALUES  ( '4',  -- SEC_GRP_ID - bigint
          '239' , -- USER_ID - bigint
          GETDATE() , -- CREATE_DT - datetime
          GETDATE() , -- UPDATE_DT - datetime
          NULL, -- PURGE_DT - datetime
          N'suser' , -- UPDATE_USER_TX - nvarchar(15)
          1  -- LOCK_ID - tinyint
        )


		UPDATE dbo.USERS
		SET PURGE_DT = NULL
		WHERE ID = '239'