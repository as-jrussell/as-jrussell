use unitrac

select CONTENT_XML.value('(/Content/Escrow/Regenerated)[1]', 'varchar (max)'),
CONTENT_XML.value('(/Content/ProcessDefinition/ProcessDefinitionId)[1]', 'varchar (max)')[Fiserv],
CONTENT_XML.value('(/Content/Message/MessageId)[1]', 'varchar (max)')[Message], 
* from work_item
where id in (59101111, 59173219, 61253540,  )

select * from work_item_action
where work_item_id in (56196371,57041706,57938626 )
and action_cd = 'Generate Escrow File'

Generate Escrow File - Process Definition (Id=1022090) was created
Process Definition (Id=1022090) is complete; FiServ Process (PD Id=1022095) was created

Generate Escrow File - Process Definition (Id=998720) was created
Generate Escrow File - Process Definition (Id=998732) was created
Generate Escrow File - Process Definition (Id=1005602) was created
Generate Escrow File - Process Definition (Id=1009342) was created

select * from process_definition
where id in (998720,  998732,1005602,1009342)

select * from work_item_action
where work_item_id in (56196371,57041706,57938626 )
and action_cd = 'Add Note Only'

select * from ref_code
where code_cd = 'FISERVOBU'

Process Definition (Id=998720) is complete; FiServ Process (PD Id=998723) was created
Process Definition (Id=998732) is complete; FiServ Process (PD Id=998723) was created
Process Definition (Id=1005602) is complete; FiServ Process (PD Id=1005604) was created
Process Definition (Id=1009342) is complete; FiServ Process (PD Id=1009346) was created

select * from process_definition
where id in (998723, 1005604, 1009346)


(56196371,57041706,57938626 )


select * from trading_partner_log
where log_message like '%57938626%'
and create_dt >= '2019-07-01'


select * from message
where id in (22043185,22144090)


SELECT * FROM dbo.MESSAGE
WHERE ID IN  (23220728) OR RELATE_ID_TX IN  (23220728)


56196371 - Output File : \\as.local\shared\CarmelShares\PenFed_Escrow\ESC-2771.56196371-20190802123718.txt created for Document ID : 32410065


select SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/AnticipatedNextScheduledDate)[1]',
                                    'varchar(50)') [AnticipatedNextScheduledDate],
 SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/TargetServiceList/TargetService)[1]',
                              'nvarchar(max)') , pd.update_dt,
							  * 
							-- into #tmp 
							  FROM dbo.PROCESS_DEFINITION pd
							  WHERE  SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/TargetServiceList/TargetService)[1]',
                              'nvarchar(max)') like ('UnitracBusinessService')
							  AND ACTIVE_IN = 'Y' AND ONHOLD_IN = 'N' --and process_type_cd = 'CYCLEPRC'
							  and Status_cd != 'Expired'
							  order by pd.update_dt