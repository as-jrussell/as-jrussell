SELECT US.SystemName , PD.* FROM UniTrac..PROCESS_DEFINITION PD
INNER JOIN UniTracHDStorage..unitracservices US ON PD.SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/TargetServiceList/TargetService)[1]', 'nvarchar(max)') = US.Name
WHERE PD.ID IN ( 269928, 269947)

