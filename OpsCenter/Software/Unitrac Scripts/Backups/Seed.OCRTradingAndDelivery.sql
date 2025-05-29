-- This is the seeding file for setting up OCR in UniTrac

SET QUOTED_IDENTIFIER ON
GO

--  OCRInboundProcess Definition
IF NOT EXISTS(SELECT * FROM PROCESS_DEFINITION WHERE PROCESS_TYPE_CD = 'OCRINPRCPA')
BEGIN
	INSERT INTO PROCESS_DEFINITION
		(
			NAME_TX
			,DESCRIPTION_TX
			,EXECUTION_FREQ_CD
			,PROCESS_TYPE_CD
			,PRIORITY_NO
			,ACTIVE_IN
			,CREATE_DT
			,UPDATE_DT
			,UPDATE_USER_TX
			,LOCK_ID
			,SETTINGS_XML_IM
			,INCLUDE_WEEKENDS_IN
			,INCLUDE_HOLIDAYS_IN
			,DAYS_OF_WEEK_XML
			,LAST_SCHEDULED_DT
			,OVERRIDE_DT
			,SCHEDULE_GROUP
			,STATUS_CD
			,ONHOLD_IN
			,FREQ_MULTIPLIER_NO
			,CHECKED_OUT_OWNER_ID
			,CHECKED_OUT_DT
		)
		VALUES
			(	N'OCR Inbound' /* NAME_TX - NVARCHAR(100) */
				,N'OCR Inbound' /* DESCRIPTION_TX - NVARCHAR(2000) */
				,N'HOUR' /* EXECUTION_FREQ_CD - NVARCHAR(10) NOT NULL */
				,N'OCRINPRCPA' /* PROCESS_TYPE_CD - NVARCHAR(10) NOT NULL */
				,1 /* PRIORITY_NO - INT */
				,'Y' /* ACTIVE_IN - CHAR(1) NOT NULL */
				,GETDATE() /* 'YYYY-MM-DD hh:mm:ss[.nnn]' CREATE_DT - DATETIME NOT NULL */
				,GETDATE() /* 'YYYY-MM-DD hh:mm:ss[.nnn]' UPDATE_DT - DATETIME NOT NULL */
				,N'Task42980' /* UPDATE_USER_TX - NVARCHAR(15) NOT NULL */
				,1 /* LOCK_ID - NUMERIC(4, 0) NOT NULL */
				,'<ProcessDefinitionSettings>
					  <LastProcessedDate>9/9/2012 5:09:08 AM</LastProcessedDate>
					  <TargetServerList>
						<TargetServer />
					  </TargetServerList>
					  <TargetServiceList>
						<TargetService>DirectoryWatcherServerIn</TargetService>
					  </TargetServiceList>
					  <PredecessorProcessList>
						<PredecessorProcess />
					  </PredecessorProcessList>
					   <SupportedTPTypes>
						<TPType>LFP_TP</TPType>
						<TPType>EDI_TP</TPType>
						<TPType>IDR_TP</TPType>
					   </SupportedTPTypes>
					  <AnticipatedNextScheduledDate>9/21/2013 9:37:00 PM</AnticipatedNextScheduledDate>
				</ProcessDefinitionSettings>' /* SETTINGS_XML_IM - XML NOT NULL */
				,'Y' /* INCLUDE_WEEKENDS_IN - CHAR(1) NOT NULL */
				,'Y' /* INCLUDE_HOLIDAYS_IN - CHAR(1) NOT NULL */
				,NULL /* DAYS_OF_WEEK_XML - XML */
				,GETDATE() /* 'YYYY-MM-DD hh:mm:ss[.nnn]' LAST_SCHEDULED_DT - DATETIME */
				,GETDATE() /* 'YYYY-MM-DD hh:mm:ss[.nnn]' OVERRIDE_DT - DATETIME */
				,0 /* SCHEDULE_GROUP - BIGINT */
				,DEFAULT /* STATUS_CD - NVARCHAR(10) */
				,'N' /* ONHOLD_IN - CHAR(1) NOT NULL */
				,1 /* FREQ_MULTIPLIER_NO - INT NOT NULL */
				,0 /* CHECKED_OUT_OWNER_ID - BIGINT */
				,NULL/* 'YYYY-MM-DD hh:mm:ss[.nnn]' CHECKED_OUT_DT - DATETIME */
			)
END
ELSE 
BEGIN
	UPDATE PROCESS_DEFINITION
	SET SETTINGS_XML_IM = '<ProcessDefinitionSettings>
						  <LastProcessedDate>9/9/2012 5:09:08 AM</LastProcessedDate>
						  <TargetServerList>
							<TargetServer />
						  </TargetServerList>
						  <TargetServiceList>
							<TargetService>DirectoryWatcherServerIn</TargetService>
						  </TargetServiceList>
						  <PredecessorProcessList>
							<PredecessorProcess />
						  </PredecessorProcessList>
						   <SupportedTPTypes>
							<TPType>LFP_TP</TPType>
							<TPType>EDI_TP</TPType>
							<TPType>IDR_TP</TPType>
						   </SupportedTPTypes>
						  <AnticipatedNextScheduledDate>9/21/2013 9:37:00 PM</AnticipatedNextScheduledDate>
					</ProcessDefinitionSettings>'
	WHERE PROCESS_TYPE_CD = 'OCRINPRCPA'
END
GO

-- CONNECTION_DESCRIPTOR
-- This will need to be deleted and changed if the KOFAX database holding the OutputImages table moves
-- The name of the database, if changed, is also referenced in the OCRInboundProcess code
IF NOT EXISTS(SELECT * FROM CONNECTION_DESCRIPTOR CD WHERE CD.SERVER_TX = '10.10.18.21' AND DATABASE_NM = 'OCR')
BEGIN
	INSERT INTO CONNECTION_DESCRIPTOR
	(
		NAME_TX,
		PROVIDER_TX,
		SERVER_TX,
		DATABASE_NM,
		USERNAME_TX,
		PASSWORD_TX,
		CONNECTION_LIMIT,
		CREATE_DT,
		UPDATE_DT,
		PURGE_DT,
		UPDATE_USER,
		LOCK_ID
	)
	VALUES
	(	
		'OCR',
		'SS',
		'10.10.18.21',
		'OCR',
		'ykGX/FdKYchEg5OZ0B7PIA==',
		'ykGX/FdKYchEg5OZ0B7PIA==',
		10,
		GETDATE(),
		GETDATE(),
		NULL,
		'Task42977',
		1
	)
END


-- OCR Trading Partner
IF NOT EXISTS(SELECT * FROM TRADING_PARTNER WHERE NAME_TX = 'KOFAX')
BEGIN
	INSERT INTO TRADING_PARTNER(
		EXTERNAL_ID_TX	
		,NAME_TX	
		,TYPE_CD	
		,STATUS_CD	
		,RECEIVE_FROM_TP_ID	
		,DELIVER_TO_TP_ID	
		,UPDATE_DT	
		,UPDATE_USER_TX	
		,PURGE_DT	
		,LOCK_ID	
		,ACTIVE_IN	
		,TRANSACTION_XSLT	
		,DELIVER_TO_TP_IN	
		,CREATE_DT
	)
	VALUES(
		'KOFAX'	
		,'KOFAX'	
		,'OCR_TP'	
		,'ACTIVE'	
		,NULL	
		,NULL	
		,GETDATE()	
		,'Task42980'	
		,NULL	
		,1
		,'Y'	
		,NULL	
		,'N'	
		,GETDATE()
	)
END

-- OCR Delivery Info
IF NOT EXISTS(SELECT * FROM DELIVERY_INFO WHERE TRADING_PARTNER_ID = (SELECT ID FROM TRADING_PARTNER WHERE NAME_TX = 'KOFAX') AND DELIVERY_TYPE_CD = 'OCR')
BEGIN
	INSERT INTO DELIVERY_INFO (
		TRADING_PARTNER_ID	
		,DOCUMENT_TYPE_CD	
		,DELIVERY_TYPE_CD	
		,FILESIZE_VARIANCE_NO	
		,DELIVERY_FREQ_CD	
		,PREPROCESS_TYPE_CD	
		,OVERDUE_DELIVERY_THRESHOLD_NO	
		,FILE_FORMAT_TYPE_CD	
		,BRANCH_ID	
		,UPDATE_DT	
		,UPDATE_USER_TX	
		,PURGE_DT	
		,LOCK_ID	
		,ACTIVE_IN)
	VALUES(
		(SELECT ID FROM TRADING_PARTNER WHERE NAME_TX = 'KOFAX')	
		,'ALL'	
		,'OCR'	
		,3.00	
		,'MONTHLY'		
		,''
		,0	
		,''
		,''		
		,GETDATE()	
		,'Task42980'	
		,NULL	
		,1	
		,'Y')
END

IF NOT EXISTS(SELECT * FROM DELIVERY_INFO_DELIVER_TO_TP_RELATE WHERE DELIVERY_INFO_ID = (SELECT ID FROM DELIVERY_INFO WHERE DELIVERY_TYPE_CD = 'OCR'))
BEGIN
	INSERT INTO DELIVERY_INFO_DELIVER_TO_TP_RELATE (
			DELIVERY_INFO_ID	
			,DELIVER_TO_TP_ID	
			,CREATE_DT	
			,UPDATE_DT	
			,UPDATE_USER_TX	
			,PURGE_DT	
			,LOCK_ID
	)
	VALUES(
		(SELECT ID FROM DELIVERY_INFO WHERE  DELIVERY_TYPE_CD = 'OCR')	
		,(SELECT ID FROM TRADING_PARTNER WHERE TYPE_CD = 'UNITRAC_TP' and NAME_TX = 'UniTrac')
		,GETDATE()	
		,GETDATE()	
		,'Task42980'	
		,NULL	
		,1
)
END

-- delivery info group
IF NOT EXISTS(SELECT * FROM DELIVERY_INFO_GROUP WHERE DELIVERY_INFO_ID = (SELECT ID FROM DELIVERY_INFO WHERE  DELIVERY_TYPE_CD = 'OCR'))
BEGIN
	INSERT INTO DELIVERY_INFO_GROUP (
		DELIVERY_INFO_ID	
		,NAME_TX	
		,ORDER_NO	
		,UPDATE_DT	
		,UPDATE_USER_TX	
		,PURGE_DT	
		,LOCK_ID
	)
	VALUES(
		(SELECT ID FROM DELIVERY_INFO WHERE  DELIVERY_TYPE_CD = 'OCR')	
		,'.*.ASC'
		,1	
		,GETDATE()	
		,'Task42980'	
		,NULL	
		,1
)
END

-- delivery details
IF NOT EXISTS(select * from DELIVERY_DETAIL where DELIVERY_INFO_GROUP_ID = 
	(SELECT ID FROM DELIVERY_INFO_GROUP WHERE DELIVERY_INFO_ID = (SELECT ID FROM DELIVERY_INFO WHERE  DELIVERY_TYPE_CD = 'OCR')))
BEGIN
	INSERT INTO DELIVERY_DETAIL (
		DELIVERY_INFO_GROUP_ID	
		,DELIVERY_CODE_TX	
		,VALUE_TX	
		,UPDATE_DT	
		,UPDATE_USER_TX	
		,PURGE_DT	
		,LOCK_ID

	)
	VALUES(
		(SELECT ID FROM DELIVERY_INFO_GROUP WHERE DELIVERY_INFO_ID = (SELECT ID FROM DELIVERY_INFO WHERE  DELIVERY_TYPE_CD = 'OCR'))	
		,'CreateTxn'	
		,'Y'	
		,GETDATE()
		,'Task42980'	
		,NULL	
		,1

)
END

-- PREPROCESSING DETAILS
-- first transformation from db gen XML to InsuranceDocument format
 IF NOT EXISTS(SELECT * FROM PREPROCESSING_DETAIL WHERE ORDER_NO = '1' AND DELIVERY_INFO_GROUP_ID = 
 (SELECT ID FROM DELIVERY_INFO_GROUP WHERE DELIVERY_INFO_ID = (SELECT ID FROM DELIVERY_INFO WHERE  DELIVERY_TYPE_CD = 'OCR')))
BEGIN
	INSERT INTO PREPROCESSING_DETAIL
	(
		DELIVERY_INFO_GROUP_ID	
		,ORDER_NO	
		,TYPE_CD	
		,VALUE_TX	
		,CODE_CD	
		,UPDATE_DT	
		,UPDATE_USER_TX	
		,PURGE_DT	
		,LOCK_ID
)
	VALUES(
		(SELECT ID FROM DELIVERY_INFO_GROUP WHERE DELIVERY_INFO_ID = (SELECT ID FROM DELIVERY_INFO WHERE  DELIVERY_TYPE_CD = 'OCR'))	
		,1	
		,'XSLT'
		,'xml to xml' 	
		,'db to xml transform'	
		,GETDATE()	
		,'Task42977'	
		,NULL	
		,1
	)
END

-- Second transformation from XML InsuranceDocument to wrapped in transaction XML
 IF NOT EXISTS(SELECT * FROM PREPROCESSING_DETAIL WHERE ORDER_NO = '2' AND DELIVERY_INFO_GROUP_ID = 
 (SELECT ID FROM DELIVERY_INFO_GROUP WHERE DELIVERY_INFO_ID = (SELECT ID FROM DELIVERY_INFO WHERE  DELIVERY_TYPE_CD = 'OCR')))
BEGIN
	INSERT INTO PREPROCESSING_DETAIL
	(
		DELIVERY_INFO_GROUP_ID	
		,ORDER_NO	
		,TYPE_CD	
		,VALUE_TX	
		,CODE_CD	
		,UPDATE_DT	
		,UPDATE_USER_TX	
		,PURGE_DT	
		,LOCK_ID
)
	VALUES(
		(SELECT ID FROM DELIVERY_INFO_GROUP WHERE DELIVERY_INFO_ID = (SELECT ID FROM DELIVERY_INFO WHERE  DELIVERY_TYPE_CD = 'OCR'))	
		,2	
		,'XSLT'	
		,'xml to xml' 	
		,'wrap w trans element'	
		,GETDATE()	
		,'Task42977'	
		,NULL	
		,1
	)
END

-- ppdattribute
-- Initial transform to InsuranceDocument
-- if OCRtoIDRTransform.xslt is changed, this needs to be updated
IF NOT EXISTS (select * from PPDATTRIBUTE where PREPROCESSING_DETAIL_ID =
	(SELECT ID FROM PREPROCESSING_DETAIL WHERE ORDER_NO = '1' AND DELIVERY_INFO_GROUP_ID = 
	(SELECT ID FROM DELIVERY_INFO_GROUP WHERE DELIVERY_INFO_ID = (SELECT ID FROM DELIVERY_INFO WHERE  DELIVERY_TYPE_CD = 'OCR'))))
BEGIN
	INSERT INTO PPDATTRIBUTE
	(
		PREPROCESSING_DETAIL_ID	
		,VALUE_TX	
		,CODE_CD	
		,CREATE_DT	
		,UPDATE_DT	
		,UPDATE_USER_TX	
		,PURGE_DT	
		,LOCK_ID	
		,VALUE_XML	
		,COMMON_STYLESHEET_ID
)
	VALUES(
		(SELECT ID FROM PREPROCESSING_DETAIL WHERE ORDER_NO = '1' AND DELIVERY_INFO_GROUP_ID = 
 (SELECT ID FROM DELIVERY_INFO_GROUP WHERE DELIVERY_INFO_ID = (SELECT ID FROM DELIVERY_INFO WHERE  DELIVERY_TYPE_CD = 'OCR')))	
		,'XSLT XML'	
		,'XSLTScript'	
		,GETDATE()	
		,GETDATE()	
		,'Task42977'	
		,NULL	
		,1	
		 ,'<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:OS="urn:osprey-solutions" xmlns:fn="fn" exclude-result-prefixes=" OS fn msxsl">
  <xsl:output indent="yes" encoding="US-ASCII" method="xml"/>
  <!-- ******************************************Main Template ******************************************-->
  <xsl:template match="/" name="main">
    <Message>
      <!-- TODO: -->
      <!--		<xsl:attribute name="Date"/>
			<xsl:attribute name="Time"/> -->
      <xsl:attribute name="InterchangeControlNumber"/>
      <xsl:attribute name="GroupControlNumber"/>
      <TradingPartnerDirectory>
        <SenderName/>
        <SenderId/>
        <RecipientName/>
        <RecipientId/>
      </TradingPartnerDirectory>
      <xsl:for-each select="/TRANSACTION/OUTPUTIMAGES">
        <xsl:if test="position() = 1">
          <!-- header info -->
          <IDRHeader>
            <xsl:call-template name="IDRHeader"/>
          </IDRHeader>
        </xsl:if>
      </xsl:for-each>
      <xsl:for-each select="/TRANSACTION/OUTPUTIMAGES">
        <!-- header info -->
        <InsuranceDocument>
          <xsl:call-template name="InsuranceDocumentDetails"/>
        </InsuranceDocument>
      </xsl:for-each>
    </Message>
  </xsl:template>
  <!-- ******************************************* Header ******************************************************************************-->
  <xsl:template name="IDRHeader">
    <xsl:attribute name="BatchNumber">
      <xsl:value-of select="BatchID"/>
    </xsl:attribute>
    <xsl:attribute name="LenderId">
      <xsl:value-of select="LenderID"/>
    </xsl:attribute>
  </xsl:template>
  <!-- ******************************************* Insurance Document Details Template *******************************************-->
  <xsl:template name="InsuranceDocumentDetails">
    <xsl:attribute name="Id">
      <xsl:value-of select="DocumentPath"/>
    </xsl:attribute>
    <xsl:attribute name="DocumentType">
      <xsl:value-of select="TransactionType"/>
    </xsl:attribute>
    <xsl:attribute name="LoanNumber">
      <xsl:value-of select="LoanNumber"/>
    </xsl:attribute>
    <Policy>
      <xsl:if test="string-length(PolicyNumber)>0">
        <xsl:attribute name="Number">
          <xsl:value-of select="PolicyNumber"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="string-length(MailDate)>0">
        <MailDate>
          <xsl:call-template name="FormatDate">
            <xsl:with-param name="date" select="MailDate"/>
          </xsl:call-template>
        </MailDate>
      </xsl:if>
      <xsl:if test="string-length(EffectiveDate)>0 ">
        <!-- Initially had the condition to not send the field when Cancel or Reinstatement -  and (F18 != ''R'' or F18 != ''C'') -->
        <EffectiveDate>
          <xsl:call-template name="FormatDate">
            <xsl:with-param name="date" select="EffectiveDate"/>
          </xsl:call-template>
        </EffectiveDate>
      </xsl:if>
      <xsl:if test="string-length(ExpirationDate)>0">
        <ExpirationDate>
          <xsl:call-template name="FormatDate">
            <xsl:with-param name="date" select="ExpirationDate"/>
          </xsl:call-template>
        </ExpirationDate>
      </xsl:if>
      <!--<xsl:if test="F18 = ''R''">
				<xsl:if test="string-length(F22)>0 ">
					<ReinstatementDate>
						<xsl:call-template name="FormatDate">
							<xsl:with-param name="date" select="F22"/>
						</xsl:call-template>
					</ReinstatementDate>
				</xsl:if>
			</xsl:if>-->
      <xsl:if test="string-length(CancellationDate)>0 ">
        <CancellationDate>
          <xsl:call-template name="FormatDate">
            <xsl:with-param name="date" select="CancellationDate"/>
          </xsl:call-template>
        </CancellationDate>
        <CancelReason>
          <xsl:choose>
            <xsl:when test="CancellationReason=''CRQ''">IR</xsl:when>
            <xsl:when test="CancellationReason=''NPP''">NP</xsl:when>
            <xsl:when test="CancellationReason=''MIR''">TP</xsl:when>
            <xsl:when test="CancellationReason=''COC''">CC</xsl:when>
            <xsl:when test="CancellationReason=''RNS''">NL</xsl:when>
            <xsl:when test="CancellationReason=''RSN''">NL</xsl:when>
          </xsl:choose>
        </CancelReason>
      </xsl:if>
    </Policy>
    <BillingInfo>
      <xsl:if test="string-length(bill_PremiumDue)>0">
        <PremiumDueAmount>
          <xsl:value-of select="bill_PremiumDue"/>
        </PremiumDueAmount>
      </xsl:if>
      <xsl:if test="string-length(bill_TotalPremium)>0">
        <PremiumAmount>
          <xsl:value-of select="bill_TotalPremium"/>
        </PremiumAmount>
      </xsl:if>
      <xsl:if test="string-length(bill_DueDate)>0">
        <PolicyPremiumDueDate>
          <xsl:call-template name="FormatDate">
            <xsl:with-param name="date" select="bill_DueDate"/>
          </xsl:call-template>
        </PolicyPremiumDueDate>
      </xsl:if>
      <xsl:if test="bill_SupplementalBilled = ''Y''">
        <AdditionalPremiumDue>
          <xsl:value-of select="bill_PremiumDue"/>
        </AdditionalPremiumDue>
      </xsl:if>
	  <xsl:if test="string-length(bill_RemittanceID)>0">
        <RemittanceId>
          <xsl:value-of select="bill_RemittanceID"/>
        </RemittanceId>
      </xsl:if>
    </BillingInfo>
    <xsl:if test="string-length(flood_zone)>0">
      <FloodZone>true</FloodZone>
      <FloodZoneValue>
        <xsl:value-of select="flood_zone"/>
      </FloodZoneValue>
    </xsl:if>
    <xsl:if test="string-length(flood_grandfathered)>0">
      <Grandfathered>
        <xsl:choose>
          <xsl:when test="flood_grandfathered = ''Y''">true</xsl:when>
          <xsl:otherwise>false</xsl:otherwise>
        </xsl:choose>
      </Grandfathered>
    </xsl:if>
    <xsl:if test="string-length(ContractType) > 0">
      <Property>
        <xsl:attribute name="Type">
          <xsl:choose>
            <xsl:when test="ContractType = ''V''">Vehicle</xsl:when>
            <xsl:when test="ContractType = ''M'' or ContractType = ''CM''">Real Estate</xsl:when>
            <xsl:otherwise>Unknown</xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
        <Address>
          <Line1>
            <xsl:value-of select="Prop_Addr"/>
          </Line1>
          <Zip>
            <xsl:value-of select="Prop_Zip"/>
          </Zip>
        </Address>
        <Vehicle>
          <VIN>
            <xsl:value-of select="VIN"/>
          </VIN>
          <Year>
            <xsl:value-of select="Veh_Year"/>
          </Year>
          <Make>
            <xsl:value-of select="Veh_Make"/>
          </Make>
          <Model>
            <xsl:value-of select="Veh_Model"/>
          </Model>
        </Vehicle>
        <Condo/>
      </Property>
    </xsl:if>
    <!-- ***Mortgage Coverage***-->
    <xsl:if test="flg_HazardCoverage = ''Y''">
      <xsl:call-template name="CoverageInformation">
        <xsl:with-param name="Qualifier">DWELL</xsl:with-param>
        <xsl:with-param name="CoverageType">Hazard</xsl:with-param>
        <xsl:with-param name="DeductibleAmount">
          <xsl:value-of select="haz_ADeductibleAmt"/>
        </xsl:with-param>
        <xsl:with-param name="DeductiblePercent">
          <xsl:value-of select="haz_ADeductiblePct"/>
        </xsl:with-param>
        <xsl:with-param name="CoverageAmount">
          <xsl:value-of select="haz_ADwellCoverageAmt"/>
        </xsl:with-param>
        <xsl:with-param name="OptionType">
          <xsl:value-of select="CoverageBasis"/>
        </xsl:with-param>
        <xsl:with-param name="OptionAmount">
          <xsl:choose>
            <xsl:when test="CoverageBasis = ''ERCV'' and string-length(ExtCvgAmtFixed)>0">
              <xsl:value-of select="ExtCvgAmtFixed"/>
            </xsl:when>
            <xsl:when test="CoverageBasis = ''SV'' and string-length(StatedInsValue)>0">
              <xsl:value-of select="StatedInsValue"/>
            </xsl:when>
          </xsl:choose>
        </xsl:with-param>
        <xsl:with-param name="OptionPercent">
          <xsl:if test="CoverageBasis = ''ERCV'' and string-length(ExtCvgAmtPct)>0">
            <xsl:value-of select="ExtCvgAmtPct"/>
          </xsl:if>
        </xsl:with-param>
        <xsl:with-param name="WindExcluded">
          <xsl:choose>
            <xsl:when test="haz_WindExcluded = ''Y''">true</xsl:when>
            <xsl:otherwise>false</xsl:otherwise>
          </xsl:choose>
        </xsl:with-param>
        <xsl:with-param name="WindDeductibleAmount">
          <xsl:value-of select="wind_ADeductibleAmt"/>
        </xsl:with-param>
        <xsl:with-param name="WindCoverageAmount">
          <xsl:value-of select="wind_ADwellCoverageAmt"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:if>

    <xsl:if test="flg_FloodCoverage = ''Y''">
      <xsl:call-template name="CoverageInformation">
        <xsl:with-param name="Qualifier">DWELL</xsl:with-param>
        <xsl:with-param name="CoverageType">Flood</xsl:with-param>
        <xsl:with-param name="DeductibleAmount">
          <xsl:value-of select="flood_ADeductibleAmt"/>
        </xsl:with-param>
        <xsl:with-param name="DeductiblePercent">
          <xsl:value-of select="flood_ADeductiblePct"/>
        </xsl:with-param>
        <xsl:with-param name="CoverageAmount">
          <xsl:value-of select="flood_ADwellCoverageAmt"/>
        </xsl:with-param>
        <xsl:with-param name="OptionType">
          <xsl:value-of select="CoverageBasis"/>
        </xsl:with-param>
        <xsl:with-param name="OptionAmount">
          <xsl:choose>
            <xsl:when test="CoverageBasis = ''ERCV'' and string-length(ExtCvgAmtFixed)>0">
              <xsl:value-of select="ExtCvgAmtFixed"/>
            </xsl:when>
            <xsl:when test="CoverageBasis = ''SV'' and string-length(StatedInsValue)>0">
              <xsl:value-of select="StatedInsValue"/>
            </xsl:when>
          </xsl:choose>
        </xsl:with-param>
        <xsl:with-param name="OptionPercent">
          <xsl:if test="CoverageBasis = ''ERCV'' and string-length(ExtCvgAmtPct)>0">
            <xsl:value-of select="ExtCvgAmtPct"/>
          </xsl:if>
        </xsl:with-param>
        <xsl:with-param name="WindExcluded">
          <xsl:choose>
            <xsl:when test="haz_WindExcluded = ''Y''">true</xsl:when>
            <xsl:otherwise>false</xsl:otherwise>
          </xsl:choose>
        </xsl:with-param>
        <xsl:with-param name="WindDeductibleAmount">
          <xsl:value-of select="wind_ADeductibleAmt"/>
        </xsl:with-param>
        <xsl:with-param name="WindCoverageAmount">
          <xsl:value-of select="wind_ADwellCoverageAmt"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:if>

    <xsl:if test="flg_WindCoverage = ''Y''">
      <xsl:call-template name="CoverageInformation">
        <xsl:with-param name="Qualifier">DWELL</xsl:with-param>
        <xsl:with-param name="CoverageType">Windstorm</xsl:with-param>
        <xsl:with-param name="DeductibleAmount">
          <xsl:value-of select="wind_ADeductibleAmt"/>
        </xsl:with-param>
        <xsl:with-param name="DeductiblePercent">
          <xsl:value-of select="wind_ADeductiblePct"/>
        </xsl:with-param>
        <xsl:with-param name="CoverageAmount">
          <xsl:value-of select="wind_ADwellCoverageAmt"/>
        </xsl:with-param>

        <xsl:with-param name="OptionType">
          <xsl:value-of select="CoverageBasis"/>
        </xsl:with-param>
        <xsl:with-param name="OptionAmount">
          <xsl:choose>
            <xsl:when test="CoverageBasis = ''ERCV'' and string-length(ExtCvgAmtFixed)>0">
              <xsl:value-of select="ExtCvgAmtFixed"/>
            </xsl:when>
            <xsl:when test="CoverageBasis = ''SV'' and string-length(StatedInsValue)>0">
              <xsl:value-of select="StatedInsValue"/>
            </xsl:when>
          </xsl:choose>
        </xsl:with-param>
        <xsl:with-param name="OptionPercent">
          <xsl:if test="CoverageBasis = ''ERCV'' and string-length(ExtCvgAmtPct)>0">
            <xsl:value-of select="ExtCvgAmtPct"/>
          </xsl:if>
        </xsl:with-param>

        <xsl:with-param name="WindExcluded">
          <xsl:choose>
            <xsl:when test="haz_WindExcluded = ''Y''">true</xsl:when>
            <xsl:otherwise>false</xsl:otherwise>
          </xsl:choose>
        </xsl:with-param>
        <xsl:with-param name="WindDeductibleAmount">
          <xsl:value-of select="wind_ADeductibleAmt"/>
        </xsl:with-param>
        <xsl:with-param name="WindCoverageAmount">
          <xsl:value-of select="wind_ADwellCoverageAmt"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:if>

    <xsl:if test="flg_EarthquakeCoverage = ''Y''">
      <xsl:call-template name="CoverageInformation">
        <xsl:with-param name="Qualifier">DWELL</xsl:with-param>
        <xsl:with-param name="CoverageType">Earthquake</xsl:with-param>
        <xsl:with-param name="DeductibleAmount">
          <xsl:value-of select="quake_ADeductibleAmt"/>
        </xsl:with-param>
        <xsl:with-param name="DeductiblePercent">
          <xsl:value-of select="quake_ADeductiblePct"/>
        </xsl:with-param>
        <xsl:with-param name="CoverageAmount">
          <xsl:value-of select="quake_ADwellCoverageAmt"/>
        </xsl:with-param>

        <xsl:with-param name="OptionType">
          <xsl:value-of select="CoverageBasis"/>
        </xsl:with-param>
        <xsl:with-param name="OptionAmount">
          <xsl:choose>
            <xsl:when test="CoverageBasis = ''ERCV'' and string-length(ExtCvgAmtFixed)>0">
              <xsl:value-of select="ExtCvgAmtFixed"/>
            </xsl:when>
            <xsl:when test="CoverageBasis = ''SV'' and string-length(StatedInsValue)>0">
              <xsl:value-of select="StatedInsValue"/>
            </xsl:when>
          </xsl:choose>
        </xsl:with-param>
        <xsl:with-param name="OptionPercent">
          <xsl:if test="CoverageBasis = ''ERCV'' and string-length(ExtCvgAmtPct)>0">
            <xsl:value-of select="ExtCvgAmtPct"/>
          </xsl:if>
        </xsl:with-param>

        <xsl:with-param name="WindExcluded">
          <xsl:choose>
            <xsl:when test="haz_WindExcluded = ''Y''">true</xsl:when>
            <xsl:otherwise>false</xsl:otherwise>
          </xsl:choose>
        </xsl:with-param>
        <xsl:with-param name="WindDeductibleAmount">
          <xsl:value-of select="wind_ADeductibleAmt"/>
        </xsl:with-param>
        <xsl:with-param name="WindCoverageAmount">
          <xsl:value-of select="wind_ADwellCoverageAmt"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:if>

    <xsl:if test="flg_HurricaneCoverage = ''Y''">
      <xsl:call-template name="CoverageInformation">
        <xsl:with-param name="Qualifier">DWELL</xsl:with-param>
        <xsl:with-param name="CoverageType">Hurricane</xsl:with-param>
        <xsl:with-param name="DeductibleAmount">
          <xsl:value-of select="hurricane_ADeductibleAmt"/>
        </xsl:with-param>
        <xsl:with-param name="DeductiblePercent">
          <xsl:value-of select="hurricane_ADeductiblePct"/>
        </xsl:with-param>
        <xsl:with-param name="CoverageAmount">
          <xsl:value-of select="hurricane_ADwellCoverageAmt"/>
        </xsl:with-param>

        <xsl:with-param name="OptionType">
          <xsl:value-of select="CoverageBasis"/>
        </xsl:with-param>
        <xsl:with-param name="OptionAmount">
          <xsl:choose>
            <xsl:when test="CoverageBasis = ''ERCV'' and string-length(ExtCvgAmtFixed)>0">
              <xsl:value-of select="ExtCvgAmtFixed"/>
            </xsl:when>
            <xsl:when test="CoverageBasis = ''SV'' and string-length(StatedInsValue)>0">
              <xsl:value-of select="StatedInsValue"/>
            </xsl:when>
          </xsl:choose>
        </xsl:with-param>
        <xsl:with-param name="OptionPercent">
          <xsl:if test="CoverageBasis = ''ERCV'' and string-length(ExtCvgAmtPct)>0">
            <xsl:value-of select="ExtCvgAmtPct"/>
          </xsl:if>
        </xsl:with-param>

        <xsl:with-param name="WindExcluded">
          <xsl:choose>
            <xsl:when test="haz_WindExcluded = ''Y''">true</xsl:when>
            <xsl:otherwise>false</xsl:otherwise>
          </xsl:choose>
        </xsl:with-param>
        <xsl:with-param name="WindDeductibleAmount">
          <xsl:value-of select="wind_ADeductibleAmt"/>
        </xsl:with-param>
        <xsl:with-param name="WindCoverageAmount">
          <xsl:value-of select="wind_ADwellCoverageAmt"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:if>

    <!-- ***Comprehensive Coverage***-->
    <xsl:if test="flg_ComprehensiveCoverage = ''Y''">
      <xsl:call-template name="CoverageInformation">
        <xsl:with-param name="Qualifier">COMP</xsl:with-param>
        <xsl:with-param name="CoverageType">Comprehensive</xsl:with-param>
        <xsl:with-param name="DeductibleAmount" select="veh_CompDeductibleAmt"/>
      </xsl:call-template>
    </xsl:if>
    <!-- ***Collision Coverage***-->
    <xsl:if test="flg_CollisionCoverage = ''Y''">
      <xsl:call-template name="CoverageInformation">
        <xsl:with-param name="Qualifier">COLL</xsl:with-param>
        <xsl:with-param name="CoverageType">Collision</xsl:with-param>
        <xsl:with-param name="DeductibleAmount" select="veh_CollDeductibleAmt"/>
      </xsl:call-template>
    </xsl:if>
    <!-- ***Insured***-->
    <xsl:call-template name="InsuredDetails"/>
    <InsuranceCompany>
      <xsl:attribute name="Id"/>
      <xsl:attribute name="NAIC"/>
	  <xsl:attribute name="BIC_ID">
        <xsl:value-of select="BIC_ID"/>
      </xsl:attribute>
      <CompanyName>
        <xsl:value-of select="InsCoName"/>
      </CompanyName>
      <!--<PhoneNumber>
				<xsl:if test="F36 = ''INS CO SVC CTR''">
					<xsl:value-of select="F37"/>
				</xsl:if>
			</PhoneNumber> cant find-->
      <Agency>
        <xsl:attribute name="Id">
          <xsl:value-of select="AgencyID"/>
        </xsl:attribute>
        <Name>
          <xsl:value-of select="AgencyCompanyName"/>
        </Name>
        <PhoneNumber>
          <xsl:value-of select="AgencyPhone"/>
        </PhoneNumber>
        <Email>
          <xsl:value-of select="AgencyEmail"/>
        </Email>
        <Address>
          <Line1/>
          <Line2/>
          <City/>
          <StateAbbreviation/>
          <Zip/>
        </Address>
        <Agent>
          <Name>
            <xsl:value-of select="AgencyCompanyName"/>
          </Name>
        </Agent>
      </Agency>
      <SubCarrier>
        <xsl:attribute name="Id"/>
        <xsl:attribute name="NAIC"/>
      </SubCarrier>
    </InsuranceCompany>
    <LienHolder>
      <CompanyName/>
      <Address/>
    </LienHolder>
    <KeyingInformation>
      <IsApplication>
        <xsl:choose>
          <xsl:when test="flg_IsApplication = ''Y''">true</xsl:when>
          <xsl:otherwise>false</xsl:otherwise>
        </xsl:choose>
      </IsApplication>
      <IsMortgageOrLienholderNameIncorrect>
        <xsl:choose>
          <xsl:when test="flg_LienholderNameErr = ''Y''">true</xsl:when>
          <xsl:otherwise>false</xsl:otherwise>
        </xsl:choose>
      </IsMortgageOrLienholderNameIncorrect>
      <IsMortOrLienholderAddressIncorrect>
        <xsl:choose>
          <xsl:when test="flg_LienholderAddrErr = ''Y''">true</xsl:when>
          <xsl:otherwise>false</xsl:otherwise>
        </xsl:choose>
      </IsMortOrLienholderAddressIncorrect>
      <IsLiabilityCard>
        <xsl:choose>
          <xsl:when test="flg_LiabilityCard = ''Y''">true</xsl:when>
          <xsl:otherwise>false</xsl:otherwise>
        </xsl:choose>
      </IsLiabilityCard>
      <OperatorID>OCR-<xsl:value-of select="ValidationOperator"/>
      </OperatorID>
    </KeyingInformation>
  </xsl:template>
  <!--  ***************************************** Coverage Information Details ***************************************** -->
  <xsl:template name="CoverageInformation">
    <xsl:param name="Qualifier"/>
    <xsl:param name="CoverageType"/>
    <xsl:param name="CoverageAmount"/>
    <xsl:param name="DeductibleAmount"/>
    <xsl:param name="DeductiblePercent"/>
    <xsl:param name="OptionType"/>
    <xsl:param name="OptionAmount"/>
    <xsl:param name="OptionPercent"/>
    <xsl:param name="WindExcluded"/>
    <xsl:param name="WindDeductibleAmount"/>
    <xsl:param name="WindCoverageAmount"/>
    <xsl:param name="WindAdditionalCoverageAmount"/>
    <CoverageInformation>
      <xsl:attribute name="Qualifier">
        <xsl:value-of select="$Qualifier"/>
      </xsl:attribute>
      <Type>
        <xsl:value-of select="$CoverageType"/>
      </Type>
      <xsl:if test="$DeductibleAmount > 0">
        <DeductibleAmount>
          <xsl:value-of select="$DeductibleAmount"/>
        </DeductibleAmount>
      </xsl:if>
      <xsl:if test="$DeductiblePercent > 0">
        <DeductiblePercent>
          <xsl:value-of select="$DeductiblePercent"/>
        </DeductiblePercent>
      </xsl:if>
      <CoverageAmountInfo>
        <xsl:if test="$CoverageAmount > 0">
          <CoverageAmount>
            <xsl:value-of select="$CoverageAmount"/>
          </CoverageAmount>
        </xsl:if>
      </CoverageAmountInfo>
      <CoverageOptionInfo>
        <xsl:if test="string-length($OptionType) > 0">
          <Type>
            <xsl:choose>
              <xsl:when test="$OptionType = ''REG''">Replacement</xsl:when>
              <xsl:when test="$OptionType = ''RCV''">Guaranteed</xsl:when>
              <xsl:when test="$OptionType = ''ERCV''">Extended</xsl:when>
              <xsl:when test="$OptionType = ''EXCS''">Excess</xsl:when>
              <xsl:when test="$OptionType = ''INWI''">WallsIn</xsl:when>
              <xsl:when test="$OptionType = ''EXWNDCV''">PolicyExcludesWind</xsl:when>
              <xsl:when test="$OptionType = ''SV''">StatedInsurableValueAmount</xsl:when>
            </xsl:choose>
          </Type>
        </xsl:if>
        <xsl:if test="$OptionAmount > 0">
          <Amount>
            <xsl:value-of select="$OptionAmount"/>
          </Amount>
        </xsl:if>
        <xsl:if test="$OptionPercent > 0">
          <Percent>
            <xsl:value-of select="$OptionPercent"/>
          </Percent>
        </xsl:if>
      </CoverageOptionInfo>
      <xsl:if test="string-length($WindExcluded) > 0">
        <WindExcluded>
          <xsl:value-of select="$WindExcluded"/>
        </WindExcluded>
      </xsl:if>
      <xsl:if test="$WindDeductibleAmount > 0">
        <WindDeductibleAmount>
          <xsl:value-of select="$WindDeductibleAmount"/>
        </WindDeductibleAmount>
      </xsl:if>
      <xsl:if test="$WindCoverageAmount > 0">
        <WindCoverageAmount>
          <xsl:value-of select="$WindCoverageAmount"/>
        </WindCoverageAmount>
      </xsl:if>
      <xsl:if test="$WindAdditionalCoverageAmount > 0">
        <WindAdditionalCoverageAmount>
          <xsl:value-of select="$WindAdditionalCoverageAmount"/>
        </WindAdditionalCoverageAmount>
      </xsl:if>
    </CoverageInformation>
  </xsl:template>
  <!--  ***************************************** Insured Details ***************************************** -->
  <xsl:template name="InsuredDetails">
    <Insured>
      <LastName>
        <xsl:value-of select="Insured_LastName"/>
      </LastName>
      <FirstName>
        <xsl:value-of select="Insured_FirstName"/>
      </FirstName>
      <MiddleInitial/>
      <!--This value is not passed in OutputImages-->
      <xsl:if test="string-length(Insured_DBAName)>0">
        <AdditionalName>
          <xsl:value-of select="Insured_DBAName"/>
        </AdditionalName>
      </xsl:if>
      <Address>
        <Line1>
          <xsl:value-of select="Insured_Addr"/>
        </Line1>
        <Zip>
          <xsl:value-of select="Insured_Zip"/>
        </Zip>
      </Address>
    </Insured>
    <xsl:if test="string-length(Insured_LastName2)>0 or string-length(Insured_FirstName2)>0">
      <Insured>
        <LastName>
          <xsl:value-of select="Insured_LastName2"/>
        </LastName>
        <FirstName>
          <xsl:value-of select="Insured_FirstName2"/>
        </FirstName>
        <MiddleInitial/>
        <!--This value is not passed in OutputImages-->
        <xsl:if test="string-length(Insured_DBAName)>0">
          <AdditionalName/>
        </xsl:if>
        <Address>
          <Line1/>
          <Zip/>
        </Address>
      </Insured>
    </xsl:if>
  </xsl:template>
  <xsl:template name="FormatDate">
    <xsl:param name="date"/>
    <xsl:choose>
      <xsl:when test="substring($date, 3, 1) = ''/''">
        <xsl:value-of select="concat(substring($date, 7, 4), ''-'', substring($date, 1, 2), ''-'', substring($date, 4, 2))"/>
      </xsl:when>
      <xsl:when test="string-length($date) > 10">
        <xsl:value-of select="substring($date, 1, 10)"/>
      </xsl:when>
      <xsl:when test="string-length($date) = 10">
        <xsl:value-of select="substring($date, 1, 10)"/>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>'
		,NULL
	)
END

-- Second transform to transaction wrapped InsuranceDocument
IF NOT EXISTS (select * from PPDATTRIBUTE where PREPROCESSING_DETAIL_ID =
	(SELECT ID FROM PREPROCESSING_DETAIL WHERE ORDER_NO = '2' AND DELIVERY_INFO_GROUP_ID = 
	(SELECT ID FROM DELIVERY_INFO_GROUP WHERE DELIVERY_INFO_ID = (SELECT ID FROM DELIVERY_INFO WHERE  DELIVERY_TYPE_CD = 'OCR'))))
BEGIN
	INSERT INTO PPDATTRIBUTE
	(
		PREPROCESSING_DETAIL_ID	
		,VALUE_TX	
		,CODE_CD	
		,CREATE_DT	
		,UPDATE_DT	
		,UPDATE_USER_TX	
		,PURGE_DT	
		,LOCK_ID	
		,VALUE_XML	
		,COMMON_STYLESHEET_ID
)
	VALUES(
		(SELECT ID FROM PREPROCESSING_DETAIL WHERE ORDER_NO = '2' AND DELIVERY_INFO_GROUP_ID = 
			(SELECT ID FROM DELIVERY_INFO_GROUP WHERE DELIVERY_INFO_ID = (SELECT ID FROM DELIVERY_INFO WHERE  DELIVERY_TYPE_CD = 'OCR')))	
		,'XSLT XML'	
		,'XSLTScript'	
		,GETDATE()	
		,GETDATE()	
		,'Task42977'	
		,NULL	
		,1	
		,'<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" version="1.0" exclude-result-prefixes="msxsl"><xsl:output method="xml" indent="yes" /><xsl:template match="@*|node()"><xsl:copy><xsl:apply-templates select="@*|node()" /></xsl:copy></xsl:template><xsl:template match="/Message"><Document><xsl:attribute name="ExternalReferenceNo"><xsl:value-of select="@GroupControlNumber" /></xsl:attribute><xsl:apply-templates select="IDRHeader" /><xsl:apply-templates select="InsuranceDocument" /></Document></xsl:template><xsl:template match="IDRHeader"><Transaction Type="Header" Processed="Y"><xsl:copy><xsl:apply-templates select="@*|node()" /></xsl:copy></Transaction></xsl:template><xsl:template match="InsuranceDocument"><Transaction Type="OCR" Processed="N" RelateId="0"><xsl:copy><xsl:apply-templates select="@*|node()" /></xsl:copy></Transaction></xsl:template><xsl:template match="OCR"><xsl:copy><xsl:attribute name="Processed">N</xsl:attribute><xsl:attribute name="RelateId">0</xsl:attribute><xsl:apply-templates select="@*|node()" /></xsl:copy></xsl:template></xsl:stylesheet>'	
		,NULL
	)
END