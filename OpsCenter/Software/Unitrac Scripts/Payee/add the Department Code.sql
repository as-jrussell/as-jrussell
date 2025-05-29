USE Unitrac


--Get Lender ID (if you don't already have it, type in Lender Code)
SELECT *
FROM LENDER
WHERE CODE_TX = ''


--Pull up lender payee code(s) that needs to have code added 
select ID into #tmpLPC
--SELECT *
FROM LENDER_PAYEE_CODE_FILE
WHERE LENDER_ID = XXXX AND PAYEE_CODE_TX IN ( '')




--Add in the Department Code desired, ticket for update user and run update
update L set department_code_tx ='', L.LOCK_ID = L.LOCK_ID+1, UPDATE_DT = GETDATE() , UPDATE_USER_TX = ''
--SELECT department_code_tx , *
FROM LENDER_PAYEE_CODE_FILE L
WHERE L.ID IN (select * from #tmpLPC)
