	declare @tpTrackingSourceDefId bigint
	
	select @tpTrackingSourceDefId = Id
	from RELATED_DATA_DEF
	where RELATE_CLASS_NM = 'TradingPartner' and NAME_TX = 'TrackingSource'

select
 rd1_id=rd1.id
,rd1_value=rd1.VALUE_TX
,rd1_update=rd1.update_dt
,rd1_user=rd1.update_user_tx
,sc.*
, *
	FROM 
		TRADING_PARTNER tp1
		left outer join RELATED_DATA rd0       ON rd0.DEF_ID = @tpTrackingSourceDefId and rd0.RELATE_ID = tp1.ID
   		
		inner JOIN DELIVERY_INFO di1		ON tp1.ID = di1.TRADING_PARTNER_ID
		LEFT OUTER JOIN REF_CODE rc				on (rc.DOMAIN_CD = 'DeliveryFrequency' and rc.CODE_CD = di1.DELIVERY_FREQ_CD)

		LEFT OUTER JOIN RELATED_DATA_DEF rdd1	ON (rdd1.RELATE_CLASS_NM = 'DeliveryInfo' and rdd1.NAME_TX = 'UniTracServiceCenter')
		LEFT OUTER JOIN RELATED_DATA rd1		   ON (rd1.DEF_ID = rdd1.ID and rd1.RELATE_ID=di1.ID)
		LEFT OUTER JOIN SERVICE_CENTER sc     on (sc.ID = rd1.VALUE_TX)
where tp1.external_id_tx = '4824'

select sc.* from service_center sc where sc.CODE_TX in ('Albuquerque','Maitland')