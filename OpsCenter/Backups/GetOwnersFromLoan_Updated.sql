
use UniTrac

select 
  OLR.ID, OLR.OWNER_ID, OLR.LOAN_ID 
	 INTO #TMP_OWNER_LOAN_RELATE
	 from OWNER_LOAN_RELATE olr
WHERE
      olr.LOAN_ID = 293312751 AND  olr.purge_dt is null

	 
	 select O.*
	 into #TMP_OWNER
	 FROM OWNER o
	 join  #TMP_OWNER_LOAN_RELATE  OLR on OLR.OWNER_ID = O.ID
	 WHERE o.PURGE_DT IS NULL

	select A.*
	 into #TMP_OWNER_ADDRESS
	 FROM OWNER_ADDRESS A
	 join #TMP_OWNER O on A.ID = O.ADDRESS_ID
	 WHERE a.purge_dt is null

   SELECT
      -- OWNER_LOAN_RELATE
      olr.ID,
      olr.OWNER_ID,
      olr.LOAN_ID,
      olr.PRIMARY_IN,
      olr.RECEIVE_NOTICES_IN,
      olr.TAKE_UPDATES_IN,
      olr.LOCK_ID,
      olr.OWNER_TYPE_CD,
      olr.EXPIRATION_DT,

      -- OWNER_ADDRESS
      a.ID,
      a.LINE_1_TX,
      a.LINE_2_TX,
      a.CITY_TX,
      a.STATE_PROV_TX,
      a.COUNTRY_TX,
      a.POSTAL_CODE_TX,
      a.ATTENTION_TX,
      a.ADDRESS_TYPE_CD,
      a.PO_BOX_TX,
      a.RURAL_ROUTE_TX,
      a.UNIT_TX,
      a.PARSED_STATUS_CD,
      a.CREATE_DT,
      a.UPDATE_DT,
      a.PURGE_DT,
      a.UPDATE_USER_TX,
      a.LOCK_ID,

      -- OWNER   
      o.ID,
      o.PREFERRED_CUSTOMER_IN,
      o.SPECIAL_PERSON_IN,
      o.ADDRESS_ID,
      o.LOCK_ID,
      o.NAME_TX,
      o.LAST_NAME_TX,
      o.FIRST_NAME_TX,
      o.MIDDLE_INITIAL_TX,
      o.CREDIT_SCORE_TX,
      o.HOME_PHONE_TX,
      o.WORK_PHONE_TX,
      o.CELL_PHONE_TX,
      o.EMAIL_TX,
      o.ALLOW_EMAIL_IN,
      o.CUSTOMER_NUMBER_TX,
      o.FIELD_PROTECTION_XML,
      o.SPECIAL_HANDLING_XML,
      o.REO_IN,
      o.TEXT_NOTIFICATION_STATUS_CD,
      o.TEXT_SUBSCRIBE_STATUS_CD,
      o.CELLPHONE_VALIDATION_STATUS_CD,
		o.BIRTH_DT,
      o.DO_NOT_USE_EMAIL_IN
	FROM OWNER_LOAN_RELATE olr
	join  #TMP_OWNER_LOAN_RELATE OT on OT.ID = OLR.ID
     inner join #TMP_OWNER o on olr.OWNER_ID = o.ID 
     left outer join #TMP_OWNER_ADDRESS a on o.ADDRESS_ID = a.ID 
    

