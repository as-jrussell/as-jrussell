SELECT * FROM UniTrac..REF_DOMAIN


SELECT * FROM UNITRAC..REF_CODE
WHERE DOMAIN_CD = 'ADDRESSTYPE'

SELECT * FROM UniTrac..REF_CODE
WHERE DOMAIN_CD = 'COLLATERALSTATUS'

SELECT * FROM UniTrac..REF_CODE_ATTRIBUTE
WHERE DOMAIN_CD = 'COLLATERALSTATUS' AND REF_CD = 'I'

SELECT * FROM UniTrac..REF_CODE
WHERE DESCRIPTION_TX like '%Notice%'

