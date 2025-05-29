USE [Unitrac_Reports]
GO

/****** Object:  StoredProcedure [dbo].[GetEscrowExceptionReasons]    Script Date: 2/25/2019 8:57:51 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[GetEscrowExceptionReasons]
(
	@lenderId BIGINT,
	@escrowId BIGINT
)
AS
BEGIN
	SET NOCOUNT ON

	DECLARE @ediCount INT

	--If escrow if from EDI, then ignore exception checks
	SELECT @ediCount = COUNT(*)
	FROM ESCROW esc
		JOIN INTERACTION_HISTORY ih ON ih.PROPERTY_ID = esc.PROPERTY_ID AND ih.RELATE_ID = esc.ID AND ih.TYPE_CD = 'ESCROW' AND ih.PURGE_DT IS NULL
	WHERE esc.ID = @escrowId
	AND ih.SPECIAL_HANDLING_XML.value('(/SH/Source)[1]', 'nvarchar(10)') = 'EDI'

	IF @ediCount > 0
	BEGIN
		RETURN
	END

	SELECT distinct eed.ID, eed.REASON_CD, eed.FUNCTION_NAME_TX
	into #tmpLenderCodes
	FROM ESCROW_EXCEPTION_DEFINITION eed
	JOIN ESCROW_EXCEPTION_DEFINITION_LENDER_RELATE rel on rel.LENDER_ID = @lenderId

    Create table #tmpOutCodes
    (
        ReasonCode nvarchar(30)
    )

	DECLARE @tableID bigint
	DECLARE @reasonCd as nvarchar(30)
	DECLARE @fnName as nvarchar(100)
	DECLARE @sql as nvarchar(max)

	while exists (select * from #tmpLenderCodes)
	begin

		select top 1 @TableID = ID, @reasonCd = REASON_CD, @fnName = FUNCTION_NAME_TX
		from #tmpLenderCodes
		order by ID asc

		--Check if function exists
		IF OBJECT_ID(@fnName) IS NOT NULL
		BEGIN

			-- create sql for the function call
			select @sql = 'select dbo.' + @fnName + '(' + cast(@escrowId as varchar(20)) + ')'

			--add result of function call to output table
			insert into	#tmpOutCodes
			exec sys.sp_executesql @sql, N'@escrowId bigint', @escrowId
			
		END		

		delete #tmpLenderCodes where ID = @TableID

	end

   delete from #tmpOutCodes where ReasonCode is null

   select ReasonCode from #tmpOutCodes

END

GO

