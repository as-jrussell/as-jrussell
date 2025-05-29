USE [UniTrac]
GO

/****** Object:  StoredProcedure [dbo].[GetVerifyDataWorkItemExtensions]    Script Date: 1/28/2016 11:40:44 AM ******/
DROP PROCEDURE [dbo].[GetVerifyDataWorkItemExtensions]
GO

/****** Object:  StoredProcedure [dbo].[GetVerifyDataWorkItemExtensions]    Script Date: 1/28/2016 11:40:44 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[GetVerifyDataWorkItemExtensions]
(
	@lenderId bigint = NULL,
	@lenderProductId bigint = NULL,
	@lenderAdmin nvarchar(100) = NULL,
	@userId bigint = NULL,
	@SearchText varchar(100)  = NULL,
	@UserRoleCd varchar(50) = NULL,
	@VerificationStatus varchar(50) = null,
	@RecordCount int = null,
	@WorkItemState nvarchar(100) = NULL,
	@CheckOutWorkItems char(1) = 'Y'
)
AS
BEGIN

DECLARE @userName VARCHAR(50)
DECLARE @VerificationStatus2 as nvarchar(100) = null
 
IF @WorkItemState = 'AssignFromLender'
begin
set @VerificationStatus = 'Verified By Lender'
set @VerificationStatus2 = 'Changed By Lender'
end


--Get WorkItem Ids
SELECT WI.ID WI_ID
,ROW_NUMBER() OVER (PARTITION BY WI.ID ORDER BY UWQR.PRIORITY_NO ASC, WQV.PRIORITY1_NO ASC, WQV.PRIORITY2_NO ASC,
					WQV.PRIORITY3_NO ASC, WQV.PRIORITY4_NO ASC, WQV.CREATE_DT ASC) AS RowNumPerWI
,ROW_NUMBER() OVER (ORDER BY UWQR.PRIORITY_NO ASC, WQV.PRIORITY1_NO ASC, WQV.PRIORITY2_NO ASC,
					WQV.PRIORITY3_NO ASC, WQV.PRIORITY4_NO ASC, WQV.CREATE_DT ASC) AS RowNumOrderBy
INTO #tmpWI
FROM dbo.WorkQueue_view WQV with (NOEXPAND, ROWLOCK, xlock, READPAST, READCOMMITTEDLOCK)
	JOIN dbo.USER_WORK_QUEUE_RELATE UWQR ON UWQR.WORK_QUEUE_ID = WQV.WORK_QUEUE_ID 
												AND  WQV.USER_ROLE_CD = UWQR.USER_ROLE_CD
												AND UWQR.PURGE_DT is null 
	JOIN WORK_ITEM WI ON WI.ID = WQV.WORKITEM_ID AND WI.PURGE_DT IS NULL
	JOIN WORKFLOW_DEFINITION WD ON WD.ID = WI.WORKFLOW_DEFINITION_ID AND WD.NAME_TX = 'VerifyData'
	JOIN LOAN LN ON LN.ID = WI.RELATE_ID AND LN.PURGE_DT IS NULL
	JOIN COLLATERAL COL ON COL.LOAN_ID = LN.ID AND COL.PURGE_DT IS NULL
	JOIN REQUIRED_COVERAGE RC ON RC.PROPERTY_ID = COL.PROPERTY_ID AND RC.PURGE_DT IS NULL	
	CROSS APPLY WI.CONTENT_XML.nodes('/Content/VerifyData/Detail') AS WIXML(VS)
WHERE 
(@lenderId is null or (@lenderId is not null and LN.LENDER_ID = @lenderId))
AND UWQR.USER_ID = @userId
AND (@lenderProductId is null or (@lenderProductId is not null and RC.LENDER_PRODUCT_ID = @lenderProductId)) 
AND WI.USER_ROLE_CD = @UserRoleCd
AND ((@WorkItemState = 'AssignFromLender' and WIXML.VS.value('@VerificationStatus[1]', 'VARCHAR(100)') in (@VerificationStatus, @VerificationStatus2)) 
	or WIXML.VS.value('@VerificationStatus[1]', 'VARCHAR(100)') = @VerificationStatus)
AND (@SearchText IS NULL OR (@SearchText IS NOT NULL AND CAST(WI.CONTENT_XML AS VARCHAR(MAX)) LIKE '%' + @SearchText + '%'))
AND (@LenderAdmin is NULL or @LenderAdmin = 'All' or WI.CONTENT_XML.value('(/Content/Information)[1]','nvarchar(max)')  LIKE '%Lender Admin: ' + @LenderAdmin + '%')
AND (WI.CHECKED_OUT_OWNER_ID IS NULL OR WI.CHECKED_OUT_OWNER_ID = 0 OR WI.CHECKED_OUT_OWNER_ID = @userId)


--Get Username
SELECT @userName = SUBSTRING(USER_NAME_TX, 1, 15)
FROM USERS
WHERE ID = @userId


--CheckOut WorkItems
IF @CheckOutWorkItems = 'Y'
BEGIN
	UPDATE WI
	SET CHECKED_OUT_OWNER_ID = @userId
		, CHECKED_OUT_DT = GETDATE()
		, UPDATE_DT = GETDATE()
		, UPDATE_USER_TX = @userName
		, LOCK_ID = ( LOCK_ID % 255 ) + 1
	FROM WORK_ITEM WI
		JOIN (SELECT TOP (@RecordCount) WI_ID FROM #tmpWI WHERE RowNumPerWI = 1
         ORDER BY RowNumOrderBy) AS tmpWI ON tmpWI.WI_ID = WI.ID
END

--Return WorkItems		
SELECT TOP (@RecordCount) WI.ID
	, WI.NAME_TX
	, WI.WORKFLOW_DEFINITION_ID
	, WI.RELATE_ID
	, WI.RELATE_TYPE_CD
	, WI.ACTIVE_IN
	, WI.STATUS_CD
	, WI.PARENT_ID
	, WI.CURRENT_QUEUE_ID
	, WI.CURRENT_OWNER_ID
	, WI.LAST_WORK_ITEM_ACTION_ID
	, WI.PRIORITY_NUM
	, WI.CREATE_DT
	, WI.UPDATE_DT
	, WI.PURGE_DT
	, WI.UPDATE_USER_TX
	, WI.RESERVED_OWNER_ID
	, WI.RESERVED_DT
	, WI.CHECKED_OUT_OWNER_ID
	, WI.CHECKED_OUT_OWNER_SUB_TX
	, WI.CHECKED_OUT_DT
	, WI.CONTENT_XML
	, WI.LAST_EVALUATION_DT
	, WI.LOCK_ID
	, WI.USER_ROLE_CD
	, WI.DELAY_UNTIL_DT
	, WI.DO_NOT_EVALUATE_IN
	, LN.ID
	, LN.NUMBER_TX
	, LN.PAYOFF_DT
	, LN.EXTRACT_UNMATCH_COUNT_NO
	, AGENCY_NOTE.ACTION_NOTE_TX
	, LENDER_NOTE.ACTION_NOTE_TX
FROM #tmpWI tmp
	JOIN WORK_ITEM WI ON WI.ID = tmp.WI_ID
	JOIN LOAN LN ON LN.ID = WI.RELATE_ID
	OUTER APPLY (
		SELECT TOP 1 ACTION_NOTE_TX
		FROM WORK_ITEM_ACTION WIA 
		WHERE WI.ID = WIA.WORK_ITEM_ID AND WIA.PURGE_DT IS NULL AND WIA.ACTION_CD = 'Add Note Only' 
		AND WIA.UPDATE_USER_TX != 'UTLenderSrvc'
 		ORDER BY WIA.CREATE_DT DESC) AS AGENCY_NOTE
 	OUTER APPLY (
		SELECT TOP 1 ACTION_NOTE_TX
		FROM WORK_ITEM_ACTION WIA 
		WHERE WI.ID = WIA.WORK_ITEM_ID AND WIA.PURGE_DT IS NULL  
		AND WIA.UPDATE_USER_TX = 'UTLenderSrvc'
 		ORDER BY WIA.CREATE_DT DESC) AS LENDER_NOTE									
WHERE tmp.RowNumPerWI = 1
ORDER BY tmp.RowNumOrderBy

DROP TABLE #tmpWI

END

GO

