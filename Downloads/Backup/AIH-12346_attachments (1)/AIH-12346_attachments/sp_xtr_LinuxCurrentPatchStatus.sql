USE SHAVLIK


IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_ID = OBJECT_ID(N'[dbo].[xtr_LinuxCurrentPatchStatus]')
                    AND type IN (N'P') ) 
    DROP PROCEDURE [dbo].[xtr_LinuxCurrentPatchStatus] ;
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[xtr_LinuxCurrentPatchStatus]') AND type in (N'P', N'PC'))
BEGIN
	/* Create Empty Stored Procedure */
	EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[xtr_LinuxCurrentPatchStatus] AS RETURN 0;';
END;
GO

 
ALTER PROCEDURE [dbo].[xtr_LinuxCurrentPatchStatus] (@BATCHID Int,@RECORDSSTAGED Int OUTPUT)

AS 

BEGIN
DECLARE @ENTITYNAME VARCHAR(100) = 'xtr_LinuxCurrentPatchStatus'
BEGIN TRY

IF OBJECT_ID('tempdb..#MergeSummary') IS NULL
	CREATE TABLE #MergeSummary (CHANGE VARCHAR(20))


DECLARE @LinuxTempStatus TABLE (
MACHINEID Int,
PATCH VARCHAR(256),
PATCHID INT,
ASSESSEDMACHINESTATEID INT,
SCANDATE DATETIME,
INSTALLSTATEID INT,
OSID INT,
OCCURENCES INT
)

DECLARE @LinuxCurrentPatchStatus TABLE (
MACHINEID Int,
PATCH VARCHAR(256),
PATCHID INT,
ASSESSEDMACHINESTATEID INT,
SCANDATE DATETIME,
INSTALLSTATEID INT,
OSID INT

)



INSERT INTO @LinuxCurrentPatchStatus
SELECT   MS.MACHINEID AS MACHINEID, LP.Name AS PATCH ,  LDPS.LINUXPATCHID AS PATCHID, LDPS.ASSESSEDMACHINESTATEID AS ASSESSEDMACHINESTATEID, 
PS.STARTEDON AS SCANDATE , LDPS.LINUXINSTALLSTATEID AS INSTALLSTATE, SM.PLATFORMID AS OSID
FROM Reporting2.AssessedMachineState MS
LEFT OUTER JOIN
Reporting2.PatchScan PS ON PS.ID = MS.PATCHSCANID
LEFT OUTER JOIN
REPORTING2.LinuxDetectedPatchState LDPS ON MS.ID = LDPS.ASSESSEDMACHINESTATEID
LEFT OUTER JOIN
Reporting2.LinuxPatch LP ON LDPS.LINUXPATCHID = LP.ID
LEFT OUTER JOIN
Reporting2.VendorSeverity VS ON VS.ID = LP.VENDORSEVERITYID
LEFT OUTER JOIN
DBO.ScanMachines SM ON LDPS.ASSESSEDMACHINESTATEID = SM.SMACHID
INNER JOIN(
 SELECT AMS.MACHINEID,  LP.ID AS PATCHID,  MAX(LDPS.ASSESSEDMACHINESTATEID) AS MAXAMS
FROM Reporting2.LinuxPatch LP 
INNER JOIN REPORTING2.LinuxDetectedPatchState LDPS ON LP.ID = LDPS.LINUXPATCHID
INNER JOIN Reporting2.AssessedMachineState AMS ON AMS.ID = LDPS.ASSESSEDMACHINESTATEID
GROUP BY AMS.MACHINEID, LP.ID ) B
ON LDPS.ASSESSEDMACHINESTATEID = B.MAXAMS and MS.MACHINEID = B.MACHINEID AND  LP.ID = B.PATCHID 
WHERE PS.STARTEDON > (SELECT CASE WHEN COUNT(LOGDATE) <> 0 THEN MAX(LOGDATE) ELSE '2000-01-01 00:00:00.000' END FROM xtrEntityProcessLog 
WHERE  PROCEDURENAME LIKE '%Linux%') 


INSERT INTO  @LinuxTempStatus 
SELECT [MACHINEID],[PATCH] ,[PATCHID], [ASSESSEDMACHINESTATEID], [SCANDATE], [INSTALLSTATEID], [OSID], COUNT(*) OCCURENCES 
  FROM @LinuxCurrentPatchStatus
GROUP BY  [MACHINEID] ,[PATCH]  ,[PATCHID]  , [ASSESSEDMACHINESTATEID], [SCANDATE], [INSTALLSTATEID], [OSID]
HAVING COUNT(*) > 1;

DELETE @LinuxCurrentPatchStatus FROM @LinuxCurrentPatchStatus CPS 
INNER JOIN @LinuxTempStatus  TS
ON TS.MACHINEID = CPS.MACHINEID AND TS.PATCHID = CPS.PATCHID 
AND TS.ASSESSEDMACHINESTATEID = CPS.ASSESSEDMACHINESTATEID


INSERT INTO @LinuxCurrentPatchStatus (MACHINEID, PATCH, PATCHID,  ASSESSEDMACHINESTATEID, SCANDATE, INSTALLSTATEID, OSID)
SELECT [MACHINEID],[PATCH],[PATCHID],[ASSESSEDMACHINESTATEID], [SCANDATE], [INSTALLSTATEID], [OSID] 
FROM @LinuxTempStatus 



MERGE xtrLinuxCurrentPatchStatus T
USING @LinuxCurrentPatchStatus S ON T.MACHINEID = S.MACHINEID AND T.PATCHID = S.PATCHID 
WHEN NOT MATCHED BY TARGET 
THEN 
INSERT (MACHINEID, PATCH, PATCHID, ASSESSEDMACHINESTATEID, SCANDATE, INSTALLSTATEID, OSID)
VALUES (S.MACHINEID, S.PATCH, S.PATCHID, S.ASSESSEDMACHINESTATEID, S.SCANDATE, S.INSTALLSTATEID, S.OSID)
WHEN MATCHED THEN
UPDATE SET T.ASSESSEDMACHINESTATEID = S.ASSESSEDMACHINESTATEID, T.SCANDATE = S.SCANDATE, T.INSTALLSTATEID = S.INSTALLSTATEID, T.OSID = S.OSID
OUTPUT $action INTO #MergeSummary;



SET @RECORDSSTAGED = @@rowcount


INSERT INTO dbo.xtrEntityProcessLog (BATCHID, LOGDATE, PROCEDURENAME, DESCRIPTION) 

SELECT @BATCHID, GETUTCDATE(),  'xtr_LinuxCurrentPatchStatus', 'Inserted ' + CAST(ISNULL((SELECT COUNT(0) AS RecordCount FROM  #MergeSummary WHERE CHANGE = 'INSERT' GROUP BY CHANGE),0) AS nvarchar(100)) + ' records'
UNION
SELECT @BATCHID, GETUTCDATE(),  'xtr_LinuxCurrentPatchStatus', 'Updated ' + CAST(ISNULL((SELECT COUNT(0) AS RecordCount FROM  #MergeSummary WHERE CHANGE = 'UPDATE' GROUP BY CHANGE),0) AS nvarchar(100)) + ' records'

DROP TABLE #MergeSummary



END TRY

BEGIN CATCH

	EXEC xtr_LogErrorInfo @BATCHID, @ENTITYNAME


END CATCH


END