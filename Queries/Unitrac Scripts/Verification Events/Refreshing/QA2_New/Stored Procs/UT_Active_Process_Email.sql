USE [UniTrac]
GO

/****** Object:  StoredProcedure [dbo].[UT_Active_Processes_Email]    Script Date: 9/18/2017 7:50:38 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





CREATE PROCEDURE [dbo].[UT_Active_Processes_Email]  (@body as varchar(6000), @attachment as varchar(1000)=NULL )AS


SET NOCOUNT ON

Declare @efrom as varchar(500)
Declare @subject as varchar(500)
Declare @eto as varchar(5000)

Select @efrom = 'no-reply-unitrac@alliedsolutions.net',
@subject = 'Current Active Cycle/Escrow/Billing/EOM Processes in QA2', 
@eto = 'PMO-QA@alliedsolutions.net, ITAdmins-UniTrac@alliedsolutions.net, Nicholas.Schaub@alliedsolutions.net'
--@eto = 'Mike.Breitsch@alliedsolutions.net, Joseph.Russell@alliedsolutions.net, Padma.Balakrishnan@alliedsolutions.net, Neelima.Dobbala@alliedsolutions.net, Sirisha.Boddupally@alliedsolutions.net, Sudha.Thapaliya@alliedsolutions.net, Saraswati.Subedi@alliedsolutions.net,Wendy.Walker@alliedsolutions.net, Nicholas.Schaub@alliedsolutions.net, Benjamin.Helmuth@alliedsolutions.net, Anthony.Newbern@alliedsolutions.net'
--@eto = 'Mike.Breitsch@alliedsolutions.net'


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


GO
