USE RPA;

DECLARE @SourceRowCount int = 0;

--GET COUNT of rows to be changed
with partitionTID as
(
SELECT RecordId, ir.TransactionID, row_number() over (partition by RecordId order by TransactionID) as [rownum]
FROM [RPA].[dbo].[Rpa_Vow_Result_Records] rr
INNER JOIN [RPA].[dbo].[Rpa_Vow_Inbound_Records] ir ON ir.[RecordId] = rr.InboundID 
 WHERE rr.createdDate BETWEEN '12/21/2020' AND '12/22/2020 11:01:00.000'
 AND [AlliedTransactionID] not in ('234055326', '250014886', '242582893', '257690610', '100285407') 
 AND ErrorReason IS NULL
 AND FoundPolicyStatus in ('Active', 'Inactive') 
 )

SELECT @SourceRowCount =  COUNT(*) From partitionTID where rownum = 1
PRINT 'Rows to be changed ' + convert(varchar(100), @SourceRowCount)


-- Preserve DATA for rollback;
;with partitionTID1 as
(
	SELECT 
		RecordId
		,ir.PulledDate AS OLD_PulledDate
		,NULL AS NEW_PulledDate
		,ProcessTool AS OLD_ProcessTool
		,'RPA' AS NEW_ProcessTool
		,row_number() over (partition by RecordId order by TransactionID) as [rownum]
	 FROM [RPA].[dbo].[Rpa_Vow_Result_Records] rr
	 INNER JOIN [RPA].[dbo].[Rpa_Vow_Inbound_Records] ir ON ir.[RecordId] = rr.InboundID 
	 WHERE rr.createdDate BETWEEN '12/21/2020' AND '12/22/2020 11:01:00.000'
	 AND [AlliedTransactionID] not in ('234055326', '250014886', '242582893', '257690610', '100285407') 
	 AND ErrorReason IS NULL
	 AND FoundPolicyStatus in ('Active', 'Inactive')
)
	SELECT *
	FROM partitionTID1
	WHERE rownum = 1
 

--Perform update only if preserve count = SourceRowCount
IF( @@RowCount = @SourceRowCount )
	BEGIN
		PRINT 'Performing UPDATE - Preserve Row Count = Source Row Count'
		UPDATE [RPA].[dbo].[Rpa_Vow_Inbound_Records]
		SET PulledDate = BACKOUT.NEW_PulledDate, ProcessTool = BACKOUT.NEW_ProcessTool
		FROM [Rpa_Vow_Inbound_Records] IR
		INNER JOIN [UIPAHDStorage]..[INC0573763] [BACKOUT] ON BACKOUT.RecordId = IR.RecordId

		--BACKOUT PLAN if updated row count != SourceRowCount
		IF( @@RowCount <> @SourceRowCount )
			BEGIN
				PRINT 'Performing ROLLBACKUP - Update Row Count != SourceRow Count'
				UPDATE [RPA].[dbo].[Rpa_Vow_Inbound_Records]
				SET PulledDate = BACKOUT.OLD_PulledDate, ProcessTool = BACKOUT.OLD_ProcessTool
				FROM [Rpa_Vow_Inbound_Records] IR
				INNER JOIN [UIPAHDStorage]..[INC0573763] [BACKOUT] ON BACKOUT.RecordId = IR.RecordId
			END
		ELSE
			BEGIN
				PRINT 'SUCCESS - UPDATE Row Count = Source Row Count'
			END
	END
ELSE
	BEGIN
		PRINT 'STOPPING - Preserve Row Count != Source Row Count'
	END