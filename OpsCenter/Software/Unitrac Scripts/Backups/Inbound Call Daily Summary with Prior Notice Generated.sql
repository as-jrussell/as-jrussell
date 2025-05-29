--Declare @Begin_date as date = '12/05/2017'

declare @ConvertBegin_Date as nvarchar(max)
set @ConvertBegin_Date = Convert(date, @Begin_Date, 101)
set @ConvertBegin_Date = Cast(@ConvertBegin_Date as nvarchar(max))
DECLARE @CallDate as varchar(max) = DATEADD (D , -1 , @Begin_Date ) 
Declare @BeginDate as Date = DATEADD (D , -1 , @CallDate ) ;
declare @ConvertBeginDate as varchar(max)
set @ConvertBeginDate = Convert(date, @BeginDate, 101)
set @ConvertBeginDate = Cast(@ConvertBeginDate as nvarchar(max))


declare @ConvertCallDate as nvarchar(max)
set @ConvertCallDate = Convert(date, @Begin_Date, 101)
set @ConvertCallDate = Cast(@ConvertCallDate as nvarchar(max))
declare @sql nvarchar(max)  = '';
declare @newid nvarchar(max) = replace((select NEWID()), '-', '');

set @sql = 
'

IF OBJECT_ID(''tempdb.dbo.#' + @newid + 'allcalls'') IS not NULL
DROP TABLE tempdb.dbo.#' + @newid + 'allcalls
IF OBJECT_ID(''tempdb.dbo.#' + @newid + 'GetPid'') IS not NULL
DROP TABLE tempdb.dbo.#' + @newid + 'GetPid
IF OBJECT_ID(''tempdb.dbo.#' + @newid + 'InboundCallsOrig'') IS not NULL
DROP TABLE tempdb.dbo.#' + @newid + 'InboundCallsOrig
IF OBJECT_ID(''tempdb.dbo.#' + @newid + 'toptwowinners'') IS not NULL
DROP TABLE tempdb.dbo.#' + @newid + 'toptwowinners
IF OBJECT_ID(''tempdb.dbo.#' + @newid + 'closest_of_the_two'') IS not NULL
DROP TABLE tempdb.dbo.#' + @newid + 'closest_of_the_two
IF OBJECT_ID(''tempdb.dbo.#' + @newid + 'dupesplus'') IS not NULL
DROP TABLE #' + @newid + 'dupesplus

IF OBJECT_ID(''tempdb.dbo.#' + @newid + 'cottPlus'') IS not NULL
DROP TABLE tempdb.dbo.#' + @newid + 'cottPlus

IF OBJECT_ID(''tempdb.dbo.#' + @newid + 'miniProp'') IS not NULL
DROP TABLE tempdb.dbo.#' + @newid + 'miniProp
IF OBJECT_ID(''tempdb.dbo.#' + @newid + 'miniCollateral'') IS not NULL
DROP TABLE tempdb.dbo.#' + @newid + 'miniCollateral
IF OBJECT_ID(''tempdb.dbo.#' + @newid + 'miniCollateral_CODE'') IS not NULL
DROP TABLE tempdb.dbo.#' + @newid + 'miniCollateral_CODE
IF OBJECT_ID(''tempdb.dbo.#' + @newid + 'miniOwnerAddress'') IS not NULL
DROP TABLE tempdb.dbo.#' + @newid + 'miniOwnerAddress
IF OBJECT_ID(''tempdb.dbo.#' + @newid + 'miniOwner'') IS not NULL
DROP TABLE tempdb.dbo.#' + @newid + 'miniOwner
IF OBJECT_ID(''tempdb.dbo.#' + @newid + 'miniLoan'') IS not NULL
DROP TABLE tempdb.dbo.#' + @newid + 'miniLoan
IF OBJECT_ID(''tempdb.dbo.#' + @newid + 'miniLender'') IS not NULL
DROP TABLE tempdb.dbo.#' + @newid + 'miniLender
IF OBJECT_ID(''tempdb.dbo.#' + @newid + 'altCollateral'') IS not NULL
DROP TABLE tempdb.dbo.#' + @newid + 'altCollateral
IF OBJECT_ID(''tempdb.dbo.#' + @newid + 'VehicleInfo'') IS not NULL
DROP TABLE tempdb.dbo.#' + @newid + 'VehicleInfo
IF OBJECT_ID(''tempdb.dbo.#' + @newid + 'miniNewNote'') IS not NULL
DROP TABLE tempdb.dbo.#' + @newid + 'miniNewNote
IF OBJECT_ID(''tempdb.dbo.#' + @newid + 'NoticeWinners'') IS not NULL
DROP TABLE tempdb.dbo.#' + @newid + 'NoticeWinners
IF OBJECT_ID(''tempdb.dbo.#' + @newid + 'CPIWinners'') IS not NULL
DROP TABLE tempdb.dbo.#' + @newid + 'CPIWinners
IF OBJECT_ID(''tempdb.dbo.#' + @newid + 'miniRequired_Coverage'') IS not NULL
DROP TABLE tempdb.dbo.#' + @newid + 'miniRequired_Coverage
IF OBJECT_ID(''tempdb.dbo.#' + @newid + 'miniOwner_Loan_Relate'') IS not NULL
DROP TABLE tempdb.dbo.#' + @newid + 'miniOwner_Loan_Relate
IF OBJECT_ID(''tempdb.dbo.#' + @newid + 'miniNotice'') IS not NULL
DROP TABLE tempdb.dbo.#' + @newid + 'miniNotice
IF OBJECT_ID(''tempdb.dbo.#' + @newid + 'NoticeID'') IS not NULL
DROP TABLE tempdb.dbo.#' + @newid + 'NoticeID 
IF OBJECT_ID(''tempdb.dbo.#' + @newid + 'FinalSelect'') IS not NULL
DROP TABLE tempdb.dbo.#' + @newid + 'FinalSelect





selEct   ROW_NUMBER() OVER(ORDER BY id ASC) AS RowNumb, id as acid,type_cd as actype_cd,SPECIAL_HANDLING_XML.value(''(/SH/RC/.)[1]'', ''BIGINT'') as acrc_id,Loan_id as acLoan_id,Property_id as acProperty_id, Special_handling_xml as acSpecial_handling_xml,create_dt as accreate_dt, 
PURGE_DT as acPURGE_DT

INTO #' + @newid + 'allcalls
from INTERACTION_HISTORY 
where 1=1
and INTERACTION_HISTORY.TYPE_CD = ''INBNDCALL''
and (cast(INTERACTION_HISTORY.CREATE_DT as date) =  ''' + @ConvertBegin_Date + '''
 and INTERACTION_HISTORY.PURGE_DT is  null)


 select distinct  ac.acPROPERTY_ID, ac.RowNumb,acLoan_id
into #' + @newid + 'GetPid 
from #' + @newid + 'allcalls ac

select 
gp.RowNumb,
INTERACTION_HISTORY.ID as IBC_ID, 
INTERACTION_HISTORY.SPECIAL_HANDLING_XML.value(''(/SH/RC/.)[1]'', ''BIGINT'') as ''RC_ID_Required_C'', 
COALESCE(INTERACTION_HISTORY.special_handling_xml.value(''(/SH[1]/MailDate)[1]'',''datetime''),INTERACTION_HISTORY.CREATE_DT) as MailDate,
datediff(day, INTERACTION_HISTORY.CREATE_DT, ''' + @ConvertCallDate + ''') as daysinbetween,
ROW_NUMBER() over(partition by gp.acPROPERTY_ID,INTERACTION_HISTORY.TYPE_CD order by datediff(hour, INTERACTION_HISTORY.CREATE_DT, ''' + @ConvertCallDate + ''') ) as ranking,
INTERACTION_HISTORY.SPECIAL_HANDLING_XML.value(''(/SH/RC/.)[1]'', ''BIGINT'') as RC_ID, 
INTERACTION_HISTORY.PROPERTY_ID,
INTERACTION_HISTORY.CREATE_DT as allcreatedates, 
INTERACTION_HISTORY.RELATE_ID as allids,
INTERACTION_HISTORY.TYPE_CD as allNoticeTypes,
INTERACTION_HISTORY.RELATE_CLASS_TX as allRelateTypes
into #' + @newid + 'InboundCallsOrig
from INTERACTION_HISTORY join #' + @newid + 'GetPid gp on INTERACTION_HISTORY.PROPERTY_ID = gp.acPROPERTY_ID
where 
1=1
and (cast(INTERACTION_HISTORY.CREATE_DT as date) <  ''' + @ConvertCallDate + '''  
and INTERACTION_HISTORY.PURGE_DT is null 
and INTERACTION_HISTORY.PROPERTY_ID = gp.acPROPERTY_ID   
and RELATE_CLASS_TX IN (''Allied.UniTrac.ForcePlacedCertificate'',''Allied.UniTrac.Notice''))  

select RowNumb,IBC_ID,rc_id,
 rank() OVER (ORDER BY IBC_ID) as MyRank,allids,daysinbetween,mailDate,allNoticeTypes,
allcreatedates,Property_id,ranking,ROW_NUMBER() over(partition by PROPERTY_ID order by daysinbetween)as numberone 
into #' + @newid + 'toptwowinners
from #' + @newid + 'InboundCallsOrig  where ranking = 1
order by Myrank


select RowNumb,ibc_id,rc_id,MyRank,
numberone,allcreatedates,daysinbetween,mailDate, property_id, allids,allNoticeTypes
into #' + @newid + 'closest_of_the_two
from #' + @newid + 'toptwowinners where numberone = 1

select gp.acProperty_id,gp.RowNumb,gp.acLoan_id
into #' + @newid + 'dupesplus
 from #' + @newid + 'Getpid gp left outer join #' + @newid + 'closest_of_the_two  cott on cott.RowNumb = gp.RowNumb
where cott.RowNumb is null --order by RowNumb --679  4037




select ac.acid as IBC_id, ac.acProperty_id,ac.acLoan_id,dp.RowNumb as dpRowNumb,cott3.RowNumb,cott3.Property_id
into #' + @newid + 'cottPlus
 from #' + @newid + 'allcalls ac 
 left outer join #' + @newid + 'closest_of_the_two cott3 on ac.RowNumb = cott3.RowNumb
left outer join #' + @newid + 'dupesplus dp on ac.RowNumb = dp.RowNumb


select  cp.Ibc_id, id as property_id,
coalesce(property.YEAR_TX, '' '') + '' '' + coalesce(property.MAKE_TX, '' '') + '' '' 
+ coalesce(property.MODEL_TX, '' '') + '' '' + coalesce(property.VIN_TX, '' '') as ''Collateral'', 
address_id,description_tx
into #' + @newid + 'miniProp
--------from  #' + @newid + 'closest_of_the_two cott1 
--------inner join property on cott1.property_id = property.id 
from  #' + @newid + 'cottPlus cp 
inner join property on property.id = coalesce(cp.Property_id,cp.acProperty_id)--,cott1.acPrOperty_id) 
 


select cott2.RowNumb,cott2.IBC_id, coll.[iD],coll.PROPERTY_ID,coalesce(coll.LOAN_ID,cott2.acLoan_id) as Loan_id,coll.PRIMARY_LOAN_IN,coll.COLLATERAL_CODE_ID  
into #' + @newid + 'miniCollateral
from #' + @newid + 'cottPlus cott2 
left outer join Collateral coll on coll.property_id = coalesce(cott2.acproperty_id,cott2.acProperty_id)  --cott2.property_id 
and (coll.PURGE_DT is null and PRIMARY_LOAN_IN = ''Y'')

 select mp2.ibc_id,   oa.[ID],oa.[LINE_1_TX]
into #' + @newid + 'miniOwnerAddress
 from #' + @newid + 'miniProp mp2 join OWNER_ADDRESS oa on mp2.ADDRESS_ID = oa.id

 
---------- select mc4.Ibc_id, cc.id, cc.VEHICLE_LOOKUP_IN,cc.ADDRESS_LOOKUP_IN, cc.code_tx,cc.PRIMARY_CLASS_CD,cc.SECONDARY_CLASS_CD,cc.PURGE_DT
----------into #' + @newid + 'miniCollateral_CODE
---------- from COLLATERAL_CODE cc join #' + @newid + 'miniCollateral mc4 on mc4.COLLATERAL_CODE_ID = cc.id and cc.PURGE_DT is null 

 select mc4.Ibc_id, cc.id, cc.VEHICLE_LOOKUP_IN,cc.ADDRESS_LOOKUP_IN, cc.code_tx,cc.PRIMARY_CLASS_CD,cc.SECONDARY_CLASS_CD,cc.PURGE_DT
into #' + @newid + 'miniCollateral_CODE
 from COLLATERAL_CODE cc join #' + @newid + 'miniCollateral mc4 on mc4.COLLATERAL_CODE_ID = cc.id and cc.PURGE_DT is null 


select
 ml.purge_dt,  ml.RECORD_TYPE_CD,
mc.ibc_id, ml.LENDER_ID,ml.id as LoanID,NUMBER_TX, mc.loan_id as CollLoanID 
into #' + @newid + 'miniLoan
from #' + @newid + 'miniCollateral mc join Loan ml on ml.id = mc.LOAN_ID  order by purge_dt desc, RECORD_TYPE_CD desc

select mlo.ibc_id, mle.id,mle.test_in,mle.status_cd,mle.CODE_TX,mle.NAME_TX 
into #' + @newid + 'miniLender
from #' + @newid + 'miniLoan mlo join Lender mle on mlo.LENDER_ID = mle.id 


select cott2.ibc_id, Sequence_no,n.id, coalesce(rc.Meaning_tx, ''No Type Listed'') as NoticeT
into #' + @newid + 'miniNotice
from Notice n 
inner join #' + @newid + 'closest_of_the_two cott2 on n.id = cott2.allids
inner join [REF_CODE] rc on rc.Code_cd = n.type_cd and rc.Domain_cd = ''NoticeType'' and rc.purge_dt is null

select  ibc_id, RC_ID, allids,property_id, allnoticetypes, allcreatedates
into #' + @newid + 'NoticeWinners
from #' + @newid + 'closest_of_the_two where allnoticetypes = ''Notice''

select  ibc_id, RC_ID, allids, property_id, allnoticetypes, allcreatedates, Maildate
into #' + @newid + 'CPIWinners
from #' + @newid + 'closest_of_the_two where allnoticetypes = ''CPI''

select
cott.ibc_id, nw.rc_id as nw_rcid, cw.rc_id as cw_rcid
 ,rc.[PROPERTY_ID] ,rc.[TYPE_CD]   ,rc.[CPI_QUOTE_ID] ,rc.[LENDER_PRODUCT_ID]

into #' + @newid + 'NoticeID
from #' + @newid + 'closest_of_the_two cott 
left outer join #' + @newid + 'noticeWinners nw on cott.ibc_id = nw.ibc_id
left outer join #' + @newid + 'CPIWinners cw on cott.ibc_id = cw.ibc_id
left outer join [REQUIRED_COVERAGE] rc on cott.rc_id = rc.id



select ibc_id,cott3.property_id, type_cd, id
into #' + @newid + 'miniRequired_Coverage 
from [REQUIRED_COVERAGE] rc join #' + @newid + 'closest_of_the_two cott3 on rc.id = cott3.rc_id

SELECT
ROW_NUMBER() over(partition by gp.PROPERTY_ID order by gp.PROPERTY_ID)as numberone ,
 gp.ibc_id,n.NAME_TX, n.[ID] as ''notice id'', gp.PROPERTY_ID as gppid, gp.allids as relateId

into #' + @newid + 'miniNewNote
FROM [Notice] n
inner join  #' + @newid + 'closest_of_the_two gp on gp.allids = n.id

select mOLR.OWNER_ID,PRIMARY_IN,mOLR.LOAN_ID, ml.ibc_id
into #' + @newid + 'miniOwner_Loan_Relate
from #' + @newid + 'miniLoan  ml join OWNER_LOAN_RELATE mOLR on mOLR.LOAN_ID = ml.loanid and mOLR.PRIMARY_IN = ''Y'' and mOLR.purge_dt is null 

select * 
into #' + @newid + 'miniOwner
from #' + @newid + 'miniOwner_Loan_Relate mOLR join OWNER on OWNER.id = mOLR.owner_id and  OWNER.purge_dt is null 

select 
ibc_id
 into #' + @newid + 'altCollateral
 from #' + @newid + 'miniProp  
 where (collateral is null or collateral = '''')

select mp.ibc_id, 
(case
	when (mp.collateral is null or mp.collateral = '''')
	then
oa.Line_1_tx
else
	mp.collateral
	end) as collateral
	into #' + @newid + 'VehicleInfo
from #' + @newid + 'miniprop mp 
left outer join #' + @newid + 'allcalls ac on mp.ibc_id = ac.acid
left outer join #' + @newid + 'altCollateral accoll on mp.ibc_id= accoll.ibc_id
left outer  join #' + @newid + 'miniownerAddress oa on oa.ibc_id= mp.ibc_id

order by collateral 
;
--with finalSelect as (
select --distinct

mlender.code_tx as ''Lender Code'',
mlender.NAME_TX as ''Lender Name'',
cott.daysinbetween as ''Least Days Between'',
mLoan.number_tx as ''Loan Number'',
isnull( o.LAST_NAME_TX, '''') as ''Last Name'', 
isnull( o.FIRST_NAME_TX, '''') as ''First Name'',
vi.collateral as ''Collateral'',
mcc.code_tx  as ''Collateral Code'',
Mcc.PRIMARY_CLASS_CD as ''Primary Class'',
mcc.SECONDARY_CLASS_CD as ''Secondary Class'',
mrc.type_cd as ''Coverage Type'',
(case
	when (mn.NoticeT is null or mn.NoticeT = '''')
	then
''No Type Listed''
else
	mn.NoticeT 
	end) as ''Notice Type'',

(case
	when (mn.SEQUENCE_NO is null or mn.SEQUENCE_NO = '''')
	then
''''
else
	mn.SEQUENCE_NO
	end) as ''Notice Sequence'',
cott.allNoticeTypes as Mynoticetypes,
cott.mailDate as ''Mail Date'',
''' + @ConvertCallDate + ''' as ''Inbound Call'',
nw.allcreatedates as  ''Notice Date'',
cw.rc_id as ''Cert ID'',
cw.mailDate as ''Cert Date'',
cott.rc_id as ''RC ID'',
mp.property_id  as ''Property Id'',
------------------------cott.property_id as ''Property Id'',
mloan.loanid as ''Loan Id'',

(case
	when (nid.nw_rcid is null or nid.nw_rcid = '''')
	then
nid.cw_rcid 
else
	nid.nw_rcid
	end) as ''Notice ID'',

ac.acid as ''IH ID''
into #' + @newid + 'FinalSelect
from
--------#closest_of_the_two cott 

 #' + @newid + 'allcalls ac 
left outer join #' + @newid + 'cottplus dp on ac.RowNumb = dp.RowNumb
left outer join #' + @newid + 'closest_of_the_two cott on ac.RowNumb = cott.RowNumb

left outer join #' + @newid + 'miniProp mp on mp.ibc_id = ac.acid

left outer join #' + @newid + 'miniCollateral_CODE mcc on ac.acid = mcc.ibc_id
left outer join #' + @newid + 'miniLoan mloan on ac.acid = mloan.ibc_id
left outer join #' + @newid + 'miniLender mlender on ac.acid = mlender.ibc_id
left outer join #' + @newid + 'miniowner o on ac.acid = o.ibc_id
left outer join #' + @newid + 'VehicleInfo vi on ac.acid = vi.ibc_id
left outer join #' + @newid + 'miniRequired_Coverage mrc on cott.ibc_id = mrc.ibc_id
left outer join #' + @newid + 'miniNotice mn on cott.ibc_id = mn.ibc_id
left outer join #' + @newid + 'CPIWinners cw on cott.ibc_id = cw.ibc_id
left outer join #' + @newid + 'NoticeWinners nw on cott.ibc_id = nw.ibc_id
left outer join #' + @newid + 'NoticeId nid on cott.ibc_id = nid.ibc_id 

 --order by [Lender Code], [Loan Number]


----------select * from #allcalls --4037
----------select * from #GetPid  --4037
----------select * from #InboundCallsOrig   --10323

----------select * from #toptwowinners  --4941
----------select * from #closest_of_the_two   --3358
----------select * from #miniProp --where collateral is null  -- ibc_id = 366226807  --3358

----------select * from #dupesplus
----------select * from #cottPlus


----------select * from #miniCollateral --where COLLATERAL_CODE_ID is not null  --4002
------------select * from #miniCollateral_CODE   --4002
------------select * from #miniOwnerAddress    --484
------------select * from #miniOwner           --4002
----------select * from #miniLoan   ---    where collloanid   =226502427      --4002

----------select * from #miniLender          --472

----------select * from #altCollateral         --4303 
----------select * from #VehicleInfo    where collateral is null      --3672
----------select * from #miniNewNote        --3411
----------select * from #NoticeWinners       --247   
----------select * from #CPIWinners         --3938      

----------select * from #miniRequired_Coverage   --4002
----------select * from #miniOwner_Loan_Relate       --3672
-------------select * from #ICO
----------select * from #miniNotice           --4781   

--------------select * from #autoDetail

----------select * from #NoticeID
----------select * from #FinalSelect  -- order by [Property id]
----------select * from #FinalSelect where [Property id] = 2216711

select * from #' + @newid + 'FinalSelect order by [Lender Code], [Loan Number]


IF OBJECT_ID(''tempdb.dbo.#' + @newid + 'allcalls'') IS not NULL
DROP TABLE tempdb.dbo.#' + @newid + 'allcalls
IF OBJECT_ID(''tempdb.dbo.#' + @newid + 'GetPid'') IS not NULL
DROP TABLE tempdb.dbo.#' + @newid + 'GetPid
IF OBJECT_ID(''tempdb.dbo.#' + @newid + 'InboundCallsOrig'') IS not NULL
DROP TABLE tempdb.dbo.#' + @newid + 'InboundCallsOrig
IF OBJECT_ID(''tempdb.dbo.#' + @newid + 'toptwowinners'') IS not NULL
DROP TABLE tempdb.dbo.#' + @newid + 'toptwowinners
IF OBJECT_ID(''tempdb.dbo.#' + @newid + 'closest_of_the_two'') IS not NULL
DROP TABLE tempdb.dbo.#' + @newid + 'closest_of_the_two
IF OBJECT_ID(''tempdb.dbo.#' + @newid + 'dupesplus'') IS not NULL
DROP TABLE tempdb.dbo.#' + @newid + 'dupesplus

IF OBJECT_ID(''tempdb.dbo.#' + @newid + 'cottPlus'') IS not NULL
DROP TABLE tempdb.dbo.#' + @newid + 'cottPlus

IF OBJECT_ID(''tempdb.dbo.#' + @newid + 'miniProp'') IS not NULL
DROP TABLE tempdb.dbo.#' + @newid + 'miniProp
IF OBJECT_ID(''tempdb.dbo.#' + @newid + 'miniCollateral'') IS not NULL
DROP TABLE tempdb.dbo.#' + @newid + 'miniCollateral
IF OBJECT_ID(''tempdb.dbo.#' + @newid + 'miniCollateral_CODE'') IS not NULL
DROP TABLE tempdb.dbo.#' + @newid + 'miniCollateral_CODE
IF OBJECT_ID(''tempdb.dbo.#' + @newid + 'miniOwnerAddress'') IS not NULL
DROP TABLE tempdb.dbo.#' + @newid + 'miniOwnerAddress
IF OBJECT_ID(''tempdb.dbo.#' + @newid + 'miniOwner'') IS not NULL
DROP TABLE tempdb.dbo.#' + @newid + 'miniOwner
IF OBJECT_ID(''tempdb.dbo.#' + @newid + 'miniLoan'') IS not NULL
DROP TABLE tempdb.dbo.#' + @newid + 'miniLoan
IF OBJECT_ID(''tempdb.dbo.#' + @newid + 'miniLender'') IS not NULL
DROP TABLE tempdb.dbo.#' + @newid + 'miniLender
IF OBJECT_ID(''tempdb.dbo.#' + @newid + 'altCollateral'') IS not NULL
DROP TABLE tempdb.dbo.#' + @newid + 'altCollateral
IF OBJECT_ID(''tempdb.dbo.#' + @newid + 'VehicleInfo'') IS not NULL
DROP TABLE tempdb.dbo.#' + @newid + 'VehicleInfo
IF OBJECT_ID(''tempdb.dbo.#' + @newid + 'miniNewNote'') IS not NULL
DROP TABLE tempdb.dbo.#' + @newid + 'miniNewNote
IF OBJECT_ID(''tempdb.dbo.#' + @newid + 'NoticeWinners'') IS not NULL
DROP TABLE tempdb.dbo.#' + @newid + 'NoticeWinners
IF OBJECT_ID(''tempdb.dbo.#' + @newid + 'CPIWinners'') IS not NULL
DROP TABLE tempdb.dbo.#' + @newid + 'CPIWinners
IF OBJECT_ID(''tempdb.dbo.#' + @newid + 'miniRequired_Coverage'') IS not NULL
DROP TABLE tempdb.dbo.#' + @newid + 'miniRequired_Coverage
IF OBJECT_ID(''tempdb.dbo.#' + @newid + 'miniOwner_Loan_Relate'') IS not NULL
DROP TABLE tempdb.dbo.#' + @newid + 'miniOwner_Loan_Relate
IF OBJECT_ID(''tempdb.dbo.#' + @newid + 'miniNotice'') IS not NULL
DROP TABLE tempdb.dbo.#' + @newid + 'miniNotice
IF OBJECT_ID(''tempdb.dbo.#' + @newid + 'NoticeID'') IS not NULL
DROP TABLE tempdb.dbo.#' + @newid + 'NoticeID 
IF OBJECT_ID(''tempdb.dbo.#' + @newid + 'FinalSelect'') IS not NULL
DROP TABLE tempdb.dbo.#' + @newid + 'FinalSelect




';

----select @sql  --, @newid
exec(@sql);

