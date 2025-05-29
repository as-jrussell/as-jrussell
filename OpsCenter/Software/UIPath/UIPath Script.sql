
 
	SELECT qd.ID
			,qd.Name
			,qd.Description
			,qd.IsDeleted
			--,uip.Enabled
			--,uip.QueueName
			INTO #QueuesEnabled
		FROM [UIPATH].[dbo].[QueueDefinitions] qd

		--INNER JOIN  [RPA].[dbo].[Rpa_Uipath_QueueInfo] uip on uip.QueueName = qd.Name collate SQL_Latin1_General_CP1_CI_AS 
			--AND uip.Enabled = 1
			--AND uip.QueueName like 'VOW%'
		WHERE qd.IsDeleted = 0 
			AND (qd.Description != 'OFF' OR qd.Description is null)
			AND qd.Name like 'VOW%'



	Select Notes
			,RecordID
			INTO #TotalInbound
		FROM [RPA].[dbo].[Rpa_Vow_Inbound_Records]

		Where Notes is not null and CreatedDate >= dateadd(day, -15, Getdate())
		and PulledDate is not null


	Select Notes
			,Count(RecordID) as InboundCount
INTO #InboundCount 
		FROM #TotalInbound
		GROUP BY Notes




	SELECT JSON_Value([SpecificData],'$.DynamicProperties.InboundID') AS [InboundID]
			,inb.Notes
			,inb.RecordID
			,qd.Name
INTO #TotalRunning
		FROM [UiPath].[dbo].[QueueItems] qi 

		inner join #TotalInbound inb on 
			JSON_Value([SpecificData], '$.DynamicProperties.InboundID') = inb.RecordID
		INNER JOIN [UiPath].[dbo].[QueueDefinitions] qd ON qd.id = QueueDefinitionId 
		INNER JOIN #QueuesEnabled qe on qe.Name = qd.Name

		WHERE qd.name LIKE 'VOW%' 
			AND EndProcessing IS NULL
			AND JSON_Value([SpecificData], '$.DynamicProperties.InboundID') IS NOT NULL
			AND Status not in ('4','5','6')



	SELECT Notes
			,COUNT(InboundID) as OutstandingQueueItems 
			INTO #TotalRunningCount 
		FROM #TotalRunning
		GROUP BY Notes


	SELECT JSON_Value([SpecificData], '$.DynamicProperties.InboundID') AS [InboundID]
			,inb.Notes
	INTO #DeletedNotes
		FROM [UiPath].[dbo].[QueueItems] qi 

		inner join #TotalInbound inb on 
			JSON_Value([SpecificData], '$.DynamicProperties.InboundID') = inb.RecordID 
		
		INNER JOIN [UiPath].[dbo].[QueueDefinitions] qd ON qd.id = QueueDefinitionId 
		INNER JOIN #QueuesEnabled qe on qe.Name = qd.Name

		WHERE qd.name LIKE 'VOW%' 
			AND EndProcessing IS NULL
			AND JSON_Value([SpecificData], '$.DynamicProperties.InboundID') IS NOT NULL
			AND Status in (4,5,6)

SELECT Notes
		,COUNT(InboundID) as DeletedItems
		INTO #DeletedCount
	FROM #DeletedNotes
	GROUP BY Notes


SELECT JSON_Value([SpecificData],'$.DynamicProperties.InboundID') AS [InboundID]
		,inb.RecordID
		,inb.Notes
		,rr.VowID
		,qi.Status
		,qi.CreationTime
		,qi.SpecificData
		INTO #TotalComplete
	FROM [UiPath].[dbo].[QueueItems] qi 
	
	inner join #TotalInbound inb on 
	JSON_Value([SpecificData], '$.DynamicProperties.InboundID') = inb.RecordID 
	INNER JOIN [UiPath].[dbo].[QueueDefinitions] qd ON qd.id = QueueDefinitionId 
	
	INNER JOIN [RPA].[dbo].[Rpa_Vow_Result_Records] rr on rr.InboundID = inb.RecordID
	INNER JOIN #QueuesEnabled qe on qe.Name = qd.Name
	
	WHERE qd.name LIKE 'VOW%' 
		AND JSON_Value([SpecificData], '$.DynamicProperties.InboundID') IS NOT NULL
		AND Status = 3

	SELECT Notes
			,Count(InboundID) as CompletedItems
			INTO #CompletedCount
		FROM #TotalComplete
		GROUP BY NOTES


	select ti.Notes
			,ti.RecordID
			,tr.InboundID 
			INTO #CompletedUniqueNotes
	from #TotalInbound ti

	inner join (select distinct InboundID from [RPA].[dbo].[Rpa_Vow_Result_Records]) rr on rr.InboundID = ti.RecordID

	left join #TotalRunning tr on tr.InboundID = ti.RecordID
	where tr.InboundID is null

Select Notes
		,Count(RecordID) as CompletedUniqueItems
	INTO #UniqueCount
	FROM #CompletedUniqueNotes
	GROUP BY Notes



select ti.Notes
			,ti.RecordID
			,tr.InboundID 
			INTO #IncompleteUniqueItems
	from #TotalInbound ti

	inner join (select distinct InboundID from #TotalRunning) tr on tr.InboundID = ti.RecordID


SELECT Notes
		,Count(RecordID) as IncompleteUniqueItems
		INTO #IncompleteUniqueCount 
	FROM #IncompleteUniqueItems
	GROUP BY Notes

	SELECT JSON_Value([SpecificData], '$.DynamicProperties.InboundID') AS [InboundID]
			,inb.Notes
	INTO #AppExceptionItems
		FROM [UiPath].[dbo].[QueueItems] qi 

		inner join #TotalInbound inb on 
			JSON_Value([SpecificData], '$.DynamicProperties.InboundID') = inb.RecordID 
		
		INNER JOIN [UiPath].[dbo].[QueueDefinitions] qd ON qd.id = QueueDefinitionId 
		INNER JOIN #QueuesEnabled qe on qe.Name = qd.Name

			AND EndProcessing IS NOT NULL
			AND JSON_Value([SpecificData], '$.DynamicProperties.InboundID') IS NOT NULL
			AND ProcessingExceptionType = 0

	SELECT Notes
			,Count(InboundID) AS AppExceptionItems
			INTO #AppExceptionCount
		FROM #AppExceptionItems
		GROUP BY Notes

	SELECT ti.Notes
			,ti.RecordID
			INTO #AppExceptionUnique
		FROM #TotalInbound ti

		inner join (select distinct InboundID from #AppExceptionItems) ae 
			on ae.InboundID = ti.RecordID
		left join #CompletedUniqueNotes cu on cu.RecordID = ti.RecordID
		left join #IncompleteUniqueItems iu on iu.RecordID = ti.RecordID

		where iu.RecordID is null
			and cu.RecordID is null

	SELECT Notes
			,Count(RecordID) as AppExceptionUniqueCount
			INTO #AppExceptionUniqueCount
		FROM #AppExceptionUnique
		GROUP BY Notes

	SELECT JSON_Value([SpecificData], '$.DynamicProperties.InboundID') AS [InboundID]
			,inb.Notes
	INTO #BusinessExceptionItems
		FROM [UiPath].[dbo].[QueueItems] qi 

		inner join #TotalInbound inb on 
			JSON_Value([SpecificData], '$.DynamicProperties.InboundID') = inb.RecordID 
		
		INNER JOIN [UiPath].[dbo].[QueueDefinitions] qd ON qd.id = QueueDefinitionId 
		INNER JOIN #QueuesEnabled qe on qe.Name = qd.Name

			AND EndProcessing IS NOT NULL
			AND JSON_Value([SpecificData], '$.DynamicProperties.InboundID') IS NOT NULL
			AND ProcessingExceptionType = 1

	SELECT Notes
			,Count(InboundID) AS BusinessExceptionItems
			INTO #BusinessExceptionCount
		FROM #BusinessExceptionItems
		GROUP BY Notes

	SELECT ti.Notes
			,ti.RecordID
			INTO #BusinessExceptionUnique
		FROM #TotalInbound ti
		inner join (select distinct InboundID from #BusinessExceptionItems) be
			on be.InboundID = ti.RecordID
		left join #CompletedUniqueNotes cu on cu.RecordID = ti.RecordID
		left join #IncompleteUniqueItems iu on iu.RecordID = ti.RecordID

		where iu.RecordID is null
			and cu.RecordID is null

	SELECT Notes
			,Count(RecordID) as BusinessExceptionUniqueCount
		INTO #BusinessExceptionUniqueCount
		FROM #BusinessExceptionUnique
		GROUP BY Notes

	select dn.Notes
			,dn.InboundID
			,cu.RecordID as CompleteID
			,iu.RecordID as IncompleteID
		INTO #DeletedUnique
		from #DeletedNotes dn

		left join #CompletedUniqueNotes cu on cu.RecordID = dn.InboundID 
		left join #IncompleteUniqueItems iu on iu.RecordID = dn.InboundID

		where cu.RecordID is null and iu.RecordID is null



	SELECT Notes
			,COUNT(ti.RecordID) as DeletedUniqueItems
			INTO #DeletedUniqueCount 
		FROM #TotalInbound ti

		INNER JOIN (SELECT DISTINCT InboundID from #DeletedUnique) du on du.InboundID = ti.RecordID

		GROUP BY Notes




	select ti.Notes
			,ti.RecordID
			INTO #UnknownUnique 
		from #TotalInbound ti
		left join #CompletedUniqueNotes cu on cu.RecordID = ti.RecordID
		left join #IncompleteUniqueItems iu on iu.RecordId = ti.RecordID
		left join #AppExceptionUnique au on au.RecordID = ti.RecordID
		left join #BusinessExceptionUnique bu on bu.RecordID = ti.RecordID
		left join #DeletedUnique du on du.InboundID = ti.RecordID

		--left join [RPA].[dbo].Rpa_Vow_Result_Records rr on rr.InboundID = ti.RecordID

		where cu.RecordId is null
			and iu.RecordId is null
			and du.InboundID is null 
			and au.RecordID is null
			and bu.RecordID is null
			--and rr.InboundID is null



	SELECT Notes	
			,COUNT(RecordId) as UnknownUniqueItems
			INTO #UnknownUniqueCount 
		FROM #UnknownUnique
		GROUP BY Notes


SELECT ic.Notes
		,coalesce(ic.InboundCount, 0) as TotalInboundCount
		,coalesce(tc.OutstandingQueueItems, 0) as OutstandingQueueItems
		,coalesce(cc.CompletedItems, 0) as CompletedItems
		,coalesce(iuc.IncompleteUniqueItems, 0) as IncompleteUniqueItems
		,coalesce(uc.CompletedUniqueItems, 0) as CompletedUniqueItems
		,coalesce(ac.AppExceptionItems, 0) as AppExceptions
		,coalesce(auc.AppExceptionUniqueCount, 0) as AppExceptionsUniqueItems
		,coalesce(bc.BusinessExceptionItems, 0) as BusinessExceptions
		,coalesce(buc.BusinessExceptionUniqueCount, 0) as BusinessExceptionsUniqueItems
		,coalesce(dc.DeletedItems, 0) as DeletedItems
		,coalesce(duc.DeletedUniqueItems, 0) as DeletedUniqueItems
		,coalesce(uuc.UnknownUniqueItems, 0) as UnknownUniqueItems
	
	FROM #InboundCount ic
	LEFT JOIN #TotalRunningCount tc on tc.Notes = ic.Notes
	LEFT JOIN #DeletedCount dc on dc.Notes = ic.Notes
	LEFT JOIN #CompletedCount cc on cc.Notes = ic.Notes
	LEFT JOIN #UniqueCount uc on uc.Notes = ic.Notes
	LEFT JOIN #IncompleteUniqueCount iuc on iuc.Notes = ic.Notes
	LEFT JOIN #DeletedUniqueCount duc on duc.Notes = ic.Notes
	LEFT JOIN #AppExceptionCount ac on ac.Notes = ic.Notes
	LEFT JOIN #AppExceptionUniqueCount auc on auc.Notes = ic.Notes
	LEFT JOIN #BusinessExceptionCount bc on bc.Notes = ic.Notes
	LEFT JOIN #BusinessExceptionUniqueCount buc on buc.Notes = ic.Notes
	LEFT JOIN #UnknownUniqueCount uuc on uuc.Notes = ic.Notes

	ORDER BY TotalInboundCount desc