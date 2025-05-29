use unitrac

declare @PDID bigint = '13097'
DECLARE @NextFullCycleDate nvarchar(25) = '6/21/2019 1:30:00 AM'  --remember to ensure that it is in the central time zone  
DECLARE @Task nvarchar(15) = 'INC0430053'


update PROCESS_DEFINITION
set SETTINGS_XML_IM.modify('replace value of (/ProcessDefinitionSettings/NextFullCycleDate/text())[1] with sql:variable("@NextFullCycleDate")')
where ID = @PDID







DECLARE @LastFullCycleDate nvarchar(25) = '6/7/2019 4:19:34 AM'  --remember to ensure that it is in the central time zone 


update PROCESS_DEFINITION
set SETTINGS_XML_IM.modify('replace value of (/ProcessDefinitionSettings/LastFullCycleDate/text())[1] with sql:variable("@LastFullCycleDate")')
,UPDATE_DT = getdate(), UPDATE_USER_TX = @Task, LOCK_ID = (LOCK_ID % 255 ) + 1
where ID = @PDID



select SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/NextFullCycleDate)[1]',
                                    'varchar(50)'),
									SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/LastFullCycleDate)[1]',
                                    'varchar(50)'),
									* from PROCESS_DEFINITION
where id in (13907)




update pd
set SETTINGS_XML_IM = '<ProcessDefinitionSettings>
  <LastProcessedDate />
  <TargetServerList>
    <TargetServer />
  </TargetServerList>
  <TargetServiceList>
    <TargetService />
  </TargetServiceList>
  <PredecessorProcessList>
    <PredecessorProcess />
  </PredecessorProcessList>
  <LDAPServer>10.10.18.186</LDAPServer>
  <LDAPPath>ou=groups,ou=internal,dc=as,dc=net</LDAPPath>
  <AnticipatedNextScheduledDate>6/21/2019 1:30:00 AM</AnticipatedNextScheduledDate>
  <TimeOfDay>01:30:00</TimeOfDay>
  <ForcedPlcyOptBlanketAuditDate>1/1/0001 12:00:00 AM</ForcedPlcyOptBlanketAuditDate>
  <LastFullCycleDate>6/7/2019 4:19:34 AM</LastFullCycleDate>
  <DailyCycleType>Daily</DailyCycleType>
  <NextFullCycleDate>6/21/2019 1:30:00 AM</NextFullCycleDate>
  <LastCycleMode>Daily</LastCycleMode>
  <LastDailyCycleDate>6/7/2019 3:40:43 AM</LastDailyCycleDate>
  <PutOnHoldDate>1/1/0001 12:00:00 AM</PutOnHoldDate>
  <LenderList>
    <LenderID IsEnabled="Y">1115</LenderID>
  </LenderList>
  <LCGCTList>
    <LCGCTId>3524</LCGCTId>
    <LCGCTId>7661</LCGCTId>
  </LCGCTList>
  <LenderReportConfigList />
  <NoticeList>
    <NoticeType FirstMaxCount="-1" SecondMaxCount="-1" FirstNoticeThreshold="250" SecondNoticeThreshold="-1" NoticeCapReason="CCY" CapRemovalDate="9999-12-31T00:00:00">AN</NoticeType>
    <NoticeType FirstMaxCount="-1" SecondMaxCount="-1" FirstNoticeThreshold="400" SecondNoticeThreshold="400" NoticeCapReason="CCY" CapRemovalDate="9999-12-31T00:00:00">A</NoticeType>
    <NoticeType FirstMaxCount="-1" SecondMaxCount="-1" FirstNoticeThreshold="400" SecondNoticeThreshold="-1" NoticeCapReason="CCY" CapRemovalDate="9999-12-31T00:00:00">BI</NoticeType>
    <NoticeType FirstMaxCount="-1" SecondMaxCount="-1" FirstNoticeThreshold="400" SecondNoticeThreshold="-1" NoticeCapReason="CCY" CapRemovalDate="9999-12-31T00:00:00">ID</NoticeType>
    <NoticeType FirstMaxCount="-1" SecondMaxCount="-1" FirstNoticeThreshold="400" SecondNoticeThreshold="400" NoticeCapReason="CCY" CapRemovalDate="9999-12-31T00:00:00">IC</NoticeType>
    <NoticeType FirstMaxCount="-1" SecondMaxCount="-1" FirstNoticeThreshold="400" SecondNoticeThreshold="400" NoticeCapReason="CCY" CapRemovalDate="9999-12-31T00:00:00">B</NoticeType>
    <NoticeType FirstMaxCount="-1" SecondMaxCount="-1" FirstNoticeThreshold="250" SecondNoticeThreshold="300" NoticeCapReason="CCY" CapRemovalDate="9999-12-31T00:00:00">C</NoticeType>
    <NoticeType FirstMaxCount="-1" SecondMaxCount="-1" FirstNoticeThreshold="400" SecondNoticeThreshold="400" NoticeCapReason="CCY" CapRemovalDate="9999-12-31T00:00:00">E</NoticeType>
    <NoticeType FirstMaxCount="-1" SecondMaxCount="-1" FirstNoticeThreshold="300" SecondNoticeThreshold="400" NoticeCapReason="CCY" CapRemovalDate="9999-12-31T00:00:00">I</NoticeType>
    <NoticeType FirstMaxCount="-1" SecondMaxCount="-1" FirstNoticeThreshold="400" SecondNoticeThreshold="400" NoticeCapReason="CCY" CapRemovalDate="9999-12-31T00:00:00">L</NoticeType>
    <NoticeType FirstMaxCount="-1" SecondMaxCount="-1" FirstNoticeThreshold="400" SecondNoticeThreshold="400" NoticeCapReason="CCY" CapRemovalDate="9999-12-31T00:00:00">IL</NoticeType>
    <NoticeType FirstMaxCount="-1" SecondMaxCount="-1" FirstNoticeThreshold="400" SecondNoticeThreshold="400" NoticeCapReason="CCY" CapRemovalDate="9999-12-31T00:00:00">N</NoticeType>
    <NoticeType FirstMaxCount="-1" SecondMaxCount="-1" FirstNoticeThreshold="400" SecondNoticeThreshold="400" NoticeCapReason="CCY" CapRemovalDate="9999-12-31T00:00:00">PC</NoticeType>
    <NoticeType FirstMaxCount="-1" SecondMaxCount="-1" FirstNoticeThreshold="400" SecondNoticeThreshold="400" NoticeCapReason="CCY" CapRemovalDate="9999-12-31T00:00:00">PE</NoticeType>
    <NoticeType FirstMaxCount="-1" SecondMaxCount="-1" FirstNoticeThreshold="400" SecondNoticeThreshold="400" NoticeCapReason="CCY" CapRemovalDate="9999-12-31T00:00:00">R</NoticeType>
    <NoticeType FirstMaxCount="-1" SecondMaxCount="-1" FirstNoticeThreshold="300" SecondNoticeThreshold="400" NoticeCapReason="CCY" CapRemovalDate="9999-12-31T00:00:00">IS</NoticeType>
  </NoticeList>
  <SProcList>
    <SProc IsEnabled="Y">UpdatePaymentIncrease</SProc>
  </SProcList>
  <DailyCycleDays>
    <Day>Monday</Day>
    <Day>Tuesday</Day>
    <Day>Wednesday</Day>
    <Day>Thursday</Day>
    <Day>Friday</Day>
  </DailyCycleDays>
  <ServiceCapabilityList>
    <ServiceCapability>RAMMEDIUM</ServiceCapability>
    <ServiceCapability>CPUMEDIUM</ServiceCapability>
    <SystemRamInGB />
    <SystemProcessorCount />
  </ServiceCapabilityList>
</ProcessDefinitionSettings>'
--select *
from PROCESS_DEFINITION pd
where id in (13907)


