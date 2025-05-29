USE [UniTrac]
GO

/****** Object:  StoredProcedure [dbo].[EMAIL_OCR_COUNT]    Script Date: 12/9/2019 11:11:05 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[EMAIL_OCR_COUNT] 
	-- Add the parameters for the stored procedure here

	(@body as varchar(6000), @attachment as varchar(1000)=NULL )


AS
BEGIN

Declare @efrom as varchar(500)
Declare @subject as varchar(500)
Declare @eto as varchar(5000)


Select @efrom = 'UT_SQL@alliedsolutions.net',
@subject = 'OCR STATUS COUNT FOR LAST 2 HOURS', 
@eto = 'benjamin.helmuth@alliedsolutions.net;john.martin@alliedsolutions.net;mike.breitsch@alliedsolutions.net;krystle.swanson@alliedsolutions.net;laura.abrams@alliedsolutions.net;lynda.carr@alliedsolutions.net;cynthia.clark@alliedsolutions.net;cindy.pierson@alliedsolutions.net'


DECLARE @object int
Declare @hr as int

EXEC @hr = sp_OACreate 'CDO.Message', @object OUT

EXEC @hr = sp_OASetProperty @object, 'Configuration.fields("http://schemas.microsoft.com/cdo/configuration/sendusing").Value','2' 
EXEC @hr = sp_OASetProperty @object, 'Configuration.fields("http://schemas.microsoft.com/cdo/configuration/smtpserver").Value', 'mailrelay.alliedsolutions.net' 

--EXEC @hr = sp_OASetProperty @object, 'Configuration.fields ("http://schemas.microsoft.com/cdo/configuration/sendusing").Value','1'
EXEC @hr = sp_OAMethod @object, 'Configuration.Fields.Update', null

EXEC @hr = sp_OASetProperty @object, 'From',@efrom
EXEC @hr = sp_OASetProperty @object, 'TextBody', @body
EXEC @hr = sp_OASetProperty @object, 'Subject', @subject
EXEC @hr = sp_OASetProperty @object, 'To', @eto
EXEC @hr = sp_OASetProperty @object, 'MailFormat', 0
if @attachment is not null
EXEC @hr = sp_OAMethod @object, 'AddAttachment', NULL, @attachment
EXEC @hr = sp_OAMethod @object, 'Send', NULL
EXEC @hr = sp_OADestroy @object
END

GO

