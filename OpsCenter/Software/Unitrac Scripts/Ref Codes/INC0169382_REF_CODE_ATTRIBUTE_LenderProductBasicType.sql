----- INC0169382 Ref Code Add for Lender Product Basic Type (Repo Plus)

----------- Update REF_CODE Table ----------------------
SELECT * FROM UniTrac..REF_CODE
WHERE DOMAIN_CD = 'LenderProductBasicType'

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
VALUES  ( N'REPOPLUS' , -- CODE_CD - nvarchar(50)
          N'LenderProductBasicType' , -- DOMAIN_CD - nvarchar(30)
          N'Repo Plus' , -- MEANING_TX - nvarchar(1000)
          N'Repo Plus' , -- DESCRIPTION_TX - nvarchar(1000)
          'Y' , -- ACTIVE_IN - char(1)
          GETDATE() , -- CREATE_DT - datetime
          GETDATE() , -- UPDATE_DT - datetime
          NULL , -- PURGE_DT - datetime
          N'INC0169382' , -- UPDATE_USER_TX - nvarchar(15)
          2 , -- LOCK_ID - tinyint
          0 , -- AGENCY_ID - bigint
          999  -- ORDER_NO - int
        )

----------- Update REF_CODE_ATTRIBUTE Table ----------------------
SELECT * FROM UniTrac..REF_CODE_ATTRIBUTE
WHERE DOMAIN_CD = 'LenderProductBasicType'

INSERT INTO UniTrac..REF_CODE_ATTRIBUTE
        ( ATTRIBUTE_CD ,
          REF_CD ,
          DOMAIN_CD ,
          VALUE_TX ,
          CREATE_DT ,
          UPDATE_DT ,
          PURGE_DT ,
          UPDATE_USER_TX ,
          LOCK_ID ,
          AGENCY_ID
        )
VALUES  ( N'CreateVerifyData' , -- ATTRIBUTE_CD - nvarchar(30)
          N'REPOPLUS' , -- REF_CD - nvarchar(50)
          N'LenderProductBasicType' , -- DOMAIN_CD - nvarchar(30)
          N'' , -- VALUE_TX - nvarchar(100)
          GETDATE() , -- CREATE_DT - datetime
          GETDATE() , -- UPDATE_DT - datetime
          NULL , -- PURGE_DT - datetime
          N'admin' , -- UPDATE_USER_TX - nvarchar(15)
          1 , -- LOCK_ID - tinyint
          0  -- AGENCY_ID - bigint
        )
