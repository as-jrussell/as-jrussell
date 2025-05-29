USE UniTrac


----MOST OF THE DATA
--drop table #tmp
select *	    into #tmp
FROM   dbo.PROCESS_DEFINITION PD
where PROCESS_TYPE_CD IN ('BILLING','CYCLEPRC')
and  pd.ACTIVE_IN = 'Y' AND pd.ONHOLD_IN = 'N' and pd.EXECUTION_FREQ_CD <> 'RUNONCE' 



SELECT distinct
       pd.NAME_TX 
	   ,pd2.EXECUTION_FREQ_CD [Cycle Frequency] ,
       pd1.EXECUTION_FREQ_CD [Billing Frequency] ,
       pd2.LAST_RUN_DT [Cycle Last Run Date],
	   pd1.LAST_RUN_DT [Billing Last Run Date],
	   pd.PROCESS_TYPE_CD
	--    into UnitracHDStorage..INC0375989
FROM  #tmp pd
left join dbo.PROCESS_DEFINITION pd1 on pd1.id =pd.id and pd1.PROCESS_TYPE_CD=  'BILLING' 
left join dbo.PROCESS_DEFINITION pd2 on pd2.id =pd.id and pd2.PROCESS_TYPE_CD=  'CYCLEPRC' 




/*
User wants to add the Basic Type and Basic Sub Type, the 
Ids are in the XML along with the LenderId. Below is what
I have tried but did not work as well as thought. 


*/



--drop table #tmp
SELECT top 5
SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/LCGCTList/LCGCTId)[1]','nvarchar(max)')	LCGCTId1	,
SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/LCGCTList/LCGCTId)[2]','nvarchar(max)')	LCGCTId2	,
SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/LCGCTList/LCGCTId)[3]','nvarchar(max)')	LCGCTId3	,
SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/LCGCTList/LCGCTId)[4]','nvarchar(max)')	LCGCTId4	,
SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/LCGCTList/LCGCTId)[5]','nvarchar(max)')	LCGCTId5	,
SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/LCGCTList/LCGCTId)[6]','nvarchar(max)')	LCGCTId6	,
SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/LCGCTList/LCGCTId)[7]','nvarchar(max)')	LCGCTId7	,
SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/LCGCTList/LCGCTId)[8]','nvarchar(max)')	LCGCTId8	,
SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/LCGCTList/LCGCTId)[9]','nvarchar(max)')	LCGCTId9	,
SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/LCGCTList/LCGCTId)[10]','nvarchar(max)')	LCGCTId10	,
SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/LCGCTList/LCGCTId)[11]','nvarchar(max)')	LCGCTId11	,
SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/LCGCTList/LCGCTId)[12]','nvarchar(max)')	LCGCTId12	,
SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/LCGCTList/LCGCTId)[13]','nvarchar(max)')	LCGCTId13	,
SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/LCGCTList/LCGCTId)[14]','nvarchar(max)')	LCGCTId14	,
SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/LCGCTList/LCGCTId)[15]','nvarchar(max)')	LCGCTId15	,
SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/LCGCTList/LCGCTId)[16]','nvarchar(max)')	LCGCTId16	,
SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/LCGCTList/LCGCTId)[17]','nvarchar(max)')	LCGCTId17	,
SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/LCGCTList/LCGCTId)[18]','nvarchar(max)')	LCGCTId18	,
SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/LCGCTList/LCGCTId)[19]','nvarchar(max)')	LCGCTId19	,
SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/LCGCTList/LCGCTId)[20]','nvarchar(max)')	LCGCTId20	,
SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/LCGCTList/LCGCTId)[21]','nvarchar(max)')	LCGCTId21	,
SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/LCGCTList/LCGCTId)[22]','nvarchar(max)')	LCGCTId22	,
SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/LCGCTList/LCGCTId)[23]','nvarchar(max)')	LCGCTId23	,
SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/LCGCTList/LCGCTId)[24]','nvarchar(max)')	LCGCTId24	,
SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/LCGCTList/LCGCTId)[25]','nvarchar(max)')	LCGCTId25	,
SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/LCGCTList/LCGCTId)[26]','nvarchar(max)')	LCGCTId26	,
SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/LCGCTList/LCGCTId)[27]','nvarchar(max)')	LCGCTId27	,
SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/LCGCTList/LCGCTId)[28]','nvarchar(max)')	LCGCTId28	,
SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/LCGCTList/LCGCTId)[29]','nvarchar(max)')	LCGCTId29	,
SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/LCGCTList/LCGCTId)[30]','nvarchar(max)')	LCGCTId30	,
SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/LCGCTList/LCGCTId)[31]','nvarchar(max)')	LCGCTId31	,
SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/LCGCTList/LCGCTId)[32]','nvarchar(max)')	LCGCTId32	,
SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/LCGCTList/LCGCTId)[33]','nvarchar(max)')	LCGCTId33	,
SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/LCGCTList/LCGCTId)[34]','nvarchar(max)')	LCGCTId34	,
SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/LCGCTList/LCGCTId)[35]','nvarchar(max)')	LCGCTId35	,
SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/LCGCTList/LCGCTId)[36]','nvarchar(max)')	LCGCTId36	,
SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/LCGCTList/LCGCTId)[37]','nvarchar(max)')	LCGCTId37	,
SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/LCGCTList/LCGCTId)[38]','nvarchar(max)')	LCGCTId38	,
SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/LCGCTList/LCGCTId)[39]','nvarchar(max)')	LCGCTId39	,
SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/LCGCTList/LCGCTId)[40]','nvarchar(max)')	LCGCTId40	,
SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/LCGCTList/LCGCTId)[41]','nvarchar(max)')	LCGCTId41	,
SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/LCGCTList/LCGCTId)[42]','nvarchar(max)')	LCGCTId42	,
SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/LCGCTList/LCGCTId)[43]','nvarchar(max)')	LCGCTId43	,
SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/LCGCTList/LCGCTId)[44]','nvarchar(max)')	LCGCTId44	,
SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/LCGCTList/LCGCTId)[45]','nvarchar(max)')	LCGCTId45	,
SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/LCGCTList/LCGCTId)[46]','nvarchar(max)')	LCGCTId46	,
SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/LCGCTList/LCGCTId)[47]','nvarchar(max)')	LCGCTId47	,
SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/LCGCTList/LCGCTId)[48]','nvarchar(max)')	LCGCTId48	,
SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/LCGCTList/LCGCTId)[49]','nvarchar(max)')	LCGCTId49	,
SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/LCGCTList/LCGCTId)[50]','nvarchar(max)')	LCGCTId50	,
SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/LCGCTList/LCGCTId)[51]','nvarchar(max)')	LCGCTId51	,
SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/LCGCTList/LCGCTId)[52]','nvarchar(max)')	LCGCTId52	,
SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/LCGCTList/LCGCTId)[53]','nvarchar(max)')	LCGCTId53	,
SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/LCGCTList/LCGCTId)[54]','nvarchar(max)')	LCGCTId54	,
SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/LCGCTList/LCGCTId)[55]','nvarchar(max)')	LCGCTId55	,
SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/LCGCTList/LCGCTId)[56]','nvarchar(max)')	LCGCTId56	,
SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/LCGCTList/LCGCTId)[57]','nvarchar(max)')	LCGCTId57	,
SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/LCGCTList/LCGCTId)[58]','nvarchar(max)')	LCGCTId58	,
SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/LCGCTList/LCGCTId)[59]','nvarchar(max)')	LCGCTId59	,
SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/LCGCTList/LCGCTId)[60]','nvarchar(max)')	LCGCTId60	,
SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/LCGCTList/LCGCTId)[61]','nvarchar(max)')	LCGCTId61	,
SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/LCGCTList/LCGCTId)[62]','nvarchar(max)')	LCGCTId62	,
      *
	    into #tmp
FROM   dbo.PROCESS_DEFINITION PD
where PROCESS_TYPE_CD IN ('BILLING','CYCLEPRC')
and  pd.ACTIVE_IN = 'Y' AND pd.ONHOLD_IN = 'N' and pd.EXECUTION_FREQ_CD <> 'RUNONCE' 



SELECT distinct
       pd.NAME_TX 
	   ,pd2.EXECUTION_FREQ_CD [Cycle Frequency] ,
       pd1.EXECUTION_FREQ_CD [Billing Frequency] ,
       pd2.LAST_RUN_DT [Cycle Last Run Date],
	   pd1.LAST_RUN_DT [Billing Last Run Date],
	   pd.PROCESS_TYPE_CD, rc1.DESCRIPTION_TX [BASIC_TYPE_CD], rc2.DESCRIPTION_TX [BASIC_SUB_TYPE_CD],lp2.*
	--    into UnitracHDStorage..INC0375989
FROM  #tmp pd
left join dbo.LENDER_PRODUCT LP ON LP.ID = pd.LCGCTId1
left join dbo.LENDER_PRODUCT	LP2	ON LP.ID = pd.LCGCTId2
left join dbo.LENDER_PRODUCT	LP3	ON LP.ID = pd.LCGCTId3
left join dbo.LENDER_PRODUCT	LP4	ON LP.ID = pd.LCGCTId4
left join dbo.LENDER_PRODUCT	LP5	ON LP.ID = pd.LCGCTId5
left join dbo.LENDER_PRODUCT	LP6	ON LP.ID = pd.LCGCTId6
left join dbo.LENDER_PRODUCT	LP7	ON LP.ID = pd.LCGCTId7
left join dbo.LENDER_PRODUCT	LP8	ON LP.ID = pd.LCGCTId8
left join dbo.LENDER_PRODUCT	LP9	ON LP.ID = pd.LCGCTId9
left join dbo.LENDER_PRODUCT	LP10	ON LP.ID = pd.LCGCTId10
left join dbo.LENDER_PRODUCT	LP11	ON LP.ID = pd.LCGCTId11
left join dbo.LENDER_PRODUCT	LP12	ON LP.ID = pd.LCGCTId12
left join dbo.LENDER_PRODUCT	LP13	ON LP.ID = pd.LCGCTId13
left join dbo.LENDER_PRODUCT	LP14	ON LP.ID = pd.LCGCTId14
left join dbo.LENDER_PRODUCT	LP15	ON LP.ID = pd.LCGCTId15
left join dbo.LENDER_PRODUCT	LP16	ON LP.ID = pd.LCGCTId16
left join dbo.LENDER_PRODUCT	LP17	ON LP.ID = pd.LCGCTId17
left join dbo.LENDER_PRODUCT	LP18	ON LP.ID = pd.LCGCTId18
left join dbo.LENDER_PRODUCT	LP19	ON LP.ID = pd.LCGCTId19
left join dbo.LENDER_PRODUCT	LP20	ON LP.ID = pd.LCGCTId20
left join dbo.LENDER_PRODUCT	LP21	ON LP.ID = pd.LCGCTId21
left join dbo.LENDER_PRODUCT	LP22	ON LP.ID = pd.LCGCTId22
left join dbo.LENDER_PRODUCT	LP23	ON LP.ID = pd.LCGCTId23
left join dbo.LENDER_PRODUCT	LP24	ON LP.ID = pd.LCGCTId24
left join dbo.LENDER_PRODUCT	LP25	ON LP.ID = pd.LCGCTId25
left join dbo.LENDER_PRODUCT	LP26	ON LP.ID = pd.LCGCTId26
left join dbo.LENDER_PRODUCT	LP27	ON LP.ID = pd.LCGCTId27
left join dbo.LENDER_PRODUCT	LP28	ON LP.ID = pd.LCGCTId28
left join dbo.LENDER_PRODUCT	LP29	ON LP.ID = pd.LCGCTId29
left join dbo.LENDER_PRODUCT	LP30	ON LP.ID = pd.LCGCTId30
left join dbo.LENDER_PRODUCT	LP31	ON LP.ID = pd.LCGCTId31
left join dbo.LENDER_PRODUCT	LP32	ON LP.ID = pd.LCGCTId32
left join dbo.LENDER_PRODUCT	LP33	ON LP.ID = pd.LCGCTId33
left join dbo.LENDER_PRODUCT	LP34	ON LP.ID = pd.LCGCTId34
left join dbo.LENDER_PRODUCT	LP35	ON LP.ID = pd.LCGCTId35
left join dbo.LENDER_PRODUCT	LP36	ON LP.ID = pd.LCGCTId36
left join dbo.LENDER_PRODUCT	LP37	ON LP.ID = pd.LCGCTId37
left join dbo.LENDER_PRODUCT	LP38	ON LP.ID = pd.LCGCTId38
left join dbo.LENDER_PRODUCT	LP39	ON LP.ID = pd.LCGCTId39
left join dbo.LENDER_PRODUCT	LP40	ON LP.ID = pd.LCGCTId40
left join dbo.LENDER_PRODUCT	LP41	ON LP.ID = pd.LCGCTId41
left join dbo.LENDER_PRODUCT	LP42	ON LP.ID = pd.LCGCTId42
left join dbo.LENDER_PRODUCT	LP43	ON LP.ID = pd.LCGCTId43
left join dbo.LENDER_PRODUCT	LP44	ON LP.ID = pd.LCGCTId44
left join dbo.LENDER_PRODUCT	LP45	ON LP.ID = pd.LCGCTId45
left join dbo.LENDER_PRODUCT	LP46	ON LP.ID = pd.LCGCTId46
left join dbo.LENDER_PRODUCT	LP47	ON LP.ID = pd.LCGCTId47
left join dbo.LENDER_PRODUCT	LP48	ON LP.ID = pd.LCGCTId48
left join dbo.LENDER_PRODUCT	LP49	ON LP.ID = pd.LCGCTId49
left join dbo.LENDER_PRODUCT	LP50	ON LP.ID = pd.LCGCTId50
left join dbo.LENDER_PRODUCT	LP51	ON LP.ID = pd.LCGCTId51
left join dbo.LENDER_PRODUCT	LP52	ON LP.ID = pd.LCGCTId52
left join dbo.LENDER_PRODUCT	LP53	ON LP.ID = pd.LCGCTId53
left join dbo.LENDER_PRODUCT	LP54	ON LP.ID = pd.LCGCTId54
left join dbo.LENDER_PRODUCT	LP55	ON LP.ID = pd.LCGCTId55
left join dbo.LENDER_PRODUCT	LP56	ON LP.ID = pd.LCGCTId56
left join dbo.LENDER_PRODUCT	LP57	ON LP.ID = pd.LCGCTId57
left join dbo.LENDER_PRODUCT	LP58	ON LP.ID = pd.LCGCTId58
left join dbo.LENDER_PRODUCT	LP59	ON LP.ID = pd.LCGCTId59
left join dbo.LENDER_PRODUCT	LP60	ON LP.ID = pd.LCGCTId60
left join dbo.LENDER_PRODUCT	LP61	ON LP.ID = pd.LCGCTId61
left join dbo.LENDER_PRODUCT	LP62	ON LP.ID = pd.LCGCTId62
left join dbo.PROCESS_DEFINITION pd1 on pd1.id =pd.id and pd1.PROCESS_TYPE_CD=  'BILLING' 
left join dbo.PROCESS_DEFINITION pd2 on pd2.id =pd.id and pd2.PROCESS_TYPE_CD=  'CYCLEPRC' 
left join ref_code rc1 on rc1.code_cd = lp.BASIC_TYPE_CD and rc1.domain_cd = 'LenderProductBasicType'
left join ref_code rc2 on rc2.code_cd = lp.BASIC_SUB_TYPE_CD and rc2.domain_cd = 'LenderProductBasicSubType'
where  pd.NAME_TX  like '%usdtest1%'
--LenderProductBasicType
--LenderProductBasicSubType


select * from #tmp

select * from process_definition
where id in (54)

select * from 