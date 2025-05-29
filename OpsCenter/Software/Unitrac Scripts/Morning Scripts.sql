-- select ref_cd [Process Type], rc.meaning_tx [Process Meaning], rc.description_tx [Process Description], CONVERT(INT, rca.value_tx)[VALUE_TX]
-- from ref_code_attribute rca
-- join ref_code rc on rca.ref_cd = rc.code_cd and rc.domain_cd = 'ProcessType'
-- where rca.domain_cd = 'ProcessType'
-- AND ATTRIBUTE_CD = 'PROCESS_Q_PRIORITY_DEFAULT'
-- ORDER BY CONVERT(INT, rca.value_tx)  ASC
USE unitrac

SELECT pd.PROCESS_TYPE_CD,
       pd.PROC_PRIORITY_NO,
       pd.ONHOLD_IN,
       Count(*) AS CountOfProcesses
FROM   dbo.UBSReadyToExecuteQueue AS t1
       JOIN sys.conversation_endpoints ce
         ON t1.conversation_handle = ce.conversation_handle
       JOIN PROCESS_DEFINITION pd
         ON pd.ID = (SELECT Cast(MESSAGE_BODY AS XML).value(N'(/MsgRoot/Id/node())[1]', N'bigint')
                     FROM   dbo.UBSReadyToExecuteQueue t2
                     WHERE  t2.CONVERSATION_HANDLE = t1.CONVERSATION_HANDLE)
GROUP  BY pd.PROCESS_TYPE_CD,
          pd.PROC_PRIORITY_NO,
          pd.ONHOLD_IN
ORDER  BY PROC_PRIORITY_NO,
          Count(*)

SELECT pd.PROCESS_TYPE_CD,
       Min(pl.CREATE_DT) MinCreateDate,
       Max(pl.END_DT)    MaxEndDate,
       Count(*)          [Count]
FROM   PROCESS_DEFINITION pd
       JOIN process_log pl
         ON pl.PROCESS_DEFINITION_ID = pd.ID
WHERE  Cast(pl.CREATE_DT AS DATE) = Cast(Getdate() AS DATE)
       AND pl.STATUS_CD = 'Complete'
       AND pl.SERVICE_NAME_TX IS NOT NULL
       AND pl.END_DT IS NOT NULL
       AND pl.MSG_TX LIKE 'Total WorkItems processed:%'
       AND pd.LOAD_BALANCE_IN = 'Y'
GROUP  BY PROCESS_TYPE_CD

SELECT Count(*)       [CountOfProcesses],
       SERVICE_NAME_TX,
       Max(pl.END_DT) MaxEndDate
FROM   PROCESS_LOG pl
WHERE  UPDATE_USER_TX IN ( 'UBSDist', 'UBSProc1', 'UBSProc2', 'UBSProc4',
                           'UBSProc5', 'UBSProc6', 'UBSProc7', 'UBSProc8', 'UBSProc9a' )
       AND SERVICE_NAME_TX IS NOT NULL
       AND Cast(pl.CREATE_DT AS DATE) = Cast(Getdate() AS DATE)
GROUP  BY SERVICE_NAME_TX
ORDER  BY SERVICE_NAME_TX ASC

SELECT CONVERT(TIME, END_DT - START_DT)[hh:mm:ss],
       PD.NAME_TX,
       PL.SERVICE_NAME_TX,
       pl.START_DT,
       PL.PROCESS_DEFINITION_ID
FROM   dbo.PROCESS_LOG PL
       JOIN dbo.PROCESS_DEFINITION PD
         ON PD.ID = PL.PROCESS_DEFINITION_ID
WHERE  pl.UPDATE_USER_TX IN ( 'UBSDist', 'UBSProc1', 'UBSProc2', 'UBSProc4',
                              'UBSProc5', 'UBSProc6', 'UBSProc7', 'UBSProc8', 'UBSProc9a' )
       AND SERVICE_NAME_TX IS NOT NULL
       AND Cast(pl.CREATE_DT AS DATE) = Cast(Getdate() AS DATE)
       AND CONVERT(TIME, pl.END_DT - pl. START_DT) > '00:30'
ORDER  BY CONVERT(TIME, END_DT - START_DT) DESC

SELECT Min(rh.create_dt) [Oldest report],
       Count(*)          [Counts],
       rh.STATUS_CD      [Status]
FROM   REPORT_HISTORY rh
       LEFT JOIN dbo.DOCUMENT_CONTAINER dc
              ON dc.id = rh.DOCUMENT_CONTAINER_ID
WHERE  Cast(rh.UPDATE_DT AS DATE) >= Cast(Getdate() AS DATE)
       AND rh.GENERATION_SOURCE_CD = 'u'
GROUP  BY STATUS_CD

SELECT Max(rh.UPDATE_DT) [Last Report Done by UBSRPT]
FROM   REPORT_HISTORY rh
WHERE  STATUS_CD = 'COMP'
       AND Cast(rh.UPDATE_DT AS DATE) = Cast(Getdate() AS DATE)
       AND rh.UPDATE_USER_TX = 'UBSRPT' 
