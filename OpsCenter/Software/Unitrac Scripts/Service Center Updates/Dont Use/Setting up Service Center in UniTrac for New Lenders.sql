---Researching the lenders

--1) Center/Lender Mapping
SELECT LENDER.CODE_TX, LENDER.NAME_TX,SERVICE_CENTER.NAME_TX--,*
FROM SERVICE_CENTER_FUNCTION_LENDER_RELATE
INNER JOIN LENDER ON SERVICE_CENTER_FUNCTION_LENDER_RELATE.LENDER_ID = LENDER.ID
INNER JOIN SERVICE_CENTER_FUNCTION ON SERVICE_CENTER_FUNCTION_LENDER_RELATE.SERVICE_CENTER_FUNCTION_ID = SERVICE_CENTER_FUNCTION.ID
INNER JOIN SERVICE_CENTER ON SERVICE_CENTER_FUNCTION.SERVICE_CENTER_ID = SERVICE_CENTER.ID
WHERE LENDER.CODE_TX = '6083  '
ORDER BY LENDER.CODE_TX

--2) Center/LenderOrg Mapping
SELECT LENDER.CODE_TX, LENDER.NAME_TX,LENDER_ORGANIZATION.NAME_TX,RELATE_ID, RELATED_DATA.VALUE_TX--,*
FROM RELATED_DATA
INNER JOIN LENDER_ORGANIZATION ON RELATED_DATA.RELATE_ID = LENDER_ORGANIZATION.ID
INNER JOIN LENDER ON LENDER_ORGANIZATION.LENDER_ID = LENDER.ID
WHERE DEF_ID = 105 AND LENDER.CODE_TX = '6083  '
ORDER BY LENDER.CODE_TX



---Updating the Center/Lender Mapping

DECLARE @centerCode NVARCHAR(30) ,
    @vutCenterCode NVARCHAR(14) ,
    @lenderCode NVARCHAR(10) = '6083'

set @vutCenterCode = 'Seattle'
set @centerCode = 'Seattle'


UPDATE  VUT.dbo.tblLender
SET     centerkey = ( SELECT    CenterKey
                      FROM      VUT.dbo.tblCenter
                      WHERE     CenterID = @vutCenterCode
                    )
WHERE   LenderID IN ( @lenderCode )

--Inserting a new line if there isn't one for Center/LenderOrg Mapping 
--INSERT into RELATED_DATA (DEF_ID, RELATE_ID, VALUE_TX, CREATE_DT, UPDATE_DT, UPDATE_USER_TX, LOCK_ID)
--select 105, div.id, 'Seattle', GETDATE(), GETDATE(), 'script', 1
--from LENDER_ORGANIZATION div
--   inner join LENDER l on l.ID = div.LENDER_ID 
--where l.CODE_TX = '6044'
--   and div.TYPE_CD = 'DIV' and div.PURGE_DT is null  



UPDATE  UniTrac.dbo.SERVICE_CENTER_FUNCTION_LENDER_RELATE
SET     SERVICE_CENTER_FUNCTION_ID = ( SELECT   scf.ID
                                       FROM     SERVICE_CENTER_FUNCTION scf
                                                INNER JOIN SERVICE_CENTER sc ON sc.ID = scf.SERVICE_CENTER_ID
                                                              AND sc.CODE_TX = @centerCode
                                     )
FROM    lender l
        INNER JOIN SERVICE_CENTER_FUNCTION_LENDER_RELATE r ON r.LENDER_ID = l.ID
WHERE   l.CODE_TX IN ( @lenderCode ) 

--- Updating the Center/LenderOrg Mapping

SELECT  *
FROM    UniTrac..RELATED_DATA
WHERE   DEF_ID = 105
        AND RELATE_ID IN ( 3726,
3727 )

UPDATE  UniTrac..RELATED_DATA
SET     VALUE_TX = 'Seattle'
WHERE   ID IN (25555723,
25555724)
        AND RELATE_ID IN (  3726,
3727 ) 
        AND DEF_ID = 105