USE UniTrac


SELECT ID into #tmpLender
FROM LENDER
WHERE CODE_TX = '3039'


SELECT ID into #tmpLENDERPAYEE
--select *
FROM LENDER_PAYEE_CODE_FILE
WHERE LENDER_ID in (select id from #tmpLender) AND PAYEE_CODE_TX in ('122', '4540', '96040')


--Add ID from the select that matches the address
SELECT LPCM.ID into #tmpLENDERMATCH
--select U.GIVEN_NAME_TX, U.FAMILY_NAME_TX, LPC.PAYEE_CODE_TX, LPC.COMP_NAME_TX, LPCM.CREATE_DT
FROM LENDER_PAYEE_CODE_MATCH LPCM
INNER JOIN ADDRESS ON LPCM.REMITTANCE_ADDR_ID = ADDRESS.ID
inner join USERS u on u.user_name_tx = LPCM.update_user_Tx 
join LENDER_PAYEE_CODE_FILE lpc on lpc.id = lpcm.lender_payee_code_file_id
WHERE LENDER_PAYEE_CODE_FILE_ID in (select id from #tmpLENDERPAYEE) AND LPCM.PURGE_DT IS NULL
and LPCM.ID = ''

UPDATE LPCM
SET PURGE_DT = GETDATE(), UPDATE_DT = GETDATE(),UPDATE_USER_TX = 'adminUnMapScrpt', LOCK_ID = LOCK_ID + 1
--SELECT *
FROM LENDER_PAYEE_CODE_MATCH LPCM
WHERE LENDER_PAYEE_CODE_FILE_ID in (select id from #tmpLENDERPAYEE) AND ID IN (select id from #tmpLENDERMATCH)



drop table  #tmpLender
drop table #tmpLENDERMATCH
drop table #tmpLENDERPAYEE


