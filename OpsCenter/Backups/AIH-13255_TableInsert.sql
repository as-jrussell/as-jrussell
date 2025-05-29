USE [AppLog]
GO

DECLARE @Start datetime = (select max(modified) from [AppLog].[dbo].[Applog_New])
DECLARE @END datetime = (select GETDATE())



IF NOT EXISTS (select 1 from [AppLog].[dbo].[Applog] WHERE [Modified] BETWEEN @Start AND @END)
BEGIN 
INSERT INTO [AppLog].[dbo].[Applog]
           ([GUID]
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
           ,[Comment3])	   			 
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
		   --select top 1 *
FROM [AppLog].[dbo].[Applog_old]
where Modified  BETWEEN @Start AND @END
PRINT 'SUCCESS: DATA COPIED OVER'
END
ELSE

BEGIN

PRINT 'WARNING: CHECK YOUR DATA PLEASE THERE IS A PROBLEM!!!'

END

