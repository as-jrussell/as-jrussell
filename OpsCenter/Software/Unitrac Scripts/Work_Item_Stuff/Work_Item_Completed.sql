DECLARE @ToDatetime DATETIME = DATEADD(Hour,16, CAST( CAST(Cast(GETDATE() AS DATE) AS VARCHAR) AS DATETIME))
DECLARE @FromDatetime DATETIME = DATEADD(Minute,1, DATEADD(DAY,-1, @ToDatetime))
select wi.ID AS 'Work Item ID', 
tp.EXTERNAL_ID_TX as 'Lender Code', 
tp.NAME_TX as 'Lender Name',
case lodivm.CODE_TX 
when '3' then 'Vehicle'
when '4' then 'Mortgage'
when '7' then 'Equipment Lease'
when '8' then 'Vehicle Lease'
when '9' then 'Equipment'
when '10' then 'Commercial Mortgage'
when '99' then 'Commercial Property'
else isnull(lodiv.CODE_TX,'All')
end as 'DIVISION',
isnull(lobrchm.code_tx,'All') as 'BRANCH',
wia.ACTION_CD AS 'Status',
wi.CONTENT_XML.value('(/Content/Lender/LastCycleDate)[1]','datetime') as LastCycleDate,
wi.CONTENT_XML.value('(/Content/Lender/NextCycleDate)[1]','datetime') as NextCycleDate,
wia.UPDATE_DT as 'Completed Date'
from WORK_ITEM wi
join WORK_ITEM_ACTION wia on wi.ID = wia.WORK_ITEM_ID
join MESSAGE m on wi.relate_id = m.id and wi.relate_type_cd = 'LDHLib.Message' and m.PURGE_DT is null
join TRADING_PARTNER tp on m.received_from_trading_partner_id = tp.id and tp.PURGE_DT is null
join USERS u on wi.CURRENT_OWNER_ID = u.ID
join DELIVERY_INFO di on di.TRADING_PARTNER_ID = tp.ID and di.ID = m.DELIVERY_INFO_ID
left outer join RELATED_DATA_DEF rdd on rdd.NAME_TX = 'UniTracDivision' and RDD.RELATE_CLASS_NM = 'DeliveryInfo'
LEFT OUTER JOIN RELATED_DATA rd on rd.DEF_ID = rdd.ID and rd.RELATE_ID = di.ID
left outer join LENDER_ORGANIZATION lodiv on lodiv.id = rd.value_tx
left outer join RELATED_DATA_DEF rddB on rddB.NAME_TX = 'UniTracBranch' and RDDB.RELATE_CLASS_NM = 'DeliveryInfo'
LEFT OUTER JOIN RELATED_DATA rdB on rdB.DEF_ID = rddB.ID and rdB.RELATE_ID = di.ID
left outer join LENDER_ORGANIZATION lobranch on lobranch.id = rdB.value_tx
LEFT OUTER JOIN RELATED_DATA_DEF RDDM ON RDDM.RELATE_CLASS_NM = 'Message' and RDDM.Name_TX = 'ExtractConfiguration'
left outer join RELATED_DATA RDM ON RDM.DEF_ID = RDDM.ID AND RDM.RELATE_ID = M.ID
LEFT OUTER JOIN VUT.DBO.tblLenderExtract LE ON LE.LenderExtractKey = RDM.VALUE_TX
LEFT OUTER JOIN LENDER_ORGANIZATION LODIVM ON LODIVM.ID = LE.ContractTypeKey
LEFT OUTER JOIN LENDER_ORGANIZATION LOBRCHM ON LOBRCHM.ID = LE.BranchKey
where wia.ACTION_CD = 'Complete' 
and wia.UPDATE_DT 
between @FromDatetime and @ToDatetime
and di.ACTIVE_IN = 'Y' 
order by 'Lender Code'