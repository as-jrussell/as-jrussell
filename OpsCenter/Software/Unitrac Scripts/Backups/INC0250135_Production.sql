USE UniTrac

SELECT *
FROM LENDER
WHERE CODE_TX = '3769'

SELECT ID into #tmpLPCF
FROM LENDER_PAYEE_CODE_FILE
WHERE LENDER_ID = 2333 AND PURGE_DT IS NULL

SELECT ID, PAYEE_CODE_TX
FROM LENDER_PAYEE_CODE_FILE
WHERE LENDER_ID = 2333 AND LEN(PAYEE_CODE_TX) = '4'
ORDER BY PAYEE_CODE_TX ASC 

	        SELECT  *
        FROM    dbo.ADDRESS
        WHERE   ID IN ( 287533, 295042, 287982, 296099, 287642, 288956, 292765,
                        288847, 307472, 288784, 293863, 287287, 293734, 296520,
                        287323, 291442, 292694, 287460, 288186, 296834, 296833,
                        295043, 293843 )

SELECT *
FROM LENDER_PAYEE_CODE_MATCH
WHERE LENDEr_PAYEE_CODE_FILE_ID IN (SELECT ID FROM #tmpLPCF) 

SELECT * FROM dbo.LENDER_PAYEE_CODE_FILE LPCF
LEFT JOIN dbo.LENDER_PAYEE_CODE_MATCH LPCM ON LPCM.LENDER_PAYEE_CODE_FILE_ID = LPCF.ID
WHERE LPCF.ID IN (SELECT ID FROM #tmpLPCF) AND LPCM.BIC_ID IS NULL
ORDER BY PAYEE_CODE_TX ASC 

INSERT  dbo.LENDER_PAYEE_CODE_MATCH
        ( LENDER_PAYEE_CODE_FILE_ID ,
          REMITTANCE_ADDR_ID ,
          BIC_ID ,
          REMITTANCE_TYPE_CD ,
          CREATE_DT ,
          PURGE_DT ,
          UPDATE_DT ,
          UPDATE_USER_TX ,
          LOCK_ID ,
          PRIMARY_IN
        )
VALUES  ( 34169 ,
          24705 ,
          12029 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0250135' ,
          1 ,
          'Y'
        )
INSERT  dbo.LENDER_PAYEE_CODE_MATCH
        ( LENDER_PAYEE_CODE_FILE_ID ,
          REMITTANCE_ADDR_ID ,
          BIC_ID ,
          REMITTANCE_TYPE_CD ,
          CREATE_DT ,
          PURGE_DT ,
          UPDATE_DT ,
          UPDATE_USER_TX ,
          LOCK_ID ,
          PRIMARY_IN
        )
VALUES  ( 34168 ,
          18235 ,
          14397 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0250135' ,
          1 ,
          'Y'
        )
INSERT  dbo.LENDER_PAYEE_CODE_MATCH
        ( LENDER_PAYEE_CODE_FILE_ID ,
          REMITTANCE_ADDR_ID ,
          BIC_ID ,
          REMITTANCE_TYPE_CD ,
          CREATE_DT ,
          PURGE_DT ,
          UPDATE_DT ,
          UPDATE_USER_TX ,
          LOCK_ID ,
          PRIMARY_IN
        )
VALUES  ( 34167 ,
          18238 ,
          14410 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0250135' ,
          1 ,
          'Y'
        )
INSERT  dbo.LENDER_PAYEE_CODE_MATCH
        ( LENDER_PAYEE_CODE_FILE_ID ,
          REMITTANCE_ADDR_ID ,
          BIC_ID ,
          REMITTANCE_TYPE_CD ,
          CREATE_DT ,
          PURGE_DT ,
          UPDATE_DT ,
          UPDATE_USER_TX ,
          LOCK_ID ,
          PRIMARY_IN
        )
VALUES  ( 34166 ,
          153578 ,
          13433 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0250135' ,
          1 ,
          'Y'
        )
INSERT  dbo.LENDER_PAYEE_CODE_MATCH
        ( LENDER_PAYEE_CODE_FILE_ID ,
          REMITTANCE_ADDR_ID ,
          BIC_ID ,
          REMITTANCE_TYPE_CD ,
          CREATE_DT ,
          PURGE_DT ,
          UPDATE_DT ,
          UPDATE_USER_TX ,
          LOCK_ID ,
          PRIMARY_IN
        )
VALUES  ( 34165 ,
          146563 ,
          14416 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0250135' ,
          1 ,
          'Y'
        )
INSERT  dbo.LENDER_PAYEE_CODE_MATCH
        ( LENDER_PAYEE_CODE_FILE_ID ,
          REMITTANCE_ADDR_ID ,
          BIC_ID ,
          REMITTANCE_TYPE_CD ,
          CREATE_DT ,
          PURGE_DT ,
          UPDATE_DT ,
          UPDATE_USER_TX ,
          LOCK_ID ,
          PRIMARY_IN
        )
VALUES  ( 34164 ,
          180781 ,
          15269 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0250135' ,
          1 ,
          'Y'
        )
INSERT  dbo.LENDER_PAYEE_CODE_MATCH
        ( LENDER_PAYEE_CODE_FILE_ID ,
          REMITTANCE_ADDR_ID ,
          BIC_ID ,
          REMITTANCE_TYPE_CD ,
          CREATE_DT ,
          PURGE_DT ,
          UPDATE_DT ,
          UPDATE_USER_TX ,
          LOCK_ID ,
          PRIMARY_IN
        )
VALUES  ( 34163 ,
          146604 ,
          14432 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0250135' ,
          1 ,
          'Y'
        )
INSERT  dbo.LENDER_PAYEE_CODE_MATCH
        ( LENDER_PAYEE_CODE_FILE_ID ,
          REMITTANCE_ADDR_ID ,
          BIC_ID ,
          REMITTANCE_TYPE_CD ,
          CREATE_DT ,
          PURGE_DT ,
          UPDATE_DT ,
          UPDATE_USER_TX ,
          LOCK_ID ,
          PRIMARY_IN
        )
VALUES  ( 34162 ,
          209881 ,
          12076 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0250135' ,
          1 ,
          'Y'
        )
INSERT  dbo.LENDER_PAYEE_CODE_MATCH
        ( LENDER_PAYEE_CODE_FILE_ID ,
          REMITTANCE_ADDR_ID ,
          BIC_ID ,
          REMITTANCE_TYPE_CD ,
          CREATE_DT ,
          PURGE_DT ,
          UPDATE_DT ,
          UPDATE_USER_TX ,
          LOCK_ID ,
          PRIMARY_IN
        )
VALUES  ( 34161 ,
          153576 ,
          15797 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0250135' ,
          1 ,
          'Y'
        )
INSERT  dbo.LENDER_PAYEE_CODE_MATCH
        ( LENDER_PAYEE_CODE_FILE_ID ,
          REMITTANCE_ADDR_ID ,
          BIC_ID ,
          REMITTANCE_TYPE_CD ,
          CREATE_DT ,
          PURGE_DT ,
          UPDATE_DT ,
          UPDATE_USER_TX ,
          LOCK_ID ,
          PRIMARY_IN
        )
VALUES  ( 34160 ,
          232399 ,
          20052 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0250135' ,
          1 ,
          'Y'
        )
INSERT  dbo.LENDER_PAYEE_CODE_MATCH
        ( LENDER_PAYEE_CODE_FILE_ID ,
          REMITTANCE_ADDR_ID ,
          BIC_ID ,
          REMITTANCE_TYPE_CD ,
          CREATE_DT ,
          PURGE_DT ,
          UPDATE_DT ,
          UPDATE_USER_TX ,
          LOCK_ID ,
          PRIMARY_IN
        )
VALUES  ( 34159 ,
          8645 ,
          12111 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0250135' ,
          1 ,
          'Y'
        )
INSERT  dbo.LENDER_PAYEE_CODE_MATCH
        ( LENDER_PAYEE_CODE_FILE_ID ,
          REMITTANCE_ADDR_ID ,
          BIC_ID ,
          REMITTANCE_TYPE_CD ,
          CREATE_DT ,
          PURGE_DT ,
          UPDATE_DT ,
          UPDATE_USER_TX ,
          LOCK_ID ,
          PRIMARY_IN
        )
VALUES  ( 34158 ,
          146652 ,
          12112 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0250135' ,
          1 ,
          'Y'
        )
INSERT  dbo.LENDER_PAYEE_CODE_MATCH
        ( LENDER_PAYEE_CODE_FILE_ID ,
          REMITTANCE_ADDR_ID ,
          BIC_ID ,
          REMITTANCE_TYPE_CD ,
          CREATE_DT ,
          PURGE_DT ,
          UPDATE_DT ,
          UPDATE_USER_TX ,
          LOCK_ID ,
          PRIMARY_IN
        )
VALUES  ( 34157 ,
          27237 ,
          12131 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0250135' ,
          1 ,
          'Y'
        )
INSERT  dbo.LENDER_PAYEE_CODE_MATCH
        ( LENDER_PAYEE_CODE_FILE_ID ,
          REMITTANCE_ADDR_ID ,
          BIC_ID ,
          REMITTANCE_TYPE_CD ,
          CREATE_DT ,
          PURGE_DT ,
          UPDATE_DT ,
          UPDATE_USER_TX ,
          LOCK_ID ,
          PRIMARY_IN
        )
VALUES  ( 34156 ,
          8665 ,
          12137 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0250135' ,
          1 ,
          'Y'
        )
INSERT  dbo.LENDER_PAYEE_CODE_MATCH
        ( LENDER_PAYEE_CODE_FILE_ID ,
          REMITTANCE_ADDR_ID ,
          BIC_ID ,
          REMITTANCE_TYPE_CD ,
          CREATE_DT ,
          PURGE_DT ,
          UPDATE_DT ,
          UPDATE_USER_TX ,
          LOCK_ID ,
          PRIMARY_IN
        )
VALUES  ( 34155 ,
          9855 ,
          14477 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0250135' ,
          1 ,
          'Y'
        )
INSERT  dbo.LENDER_PAYEE_CODE_MATCH
        ( LENDER_PAYEE_CODE_FILE_ID ,
          REMITTANCE_ADDR_ID ,
          BIC_ID ,
          REMITTANCE_TYPE_CD ,
          CREATE_DT ,
          PURGE_DT ,
          UPDATE_DT ,
          UPDATE_USER_TX ,
          LOCK_ID ,
          PRIMARY_IN
        )
VALUES  ( 34154 ,
          175565 ,
          14969 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0250135' ,
          1 ,
          'Y'
        )
INSERT  dbo.LENDER_PAYEE_CODE_MATCH
        ( LENDER_PAYEE_CODE_FILE_ID ,
          REMITTANCE_ADDR_ID ,
          BIC_ID ,
          REMITTANCE_TYPE_CD ,
          CREATE_DT ,
          PURGE_DT ,
          UPDATE_DT ,
          UPDATE_USER_TX ,
          LOCK_ID ,
          PRIMARY_IN
        )
VALUES  ( 34153 ,
          10130 ,
          12147 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0250135' ,
          1 ,
          'Y'
        )
INSERT  dbo.LENDER_PAYEE_CODE_MATCH
        ( LENDER_PAYEE_CODE_FILE_ID ,
          REMITTANCE_ADDR_ID ,
          BIC_ID ,
          REMITTANCE_TYPE_CD ,
          CREATE_DT ,
          PURGE_DT ,
          UPDATE_DT ,
          UPDATE_USER_TX ,
          LOCK_ID ,
          PRIMARY_IN
        )
VALUES  ( 34152 ,
          118700 ,
          15336 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0250135' ,
          1 ,
          'Y'
        )
INSERT  dbo.LENDER_PAYEE_CODE_MATCH
        ( LENDER_PAYEE_CODE_FILE_ID ,
          REMITTANCE_ADDR_ID ,
          BIC_ID ,
          REMITTANCE_TYPE_CD ,
          CREATE_DT ,
          PURGE_DT ,
          UPDATE_DT ,
          UPDATE_USER_TX ,
          LOCK_ID ,
          PRIMARY_IN
        )
VALUES  ( 34151 ,
          9873 ,
          14498 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0250135' ,
          1 ,
          'Y'
        )
INSERT  dbo.LENDER_PAYEE_CODE_MATCH
        ( LENDER_PAYEE_CODE_FILE_ID ,
          REMITTANCE_ADDR_ID ,
          BIC_ID ,
          REMITTANCE_TYPE_CD ,
          CREATE_DT ,
          PURGE_DT ,
          UPDATE_DT ,
          UPDATE_USER_TX ,
          LOCK_ID ,
          PRIMARY_IN
        )
VALUES  ( 34150 ,
          284445 ,
          16039 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0250135' ,
          1 ,
          'Y'
        )
INSERT  dbo.LENDER_PAYEE_CODE_MATCH
        ( LENDER_PAYEE_CODE_FILE_ID ,
          REMITTANCE_ADDR_ID ,
          BIC_ID ,
          REMITTANCE_TYPE_CD ,
          CREATE_DT ,
          PURGE_DT ,
          UPDATE_DT ,
          UPDATE_USER_TX ,
          LOCK_ID ,
          PRIMARY_IN
        )
VALUES  ( 34149 ,
          9561 ,
          13666 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0250135' ,
          1 ,
          'Y'
        )
INSERT  dbo.LENDER_PAYEE_CODE_MATCH
        ( LENDER_PAYEE_CODE_FILE_ID ,
          REMITTANCE_ADDR_ID ,
          BIC_ID ,
          REMITTANCE_TYPE_CD ,
          CREATE_DT ,
          PURGE_DT ,
          UPDATE_DT ,
          UPDATE_USER_TX ,
          LOCK_ID ,
          PRIMARY_IN
        )
VALUES  ( 34148 ,
          212558 ,
          16083 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0250135' ,
          1 ,
          'Y'
        )
INSERT  dbo.LENDER_PAYEE_CODE_MATCH
        ( LENDER_PAYEE_CODE_FILE_ID ,
          REMITTANCE_ADDR_ID ,
          BIC_ID ,
          REMITTANCE_TYPE_CD ,
          CREATE_DT ,
          PURGE_DT ,
          UPDATE_DT ,
          UPDATE_USER_TX ,
          LOCK_ID ,
          PRIMARY_IN
        )
VALUES  ( 34147 ,
          153297 ,
          15792 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0250135' ,
          1 ,
          'Y'
        )
INSERT  dbo.LENDER_PAYEE_CODE_MATCH
        ( LENDER_PAYEE_CODE_FILE_ID ,
          REMITTANCE_ADDR_ID ,
          BIC_ID ,
          REMITTANCE_TYPE_CD ,
          CREATE_DT ,
          PURGE_DT ,
          UPDATE_DT ,
          UPDATE_USER_TX ,
          LOCK_ID ,
          PRIMARY_IN
        )
VALUES  ( 34146 ,
          210939 ,
          14883 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0250135' ,
          1 ,
          'Y'
        )
INSERT  dbo.LENDER_PAYEE_CODE_MATCH
        ( LENDER_PAYEE_CODE_FILE_ID ,
          REMITTANCE_ADDR_ID ,
          BIC_ID ,
          REMITTANCE_TYPE_CD ,
          CREATE_DT ,
          PURGE_DT ,
          UPDATE_DT ,
          UPDATE_USER_TX ,
          LOCK_ID ,
          PRIMARY_IN
        )
VALUES  ( 34145 ,
          9182 ,
          12784 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0250135' ,
          1 ,
          'Y'
        )
INSERT  dbo.LENDER_PAYEE_CODE_MATCH
        ( LENDER_PAYEE_CODE_FILE_ID ,
          REMITTANCE_ADDR_ID ,
          BIC_ID ,
          REMITTANCE_TYPE_CD ,
          CREATE_DT ,
          PURGE_DT ,
          UPDATE_DT ,
          UPDATE_USER_TX ,
          LOCK_ID ,
          PRIMARY_IN
        )
VALUES  ( 34144 ,
          265911 ,
          14949 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0250135' ,
          1 ,
          'Y'
        )
INSERT  dbo.LENDER_PAYEE_CODE_MATCH
        ( LENDER_PAYEE_CODE_FILE_ID ,
          REMITTANCE_ADDR_ID ,
          BIC_ID ,
          REMITTANCE_TYPE_CD ,
          CREATE_DT ,
          PURGE_DT ,
          UPDATE_DT ,
          UPDATE_USER_TX ,
          LOCK_ID ,
          PRIMARY_IN
        )
VALUES  ( 34143 ,
          10027 ,
          14873 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0250135' ,
          1 ,
          'Y'
        )
INSERT  dbo.LENDER_PAYEE_CODE_MATCH
        ( LENDER_PAYEE_CODE_FILE_ID ,
          REMITTANCE_ADDR_ID ,
          BIC_ID ,
          REMITTANCE_TYPE_CD ,
          CREATE_DT ,
          PURGE_DT ,
          UPDATE_DT ,
          UPDATE_USER_TX ,
          LOCK_ID ,
          PRIMARY_IN
        )
VALUES  ( 34142 ,
          18267 ,
          14547 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0250135' ,
          1 ,
          'Y'
        )
INSERT  dbo.LENDER_PAYEE_CODE_MATCH
        ( LENDER_PAYEE_CODE_FILE_ID ,
          REMITTANCE_ADDR_ID ,
          BIC_ID ,
          REMITTANCE_TYPE_CD ,
          CREATE_DT ,
          PURGE_DT ,
          UPDATE_DT ,
          UPDATE_USER_TX ,
          LOCK_ID ,
          PRIMARY_IN
        )
VALUES  ( 34141 ,
          24497 ,
          15157 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0250135' ,
          1 ,
          'Y'
        )
INSERT  dbo.LENDER_PAYEE_CODE_MATCH
        ( LENDER_PAYEE_CODE_FILE_ID ,
          REMITTANCE_ADDR_ID ,
          BIC_ID ,
          REMITTANCE_TYPE_CD ,
          CREATE_DT ,
          PURGE_DT ,
          UPDATE_DT ,
          UPDATE_USER_TX ,
          LOCK_ID ,
          PRIMARY_IN
        )
VALUES  ( 34140 ,
          227574 ,
          12211 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0250135' ,
          1 ,
          'Y'
        )
INSERT  dbo.LENDER_PAYEE_CODE_MATCH
        ( LENDER_PAYEE_CODE_FILE_ID ,
          REMITTANCE_ADDR_ID ,
          BIC_ID ,
          REMITTANCE_TYPE_CD ,
          CREATE_DT ,
          PURGE_DT ,
          UPDATE_DT ,
          UPDATE_USER_TX ,
          LOCK_ID ,
          PRIMARY_IN
        )
VALUES  ( 34139 ,
          175489 ,
          14564 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0250135' ,
          1 ,
          'Y'
        )
INSERT  dbo.LENDER_PAYEE_CODE_MATCH
        ( LENDER_PAYEE_CODE_FILE_ID ,
          REMITTANCE_ADDR_ID ,
          BIC_ID ,
          REMITTANCE_TYPE_CD ,
          CREATE_DT ,
          PURGE_DT ,
          UPDATE_DT ,
          UPDATE_USER_TX ,
          LOCK_ID ,
          PRIMARY_IN
        )
VALUES  ( 34138 ,
          24553 ,
          14565 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0250135' ,
          1 ,
          'Y'
        )
INSERT  dbo.LENDER_PAYEE_CODE_MATCH
        ( LENDER_PAYEE_CODE_FILE_ID ,
          REMITTANCE_ADDR_ID ,
          BIC_ID ,
          REMITTANCE_TYPE_CD ,
          CREATE_DT ,
          PURGE_DT ,
          UPDATE_DT ,
          UPDATE_USER_TX ,
          LOCK_ID ,
          PRIMARY_IN
        )
VALUES  ( 34137 ,
          147200 ,
          15238 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0250135' ,
          1 ,
          'Y'
        )
INSERT  dbo.LENDER_PAYEE_CODE_MATCH
        ( LENDER_PAYEE_CODE_FILE_ID ,
          REMITTANCE_ADDR_ID ,
          BIC_ID ,
          REMITTANCE_TYPE_CD ,
          CREATE_DT ,
          PURGE_DT ,
          UPDATE_DT ,
          UPDATE_USER_TX ,
          LOCK_ID ,
          PRIMARY_IN
        )
VALUES  ( 34136 ,
          37868 ,
          12854 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0250135' ,
          1 ,
          'Y'
        )
INSERT  dbo.LENDER_PAYEE_CODE_MATCH
        ( LENDER_PAYEE_CODE_FILE_ID ,
          REMITTANCE_ADDR_ID ,
          BIC_ID ,
          REMITTANCE_TYPE_CD ,
          CREATE_DT ,
          PURGE_DT ,
          UPDATE_DT ,
          UPDATE_USER_TX ,
          LOCK_ID ,
          PRIMARY_IN
        )
VALUES  ( 34135 ,
          18281 ,
          15078 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0250135' ,
          1 ,
          'Y'
        )
INSERT  dbo.LENDER_PAYEE_CODE_MATCH
        ( LENDER_PAYEE_CODE_FILE_ID ,
          REMITTANCE_ADDR_ID ,
          BIC_ID ,
          REMITTANCE_TYPE_CD ,
          CREATE_DT ,
          PURGE_DT ,
          UPDATE_DT ,
          UPDATE_USER_TX ,
          LOCK_ID ,
          PRIMARY_IN
        )
VALUES  ( 34134 ,
          147233 ,
          14577 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0250135' ,
          1 ,
          'Y'
        )
INSERT  dbo.LENDER_PAYEE_CODE_MATCH
        ( LENDER_PAYEE_CODE_FILE_ID ,
          REMITTANCE_ADDR_ID ,
          BIC_ID ,
          REMITTANCE_TYPE_CD ,
          CREATE_DT ,
          PURGE_DT ,
          UPDATE_DT ,
          UPDATE_USER_TX ,
          LOCK_ID ,
          PRIMARY_IN
        )
VALUES  ( 34133 ,
          9477 ,
          13442 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0250135' ,
          1 ,
          'Y'
        )
INSERT  dbo.LENDER_PAYEE_CODE_MATCH
        ( LENDER_PAYEE_CODE_FILE_ID ,
          REMITTANCE_ADDR_ID ,
          BIC_ID ,
          REMITTANCE_TYPE_CD ,
          CREATE_DT ,
          PURGE_DT ,
          UPDATE_DT ,
          UPDATE_USER_TX ,
          LOCK_ID ,
          PRIMARY_IN
        )
VALUES  ( 34132 ,
          9593 ,
          13803 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0250135' ,
          1 ,
          'Y'
        )
INSERT  dbo.LENDER_PAYEE_CODE_MATCH
        ( LENDER_PAYEE_CODE_FILE_ID ,
          REMITTANCE_ADDR_ID ,
          BIC_ID ,
          REMITTANCE_TYPE_CD ,
          CREATE_DT ,
          PURGE_DT ,
          UPDATE_DT ,
          UPDATE_USER_TX ,
          LOCK_ID ,
          PRIMARY_IN
        )
VALUES  ( 34131 ,
          282813 ,
          20287 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0250135' ,
          1 ,
          'Y'
        )
INSERT  dbo.LENDER_PAYEE_CODE_MATCH
        ( LENDER_PAYEE_CODE_FILE_ID ,
          REMITTANCE_ADDR_ID ,
          BIC_ID ,
          REMITTANCE_TYPE_CD ,
          CREATE_DT ,
          PURGE_DT ,
          UPDATE_DT ,
          UPDATE_USER_TX ,
          LOCK_ID ,
          PRIMARY_IN
        )
VALUES  ( 34130 ,
          113738 ,
          15015 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0250135' ,
          1 ,
          'Y'
        )
INSERT  dbo.LENDER_PAYEE_CODE_MATCH
        ( LENDER_PAYEE_CODE_FILE_ID ,
          REMITTANCE_ADDR_ID ,
          BIC_ID ,
          REMITTANCE_TYPE_CD ,
          CREATE_DT ,
          PURGE_DT ,
          UPDATE_DT ,
          UPDATE_USER_TX ,
          LOCK_ID ,
          PRIMARY_IN
        )
VALUES  ( 34129 ,
          123067 ,
          14611 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0250135' ,
          1 ,
          'Y'
        )
INSERT  dbo.LENDER_PAYEE_CODE_MATCH
        ( LENDER_PAYEE_CODE_FILE_ID ,
          REMITTANCE_ADDR_ID ,
          BIC_ID ,
          REMITTANCE_TYPE_CD ,
          CREATE_DT ,
          PURGE_DT ,
          UPDATE_DT ,
          UPDATE_USER_TX ,
          LOCK_ID ,
          PRIMARY_IN
        )
VALUES  ( 34128 ,
          187554 ,
          18258 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0250135' ,
          1 ,
          'Y'
        )
INSERT  dbo.LENDER_PAYEE_CODE_MATCH
        ( LENDER_PAYEE_CODE_FILE_ID ,
          REMITTANCE_ADDR_ID ,
          BIC_ID ,
          REMITTANCE_TYPE_CD ,
          CREATE_DT ,
          PURGE_DT ,
          UPDATE_DT ,
          UPDATE_USER_TX ,
          LOCK_ID ,
          PRIMARY_IN
        )
VALUES  ( 34127 ,
          281644 ,
          12357 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0250135' ,
          1 ,
          'Y'
        )
INSERT  dbo.LENDER_PAYEE_CODE_MATCH
        ( LENDER_PAYEE_CODE_FILE_ID ,
          REMITTANCE_ADDR_ID ,
          BIC_ID ,
          REMITTANCE_TYPE_CD ,
          CREATE_DT ,
          PURGE_DT ,
          UPDATE_DT ,
          UPDATE_USER_TX ,
          LOCK_ID ,
          PRIMARY_IN
        )
VALUES  ( 34126 ,
          267656 ,
          20077 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0250135' ,
          1 ,
          'Y'
        )
INSERT  dbo.LENDER_PAYEE_CODE_MATCH
        ( LENDER_PAYEE_CODE_FILE_ID ,
          REMITTANCE_ADDR_ID ,
          BIC_ID ,
          REMITTANCE_TYPE_CD ,
          CREATE_DT ,
          PURGE_DT ,
          UPDATE_DT ,
          UPDATE_USER_TX ,
          LOCK_ID ,
          PRIMARY_IN
        )
VALUES  ( 34125 ,
          232397 ,
          20051 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0250135' ,
          1 ,
          'Y'
        )
INSERT  dbo.LENDER_PAYEE_CODE_MATCH
        ( LENDER_PAYEE_CODE_FILE_ID ,
          REMITTANCE_ADDR_ID ,
          BIC_ID ,
          REMITTANCE_TYPE_CD ,
          CREATE_DT ,
          PURGE_DT ,
          UPDATE_DT ,
          UPDATE_USER_TX ,
          LOCK_ID ,
          PRIMARY_IN
        )
VALUES  ( 34124 ,
          9919 ,
          14624 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0250135' ,
          1 ,
          'Y'
        )
INSERT  dbo.LENDER_PAYEE_CODE_MATCH
        ( LENDER_PAYEE_CODE_FILE_ID ,
          REMITTANCE_ADDR_ID ,
          BIC_ID ,
          REMITTANCE_TYPE_CD ,
          CREATE_DT ,
          PURGE_DT ,
          UPDATE_DT ,
          UPDATE_USER_TX ,
          LOCK_ID ,
          PRIMARY_IN
        )
VALUES  ( 34123 ,
          10072 ,
          15016 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0250135' ,
          1 ,
          'Y'
        )
INSERT  dbo.LENDER_PAYEE_CODE_MATCH
        ( LENDER_PAYEE_CODE_FILE_ID ,
          REMITTANCE_ADDR_ID ,
          BIC_ID ,
          REMITTANCE_TYPE_CD ,
          CREATE_DT ,
          PURGE_DT ,
          UPDATE_DT ,
          UPDATE_USER_TX ,
          LOCK_ID ,
          PRIMARY_IN
        )
VALUES  ( 34122 ,
          147477 ,
          15454 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0250135' ,
          1 ,
          'Y'
        )
INSERT  dbo.LENDER_PAYEE_CODE_MATCH
        ( LENDER_PAYEE_CODE_FILE_ID ,
          REMITTANCE_ADDR_ID ,
          BIC_ID ,
          REMITTANCE_TYPE_CD ,
          CREATE_DT ,
          PURGE_DT ,
          UPDATE_DT ,
          UPDATE_USER_TX ,
          LOCK_ID ,
          PRIMARY_IN
        )
VALUES  ( 34121 ,
          188498 ,
          14653 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0250135' ,
          1 ,
          'Y'
        )
INSERT  dbo.LENDER_PAYEE_CODE_MATCH
        ( LENDER_PAYEE_CODE_FILE_ID ,
          REMITTANCE_ADDR_ID ,
          BIC_ID ,
          REMITTANCE_TYPE_CD ,
          CREATE_DT ,
          PURGE_DT ,
          UPDATE_DT ,
          UPDATE_USER_TX ,
          LOCK_ID ,
          PRIMARY_IN
        )
VALUES  ( 34120 ,
          147391 ,
          13114 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0250135' ,
          1 ,
          'Y'
        )
INSERT  dbo.LENDER_PAYEE_CODE_MATCH
        ( LENDER_PAYEE_CODE_FILE_ID ,
          REMITTANCE_ADDR_ID ,
          BIC_ID ,
          REMITTANCE_TYPE_CD ,
          CREATE_DT ,
          PURGE_DT ,
          UPDATE_DT ,
          UPDATE_USER_TX ,
          LOCK_ID ,
          PRIMARY_IN
        )
VALUES  ( 34119 ,
          170464 ,
          16436 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0250135' ,
          1 ,
          'Y'
        )
INSERT  dbo.LENDER_PAYEE_CODE_MATCH
        ( LENDER_PAYEE_CODE_FILE_ID ,
          REMITTANCE_ADDR_ID ,
          BIC_ID ,
          REMITTANCE_TYPE_CD ,
          CREATE_DT ,
          PURGE_DT ,
          UPDATE_DT ,
          UPDATE_USER_TX ,
          LOCK_ID ,
          PRIMARY_IN
        )
VALUES  ( 34118 ,
          39605 ,
          14657 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0250135' ,
          1 ,
          'Y'
        )
INSERT  dbo.LENDER_PAYEE_CODE_MATCH
        ( LENDER_PAYEE_CODE_FILE_ID ,
          REMITTANCE_ADDR_ID ,
          BIC_ID ,
          REMITTANCE_TYPE_CD ,
          CREATE_DT ,
          PURGE_DT ,
          UPDATE_DT ,
          UPDATE_USER_TX ,
          LOCK_ID ,
          PRIMARY_IN
        )
VALUES  ( 34117 ,
          23847 ,
          14981 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0250135' ,
          1 ,
          'Y'
        )
INSERT  dbo.LENDER_PAYEE_CODE_MATCH
        ( LENDER_PAYEE_CODE_FILE_ID ,
          REMITTANCE_ADDR_ID ,
          BIC_ID ,
          REMITTANCE_TYPE_CD ,
          CREATE_DT ,
          PURGE_DT ,
          UPDATE_DT ,
          UPDATE_USER_TX ,
          LOCK_ID ,
          PRIMARY_IN
        )
VALUES  ( 34116 ,
          40173 ,
          13439 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0250135' ,
          1 ,
          'Y'
        )
INSERT  dbo.LENDER_PAYEE_CODE_MATCH
        ( LENDER_PAYEE_CODE_FILE_ID ,
          REMITTANCE_ADDR_ID ,
          BIC_ID ,
          REMITTANCE_TYPE_CD ,
          CREATE_DT ,
          PURGE_DT ,
          UPDATE_DT ,
          UPDATE_USER_TX ,
          LOCK_ID ,
          PRIMARY_IN
        )
VALUES  ( 34115 ,
          12875 ,
          15123 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0250135' ,
          1 ,
          'Y'
        )
INSERT  dbo.LENDER_PAYEE_CODE_MATCH
        ( LENDER_PAYEE_CODE_FILE_ID ,
          REMITTANCE_ADDR_ID ,
          BIC_ID ,
          REMITTANCE_TYPE_CD ,
          CREATE_DT ,
          PURGE_DT ,
          UPDATE_DT ,
          UPDATE_USER_TX ,
          LOCK_ID ,
          PRIMARY_IN
        )
VALUES  ( 34114 ,
          9928 ,
          14677 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0250135' ,
          1 ,
          'Y'
        )
INSERT  dbo.LENDER_PAYEE_CODE_MATCH
        ( LENDER_PAYEE_CODE_FILE_ID ,
          REMITTANCE_ADDR_ID ,
          BIC_ID ,
          REMITTANCE_TYPE_CD ,
          CREATE_DT ,
          PURGE_DT ,
          UPDATE_DT ,
          UPDATE_USER_TX ,
          LOCK_ID ,
          PRIMARY_IN
        )
VALUES  ( 34113 ,
          9683 ,
          14119 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0250135' ,
          1 ,
          'Y'
        )
INSERT  dbo.LENDER_PAYEE_CODE_MATCH
        ( LENDER_PAYEE_CODE_FILE_ID ,
          REMITTANCE_ADDR_ID ,
          BIC_ID ,
          REMITTANCE_TYPE_CD ,
          CREATE_DT ,
          PURGE_DT ,
          UPDATE_DT ,
          UPDATE_USER_TX ,
          LOCK_ID ,
          PRIMARY_IN
        )
VALUES  ( 34112 ,
          147457 ,
          16474 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0250135' ,
          1 ,
          'Y'
        )
INSERT  dbo.LENDER_PAYEE_CODE_MATCH
        ( LENDER_PAYEE_CODE_FILE_ID ,
          REMITTANCE_ADDR_ID ,
          BIC_ID ,
          REMITTANCE_TYPE_CD ,
          CREATE_DT ,
          PURGE_DT ,
          UPDATE_DT ,
          UPDATE_USER_TX ,
          LOCK_ID ,
          PRIMARY_IN
        )
VALUES  ( 34111 ,
          9002 ,
          12503 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0250135' ,
          1 ,
          'Y'
        )
INSERT  dbo.LENDER_PAYEE_CODE_MATCH
        ( LENDER_PAYEE_CODE_FILE_ID ,
          REMITTANCE_ADDR_ID ,
          BIC_ID ,
          REMITTANCE_TYPE_CD ,
          CREATE_DT ,
          PURGE_DT ,
          UPDATE_DT ,
          UPDATE_USER_TX ,
          LOCK_ID ,
          PRIMARY_IN
        )
VALUES  ( 34110 ,
          175115 ,
          15103 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0250135' ,
          1 ,
          'Y'
        )
INSERT  dbo.LENDER_PAYEE_CODE_MATCH
        ( LENDER_PAYEE_CODE_FILE_ID ,
          REMITTANCE_ADDR_ID ,
          BIC_ID ,
          REMITTANCE_TYPE_CD ,
          CREATE_DT ,
          PURGE_DT ,
          UPDATE_DT ,
          UPDATE_USER_TX ,
          LOCK_ID ,
          PRIMARY_IN
        )
VALUES  ( 34109 ,
          175415 ,
          13112 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0250135' ,
          1 ,
          'Y'
        )
INSERT  dbo.LENDER_PAYEE_CODE_MATCH
        ( LENDER_PAYEE_CODE_FILE_ID ,
          REMITTANCE_ADDR_ID ,
          BIC_ID ,
          REMITTANCE_TYPE_CD ,
          CREATE_DT ,
          PURGE_DT ,
          UPDATE_DT ,
          UPDATE_USER_TX ,
          LOCK_ID ,
          PRIMARY_IN
        )
VALUES  ( 34108 ,
          39760 ,
          15245 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0250135' ,
          1 ,
          'Y'
        )
INSERT  dbo.LENDER_PAYEE_CODE_MATCH
        ( LENDER_PAYEE_CODE_FILE_ID ,
          REMITTANCE_ADDR_ID ,
          BIC_ID ,
          REMITTANCE_TYPE_CD ,
          CREATE_DT ,
          PURGE_DT ,
          UPDATE_DT ,
          UPDATE_USER_TX ,
          LOCK_ID ,
          PRIMARY_IN
        )
VALUES  ( 34107 ,
          9021 ,
          12570 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0250135' ,
          1 ,
          'Y'
        )
INSERT  dbo.LENDER_PAYEE_CODE_MATCH
        ( LENDER_PAYEE_CODE_FILE_ID ,
          REMITTANCE_ADDR_ID ,
          BIC_ID ,
          REMITTANCE_TYPE_CD ,
          CREATE_DT ,
          PURGE_DT ,
          UPDATE_DT ,
          UPDATE_USER_TX ,
          LOCK_ID ,
          PRIMARY_IN
        )
VALUES  ( 34106 ,
          23814 ,
          13071 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0250135' ,
          1 ,
          'Y'
        )
INSERT  dbo.LENDER_PAYEE_CODE_MATCH
        ( LENDER_PAYEE_CODE_FILE_ID ,
          REMITTANCE_ADDR_ID ,
          BIC_ID ,
          REMITTANCE_TYPE_CD ,
          CREATE_DT ,
          PURGE_DT ,
          UPDATE_DT ,
          UPDATE_USER_TX ,
          LOCK_ID ,
          PRIMARY_IN
        )
VALUES  ( 34105 ,
          24765 ,
          13071 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0250135' ,
          1 ,
          'Y'
        )
INSERT  dbo.LENDER_PAYEE_CODE_MATCH
        ( LENDER_PAYEE_CODE_FILE_ID ,
          REMITTANCE_ADDR_ID ,
          BIC_ID ,
          REMITTANCE_TYPE_CD ,
          CREATE_DT ,
          PURGE_DT ,
          UPDATE_DT ,
          UPDATE_USER_TX ,
          LOCK_ID ,
          PRIMARY_IN
        )
VALUES  ( 34104 ,
          147509 ,
          13527 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0250135' ,
          1 ,
          'Y'
        )
INSERT  dbo.LENDER_PAYEE_CODE_MATCH
        ( LENDER_PAYEE_CODE_FILE_ID ,
          REMITTANCE_ADDR_ID ,
          BIC_ID ,
          REMITTANCE_TYPE_CD ,
          CREATE_DT ,
          PURGE_DT ,
          UPDATE_DT ,
          UPDATE_USER_TX ,
          LOCK_ID ,
          PRIMARY_IN
        )
VALUES  ( 34103 ,
          147515 ,
          12603 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0250135' ,
          1 ,
          'Y'
        )
INSERT  dbo.LENDER_PAYEE_CODE_MATCH
        ( LENDER_PAYEE_CODE_FILE_ID ,
          REMITTANCE_ADDR_ID ,
          BIC_ID ,
          REMITTANCE_TYPE_CD ,
          CREATE_DT ,
          PURGE_DT ,
          UPDATE_DT ,
          UPDATE_USER_TX ,
          LOCK_ID ,
          PRIMARY_IN
        )
VALUES  ( 34102 ,
          9657 ,
          14012 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0250135' ,
          1 ,
          'Y'
        )
INSERT  dbo.LENDER_PAYEE_CODE_MATCH
        ( LENDER_PAYEE_CODE_FILE_ID ,
          REMITTANCE_ADDR_ID ,
          BIC_ID ,
          REMITTANCE_TYPE_CD ,
          CREATE_DT ,
          PURGE_DT ,
          UPDATE_DT ,
          UPDATE_USER_TX ,
          LOCK_ID ,
          PRIMARY_IN
        )
VALUES  ( 34101 ,
          178063 ,
          14771 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0250135' ,
          1 ,
          'Y'
        )
INSERT  dbo.LENDER_PAYEE_CODE_MATCH
        ( LENDER_PAYEE_CODE_FILE_ID ,
          REMITTANCE_ADDR_ID ,
          BIC_ID ,
          REMITTANCE_TYPE_CD ,
          CREATE_DT ,
          PURGE_DT ,
          UPDATE_DT ,
          UPDATE_USER_TX ,
          LOCK_ID ,
          PRIMARY_IN
        )
VALUES  ( 34100 ,
          9953 ,
          14786 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0250135' ,
          1 ,
          'Y'
        )
INSERT  dbo.LENDER_PAYEE_CODE_MATCH
        ( LENDER_PAYEE_CODE_FILE_ID ,
          REMITTANCE_ADDR_ID ,
          BIC_ID ,
          REMITTANCE_TYPE_CD ,
          CREATE_DT ,
          PURGE_DT ,
          UPDATE_DT ,
          UPDATE_USER_TX ,
          LOCK_ID ,
          PRIMARY_IN
        )
VALUES  ( 34099 ,
          114764 ,
          13486 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0250135' ,
          1 ,
          'Y'
        )
INSERT  dbo.LENDER_PAYEE_CODE_MATCH
        ( LENDER_PAYEE_CODE_FILE_ID ,
          REMITTANCE_ADDR_ID ,
          BIC_ID ,
          REMITTANCE_TYPE_CD ,
          CREATE_DT ,
          PURGE_DT ,
          UPDATE_DT ,
          UPDATE_USER_TX ,
          LOCK_ID ,
          PRIMARY_IN
        )
VALUES  ( 34098 ,
          175225 ,
          16556 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0250135' ,
          1 ,
          'Y'
        )
INSERT  dbo.LENDER_PAYEE_CODE_MATCH
        ( LENDER_PAYEE_CODE_FILE_ID ,
          REMITTANCE_ADDR_ID ,
          BIC_ID ,
          REMITTANCE_TYPE_CD ,
          CREATE_DT ,
          PURGE_DT ,
          UPDATE_DT ,
          UPDATE_USER_TX ,
          LOCK_ID ,
          PRIMARY_IN
        )
VALUES  ( 34097 ,
          141459 ,
          13655 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0250135' ,
          1 ,
          'Y'
        )
INSERT  dbo.LENDER_PAYEE_CODE_MATCH
        ( LENDER_PAYEE_CODE_FILE_ID ,
          REMITTANCE_ADDR_ID ,
          BIC_ID ,
          REMITTANCE_TYPE_CD ,
          CREATE_DT ,
          PURGE_DT ,
          UPDATE_DT ,
          UPDATE_USER_TX ,
          LOCK_ID ,
          PRIMARY_IN
        )
VALUES  ( 34096 ,
          9333 ,
          13087 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0250135' ,
          1 ,
          'Y'
        )
INSERT  dbo.LENDER_PAYEE_CODE_MATCH
        ( LENDER_PAYEE_CODE_FILE_ID ,
          REMITTANCE_ADDR_ID ,
          BIC_ID ,
          REMITTANCE_TYPE_CD ,
          CREATE_DT ,
          PURGE_DT ,
          UPDATE_DT ,
          UPDATE_USER_TX ,
          LOCK_ID ,
          PRIMARY_IN
        )
VALUES  ( 34095 ,
          27388 ,
          15235 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0250135' ,
          1 ,
          'Y'
        )
INSERT  dbo.LENDER_PAYEE_CODE_MATCH
        ( LENDER_PAYEE_CODE_FILE_ID ,
          REMITTANCE_ADDR_ID ,
          BIC_ID ,
          REMITTANCE_TYPE_CD ,
          CREATE_DT ,
          PURGE_DT ,
          UPDATE_DT ,
          UPDATE_USER_TX ,
          LOCK_ID ,
          PRIMARY_IN
        )
VALUES  ( 34094 ,
          149507 ,
          15508 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0250135' ,
          1 ,
          'Y'
        )
INSERT  dbo.LENDER_PAYEE_CODE_MATCH
        ( LENDER_PAYEE_CODE_FILE_ID ,
          REMITTANCE_ADDR_ID ,
          BIC_ID ,
          REMITTANCE_TYPE_CD ,
          CREATE_DT ,
          PURGE_DT ,
          UPDATE_DT ,
          UPDATE_USER_TX ,
          LOCK_ID ,
          PRIMARY_IN
        )
VALUES  ( 34093 ,
          114640 ,
          13957 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0250135' ,
          1 ,
          'Y'
        )
INSERT  dbo.LENDER_PAYEE_CODE_MATCH
        ( LENDER_PAYEE_CODE_FILE_ID ,
          REMITTANCE_ADDR_ID ,
          BIC_ID ,
          REMITTANCE_TYPE_CD ,
          CREATE_DT ,
          PURGE_DT ,
          UPDATE_DT ,
          UPDATE_USER_TX ,
          LOCK_ID ,
          PRIMARY_IN
        )
VALUES  ( 34092 ,
          147033 ,
          13304 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0250135' ,
          1 ,
          'Y'
        )
INSERT  dbo.LENDER_PAYEE_CODE_MATCH
        ( LENDER_PAYEE_CODE_FILE_ID ,
          REMITTANCE_ADDR_ID ,
          BIC_ID ,
          REMITTANCE_TYPE_CD ,
          CREATE_DT ,
          PURGE_DT ,
          UPDATE_DT ,
          UPDATE_USER_TX ,
          LOCK_ID ,
          PRIMARY_IN
        )
VALUES  ( 34091 ,
          9522 ,
          13624 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0250135' ,
          1 ,
          'Y'
        )
INSERT  dbo.LENDER_PAYEE_CODE_MATCH
        ( LENDER_PAYEE_CODE_FILE_ID ,
          REMITTANCE_ADDR_ID ,
          BIC_ID ,
          REMITTANCE_TYPE_CD ,
          CREATE_DT ,
          PURGE_DT ,
          UPDATE_DT ,
          UPDATE_USER_TX ,
          LOCK_ID ,
          PRIMARY_IN
        )
VALUES  ( 34090 ,
          9288 ,
          13023 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0250135' ,
          1 ,
          'Y'
        )
INSERT  dbo.LENDER_PAYEE_CODE_MATCH
        ( LENDER_PAYEE_CODE_FILE_ID ,
          REMITTANCE_ADDR_ID ,
          BIC_ID ,
          REMITTANCE_TYPE_CD ,
          CREATE_DT ,
          PURGE_DT ,
          UPDATE_DT ,
          UPDATE_USER_TX ,
          LOCK_ID ,
          PRIMARY_IN
        )
VALUES  ( 34089 ,
          39004 ,
          12723 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0250135' ,
          1 ,
          'Y'
        )
INSERT  dbo.LENDER_PAYEE_CODE_MATCH
        ( LENDER_PAYEE_CODE_FILE_ID ,
          REMITTANCE_ADDR_ID ,
          BIC_ID ,
          REMITTANCE_TYPE_CD ,
          CREATE_DT ,
          PURGE_DT ,
          UPDATE_DT ,
          UPDATE_USER_TX ,
          LOCK_ID ,
          PRIMARY_IN
        )
VALUES  ( 34088 ,
          37811 ,
          12723 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0250135' ,
          1 ,
          'Y'
        )
INSERT  dbo.LENDER_PAYEE_CODE_MATCH
        ( LENDER_PAYEE_CODE_FILE_ID ,
          REMITTANCE_ADDR_ID ,
          BIC_ID ,
          REMITTANCE_TYPE_CD ,
          CREATE_DT ,
          PURGE_DT ,
          UPDATE_DT ,
          UPDATE_USER_TX ,
          LOCK_ID ,
          PRIMARY_IN
        )
VALUES  ( 34087 ,
          296223 ,
          20322 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0250135' ,
          1 ,
          'Y'
        )
INSERT  dbo.LENDER_PAYEE_CODE_MATCH
        ( LENDER_PAYEE_CODE_FILE_ID ,
          REMITTANCE_ADDR_ID ,
          BIC_ID ,
          REMITTANCE_TYPE_CD ,
          CREATE_DT ,
          PURGE_DT ,
          UPDATE_DT ,
          UPDATE_USER_TX ,
          LOCK_ID ,
          PRIMARY_IN
        )
VALUES  ( 34086 ,
          146127 ,
          12770 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0250135' ,
          1 ,
          'Y'
        )
INSERT  dbo.LENDER_PAYEE_CODE_MATCH
        ( LENDER_PAYEE_CODE_FILE_ID ,
          REMITTANCE_ADDR_ID ,
          BIC_ID ,
          REMITTANCE_TYPE_CD ,
          CREATE_DT ,
          PURGE_DT ,
          UPDATE_DT ,
          UPDATE_USER_TX ,
          LOCK_ID ,
          PRIMARY_IN
        )
VALUES  ( 34085 ,
          146133 ,
          13037 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0250135' ,
          1 ,
          'Y'
        )
INSERT  dbo.LENDER_PAYEE_CODE_MATCH
        ( LENDER_PAYEE_CODE_FILE_ID ,
          REMITTANCE_ADDR_ID ,
          BIC_ID ,
          REMITTANCE_TYPE_CD ,
          CREATE_DT ,
          PURGE_DT ,
          UPDATE_DT ,
          UPDATE_USER_TX ,
          LOCK_ID ,
          PRIMARY_IN
        )
VALUES  ( 34084 ,
          114395 ,
          12768 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0250135' ,
          1 ,
          'Y'
        )
INSERT  dbo.LENDER_PAYEE_CODE_MATCH
        ( LENDER_PAYEE_CODE_FILE_ID ,
          REMITTANCE_ADDR_ID ,
          BIC_ID ,
          REMITTANCE_TYPE_CD ,
          CREATE_DT ,
          PURGE_DT ,
          UPDATE_DT ,
          UPDATE_USER_TX ,
          LOCK_ID ,
          PRIMARY_IN
        )
VALUES  ( 34083 ,
          146494 ,
          13814 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0250135' ,
          1 ,
          'Y'
        )
