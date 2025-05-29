DECLARE @Server VARCHAR(100) = 'TIMMAY'

SELECT Concat('declare @srvr nvarchar(128), @retval int;
set @srvr =''', [Data_Source], ''' 
begin try
    exec @retval = sys.sp_testlinkedserver @srvr;
end try
begin catch
    set @retval = sign(@@error);
end catch;
if @retval <> 0
print 
''Dropping Server ''+@srvr+ ''''
if @retval <> 0
EXEC master.dbo.sp_dropserver @server= @srvr,@droplogins=''droplogins''
')
FROM   [InventoryDWH].[inv].[LinkedServer] LNK
       JOIN [InventoryDWH].[inv].[instance] AS INST
         ON ( LNK.InstanceID = INST.ID )
WHERE  Cast(LNK.HarvestDate AS DATE) >= Cast(Getdate() AS DATE)
       AND LNK.[Status] != 'Valid'
       AND inst.MachineName = @Server
       AND Provider_string NOT LIKE 'Integrated Security=SSPI;Data Source=OCR-PRD%-LISTEN;ApplicationIntent=ReadOnly'


