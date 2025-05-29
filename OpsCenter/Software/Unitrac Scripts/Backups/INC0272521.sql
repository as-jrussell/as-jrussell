USE OspreyDashboard


SELECT * FROM dbo.DATASOURCE_CACHE_LOOKUP	


EXEC dbo.EnableLender @LENDER_CD = '2777' -- varchar(50)



INSERT  INTO DATASOURCE_CACHE_LOOKUP
        ( LOOKUP_KEY_CD ,
          LOOKUP_VALUE ,
          CREATE_DT ,
          UPDATE_DT ,
          UPDATE_USER_TX ,
          LOCK_ID
        )
VALUES  ( 'LENDER_CODE' ,
          '2777' ,
          GETDATE() ,
          GETDATE() ,
          'Script' ,
          1
        )
