-- Ref Domain/Attribue/Code Variables
DECLARE @domainCD as varchar(max) = 'TextTemplate'
DECLARE @codeCD as varchar(max)
DECLARE @meaning as varchar(max)
DECLARE @description as varchar(max)
DECLARE @attributeCD as varchar(max)
DECLARE @attributeValue as varchar(max)

-- Add Text Template Payment Reminder 5-Day
set @codeCD = 'PR5D'
set @meaning = 'Payment Reminder: 5-Day'
set @description = 'Payment Reminder: 5-Day'
IF NOT EXISTS(select * from REF_CODE where DOMAIN_CD = @domainCD AND CODE_CD = @codeCD)
   INSERT INTO REF_CODE
   (CODE_CD,DOMAIN_CD,MEANING_TX,DESCRIPTION_TX,ACTIVE_IN,CREATE_DT,UPDATE_DT,UPDATE_USER_TX,LOCK_ID,AGENCY_ID,ORDER_NO)
   VALUES 
   (@codeCD,@domainCD,@meaning,@description,'Y',GETDATE(),GETDATE(),'admin',1,0,999)   

set @attributeCD = 'SbTTemplateId'
set @attributeValue = '1'
IF NOT EXISTS(select * from REF_CODE_ATTRIBUTE where DOMAIN_CD = @domainCD AND REF_CD = @codeCD and ATTRIBUTE_CD = @attributeCD)
   INSERT INTO REF_CODE_ATTRIBUTE
   (ATTRIBUTE_CD,REF_CD,DOMAIN_CD,VALUE_TX,CREATE_DT,UPDATE_DT,UPDATE_USER_TX,LOCK_ID,AGENCY_ID)
   VALUES
   (@attributeCD,@codeCD,@domainCD,@attributeValue,GETDATE(),GETDATE(),'admin',1,0)

-- Add Text Template Payment Reminder 1-Day
set @codeCD = 'PR1D'
set @meaning = 'Payment Reminder: 1-Day'
set @description = 'Payment Reminder: 1-Day'
IF NOT EXISTS(select * from REF_CODE where DOMAIN_CD = @domainCD AND CODE_CD = @codeCD)
   INSERT INTO REF_CODE
   (CODE_CD,DOMAIN_CD,MEANING_TX,DESCRIPTION_TX,ACTIVE_IN,CREATE_DT,UPDATE_DT,UPDATE_USER_TX,LOCK_ID,AGENCY_ID,ORDER_NO)
   VALUES 
   (@codeCD,@domainCD,@meaning,@description,'Y',GETDATE(),GETDATE(),'admin',1,0,999)   

set @attributeCD = 'SbTTemplateId'
set @attributeValue = '2'
IF NOT EXISTS(select * from REF_CODE_ATTRIBUTE where DOMAIN_CD = @domainCD AND REF_CD = @codeCD and ATTRIBUTE_CD = @attributeCD)
   INSERT INTO REF_CODE_ATTRIBUTE
   (ATTRIBUTE_CD,REF_CD,DOMAIN_CD,VALUE_TX,CREATE_DT,UPDATE_DT,UPDATE_USER_TX,LOCK_ID,AGENCY_ID)
   VALUES
   (@attributeCD,@codeCD,@domainCD,@attributeValue,GETDATE(),GETDATE(),'admin',1,0)
   
-- Add Text Template Missed Payment Notice
set @codeCD = 'MPN'
set @meaning = 'Missed Payment Notice'
set @description = 'Missed Payment Notice'
IF NOT EXISTS(select * from REF_CODE where DOMAIN_CD = @domainCD AND CODE_CD = @codeCD)
   INSERT INTO REF_CODE
   (CODE_CD,DOMAIN_CD,MEANING_TX,DESCRIPTION_TX,ACTIVE_IN,CREATE_DT,UPDATE_DT,UPDATE_USER_TX,LOCK_ID,AGENCY_ID,ORDER_NO)
   VALUES 
   (@codeCD,@domainCD,@meaning,@description,'Y',GETDATE(),GETDATE(),'admin',1,0,999)   

set @attributeCD = 'SbTTemplateId'
set @attributeValue = '3'
IF NOT EXISTS(select * from REF_CODE_ATTRIBUTE where DOMAIN_CD = @domainCD AND REF_CD = @codeCD and ATTRIBUTE_CD = @attributeCD)
   INSERT INTO REF_CODE_ATTRIBUTE
   (ATTRIBUTE_CD,REF_CD,DOMAIN_CD,VALUE_TX,CREATE_DT,UPDATE_DT,UPDATE_USER_TX,LOCK_ID,AGENCY_ID)
   VALUES
   (@attributeCD,@codeCD,@domainCD,@attributeValue,GETDATE(),GETDATE(),'admin',1,0)
