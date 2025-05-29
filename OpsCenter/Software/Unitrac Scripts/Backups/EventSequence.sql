


SELECT  L.CODE_TX [Lender Number] ,
        L.NAME_TX [Lender Name] ,
        Lp.NAME_TX [Lender Prouct] ,
        LP.DESCRIPTION_TX [Lender Product Description] ,
        BASIC_TYPE_CD [Basic Type] ,
        BASIC_SUB_TYPE_CD [BasicSub Type] ,
        ESC.DESCRIPTION_TX [Event Sequence Desc] ,
        RC.DESCRIPTION_TX [Notice Type] ,
        NOTICE_SEQ_NO [Notice Sequence] ,
        T.DESCRPTION_TX [Template Name] ,
        LP.START_DT [Start Date]
FROM    dbo.EVENT_SEQ_CONTAINER ESC
        JOIN dbo.EVENT_SEQUENCE ES ON ES.EVENT_SEQ_CONTAINER_ID = ESC.ID
        JOIN dbo.TEMPLATE T ON T.ID = ES.TEMPLATE_ID
        JOIN dbo.LENDER_PRODUCT LP ON ESC.LENDER_ID = LP.ID
        JOIN dbo.LENDER L ON L.ID = LP.LENDER_ID
        LEFT JOIN dbo.REF_CODE RC ON RC.CODE_CD = ES.NOTICE_TYPE_CD
                                     AND RC.DOMAIN_CD = 'NoticeType'
		WHERE L.STATUS_CD = 'ACTIVE' AND TEST_IN = 'N' AND L.PURGE_DT IS NULL
		AND BASIC_TYPE_CD NOT IN ('TRKONLY','ORDERUP')