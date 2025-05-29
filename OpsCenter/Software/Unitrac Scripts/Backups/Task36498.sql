select 
      tp.NAME_TX, 
      tp.EXTERNAL_ID_TX as 'LenderID', 
      isnull(rdts.VALUE_TX, 'VUT') as 'TrackingSource',
      di.DOCUMENT_TYPE_CD as 'LoanType',
      u.GIVEN_NAME_TX as 'FirstName',
      u.FAMILY_NAME_TX as 'LastName', 
      ISNULL(rddi.VALUE_TX, 'unknown') as 'SA Assigned',
      case rdhw.VALUE_TX  when 'Y' THEN 'Yes' else 'No' end as 'HoldForReview' , rdhw.COMMENT_TX
from 
      TRADING_PARTNER tp
      join DELIVERY_INFO di on di.TRADING_PARTNER_ID = tp.ID
      join RELATED_DATA_DEF rddts on rddts.NAME_TX = 'TrackingSource' and rddts.RELATE_CLASS_NM ='tradingpartner'
      LEFT OUTER join RELATED_DATA rdts on rdts.DEF_ID = rddts.ID and rdts.RELATE_ID = tp.ID
      join RELATED_DATA_DEF rdddi on rdddi.NAME_TX = 'SAAssigned' and rdddi.RELATE_CLASS_NM='DeliveryInfo'
      LEFT OUTER JOIN RELATED_DATA rddi on rddi.DEF_ID = rdddi.ID and rddi.RELATE_ID = di.ID
      join RELATED_DATA_DEF rddhw on rddhw.NAME_TX = 'HoldForReview' and rddhw.RELATE_CLASS_NM ='DeliveryInfo'
      LEFT OUTER join RELATED_DATA rdhw on rdhw.DEF_ID = rddhw.ID and rdhw.RELATE_ID = di.ID
      join USERS u on u.id = rddi.value_tx
where
          tp.PURGE_DT is null
      and di.PURGE_DT is NULL
	  AND rdhw.COMMENT_TX = 'HoldForReview'
	  AND rdhw.VALUE_TX = 'Y'
    ORDER BY rdhw.COMMENT_TX DESC
	--2117

	SELECT * FROM dbo.LENDER
	WHERE AGENCY_ID = '1' --AND STATUS_CD = 'ACTIVE'

	  --SELECT * FROM dbo.RELATED_DATA_DEF
	  --WHERE NAME_TX = 'HoldForReview'


select 
      tp.NAME_TX, 
      tp.EXTERNAL_ID_TX as 'LenderID', 
      isnull(rdts.VALUE_TX, 'VUT') as 'TrackingSource',
      di.DOCUMENT_TYPE_CD as 'LoanType',
      u.GIVEN_NAME_TX as 'FirstName',
      u.FAMILY_NAME_TX as 'LastName', 
      ISNULL(rddi.VALUE_TX, 'unknown') as 'SA Assigned',
      case rdhw.VALUE_TX  when '1' THEN 'Yes' else 'No' end as 'HotWatch', rdhw.COMMENT_TX, rdhw.VALUE_TX
from 
      TRADING_PARTNER tp
      join DELIVERY_INFO di on di.TRADING_PARTNER_ID = tp.ID
      join RELATED_DATA_DEF rddts on rddts.NAME_TX = 'TrackingSource' and rddts.RELATE_CLASS_NM ='tradingpartner'
      LEFT OUTER join RELATED_DATA rdts on rdts.DEF_ID = rddts.ID and rdts.RELATE_ID = tp.ID
      join RELATED_DATA_DEF rdddi on rdddi.NAME_TX = 'SAAssigned' and rdddi.RELATE_CLASS_NM='DeliveryInfo'
      LEFT OUTER JOIN RELATED_DATA rddi on rddi.DEF_ID = rdddi.ID and rddi.RELATE_ID = di.ID
      join RELATED_DATA_DEF rddhw on rddhw.NAME_TX = 'HotWatch' and rddhw.RELATE_CLASS_NM ='DeliveryInfo'
      LEFT OUTER join RELATED_DATA rdhw on rdhw.DEF_ID = rddhw.ID and rdhw.RELATE_ID = di.ID
      join USERS u on u.id = rddi.value_tx
where
          tp.PURGE_DT is null
      and di.PURGE_DT is null