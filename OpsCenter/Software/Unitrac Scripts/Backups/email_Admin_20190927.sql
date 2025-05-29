USE [INFA_DX]
GO

/****** Object:  StoredProcedure [dbo].[email_Admin]    Script Date: 9/27/2019 11:30:25 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[email_Admin]  (@body as varchar(6000), @attachment as varchar(1000)=NULL )

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	Declare @efrom as varchar(500)
	Declare @subject as varchar(500)
	Declare @eto as varchar(5000)


	Select @efrom = 'UT_SQL@alliedsolutions.net',
	@subject = 'Production: Informatica Error Vehicle Lookup Service', 
	@eto = 'benjamin.helmuth@alliedsolutions.net;joseph.russell@alliedsolutions.net;mike.breitsch@alliedsolutions.net'


	DECLARE @object int
	Declare @hr as int

	EXEC @hr = sp_OACreate 'CDO.Message', @object OUT

	EXEC @hr = sp_OASetProperty @object, 'Configuration.fields("http://schemas.microsoft.com/cdo/configuration/sendusing").Value','2' 
	EXEC @hr = sp_OASetProperty @object, 'Configuration.fields("http://schemas.microsoft.com/cdo/configuration/smtpserver").Value', '10.10.18.28' 

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

