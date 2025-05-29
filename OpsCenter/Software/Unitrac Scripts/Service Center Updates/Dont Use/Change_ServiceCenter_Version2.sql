---- Check VUT..tblCenter Assignment First
--SELECT  P.LenderID ,
--        P.LenderKey ,
--        Q.CenterKey ,
--        Q.CenterID ,
--        Q.CenterName
--FROM    VUT.dbo.tblLender P
--        INNER JOIN dbo.tblCenter Q ON P.CenterKey = Q.CenterKey
--WHERE   P.LenderID IN ( '7512' )

DECLARE @centerCode NVARCHAR(30) ,
    @vutCenterCode NVARCHAR(14) ,
    @lenderCode NVARCHAR(10) = '7512'

--set @vutCenterCode = 'Albuquerq'
--set @centerCode = 'Albuquerque'

--set @vutCenterCode = 'Carmel'
--set @centerCode = 'Carmel'

set @vutCenterCode = 'Calif Mortgage'
set @centerCode = 'Calif Mortgage'


--set @vutCenterCode = 'Denver'
--set @centerCode = 'Denver'

--SET @vutCenterCode = 'Lag Hills'
--SET @centerCode = 'Laguna Hills'

--set @vutCenterCode = 'Maitland'
--set @centerCode = 'Maitland'

--set @vutCenterCode = 'OK City'
--set @centerCode = 'Oklahoma City'

--set @vutCenterCode = 'Plano'
--set @centerCode = 'Plano'

--set @vutCenterCode = 'Seattle'
--set @centerCode = 'Seattle'

--set @vutCenterCode = 'Sioux City'
--set @centerCode = 'Sioux City'

--set @vutCenterCode = 'SLC'
--set @centerCode = 'Salt Lake City'

--set @vutCenterCode = 'Wich Falls'   
--set @centerCode = 'Wichita Falls'

UPDATE  VUT.dbo.tblLender
SET     centerkey = ( SELECT    CenterKey
                      FROM      VUT.dbo.tblCenter
                      WHERE     CenterID = @vutCenterCode
                    )
WHERE   LenderID IN ( @lenderCode )


UPDATE  UniTrac.dbo.RELATED_DATA
SET     VALUE_TX = @centerCode
FROM    RELATED_DATA rd
        INNER JOIN RELATED_DATA_DEF rdd ON rdd.ID = rd.DEF_ID
                                           AND rdd.NAME_TX = 'AssociatedServiceCenter'
                                           AND rdd.RELATE_CLASS_NM = 'LenderOrganization'
        INNER JOIN LENDER_ORGANIZATION lo ON rd.RELATE_ID = lo.ID
        INNER JOIN LENDER l ON lo.LENDER_ID = l.ID
WHERE   l.CODE_TX IN ( @lenderCode )


UPDATE  UniTrac.dbo.SERVICE_CENTER_FUNCTION_LENDER_RELATE
SET     SERVICE_CENTER_FUNCTION_ID = ( SELECT   scf.ID
                                       FROM     SERVICE_CENTER_FUNCTION scf
                                                INNER JOIN SERVICE_CENTER sc ON sc.ID = scf.SERVICE_CENTER_ID
                                                              AND sc.CODE_TX = @centerCode
                                     )
FROM    lender l
        INNER JOIN SERVICE_CENTER_FUNCTION_LENDER_RELATE r ON r.LENDER_ID = l.ID
WHERE   l.CODE_TX IN ( @lenderCode ) 

