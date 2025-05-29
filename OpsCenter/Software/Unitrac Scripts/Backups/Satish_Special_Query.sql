DECLARE @workItemId BIGINT = 37838148

DECLARE @isChildWI CHAR(1) = 'N'

DECLARE @parentWI BIGINT

DECLARE @plId BIGINT

DECLARE @isImmediate VARCHAR(10)

 

declare @tmpPLI Table(PLI_ID BIGINT)

 

--Identify if WI is immediate 

SELECT @isImmediate = CONTENT_XML.value('(/Content/Cycle/Immediate)[1]', 'varchar(10)')

              ,@plId = RELATE_ID

FROM WORK_ITEM

WHERE ID = @workItemId

 

IF @isImmediate IS NULL

              SET @isImmediate = 'NO'

 

--Identify if WI is child or parent. MIN ID will be of parent                     

SELECT @parentWI = MIN(wi.ID)

FROM WORK_ITEM wi

JOIN WORKFLOW_DEFINITION wd ON wd.ID = wi.WORKFLOW_DEFINITION_ID

              AND wd.NAME_TX = 'Cycle'

WHERE wi.RELATE_ID = @plId

              AND wi.PURGE_DT IS NULL

 

IF @parentWI != @workItemId

              SET @isChildWI = 'Y'

 

IF @isChildWI = 'Y'

BEGIN

              INSERT INTO @tmpPLI (PLI_ID)

              SELECT rel.PROCESS_LOG_ITEM_ID

              FROM WORK_ITEM_PROCESS_LOG_ITEM_RELATE rel

              JOIN PROCESS_LOG_ITEM pli ON pli.ID = rel.PROCESS_LOG_ITEM_ID

              WHERE rel.WORK_ITEM_ID = @workItemId

                           AND pli.STATUS_CD = 'COMP'

                           AND pli.PURGE_DT IS NULL

                           AND rel.PURGE_DT IS NULL

END

ELSE

BEGIN

              INSERT INTO @tmpPLI (PLI_ID)

              SELECT pli.ID

              FROM WORK_ITEM wi

              JOIN PROCESS_LOG_ITEM pli ON pli.PROCESS_LOG_ID = wi.RELATE_ID

              WHERE wi.ID = @workItemId

                           AND pli.STATUS_CD = 'COMP'

                           AND pli.PURGE_DT IS NULL

                           AND wi.PURGE_DT IS NULL

END

 

DECLARE @tg TABLE (

              PLI_Id BIGINT

              ,RELATE_TYPE_CD NVARCHAR(200)

              ,RELATE_ID BIGINT

              ,STATUS_CD NVARCHAR(40)

              ,OUTPUT_TYPE VARCHAR(5)

              ,TYPE_TEXT_EXISTS INT

              ,EVALUATION_EVENT_ID BIGINT

              )

 

INSERT INTO @tg

SELECT f.PLI_ID

              ,pli.RELATE_TYPE_CD

              ,pli.RELATE_ID

              ,pli.STATUS_CD

              ,pli.INFO_XML.value('(/INFO_LOG/OUTPUT_TYPE)[1]', 'nvarchar(5)') AS OUTPUT_TYPE

             ,pli.INFO_XML.exist('(/INFO_LOG/OUTPUT_TYPE/text())[1]')

              ,pli.EVALUATION_EVENT_ID

FROM PROCESS_LOG_ITEM pli

INNER JOIN @tmpPLI f ON f.PLI_ID = pli.ID

WHERE pli.PURGE_DT IS NULL
 

 

 