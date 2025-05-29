USE [msdb];

SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED



DECLARE @SQLVersion SQL_VARIANT,
        @AlertName nvarchar(256) = 'PerMon-IOerror',
        @EnableNewAlerts BIT = 0,
		@CategoryName nvarchar(100) = '[Uncategorized]', -- would prefer some day 'PerfStats',
		@JobName nvarchar(256) = 'PerMon-IOerror',  -- Alert: sp_whoisactive Capture
		@OperatorName nvarchar(100) = 'DBAlert'
DECLARE @condition nvarchar(512)

/*Check the version of SQL, if not 2012 and up just return and not deploy*/
SELECT @SQLVersion = SERVERPROPERTY('ProductMajorVersion');



IF( (CAST(@SQLVersion AS INT) < 11) OR (@SQLVersion IS NULL) OR ((select @@version) like '%AZURE%') )
BEGIN
    RETURN;
END;

/* Default on for PROD */
IF( (SELECT [DBA].[info].[GetSystemConfig] ('Server.Environment' ,'PROD')) = 'PROD' )  SET @EnableNewAlerts = 1

/*Check if the alert exists and create if it doesn't */
IF NOT EXISTS(SELECT name FROM msdb.dbo.sysalerts WHERE name = @AlertName)
    BEGIN
	    EXEC msdb.dbo.sp_add_alert 
		    @name = @AlertName, 
		    @message_id=833, 
		    @severity=1, 
		    @enabled = 0, 
		    @delay_between_responses=0, 
		    @include_event_description_in=0, 
		    @job_id=N'00000000-0000-0000-0000-000000000000';
    END
ELSE
	BEGIN
		/* Does alert exist - maintain current status */
		SELECT @EnableNewAlerts = enabled FROM msdb.dbo.sysalerts WHERE name = @AlertName
	END

/* Update Alert definition */
EXEC msdb.dbo.sp_update_alert 
	@name = @AlertName, 
	@message_id=833,
	@severity=0,
	@enabled = @EnableNewAlerts, 
	@delay_between_responses=3600, 
	@include_event_description_in=1, 
	@notification_message=N'Need data to be added here',
	@category_name = @CategoryName, 
	@performance_condition=N'', 
	@job_id=N'00000000-0000-0000-0000-000000000000';
	--@job_Name = @JobName

/* Alert Notification existence check */
IF NOT EXISTS (	SELECT * from msdb.dbo.sysalerts AS SA 
					LEFT JOIN msdb.dbo.sysnotifications AS SN ON (SA.ID = SN.alert_id)
					LEFT JOIN msdb..sysoperators AS SO ON (SN.operator_id = SO.id )
				WHERE SA.name = @AlertName AND SO.name = @OperatorName )
BEGIN
	EXEC msdb.dbo.sp_add_notification @alert_name = @AlertName, @operator_name = @OperatorName, @notification_method = 1
END

/* Drop old version */
IF EXISTS(SELECT * from msdb.dbo.sysalerts where name = 'DBA-IOerrors')
BEGIN
	EXEC msdb.dbo.sp_delete_alert @name=N'DBA-IOerrors';
END

