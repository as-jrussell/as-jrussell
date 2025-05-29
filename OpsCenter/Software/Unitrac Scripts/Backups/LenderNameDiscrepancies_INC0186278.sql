 SELECT TOP 10 * FROM UniTrac_DW..LENDER_DIM
 WHERE CODE_TX in ('2100','7619','2095')
 
 
 SELECT ldr.ID AS 'UniTrac ID' ,
        ldr.CODE_TX AS 'Lender ID' ,
        ldr.STATUS_CD AS 'Lender Status' ,
        ldr.NAME_TX AS 'UniTrac DB Lender NAME' ,
        ldr_dw.NAME_TX AS 'UniTrac DW Lender NAME'
 FROM   LENDER ldr
        JOIN UniTrac_DW..LENDER_DIM ldr_dw ON ldr.CODE_TX = ldr_dw.CODE_TX
 WHERE  ldr.NAME_TX <> ldr_dw.NAME_TX
        --AND ldr.CANCEL_DT IS NULL
        --AND ldr.TEST_IN = 'N'
        --AND ldr.STATUS_CD = 'ACTIVE'
        AND ldr.CODE_TX IN ( '2100','7619','2095' )
		ORDER BY ldr.CODE_TX ASC  
		
/*
UPDATE UniTrac_DW..LENDER_DIM
SET NAME_TX = 'U. S. Eagle Federal Credit Union'
WHERE CODE_TX = '2100' AND NAME_TX = 'US New Mexico Federal CU'

UPDATE UniTrac_DW..LENDER_DIM
SET NAME_TX = 'Bay Commercial Bank'
WHERE CODE_TX = '7619' AND NAME_TX = 'Valley Community Bank'

UPDATE UniTrac_DW..LENDER_DIM
SET NAME_TX = 'Select Seven Credit Union'
WHERE CODE_TX = '2095' AND NAME_TX = 'Johnson City FCU'*/