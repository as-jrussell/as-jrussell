
IF NOT EXISTS (select 1	from REF_CODE where DOMAIN_CD = 'ProcessType' and CODE_CD = 'OCRINPRCPA')
BEGIN
INSERT INTO REF_CODE
(
   DOMAIN_CD
   ,CODE_CD
   ,MEANING_TX
   ,DESCRIPTION_TX
   ,ACTIVE_IN
   ,[ORDER_NO]
   ,CREATE_DT
   ,UPDATE_DT
   ,UPDATE_USER_TX
   ,LOCK_ID
)
VALUES

-- OCR Process type for bug 43552
('ProcessType'	,'OCRINPRCPA'	,'OCR Inbound Process'	,'OCR Inbound Process', 'Y', 999, Getdate(),  Getdate(), 'Script', 1)
END
