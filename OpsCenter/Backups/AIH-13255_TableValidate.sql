use AppLog


DECLARE @Start datetime = (select max(modified) from [AppLog].[dbo].[Applog_New])
DECLARE @END datetime = (select GETDATE())



SELECT [GUID]
           ,[Service_User_Name]
           ,[Service_Source_Code]
           ,[Service_Name]
           ,[Service_Method]
           ,[Client_ID_Number]
           ,[VUT_Lender_ID]
           ,[Started]
           ,[Finished]
           ,[Created]
           ,[Modified]
           ,[UserID]
           ,[CurrentUser]
           ,[Input]
           ,[Output]
           ,[Comment1]
           ,[Comment2]
           ,[Comment3]
		   --select count(*)
FROM [AppLog].[dbo].[Applog_New]
where Modified  BETWEEN @Start AND @END
