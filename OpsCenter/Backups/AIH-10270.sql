USE master

IF EXISTS (select 1 from sys.syslogins where name in ('UTDashboard'))
	BEGIN 
		ALTER LOGIN [UTDashboard] DISABLE
		PRINT 'SUCCESS: UTDashboard is disabled!'
	END
ELSE
	BEGIN 
		PRINT 'WARNING: UTDashboard does not exist no account to disable!'
	END

IF EXISTS (select 1 from sys.syslogins where name in ('UTdbSyncSvcProd'))
	BEGIN 
		ALTER LOGIN [UTdbSyncSvcProd] DISABLE
		PRINT 'SUCCESS: UTdbSyncSvcProd is disabled!'
	END
ELSE
	BEGIN 
		PRINT 'WARNING: UTdbSyncSvcProd does not exist no account to disable!'
	END


IF EXISTS (select 1 from sys.syslogins where name in ('UTdbUBSGoodThruProd'))
	BEGIN 
		ALTER LOGIN [UTdbUBSGoodThruProd] DISABLE
		PRINT 'SUCCESS: UTdbUBSGoodThruProd is disabled!'
	END
ELSE
	BEGIN 
		PRINT 'WARNING: UTdbUBSGoodThruProd does not exist no account to disable!'
	END

IF EXISTS (select 1 from sys.syslogins where name in ('UTdbUBSRptProd'))
	BEGIN 
		ALTER LOGIN [UTdbUBSRptProd] DISABLE
		PRINT 'SUCCESS: UTdbUBSRptProd is disabled!'
	END
ELSE
	BEGIN 
		PRINT 'WARNING: UTdbUBSRptProd does not exist no account to disable!'
	END

IF EXISTS (select 1 from sys.syslogins where name in ('UTWebSrvc'))
	BEGIN 
		ALTER LOGIN [UTWebSrvc] DISABLE
		PRINT 'SUCCESS: UTWebSrvc is disabled!'
	END
ELSE
	BEGIN 
		PRINT 'WARNING: UTWebSrvc does not exist no account to disable!'
	END
