use unitrac

select SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/AnticipatedNextScheduledDate)[1]',
                                    'varchar(50)') [AnticipatedNextScheduledDate],
 SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/TargetServiceList/TargetService)[1]',
                              'nvarchar(max)') ,
* from PROCESS_DEFINITION where  PROCESS_TYPE_CD='escrow'
and status_cd != 'Expired' and execution_freq_cd = 'RUNONCE'
and active_in = 'Y' and onhold_in = 'N' and purge_dt is null


--In the Meaning_TX field is the default service if altered the Escrow API will need to be recycled on UTPROD-API-01
select * from ref_code
where domain_cd like 'system'
and id = 6825
