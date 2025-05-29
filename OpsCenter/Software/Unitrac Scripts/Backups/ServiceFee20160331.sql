USE [UniTrac]
GO

/****** Object:  StoredProcedure [dbo].[Report_ServiceFeeInvoice]    Script Date: 3/31/2016 8:58:42 AM ******/
DROP PROCEDURE [dbo].[Report_ServiceFeeInvoice]
GO

/****** Object:  StoredProcedure [dbo].[Report_ServiceFeeInvoice]    Script Date: 3/31/2016 8:58:42 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[Report_ServiceFeeInvoice]
(
   @relateId bigint,
   @startDate datetime,
   @Report_History_ID bigint = null
)
AS
BEGIN

   -- Local Variables
   declare @RecordCount as bigint

   -- Get the first day of the prior month to the start date
   -- passed and retrieve the bill period and year from that
   declare @firstDayOfLastMonth datetime = DATEADD(month, DATEDIFF(month, 0, @startDate)-1, 0)
   declare @billPeriod int = MONTH(@firstDayOfLastMonth)
   declare @billYear int = YEAR(@firstDayOfLastMonth)

   -- Holds the Output Table Data
   declare @reportData as table (
      InvoiceFeeItemDescription varchar(255),
      UnitType varchar(255),
      LoanNumber varchar(255),
      Name varchar(255),
      Branch varchar(255),
      LoanEffectiveDate datetime,
      LoanCreateDate datetime,
      CollateralDescription varchar(255),
      CollateralCode varchar(255),
      PrimaryClass varchar(255),
      SecondaryClass varchar(255),
      Coverage varchar(255),
      DateofItem datetime
   )

   -- Holds the Service Fee Invoice Item Temp Table
   declare @sfiiTable as table (
      SFIIID bigint, 
      UnitType varchar(255),
      ItemName varchar(255),
      InvoiceDescription varchar(255)
   )
   insert into @sfiiTable
   select   sfii.ID,
            sfiic.UNIT_TYPE_CD,
            sfiic.NAME_TX,
            sfic.NAME_TX
   from     SERVICE_FEE_INVOICE sfi
            inner join SERVICE_FEE_INVOICE_CONFIG sfic on sfic.ID = sfi.SFIC_ID
            inner join SERVICE_FEE_INVOICE_ITEM sfii on sfii.SFI_ID = sfi.ID
            inner join SERVICE_FEE_INVOICE_ITEM_CONFIG sfiic on sfii.SFIIC_ID = sfiic.ID
   where    sfi.ID = @relateId
            and sfii.BILL_PERIOD_NO = @billPeriod
            and sfii.BILL_YEAR_NO = @billYear

   -- Cursor Thru all the Unit Types and All Report Data Rows
   DECLARE sfiiUnitTypeCursor CURSOR FOR 
   select   distinct UnitType
   from     @sfiiTable

   declare @unitType as varchar(255)

   OPEN sfiiUnitTypeCursor   
   FETCH NEXT FROM sfiiUnitTypeCursor INTO @unitType   

   WHILE @@FETCH_STATUS = 0   
   BEGIN   
   
      -- For Loan Count Reports
      if @unitType = 'LOANCNT' or @unitType = 'NEWLOANCNT'
         insert into @reportData
         (InvoiceFeeItemDescription,UnitType,LoanNumber,Name,Branch,LoanEffectiveDate,LoanCreateDate)
         select   sfiit.InvoiceDescription,
                  @unitType,
                  l.NUMBER_TX,
                  sfiit.ItemName,
                  l.LENDER_BRANCH_CODE_TX,
                  l.EFFECTIVE_DT,
                  l.CREATE_DT
         from     @sfiiTable sfiit
                  inner join SERVICE_FEE_INVOICE_ITEM_DETAIL sfiid on sfiit.SFIIID = sfiid.SFII_ID
                  inner join LOAN l on sfiid.RELATE_ID = l.id
         where    sfiit.UnitType = @unitType

      -- For Collateral Count Reports
      else if @unitType = 'COLLCNT'
         insert into @reportData
         (InvoiceFeeItemDescription,UnitType,LoanNumber,Name,Branch,LoanEffectiveDate,LoanCreateDate,CollateralDescription,CollateralCode,PrimaryClass,SecondaryClass)
         select   sfiit.InvoiceDescription,
                  @unitType,
                  l.NUMBER_TX,
                  sfiit.ItemName,
                  l.LENDER_BRANCH_CODE_TX,
                  l.EFFECTIVE_DT,
                  l.CREATE_DT,
                  cc.DESCRIPTION_TX,
                  c.COLLATERAL_CODE_ID,
                  cc.PRIMARY_CLASS_CD,
                  cc.SECONDARY_CLASS_CD              
         from     @sfiiTable sfiit
                  inner join SERVICE_FEE_INVOICE_ITEM_DETAIL sfiid on sfiit.SFIIID = sfiid.SFII_ID
                  inner join COLLATERAL c on sfiid.RELATE_ID = c.id
                  inner join COLLATERAL_CODE cc on cc.ID = c.COLLATERAL_CODE_ID
                  inner join LOAN l on c.LOAN_ID = l.id
         where    sfiit.UnitType = @unitType

      -- For Required Coverage Count Reports
      else if @unitType = 'CVGCNT'
         insert into @reportData
         (InvoiceFeeItemDescription,UnitType,LoanNumber,Name,Branch,LoanEffectiveDate,LoanCreateDate,CollateralDescription,CollateralCode,PrimaryClass,SecondaryClass,Coverage)
         select   sfiit.InvoiceDescription,
                  @unitType,
                  l.NUMBER_TX,
                  sfiit.ItemName,
                  l.LENDER_BRANCH_CODE_TX,
                  l.EFFECTIVE_DT,
                  l.CREATE_DT,
                  cc.DESCRIPTION_TX,
                  c.COLLATERAL_CODE_ID,
                  cc.PRIMARY_CLASS_CD,
                  cc.SECONDARY_CLASS_CD,
                  rc.TYPE_CD
         from     @sfiiTable sfiit
                  inner join SERVICE_FEE_INVOICE_ITEM_DETAIL sfiid on sfiit.SFIIID = sfiid.SFII_ID
                  inner join REQUIRED_COVERAGE rc on sfiid.RELATE_ID = rc.id
                  inner join COLLATERAL c on rc.PROPERTY_ID = c.PROPERTY_ID
                  inner join COLLATERAL_CODE cc on cc.ID = c.COLLATERAL_CODE_ID
                  inner join LOAN l on c.LOAN_ID = l.id 
         where    RELATE_CLASS_TX = 'Allied.UniTrac.RequiredCoverage'
                  and sfiit.UnitType = @unitType
                  and c.PRIMARY_LOAN_IN = 'Y'

      -- For OBC Count Reports
      else if @unitType = 'OBCCNT'
         insert into @reportData
         (InvoiceFeeItemDescription,UnitType,LoanNumber,Name,Branch,LoanEffectiveDate,LoanCreateDate,CollateralDescription,CollateralCode,PrimaryClass,SecondaryClass,Coverage,DateofItem)
         select   sfiit.InvoiceDescription,
                  @unitType,
                  l.NUMBER_TX,
                  sfiit.ItemName,
                  l.LENDER_BRANCH_CODE_TX,
                  l.EFFECTIVE_DT,
                  l.CREATE_DT,
                  cc.DESCRIPTION_TX,
                  c.COLLATERAL_CODE_ID,
                  cc.PRIMARY_CLASS_CD,
                  cc.SECONDARY_CLASS_CD,
                  rc.TYPE_CD,
                  wi.UPDATE_DT
         from     @sfiiTable sfiit
                  inner join SERVICE_FEE_INVOICE_ITEM_DETAIL sfiid on sfiit.SFIIID = sfiid.SFII_ID
                  inner join WORK_ITEM wi on sfiid.RELATE_ID = wi.ID
                  inner join INTERACTION_HISTORY ih ON ih.ID = wi.RELATE_ID
                  inner join REQUIRED_COVERAGE rc on rc.id = ih.SPECIAL_HANDLING_XML.value('(/SH/RC)[1]', 'bigint')
                  inner join COLLATERAL c on rc.PROPERTY_ID = c.PROPERTY_ID
                  inner join COLLATERAL_CODE cc on cc.ID = c.COLLATERAL_CODE_ID
                  inner join LOAN l on c.LOAN_ID = l.id 
         where    sfiid.RELATE_CLASS_TX = 'Allied.UniTrac.Workflow.OutboundCallWorkItem'
                  and sfiit.UnitType = @unitType
                  and c.PRIMARY_LOAN_IN = 'Y'

      -- For Escrow Count Reports
      else if @unitType = 'ESCROWCNT'
         insert into @reportData
         (InvoiceFeeItemDescription,UnitType,LoanNumber,Name,Branch,LoanEffectiveDate,LoanCreateDate,DateofItem)
         select   sfiit.InvoiceDescription,
                  @unitType,
                  l.NUMBER_TX,
                  sfiit.ItemName,
                  l.LENDER_BRANCH_CODE_TX,
                  l.EFFECTIVE_DT,
                  l.CREATE_DT,
                  esc.REPORTED_DT
         from     @sfiiTable sfiit
                  inner join SERVICE_FEE_INVOICE_ITEM_DETAIL sfiid on sfiit.SFIIID = sfiid.SFII_ID
                  inner join ESCROW esc on sfiid.RELATE_ID = esc.ID
                  inner join LOAN l on esc.LOAN_ID = l.id 
         where    sfiid.RELATE_CLASS_TX = 'Allied.UniTrac.Escrow'
                  and sfiit.UnitType = @unitType
               
      -- For Letter Count Reports
      else if @unitType = 'LTRCNT'
         insert into @reportData
         (InvoiceFeeItemDescription,UnitType,LoanNumber,Name,Branch,LoanEffectiveDate,LoanCreateDate,CollateralDescription,CollateralCode,PrimaryClass,SecondaryClass,Coverage,DateofItem)
         select   sfiit.InvoiceDescription,
                  @unitType,
                  l.NUMBER_TX,
                  sfiit.ItemName,
                  l.LENDER_BRANCH_CODE_TX,
                  l.EFFECTIVE_DT,
                  l.CREATE_DT,
                  cc.DESCRIPTION_TX,
                  c.COLLATERAL_CODE_ID,
                  cc.PRIMARY_CLASS_CD,
                  cc.SECONDARY_CLASS_CD,
                  rc.TYPE_CD,
                  dc.PRINTED_DT
         from     @sfiiTable sfiit
                  inner join SERVICE_FEE_INVOICE_ITEM_DETAIL sfiid on sfiit.SFIIID = sfiid.SFII_ID
                  inner join NOTICE n on sfiid.RELATE_ID = n.ID
                  inner join DOCUMENT_CONTAINER dc on n.ID = dc.RELATE_ID and dc.RELATE_CLASS_NAME_TX = 'Allied.UniTrac.Notice'
                  inner join LOAN l on n.LOAN_ID = l.ID
                  inner join COLLATERAL c on l.ID = c.LOAN_ID
                  inner join COLLATERAL_CODE cc on cc.ID = c.COLLATERAL_CODE_ID
                  inner join REQUIRED_COVERAGE rc on rc.PROPERTY_ID = c.PROPERTY_ID
         where    sfiit.UnitType = @unitType
         order by c.ID

      -- For Certificate Count Reports
      else if @unitType = 'CERTCNT'
      begin

         -- Holds the Temporary Data Table
         declare @reportDataTemp as table (
            DocumentRelateId varchar(255),
            DateofItem datetime
         )

         /* Cursor thru the details and determine the most recent printed date per detail item */
         DECLARE dateCursor CURSOR FOR 
         select   distinct
                  sfiid.RELATE_ID
         from     @sfiiTable sfiit
                  inner join SERVICE_FEE_INVOICE_ITEM_DETAIL sfiid on sfiit.SFIIID = sfiid.SFII_ID
         where    sfiit.UnitType = @unitType

         declare @dcRelateId bigint

         OPEN dateCursor
         FETCH NEXT FROM dateCursor INTO @dcRelateId
         WHILE @@FETCH_STATUS = 0
         BEGIN

            insert into @reportDataTemp
            select   top 1 
                     RELATE_ID,
                     PRINTED_DT 
            from     DOCUMENT_CONTAINER
            where    RELATE_ID = @dcRelateId
            order by PRINTED_DT desc

            FETCH NEXT FROM dateCursor INTO @dcRelateId
         END
         CLOSE dateCursor
         DEALLOCATE dateCursor
         
         insert into @reportData
         (InvoiceFeeItemDescription,UnitType,LoanNumber,Name,Branch,LoanEffectiveDate,LoanCreateDate,CollateralDescription,CollateralCode,PrimaryClass,SecondaryClass,Coverage,DateofItem)
         select   distinct
                  sfiit.InvoiceDescription,
                  @unitType,
                  l.NUMBER_TX,
                  sfiit.ItemName,
                  l.LENDER_BRANCH_CODE_TX,
                  l.EFFECTIVE_DT,
                  l.CREATE_DT,
                  cc.DESCRIPTION_TX,
                  c.COLLATERAL_CODE_ID,
                  cc.PRIMARY_CLASS_CD,
                  cc.SECONDARY_CLASS_CD,
                  rc.TYPE_CD,
                  rdt.DateofItem
         from     @sfiiTable sfiit
                  inner join SERVICE_FEE_INVOICE_ITEM_DETAIL sfiid on sfiit.SFIIID = sfiid.SFII_ID
                  inner join @reportDataTemp rdt on rdt.DocumentRelateId = sfiid.RELATE_ID
                  inner join FORCE_PLACED_CERTIFICATE fpc on sfiid.RELATE_ID = fpc.ID
                  inner join DOCUMENT_CONTAINER dc on fpc.ID = dc.RELATE_ID and dc.RELATE_CLASS_NAME_TX = 'Allied.UniTrac.ForcePlacedCertificate'
                  inner join LOAN l on fpc.LOAN_ID = l.ID
                  inner join COLLATERAL c on l.ID = c.LOAN_ID
                  inner join COLLATERAL_CODE cc on cc.ID = c.COLLATERAL_CODE_ID
                  inner join REQUIRED_COVERAGE rc on rc.PROPERTY_ID = c.PROPERTY_ID
         where    sfiit.UnitType = @unitType
                  
      end

      FETCH NEXT FROM sfiiUnitTypeCursor INTO @unitType   
   END   

   CLOSE sfiiUnitTypeCursor
   DEALLOCATE sfiiUnitTypeCursor

   -- Return the Report Data
   select   *
   from     @reportData
   
   -- Get the Record Count
   select @RecordCount = @@rowcount

   IF @Report_History_ID IS NOT NULL
   BEGIN
     UPDATE REPORT_HISTORY
     SET RECORD_COUNT_NO = @RecordCount
     WHERE ID = @Report_History_ID
   END

END


GO

