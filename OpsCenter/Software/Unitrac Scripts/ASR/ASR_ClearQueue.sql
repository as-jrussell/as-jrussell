declare @c uniqueidentifier
while(1=1)
begin
    select top 1 @c = conversation_handle from dbo.UBSReadyToExecuteQueue where QUEUING_ORDER = 29822
 
    if (@@ROWCOUNT = 0) 
    break
    end conversation @c with cleanup
end





-------------------------------------------------------------
---------------------------------------------------------------



DECLARE @conversation uniqueidentifier 
DECLARE @cnt int; 
SET @cnt = 0; 
 
--** Cleanup transmission queue. 
DECLARE MsgCursor CURSOR LOCAL FOR 
    SELECT [conversation_handle] 
    FROM sys.transmission_queue 
    -- Add where filter for your purpose e.g. on service name or message type. 
 
-- Open the cursor 
OPEN MsgCursor; 
     
FETCH NEXT FROM MsgCursor 
    INTO @conversation; 
WHILE @@FETCH_STATUS = 0 
BEGIN 
    -- End conversation with cleanup. 
    END CONVERSATION @conversation WITH CLEANUP; 
 
    SET @cnt = @cnt + 1; 
    FETCH NEXT FROM MsgCursor 
        INTO @conversation; 
END; 
 
CLOSE MsgCursor; 
DEALLOCATE MsgCursor; 
PRINT CONVERT(varchar(10), @cnt) + ' Messages removed from transmission queue.'; 
 
 
--** Cleanup conversation endpoint. 
SET @cnt = 0; 
 
DECLARE MsgCursor CURSOR LOCAL FOR 
    SELECT [conversation_handle] 
    FROM sys.conversation_endpoints 
    -- Add where filter for your purpose. 
 
-- Open the cursor 
OPEN MsgCursor; 
     
FETCH NEXT FROM MsgCursor 
    INTO @conversation; 
WHILE @@FETCH_STATUS = 0 
BEGIN 
    -- End conversation with cleanup. 
    END CONVERSATION @conversation WITH CLEANUP; 
 
    SET @cnt = @cnt + 1; 
    FETCH NEXT FROM MsgCursor 
        INTO @conversation; 
END; 
 
CLOSE MsgCursor; 
DEALLOCATE MsgCursor; 
PRINT CONVERT(varchar(10), @cnt) + ' Messages removed from conversation endpoint.';
