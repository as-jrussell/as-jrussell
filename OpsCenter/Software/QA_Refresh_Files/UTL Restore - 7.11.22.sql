================================================================================
USE [master]
GO
DECLARE @returnCode int


EXEC   @returnCode = dbo.emc_run_restore ' -a NSR_DFA_SI_DD_HOST=ON-DD9300-01 -a NSR_DFA_SI_DD_USER=ddboost -a NSR_DFA_SI_DEVICE_PATH=/SQL_PROD -a "NSR_DFA_SI_DD_LOCKBOX_PATH=C:\Program Files\DPSAPPS\common\lockbox" -c utl-sql-01.colo.as.local -a "DDBOOST_COMPRESSED_RESTORE=TRUE" -a "SKIP_CLIENT_RESOLUTION=TRUE" -C "''UTL''=''F:\SQLData\UTL.mdf'', ''UTL_log''=''E:\SQLLOG\UTL_log.ldf''" -f -t "07/11/2022 12:44:20 AM" -S normal -d MSSQL:UTL MSSQL:UTL'
IF @returnCode <> 0
BEGIN
RAISERROR ('Fail!', 16, 1)
END
================================================================================



(23 row(s) affected)
Start time: Tue Jul 12 14:45:17 2022

Computer name: UTSTAGE-UTL1     User name: Unitrac-DaemonQA

Check the detailed logs that are located at 'E:\Program Files\DPSAPPS\MSAPPAGENT\logs\ddbmsqlrc.log'.
The 'Skip client resolution' option is set to true. Client name 'utl-sql-01.colo.as.local' will be used for recovery.

Version information for E:\Program Files\DPSAPPS\MSAPPAGENT\bin\ddbmsqlrc.exe:	Original file name: ddbmsqlrc.exe	Version: 19.4.0.0.Build.21	Comments: A Dell EMC product that allows backup and recovery of Microsoft applications

52701:ddbmsqlrc: Command line:
  E:\Program Files\DPSAPPS\MSAPPAGENT\bin\ddbmsqlrc.exe -a NSR_DFA_SI_DD_HOST=ON-DD9300-01 -a NSR_DFA_SI_DD_USER=ddboost -a NSR_DFA_SI_DEVICE_PATH=/SQL_PROD -a NSR_DFA_SI_DD_LOCKBOX_PATH=C:\Program Files\DPSAPPS\common\lockbox -c utl-sql-01.colo.as.local -a DDBOOST_COMPRESSED_RESTORE=TRUE -a SKIP_CLIENT_RESOLUTION=TRUE -C 'UTL'='F:\SQLData\UTL.mdf', 'UTL_log'='E:\SQLLOG\UTL_log.ldf' -f -t 07/11/2022 12:44:20 AM -S normal -d MSSQL:UTL MSSQL:UTL 

DD_SERVER : ON-DD9300-01
.
Recovering database 'UTL' into 'UTL' ...

158892:ddbmsqlrc: Instant file initialization is enabled.

RESTORE database [UTL] FROM virtual_device='EMC#1da0912f-ac7b-4cf7-91d8-c7a1b4e10c32', virtual_device='EMC#1da0912f-ac7b-4cf7-91d8-c7a1b4e10c32_2', virtual_device='EMC#1da0912f-ac7b-4cf7-91d8-c7a1b4e10c32_3', virtual_device='EMC#1da0912f-ac7b-4cf7-91d8-c7a1b4e10c32_4', virtual_device='EMC#1da0912f-ac7b-4cf7-91d8-c7a1b4e10c32_5', virtual_device='EMC#1da0912f-ac7b-4cf7-91d8-c7a1b4e10c32_6', virtual_device='EMC#1da0912f-ac7b-4cf7-91d8-c7a1b4e10c32_7', virtual_device='EMC#1da0912f-ac7b-4cf7-91d8-c7a1b4e10c32_8'  WITH move 'UTL' to 'F:\SQLData\UTL.mdf', move 'UTL_log' to 'E:\SQLLOG\UTL_log.ldf', replace, maxtransfersize = 4194304 

Successfully established the direct file retrieval session for backup ID '1657515719' with 'Data Domain' device path '/SQL_PROD'.
Successfully established the direct file retrieval session for backup ID '1657515722' with 'Data Domain' device path '/SQL_PROD'.
Successfully established the direct file retrieval session for backup ID '1657515721' with 'Data Domain' device path '/SQL_PROD'.
Successfully established the direct file retrieval session for backup ID '1657515720' with 'Data Domain' device path '/SQL_PROD'.
Successfully established the direct file retrieval session for backup ID '1657515716' with 'Data Domain' device path '/SQL_PROD'.
Successfully established the direct file retrieval session for backup ID '1657515718' with 'Data Domain' device path '/SQL_PROD'.
Successfully established the direct file retrieval session for backup ID '1657515717' with 'Data Domain' device path '/SQL_PROD'.
Successfully established the direct file retrieval session for backup ID '1657515723' with 'Data Domain' device path '/SQL_PROD'.
Processed 299862520 pages for database 'UTL', file 'UTL' on file 1.

The restore of database 'UTL' completed successfully.

Stop time: Tue Jul 12 16:36:18 2022



