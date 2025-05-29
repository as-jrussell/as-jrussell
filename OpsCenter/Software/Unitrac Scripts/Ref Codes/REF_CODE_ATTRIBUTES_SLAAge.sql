SELECT * FROM UniTrac..REF_CODE_ATTRIBUTE
WHERE DOMAIN_CD = 'SLAAge'
--AND attribute_cd = 'Condition'
ORDER BY ID
--ORDER BY REF_CD,ATTRIBUTE_CD
--AND REF_CD = 'RULE1'

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
VALUES  ( N'Condition' , -- ATTRIBUTE_CD - nvarchar(30)
          N'RULE11' , -- REF_CD - nvarchar(50)
          N'SLAAge' , -- DOMAIN_CD - nvarchar(30)
          N'336' , -- VALUE_TX - nvarchar(100)
          '2013-08-22 12:00:00' , -- CREATE_DT - datetime
          '2013-08-22 12:00:00' , -- UPDATE_DT - datetime
          NULL , -- PURGE_DT - datetime
          N'admin' , -- UPDATE_USER_TX - nvarchar(15)
          1 , -- LOCK_ID - tinyint
          0  -- AGENCY_ID - bigint
        )
        
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
VALUES  ( N'Operator' , -- ATTRIBUTE_CD - nvarchar(30)
          N'RULE11' , -- REF_CD - nvarchar(50)
          N'SLAAge' , -- DOMAIN_CD - nvarchar(30)
          N'gt' , -- VALUE_TX - nvarchar(100)
          '2013-08-22 12:00:00' , -- CREATE_DT - datetime
          '2013-08-22 12:00:00' , -- UPDATE_DT - datetime
          NULL , -- PURGE_DT - datetime
          N'admin' , -- UPDATE_USER_TX - nvarchar(15)
          1 , -- LOCK_ID - tinyint
          0  -- AGENCY_ID - bigint
        ) 
        
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
VALUES  ( N'Type' , -- ATTRIBUTE_CD - nvarchar(30)
          N'RULE11' , -- REF_CD - nvarchar(50)
          N'SLAAge' , -- DOMAIN_CD - nvarchar(30)
          N'WorkItemAge' , -- VALUE_TX - nvarchar(100)
          '2013-08-22 12:00:00' , -- CREATE_DT - datetime
          '2013-08-22 12:00:00' , -- UPDATE_DT - datetime
          NULL , -- PURGE_DT - datetime
          N'admin' , -- UPDATE_USER_TX - nvarchar(15)
          1 , -- LOCK_ID - tinyint
          0  -- AGENCY_ID - bigint
        )                  
        
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
VALUES  ( N'Unit' , -- ATTRIBUTE_CD - nvarchar(30)
          N'RULE11' , -- REF_CD - nvarchar(50)
          N'SLAAge' , -- DOMAIN_CD - nvarchar(30)
          N'Hours' , -- VALUE_TX - nvarchar(100)
          '2013-08-22 12:00:00' , -- CREATE_DT - datetime
          '2013-08-22 12:00:00' , -- UPDATE_DT - datetime
          NULL , -- PURGE_DT - datetime
          N'admin' , -- UPDATE_USER_TX - nvarchar(15)
          1 , -- LOCK_ID - tinyint
          0  -- AGENCY_ID - bigint
        )  
        
        
 UPDATE UniTrac..REF_CODE_ATTRIBUTE
 SET PURGE_DT = NULL
 WHERE ID IN (9767,9768,9769,9770)        