DECLARE @xlstName nvarchar(50) = 'FICS-BACKFEED'
DECLARE @xlstType nvarchar(4) = 'C'
IF NOT EXISTS (select 1 from COMMON_STYLESHEET where NAME_TX = @xlstName)
BEGIN
	INSERT INTO COMMON_STYLESHEET
	(NAME_TX, TYPE_CD, CREATE_DT, UPDATE_DT, UPDATE_USER_TX, PURGE_DT, LOCK_ID, DEFAULT_IN)
	VALUES
	(@xlstName, @xlstType, GETDATE(), GETDATE(), 'SCRIPT', NULL, 1, 'N')
END

declare @thisxml xml = 
'<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xslHelper="urn:xslHelper" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:FormatInsurance="urn:custom-scripts-csharp" version="1.0">
  <xsl:preserve-space elements="xsl:text" />
  <xsl:output method="text" omit-xml-declaration="yes" indent="no" />
  <xsl:decimal-format name="us" decimal-separator="." grouping-separator="," />
  <xsl:template match="/">
    <xsl:for-each select="Portfolio/Loan">
      <xsl:variable name="DBA" select="Owners/Owner[@typCd = ''DBA'']/@lastName" />
      <xsl:for-each select="Owners/Owner[@typCd = ''B'' or @typCd = ''CS'']">
        <xsl:variable name="OwnerID" select="@id" />
        <xsl:for-each select="../../Colls/Coll">
          <xsl:variable name="CollID" select="@id" />
          <xsl:for-each select="Cvgs/Cvg">
            <xsl:variable name="ReqCovID" select="@id" />
            <xsl:variable name="PlcyID" select="Plcys/Plcy/@id" />
            <xsl:apply-templates select="../../../..">
              <xsl:with-param name="CollID" select="$CollID" />
              <xsl:with-param name="OwnerID" select="$OwnerID" />
              <xsl:with-param name="ReqCovID" select="$ReqCovID" />
              <xsl:with-param name="DBA" select="$DBA" />
              <xsl:with-param name="PlcyID" select="$PlcyID" />
            </xsl:apply-templates>
          </xsl:for-each>
        </xsl:for-each>
      </xsl:for-each>
    </xsl:for-each>
  </xsl:template>
  <xsl:template match="Loan">
    <xsl:param name="line-separator" select="''&#xD;&#xA;''" />
    <xsl:param name="CollID" />
    <xsl:param name="OwnerID" />
    <xsl:param name="ReqCovID" />
    <xsl:param name="DBA" />
    <xsl:param name="PlcyID" />
    <!-- 01: Lender # -->
    <xsl:value-of select="xslHelper:GetFISCLenderCode()" />
    <!-- 11: Loan Number -->
    <xsl:value-of select="FormatInsurance:PadSpaceRight(@num, 20)" />
    <!-- 31: Filler -->
    <xsl:value-of select="FormatInsurance:PadSpaceRight('''' , 1)" />
	<!-- 32: Delinquent Date -->
    <xsl:value-of select="FormatInsurance:PadSpaceRight(@dlnqDt, 8)" />
    <!-- 40: Unique Iden Code -->
    <xsl:value-of select="FormatInsurance:PadSpaceRight('''', 11)" />
    <!-- 51: Insurance Type Cd -->
    <xsl:value-of select="FormatInsurance:PadSpaceRight(xslHelper:GetInsuranceTypeCd(Colls/Coll[@id=$CollID]/Cvgs/Cvg[@id=$ReqCovID]/@typCd), 3)" />
    <!-- 54: Program Type Cd -->
    <xsl:value-of select="FormatInsurance:PadSpaceRight('''' , 2)" />
    <!-- 56: Property Type Cd -->
    <xsl:value-of select="FormatInsurance:PadSpaceRight('''', 15)" />
    <!-- 71: Company Payee Code-->
    <xsl:value-of select="xslHelper:GetCompanyPayeeCd(Colls/Coll[@id=$CollID]/Cvgs/Cvg[@id=$ReqCovID]/@escrowIn, Colls/Coll[@id=$CollID]/Cvgs/Cvg[@id=$ReqCovID]/@fpcInd, Colls/Coll[@id=$CollID]/Cvgs/Cvg[@id=$ReqCovID]/Plcys/Plcy[@id=$PlcyID]/@bicID, @num, Colls/Coll[@id=$CollID]/@line1, Colls/Coll[@id=$CollID]/Cvgs/Cvg[@id=$ReqCovID]/@typ)" />
    <!-- 79: Agent/Agency Payee Code -->
	  <xsl:value-of select="xslHelper:GetAgencyPayeeCd(Colls/Coll[@id=$CollID]/Cvgs/Cvg[@id=$ReqCovID]/@escrowIn, @num, Colls/Coll[@id=$CollID]/@line1, Colls/Coll[@id=$CollID]/Cvgs/Cvg[@id=$ReqCovID]/@typ)" />
	  <!-- 87: Payment Director Code -->
    <xsl:value-of select="FormatInsurance:PadSpaceRight(''C'', 1)" />
    <!-- 88: AM Best Code -->
    <xsl:value-of select="FormatInsurance:PadSpaceRight('''', 5)" />
    <!-- 93: NAIC Code -->
    <xsl:value-of select="FormatInsurance:PadSpaceRight('''', 5)" />
    <!-- 98: Premium Amount -->
	  <xsl:choose>
		  <xsl:when test=''Colls/Coll[@id=$CollID]/Cvgs/Cvg[@id=$ReqCovID]/@fpcID''>
			  <xsl:value-of select=''xslHelper:PadSpaceLeft(Colls/Coll[@id=$CollID]/Cvgs/Cvg[@id=$ReqCovID]/@fpcPolicyAmt, 11, "0")'' />
		  </xsl:when>
		  <xsl:when test=''Colls/Coll[@id=$CollID]/Cvgs/Cvg[@id=$ReqCovID]/@escrowIn="Y"''>
			  <xsl:value-of select=''xslHelper:PadSpaceLeft(Colls/Coll[@id=$CollID]/Cvgs/Cvg[@id=$ReqCovID]/Plcys/Plcy[@id=$PlcyID]/@policyAMT, 11, "0")'' />
		  </xsl:when>
		  <xsl:otherwise>
			  <xsl:value-of select=''xslHelper:PadSpaceLeft("0.00", 11, "0")'' />
		  </xsl:otherwise>
	  </xsl:choose>
    <!-- 109: Premium Due Date -->
    <xsl:choose>
      <xsl:when test=''Colls/Coll[@id=$CollID]/Cvgs/Cvg[@id=$ReqCovID]/@escrowIn="N"''>
		  <xsl:choose>
			  <xsl:when test=''Colls/Coll[@id=$CollID]/Cvgs/Cvg[@id=$ReqCovID]/Plcys/Plcy[@id=$PlcyID]/@continuousIn="N" and Colls/Coll[@id = $CollID]/Cvgs/Cvg[@id=$ReqCovID]/Plcys/Plcy[@id=$PlcyID]/@expDt''>
				  <xsl:value-of select="FormatInsurance:PadSpaceRight(xslHelper:GetFormattedDate(Colls/Coll[@id = $CollID]/Cvgs/Cvg[@id=$ReqCovID]/Plcys/Plcy[@id=$PlcyID]/@expDt), 8)" />
			  </xsl:when>
			  <xsl:when test=''Colls/Coll[@id=$CollID]/Cvgs/Cvg[@id=$ReqCovID]/Plcys/Plcy[@id=$PlcyID]/@continuousIn="Y" and Colls/Coll[@id=$CollID]/Cvgs/Cvg[@id=$ReqCovID]/Plcys/Plcy[@id=$PlcyID]/@effDt''>
				  <xsl:value-of select="FormatInsurance:PadSpaceRight(xslHelper:GetPremiumDueDate(Colls/Coll[@id=$CollID]/Cvgs/Cvg[@id=$ReqCovID]/@escrowIn, Colls/Coll[@id=$CollID]/Cvgs/Cvg[@id=$ReqCovID]/Plcys/Plcy[@id=$PlcyID]/@effDt), 8)" />
			  </xsl:when>
			  <xsl:otherwise>
				  <xsl:value-of select="FormatInsurance:PadSpaceRight('''', 8)" />
			  </xsl:otherwise>
		  </xsl:choose>
	  </xsl:when>
	  <xsl:when test=''../@escrowRunType="A" and Colls/Coll[@id=$CollID]/Cvgs/Cvg[@id=$ReqCovID]/@escrowIn="Y" and Colls/Coll[@id=$CollID]/Cvgs/Cvg[@id=$ReqCovID]/Plcys/Plcy[@id=$PlcyID]/@EndDt and Colls/Coll[@id=$CollID]/Cvgs/Cvg[@id=$ReqCovID]/@fpcInd="N"''>
		<xsl:value-of select="FormatInsurance:PadSpaceRight(xslHelper:GetFormattedDate(Colls/Coll[@id = $CollID]/Cvgs/Cvg[@id=$ReqCovID]/Plcys/Plcy[@id=$PlcyID]/@EndDt), 8)" />
	  </xsl:when>
	  <xsl:when test=''Colls/Coll[@id=$CollID]/Cvgs/Cvg[@id=$ReqCovID]/Plcys/Plcy[@id=$PlcyID]/@escrowDueDt''>
		  <xsl:value-of select="FormatInsurance:PadSpaceRight(xslHelper:GetPremiumDueDate(Colls/Coll[@id=$CollID]/Cvgs/Cvg[@id=$ReqCovID]/@escrowIn, Colls/Coll[@id=$CollID]/Cvgs/Cvg[@id=$ReqCovID]/Plcys/Plcy[@id=$PlcyID]/@escrowDueDt), 8)" />
	  </xsl:when>
	  <xsl:otherwise>
		<xsl:value-of select="FormatInsurance:PadSpaceRight('''', 8)" />
	  </xsl:otherwise>
	</xsl:choose>
    <!-- 117: Payment Identifier -->
    <xsl:value-of select="FormatInsurance:PadSpaceRight('''', 15)" />
    <!-- 132: Premium Paid Date -->
	  <xsl:choose>
		  <xsl:when test="Colls/Coll[@id = $CollID]/Cvgs/Cvg[@id=$ReqCovID]/@goodThruDt">
			  <xsl:value-of select="FormatInsurance:PadSpaceRight(xslHelper:GetFormattedDate(Colls/Coll[@id = $CollID]/Cvgs/Cvg[@id=$ReqCovID]/@goodThruDt), 8)" />
		  </xsl:when>
		  <xsl:otherwise>
			  <xsl:value-of select="FormatInsurance:PadSpaceRight('''', 8)" />
		  </xsl:otherwise>
	  </xsl:choose>
	  <!-- 140: Policy/Coverage Eff Date TO DO Same date as 109 -->
	  <xsl:choose>
		  <xsl:when test=''Colls/Coll[@id=$CollID]/Cvgs/Cvg[@id=$ReqCovID]/@fpcInd="Y" and Colls/Coll[@id = $CollID]/Cvgs/Cvg[@id=$ReqCovID]/@fpcEffDt''>
			  <xsl:value-of select="FormatInsurance:PadSpaceRight(xslHelper:GetFormattedDate(Colls/Coll[@id = $CollID]/Cvgs/Cvg[@id=$ReqCovID]/@fpcEffDt), 8)" />
		  </xsl:when>
		  <xsl:when test=''Colls/Coll[@id=$CollID]/Cvgs/Cvg[@id=$ReqCovID]/@escrowIn="N"''>
			  <xsl:choose>
				  <xsl:when test=''Colls/Coll[@id=$CollID]/Cvgs/Cvg[@id=$ReqCovID]/Plcys/Plcy[@id=$PlcyID]/@continuousIn="N" and Colls/Coll[@id = $CollID]/Cvgs/Cvg[@id=$ReqCovID]/Plcys/Plcy[@id=$PlcyID]/@expDt''>
					  <xsl:value-of select="FormatInsurance:PadSpaceRight(xslHelper:GetFormattedDate(Colls/Coll[@id = $CollID]/Cvgs/Cvg[@id=$ReqCovID]/Plcys/Plcy[@id=$PlcyID]/@expDt), 8)" />
				  </xsl:when>
				  <xsl:when test="Colls/Coll[@id=$CollID]/Cvgs/Cvg[@id=$ReqCovID]/Plcys/Plcy[@id=$PlcyID]/@effDt">
					  <xsl:value-of select="FormatInsurance:PadSpaceRight(xslHelper:GetPremiumDueDate(Colls/Coll[@id=$CollID]/Cvgs/Cvg[@id=$ReqCovID]/@escrowIn, Colls/Coll[@id=$CollID]/Cvgs/Cvg[@id=$ReqCovID]/Plcys/Plcy[@id=$PlcyID]/@effDt), 8)" />
				  </xsl:when>
				  <xsl:otherwise>
					  <xsl:value-of select="FormatInsurance:PadSpaceRight('''', 8)" />
				  </xsl:otherwise>
			  </xsl:choose>
		  </xsl:when>
		  <xsl:when test=''Colls/Coll[@id=$CollID]/Cvgs/Cvg[@id=$ReqCovID]/@escrowIn="Y" and Colls/Coll[@id=$CollID]/Cvgs/Cvg[@id=$ReqCovID]/Plcys/Plcy[@id=$PlcyID]/@effDt''>
			  <xsl:value-of select="FormatInsurance:PadSpaceRight(xslHelper:GetFormattedDate(Colls/Coll[@id=$CollID]/Cvgs/Cvg[@id=$ReqCovID]/Plcys/Plcy[@id=$PlcyID]/@effDt), 8)" />
		  </xsl:when>
		  <xsl:otherwise>
			  <xsl:value-of select="FormatInsurance:PadSpaceRight('''', 8)" />
		  </xsl:otherwise>
	  </xsl:choose>
	  <!-- 148: Policy Expiration Date -->
	  <xsl:choose>
		  <xsl:when test=''Colls/Coll[@id=$CollID]/Cvgs/Cvg[@id=$ReqCovID]/@fpcInd="Y" and Colls/Coll[@id = $CollID]/Cvgs/Cvg[@id=$ReqCovID]/@fpcExpDt''>
			  <xsl:value-of select="FormatInsurance:PadSpaceRight(xslHelper:GetFormattedDate(Colls/Coll[@id = $CollID]/Cvgs/Cvg[@id=$ReqCovID]/@fpcExpDt), 8)" />
		  </xsl:when>
		  <xsl:when test=''Colls/Coll[@id=$CollID]/Cvgs/Cvg[@id=$ReqCovID]/@escrowIn="N"''>
			  <xsl:choose>
				  <xsl:when test=''Colls/Coll[@id=$CollID]/Cvgs/Cvg[@id=$ReqCovID]/Plcys/Plcy[@id=$PlcyID]/@continuousIn="N" and Colls/Coll[@id = $CollID]/Cvgs/Cvg[@id=$ReqCovID]/Plcys/Plcy[@id=$PlcyID]/@expDt''>
					  <xsl:value-of select="FormatInsurance:PadSpaceRight(xslHelper:GetFormattedDate(Colls/Coll[@id = $CollID]/Cvgs/Cvg[@id=$ReqCovID]/Plcys/Plcy[@id=$PlcyID]/@expDt), 8)" />
				  </xsl:when>
				  <xsl:when test="Colls/Coll[@id=$CollID]/Cvgs/Cvg[@id=$ReqCovID]/Plcys/Plcy[@id=$PlcyID]/@effDt">
					  <xsl:value-of select="FormatInsurance:PadSpaceRight(xslHelper:GetPremiumDueDate(Colls/Coll[@id=$CollID]/Cvgs/Cvg[@id=$ReqCovID]/@escrowIn, Colls/Coll[@id=$CollID]/Cvgs/Cvg[@id=$ReqCovID]/Plcys/Plcy[@id=$PlcyID]/@effDt), 8)" />
				  </xsl:when>
				  <xsl:otherwise>
					  <xsl:value-of select="FormatInsurance:PadSpaceRight('''', 8)" />
				  </xsl:otherwise>
			  </xsl:choose>
		  </xsl:when>
		  <xsl:when test=''Colls/Coll[@id=$CollID]/Cvgs/Cvg[@id=$ReqCovID]/@escrowIn="Y" and Colls/Coll[@id=$CollID]/Cvgs/Cvg[@id=$ReqCovID]/Plcys/Plcy[@id=$PlcyID]/@escrowDueDt''>
			  <xsl:value-of select="FormatInsurance:PadSpaceRight(xslHelper:GetPremiumDueDate(Colls/Coll[@id=$CollID]/Cvgs/Cvg[@id=$ReqCovID]/@escrowIn, Colls/Coll[@id=$CollID]/Cvgs/Cvg[@id=$ReqCovID]/Plcys/Plcy[@id=$PlcyID]/@escrowDueDt), 8)" />
		  </xsl:when>
		  <xsl:otherwise>
			  <xsl:value-of select="FormatInsurance:PadSpaceRight('''', 8)" />
		  </xsl:otherwise>
	  </xsl:choose>
	  <!-- 156: Policy Cancellation Date -->
	  <xsl:choose>
		  <xsl:when test="Colls/Coll[@id = $CollID]/Cvgs/Cvg[@id=$ReqCovID]/Plcys/Plcy[@id=$PlcyID]/@cxlDt">
			  <xsl:value-of select="FormatInsurance:PadSpaceRight(xslHelper:GetFormattedDate(Colls/Coll[@id = $CollID]/Cvgs/Cvg[@id=$ReqCovID]/Plcys/Plcy[@id=$PlcyID]/@cxlDt), 8)" />
		  </xsl:when>
		  <xsl:otherwise>
			  <xsl:value-of select="FormatInsurance:PadSpaceRight('''', 8)" />
		  </xsl:otherwise>
	  </xsl:choose>
	  <!-- 164: Policy Term -->
    <xsl:value-of select="FormatInsurance:PadSpaceRight('''', 3)" />
    <!-- 167: Payment Frequency -->
	  <xsl:choose>
		  <xsl:when test="Colls/Coll[@id=$CollID]/Cvgs/Cvg[@id=$ReqCovID]/Plcys/Plcy[@id=$PlcyID]/@goodThruDt and Colls/Coll[@id=$CollID]/Cvgs/Cvg[@id=$ReqCovID]/Plcys/Plcy[@id=$PlcyID]/@escrowEndDt">
			  <xsl:value-of select="xslHelper:PaymentFrequency(Colls/Coll[@id=$CollID]/Cvgs/Cvg[@id=$ReqCovID]/Plcys/Plcy[@id=$PlcyID]/@goodThruDt,Colls/Coll[@id=$CollID]/Cvgs/Cvg[@id=$ReqCovID]/Plcys/Plcy[@id=$PlcyID]/@escrowEndDt)" />
		  </xsl:when>
		  <xsl:when test="Colls/Coll[@id=$CollID]/Cvgs/Cvg[@id=$ReqCovID]/Plcys/Plcy[@id=$PlcyID]/@effDt and Colls/Coll[@id=$CollID]/Cvgs/Cvg[@id=$ReqCovID]/Plcys/Plcy[@id=$PlcyID]/@escrowEndDt">
			  <xsl:value-of select="xslHelper:PaymentFrequency(Colls/Coll[@id=$CollID]/Cvgs/Cvg[@id=$ReqCovID]/Plcys/Plcy[@id=$PlcyID]/@effDt,Colls/Coll[@id=$CollID]/Cvgs/Cvg[@id=$ReqCovID]/Plcys/Plcy[@id=$PlcyID]/@escrowEndDt)" />
		  </xsl:when>
		  <xsl:otherwise>
			  <xsl:value-of select="FormatInsurance:PadSpaceRight(''A'', 3)" />
		  </xsl:otherwise>
	  </xsl:choose>
    <!-- 170: Coverage Amount -->
    <xsl:choose>
      <xsl:when test="Colls/Coll[@id=$CollID]/Cvgs/Cvg[@id=$ReqCovID]/@reqAmt">
        <xsl:value-of select="FormatInsurance:PadSpaceRight(xslHelper:GetFormattedAmount(Colls/Coll[@id=$CollID]/Cvgs/Cvg[@id=$ReqCovID]/@reqAmt), 9)" />
      </xsl:when>
      <xsl:when test="@misc2 and number(@misc2) = @misc2">
        <xsl:value-of select="FormatInsurance:PadSpaceRight(xslHelper:GetFormattedAmount(@misc2), 9)" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="FormatInsurance:PadSpaceRight('''', 9)" />
      </xsl:otherwise>
    </xsl:choose>
    <!-- 179: Policy Number -->
	  <xsl:choose>
 		  <xsl:when test=''Colls/Coll[@id=$CollID]/Cvgs/Cvg[@id=$ReqCovID]/@fpcInd="Y"''>
			  <xsl:value-of select="FormatInsurance:PadSpaceRight(Colls/Coll[@id=$CollID]/Cvgs/Cvg[@id=$ReqCovID]/@fpcNumb, 40)" />
		  </xsl:when>
		  <xsl:when test=''Colls/Coll[@id=$CollID]/Cvgs/Cvg[@id=$ReqCovID]/@escrowIn="Y"''>
			  <xsl:value-of select="FormatInsurance:PadSpaceRight(Colls/Coll[@id=$CollID]/Cvgs/Cvg[@id=$ReqCovID]/Plcys/Plcy[@id=$PlcyID]/@escrowNum, 40)" />
		  </xsl:when>
		  <xsl:when test=''Colls/Coll[@id=$CollID]/Cvgs/Cvg[@id=$ReqCovID]/@escrowIn="N"''>
			  <xsl:value-of select="FormatInsurance:PadSpaceRight(Colls/Coll[@id=$CollID]/Cvgs/Cvg[@id=$ReqCovID]/Plcys/Plcy[@id=$PlcyID]/@num, 40)" />
		  </xsl:when>
	  </xsl:choose>
    <!-- 219:Escrow Indicator -->
	  <xsl:choose>
		  <xsl:when test=''Colls/Coll[@id=$CollID]/Cvgs/Cvg[@id=$ReqCovID]/@fpcID''>
			  <xsl:value-of select="FormatInsurance:PadSpaceRight(''E'', 1)" />
		  </xsl:when>
		  <xsl:otherwise>
			  <xsl:value-of select="FormatInsurance:PadSpaceRight('''', 1)" />
		  </xsl:otherwise>
	  </xsl:choose>
    <!-- 220: Transaction Type Code -->
    <xsl:value-of select="FormatInsurance:PadSpaceRight(''I'', 2)" />
    <!--222: Name-->
    <xsl:value-of select="FormatInsurance:PadSpaceRight(Colls/Coll[@id=$CollID]/Cvgs/Cvg[@id=$ReqCovID]/Plcys/Plcy[@id=$PlcyID]/@bicName, 40)" />
    <!-- 262: Co-Maker Name -->
    <xsl:value-of select="FormatInsurance:PadSpaceRight('''', 40)" />
    <!--302: Mailing Address1 -->
    <xsl:value-of select="FormatInsurance:PadSpaceRight('''', 40)" />
    <!--342: Mailing Address2 -->
    <xsl:value-of select="FormatInsurance:PadSpaceRight('''', 40)" />
    <!--382: Mailing Address3 -->
    <xsl:value-of select="FormatInsurance:PadSpaceRight('''', 40)" />
    <!--422: Mailing Address4 -->
    <xsl:value-of select="FormatInsurance:PadSpaceRight('''', 40)" />
    <!--462: Mailing Address1 -->
    <xsl:value-of select="FormatInsurance:PadSpaceRight('''', 40)" />
    <!--502: Mailing Address2 -->
    <xsl:value-of select="FormatInsurance:PadSpaceRight('''', 40)" />
    <!--542: Mailing Address3 -->
    <xsl:value-of select="FormatInsurance:PadSpaceRight('''', 40)" />
    <!--582: Mailing Address4 -->
    <xsl:value-of select="FormatInsurance:PadSpaceRight('''', 40)" />
    <!--622: Flood Zone-->
    <xsl:value-of select="FormatInsurance:PadSpaceRight('''', 5)" />
    <!--627: Vehicle Year -->
    <xsl:value-of select="FormatInsurance:PadSpaceRight('''', 4)" />
    <!--631: Vehicle Make-->
    <xsl:value-of select="FormatInsurance:PadSpaceRight('''', 18)" />
    <!--649: Vehicle Model-->
    <xsl:value-of select="FormatInsurance:PadSpaceRight('''', 18)" />
    <!--667: Vehicle Identification-->
    <xsl:value-of select="FormatInsurance:PadSpaceRight('''', 17)" />
    <!--684: Old Policy Number-->
    <xsl:value-of select="xslHelper:GetPreviousPolicyNumber(@num, Colls/Coll[@id=$CollID]/@line1, Colls/Coll[@id=$CollID]/Cvgs/Cvg[@id=$ReqCovID]/@typ)" />
    <!--709: Filler -->
    <xsl:value-of select="FormatInsurance:PadSpaceRight('''', 175)" />
    <!--884: CR &LF -->
    <xsl:value-of select="$line-separator" />
  </xsl:template>
  <msxsl:script language="C#" implements-prefix="FormatInsurance">
	  public string PadSpaceRight(string value, int length)
	  {
	  if (value == null)
	  {
	    value = string.Empty;
	  }
	    return value.PadRight(length);
	  }
  </msxsl:script>
</xsl:stylesheet>'

UPDATE COMMON_STYLESHEET
SET COMMON_XML = @thisxml,
UPDATE_DT = GETDATE(),
UPDATE_USER_TX = 'SCRIPT' 
where NAME_TX = @xlstName