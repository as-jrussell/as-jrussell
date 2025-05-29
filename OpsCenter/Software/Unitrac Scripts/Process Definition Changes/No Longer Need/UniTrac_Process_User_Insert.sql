INSERT INTO UniTrac..USERS
        ( USER_NAME_TX ,
          PASSWORD_TX ,
          FAMILY_NAME_TX ,
          GIVEN_NAME_TX ,
          ACTIVE_IN ,
          EMAIL_TX ,
          EXTERN_MAINT_IN ,
          LOGIN_COUNT_NO ,
          LAST_LOGIN_DT ,
          CREATE_DT ,
          UPDATE_DT ,
          PURGE_DT ,
          UPDATE_USER_TX ,
          LOCK_ID ,
          DEFAULT_AGENCY_ID ,
          SYSTEM_IN
        )
VALUES  ( N'DashUsr' , -- USER_NAME_TX - nvarchar(50)
          N'OOo2uY6cqEVRVagK2TRCCg==' , -- PASSWORD_TX - nvarchar(50)
          N'Server' , -- FAMILY_NAME_TX - nvarchar(50)
          N'DashUsr' , -- GIVEN_NAME_TX - nvarchar(30)
          'Y' , -- ACTIVE_IN - char(1)
          NULL , -- EMAIL_TX - nvarchar(100)
          'N' , -- EXTERN_MAINT_IN - char(1)
          NULL , -- LOGIN_COUNT_NO - numeric
          GETDATE() , -- LAST_LOGIN_DT - datetime
          GETDATE() , -- CREATE_DT - datetime
          GETDATE() , -- UPDATE_DT - datetime
          NULL , -- PURGE_DT - datetime
          N'admin' , -- UPDATE_USER_TX - nvarchar(15)
          1 , -- LOCK_ID - tinyint
          1 , -- DEFAULT_AGENCY_ID - bigint
          NULL  -- SYSTEM_IN - char(1)
        )
        
SELECT * FROM UniTrac..USERS
WHERE FAMILY_NAME_TX = 'Server'

SELECT * FROM UniTrac..AGENCY_USER_RELATE

INSERT INTO UniTrac..AGENCY_USER_RELATE
        ( USER_ID ,
          AGENCY_ID ,
          CREATE_DT ,
          UPDATE_DT ,
          PURGE_DT ,
          UPDATE_USER_TX ,
          LOCK_ID
        )
VALUES  ( 1869 , -- USER_ID - bigint
          1 , -- AGENCY_ID - bigint
          GETDATE() , -- CREATE_DT - datetime
          GETDATE() , -- UPDATE_DT - datetime
          NULL , -- PURGE_DT - datetime
          N'script' , -- UPDATE_USER_TX - nvarchar(15)
          1  -- LOCK_ID - tinyint
        )