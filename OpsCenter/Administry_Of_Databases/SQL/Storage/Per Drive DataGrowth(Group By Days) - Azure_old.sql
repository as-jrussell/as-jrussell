DECLARE @filename NVARCHAR(1000)
DECLARE @DatabaseName VARCHAR(100) = '' --Database Name
DECLARE @Typename VARCHAR(100) = '' --Type Data or Log File
SELECT @filename = Cast(value AS NVARCHAR(1000))
--SELECT *
FROM   sys.Fn_trace_getinfo(DEFAULT)
WHERE  traceid = 1
       AND property = 2

-- Split filename into parts in order to get rid of the rollover number
DECLARE @bc  INT,
        @ec  INT,
        @bfn VARCHAR(1000),
        @efn VARCHAR(10)

SET @filename = Reverse(@filename)
SET @bc = Charindex('.', @filename)
SET @ec = Charindex('_', @filename) + 1
SET @efn = Reverse(Substring(@filename, 1, @bc))
SET @bfn = Reverse(Substring(@filename, @ec, Len(@filename)))
-- Set filename without rollover number
SET @filename = @bfn + @efn

SELECT DB.name,
       te.name,
       Filename,
       CONVERT(DATE, StartTime)          [Date],
       Sum(( IntegerData * 8.0 / 1024 )) AS 'ChangeInSize MB',
       LoginName
FROM   Fn_trace_gettable(@filename, DEFAULT) AS ftg
       INNER JOIN sys.trace_events AS te
               ON ftg.EventClass = te.trace_event_id
       LEFT JOIN sys.databases DB
              ON DB.physical_database_name = ftg.DatabaseName
WHERE  ( ftg.EventClass = 92
          OR ftg.EventClass = 93 )
       AND DatabaseName LIKE '%' + @DatabaseName + '%'
       AND te.name LIKE '%' + @TypeName + '%'
GROUP  BY DB.name,
          CONVERT(DATE, StartTime),
          te.name,
          Filename,
          LoginName
ORDER  BY te.name ASC,
          CONVERT(DATE, StartTime) DESC 
