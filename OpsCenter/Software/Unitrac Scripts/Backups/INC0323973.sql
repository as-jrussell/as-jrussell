USE Unitrac

SELECT * FROM CHANGE C
LEFT JOIN CHANGE_UPDATE CU ON C.ID = CU.CHANGE_ID
WHERE C.ENTITY_NAME_TX = 'Allied.UniTrac.LenderReportConfig' AND 
C.USER_TX = 'jrussell'
ORDER BY C.CREATE_DT DESC 


SELECT LRC.UPDATE_DT, LRC.TITLE_TX, * FROM dbo.LENDER_REPORT_CONFIG LRC
WHERE ID IN (89034,
89015,
88992,
104208)


INSERT dbo.CHANGE (   ENTITY_NAME_TX ,
                           ENTITY_ID ,
                           NOTE_TX ,
                           TICKET_TX ,
                           USER_TX ,
                           ATTACHMENT_IN ,
                           CREATE_DT ,
                           AGENCY_ID ,
                           DESCRIPTION_TX ,
                           DETAILS_IN ,
                           FORMATTED_IN ,
                           LOCK_ID ,
                           PARENT_NAME_TX ,
                           PARENT_ID ,
                           TRANS_STATUS_CD ,
                           TRANS_STATUS_DT
                       )
VALUES (   'Allied.UniTrac.LenderReportConfig' ,        -- ENTITY_NAME_TX - varchar(100)
           88981 ,         -- ENTITY_ID - bigint
           N'Reset it blank' ,       -- NOTE_TX - nvarchar(100)
           N'' ,       -- TICKET_TX - nvarchar(20)
           N'jrussell' ,       -- USER_TX - nvarchar(15)
           'N' ,        -- ATTACHMENT_IN - char(1)
           GETDATE() , -- CREATE_DT - datetime
           NULL ,         -- AGENCY_ID - bigint
           NULL ,       -- DESCRIPTION_TX - nvarchar(max)
           'Y' ,        -- DETAILS_IN - char(1)
           'N' ,        -- FORMATTED_IN - char(1)
           1 ,         -- LOCK_ID - tinyint
           'Allied.UniTrac.Lender' ,        -- PARENT_NAME_TX - varchar(100)
           2254 ,         -- PARENT_ID - bigint
           'PEND' ,        -- TRANS_STATUS_CD - varchar(4)
           NULL  -- TRANS_STATUS_DT - datetime
       )


	   INSERT dbo.CHANGE_UPDATE (   CHANGE_ID ,
	                                     TABLE_NAME_TX ,
	                                     TABLE_ID ,
	                                     QUALIFIER_TX ,
	                                     COLUMN_NM ,
	                                     FROM_VALUE_TX ,
	                                     TO_VALUE_TX ,
	                                     DATATYPE_NO ,
	                                     CREATE_DT ,
	                                     AREA_TX ,
	                                     FORMAT_FROM_VALUE_TX ,
	                                     FORMAT_TO_VALUE_TX ,
	                                     DISPLAY_IN ,
	                                     OPERATION_CD
	                                 )
	   VALUES (   2282352 ,         -- CHANGE_ID - bigint
	              'LENDER_REPORT_CONFIG' ,        -- TABLE_NAME_TX - varchar(50)
	              88981 ,         -- TABLE_ID - bigint
	              N'' ,       -- QUALIFIER_TX - nvarchar(500)
	              'FOOTER_TX' ,        -- COLUMN_NM - varchar(50)
	              N'.' ,       -- FROM_VALUE_TX - nvarchar(max)
	              NULL ,       -- TO_VALUE_TX - nvarchar(max)
	              1 ,         -- DATATYPE_NO - tinyint
	              GETDATE() , -- CREATE_DT - datetime
	              N'' ,       -- AREA_TX - nvarchar(500)
	              N'' ,       -- FORMAT_FROM_VALUE_TX - nvarchar(max)
	              N'' ,       -- FORMAT_TO_VALUE_TX - nvarchar(max)
	              '' ,        -- DISPLAY_IN - char(1)
	              ''          -- OPERATION_CD - char(1)
	          )




SELECT LO.* FROM dbo.LENDER_ORGANIZATION LO
JOIN dbo.LENDER L ON L.ID = LO.LENDER_ID
WHERE L.CODE_TX = '3525'