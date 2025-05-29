

EXEC dbo.PopulateDatasourceCacheStaging


SELECT
MIN(dcs.CREATE_DT) AS MinDate
, MAX(dcs.CREATE_DT) AS MaxDate
, COUNT(*) AS RecordCount
FROM DATASOURCE_CACHE_STAGING dcs