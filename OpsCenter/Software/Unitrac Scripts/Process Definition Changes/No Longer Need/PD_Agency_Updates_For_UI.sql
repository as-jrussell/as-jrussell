INSERT  INTO RELATED_DATA
        ( DEF_ID ,
          RELATE_ID ,
          VALUE_TX ,
          START_DT ,
          END_DT ,
          COMMENT_TX ,
          CREATE_DT ,
          UPDATE_DT ,
          UPDATE_USER_TX ,
          LOCK_ID
        )
        SELECT  116 ,
                pd.ID ,
                '1' ,
                GETDATE() ,
                NULL ,
                'AgencyFilter' ,
                GETDATE() ,
                GETDATE() ,
                'SCRIPT' ,
                1
        FROM    PROCESS_DEFINITION pd
        WHERE   pd.ID IN ( 70585, 68432, 69899. )
        ORDER BY pd.CREATE_DT DESC


SELECT * FROM UniTrac..RELATED_DATA
WHERE DEF_ID = 116
AND CREATE_DT > '2014-07-11' 
AND RELATE_ID IN (68432,69899,70585)

