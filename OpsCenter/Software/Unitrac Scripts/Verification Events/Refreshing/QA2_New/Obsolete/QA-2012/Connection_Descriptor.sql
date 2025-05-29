select * from UniTrac..CONNECTION_DESCRIPTOR

update UniTrac..CONNECTION_DESCRIPTOR
set SERVER_TX = 'TIMMAY',USERNAME_TX = 'ZgBwzSipNRcoC9/PZusaW8vD6v4cc94w',PASSWORD_TX = '4vidTVu/NaUfPRXjVxSvQchJuE2KY2CSRY1HUz5JJDfIvnNuy4/JIs7MMMuS/qMU'
WHERE ID = 3 AND NAME_TX = 'VUT_Agency'

----------------------

INSERT INTO UniTrac..CONNECTION_DESCRIPTOR
        ( NAME_TX ,
          PROVIDER_TX ,
          SERVER_TX ,
          DATABASE_NM ,
          USERNAME_TX ,
          PASSWORD_TX ,
          CONNECTION_LIMIT ,
          CREATE_DT ,
          UPDATE_DT ,
          PURGE_DT ,
          UPDATE_USER ,
          LOCK_ID
        )
VALUES  ( N'MID_HIST' , -- NAME_TX - nvarchar(30)
          N'SS' , -- PROVIDER_TX - nvarchar(50)
          'VUT-DB01' , -- SERVER_TX - varchar(30)
          N'MIDHistory' , -- DATABASE_NM - nvarchar(30)
          N'FW2wo5M97wcPwV+C76GNYr55ZTBarjk4' , -- USERNAME_TX - nvarchar(100)
          N'fPhPxSZpTymGyI2JzA0i/PNfkh1KmAWmS9UgD+WRTs8=' , -- PASSWORD_TX - nvarchar(100)
          080 , -- CONNECTION_LIMIT - int
          GETDATE() , -- CREATE_DT - datetime
          GETDATE() , -- UPDATE_DT - datetime
          NULL , -- PURGE_DT - datetime
          N'admin' , -- UPDATE_USER - nvarchar(15)
          1  -- LOCK_ID - numeric
        )