/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [RecordingId]
      ,[RelatedRecordingId]
      ,[MediaURI]
      ,[MediaKey]
      ,[MediaType]
      ,[FileSize]
      ,[RecordingDate]
      ,[RecordingDateOffset]
      ,[ExpirationDate]
      ,[StartEventCode]
      ,[Duration]
      ,[FromConnValue]
      ,[ToConnValue]
      ,[MediaStatus]
      ,[Direction]
      ,[QueueObjectIdKey]
      ,[InitiationPolicyName]
      ,[ScreenRecordedHostName]
      ,[LineName]
      ,[NumAttachments]
      ,[CallType]
      ,[Version]
      ,[KeywordCustomerScorePositive]
      ,[KeywordCustomerScoreNegative]
      ,[KeywordAgentScorePositive]
      ,[KeywordAgentScoreNegative]
      ,[IsArchived]
      ,[RecordingType]

--SELECT top 5 [MediaURI], I.DisplayName, ConnValue, WorkGroup, I.EventDate
    FROM [IND_AlliedSolutions_157GIC109].[dbo].[Individual] II
  JOIN [IND_AlliedSolutions_157GIC109].[dbo].[IR_Event] I on II.IndivID  = I.IndivID
    JOIN [IND_AlliedSolutions_157GIC109].[dbo].[IR_RecordingMedia] R on R.RecordingId  = I.RecordingId
  WHERE IsInternalParticipant = '1'


  SELECT DISTINCT I.DisplayName
  --SELECT DISTINCT COUNT(*)
    FROM [IND_AlliedSolutions_157GIC109].[dbo].[Individual] II
  JOIN [IND_AlliedSolutions_157GIC109].[dbo].[IR_Event] I on II.IndivID  = I.IndivID
    JOIN [IND_AlliedSolutions_157GIC109].[dbo].[IR_RecordingMedia] R on R.RecordingId  = I.RecordingId
  ORDER BY EVENTDATE ASC 