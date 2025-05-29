--Check Status of FullTEXT Index
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET nocount ON
DECLARE @tbl SYSNAME
DECLARE @cat SYSNAME
DECLARE @Delta INT
DECLARE @ErrorMessage AS VARCHAR(100)
CREATE TABLE #temp_ca
    (
      TABLE_OWNER VARCHAR(100) ,
      TABLE_NAME VARCHAR(256) ,
      FULLTEXT_KEY_INDEX_NAME VARCHAR(256) ,
      FULLTEXT_KEY_COLID INT ,
      FULLTEXT_INDEX_ACTIVE INT ,
      FULLTEXT_CATALOG_NAME VARCHAR(256)
    )
CREATE TABLE #temp_status
    (
      Catalog VARCHAR(64) ,
      TblName VARCHAR(64) ,
      [IsEnabled] BIT ,
      ChangeTracking VARCHAR(24) ,
      PopulateStatus VARCHAR(64) ,
      RowCnt INT ,
      FTS_CT INT ,
      Delta INT ,
      PercentCompleted VARCHAR(128) ,
      path NVARCHAR(260)
    )
INSERT  INTO #temp_ca
        EXEC sp_help_fulltext_tables 
DECLARE ca_cursor CURSOR
FOR
    SELECT  TABLE_NAME ,
            FULLTEXT_CATALOG_NAME
    FROM    #temp_ca
OPEN ca_cursor
FETCH NEXT FROM ca_cursor INTO @tbl, @cat
WHILE @@fetch_STATUS = 0 
    BEGIN
        INSERT  INTO #temp_status
                SELECT  CAST (@cat AS VARCHAR(40)) Catalog ,
                        CAST(OBJECT_NAME(si.id) AS VARCHAR(25)) TblName ,
                        CAST(OBJECTPROPERTY(tbl.id,
                                            'TableHasActiveFulltextIndex') AS BIT) AS [IsEnabled] ,
                        CASE ISNULL(OBJECTPROPERTY(tbl.id,
                                                   'TableFullTextBackgroundUpdateIndexon'),
                                    0) + ISNULL(OBJECTPROPERTY(tbl.id,
                                                              'TableFullTextChangeTrackingon'),
                                                0)
                          WHEN 0 THEN 'Do not track changes'
                          WHEN 1 THEN 'Manual'
                          WHEN 2 THEN 'Automatic'
                        END [ChangeTracking] ,
                        CASE FULLTEXTCATALOGPROPERTY(@cat, 'PopulateStatus')
                          WHEN 0 THEN 'Idle'
                          WHEN 1 THEN 'Full population in progress'
                          WHEN 2 THEN 'Paused'
                          WHEN 3 THEN 'Throttled'
                          WHEN 4 THEN 'Recovering'
                          WHEN 5 THEN 'Shutdown'
                          WHEN 6 THEN 'Incremental population in progress'
                          WHEN 7 THEN 'Building index'
                          WHEN 8 THEN 'Disk is full. Paused.'
                          WHEN 9 THEN 'Change tracking'
                        END PopulateStatus ,
                        si.RowCnt ,
                        FULLTEXTCATALOGPROPERTY(@cat, 'ItemCount') FTS_CT ,
                        si.RowCnt - FULLTEXTCATALOGPROPERTY(@cat, 'ItemCount') Delta ,
                        CAST (100.0 * FULLTEXTCATALOGPROPERTY(@cat,
                                                              'ItemCount')
                        / CAST(si.RowCnt AS DECIMAL(14, 2)) AS VARCHAR) + '%' AS PercentCompleted ,
                        ISNULL(cat.path, 'Check Default Path')
                FROM    dbo.sysobjects AS tbl
                        INNER JOIN sysusers AS stbl ON stbl.uid = tbl.uid
                        INNER JOIN sysfulltextcatalogs AS cat ON ( cat.ftcatid = OBJECTPROPERTY(tbl.id,
                                                              'TableFullTextCatalogId') )
                                                              AND ( 1 = CAST(OBJECTPROPERTY(tbl.id,
                                                              'TableFullTextCatalogId') AS BIT) )
                        INNER JOIN sysindexes AS si ON si.id = tbl.id
                WHERE   si.indid IN ( 0, 1 )
                        AND si.id = OBJECT_ID(@tbl)
        FETCH NEXT FROM ca_cursor INTO @tbl, @cat
    END
CLOSE ca_cursor
DEALLOCATE ca_cursor




SELECT @Delta = Delta FROM #temp_status t
SELECT @ErrorMessage = 'The crawler is behind by ' + CONVERT(VARCHAR(20), Delta) FROM #temp_status t  


SELECT * FROM #temp_ca

SELECT * FROM #temp_status
--DROP TABLE #temp_ca
--DROP TABLE #temp_status

    --IF @Delta > 1000
    --    BEGIN
    --        EXEC msdb.dbo.sp_send_dbmail @profile_name = 'Unitrac-prod',
    --            @recipients = 'UT-Prod-SysAdmin@alliedsolutions.net;leroy.brown@alliedsolutions.net',
    --            @subject = 'UniTrac Full-Text Crawler Is Behind',
    --            @body = @ErrorMessage
    --        RETURN
    --    END