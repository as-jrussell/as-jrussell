SELECT * FROM UniTrac..REF_CODE
WHERE DOMAIN_CD = 'ServiceCenter'

SELECT * FROM UniTrac..REF_CODE_ATTRIBUTE
WHERE DOMAIN_CD LIKE 'Service%'

INSERT INTO UniTrac..REF_CODE
        ( CODE_CD ,
          DOMAIN_CD ,
          MEANING_TX ,
          DESCRIPTION_TX ,
          ACTIVE_IN ,
          CREATE_DT ,
          UPDATE_DT ,
          PURGE_DT ,
          UPDATE_USER_TX ,
          LOCK_ID ,
          AGENCY_ID ,
          ORDER_NO
        )
VALUES  ( N'Napa' , -- CODE_CD - nvarchar(50)
          N'ServiceCenter' , -- DOMAIN_CD - nvarchar(30)
          N'Napa' , -- MEANING_TX - nvarchar(1000)
          N'Service Center at Napa' , -- DESCRIPTION_TX - nvarchar(1000)
          'Y' , -- ACTIVE_IN - char(1)
          GETDATE() , -- CREATE_DT - datetime
          GETDATE() , -- UPDATE_DT - datetime
          NULL , -- PURGE_DT - datetime
          N'INC0182837' , -- UPDATE_USER_TX - nvarchar(15)
          1 , -- LOCK_ID - tinyint
          0 , -- AGENCY_ID - bigint
          999  -- ORDER_NO - int
        )