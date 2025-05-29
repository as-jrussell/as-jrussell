use unitrac



---CTRL H to do a quick replace and replace LENDERCODE to the lender code. 

update PROCESS_DEFINITION
SET SETTINGS_XML_IM.modify('insert <LenderID>LENDERCODE</LenderID> into (/ProcessDefinitionSettings/LenderList)[1]')
where ID = 199525
 
update PROCESS_DEFINITION
SET SETTINGS_XML_IM.modify('insert <LenderID>LENDERCODE</LenderID> into (/ProcessDefinitionSettings/InsuranceDocTypeSettings/LenderList)[1]')
where ID = 39        

update PROCESS_DEFINITION
SET SETTINGS_XML_IM.modify('insert <LenderID>LENDERCODE</LenderID> into (/ProcessDefinitionSettings/InsuranceDocTypeSettings/LenderList)[2]')
where ID = 39         

update PROCESS_DEFINITION
SET SETTINGS_XML_IM.modify('insert <LenderID>LENDERCODE</LenderID> into (/ProcessDefinitionSettings/InsuranceDocTypeSettings/LenderList)[3]')
where ID = 39         

update PROCESS_DEFINITION
SET SETTINGS_XML_IM.modify('insert <LenderID>LENDERCODE</LenderID> into (/ProcessDefinitionSettings/LenderList)[1]')
where ID = 336
 


      
      




