USE UTL


EXEC UT_GetPDErrorInfo
GO

--exec UT_DailyUTL

exec UT_DailyUTL_Breakdown

SELECT  SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/TargetServiceList/TargetService)[1]',
                              'nvarchar(max)') [Target Service] ,  STATUS_CD,* from process_definition


update pd 
set STATUS_CD = 'Complete'
--select *
from process_definition pd
where STATUS_CD = 'Error'


select LL.NAME_tX, rd.value_tx, L.* from loan L
join [unitrac-db01].Unitrac.dbo.Lender LL on LL.ID = L.lender_id
left join [unitrac-db01].Unitrac.dbo.RELATED_DATA rd ON LL.ID = rd.RELATE_ID AND rd.DEF_ID = '183' 
where L.PURGE_DT IS NULL  and   l.EVALUATION_DT < '1/1/1901'
order by LL.CODE_TX ASC


exec Login @userName='UTWebSrvc',@password='qGupeajHm68mXlLG27RPBoQoandR0D4n',@getConnectInfo='Y'



select count(*)[Open UTLs from Lender that have added], LL.CODE_TX [Lender Code], LL.NAME_TX [Lender Name]
from loan L
join [unitrac-db01].Unitrac.dbo.Lender LL on LL.ID = L.lender_id
join [unitrac-db01].Unitrac.dbo.RELATED_DATA rd ON LL.ID = rd.RELATE_ID AND rd.DEF_ID = '183' and rd.value_tx = 'true'
where L.PURGE_DT IS NULL  and   l.EVALUATION_DT < '1/1/1901'
group by  LL.CODE_TX, LL.NAME_TX
order by count(*) DESC


select * from process_log
where CREATE_DT > dateadd(HOUR, -3, getdate()) 
order by update_dt desc

select * from CONNECTION_DESCRIPTOR

/*

select * from loan l
join (select le.id lender_id, le.code_tx, le.name_tx
       from LENDER le where le.enable_matching_in = 'Y' and le.purge_dt is null) le on le.lender_id = l.lender_id
	   where l.EVALUATION_DT < '1/1/1901'
	   and l.PURGE_DT is null


*/




/*
select * from [unitrac-db01].Unitrac.dbo.Lender
where code_tx = '4280'


update PD 
set
status_cd = 'Complete',
 SETTINGS_XML_IM = '<ProcessDefinitionSettings>
  <LastProcessedDate />
  <TargetServerList>
    <TargetServer />
  </TargetServerList>
  <TargetServiceList>
    <TargetService>UTLRematchAdhoc</TargetService>
  </TargetServiceList>
  <PredecessorProcessList>
    <PredecessorProcess />
  </PredecessorProcessList>
  <LDAPServer>10.10.18.186</LDAPServer>
  <LDAPPath>ou=groups,ou=internal,dc=as,dc=net</LDAPPath>
  <AnticipatedNextScheduledDate>5/30/2019 10:39:35 AM</AnticipatedNextScheduledDate>
  <LenderList>
    <LenderID LastProcessed="1/1/0001 12:00:00 AM" ManualLender="N" IsEnabled="Y">USDTEST1</LenderID>
    <LenderID LastProcessed="1/1/0001 12:00:00 AM" ManualLender="N" IsEnabled="Y">2449</LenderID>
    <LenderID LastProcessed="1/1/0001 12:00:00 AM" ManualLender="N" IsEnabled="Y">2545</LenderID>
    <LenderID LastProcessed="1/1/0001 12:00:00 AM" ManualLender="N" IsEnabled="Y">4411</LenderID>
  </LenderList>
  <PurgeUTL>Y</PurgeUTL>
  <ServiceCapabilityList>
    <SystemRamInGB />
    <SystemProcessorCount />
  </ServiceCapabilityList>
</ProcessDefinitionSettings>'
--select *
from PROCESS_DEFINITION PD
where id in (10)

*/




   


   SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[UT_GetPDErrorInfo]
AS
    SET NOCOUNT ON

    DECLARE @ID VARCHAR(10)
    DECLARE @NAME_TX NVARCHAR(100)
    DECLARE @UPDATE_DT NVARCHAR(25)
    DECLARE @LAST_RUN_DT NVARCHAR(25)
    DECLARE @STATUS_CD NVARCHAR(10)
    DECLARE @PROCESS_TYPE_CD NVARCHAR(100)
    DECLARE @body AS VARCHAR(6000) 

    SET @body = ''

    CREATE TABLE #tmpPDInfo
        (
          ID NVARCHAR(100) ,
          NAME_TX NVARCHAR(100) ,
          UPDATE_DT NVARCHAR(25) ,
          LAST_RUN_DT NVARCHAR(25) ,
          STATUS_CD NVARCHAR(10) ,
          PROCESS_TYPE_CD NVARCHAR(100)
        )

    INSERT  INTO #tmpPDInfo
            ( ID ,
              NAME_TX ,
              UPDATE_DT ,
              LAST_RUN_DT ,
              STATUS_CD ,
              PROCESS_TYPE_CD
            )
            SELECT  pd.ID ,
                    pd.NAME_TX ,
                    pd.UPDATE_DT ,
                    pd.LAST_RUN_DT ,
                    pd.STATUS_CD ,
                    pd.PROCESS_TYPE_CD
            FROM    dbo.PROCESS_DEFINITION pd
            WHERE   pd.STATUS_CD = 'Error' and (pd.LOAD_BALANCE_IN = 'N' or pd.LOAD_BALANCE_IN is NULL)
                                                
    DECLARE CursorVar CURSOR READ_ONLY
    FOR
        SELECT  ID ,
                NAME_TX ,
                UPDATE_DT ,
                LAST_RUN_DT ,
                STATUS_CD ,
                PROCESS_TYPE_CD
        FROM    #tmpPDInfo

    OPEN CursorVar
    FETCH CursorVar INTO @ID, @NAME_TX, @UPDATE_DT, @LAST_RUN_DT, @STATUS_CD,
        @PROCESS_TYPE_CD

    WHILE @@Fetch_Status = 0
        BEGIN
            SET @body = @body + @ID + ',  ' + @NAME_TX + ',  ' + @UPDATE_DT
                + ',  ' + @LAST_RUN_DT + ',  ' + @STATUS_CD + ',  '
                + @PROCESS_TYPE_CD + CHAR(13) + CHAR(10)

            FETCH NEXT FROM CursorVar INTO @ID, @NAME_TX, @UPDATE_DT,
                @LAST_RUN_DT, @STATUS_CD, @PROCESS_TYPE_CD
        END
    CLOSE CursorVar
    DEALLOCATE CursorVar

    IF @body <> ''
        BEGIN
            SET @body = 'UTL Process Definitions In Error Status:   (Process Definition ID, Process Name, Update Dt, Last Run Dt, Process Type Code)

For assistance on how to reset these please refer to: http://connections.alliedsolutions.net/forums/html/topic?id=c24d8699-4705-40bf-8889-333a0c623401' + CHAR(13) + CHAR(10) + @body 
            EXEC UT_GetPDErrorInfo_Email @Body	
--Print @body
        END

    DROP TABLE #tmpPDInfo


GO