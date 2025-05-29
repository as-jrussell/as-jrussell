SELECT *
FROM LENDER
WHERE CODE_TX = '3769'

SELECT ID, PAYEE_CODE_TX
FROM LENDER_PAYEE_CODE_FILE
WHERE LENDER_ID = 2325 AND LEN(PAYEE_CODE_TX) = '4'
ORDER BY PAYEE_CODE_TX ASC 


SELECT ID INTO #tmpLPCF
FROM LENDER_PAYEE_CODE_FILE
WHERE LENDER_ID = 2325

DROP TABLE #tmpLPCF

SELECT * FROM #tmpLPCF

SELECT *
FROM LENDER_PAYEE_CODE_MATCH
WHERE LENDEr_PAYEE_CODE_FILE_ID IN (SELECT ID FROM #tmpLPCF) 


SELECT LPCF.ID, LPCF.PAYEE_CODE_TX FROM dbo.LENDER_PAYEE_CODE_FILE LPCF
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
VALUES  ( 33039 ,
          287533 ,
          18317 ,
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
VALUES  ( 33069 ,
          295042 ,
          20319 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0250135' ,
          2 ,
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
VALUES  ( 33077 ,
          287982 ,
          16611 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0250135' ,
          3 ,
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
VALUES  ( 33098 ,
          296099 ,
          15902 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0250135' ,
          4 ,
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
VALUES  ( 33122 ,
          287642 ,
          20302 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0250135' ,
          5 ,
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
VALUES  ( 33189 ,
          288956 ,
          20304 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0250135' ,
          6 ,
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
VALUES  ( 33192 ,
          292765 ,
          20309 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0250135' ,
          7 ,
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
VALUES  ( 33225 ,
          288847 ,
          20243 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0250135' ,
          8 ,
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
VALUES  ( 33264 ,
          307472 ,
          18361 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0250135' ,
          9 ,
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
VALUES  ( 33272 ,
          288784 ,
          18362 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0250135' ,
          10 ,
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
VALUES  ( 33361 ,
          293863 ,
          20315 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0250135' ,
          11 ,
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
VALUES  ( 33406 ,
          287287 ,
          20299 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0250135' ,
          12 ,
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
VALUES  ( 33422 ,
          293734 ,
          16362 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0250135' ,
          13 ,
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
VALUES  ( 33571 ,
          296520 ,
          20087 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0250135' ,
          14 ,
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
VALUES  ( 33574 ,
          287323 ,
          12520 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0250135' ,
          15 ,
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
VALUES  ( 33584 ,
          291442 ,
          16268 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0250135' ,
          16 ,
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
VALUES  ( 33586 ,
          292694 ,
          20308 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0250135' ,
          17 ,
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
VALUES  ( 33597 ,
          287460 ,
          20300 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0250135' ,
          18 ,
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
VALUES  ( 33620 ,
          288186 ,
          15582 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0250135' ,
          19 ,
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
VALUES  ( 33662 ,
          296834 ,
          20329 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0250135' ,
          20 ,
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
VALUES  ( 33663 ,
          296833 ,
          20329 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0250135' ,
          21 ,
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
VALUES  ( 33715 ,
          295043 ,
          20320 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0250135' ,
          22 ,
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
VALUES  ( 33798 ,
          293843 ,
          20313 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0250135' ,
          23 ,
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
VALUES  ( 32879 ,
          294596 ,
          20322 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0250135' ,
          1 ,
          'Y'
        )

		SELECT * FROM dbo.ADDRESS
		WHERE UPDATE_USER_TX = 'INC0250135'



        SELECT  *
        FROM    dbo.ADDRESS
        WHERE   ID IN ( 287533, 295042, 287982, 296099, 287642, 288956, 292765,
                        288847, 307472, 288784, 293863, 287287, 293734, 296520,
                        287323, 291442, 292694, 287460, 288186, 296834, 296833,
                        295043, 293843 )





INSERT dbo.LENDER_PAYEE_CODE_MATCH ( LENDER_PAYEE_CODE_FILE_ID ,REMITTANCE_ADDR_ID ,BIC_ID ,REMITTANCE_TYPE_CD ,CREATE_DT ,PURGE_DT ,UPDATE_DT ,UPDATE_USER_TX ,LOCK_ID ,PRIMARY_IN)VALUES	(	33039	,	287533	,	18317	,	N'BIC'	,	GETDATE()	,NULL	,	GETDATE()	,	N'INC0250135'	,	1	,'Y')
INSERT dbo.LENDER_PAYEE_CODE_MATCH ( LENDER_PAYEE_CODE_FILE_ID ,REMITTANCE_ADDR_ID ,BIC_ID ,REMITTANCE_TYPE_CD ,CREATE_DT ,PURGE_DT ,UPDATE_DT ,UPDATE_USER_TX ,LOCK_ID ,PRIMARY_IN)VALUES	(	33069	,	295042	,	20319	,	N'BIC'	,	GETDATE()	,NULL	,	GETDATE()	,	N'INC0250135'	,	2	,'Y')
INSERT dbo.LENDER_PAYEE_CODE_MATCH ( LENDER_PAYEE_CODE_FILE_ID ,REMITTANCE_ADDR_ID ,BIC_ID ,REMITTANCE_TYPE_CD ,CREATE_DT ,PURGE_DT ,UPDATE_DT ,UPDATE_USER_TX ,LOCK_ID ,PRIMARY_IN)VALUES	(	33077	,	287982	,	16611	,	N'BIC'	,	GETDATE()	,NULL	,	GETDATE()	,	N'INC0250135'	,	3	,'Y')
INSERT dbo.LENDER_PAYEE_CODE_MATCH ( LENDER_PAYEE_CODE_FILE_ID ,REMITTANCE_ADDR_ID ,BIC_ID ,REMITTANCE_TYPE_CD ,CREATE_DT ,PURGE_DT ,UPDATE_DT ,UPDATE_USER_TX ,LOCK_ID ,PRIMARY_IN)VALUES	(	33098	,	296099	,	15902	,	N'BIC'	,	GETDATE()	,NULL	,	GETDATE()	,	N'INC0250135'	,	4	,'Y')
INSERT dbo.LENDER_PAYEE_CODE_MATCH ( LENDER_PAYEE_CODE_FILE_ID ,REMITTANCE_ADDR_ID ,BIC_ID ,REMITTANCE_TYPE_CD ,CREATE_DT ,PURGE_DT ,UPDATE_DT ,UPDATE_USER_TX ,LOCK_ID ,PRIMARY_IN)VALUES	(	33122	,	287642	,	20302	,	N'BIC'	,	GETDATE()	,NULL	,	GETDATE()	,	N'INC0250135'	,	5	,'Y')
INSERT dbo.LENDER_PAYEE_CODE_MATCH ( LENDER_PAYEE_CODE_FILE_ID ,REMITTANCE_ADDR_ID ,BIC_ID ,REMITTANCE_TYPE_CD ,CREATE_DT ,PURGE_DT ,UPDATE_DT ,UPDATE_USER_TX ,LOCK_ID ,PRIMARY_IN)VALUES	(	33189	,	288956	,	20304	,	N'BIC'	,	GETDATE()	,NULL	,	GETDATE()	,	N'INC0250135'	,	6	,'Y')
INSERT dbo.LENDER_PAYEE_CODE_MATCH ( LENDER_PAYEE_CODE_FILE_ID ,REMITTANCE_ADDR_ID ,BIC_ID ,REMITTANCE_TYPE_CD ,CREATE_DT ,PURGE_DT ,UPDATE_DT ,UPDATE_USER_TX ,LOCK_ID ,PRIMARY_IN)VALUES	(	33192	,	292765	,	20309	,	N'BIC'	,	GETDATE()	,NULL	,	GETDATE()	,	N'INC0250135'	,	7	,'Y')
INSERT dbo.LENDER_PAYEE_CODE_MATCH ( LENDER_PAYEE_CODE_FILE_ID ,REMITTANCE_ADDR_ID ,BIC_ID ,REMITTANCE_TYPE_CD ,CREATE_DT ,PURGE_DT ,UPDATE_DT ,UPDATE_USER_TX ,LOCK_ID ,PRIMARY_IN)VALUES	(	33225	,	288847	,	20243	,	N'BIC'	,	GETDATE()	,NULL	,	GETDATE()	,	N'INC0250135'	,	8	,'Y')
INSERT dbo.LENDER_PAYEE_CODE_MATCH ( LENDER_PAYEE_CODE_FILE_ID ,REMITTANCE_ADDR_ID ,BIC_ID ,REMITTANCE_TYPE_CD ,CREATE_DT ,PURGE_DT ,UPDATE_DT ,UPDATE_USER_TX ,LOCK_ID ,PRIMARY_IN)VALUES	(	33264	,	307472	,	18361	,	N'BIC'	,	GETDATE()	,NULL	,	GETDATE()	,	N'INC0250135'	,	9	,'Y')
INSERT dbo.LENDER_PAYEE_CODE_MATCH ( LENDER_PAYEE_CODE_FILE_ID ,REMITTANCE_ADDR_ID ,BIC_ID ,REMITTANCE_TYPE_CD ,CREATE_DT ,PURGE_DT ,UPDATE_DT ,UPDATE_USER_TX ,LOCK_ID ,PRIMARY_IN)VALUES	(	33272	,	288784	,	18362	,	N'BIC'	,	GETDATE()	,NULL	,	GETDATE()	,	N'INC0250135'	,	10	,'Y')
INSERT dbo.LENDER_PAYEE_CODE_MATCH ( LENDER_PAYEE_CODE_FILE_ID ,REMITTANCE_ADDR_ID ,BIC_ID ,REMITTANCE_TYPE_CD ,CREATE_DT ,PURGE_DT ,UPDATE_DT ,UPDATE_USER_TX ,LOCK_ID ,PRIMARY_IN)VALUES	(	33361	,	293863	,	20315	,	N'BIC'	,	GETDATE()	,NULL	,	GETDATE()	,	N'INC0250135'	,	11	,'Y')
INSERT dbo.LENDER_PAYEE_CODE_MATCH ( LENDER_PAYEE_CODE_FILE_ID ,REMITTANCE_ADDR_ID ,BIC_ID ,REMITTANCE_TYPE_CD ,CREATE_DT ,PURGE_DT ,UPDATE_DT ,UPDATE_USER_TX ,LOCK_ID ,PRIMARY_IN)VALUES	(	33406	,	287287	,	20299	,	N'BIC'	,	GETDATE()	,NULL	,	GETDATE()	,	N'INC0250135'	,	12	,'Y')
INSERT dbo.LENDER_PAYEE_CODE_MATCH ( LENDER_PAYEE_CODE_FILE_ID ,REMITTANCE_ADDR_ID ,BIC_ID ,REMITTANCE_TYPE_CD ,CREATE_DT ,PURGE_DT ,UPDATE_DT ,UPDATE_USER_TX ,LOCK_ID ,PRIMARY_IN)VALUES	(	33422	,	293734	,	16362	,	N'BIC'	,	GETDATE()	,NULL	,	GETDATE()	,	N'INC0250135'	,	13	,'Y')
INSERT dbo.LENDER_PAYEE_CODE_MATCH ( LENDER_PAYEE_CODE_FILE_ID ,REMITTANCE_ADDR_ID ,BIC_ID ,REMITTANCE_TYPE_CD ,CREATE_DT ,PURGE_DT ,UPDATE_DT ,UPDATE_USER_TX ,LOCK_ID ,PRIMARY_IN)VALUES	(	33571	,	296520	,	20087	,	N'BIC'	,	GETDATE()	,NULL	,	GETDATE()	,	N'INC0250135'	,	14	,'Y')
INSERT dbo.LENDER_PAYEE_CODE_MATCH ( LENDER_PAYEE_CODE_FILE_ID ,REMITTANCE_ADDR_ID ,BIC_ID ,REMITTANCE_TYPE_CD ,CREATE_DT ,PURGE_DT ,UPDATE_DT ,UPDATE_USER_TX ,LOCK_ID ,PRIMARY_IN)VALUES	(	33574	,	287323	,	12520	,	N'BIC'	,	GETDATE()	,NULL	,	GETDATE()	,	N'INC0250135'	,	15	,'Y')
INSERT dbo.LENDER_PAYEE_CODE_MATCH ( LENDER_PAYEE_CODE_FILE_ID ,REMITTANCE_ADDR_ID ,BIC_ID ,REMITTANCE_TYPE_CD ,CREATE_DT ,PURGE_DT ,UPDATE_DT ,UPDATE_USER_TX ,LOCK_ID ,PRIMARY_IN)VALUES	(	33584	,	291442	,	16268	,	N'BIC'	,	GETDATE()	,NULL	,	GETDATE()	,	N'INC0250135'	,	16	,'Y')
INSERT dbo.LENDER_PAYEE_CODE_MATCH ( LENDER_PAYEE_CODE_FILE_ID ,REMITTANCE_ADDR_ID ,BIC_ID ,REMITTANCE_TYPE_CD ,CREATE_DT ,PURGE_DT ,UPDATE_DT ,UPDATE_USER_TX ,LOCK_ID ,PRIMARY_IN)VALUES	(	33586	,	292694	,	20308	,	N'BIC'	,	GETDATE()	,NULL	,	GETDATE()	,	N'INC0250135'	,	17	,'Y')
INSERT dbo.LENDER_PAYEE_CODE_MATCH ( LENDER_PAYEE_CODE_FILE_ID ,REMITTANCE_ADDR_ID ,BIC_ID ,REMITTANCE_TYPE_CD ,CREATE_DT ,PURGE_DT ,UPDATE_DT ,UPDATE_USER_TX ,LOCK_ID ,PRIMARY_IN)VALUES	(	33597	,	287460	,	20300	,	N'BIC'	,	GETDATE()	,NULL	,	GETDATE()	,	N'INC0250135'	,	18	,'Y')
INSERT dbo.LENDER_PAYEE_CODE_MATCH ( LENDER_PAYEE_CODE_FILE_ID ,REMITTANCE_ADDR_ID ,BIC_ID ,REMITTANCE_TYPE_CD ,CREATE_DT ,PURGE_DT ,UPDATE_DT ,UPDATE_USER_TX ,LOCK_ID ,PRIMARY_IN)VALUES	(	33620	,	288186	,	15582	,	N'BIC'	,	GETDATE()	,NULL	,	GETDATE()	,	N'INC0250135'	,	19	,'Y')
INSERT dbo.LENDER_PAYEE_CODE_MATCH ( LENDER_PAYEE_CODE_FILE_ID ,REMITTANCE_ADDR_ID ,BIC_ID ,REMITTANCE_TYPE_CD ,CREATE_DT ,PURGE_DT ,UPDATE_DT ,UPDATE_USER_TX ,LOCK_ID ,PRIMARY_IN)VALUES	(	33662	,	296834	,	20329	,	N'BIC'	,	GETDATE()	,NULL	,	GETDATE()	,	N'INC0250135'	,	20	,'Y')
INSERT dbo.LENDER_PAYEE_CODE_MATCH ( LENDER_PAYEE_CODE_FILE_ID ,REMITTANCE_ADDR_ID ,BIC_ID ,REMITTANCE_TYPE_CD ,CREATE_DT ,PURGE_DT ,UPDATE_DT ,UPDATE_USER_TX ,LOCK_ID ,PRIMARY_IN)VALUES	(	33663	,	296833	,	20329	,	N'BIC'	,	GETDATE()	,NULL	,	GETDATE()	,	N'INC0250135'	,	21	,'Y')
INSERT dbo.LENDER_PAYEE_CODE_MATCH ( LENDER_PAYEE_CODE_FILE_ID ,REMITTANCE_ADDR_ID ,BIC_ID ,REMITTANCE_TYPE_CD ,CREATE_DT ,PURGE_DT ,UPDATE_DT ,UPDATE_USER_TX ,LOCK_ID ,PRIMARY_IN)VALUES	(	33715	,	295043	,	20320	,	N'BIC'	,	GETDATE()	,NULL	,	GETDATE()	,	N'INC0250135'	,	22	,'Y')
INSERT dbo.LENDER_PAYEE_CODE_MATCH ( LENDER_PAYEE_CODE_FILE_ID ,REMITTANCE_ADDR_ID ,BIC_ID ,REMITTANCE_TYPE_CD ,CREATE_DT ,PURGE_DT ,UPDATE_DT ,UPDATE_USER_TX ,LOCK_ID ,PRIMARY_IN)VALUES	(	33798	,	293843	,	20313	,	N'BIC'	,	GETDATE()	,NULL	,	GETDATE()	,	N'INC0250135'	,	23	,'Y')














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
VALUES  ( 32961 ,
          24705 ,
          12029 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          2 ,
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
VALUES  ( 32960 ,
          18235 ,
          14397 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          3 ,
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
VALUES  ( 32959 ,
          18238 ,
          14410 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          4 ,
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
VALUES  ( 32958 ,
          153578 ,
          13433 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          5 ,
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
VALUES  ( 32957 ,
          146563 ,
          14416 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          6 ,
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
VALUES  ( 32956 ,
          180781 ,
          15269 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          7 ,
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
VALUES  ( 32955 ,
          146604 ,
          14432 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          8 ,
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
VALUES  ( 32954 ,
          209881 ,
          12076 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          9 ,
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
VALUES  ( 32953 ,
          153576 ,
          15797 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          10 ,
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
VALUES  ( 32952 ,
          232399 ,
          20052 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          11 ,
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
VALUES  ( 32951 ,
          8645 ,
          12111 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          12 ,
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
VALUES  ( 32950 ,
          146652 ,
          12112 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          13 ,
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
VALUES  ( 32949 ,
          27237 ,
          12131 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          14 ,
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
VALUES  ( 32948 ,
          8665 ,
          12137 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          15 ,
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
VALUES  ( 32947 ,
          9855 ,
          14477 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          16 ,
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
VALUES  ( 32946 ,
          175565 ,
          14969 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          17 ,
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
VALUES  ( 32945 ,
          10130 ,
          12147 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          18 ,
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
VALUES  ( 32944 ,
          118700 ,
          15336 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          19 ,
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
VALUES  ( 32943 ,
          9873 ,
          14498 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          20 ,
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
VALUES  ( 32942 ,
          284445 ,
          16039 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          21 ,
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
VALUES  ( 32941 ,
          9561 ,
          13666 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          22 ,
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
VALUES  ( 32940 ,
          212558 ,
          16083 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          23 ,
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
VALUES  ( 32939 ,
          153297 ,
          15792 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          24 ,
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
VALUES  ( 32938 ,
          210939 ,
          14883 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          25 ,
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
VALUES  ( 32937 ,
          9182 ,
          12784 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          26 ,
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
VALUES  ( 32936 ,
          265911 ,
          14949 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          27 ,
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
VALUES  ( 32935 ,
          10027 ,
          14873 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          28 ,
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
VALUES  ( 32934 ,
          18267 ,
          14547 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          29 ,
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
VALUES  ( 32933 ,
          24497 ,
          15157 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          30 ,
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
VALUES  ( 32932 ,
          227574 ,
          12211 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          31 ,
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
VALUES  ( 32931 ,
          175489 ,
          14564 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          32 ,
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
VALUES  ( 32930 ,
          24553 ,
          14565 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          33 ,
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
VALUES  ( 32929 ,
          147200 ,
          15238 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          34 ,
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
VALUES  ( 32928 ,
          37868 ,
          12854 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          35 ,
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
VALUES  ( 32927 ,
          18281 ,
          15078 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          36 ,
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
VALUES  ( 32926 ,
          147233 ,
          14577 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          37 ,
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
VALUES  ( 32925 ,
          9477 ,
          13442 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          38 ,
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
VALUES  ( 32924 ,
          9593 ,
          13803 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          39 ,
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
VALUES  ( 32923 ,
          282813 ,
          20287 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          40 ,
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
VALUES  ( 32922 ,
          113738 ,
          15015 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          41 ,
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
VALUES  ( 32921 ,
          123067 ,
          14611 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          42 ,
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
VALUES  ( 32920 ,
          187554 ,
          18258 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          43 ,
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
VALUES  ( 32919 ,
          281644 ,
          12357 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          44 ,
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
VALUES  ( 32918 ,
          267656 ,
          20077 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          45 ,
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
VALUES  ( 32917 ,
          232397 ,
          20051 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          46 ,
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
VALUES  ( 32916 ,
          9919 ,
          14624 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          47 ,
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
VALUES  ( 32915 ,
          10072 ,
          15016 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          48 ,
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
VALUES  ( 32914 ,
          147477 ,
          15454 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          49 ,
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
VALUES  ( 32913 ,
          188498 ,
          14653 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          50 ,
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
VALUES  ( 32912 ,
          147391 ,
          13114 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          51 ,
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
VALUES  ( 32911 ,
          170464 ,
          16436 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          52 ,
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
VALUES  ( 32910 ,
          39605 ,
          14657 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          53 ,
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
VALUES  ( 32909 ,
          23847 ,
          14981 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          54 ,
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
VALUES  ( 32908 ,
          40173 ,
          13439 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          55 ,
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
VALUES  ( 32907 ,
          12875 ,
          15123 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          56 ,
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
VALUES  ( 32906 ,
          9928 ,
          14677 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          57 ,
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
VALUES  ( 32905 ,
          9683 ,
          14119 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          58 ,
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
VALUES  ( 32904 ,
          147457 ,
          16474 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          59 ,
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
VALUES  ( 32903 ,
          9002 ,
          12503 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          60 ,
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
VALUES  ( 32902 ,
          175115 ,
          15103 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          61 ,
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
VALUES  ( 32901 ,
          175415 ,
          13112 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          62 ,
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
VALUES  ( 32900 ,
          39760 ,
          15245 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          63 ,
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
VALUES  ( 32899 ,
          9021 ,
          12570 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          64 ,
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
VALUES  ( 32898 ,
          23814 ,
          13071 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          65 ,
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
VALUES  ( 32897 ,
          24765 ,
          13071 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          66 ,
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
VALUES  ( 32896 ,
          147509 ,
          13527 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          67 ,
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
VALUES  ( 32895 ,
          147515 ,
          12603 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          68 ,
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
VALUES  ( 32894 ,
          9657 ,
          14012 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          69 ,
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
VALUES  ( 32893 ,
          178063 ,
          14771 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          70 ,
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
VALUES  ( 32892 ,
          9953 ,
          14786 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          71 ,
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
VALUES  ( 32891 ,
          114764 ,
          13486 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          72 ,
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
VALUES  ( 32890 ,
          175225 ,
          16556 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          73 ,
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
VALUES  ( 32889 ,
          141459 ,
          13655 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          74 ,
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
VALUES  ( 32888 ,
          9333 ,
          13087 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          75 ,
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
VALUES  ( 32887 ,
          27388 ,
          15235 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          76 ,
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
VALUES  ( 32886 ,
          149507 ,
          15508 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          77 ,
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
VALUES  ( 32885 ,
          114640 ,
          13957 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          78 ,
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
VALUES  ( 32884 ,
          147033 ,
          13304 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          79 ,
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
VALUES  ( 32883 ,
          9522 ,
          13624 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          80 ,
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
VALUES  ( 32882 ,
          9288 ,
          13023 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          81 ,
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
VALUES  ( 32881 ,
          39004 ,
          12723 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          82 ,
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
VALUES  ( 32880 ,
          37811 ,
          12723 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          83 ,
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
VALUES  ( 32879 ,
          296223 ,
          20322 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          84 ,
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
VALUES  ( 32878 ,
          146127 ,
          12770 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          85 ,
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
VALUES  ( 32877 ,
          146133 ,
          13037 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          86 ,
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
VALUES  ( 32876 ,
          114395 ,
          12768 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          87 ,
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
VALUES  ( 32875 ,
          146494 ,
          13814 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          88 ,
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
VALUES  ( 1965 ,
          24705 ,
          12029 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          2 ,
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
VALUES  ( 2012 ,
          18235 ,
          14397 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          3 ,
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
VALUES  ( 2093 ,
          18238 ,
          14410 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          4 ,
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
VALUES  ( 2108 ,
          153578 ,
          13433 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          5 ,
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
VALUES  ( 2137 ,
          146563 ,
          14416 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          6 ,
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
VALUES  ( 2169 ,
          180781 ,
          15269 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          7 ,
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
VALUES  ( 2329 ,
          146604 ,
          14432 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          8 ,
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
VALUES  ( 2344 ,
          209881 ,
          12076 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          9 ,
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
VALUES  ( 2411 ,
          153576 ,
          15797 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          10 ,
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
VALUES  ( 2414 ,
          232399 ,
          20052 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          11 ,
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
VALUES  ( 2474 ,
          8645 ,
          12111 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          12 ,
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
VALUES  ( 2479 ,
          146652 ,
          12112 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          13 ,
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
VALUES  ( 2587 ,
          27237 ,
          12131 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          14 ,
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
VALUES  ( 2620 ,
          8665 ,
          12137 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          15 ,
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
VALUES  ( 2636 ,
          9855 ,
          14477 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          16 ,
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
VALUES  ( 2652 ,
          175565 ,
          14969 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          17 ,
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
VALUES  ( 2684 ,
          10130 ,
          12147 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          18 ,
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
VALUES  ( 2782 ,
          118700 ,
          15336 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          19 ,
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
VALUES  ( 2912 ,
          9873 ,
          14498 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          20 ,
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
VALUES  ( 2924 ,
          284445 ,
          16039 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          21 ,
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
VALUES  ( 3155 ,
          9561 ,
          13666 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          22 ,
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
VALUES  ( 3197 ,
          212558 ,
          16083 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          23 ,
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
VALUES  ( 3199 ,
          153297 ,
          15792 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          24 ,
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
VALUES  ( 3218 ,
          210939 ,
          14883 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          25 ,
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
VALUES  ( 3225 ,
          9182 ,
          12784 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          26 ,
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
VALUES  ( 3240 ,
          265911 ,
          14949 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          27 ,
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
VALUES  ( 3243 ,
          10027 ,
          14873 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          28 ,
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
VALUES  ( 3246 ,
          18267 ,
          14547 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          29 ,
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
VALUES  ( 3250 ,
          24497 ,
          15157 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          30 ,
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
VALUES  ( 3287 ,
          227574 ,
          12211 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          31 ,
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
VALUES  ( 3365 ,
          175489 ,
          14564 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          32 ,
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
VALUES  ( 3370 ,
          24553 ,
          14565 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          33 ,
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
VALUES  ( 3372 ,
          147200 ,
          15238 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          34 ,
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
VALUES  ( 3403 ,
          37868 ,
          12854 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          35 ,
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
VALUES  ( 3516 ,
          18281 ,
          15078 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          36 ,
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
VALUES  ( 3554 ,
          147233 ,
          14577 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          37 ,
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
VALUES  ( 3691 ,
          9477 ,
          13442 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          38 ,
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
VALUES  ( 3717 ,
          9593 ,
          13803 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          39 ,
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
VALUES  ( 3761 ,
          282813 ,
          20287 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          40 ,
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
VALUES  ( 3766 ,
          113738 ,
          15015 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          41 ,
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
VALUES  ( 3784 ,
          123067 ,
          14611 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          42 ,
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
VALUES  ( 3859 ,
          187554 ,
          18258 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          43 ,
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
VALUES  ( 3934 ,
          281644 ,
          12357 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          44 ,
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
VALUES  ( 3966 ,
          267656 ,
          20077 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          45 ,
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
VALUES  ( 3973 ,
          232397 ,
          20051 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          46 ,
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
VALUES  ( 3999 ,
          9919 ,
          14624 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          47 ,
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
VALUES  ( 4030 ,
          10072 ,
          15016 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          48 ,
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
VALUES  ( 4175 ,
          147477 ,
          15454 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          49 ,
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
VALUES  ( 4244 ,
          188498 ,
          14653 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          50 ,
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
VALUES  ( 4246 ,
          147391 ,
          13114 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          51 ,
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
VALUES  ( 4255 ,
          170464 ,
          16436 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          52 ,
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
VALUES  ( 4262 ,
          39605 ,
          14657 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          53 ,
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
VALUES  ( 4318 ,
          23847 ,
          14981 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          54 ,
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
VALUES  ( 4335 ,
          40173 ,
          13439 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          55 ,
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
VALUES  ( 4474 ,
          12875 ,
          15123 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          56 ,
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
VALUES  ( 4483 ,
          9928 ,
          14677 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          57 ,
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
VALUES  ( 4484 ,
          9683 ,
          14119 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          58 ,
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
VALUES  ( 4607 ,
          147457 ,
          16474 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          59 ,
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
VALUES  ( 4715 ,
          9002 ,
          12503 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          60 ,
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
VALUES  ( 4889 ,
          175115 ,
          15103 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          61 ,
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
VALUES  ( 4890 ,
          175415 ,
          13112 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          62 ,
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
VALUES  ( 4899 ,
          39760 ,
          15245 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          63 ,
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
VALUES  ( 4968 ,
          9021 ,
          12570 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          64 ,
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
VALUES  ( 4990 ,
          23814 ,
          13071 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          65 ,
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
VALUES  ( 4995 ,
          24765 ,
          13071 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          66 ,
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
VALUES  ( 5026 ,
          147509 ,
          13527 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          67 ,
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
VALUES  ( 5084 ,
          147515 ,
          12603 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          68 ,
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
VALUES  ( 5136 ,
          9657 ,
          14012 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          69 ,
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
VALUES  ( 5222 ,
          178063 ,
          14771 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          70 ,
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
VALUES  ( 5421 ,
          9953 ,
          14786 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          71 ,
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
VALUES  ( 5438 ,
          114764 ,
          13486 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          72 ,
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
VALUES  ( 5448 ,
          175225 ,
          16556 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          73 ,
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
VALUES  ( 5486 ,
          141459 ,
          13655 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          74 ,
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
VALUES  ( 5610 ,
          9333 ,
          13087 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          75 ,
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
VALUES  ( 5636 ,
          27388 ,
          15235 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          76 ,
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
VALUES  ( 5785 ,
          149507 ,
          15508 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          77 ,
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
VALUES  ( 6280 ,
          114640 ,
          13957 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          78 ,
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
VALUES  ( 6310 ,
          147033 ,
          13304 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          79 ,
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
VALUES  ( 6317 ,
          9522 ,
          13624 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          80 ,
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
VALUES  ( 6496 ,
          9288 ,
          13023 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          81 ,
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
VALUES  ( 6505 ,
          39004 ,
          12723 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          82 ,
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
VALUES  ( 6511 ,
          37811 ,
          12723 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          83 ,
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
VALUES  ( 6591 ,
          296223 ,
          20322 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          84 ,
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
VALUES  ( 6665 ,
          146127 ,
          12770 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          85 ,
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
VALUES  ( 6670 ,
          146133 ,
          13037 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          86 ,
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
VALUES  ( 6673 ,
          114395 ,
          12768 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          87 ,
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
VALUES  ( 6695 ,
          146494 ,
          13814 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          88 ,
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
VALUES  ( 32962 ,
          149494 ,
          15495 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 32963 ,
          206298 ,
          15798 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 32964 ,
          175328 ,
          16575 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 32965 ,
          149496 ,
          15497 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 32966 ,
          187606 ,
          18310 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 32967 ,
          149509 ,
          14326 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 32968 ,
          149508 ,
          14325 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 32969 ,
          175332 ,
          16576 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 32970 ,
          175329 ,
          16576 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 32971 ,
          273408 ,
          20241 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 32972 ,
          149504 ,
          15505 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 32973 ,
          149512 ,
          15511 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 32974 ,
          261508 ,
          15511 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 32975 ,
          187607 ,
          18311 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 32976 ,
          149527 ,
          15525 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 32977 ,
          213095 ,
          15524 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 32978 ,
          156184 ,
          15524 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 32979 ,
          154326 ,
          15806 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 32980 ,
          149532 ,
          15531 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 32981 ,
          253441 ,
          15531 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 32982 ,
          187608 ,
          18312 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 32983 ,
          218092 ,
          15810 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 32984 ,
          223227 ,
          11883 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 32985 ,
          221932 ,
          15819 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 32986 ,
          211620 ,
          19985 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 32987 ,
          187609 ,
          18313 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 32988 ,
          187610 ,
          18314 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 32989 ,
          149537 ,
          11907 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 32990 ,
          149539 ,
          15537 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 32991 ,
          187611 ,
          18315 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 32992 ,
          149541 ,
          15539 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 32993 ,
          218487 ,
          15831 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 32994 ,
          226372 ,
          14335 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 32995 ,
          226372 ,
          14337 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 32996 ,
          149543 ,
          15541 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 32997 ,
          149545 ,
          15543 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 32998 ,
          261856 ,
          20184 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 32999 ,
          149550 ,
          16689 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33000 ,
          220958 ,
          16689 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33001 ,
          149550 ,
          15544 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33002 ,
          149546 ,
          15544 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33003 ,
          220958 ,
          15544 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33004 ,
          149550 ,
          15546 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33005 ,
          149547 ,
          15546 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33006 ,
          220958 ,
          15546 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33007 ,
          149550 ,
          15547 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33008 ,
          149548 ,
          15547 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33009 ,
          220958 ,
          15547 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33010 ,
          149550 ,
          15559 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33011 ,
          149561 ,
          15559 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33012 ,
          220958 ,
          15559 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33013 ,
          149550 ,
          18316 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33014 ,
          187612 ,
          18316 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33015 ,
          220958 ,
          18316 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33016 ,
          149550 ,
          15549 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33017 ,
          220958 ,
          15549 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33018 ,
          149550 ,
          15550 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33019 ,
          149552 ,
          15550 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33020 ,
          220958 ,
          15550 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33021 ,
          149550 ,
          15551 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33022 ,
          149553 ,
          15551 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33023 ,
          220958 ,
          15551 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33024 ,
          149550 ,
          15553 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33025 ,
          149555 ,
          15553 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33026 ,
          220958 ,
          15553 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33027 ,
          149550 ,
          15554 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33028 ,
          149556 ,
          15554 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33029 ,
          220958 ,
          15554 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33030 ,
          149550 ,
          15556 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33031 ,
          149558 ,
          15556 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33032 ,
          220958 ,
          15556 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33033 ,
          149562 ,
          15560 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33034 ,
          171231 ,
          15837 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33035 ,
          149563 ,
          15561 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33036 ,
          149573 ,
          11944 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33037 ,
          187619 ,
          18323 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33038 ,
          232180 ,
          18317 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33039 ,
          287533 ,
          18317 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33040 ,
          222113 ,
          18317 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33041 ,
          187613 ,
          18317 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33042 ,
          257753 ,
          18317 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33043 ,
          221324 ,
          18317 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33044 ,
          170228 ,
          15840 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33045 ,
          264155 ,
          20190 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33046 ,
          228763 ,
          15843 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33047 ,
          226413 ,
          15843 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33048 ,
          228762 ,
          15843 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33049 ,
          229657 ,
          15843 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33050 ,
          241362 ,
          15568 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33051 ,
          149571 ,
          15568 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33052 ,
          149569 ,
          15566 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33053 ,
          226414 ,
          15566 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33054 ,
          149569 ,
          11935 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33055 ,
          226417 ,
          11935 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33056 ,
          226414 ,
          11935 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33057 ,
          223231 ,
          15852 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33058 ,
          276856 ,
          16533 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33059 ,
          187616 ,
          18320 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33060 ,
          154335 ,
          15908 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33061 ,
          259834 ,
          12828 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33062 ,
          245087 ,
          20089 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33063 ,
          149580 ,
          15576 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33064 ,
          149570 ,
          15567 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33065 ,
          149576 ,
          15572 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33066 ,
          149577 ,
          15573 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33067 ,
          285436 ,
          15573 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33068 ,
          287169 ,
          20298 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33069 ,
          295042 ,
          20319 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33070 ,
          149582 ,
          11964 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33071 ,
          149583 ,
          15578 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33072 ,
          187617 ,
          18321 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33073 ,
          226434 ,
          18321 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33074 ,
          218489 ,
          15855 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33075 ,
          232168 ,
          15855 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33076 ,
          187618 ,
          18322 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33077 ,
          287982 ,
          16611 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33078 ,
          257617 ,
          16611 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33079 ,
          217429 ,
          15865 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33080 ,
          260509 ,
          15866 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33081 ,
          139070 ,
          16598 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33082 ,
          149593 ,
          15588 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33083 ,
          149594 ,
          15589 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33084 ,
          222412 ,
          13298 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33085 ,
          149658 ,
          15646 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33086 ,
          149657 ,
          15645 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33087 ,
          221195 ,
          15890 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33088 ,
          217088 ,
          15891 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33089 ,
          187620 ,
          18324 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33090 ,
          149660 ,
          15648 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33091 ,
          149663 ,
          15651 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33092 ,
          149661 ,
          15649 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33093 ,
          149662 ,
          15650 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33094 ,
          252079 ,
          15896 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33095 ,
          223712 ,
          15901 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33096 ,
          217904 ,
          15901 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33097 ,
          187621 ,
          18325 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33098 ,
          296099 ,
          15902 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33099 ,
          149501 ,
          15502 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33100 ,
          233504 ,
          15516 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33101 ,
          149517 ,
          15516 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33102 ,
          259783 ,
          20168 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33103 ,
          149519 ,
          15518 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33104 ,
          232176 ,
          15518 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33105 ,
          226234 ,
          15520 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33106 ,
          149521 ,
          15520 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33107 ,
          226465 ,
          18326 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33108 ,
          187622 ,
          18326 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33109 ,
          226470 ,
          18326 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33110 ,
          149667 ,
          15655 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33111 ,
          149668 ,
          15656 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33112 ,
          149669 ,
          15657 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33113 ,
          187623 ,
          18327 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33114 ,
          149670 ,
          15658 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33115 ,
          187624 ,
          18328 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33116 ,
          286786 ,
          15915 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33117 ,
          221773 ,
          15916 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33118 ,
          210582 ,
          15917 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33119 ,
          285195 ,
          20294 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33120 ,
          187625 ,
          18329 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33121 ,
          293175 ,
          20311 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33122 ,
          287642 ,
          20302 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33123 ,
          187626 ,
          18330 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33124 ,
          221340 ,
          15925 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33125 ,
          220930 ,
          15926 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33126 ,
          187627 ,
          18331 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33127 ,
          206594 ,
          13485 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33128 ,
          203908 ,
          13485 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33129 ,
          231600 ,
          20047 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33130 ,
          223256 ,
          15659 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33131 ,
          149671 ,
          15659 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33132 ,
          149716 ,
          15702 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33133 ,
          187628 ,
          18332 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33134 ,
          229295 ,
          12034 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33135 ,
          237126 ,
          15947 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33136 ,
          246219 ,
          20093 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33137 ,
          149672 ,
          15660 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33138 ,
          187629 ,
          18333 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33139 ,
          223261 ,
          15951 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33140 ,
          223262 ,
          12046 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33141 ,
          187630 ,
          18334 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33142 ,
          223263 ,
          15955 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33143 ,
          218797 ,
          15956 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33144 ,
          239362 ,
          15956 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33145 ,
          149647 ,
          15636 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33146 ,
          223763 ,
          12049 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33147 ,
          202998 ,
          15959 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33148 ,
          187631 ,
          18335 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33149 ,
          9215 ,
          15963 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33150 ,
          149674 ,
          15662 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33151 ,
          226729 ,
          15965 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33152 ,
          149677 ,
          15665 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33153 ,
          149678 ,
          15666 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33154 ,
          187538 ,
          18242 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33155 ,
          149679 ,
          15667 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33156 ,
          149680 ,
          15668 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33157 ,
          149682 ,
          15670 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33158 ,
          149681 ,
          15669 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33159 ,
          187632 ,
          15672 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33160 ,
          187632 ,
          15671 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33161 ,
          187632 ,
          18336 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33162 ,
          187633 ,
          18337 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33163 ,
          149686 ,
          15674 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33164 ,
          227741 ,
          14426 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33165 ,
          261158 ,
          20174 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33166 ,
          187634 ,
          18338 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33167 ,
          187635 ,
          18339 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33168 ,
          149685 ,
          15673 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33169 ,
          187636 ,
          18340 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33170 ,
          223954 ,
          20022 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33171 ,
          149726 ,
          15708 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33172 ,
          253237 ,
          15982 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33173 ,
          245242 ,
          15982 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33174 ,
          171239 ,
          15983 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33175 ,
          149691 ,
          15679 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33176 ,
          187174 ,
          18239 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33177 ,
          187637 ,
          18341 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33178 ,
          273406 ,
          20240 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33179 ,
          238769 ,
          15987 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33180 ,
          187638 ,
          18342 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33181 ,
          187639 ,
          18343 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33182 ,
          235574 ,
          20081 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33183 ,
          228883 ,
          20036 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33184 ,
          222028 ,
          13821 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33185 ,
          187640 ,
          18344 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33186 ,
          149693 ,
          15681 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33187 ,
          257755 ,
          20129 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33188 ,
          187641 ,
          18345 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33189 ,
          288956 ,
          20304 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33190 ,
          223712 ,
          16005 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33191 ,
          220433 ,
          16011 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33192 ,
          292765 ,
          20309 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33193 ,
          202742 ,
          16013 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33194 ,
          267840 ,
          20203 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33195 ,
          261226 ,
          18346 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33196 ,
          187642 ,
          18346 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33197 ,
          187643 ,
          18347 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33198 ,
          149696 ,
          12129 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33199 ,
          149697 ,
          15684 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33200 ,
          149695 ,
          15683 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33201 ,
          149699 ,
          15686 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33202 ,
          149700 ,
          15687 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33203 ,
          149698 ,
          15685 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33204 ,
          212652 ,
          15685 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33205 ,
          187644 ,
          18348 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33206 ,
          149701 ,
          15688 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33207 ,
          149702 ,
          15689 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33208 ,
          149703 ,
          15690 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33209 ,
          149704 ,
          15691 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33210 ,
          149705 ,
          15692 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33211 ,
          149706 ,
          15693 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33212 ,
          220434 ,
          16020 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33213 ,
          220434 ,
          15697 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33214 ,
          220434 ,
          15695 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33215 ,
          220434 ,
          15698 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33216 ,
          223647 ,
          16021 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33217 ,
          223386 ,
          13108 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33218 ,
          229654 ,
          13108 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33219 ,
          259060 ,
          20165 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33220 ,
          149715 ,
          15701 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33221 ,
          149720 ,
          15706 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33222 ,
          187647 ,
          18351 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33223 ,
          191793 ,
          18404 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33224 ,
          224312 ,
          20023 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33225 ,
          288847 ,
          20243 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33226 ,
          149725 ,
          15707 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33227 ,
          224309 ,
          12155 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33228 ,
          149727 ,
          15709 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33229 ,
          184181 ,
          15710 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33230 ,
          149728 ,
          15710 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33231 ,
          149729 ,
          15711 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33232 ,
          281778 ,
          15712 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33233 ,
          149730 ,
          15712 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33234 ,
          149731 ,
          15713 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33235 ,
          149732 ,
          15714 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33236 ,
          187648 ,
          18352 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33237 ,
          232280 ,
          18352 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33238 ,
          226372 ,
          13874 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33239 ,
          270814 ,
          13874 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33240 ,
          196974 ,
          18407 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33241 ,
          225220 ,
          16031 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33242 ,
          187655 ,
          18359 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33243 ,
          187649 ,
          18353 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33244 ,
          187653 ,
          18357 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33245 ,
          187654 ,
          18358 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33246 ,
          271174 ,
          20232 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33247 ,
          187650 ,
          18354 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33248 ,
          232488 ,
          18354 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33249 ,
          232573 ,
          18354 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33250 ,
          284445 ,
          16039 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33251 ,
          218807 ,
          16039 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33252 ,
          221584 ,
          16041 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33253 ,
          149753 ,
          15734 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33254 ,
          187651 ,
          18355 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33255 ,
          187652 ,
          18356 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33256 ,
          237906 ,
          18356 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33257 ,
          217029 ,
          19996 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33258 ,
          149752 ,
          15733 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33259 ,
          226967 ,
          16049 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33260 ,
          226959 ,
          16047 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33261 ,
          9215 ,
          16050 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33262 ,
          187656 ,
          18360 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33263 ,
          187657 ,
          18361 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33264 ,
          307472 ,
          18361 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33265 ,
          232010 ,
          18361 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33266 ,
          227259 ,
          16062 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33267 ,
          230891 ,
          15775 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33268 ,
          218809 ,
          16064 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33269 ,
          270476 ,
          16065 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33270 ,
          232242 ,
          18362 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33271 ,
          187658 ,
          18362 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33272 ,
          288784 ,
          18362 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33273 ,
          149756 ,
          15737 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33274 ,
          149755 ,
          15736 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33275 ,
          149757 ,
          15738 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33276 ,
          221215 ,
          15740 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33277 ,
          187659 ,
          18363 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33278 ,
          187660 ,
          18364 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33279 ,
          227990 ,
          16069 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33280 ,
          175391 ,
          16070 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33281 ,
          227729 ,
          16070 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33282 ,
          247477 ,
          20095 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33283 ,
          253483 ,
          16072 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33284 ,
          226508 ,
          16072 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33285 ,
          187661 ,
          18365 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33286 ,
          229084 ,
          16081 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33287 ,
          149733 ,
          15715 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33288 ,
          149734 ,
          15716 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33289 ,
          187663 ,
          18367 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33290 ,
          256631 ,
          20127 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33291 ,
          262238 ,
          20185 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33292 ,
          227557 ,
          15744 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33293 ,
          149763 ,
          15744 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33294 ,
          230992 ,
          18369 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33295 ,
          187665 ,
          18369 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33296 ,
          227557 ,
          15745 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33297 ,
          149763 ,
          15745 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33298 ,
          227557 ,
          16631 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33299 ,
          149763 ,
          16631 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33300 ,
          227557 ,
          15746 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33301 ,
          149763 ,
          15746 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33302 ,
          284638 ,
          12180 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33303 ,
          149766 ,
          15747 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33304 ,
          187664 ,
          18368 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33305 ,
          227264 ,
          18368 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33306 ,
          247778 ,
          20097 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33307 ,
          221775 ,
          16085 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33308 ,
          227559 ,
          16086 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33309 ,
          149767 ,
          15748 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33310 ,
          254077 ,
          16091 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33311 ,
          187537 ,
          18241 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33312 ,
          221389 ,
          16095 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33313 ,
          149735 ,
          15717 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33314 ,
          149736 ,
          15718 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33315 ,
          267290 ,
          18240 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33316 ,
          187536 ,
          18240 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33317 ,
          149768 ,
          15749 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33318 ,
          227574 ,
          12211 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33319 ,
          251988 ,
          20117 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33320 ,
          149896 ,
          15776 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33321 ,
          259826 ,
          16291 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33322 ,
          227575 ,
          16295 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33323 ,
          229702 ,
          14010 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33324 ,
          147179 ,
          14010 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33325 ,
          227576 ,
          14010 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33326 ,
          231812 ,
          16299 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33327 ,
          149939 ,
          14562 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33328 ,
          292927 ,
          14562 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33329 ,
          245313 ,
          20091 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33330 ,
          149771 ,
          15752 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33331 ,
          149772 ,
          15753 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33332 ,
          187539 ,
          18243 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33333 ,
          149604 ,
          15599 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33334 ,
          149774 ,
          15755 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33335 ,
          208151 ,
          16305 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33336 ,
          187540 ,
          18244 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33337 ,
          231057 ,
          16306 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33338 ,
          227587 ,
          16307 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33339 ,
          187541 ,
          18245 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33340 ,
          212871 ,
          19990 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33341 ,
          227741 ,
          16312 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33342 ,
          149776 ,
          18247 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33343 ,
          279568 ,
          15758 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33344 ,
          149776 ,
          15756 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33345 ,
          149783 ,
          12266 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33346 ,
          149948 ,
          12267 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33347 ,
          227860 ,
          18248 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33348 ,
          187544 ,
          18248 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33349 ,
          149949 ,
          12265 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33350 ,
          208413 ,
          12265 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33351 ,
          177546 ,
          12265 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33352 ,
          149787 ,
          12272 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33353 ,
          149782 ,
          12269 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33354 ,
          177546 ,
          12269 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33355 ,
          149606 ,
          12271 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33356 ,
          149786 ,
          12270 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33357 ,
          149788 ,
          12268 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33358 ,
          187545 ,
          18249 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33359 ,
          169881 ,
          16503 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33360 ,
          262236 ,
          16319 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33361 ,
          293863 ,
          20315 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33362 ,
          187546 ,
          18250 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33363 ,
          149789 ,
          13480 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33364 ,
          149790 ,
          13478 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33365 ,
          149792 ,
          15763 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33366 ,
          149791 ,
          15762 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33367 ,
          227770 ,
          16326 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33368 ,
          170410 ,
          16328 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33369 ,
          187547 ,
          15765 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33370 ,
          187547 ,
          18251 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33371 ,
          286117 ,
          18251 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33372 ,
          187547 ,
          15764 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33373 ,
          187547 ,
          15766 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33374 ,
          187547 ,
          15769 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33375 ,
          187547 ,
          15767 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33376 ,
          149797 ,
          15768 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33377 ,
          149801 ,
          16052 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33378 ,
          149800 ,
          15771 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33379 ,
          149801 ,
          15772 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33380 ,
          216081 ,
          19995 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33381 ,
          149648 ,
          15637 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33382 ,
          139070 ,
          16335 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33383 ,
          272635 ,
          16337 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33384 ,
          228410 ,
          16337 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33385 ,
          154333 ,
          15907 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33386 ,
          229384 ,
          16338 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33387 ,
          229385 ,
          16338 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33388 ,
          227793 ,
          12860 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33389 ,
          184389 ,
          16693 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33390 ,
          175382 ,
          16579 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33391 ,
          224280 ,
          16579 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33392 ,
          220115 ,
          13755 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33393 ,
          239363 ,
          19984 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33394 ,
          210584 ,
          19984 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33395 ,
          149649 ,
          12323 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33396 ,
          205061 ,
          15639 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33397 ,
          279965 ,
          15639 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33398 ,
          149651 ,
          15639 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33399 ,
          222429 ,
          18406 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33400 ,
          193066 ,
          18406 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33401 ,
          269176 ,
          18406 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33402 ,
          277954 ,
          15522 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33403 ,
          149523 ,
          15522 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33404 ,
          187548 ,
          18252 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33405 ,
          187549 ,
          18253 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33406 ,
          287287 ,
          20299 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33407 ,
          237714 ,
          16353 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33408 ,
          274238 ,
          20256 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33409 ,
          149717 ,
          15703 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33410 ,
          149655 ,
          15643 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33411 ,
          187550 ,
          18254 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33412 ,
          149654 ,
          15642 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33413 ,
          269420 ,
          20209 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33414 ,
          232803 ,
          15719 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33415 ,
          149738 ,
          15719 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33416 ,
          234914 ,
          15719 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33417 ,
          221651 ,
          16356 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33418 ,
          187551 ,
          18255 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33419 ,
          267472 ,
          20202 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33420 ,
          187552 ,
          18256 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33421 ,
          231370 ,
          16359 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33422 ,
          293734 ,
          16362 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33423 ,
          221554 ,
          16366 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33424 ,
          149635 ,
          15623 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33425 ,
          175391 ,
          15630 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33426 ,
          218982 ,
          15630 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33427 ,
          227729 ,
          15630 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33428 ,
          149636 ,
          15624 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33429 ,
          175391 ,
          16368 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33430 ,
          252937 ,
          16368 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33431 ,
          218982 ,
          16368 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33432 ,
          227729 ,
          16368 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33433 ,
          187553 ,
          18257 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33434 ,
          228731 ,
          16371 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33435 ,
          187178 ,
          16375 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33436 ,
          227729 ,
          16684 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33437 ,
          187555 ,
          18259 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33438 ,
          217701 ,
          16377 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33439 ,
          149739 ,
          15720 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33440 ,
          149740 ,
          15721 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33441 ,
          259282 ,
          16379 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33442 ,
          8910 ,
          12366 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33443 ,
          8910 ,
          20030 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33444 ,
          241179 ,
          16386 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33445 ,
          149645 ,
          15634 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33446 ,
          240433 ,
          16389 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33447 ,
          147357 ,
          16495 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33448 ,
          227741 ,
          20029 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33449 ,
          212535 ,
          16488 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33450 ,
          187557 ,
          18261 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33451 ,
          281612 ,
          16528 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33452 ,
          149688 ,
          15676 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33453 ,
          124769 ,
          16528 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33454 ,
          124223 ,
          16392 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33455 ,
          9348 ,
          16394 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33456 ,
          228825 ,
          16394 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33457 ,
          149646 ,
          15635 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33458 ,
          149624 ,
          15615 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33459 ,
          149625 ,
          12383 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33460 ,
          230583 ,
          12389 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33461 ,
          259786 ,
          12389 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33462 ,
          149627 ,
          12389 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33463 ,
          149626 ,
          12387 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33464 ,
          149626 ,
          12393 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33465 ,
          149627 ,
          12390 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33466 ,
          149626 ,
          12392 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33467 ,
          175405 ,
          16401 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33468 ,
          175405 ,
          12395 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33469 ,
          228270 ,
          18262 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33470 ,
          187558 ,
          18262 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33471 ,
          149630 ,
          15618 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33472 ,
          149631 ,
          15619 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33473 ,
          9193 ,
          15620 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33474 ,
          263677 ,
          15621 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33475 ,
          9193 ,
          15621 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33476 ,
          292696 ,
          16405 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33477 ,
          228186 ,
          16406 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33478 ,
          192605 ,
          16407 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33479 ,
          230693 ,
          16407 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33480 ,
          147476 ,
          14633 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33481 ,
          187560 ,
          18264 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33482 ,
          23877 ,
          18264 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33483 ,
          187561 ,
          18265 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33484 ,
          220481 ,
          16412 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33485 ,
          225020 ,
          16412 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33486 ,
          239766 ,
          13158 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33487 ,
          187562 ,
          18266 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33488 ,
          35964 ,
          16416 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33489 ,
          213699 ,
          19994 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33490 ,
          149722 ,
          12156 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33491 ,
          149741 ,
          15722 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33492 ,
          253161 ,
          20119 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33493 ,
          187563 ,
          18267 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33494 ,
          187564 ,
          18268 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33495 ,
          292968 ,
          20310 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33496 ,
          149634 ,
          15622 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33497 ,
          8937 ,
          16423 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33498 ,
          227116 ,
          19988 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33499 ,
          210494 ,
          20031 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33500 ,
          149742 ,
          15723 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33501 ,
          187565 ,
          18269 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33502 ,
          187566 ,
          18270 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33503 ,
          170464 ,
          16436 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33504 ,
          187567 ,
          18271 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33505 ,
          227866 ,
          16434 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33506 ,
          149708 ,
          12978 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33507 ,
          187645 ,
          18349 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33508 ,
          8722 ,
          20032 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33509 ,
          149767 ,
          12437 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33510 ,
          222639 ,
          16440 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33511 ,
          216752 ,
          16645 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33512 ,
          8910 ,
          16596 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33513 ,
          260118 ,
          20171 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33514 ,
          170225 ,
          16444 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33515 ,
          223262 ,
          12444 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33516 ,
          9682 ,
          16445 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33517 ,
          187570 ,
          18274 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33518 ,
          149620 ,
          15612 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33519 ,
          149601 ,
          15596 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33520 ,
          149614 ,
          15606 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33521 ,
          8974 ,
          16542 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33522 ,
          218326 ,
          16542 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33523 ,
          149617 ,
          15609 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33524 ,
          149615 ,
          15607 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33525 ,
          226733 ,
          15611 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33526 ,
          175842 ,
          15611 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33527 ,
          149619 ,
          15611 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33528 ,
          218327 ,
          15611 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33529 ,
          218326 ,
          15611 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33530 ,
          175360 ,
          15611 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33531 ,
          149616 ,
          15608 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33532 ,
          218326 ,
          15608 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33533 ,
          175360 ,
          15608 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33534 ,
          175410 ,
          15608 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33535 ,
          149618 ,
          15610 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33536 ,
          187571 ,
          18275 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33537 ,
          149714 ,
          15700 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33538 ,
          237894 ,
          16452 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33539 ,
          182865 ,
          16453 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33540 ,
          207328 ,
          16456 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33541 ,
          187574 ,
          18278 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33542 ,
          187575 ,
          18279 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33543 ,
          149622 ,
          15614 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33544 ,
          266696 ,
          15614 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33545 ,
          270159 ,
          18280 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33546 ,
          218675 ,
          19999 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33547 ,
          218811 ,
          20001 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33548 ,
          187577 ,
          18281 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33549 ,
          187573 ,
          18277 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33550 ,
          234762 ,
          18277 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33551 ,
          147448 ,
          12468 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33552 ,
          149743 ,
          15724 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33553 ,
          229410 ,
          16466 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33554 ,
          8997 ,
          12476 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33555 ,
          187568 ,
          18272 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33556 ,
          187578 ,
          18282 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33557 ,
          187579 ,
          18283 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33558 ,
          187580 ,
          18284 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33559 ,
          9000 ,
          12494 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33560 ,
          149718 ,
          15704 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33561 ,
          225868 ,
          12490 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33562 ,
          257405 ,
          20128 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33563 ,
          149744 ,
          15725 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33564 ,
          187581 ,
          18285 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33565 ,
          197156 ,
          16482 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33566 ,
          187582 ,
          18286 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33567 ,
          234763 ,
          16483 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33568 ,
          220959 ,
          16484 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33569 ,
          187622 ,
          16485 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33570 ,
          149613 ,
          15605 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33571 ,
          296520 ,
          20087 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33572 ,
          244556 ,
          20087 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33573 ,
          187583 ,
          18287 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33574 ,
          287323 ,
          12520 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33575 ,
          178059 ,
          12520 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33576 ,
          232452 ,
          20056 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33577 ,
          149602 ,
          15597 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33578 ,
          187584 ,
          18288 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33579 ,
          187585 ,
          18289 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33580 ,
          149621 ,
          15613 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33581 ,
          187586 ,
          18290 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33582 ,
          245250 ,
          16265 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33583 ,
          187587 ,
          18291 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33584 ,
          291442 ,
          16268 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33585 ,
          170227 ,
          14289 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33586 ,
          292694 ,
          20308 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33587 ,
          224501 ,
          14000 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33588 ,
          231191 ,
          12557 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33589 ,
          222387 ,
          12557 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33590 ,
          241876 ,
          16273 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33591 ,
          170224 ,
          16273 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33592 ,
          244994 ,
          20088 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33593 ,
          18127 ,
          16278 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33594 ,
          187589 ,
          18293 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33595 ,
          228602 ,
          16288 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33596 ,
          149607 ,
          15600 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33597 ,
          287460 ,
          20300 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33598 ,
          149575 ,
          15571 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33599 ,
          221051 ,
          14758 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33600 ,
          187591 ,
          18295 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33601 ,
          149644 ,
          15633 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33602 ,
          187592 ,
          18296 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33603 ,
          237639 ,
          20083 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33604 ,
          269720 ,
          16233 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33605 ,
          268138 ,
          20206 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33606 ,
          220960 ,
          16235 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33607 ,
          191514 ,
          16235 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33608 ,
          250986 ,
          20113 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33609 ,
          262802 ,
          20113 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33610 ,
          260128 ,
          20113 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33611 ,
          275167 ,
          20257 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33612 ,
          245248 ,
          15580 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33613 ,
          231259 ,
          15580 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33614 ,
          149585 ,
          15580 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33615 ,
          261150 ,
          15580 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33616 ,
          246224 ,
          15581 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33617 ,
          149586 ,
          15581 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33618 ,
          246605 ,
          15582 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33619 ,
          149587 ,
          15582 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33620 ,
          288186 ,
          15582 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33621 ,
          250692 ,
          15584 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33622 ,
          149589 ,
          15584 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33623 ,
          149591 ,
          15586 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33624 ,
          253420 ,
          15587 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33625 ,
          149592 ,
          15587 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33626 ,
          229125 ,
          15587 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33627 ,
          260669 ,
          15587 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33628 ,
          219826 ,
          20002 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33629 ,
          228672 ,
          16178 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33630 ,
          149599 ,
          15594 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33631 ,
          149600 ,
          15595 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33632 ,
          149596 ,
          15591 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33633 ,
          149598 ,
          15593 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33634 ,
          239176 ,
          16182 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33635 ,
          10210 ,
          16182 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33636 ,
          149520 ,
          15519 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33637 ,
          9046 ,
          12622 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33638 ,
          263031 ,
          12622 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33639 ,
          149524 ,
          12621 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33640 ,
          187597 ,
          18301 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33641 ,
          232598 ,
          16186 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33642 ,
          220910 ,
          16186 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33643 ,
          149528 ,
          15526 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33644 ,
          210503 ,
          19983 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33645 ,
          187599 ,
          18303 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33646 ,
          270201 ,
          20210 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33647 ,
          149530 ,
          15528 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33648 ,
          220576 ,
          15528 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33649 ,
          149525 ,
          15523 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33650 ,
          149529 ,
          15527 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33651 ,
          187599 ,
          15530 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33652 ,
          198161 ,
          15530 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33653 ,
          149533 ,
          15532 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33654 ,
          149534 ,
          15533 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33655 ,
          227860 ,
          12629 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33656 ,
          187600 ,
          18304 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33657 ,
          149536 ,
          20034 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33658 ,
          149536 ,
          15535 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33659 ,
          149536 ,
          20035 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33660 ,
          187601 ,
          18305 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33661 ,
          149745 ,
          15726 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33662 ,
          296834 ,
          20329 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33663 ,
          296833 ,
          20329 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33664 ,
          179113 ,
          12157 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33665 ,
          187594 ,
          18298 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33666 ,
          187593 ,
          18297 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33667 ,
          149901 ,
          12889 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33668 ,
          149900 ,
          15777 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33669 ,
          229941 ,
          16199 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33670 ,
          187595 ,
          18299 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33671 ,
          235412 ,
          13414 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33672 ,
          149579 ,
          15575 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33673 ,
          266698 ,
          20198 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33674 ,
          187602 ,
          18306 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33675 ,
          149540 ,
          15538 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33676 ,
          149542 ,
          15540 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33677 ,
          149544 ,
          15542 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33678 ,
          149549 ,
          15548 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33679 ,
          9215 ,
          16209 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33680 ,
          187603 ,
          18307 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33681 ,
          229980 ,
          16161 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33682 ,
          149557 ,
          15555 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33683 ,
          149554 ,
          15552 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33684 ,
          149560 ,
          15558 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33685 ,
          187604 ,
          18308 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33686 ,
          149551 ,
          12818 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33687 ,
          187605 ,
          18309 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33688 ,
          218192 ,
          18309 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33689 ,
          189325 ,
          18309 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33690 ,
          175350 ,
          15563 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33691 ,
          175368 ,
          15563 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33692 ,
          175366 ,
          15563 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33693 ,
          175423 ,
          15563 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33694 ,
          175335 ,
          15563 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33695 ,
          175361 ,
          15563 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33696 ,
          178082 ,
          15563 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33697 ,
          177223 ,
          15563 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33698 ,
          256544 ,
          15563 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33699 ,
          175531 ,
          15563 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33700 ,
          218192 ,
          15564 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33701 ,
          149566 ,
          15564 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33702 ,
          189335 ,
          15564 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33703 ,
          218192 ,
          15565 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33704 ,
          149568 ,
          15565 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33705 ,
          256549 ,
          20126 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33706 ,
          184387 ,
          15569 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33707 ,
          218192 ,
          15569 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33708 ,
          149572 ,
          15569 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33709 ,
          221046 ,
          16216 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33710 ,
          156228 ,
          16101 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33711 ,
          260133 ,
          20172 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33712 ,
          18306 ,
          18387 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33713 ,
          187683 ,
          18387 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33714 ,
          239635 ,
          12674 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33715 ,
          295043 ,
          20320 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33716 ,
          170226 ,
          16156 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33717 ,
          149801 ,
          16156 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33718 ,
          187684 ,
          18388 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33719 ,
          187684 ,
          16677 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33720 ,
          149719 ,
          15705 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33721 ,
          149746 ,
          15727 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33722 ,
          149724 ,
          12151 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33723 ,
          149747 ,
          15728 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33724 ,
          187667 ,
          18371 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33725 ,
          18306 ,
          20037 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33726 ,
          149769 ,
          15750 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33727 ,
          217904 ,
          12534 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33728 ,
          217907 ,
          12534 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33729 ,
          187685 ,
          18389 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33730 ,
          138508 ,
          14798 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33731 ,
          18445 ,
          14798 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33732 ,
          138508 ,
          15492 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33733 ,
          18185 ,
          15492 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33734 ,
          138508 ,
          15491 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33735 ,
          138508 ,
          15493 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33736 ,
          231519 ,
          16163 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33737 ,
          284636 ,
          16164 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33738 ,
          231520 ,
          15494 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33739 ,
          149498 ,
          15499 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33740 ,
          149500 ,
          15501 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33741 ,
          9215 ,
          15501 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33742 ,
          149502 ,
          15503 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33743 ,
          149503 ,
          15504 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33744 ,
          149505 ,
          15506 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33745 ,
          149497 ,
          15498 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33746 ,
          149507 ,
          15508 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33747 ,
          149510 ,
          15509 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33748 ,
          149506 ,
          15507 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33749 ,
          149518 ,
          15517 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33750 ,
          149511 ,
          15510 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33751 ,
          149513 ,
          15512 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33752 ,
          149514 ,
          15513 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33753 ,
          149516 ,
          15515 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33754 ,
          149495 ,
          15496 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33755 ,
          9961 ,
          14806 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33756 ,
          187686 ,
          18390 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33757 ,
          280100 ,
          16169 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33758 ,
          187688 ,
          18392 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33759 ,
          282595 ,
          18392 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33760 ,
          187544 ,
          13920 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33761 ,
          9678 ,
          14098 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33762 ,
          220941 ,
          16173 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33763 ,
          187668 ,
          18372 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33764 ,
          149475 ,
          15482 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33765 ,
          149713 ,
          15699 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33766 ,
          230883 ,
          16134 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33767 ,
          286525 ,
          14821 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33768 ,
          149478 ,
          13303 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33769 ,
          277956 ,
          16141 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33770 ,
          187669 ,
          18373 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33771 ,
          149481 ,
          12788 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33772 ,
          149479 ,
          15485 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33773 ,
          149482 ,
          15487 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33774 ,
          149480 ,
          15486 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33775 ,
          217430 ,
          16147 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33776 ,
          149483 ,
          15488 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33777 ,
          228754 ,
          16148 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33778 ,
          228753 ,
          16148 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33779 ,
          228759 ,
          16148 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33780 ,
          228757 ,
          16148 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33781 ,
          228752 ,
          16148 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33782 ,
          228758 ,
          16148 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33783 ,
          187671 ,
          18375 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33784 ,
          271224 ,
          19993 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33785 ,
          212893 ,
          19993 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33786 ,
          209524 ,
          19982 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33787 ,
          209522 ,
          19982 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33788 ,
          149484 ,
          15489 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33789 ,
          149485 ,
          12727 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33790 ,
          230990 ,
          12731 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33791 ,
          149907 ,
          15778 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33792 ,
          149462 ,
          12797 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33793 ,
          228740 ,
          13150 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33794 ,
          149723 ,
          12152 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33795 ,
          146540 ,
          12153 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33796 ,
          187673 ,
          18377 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33797 ,
          149464 ,
          15472 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33798 ,
          293843 ,
          20313 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33799 ,
          229992 ,
          16107 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33800 ,
          260545 ,
          16108 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33801 ,
          238533 ,
          16108 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33802 ,
          228734 ,
          16111 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33803 ,
          228733 ,
          16113 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33804 ,
          149466 ,
          15474 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33805 ,
          149467 ,
          15475 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33806 ,
          187675 ,
          18379 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33807 ,
          228732 ,
          16116 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33808 ,
          149468 ,
          15476 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33809 ,
          149469 ,
          15477 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33810 ,
          217791 ,
          19997 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33811 ,
          228731 ,
          15473 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33812 ,
          187677 ,
          18381 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33813 ,
          257782 ,
          16118 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33814 ,
          228728 ,
          16118 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33815 ,
          228727 ,
          16118 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33816 ,
          293700 ,
          20312 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33817 ,
          279319 ,
          16123 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33818 ,
          228725 ,
          16126 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33819 ,
          228724 ,
          16126 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33820 ,
          228722 ,
          16129 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33823 ,
          228723 ,
          16129 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33822 ,
          235578 ,
          18383 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33821 ,
          187679 ,
          18383 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33829 ,
          235945 ,
          20082 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33828 ,
          149470 ,
          15478 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33827 ,
          149471 ,
          15479 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33826 ,
          187680 ,
          18384 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33825 ,
          248530 ,
          20098 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33824 ,
          251997 ,
          20118 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
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
VALUES  ( 33830 ,
          187681 ,
          18385 ,
          N'BIC' ,
          GETDATE() ,
          NULL ,
          GETDATE() ,
          N'INC0244170' ,
          1 ,
          'Y'
        )
