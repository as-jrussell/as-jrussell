use [ThePlayPen ]


CREATE TABLE [dbo].[test]
(
[id] INT IDENTITY(1,1) PRIMARY KEY NONCLUSTERED,
[dt] DATETIME NOT NULL,
[s] VARCHAR(14) NOT NULL,
[filler] CHAR(4000)
)
INSERT INTO [dbo].[test] ([dt],[s]) VALUES ('1900-01-01','I am row One')
INSERT INTO [dbo].[test] ([dt],[s]) VALUES ('2000-01-01','I am row Two')
INSERT INTO [dbo].[test] ([dt],[s]) VALUES ('2100-01-01','I am row Three')
INSERT INTO [dbo].[test] ([dt],[s]) VALUES ('2200-01-01','I am row Four')
GO
/*
CREATE PARTITION FUNCTION [pfDataAllSplitOnUTC](DATETIME) AS RANGE RIGHT FOR VALUES (N'2000-01-01T00:00:00.000')
GO
CREATE PARTITION SCHEME [psDataAllPrimary] AS PARTITION [pfDataAllSplitOnUTC] ALL TO ([PRIMARY])
GO
*/

CREATE CLUSTERED INDEX [cl] ON [dbo].[test] ([dt] ASC)
--ON [psDataAllPrimary] ([dt])



/*sys.fn_GetRowsetIdFromRowDump
The first function that we will look at is called fn_GetRowsetIdFromrowdump and will display the partition_id for each of the rows. If you uncomment the code above you can partition the table and see which rows end up where like I have done in the image below.
*/

SELECT
%%rowdump%% [rowdump],
sys.fn_GetRowsetIdFromRowDump(%%rowdump%%) [partition_id],
*
FROM [dbo].[test] t


/* 
sys.fn_RowDumpCracker
The virtual column in the previous example is %%rowdump%% which contains information about the rows construction not the actual row. If this is used with fn_rowdumpCracker it will crack open this row information.

Note that there are several caveats to it`s use which have been documented within the function.

1. If inrowLength is 0 it implies the column is null or 0-length
2. If information about a column is not output then it must be a trailing null or 0-length variable length column.
3. Filters out columns that have been dropped.
4. Filters out uniquifiers.
5. Does not report clustering key columns in non-clustered indexes
6. Rowdump format: this explains the constants used below
*/


SELECT %%rowdump%% [rowdump],
rc.*
FROM [dbo].[test] t
CROSS APPLY sys.fn_RowDumpCracker(%%rowdump%%) rc


/*

sys.fn_physlocFormatter and fn_physlocCracker
The next virtual column that we come across is %%physloc%% which gives the physical row location as a binary(8) and this can be used with fn_physlocFormatter to format it as [file_id:page_id:slot_id] or/and with fn_physlocCracker to split it into the 3 columns.
*/

SELECT %%physloc%% [physloc],
sys.fn_PhysLocFormatter(%%physloc%%) [file_id:page_id:slot_id],
plc.*
FROM [dbo].[test]
CROSS APPLY sys.fn_PhysLocCracker(%%physloc%%) plc


SELECT 'DBCC Page (['+DB_NAME()+'],'
+CAST(CAST(CONVERT(BINARY(2),REVERSE(SUBSTRING(%%physloc%%,5, 2))) AS INT) AS VARCHAR(MAX))+','
+CAST(CAST(CONVERT(BINARY(4),REVERSE(SUBSTRING(%%physloc%%,1,4))) AS INT) AS VARCHAR(MAX))+',2)
WITH TABLERESULTS' [DBCC Page],*
FROM [dbo].[test]


DBCC Page ([ThePlayPen],1,14264,2)  WITH TABLERESULTS
DBCC Page ([ThePlayPen],1,14264,2)  WITH TABLERESULTS
DBCC Page ([ThePlayPen],1,14280,2)  WITH TABLERESULTS
DBCC Page ([ThePlayPen],1,14280,2)  WITH TABLERESULTS


SELECT %%lockres%% [lockres],*
FROM [dbo].[test] t

