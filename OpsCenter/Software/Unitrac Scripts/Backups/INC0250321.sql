
SELECT * FROM dbo.USERS
WHERE FAMILY_NAME_TX = 'Butterbaugh'



INSERT dbo.USERS
        ( USER_NAME_TX ,
          PASSWORD_TX ,
          FAMILY_NAME_TX ,
          GIVEN_NAME_TX ,
          ACTIVE_IN ,
          EMAIL_TX ,
          EXTERN_MAINT_IN ,
          LOGIN_COUNT_NO ,
          LAST_LOGIN_DT ,
          DEFAULT_AGENCY_ID ,
          SYSTEM_IN ,
          PASSWORD_SET_DT ,
          IS_LOCKED_OUT_IN ,
          CREATE_DT ,
          UPDATE_DT ,
          PURGE_DT ,
          UPDATE_USER_TX ,
          LOCK_ID
        )
VALUES  ( N'KButterbaugh' , -- USER_NAME_TX - nvarchar(50)
          N'iLujyDVL/BEYlsBJlaXwwvYU9ovzI2RWOqR5TwTt05g=' , -- PASSWORD_TX - nvarchar(256)
          N'Butterbaugh' , -- FAMILY_NAME_TX - nvarchar(50)
          N'Kevin' , -- GIVEN_NAME_TX - nvarchar(30)
          'Y' , -- ACTIVE_IN - char(1)
          N'Kevin.Butterbaugh@alliedsolutions.net' , -- EMAIL_TX - nvarchar(100)
          'N' , -- EXTERN_MAINT_IN - char(1)
          '0' , -- LOGIN_COUNT_NO - numeric
          NULL , -- LAST_LOGIN_DT - datetime
          1 , -- DEFAULT_AGENCY_ID - bigint
          'N' , -- SYSTEM_IN - char(1)
          NULL , -- PASSWORD_SET_DT - datetime
          'N' , -- IS_LOCKED_OUT_IN - char(1)
          GETDATE() , -- CREATE_DT - datetime
          GETDATE() , -- UPDATE_DT - datetime
          NULL , -- PURGE_DT - datetime
          N'INC0250321' , -- UPDATE_USER_TX - nvarchar(15)
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
VALUES  ( 2 , -- SEC_GRP_ID - bigint
          32 , -- USER_ID - bigint
          GETDATE() , -- CREATE_DT - datetime
          GETDATE() , -- UPDATE_DT - datetime
          NULL, -- PURGE_DT - datetime
          N'INC0250321' , -- UPDATE_USER_TX - nvarchar(15)
          1  -- LOCK_ID - tinyint
        )




SELECT * FROM dbo.USER_SECURITY_GROUP_RELATE
WHERE USER_ID = '23'



SELECT * FROM UniTrac.dbo.USERS
WHERE FAMILY_NAME_TX = 'Butterbaugh'