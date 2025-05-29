USE [UniTrac]
GO

/****** Object:  StoredProcedure [dbo].[UT_GetPDErrorInfo_Email]    Script Date: 5/20/2016 11:57:34 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [dbo].[UT_GetPDErrorInfo_Email]
    (
      @body AS VARCHAR(6000) ,
      @attachment AS VARCHAR(1000) = NULL 
    )
AS 
    SET NOCOUNT ON

    DECLARE @efrom AS VARCHAR(500)
    DECLARE @subject AS VARCHAR(500)
    DECLARE @eto AS VARCHAR(5000)

    SELECT  @efrom = 'UT_SQL@alliedsolutions.net' ,
            @subject = 'UniTrac Process Defintions In Error' ,
            @eto = 'Mike.Breitsch@alliedsolutions.net, Tim.Holtz@alliedsolutions.net,Wendy.Walker@alliedsolutions.net,Joseph.Russell@alliedsolutions.net'

    DECLARE @object INT
    DECLARE @hr AS INT

    EXEC @hr = sp_OACreate 'CDO.Message', @object OUT

    EXEC @hr = sp_OASetProperty @object,
        'Configuration.fields("http://schemas.microsoft.com/cdo/configuration/sendusing").Value',
        '2' 
    EXEC @hr = sp_OASetProperty @object,
        'Configuration.fields("http://schemas.microsoft.com/cdo/configuration/smtpserver").Value',
        '10.10.18.28' 

--EXEC @hr = sp_OASetProperty @object, 'Configuration.fields ("http://schemas.microsoft.com/cdo/configuration/sendusing").Value','1'
    EXEC @hr = sp_OAMethod @object, 'Configuration.Fields.Update', NULL

    EXEC @hr = sp_OASetProperty @object, 'From', @efrom
    EXEC @hr = sp_OASetProperty @object, 'TextBody', @body
    EXEC @hr = sp_OASetProperty @object, 'Subject', @subject
    EXEC @hr = sp_OASetProperty @object, 'To', @eto
    EXEC @hr = sp_OASetProperty @object, 'MailFormat', 0
    IF @attachment IS NOT NULL 
        EXEC @hr = sp_OAMethod @object, 'AddAttachment', NULL, @attachment
    EXEC @hr = sp_OAMethod @object, 'Send', NULL
    EXEC @hr = sp_OADestroy @object




GO

