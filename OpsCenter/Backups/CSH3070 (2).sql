USE unitrac;

BEGIN TRAN;

-- 1. Declare Datasource
DECLARE @lender NVARCHAR(15) ='3525'; 
DECLARE @ControlNumber NVARCHAR(30) ='000000204'; 
DECLARE @ticket NVARCHAR(15) ='CSH3070'; 

--Rows want to Preserve
DECLARE @RowsToPreserve_wi bigint;
DECLARE @RowsToPreserve_esc bigint;


SELECT @RowsToPreserve_wi =  count(DISTINCT wi.ID)
			FROM WORK_ITEM wi
			join LENDER ll on ll.ID = wi.LENDER_ID
			where wi.CONTENT_XML.value('(/Content/Escrow/ControlNumber)[1]', 'nvarchar(50)') in (@ControlNumber)
			and ll.CODE_TX = @lender
			and wi.PURGE_DT is NULL;

SELECT @RowsToPreserve_esc =  count(DISTINCT esc.ID)
			FROM ESCROW esc
			JOIN LOAN ln ON ln.ID = esc.LOAN_ID AND ln.PURGE_DT IS NULL
			JOIN LENDER ll on ll.ID = ln.LENDER_ID
			WHERE ll.CODE_TX = @lender
			AND esc.CONTROL_NUMBER_TX in (@ControlNumber)
			AND esc.PURGE_DT IS NULL
			and esc.STATUS_CD = 'CLSE'

IF NOT EXISTS (SELECT *
               FROM UniTracHDStorage.sys.tables
               WHERE name LIKE @ticket+'_%' AND type IN (N'U'))
BEGIN 
		SELECT wi.*
			into UnitracHDStorage..CSH3070_wi
			FROM WORK_ITEM wi
			join LENDER ll on ll.ID = wi.LENDER_ID
			where wi.CONTENT_XML.value('(/Content/Escrow/ControlNumber)[1]', 'nvarchar(50)') in (@ControlNumber)
			and ll.CODE_TX = @lender
			and wi.PURGE_DT is NULL;


		SELECT esc.*
			into UnitracHDStorage..CSH3070_esc
			FROM ESCROW esc
			JOIN LOAN ln ON ln.ID = esc.LOAN_ID AND ln.PURGE_DT IS NULL
			JOIN LENDER ll on ll.ID = ln.LENDER_ID
			WHERE ll.CODE_TX = @lender
			AND esc.CONTROL_NUMBER_TX in (@ControlNumber)
			AND esc.PURGE_DT IS NULL
			and esc.STATUS_CD = 'CLSE'

IF(@@RowCount=@RowsToPreserve_wi)
		BEGIN
			PRINT 'Performing UPDATE - Preserve Row Count = Source Row Count';
			Update wi
			Set wi.purge_dt = GETDATE(), wi.update_dt = GETDATE(), wi.update_user_tx = @ticket
				FROM WORK_ITEM wi
				join LENDER ll on ll.ID = wi.LENDER_ID
				where wi.CONTENT_XML.value('(/Content/Escrow/ControlNumber)[1]', 'nvarchar(50)') in (@ControlNumber)
				and ll.CODE_TX = @lender
				and wi.PURGE_DT is NULL;

IF(@@RowCount=@RowsToPreserve_wi)
				BEGIN
					PRINT 'SUCCESS - UPDATE Row Count = Source Row Count';
					COMMIT;
				END;
			ELSE /* @@RowCount <> @SourceRowCount */
    			BEGIN
					PRINT 'Performing ROLLBACKUP - Update Row Count != SourceRow Count';
					ROLLBACK;
					END;
				END;


IF(@@RowCount=@RowsToPreserve_esc)
		BEGIN
			PRINT 'Performing UPDATE - Preserve Row Count = Source Row Count';
			Update esc
			Set esc.purge_dt = GETDATE(), esc.update_dt = GETDATE(), esc.update_user_tx = @ticket
			FROM ESCROW esc
			JOIN LOAN ln ON ln.ID = esc.LOAN_ID AND ln.PURGE_DT IS NULL
			JOIN LENDER ll on ll.ID = ln.LENDER_ID
			WHERE ll.CODE_TX = @lender
			AND esc.CONTROL_NUMBER_TX in (@ControlNumber)
			AND esc.PURGE_DT IS NULL
			and esc.STATUS_CD = 'CLSE'

				 IF(@@RowCount=@RowsToPreserve_esc)
				BEGIN
					PRINT 'SUCCESS - UPDATE Row Count = Source Row Count';
					COMMIT;
				END;
			ELSE /* @@RowCount <> @SourceRowCount */
    			BEGIN
					PRINT 'Performing ROLLBACKUP - Update Row Count != SourceRow Count';
					ROLLBACK;
				END;
		END;
 END
ELSE
BEGIN
		PRINT 'HD TABLE EXISTS - what are you doing?';
	ROLLBACK;
END;

