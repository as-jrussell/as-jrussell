
INSERT INTO PROCESS_DEFINITION (NAME_TX,DESCRIPTION_TX,EXECUTION_FREQ_CD,PROCESS_TYPE_CD,PRIORITY_NO,ACTIVE_IN,CREATE_DT,UPDATE_DT,UPDATE_USER_TX,LOCK_ID,INCLUDE_WEEKENDS_IN,INCLUDE_HOLIDAYS_IN,ONHOLD_IN,FREQ_MULTIPLIER_NO, USE_LAST_SCHEDULED_DT_IN)
SELECT 'UTL 2.0 Rematch: Default','UTL 2.0 Rematch: Default','MINUTE','UTL20REMAT',PRIORITY_NO,'N',GETDATE(),GETDATE(),'MsgSrvrEXTInfo',LOCK_ID,INCLUDE_WEEKENDS_IN,INCLUDE_HOLIDAYS_IN,'Y',FREQ_MULTIPLIER_NO, USE_LAST_SCHEDULED_DT_IN
FROM PROCESS_DEFINITION
WHERE ID = 711281

UPDATE PROCESS_DEFINITION
SET SETTINGS_XML_IM = '<ProcessDefinitionSettings>
  <LastProcessedDate />
  <TargetServerList>
    <TargetServer />
  </TargetServerList>
  <TargetServiceList>
    <TargetService>UTLRematchMidSizeLenders</TargetService>
  </TargetServiceList>
  <PredecessorProcessList>
    <PredecessorProcess />
  </PredecessorProcessList>
  <LDAPServer>10.10.18.186</LDAPServer>
  <LDAPPath>ou=groups,ou=internal,dc=as,dc=net</LDAPPath>
  <AnticipatedNextScheduledDate>3/21/2018 4:04:43 PM</AnticipatedNextScheduledDate>
  <LenderList>
    <LenderID LastProcessed="1/1/0001 12:00:00 AM" ManualLender="N" IsEnabled="Y">1771</LenderID>
    <LenderID LastProcessed="1/1/0001 12:00:00 AM" ManualLender="N" IsEnabled="Y">2252</LenderID>
    <LenderID LastProcessed="1/1/0001 12:00:00 AM" ManualLender="N" IsEnabled="Y">5044</LenderID>
    <LenderID LastProcessed="1/1/0001 12:00:00 AM" ManualLender="N" IsEnabled="Y">1695</LenderID>
    <LenderID LastProcessed="1/1/0001 12:00:00 AM" ManualLender="N" IsEnabled="Y">4386</LenderID>
    <LenderID LastProcessed="1/1/0001 12:00:00 AM" ManualLender="N" IsEnabled="Y">3104</LenderID>
    <LenderID LastProcessed="1/1/0001 12:00:00 AM" ManualLender="N" IsEnabled="Y">7350</LenderID>
    <LenderID LastProcessed="1/1/0001 12:00:00 AM" ManualLender="N" IsEnabled="Y">1574</LenderID>
    <LenderID LastProcessed="1/1/0001 12:00:00 AM" ManualLender="N" IsEnabled="Y">8162</LenderID>
    <LenderID LastProcessed="1/1/0001 12:00:00 AM" ManualLender="N" IsEnabled="Y">2244</LenderID>
    <LenderID LastProcessed="1/1/0001 12:00:00 AM" ManualLender="N" IsEnabled="Y">8500</LenderID>
    <LenderID LastProcessed="1/1/0001 12:00:00 AM" ManualLender="N" IsEnabled="Y">4045</LenderID>
    <LenderID LastProcessed="1/1/0001 12:00:00 AM" ManualLender="N" IsEnabled="Y">4801</LenderID>
    <LenderID LastProcessed="1/1/0001 12:00:00 AM" ManualLender="N" IsEnabled="Y">5115</LenderID>
    <LenderID LastProcessed="1/1/0001 12:00:00 AM" ManualLender="N" IsEnabled="Y">1615</LenderID>
    <LenderID LastProcessed="1/1/0001 12:00:00 AM" ManualLender="N" IsEnabled="Y">4660</LenderID>
    <LenderID LastProcessed="1/1/0001 12:00:00 AM" ManualLender="N" IsEnabled="Y">6497</LenderID>
    <LenderID LastProcessed="1/1/0001 12:00:00 AM" ManualLender="N" IsEnabled="Y">4888</LenderID>
    <LenderID LastProcessed="1/1/0001 12:00:00 AM" ManualLender="N" IsEnabled="Y">4668</LenderID>
    <LenderID LastProcessed="1/1/0001 12:00:00 AM" ManualLender="N" IsEnabled="Y">2295</LenderID>
    <LenderID LastProcessed="1/1/0001 12:00:00 AM" ManualLender="N" IsEnabled="Y">2038</LenderID>
    <LenderID LastProcessed="1/1/0001 12:00:00 AM" ManualLender="N" IsEnabled="Y">1994</LenderID>
    <LenderID LastProcessed="1/1/0001 12:00:00 AM" ManualLender="N" IsEnabled="Y">3000</LenderID>
    <LenderID LastProcessed="1/1/0001 12:00:00 AM" ManualLender="N" IsEnabled="Y">016400</LenderID>
    <LenderID LastProcessed="1/1/0001 12:00:00 AM" ManualLender="N" IsEnabled="Y">4657</LenderID>
    <LenderID LastProcessed="1/1/0001 12:00:00 AM" ManualLender="N" IsEnabled="Y">2268</LenderID>
    <LenderID LastProcessed="1/1/0001 12:00:00 AM" ManualLender="N" IsEnabled="Y">7034</LenderID>
    <LenderID LastProcessed="1/1/0001 12:00:00 AM" ManualLender="N" IsEnabled="Y">3057</LenderID>
    <LenderID LastProcessed="1/1/0001 12:00:00 AM" ManualLender="N" IsEnabled="Y">4266</LenderID>
    <LenderID LastProcessed="1/1/0001 12:00:00 AM" ManualLender="N" IsEnabled="Y">3585</LenderID>
    <LenderID LastProcessed="1/1/0001 12:00:00 AM" ManualLender="N" IsEnabled="Y">5150</LenderID>
    <LenderID LastProcessed="1/1/0001 12:00:00 AM" ManualLender="N" IsEnabled="Y">3525</LenderID>
    <LenderID LastProcessed="1/1/0001 12:00:00 AM" ManualLender="N" IsEnabled="Y">2107</LenderID>
    <LenderID LastProcessed="1/1/0001 12:00:00 AM" ManualLender="N" IsEnabled="Y">1931</LenderID>
    <LenderID LastProcessed="1/1/0001 12:00:00 AM" ManualLender="N" IsEnabled="Y">2725</LenderID>
    <LenderID LastProcessed="1/1/0001 12:00:00 AM" ManualLender="N" IsEnabled="Y">4750</LenderID>
    <LenderID LastProcessed="1/1/0001 12:00:00 AM" ManualLender="N" IsEnabled="Y">13100</LenderID>
    <LenderID LastProcessed="1/1/0001 12:00:00 AM" ManualLender="N" IsEnabled="Y">4105</LenderID>
    <LenderID LastProcessed="1/1/0001 12:00:00 AM" ManualLender="N" IsEnabled="Y">4286</LenderID>
  </LenderList>
  <ServiceCapabilityList>
    <SystemRamInGB />
    <SystemProcessorCount />
  </ServiceCapabilityList>
</ProcessDefinitionSettings>'
WHERE ID IN --(711279)
(711281)

SELECT  SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/TargetServiceList/TargetService)[1]',
                              'nvarchar(max)') [Target Service] ,* FROM dbo.PROCESS_DEFINITION
WHERE ID IN (711279,711280,711281,711292)


SELECT DISTINCT EXECUTION_FREQ_CD, COUNT(EXECUTION_FREQ_CD) FROM dbo.PROCESS_DEFINITION
GROUP BY EXECUTION_FREQ_CD



UPDATE  PD
SET     SETTINGS_XML_IM.modify('replace value of (/ProcessDefinitionSettings/TargetServiceList/TargetService/text())[1] with "UTLMatch"') ,
        LOCK_ID = LOCK_ID + 1 ,
        UPDATE_DT = GETDATE() ,
        ACTIVE_IN = 'Y' ,
        ONHOLD_IN = 'N'
--SELECT * 
FROM    dbo.PROCESS_DEFINITION PD
WHERE   ID = '711279'


UPDATE  PD
SET     SETTINGS_XML_IM.modify('replace value of (/ProcessDefinitionSettings/TargetServiceList/TargetService/text())[1] with "UTLRematchRepoPlus"') ,
        LOCK_ID = LOCK_ID + 1 ,
        UPDATE_DT = GETDATE() ,
        ACTIVE_IN = 'Y' ,
        ONHOLD_IN = 'N'
--SELECT * 
FROM    dbo.PROCESS_DEFINITION PD
WHERE   ID = '711280'


UPDATE  PD
SET     SETTINGS_XML_IM.modify('replace value of (/ProcessDefinitionSettings/TargetServiceList/TargetService/text())[1] with "UTLRematchDefault"') ,
        LOCK_ID = LOCK_ID + 1 ,
        UPDATE_DT = GETDATE() ,
        ACTIVE_IN = 'Y' ,
        ONHOLD_IN = 'N'
--SELECT * 
FROM    dbo.PROCESS_DEFINITION PD
WHERE   ID = '711292'



update pd
set active_in = 'Y', onhold_in = 'N'
--select *
from process_definition pd
 WHERE ID IN (711279,711280,711281,711292)


 UPDATE U SET SYSTEM_IN = 'Y'
 --select * 
 from users u
 where family_name_tx = 'SERVER'
 AND ID IN (3251,3252,3253,3254)


 USE [master]
GO

/* For security reasons the login is created disabled and with a random password. */
/****** Object:  Login [UTdbUBSMatchOutProd]    Script Date: 3/21/2018 6:41:29 PM ******/
CREATE LOGIN [UTdbUTLMatch] WITH PASSWORD=N'N4EEb5UKPFKA7upDlsHp', DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO

CREATE LOGIN [UTdbUTLRematchRepoPlus] WITH PASSWORD=N'iZGMEhN6EQctyaXls9BA', DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO


ALTER SERVER ROLE [sysadmin] ADD MEMBER [UTdbUTLMatch]
GO


ALTER SERVER ROLE [sysadmin] ADD MEMBER [UTdbUTLRematchRepoPlus]
GO


CREATE LOGIN [UTdbUTLRematchMidSizeLenders] WITH PASSWORD=N'jNKSEp0S0N9Gia1LmTNK', DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO


ALTER SERVER ROLE [sysadmin] ADD MEMBER [UTdbUTLRematchMidSizeLenders]
GO




CREATE LOGIN [UTdbUTLRematchDefault] WITH PASSWORD=N'jNKSEp0S0N9Gia1LmTNK', DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO


ALTER SERVER ROLE [sysadmin] ADD MEMBER [UTdbUTLRematchDefault]
GO


select * from process_log
where process_definition_id IN (711279,711280,711281,711292)



select *
from process_definition pd
 WHERE ID IN (711279,711280,711281,711292)
