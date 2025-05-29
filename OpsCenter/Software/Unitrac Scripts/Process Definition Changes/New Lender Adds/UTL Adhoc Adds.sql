use utl

SELECT  SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/TargetServiceList/TargetService)[1]',
                              'nvarchar(max)') [Target Service] ,
SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/AnticipatedNextScheduledDate)[1]',
                                    'varchar(50)'),
SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/LenderID)[1]',
                                    'varchar(50)'),
 * from PROCESS_DEFINITION
 where id = 10




---CTRL H to do a quick replace and replace LENDERCODE to the lender code. 

update PROCESS_DEFINITION
SET SETTINGS_XML_IM.modify('insert    <LenderID LastProcessed="1/1/0001 12:00:00 AM" ManualLender="N" IsEnabled="Y">LENDERCODE</LenderID> into (/ProcessDefinitionSettings/LenderList)[1]')
where ID = 10
 

