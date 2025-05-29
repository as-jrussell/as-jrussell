USE UniTrac


/*
Work Item = '########'
Process Log ID = 'XXXXXXXX'
*/


--Pull Work Item 
SELECT  *
FROM    dbo.WORK_ITEM
WHERE   ID = '########'

--take relate id where the relate type is: Osprey.ProcessMgr.ProcessLog
SELECT  *
FROM    dbo.PROCESS_LOG
WHERE   ID = 'XXXXXXXX'



--take relate id where the relate type is: Osprey.ProcessMgr.ProcessLog
SELECT  *
FROM    dbo.OUTPUT_BATCH
WHERE   PROCESS_LOG_ID = 'XXXXXXXX'



---Checking Notice
SELECT  *
FROM    dbo.NOTICE
WHERE   ID IN ( SELECT  RELATE_ID
                FROM    dbo.PROCESS_LOG_ITEM
                WHERE   PROCESS_LOG_ID = 'XXXXXXXX'
                        AND RELATE_TYPE_CD = 'Allied.UniTrac.Notice' )


--Checking FPC
SELECT  *
FROM    dbo.FORCE_PLACED_CERTIFICATE
WHERE   ID IN (
        SELECT  RELATE_ID
        FROM    dbo.PROCESS_LOG_ITEM
        WHERE   PROCESS_LOG_ID = 'XXXXXXXX'
                AND RELATE_TYPE_CD = 'Allied.UniTrac.ForcePlacedCertificate' )



---Checking RC
SELECT  *
FROM    dbo.REQUIRED_COVERAGE
WHERE   ID IN ( SELECT  RELATE_ID
                FROM    dbo.PROCESS_LOG_ITEM
                WHERE   PROCESS_LOG_ID = 'XXXXXXXX'
                        AND RELATE_TYPE_CD = 'Allied.UniTrac.RequiredCoverage' )

---Checking Pending Reports
SELECT  *
FROM    dbo.REPORT_HISTORY
WHERE   ID IN ( SELECT  RELATE_ID
                FROM    dbo.PROCESS_LOG_ITEM
                WHERE   PROCESS_LOG_ID = 'XXXXXXXX'
                        AND RELATE_TYPE_CD = 'Allied.UniTrac.ReportHistory' )




SELECT  *
        FROM    dbo.PROCESS_LOG_ITEM
        WHERE   PROCESS_LOG_ID = 'XXXXXXXX'
                AND RELATE_TYPE_CD NOT IN ( 'Allied.UniTrac.ForcePlacedCertificate', 'Allied.UniTrac.ReportHistory',
				'Allied.UniTrac.RequiredCoverage', 'Allied.UniTrac.Notice')