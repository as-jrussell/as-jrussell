USE [DBA]
GO

/****** Object:  StoredProcedure [alert].[Send]    Script Date: 11/25/2020 10:06:08 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [alert].[Send] 

AS
BEGIN
    DECLARE @msg nvarchar(4000)
    DECLARE @From nvarchar(128)
    Declare @MailRecipients as nvarchar(3000)
    Declare @Subject nvarchar(256)      
    Declare @FilterWhereClause as nvarchar(3000)
    Declare @str as nvarchar(max)
    DECLARE @DBMailProfile nvarchar(256), @AlertCount int
    DECLARE @AlertTime datetime, @MaxSev int
    DECLARE @ErrorNumber varchar(10), @now datetime, @LastRunTime datetime
    DECLARE @SendQuery nvarchar(max)
    DECLARE @ResultsString varchar(max) 
    Declare @Body varchar(max)
    set @ResultsString = ''
    set @now = getdate()
    Select @DBMailProfile = [PL_ParamValue] from [alert].[Parameters] where [PL_ParamName] = 'MailProfile' and [PL_Scope] = 'All'
    CREATE TABLE ##AlertSends(
                AL_ID INT,
                DB [nvarchar](200) ,
                [Server] [nvarchar](200),
                AlertTime datetime ,
                [Severity] [int] ,
                [Error] [int] ,
                [Message] [nvarchar](3000) 
)
    CREATE TABLE ##ExcludeSends(
                AL_ID int,
                DB [nvarchar](200) ,
                [Server] [nvarchar](200),
                AlertTime datetime ,
                [Severity] [int] ,
                [Error] [int] ,
                [Message] [nvarchar](3000) 
)
    INSERT INTO ##AlertSends(AL_ID, DB, Server, Severity, Error, Message, AlertTime)
    select al.AL_ID, al.[Database], al.Server, al.Severity, al.Error, al.Message, al.AlertTime
    --*, atr.*
    FROM [alert].[log] al
        INNER JOIN [alert].[trigger] atr ON atr.ErrorNumber = al.Error
    WHERE atr.NextRunTime < @now
    AND al.AlertTime > atr.LastRunTime
	AND ISNUMERIC(atr.ErrorNumber) = 1
    UNION ALL
    select al.AL_ID, al.[Database], al.Server, al.Severity, al.Error, al.Message, al.AlertTime
    FROM [alert].[log] al
        INNER JOIN [alert].[trigger] atr ON atr.ErrorNumber = -1
        LEFT JOIN [alert].[trigger] trchk ON trchk.ErrorNumber = al.Error
    WHERE atr.NextRunTime < @now
    AND trchk.ErrorNumber IS NULL
    AND atr.NextRunTime < @now
    AND al.AlertTime > atr.LastRunTime
	AND ISNUMERIC(atr.ErrorNumber) = 1
--  select * from ##AlertSends
    SELECT @FilterWhereClause = 'WHERE 
    '
    select @FilterWhereClause = @FilterWhereClause + ' (' + REPLACE(AF_MSG_Contains, '@message', 'Message') + ')
    OR '
    from [alert].[filters]
    WHERE AF_MSG_Contains NOT LIKE '%@time%'
    select @FilterWhereClause = LEFT(@FilterWhereClause, len(@FilterWhereClause)-3)
    --select @FilterWhereClause
    select @str = 'SELECT AL_ID, DB, Server, Severity, Error, Message, AlertTime FROM ##AlertSends ' + @FilterWhereClause
    INSERT INTO ##ExcludeSends(AL_ID, DB, Server, Severity, Error, Message, AlertTime)
    exec (@str)
    --TO SEND
    SELECT *
    FROM ##AlertSends snd
        LEFT JOIN ##ExcludeSends exc ON exc.AL_ID = snd.AL_ID
    WHERE exc.AL_ID IS NULL

    SELECT @MaxSev = max(snd.Severity), @AlertCount = count(*)
    FROM ##AlertSends snd
        LEFT JOIN ##ExcludeSends exc ON exc.AL_ID = snd.AL_ID
    WHERE exc.AL_ID IS NULL
    --select * from ##ExcludeSends

    --IF EXISTS ( SELECT Importance from [alert].[Parameters] where [PL_Scope] = (SELECT top 1 Severity from ##AlertSends) )
    If @MaxSev >= 19 
        Begin
            -- SET Email Recipients
            Select @MailRecipients = [PL_ParamValue] from [alert].[Parameters] where [PL_ParamName] = 'DBA Alerts' and [PL_Scope] = 'All'
            -- ADD Text Messsage Recipients
            Select @MailRecipients = @MailRecipients + ';' + [PL_ParamValue] from [alert].[Parameters] where [PL_ParamName] = 'DBA Alerts Text' and [PL_Scope] = 'All'  
        End
    Else
        Begin
            Select @MailRecipients = [PL_ParamValue] from [alert].[Parameters]  where [PL_ParamName] = 'DBA Alerts' and [PL_Scope] = 'All'           
        End

    SET @Subject = @@ServerName + ' ALERTS: ' + convert(varchar, @AlertCount)
    SET @msg = 'ALERTS SINCE LAST NOTIFICATION'
    SET @SendQuery = 'select snd.DB, snd.Server, snd.AlertTime, snd.Severity, snd.Error, snd.Message
    FROM ##AlertSends snd
        LEFT JOIN ##ExcludeSends exc ON exc.AL_ID = snd.AL_ID
    WHERE exc.AL_ID IS NULL'
    IF @AlertCount > 0
    BEGIN
        SET @ResultsString = CONVERT(NVARCHAR(MAX),     CONVERT (NVARCHAR (MAX),
        (
            SELECT
                 '',X.DB AS 'td'
                ,'',X.Server AS 'td'
                ,'',X.AlertTime AS 'td'
                ,'',X.Severity AS 'td'
                ,'',X.Error AS 'td'
                ,'',X.Message AS 'td'
            FROM ##AlertSends X
            LEFT JOIN ##ExcludeSends exc ON exc.AL_ID = X.AL_ID
                WHERE exc.AL_ID IS NULL
            FOR
                XML PATH ('tr')
        )
    ))
    SET @Body =
        '
            <h3><center>Alerts Since Last Notification</center></h3>
            <center>
                <table border=1 cellpadding=2>
                    <tr>
                        <th>DB</th>
                        <th>Server</th>
                        <th>AlertTime</th>
                        <th>Severity</th>
                        <th>Error</th>
                        <th>Message</th>            
                    </tr>
        '
    SET @Body = @Body+@ResultsString+
        '
                </table>
            </center>
        '
    SET @Body =
        '
            <html>
                <body>
                <style type="text/css">
                    table {font-size:8.0pt;font-family:Arial;text-align:left;}
                    tr {text-align:left;}
                </style>
        '
        +@Body+
        '
                </body>
            </html>
        '
    SET @Body = REPLACE (@Body,'<td>right_align','<td align="right">')
    EXEC msdb.dbo.sp_send_dbmail
    @profile_name = @DBMailProfile,
    @recipients = @MailRecipients, --'andy.wickman@moserit.com',--@MailRecipients,
    @importance = 'high',
    @subject = @Subject,
    @body = @Body,
    @body_format = 'HTML',
    --@query = @SendQuery,
    @query_result_header = 1
    END
    ----After trigger run, add minutes for time
    UPDATE [alert].[trigger]
    SET NextRunTime = dateadd(mi, FrequencyMinutes, @now), LastRunTime = @now
    WHERE NextRunTime < @now
	AND ISNUMERIC(ErrorNumber) = 1

    DROP TABLE ##ExcludeSends
    DROP TABLE ##AlertSends
END
GO

