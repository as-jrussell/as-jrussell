INSERT INTO dbo.TRADING_PARTNER(
EXTERNAL_ID_TX
,NAME_TX
,TYPE_CD
,STATUS_CD
,RECEIVE_FROM_TP_ID
,DELIVER_TO_TP_ID
,UPDATE_DT
,UPDATE_USER_TX
,PURGE_DT
,LOCK_ID
,ACTIVE_IN
,TRANSACTION_XSLT
,DELIVER_TO_TP_IN
,CREATE_DT
)
VALUES
(
N'7091'
,(SELECT NAME_TX FROM LENDER WHERE CODE_TX = '7091')
,N'LFP_TP'
,N'ACTIVE'
,0
,0
,GETDATE()
,N'SCRIPT'
,NULL
,1
,'Y'
,NULL
,'N'
,GETDATE()
);




