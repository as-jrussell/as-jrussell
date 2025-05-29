-- Set the logical path of the backup files
--DECLARE @BackupPath NVARCHAR(MAX) = N'C:\Path\To\Your\BackupFiles\';
DECLARE @BackupFile1 NVARCHAR(MAX) --= @BackupPath + 'YourBackupFile1.bak';
DECLARE @BackupFile2 NVARCHAR(MAX) --= @BackupPath + 'YourBackupFile2.bak';
DECLARE @BackupFile3 NVARCHAR(MAX) --= @BackupPath + 'YourBackupFile3.bak';
DECLARE @BackupFile4 NVARCHAR(MAX) --= @BackupPath + 'YourBackupFile4.bak';
DECLARE @BackupFile5 NVARCHAR(MAX) --= @BackupPath + 'YourBackupFile5.bak';
DECLARE @BackupFile6 NVARCHAR(MAX) --= @BackupPath + 'YourBackupFile6.bak';
DECLARE @BackupFile7 NVARCHAR(MAX) --= @BackupPath + 'YourBackupFile7.bak';
DECLARE @BackupFile8 NVARCHAR(MAX) --= @BackupPath + 'YourBackupFile8.bak';


SET @BackupFile1 = '\\dbbkprdawstgy01.as.local\alss3sqlsprd01\TFS-SERVER-04\Tfs_DefaultCollection\FULL\TFS-SERVER-04_Tfs_DefaultCollection_FULL_20240731_000051_1.bak';

SET @BackupFile2 = '\\dbbkprdawstgy01.as.local\alss3sqlsprd01\TFS-SERVER-04\Tfs_DefaultCollection\FULL\TFS-SERVER-04_Tfs_DefaultCollection_FULL_20240731_000051_2.bak';

SET @BackupFile3 = '\\dbbkprdawstgy01.as.local\alss3sqlsprd01\TFS-SERVER-04\Tfs_DefaultCollection\FULL\TFS-SERVER-04_Tfs_DefaultCollection_FULL_20240731_000051_3.bak';

SET @BackupFile4 = '\\dbbkprdawstgy01.as.local\alss3sqlsprd01\TFS-SERVER-04\Tfs_DefaultCollection\FULL\TFS-SERVER-04_Tfs_DefaultCollection_FULL_20240731_000051_4.bak';

SET @BackupFile5 = '\\dbbkprdawstgy01.as.local\alss3sqlsprd01\TFS-SERVER-04\Tfs_DefaultCollection\FULL\TFS-SERVER-04_Tfs_DefaultCollection_FULL_20240731_000051_5.bak';

SET @BackupFile6 = '\\dbbkprdawstgy01.as.local\alss3sqlsprd01\TFS-SERVER-04\Tfs_DefaultCollection\FULL\TFS-SERVER-04_Tfs_DefaultCollection_FULL_20240731_000051_6.bak';

SET @BackupFile7 = '\\dbbkprdawstgy01.as.local\alss3sqlsprd01\TFS-SERVER-04\Tfs_DefaultCollection\FULL\TFS-SERVER-04_Tfs_DefaultCollection_FULL_20240731_000051_7.bak';

SET @BackupFile8 = '\\dbbkprdawstgy01.as.local\alss3sqlsprd01\TFS-SERVER-04\Tfs_DefaultCollection\FULL\TFS-SERVER-04_Tfs_DefaultCollection_FULL_20240731_000051_8.bak'; 
-- Verify the backup files
RESTORE VERIFYONLY 
    FROM DISK = @BackupFile1,
         DISK = @BackupFile2,
         DISK = @BackupFile3,
         DISK = @BackupFile4,
         DISK = @BackupFile5,
         DISK = @BackupFile6,
         DISK = @BackupFile7,
         DISK = @BackupFile8;