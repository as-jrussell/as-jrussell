	
		DECLARE db_cursor CURSOR FOR  
		select  ppd.ID

from PREPROCESSING_DETAIL ppd 
where ppd.TYPE_CD in ('TrackingCH', 'Informatica')
and ppd.PURGE_DT IS null 
and ppd.ID not in ( select ppd.id
		from PPDATTRIBUTE pp
		join PREPROCESSING_DETAIL ppd on ppd.ID = pp.PREPROCESSING_DETAIL_ID and pp.PURGE_DT IS null and ppd.PURGE_DT IS null 
		where ppd.TYPE_CD in ('TrackingCH', 'Informatica')
		and pp.CODE_CD = 'SpecialMultiCollMatch')
				
		
		
		
DECLARE @PDID AS bigint

OPEN db_cursor   
FETCH NEXT FROM db_cursor INTO @PDID   

WHILE @@FETCH_STATUS = 0   
BEGIN   

 INSERT INTO [dbo].[PPDATTRIBUTE]
           ([PREPROCESSING_DETAIL_ID]
           ,[VALUE_TX]
           ,[CODE_CD]
           ,[CREATE_DT]
           ,[UPDATE_DT]
           ,[UPDATE_USER_TX]
           ,[PURGE_DT]
           ,[LOCK_ID]
           ,[VALUE_XML]
           ,[COMMON_STYLESHEET_ID])
     values
           (@PDID
           ,''
           ,'SpecialMultiCollMatch'
           ,getdate()
           ,getdate()
           ,'Bug36343'
           ,NULL
           ,1
           ,''
           ,0)
           
           
           FETCH NEXT FROM db_cursor INTO @PDID
 
END   
CLOSE db_cursor
DEALLOCATE db_cursor