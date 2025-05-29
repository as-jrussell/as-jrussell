USE msdb
IF EXISTS (SELECT *
           FROM   msdb..sysjobs
           WHERE  name = 'PRL_ALLIEDSYS_PROD-Inactive')
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name = 'PRL_ALLIEDSYS_PROD-Inactive',
        @enabled=0
  END

IF EXISTS (SELECT *
           FROM   msdb..sysjobs
           WHERE  name = 'PRL_ALLIEDSYS_PROD-Active')
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name = 'PRL_ALLIEDSYS_PROD-Active',
        @enabled=0
  END

USE PRL_ALLIEDSYS_PROD

IF EXISTS (SELECT 1
           FROM   PRL_ALLIEDSYS_PROD.sys.objects
           WHERE  name = 'WkflwEval_Active')
  BEGIN
      EXEC [PRL_ALLIEDSYS_PROD].dbo.[Wkflweval_active]
  END 






  
DECLARE @SourceDatabase NVARCHAR(100) = 'prl_alliedsys_prod' 
DECLARE @id NVARCHAR(1) = 3

EXEC('USE ['+@SourceDatabase+'] SELECT TOP 10 CONVERT(TIME,END_DT- START_DT)[hh:mm:ss],  PD.NAME_TX,  PL.*
             	FROM '+@SourceDatabase+'.'+ 'dbo.PROCESS_LOG PL
JOIN  '+@SourceDatabase+'.'+ 'dbo.PROCESS_DEFINITION PD ON PD.ID = PL.PROCESS_DEFINITION_ID
               WHERE
PROCESS_DEFINITION_ID =' + @id + '
ORDER BY ID DESC'); 





EXEC('USE ['+@SourceDatabase+'] SELECT *
             	FROM '+@SourceDatabase+'.'+ 'dbo.PROCESS_DEFINITION PD
               WHERE
ID =' + @id + '
ORDER BY ID DESC'); 






SELECT DISTINCT   sj.name, sj.description, enabled
 FROM msdb.dbo.sysjobs sj
WHERE  sj.name in ('PRL_ALLIEDSYS_PROD-Inactive','PRL_ALLIEDSYS_PROD-Active')