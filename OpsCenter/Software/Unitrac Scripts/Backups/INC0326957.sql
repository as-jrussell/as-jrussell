USE [UniTrac];
GO




--Loan Screen Information- LOAN/COLLATERAL/PROPERTY/OWNER/REQUIRED COVERAGE
SELECT C.* INTO UniTracHDStorage..INC0326957_C
FROM   LOAN L
       INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
       INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
       INNER JOIN REQUIRED_COVERAGE RC ON P.ID = RC.PROPERTY_ID
       INNER JOIN OWNER_LOAN_RELATE OL ON L.ID = OL.LOAN_ID
       INNER JOIN OWNER O ON OL.OWNER_ID = O.ID
       INNER JOIN OWNER_ADDRESS OA ON O.ADDRESS_ID = OA.ID
       INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
WHERE  LL.CODE_TX IN ( '7091' )
       AND L.NUMBER_TX IN ( '1747980-17', '1725540-15', '1725540-82' ,
                            '3130410-16' ,'2001350-10', '694660-10' ,
                            '3334840-10' ,'3334840-72', '573340-85' ,
                            '1973230-82' ,'14608-82', '38700-14', '38700-17' ,
                            '38700-84' ,'38700-85', '2552950-83', '72350-10' ,
                            '175620-10' ,'175620-12', '175620-82' ,
                            '175620-83' ,'176360-12', '176360-13' ,
                            '2754000-10' ,'972710-22', '3033790-10' ,
                            '3033790-11' ,'231590-10', '231590-83' ,
                            '231590-84' ,'3305250-10', '2791890-10' ,
                            '2791890-82' ,'2897300-11'
                          );




SELECT * FROM dbo.REF_CODE
WHERE CODE_CD = 'M'



UPDATE RC
SET status_cd = 'M', update_dt = GETDATE(), update_user_tx = 'INC0326957', LOCK_ID = CASE WHEN LOCK_ID >= 255 THEN 1 ELSE LOCK_ID + 1 END
--SELECT *
FROM dbo.REQUIRED_COVERAGE RC
WHERE ID IN (SELECT ID FROM UniTracHDStorage..INC0326957_RC)