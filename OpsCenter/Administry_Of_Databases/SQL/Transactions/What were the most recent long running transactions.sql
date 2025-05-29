DECLARE @sledgehammer INT = 0 ---Zero Defaults to DBA LongTranInfo Table if set to 1 and it's on Unitrac Prod you can use the previous LongRunningTransactions Table
IF @sledgehammer = 1
  BEGIN
      IF EXISTS (SELECT *
                 FROM   sys.databases
                 WHERE  name = 'Unitrac')
        BEGIN
            IF Object_id(N'tempdb..#tmpLongRunningTrans') IS NOT NULL
              DROP TABLE #tmpLongRunningTrans

            SELECT Count(session_id)         AS [COUNT],
                   session_id,
                   Cast (current_dt AS DATE) AS DATE
            INTO   #tmpLongRunningTrans
            FROM   [PerfStats].[dbo].[LongRunningTransactions]
            WHERE  Cast(current_dt AS DATE) >= Cast(Getdate() - 1 AS DATE)
            GROUP  BY session_id,
                      Cast (current_dt AS DATE)
            HAVING Count(session_id) > 50

            SELECT Concat('Long Running Sessions were on: ', session_id)
            FROM   #tmpLongRunningTrans

            SELECT *
            FROM   [PerfStats].[dbo].[LongRunningTransactions]
            WHERE  Cast(current_dt AS DATE) >= Cast(Getdate() - 1 AS DATE)
                   AND session_id IN (SELECT session_id
                                      FROM   #tmpLongRunningTrans)
        END
      ELSE
        BEGIN
            SELECT *
            FROM   [PerfStats].[dbo].[LongTranInfo]
            WHERE  Cast(current_dt AS DATE) >= Cast(Getdate() - 1 AS DATE)
                   AND total_elapsed_time <> 0
            ORDER  BY current_dt DESC
        END
  END
ELSE
  BEGIN
      SELECT *
      FROM   [PerfStats].[dbo].[LongTranInfo]
      WHERE  Cast(current_dt AS DATE) >= Cast(Getdate() - 1 AS DATE)
             AND total_elapsed_time <> 0
      ORDER  BY current_dt DESC
  END 
