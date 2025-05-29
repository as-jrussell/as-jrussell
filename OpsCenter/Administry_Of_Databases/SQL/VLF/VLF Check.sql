DECLARE @now DATETIME
SET @now = GETDATE()
if OBJECT_ID('tempdb..#VirtualLogFiles') is not null
  drop table #VirtualLogFiles
CREATE TABLE #VirtualLogFiles(
RecoveryUnitId int,
FileId INT,
FileSize BIGINT,
StartOffset bigint, --VARCHAR(100),
FSeqNo BIGINT,
[Status] INT,
Parity INT,
CreateLSN VARCHAR(100),
VLFIdent INT IDENTITY
)
INSERT INTO #VirtualLogFiles( RecoveryUnitId, FileId ,FileSize ,StartOffset ,FSeqNo ,Status ,Parity ,CreateLSN)
EXEC('DBCC loginfo()')
;WITH cte_VlfActiveCount(FileId, ActiveVLF)
AS
(
SELECT FileId, count(VLFIdent)
FROM #VirtualLogFiles vlf
WHERE status = 2
GROUP BY FileId
)
SELECT 
'$(ClientName)', @@ServerName, 
db_name(),
df.name,
VirtualLogFiles = COUNT(vlf.StartOffset),
ActiveVirtualLogFiles = cvac.ActiveVLF,
@now
FROM #VirtualLogFiles vlf
    INNER JOIN sys.database_files df ON df.file_id = vlf.FileId
    INNER JOIN cte_VlfActiveCount cvac on cvac.FileId = vlf.FileId
GROUP BY df.name, cvac.ActiveVLF
--DROP TABLE #VirtualLogFiles


--300 is starts to be concerning 
--500 could be problematic 