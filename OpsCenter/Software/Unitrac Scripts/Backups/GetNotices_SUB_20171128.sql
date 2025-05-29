USE [Unitrac_Reports]
GO

/****** Object:  StoredProcedure [dbo].[GetNotices]    Script Date: 11/28/2017 8:15:38 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE  PROCEDURE [dbo].[GetNotices]
(
   @id   bigint = null,
   @referenceId nvarchar(50) = null,
   @fpcId bigint = null,
   @lenderCode nvarchar(10) = null,
   @startDate datetime2 = null,
   @endDate datetime2 = null,
   @uniqueNoticeTypeSequenceSet char(1) = 'N',
   @requiredCoverageId bigint = null,
   @isServiceFeeInvoiceCall varchar(1) = null,
   @lenderId bigint = null,
   @isLenderUnitracTxnProcessCall varchar(1) = null
)
AS
BEGIN
   SET NOCOUNT ON
   if @id = 0
      set @id = null

   IF ISNULL(@id, 0) > 0
   BEGIN 
	   SELECT
         ID,
         LOAN_ID,
         FPC_ID,
         CPI_QUOTE_ID,
         TYPE_CD,
         NAME_TX,
         REFERENCE_ID_TX,
         SEQUENCE_NO,
         EXPECTED_ISSUE_DT,
         REASON_TYPE_CD,
         CLEAR_DT,
         CLEAR_REASON_CD,
         SENT_TO_TYPE_CD,
         GENERATION_SOURCE_CD,
         NOT_MAILED_IN,
         CREATED_BY_TX,
         LOCK_ID,
         CAPTURED_DATA_XML,
         NOT_MAILED_CD,
         NOT_MAILED_NOTE_TX,
         CONFIGURATION_ID,
         ISSUE_DT,
         TEMPLATE_ID,
         PDF_GENERATE_CD,
         MSG_LOG_TX,
         CREATE_DT,
         DELIVERY_METHOD_TX
	   FROM NOTICE
	   WHERE
		  ID = @id
   END
   ELSE IF ISNULL(@fpcId, 0 ) > 0 
	BEGIN 
	   SELECT
         ID,
         LOAN_ID,
         FPC_ID,
         CPI_QUOTE_ID,
         TYPE_CD,
         NAME_TX,
         REFERENCE_ID_TX,
         SEQUENCE_NO,
         EXPECTED_ISSUE_DT,
         REASON_TYPE_CD,
         CLEAR_DT,
         CLEAR_REASON_CD,
         SENT_TO_TYPE_CD,
         GENERATION_SOURCE_CD,
         NOT_MAILED_IN,
         CREATED_BY_TX,
         LOCK_ID,
         CAPTURED_DATA_XML,
         NOT_MAILED_CD,
         NOT_MAILED_NOTE_TX,
         CONFIGURATION_ID,
         ISSUE_DT,
         TEMPLATE_ID,
         PDF_GENERATE_CD,
         MSG_LOG_TX,
         CREATE_DT,
         DELIVERY_METHOD_TX 
	   FROM NOTICE
	   WHERE
		  REFERENCE_ID_TX = isnull(@referenceId, REFERENCE_ID_TX)
		  and FPC_ID = isnull(@fpcId, FPC_ID)
		  and PURGE_DT IS NULL
      END
   ELSE IF (ISNULL(@lenderCode, '') <> '' and @startDate is not null and @endDate is not null and @uniqueNoticeTypeSequenceSet = 'N')
	BEGIN 
	   SELECT
         n.ID,
         n.LOAN_ID,
         n.FPC_ID,
         n.CPI_QUOTE_ID,
         n.TYPE_CD,
         n.NAME_TX,
         n.REFERENCE_ID_TX,
         n.SEQUENCE_NO,
         n.EXPECTED_ISSUE_DT,
         n.REASON_TYPE_CD,
         n.CLEAR_DT,
         n.CLEAR_REASON_CD,
         n.SENT_TO_TYPE_CD,
         n.GENERATION_SOURCE_CD,
         n.NOT_MAILED_IN,
         n.CREATED_BY_TX,
         n.LOCK_ID,
         n.CAPTURED_DATA_XML,
         n.NOT_MAILED_CD,
         n.NOT_MAILED_NOTE_TX,
         n.CONFIGURATION_ID,
         n.ISSUE_DT,
         n.TEMPLATE_ID,
         n.PDF_GENERATE_CD,
         n.MSG_LOG_TX,
         n.CREATE_DT,
         n.DELIVERY_METHOD_TX
	   FROM NOTICE n  with (nolock)--, FORCESEEK, INDEX (IDX_NOTICE_CREATE_DT))
	     inner join LOAN loan with (nolock) on n.LOAN_ID = loan.ID and loan.purge_dt is null
	     inner join LENDER l with (nolock)  on loan.LENDER_ID = l.ID and l.purge_dt is null
	   WHERE n.CREATE_DT >= @startDate
	     and n.CREATE_DT < @endDate
         and l.CODE_TX = @lenderCode
		 and n.PURGE_DT IS NULL
   END
   ELSE IF (ISNULL(@lenderCode, '') <> '' and @startDate is not null and @endDate is not null and @uniqueNoticeTypeSequenceSet = 'Y')
	BEGIN 
	   SELECT
         ID,
         LOAN_ID,
         FPC_ID,
         CPI_QUOTE_ID,
         TYPE_CD,
         NAME_TX,
         REFERENCE_ID_TX,
         SEQUENCE_NO,
         EXPECTED_ISSUE_DT,
         REASON_TYPE_CD,
         CLEAR_DT,
         CLEAR_REASON_CD,
         SENT_TO_TYPE_CD,
         GENERATION_SOURCE_CD,
         NOT_MAILED_IN,
         CREATED_BY_TX,
         LOCK_ID,
         CAPTURED_DATA_XML,
         NOT_MAILED_CD,
         NOT_MAILED_NOTE_TX,
         CONFIGURATION_ID,
         ISSUE_DT,
         TEMPLATE_ID,
         PDF_GENERATE_CD,
         MSG_LOG_TX,
         CREATE_DT,
         DELIVERY_METHOD_TX 
	   FROM NOTICE with (nolock)
	   WHERE
         ID in (select MAX(n.ID) ID
			    from NOTICE n  with (nolock) --with (FORCESEEK, INDEX (IDX_NOTICE_CREATE_DT))
			     inner join NOTICE_REQUIRED_COVERAGE_RELATE nrcr  with (nolock) on nrcr.NOTICE_ID = n.ID and nrcr.PURGE_DT IS NULL
			     inner join REQUIRED_COVERAGE rc  with (nolock) on rc.ID = nrcr.REQUIRED_COVERAGE_ID and rc.PURGE_DT IS NULL
			     inner join PROPERTY p  with (nolock) on rc.PROPERTY_ID = p.ID and p.PURGE_DT IS NULL
			     inner join COLLATERAL c  with (nolock) on c.PROPERTY_ID = p.ID and c.PURGE_DT IS NULL
			     inner join COLLATERAL_CODE cc  with (nolock) on cc.ID = c.COLLATERAL_CODE_ID and cc.purge_dt IS NULL
			     inner join REF_CODE_ATTRIBUTE rca  with (nolock) on rca.DOMAIN_CD = 'SecondaryClassification' and cc.SECONDARY_CLASS_CD = rca.REF_CD 
			               and rca.ATTRIBUTE_CD = 'PropertyType'
				  inner join LENDER l  with (nolock) on p.LENDER_ID = l.ID and l.PURGE_DT IS NULL
                where n.CREATE_DT >= @startDate
                  and n.CREATE_DT < @endDate
                  and l.CODE_TX = @lenderCode
				  and n.PURGE_DT IS NULL
                group by rca.value_tx, rc.TYPE_CD, n.TYPE_CD, n.SEQUENCE_NO)
   END
   ELSE IF ISNULL(@requiredCoverageId, 0 ) > 0
	BEGIN 
     SELECT
         n.ID,
         n.LOAN_ID,
         n.FPC_ID,
         n.CPI_QUOTE_ID,
         n.TYPE_CD,
         n.NAME_TX,
         n.REFERENCE_ID_TX,
         n.SEQUENCE_NO,
         n.EXPECTED_ISSUE_DT,
         n.REASON_TYPE_CD,
         n.CLEAR_DT,
         n.CLEAR_REASON_CD,
         n.SENT_TO_TYPE_CD,
         n.GENERATION_SOURCE_CD,
         n.NOT_MAILED_IN,
         n.CREATED_BY_TX,
         n.LOCK_ID,
         n.CAPTURED_DATA_XML,
         n.NOT_MAILED_CD,
         n.NOT_MAILED_NOTE_TX,
         n.CONFIGURATION_ID,
         n.ISSUE_DT,
         n.TEMPLATE_ID,
         n.PDF_GENERATE_CD,
         n.MSG_LOG_TX,
         n.CREATE_DT,
         n.DELIVERY_METHOD_TX 
	   FROM NOTICE n
      JOIN NOTICE_REQUIRED_COVERAGE_RELATE NRCR ON NRCR.NOTICE_ID = n.ID
      WHERE NRCR.REQUIRED_COVERAGE_ID = @requiredCoverageId
      AND n.PURGE_DT IS NULL AND NRCR.PURGE_DT IS NULL	    
   END
   
   -- For Service Fee Invoice Calls
   ELSE if @isServiceFeeInvoiceCall is not null 
   BEGIN
      select   
         n.ID,
         n.LOAN_ID,
         n.FPC_ID,
         n.CPI_QUOTE_ID,
         n.TYPE_CD,
         n.NAME_TX,
         n.REFERENCE_ID_TX,
         n.SEQUENCE_NO,
         n.EXPECTED_ISSUE_DT,
         n.REASON_TYPE_CD,
         n.CLEAR_DT,
         n.CLEAR_REASON_CD,
         n.SENT_TO_TYPE_CD,
         n.GENERATION_SOURCE_CD,
         n.NOT_MAILED_IN,
         n.CREATED_BY_TX,
         n.LOCK_ID,
         n.CAPTURED_DATA_XML,
         n.NOT_MAILED_CD,
         n.NOT_MAILED_NOTE_TX,
         n.CONFIGURATION_ID,
         n.ISSUE_DT,
         n.TEMPLATE_ID,
         n.PDF_GENERATE_CD,
         n.MSG_LOG_TX,
         n.CREATE_DT,
         n.DELIVERY_METHOD_TX
      FROM  NOTICE n  with (nolock)
         inner join LOAN loan with (nolock) on n.LOAN_ID = loan.ID and loan.purge_dt is null
         inner join DOCUMENT_CONTAINER dc with (nolock) on n.ID = dc.RELATE_ID and dc.RELATE_CLASS_NAME_TX = 'Allied.UniTrac.Notice'
      where LENDER_ID = @lenderId
         and dc.PRINT_STATUS_CD = 'PRINTED' 
         and n.PURGE_DT is null
         and dc.PURGE_DT is null
         and dc.PRINTED_DT between @startDate and @endDate
   END 
   ELSE if @isLenderUnitracTxnProcessCall is not null 
   BEGIN
      Select n.ID,
         n.LOAN_ID,
         n.FPC_ID,
         n.CPI_QUOTE_ID,
         n.TYPE_CD,
         n.NAME_TX,
         n.REFERENCE_ID_TX,
         n.SEQUENCE_NO,
         n.EXPECTED_ISSUE_DT,
         n.REASON_TYPE_CD,
         n.CLEAR_DT,
         n.CLEAR_REASON_CD,
         n.SENT_TO_TYPE_CD,
         n.GENERATION_SOURCE_CD,
         n.NOT_MAILED_IN,
         n.CREATED_BY_TX,
         n.LOCK_ID,
         n.CAPTURED_DATA_XML,
         n.NOT_MAILED_CD,
         n.NOT_MAILED_NOTE_TX,
         n.CONFIGURATION_ID,
         n.ISSUE_DT,
         n.TEMPLATE_ID,
         n.PDF_GENERATE_CD,
         n.MSG_LOG_TX,
         n.CREATE_DT,
         n.DELIVERY_METHOD_TX
	From Notice n with (nolock) Where n.Id in 
		 (Select distinct n.ID	-- distinct to remove duplicate notices from the result set...	 
			  FROM  NOTICE n  with (nolock)
				 inner join LOAN loan with (nolock) on n.LOAN_ID = loan.ID and loan.purge_dt is null
				 inner join DOCUMENT_CONTAINER dc with (nolock) on n.ID = dc.RELATE_ID and dc.RELATE_CLASS_NAME_TX = 'Allied.UniTrac.Notice'
				 LEFT OUTER JOIN LENDER_UNITRAC_TRANSACTION lut on lut.TYPE_CD_TX = 'SENDNOTICE' AND lut.RELATE_CLASS_ID = n.ID and lut.RELATE_CLASS_NAME_TX = 'Allied.UniTrac.Notice'
				 AND lut.PURGE_DT IS NULL
			  where LENDER_ID = @lenderId
				 and dc.PRINT_STATUS_CD = 'PRINTED' 
				 and n.PURGE_DT is null
				 and dc.PURGE_DT is null
				 and lut.id is null)
   
   END    
   ELSE
	BEGIN
		-- FALL THROUGH...ASSUMES REFERENCE_ID IS NOT NULL
		SELECT
         ID,
         LOAN_ID,
         FPC_ID,
         CPI_QUOTE_ID,
         TYPE_CD,
         NAME_TX,
         REFERENCE_ID_TX,
         SEQUENCE_NO,
         EXPECTED_ISSUE_DT,
         REASON_TYPE_CD,
         CLEAR_DT,
         CLEAR_REASON_CD,
         SENT_TO_TYPE_CD,
         GENERATION_SOURCE_CD,
         NOT_MAILED_IN,
         CREATED_BY_TX,
         LOCK_ID,
         CAPTURED_DATA_XML,
         NOT_MAILED_CD,
         NOT_MAILED_NOTE_TX,
         CONFIGURATION_ID,
         ISSUE_DT,
         TEMPLATE_ID,
         PDF_GENERATE_CD,
         MSG_LOG_TX,
         CREATE_DT,
         DELIVERY_METHOD_TX
	   FROM NOTICE
	   WHERE
		  REFERENCE_ID_TX=@referenceId
	   AND PURGE_DT IS NULL
	   ORDER BY CREATE_DT DESC
	END
END

GO

