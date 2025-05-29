USE [IND_AlliedSolutions_157GIC109]

DECLARE @DateStart nvarchar(50) = NULL
DECLARE @DateEnd nvarchar(50) = NULL
DECLARE @ConnValue nvarchar(50) = NULL
DECLARE @DisplayName nvarchar(50) = NULL

if object_id('tempdb.dbo.#tmpRBC','U') is not null drop table #tmpRBC
create table #tmpRBC(
	QueueObjectIdKey nvarchar(100)
)

BULK INSERT #tmpRBC 
FROM --'\\ON-SQLCLSTPRD-2\BulkInserts$\CallRecordings\Test.txt'
'\\ALLIED-UT-DEV2\c$\BulkInserts\CallRecordings\Test.txt'
WITH
(
	FIRSTROW			= 1,
	FIELDTERMINATOR		= '\t',
	ROWTERMINATOR		= '\n'
);


 if (select COUNT(QueueObjectIdKey) from tempdb.dbo.#tmpRBC) >=1 
 BEGIN 
  SELECT DISTINCT  QueueObjectIdKey,  [MediaURI] ,I.DisplayName, CONVERT(DATE,I.EventDate) [Date]
    FROM [IND_AlliedSolutions_157GIC109].[dbo].[Individual] II
  JOIN [IND_AlliedSolutions_157GIC109].[dbo].[IR_Event] I on II.IndivID  = I.IndivID
    JOIN [IND_AlliedSolutions_157GIC109].[dbo].[IR_RecordingMedia] R on R.RecordingId  = I.RecordingId
	WHERE   QueueObjectIdKey  IN  (  SELECT QueueObjectIdKey  FROM #tmpRBC)
	ORDER BY QueueObjectIdKey ASC, CONVERT(DATE,I.EventDate) ASC
END
	ELSE 
 if @ConnValue is NOT NULL AND @DateStart  is NULL AND @DateEND  is  NULL
 BEGIN
SELECT DISTINCT QueueObjectIdKey,  [MediaURI] ,I.DisplayName, CONVERT(DATE,I.EventDate) [Date], ConnValue
    FROM [IND_AlliedSolutions_157GIC109].[dbo].[Individual] II
  JOIN [IND_AlliedSolutions_157GIC109].[dbo].[IR_Event] I on II.IndivID  = I.IndivID
    JOIN [IND_AlliedSolutions_157GIC109].[dbo].[IR_RecordingMedia] R on R.RecordingId  = I.RecordingId
	WHERE   ConnValue    like '%'+ @ConnValue +'%'   
	ORDER BY ConnValue ASC, CONVERT(DATE,I.EventDate) ASC
END
	ELSE
if @DateStart  is not NULL AND @DateEND  is not NULL AND @ConnValue is NULL
BEGIN
	SELECT DISTINCT QueueObjectIdKey,  [MediaURI] ,I.DisplayName,CONVERT(DATE,I.EventDate)  [Date]
    FROM [IND_AlliedSolutions_157GIC109].[dbo].[Individual] II
  JOIN [IND_AlliedSolutions_157GIC109].[dbo].[IR_Event] I on II.IndivID  = I.IndivID
    JOIN [IND_AlliedSolutions_157GIC109].[dbo].[IR_RecordingMedia] R on R.RecordingId  = I.RecordingId
	WHERE  I.EventDate >= @DateStart and	 I.EventDate <= @DateEnd
	ORDER BY  CONVERT(DATE,I.EventDate) ASC
END
	ELSE
if  @DateStart  is not NULL AND @DateEND  is not NULL AND @ConnValue is NOT NULL
BEGIN 
	SELECT DISTINCT QueueObjectIdKey,  [MediaURI] ,I.DisplayName,CONVERT(DATE,I.EventDate)  [Date]
	FROM [IND_AlliedSolutions_157GIC109].[dbo].[Individual] II
	JOIN [IND_AlliedSolutions_157GIC109].[dbo].[IR_Event] I on II.IndivID  = I.IndivID
	JOIN [IND_AlliedSolutions_157GIC109].[dbo].[IR_RecordingMedia] R on R.RecordingId  = I.RecordingId
	WHERE  I.EventDate >= @DateStart and	 I.EventDate <= @DateEnd
	AND ConnValue    like '%'+ @ConnValue +'%'   
	ORDER BY  CONVERT(DATE,I.EventDate) ASC
END
	ELSE
if @DisplayName  is not NULL 
BEGIN
	  SELECT DISTINCT QueueObjectIdKey,  [MediaURI] ,I.DisplayName, CONVERT(DATE,I.EventDate)  [Date], ConnValue
    FROM [IND_AlliedSolutions_157GIC109].[dbo].[Individual] II
  JOIN [IND_AlliedSolutions_157GIC109].[dbo].[IR_Event] I on II.IndivID  = I.IndivID
    JOIN [IND_AlliedSolutions_157GIC109].[dbo].[IR_RecordingMedia] R on R.RecordingId  = I.RecordingId
	WHERE DisplayName  like '%'+ @DisplayName +'%' 
END
	ELSE 
BEGIN 
	PRINT 'FAILURE: NO ENTRIES CHOICES HAVE BEEN MADE!!! PLEASE CHECK YOUR INFORMATION!!!'
END