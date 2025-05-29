DECLARE @xlstName nvarchar(50) = 'DNH-BACKFEED'
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
    <!-- Lender # -->
    <xsl:value-of select="FormatInsurance:PadSpaceRight(@num, 35)" />
    <!-- Coverage Type -->
    <xsl:value-of select="FormatInsurance:PadSpaceRight(xslHelper:CoverageType(Colls/Coll[@id=$CollID]/Cvgs/Cvg[@id=$ReqCovID]/@typCd), 1)" />
    <!-- Coverage Amount -->
    <xsl:value-of select="FormatInsurance:FormatAmount(Colls/Coll[@id=$CollID]/Cvgs/Cvg[@id=$ReqCovID]/Plcys/Plcy[@id=$PlcyID]/PlcyCvgs/PlcyCvg/@covAmt, 11)" />
    <!-- Agent Payee -->
    <xsl:value-of select="FormatInsurance:PadSpaceRight('''', 5)" />
    <!-- Company Payee -->
    <xsl:value-of select="xslHelper:GetCompanyPayeeCd(Colls/Coll[@id=$CollID]/Cvgs/Cvg[@id=$ReqCovID]/Plcys/Plcy[@id=$PlcyID]/@bicID, @num, Colls/Coll[@id=$CollID]/@line1, Colls/Coll[@id=$CollID]/Cvgs/Cvg[@id=$ReqCovID]/@typ)" />
    <!-- Policy Number -->
    <xsl:choose>
      <xsl:when test="Colls/Coll[@id=$CollID]/Cvgs/Cvg[@id=$ReqCovID]/@fpcInd=''Y''">
        <xsl:value-of select="FormatInsurance:PadSpaceRight(Colls/Coll[@id=$CollID]/Cvgs/Cvg[@id=$ReqCovID]/@fpcNumb, 18)" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="FormatInsurance:PadSpaceRight(Colls/Coll[@id=$CollID]/Cvgs/Cvg[@id=$ReqCovID]/Plcys/Plcy[@id=$PlcyID]/@num, 18)" />
      </xsl:otherwise>
    </xsl:choose>
    <!-- Cancel Date -->
    <xsl:choose>
      <xsl:when test="Colls/Coll[@id=$CollID]/Cvgs/Cvg[@id=$ReqCovID]/@fpcInd=''Y'' and Colls/Coll[@id = $CollID]/Cvgs/Cvg[@id=$ReqCovID]/@fpcCxlDt">
        <xsl:value-of select="FormatInsurance:PadSpaceRight(xslHelper:Get7ByteDate(Colls/Coll[@id = $CollID]/Cvgs/Cvg[@id=$ReqCovID]/@fpcCxlDt), 7)" />
      </xsl:when>
      <xsl:when test="Colls/Coll[@id=$CollID]/Cvgs/Cvg[@id=$ReqCovID]/@escrowIn=''N'' and Colls/Coll[@id = $CollID]/Cvgs/Cvg[@id=$ReqCovID]/Plcys/Plcy[@id=$PlcyID]/@cxlDt">
        <xsl:value-of select="FormatInsurance:PadSpaceRight(xslHelper:Get7ByteDate(Colls/Coll[@id = $CollID]/Cvgs/Cvg[@id=$ReqCovID]/Plcys/Plcy[@id=$PlcyID]/@cxlDt), 7)" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="FormatInsurance:PadSpaceRight('''', 7)" />
      </xsl:otherwise>
    </xsl:choose>
    <!-- Expire Date -->
    <xsl:choose>
      <xsl:when test="Colls/Coll[@id=$CollID]/Cvgs/Cvg[@id=$ReqCovID]/@fpcInd=''Y'' and Colls/Coll[@id = $CollID]/Cvgs/Cvg[@id=$ReqCovID]/@fpcExpDt">
        <xsl:value-of select="FormatInsurance:PadSpaceRight(xslHelper:Get7ByteDate(Colls/Coll[@id = $CollID]/Cvgs/Cvg[@id=$ReqCovID]/@fpcExpDt), 7)" />
      </xsl:when>
      <xsl:when test="Colls/Coll[@id=$CollID]/Cvgs/Cvg[@id=$ReqCovID]/@escrowIn=''N'' and Colls/Coll[@id = $CollID]/Cvgs/Cvg[@id=$ReqCovID]/Plcys/Plcy[@id=$PlcyID]/@expDt">
        <xsl:value-of select="FormatInsurance:PadSpaceRight(xslHelper:Get7ByteDate(Colls/Coll[@id = $CollID]/Cvgs/Cvg[@id=$ReqCovID]/Plcys/Plcy[@id=$PlcyID]/@expDt), 7)" />
      </xsl:when>
      <xsl:when test="Colls/Coll[@id=$CollID]/Cvgs/Cvg[@id=$ReqCovID]/@escrowIn=''Y'' and Colls/Coll[@id = $CollID]/Cvgs/Cvg[@id=$ReqCovID]/Plcys/Plcy[@id=$PlcyID]/@EndDt">
        <xsl:value-of select="FormatInsurance:PadSpaceRight(xslHelper:Get7ByteDate(Colls/Coll[@id = $CollID]/Cvgs/Cvg[@id=$ReqCovID]/Plcys/Plcy[@id=$PlcyID]/@EndDt), 7)" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="FormatInsurance:PadSpaceRight('''', 7)" />
      </xsl:otherwise>
    </xsl:choose>
    <!-- Effective Date -->
    <xsl:choose>
      <xsl:when test="Colls/Coll[@id=$CollID]/Cvgs/Cvg[@id=$ReqCovID]/@fpcInd=''Y'' and Colls/Coll[@id = $CollID]/Cvgs/Cvg[@id=$ReqCovID]/@fpcEffDt">
        <xsl:value-of select="FormatInsurance:PadSpaceRight(xslHelper:Get7ByteDate(Colls/Coll[@id = $CollID]/Cvgs/Cvg[@id=$ReqCovID]/@fpcEffDt), 7)" />
      </xsl:when>
      <xsl:when test="Colls/Coll[@id=$CollID]/Cvgs/Cvg[@id=$ReqCovID]/@escrowIn=''N'' and Colls/Coll[@id = $CollID]/Cvgs/Cvg[@id=$ReqCovID]/Plcys/Plcy[@id=$PlcyID]/@effDt">
        <xsl:value-of select="FormatInsurance:PadSpaceRight(xslHelper:Get7ByteDate(Colls/Coll[@id = $CollID]/Cvgs/Cvg[@id=$ReqCovID]/Plcys/Plcy[@id=$PlcyID]/@effDt), 7)" />
      </xsl:when>
      <xsl:when test="Colls/Coll[@id=$CollID]/Cvgs/Cvg[@id=$ReqCovID]/@escrowIn=''Y'' and Colls/Coll[@id = $CollID]/Cvgs/Cvg[@id=$ReqCovID]/Plcys/Plcy[@id=$PlcyID]/@eff1Dt">
        <xsl:value-of select="FormatInsurance:PadSpaceRight(xslHelper:Get7ByteDate(Colls/Coll[@id = $CollID]/Cvgs/Cvg[@id=$ReqCovID]/Plcys/Plcy[@id=$PlcyID]/@eff1Dt), 7)" />
      </xsl:when>
      <xsl:when test="Colls/Coll[@id=$CollID]/Cvgs/Cvg[@id=$ReqCovID]/@escrowIn=''Y'' and Colls/Coll[@id = $CollID]/Cvgs/Cvg[@id=$ReqCovID]/Plcys/Plcy[@id=$PlcyID]/@escrowDueDt">
        <xsl:value-of select="FormatInsurance:PadSpaceRight(xslHelper:Get7ByteDate(Colls/Coll[@id = $CollID]/Cvgs/Cvg[@id=$ReqCovID]/Plcys/Plcy[@id=$PlcyID]/@escrowDueDt), 7)" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="FormatInsurance:PadSpaceRight('''', 7)" />
      </xsl:otherwise>
    </xsl:choose>
    <!-- Escrow Ind -->
    <xsl:value-of select="FormatInsurance:PadSpaceRight(Colls/Coll[@id=$CollID]/Cvgs/Cvg[@id=$ReqCovID]/@escrowIn, 1)" />
    <!-- Premium Due Amount -->
    <xsl:choose>
      <xsl:when test="Colls/Coll[@id=$CollID]/Cvgs/Cvg[@id=$ReqCovID]/@fpcInd=''Y'' and Colls/Coll[@id=$CollID]/Cvgs/Cvg[@id=$ReqCovID]/@fpcPolicyAmt">
        <xsl:value-of select="FormatInsurance:FormatAmount(Colls/Coll[@id=$CollID]/Cvgs/Cvg[@id=$ReqCovID]/@fpcPolicyAmt, 8)" />
      </xsl:when>
      <xsl:when test="Colls/Coll[@id=$CollID]/Cvgs/Cvg[@id=$ReqCovID]/@escrowIn=''Y'' and Colls/Coll[@id=$CollID]/Cvgs/Cvg[@id=$ReqCovID]/Plcys/Plcy[@id=$PlcyID]/@policyAMT">
        <xsl:value-of select="FormatInsurance:FormatAmount(Colls/Coll[@id=$CollID]/Cvgs/Cvg[@id=$ReqCovID]/Plcys/Plcy[@id=$PlcyID]/@policyAMT, 8)" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="FormatInsurance:FormatAmount(''0.00'', 8)" />
      </xsl:otherwise>
    </xsl:choose>
    <!-- Premium Due Date -->
    <xsl:choose>
      <xsl:when test="Colls/Coll[@id=$CollID]/Cvgs/Cvg[@id=$ReqCovID]/@escrowIn=''N'' and Colls/Coll[@id = $CollID]/Cvgs/Cvg[@id=$ReqCovID]/Plcys/Plcy[@id=$PlcyID]/@expDt">
        <xsl:value-of select="FormatInsurance:PadSpaceRight(xslHelper:Get7ByteDate(Colls/Coll[@id = $CollID]/Cvgs/Cvg[@id=$ReqCovID]/Plcys/Plcy[@id=$PlcyID]/@expDt), 7)" />
      </xsl:when>
      <xsl:when test="Colls/Coll[@id=$CollID]/Cvgs/Cvg[@id=$ReqCovID]/Plcys/Plcy[@id=$PlcyID]/@escrowDueDt">
        <xsl:value-of select="FormatInsurance:PadSpaceRight(xslHelper:Get7ByteDate(Colls/Coll[@id=$CollID]/Cvgs/Cvg[@id=$ReqCovID]/Plcys/Plcy[@id=$PlcyID]/@escrowDueDt), 7)" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="FormatInsurance:PadSpaceRight('''', 7)" />
      </xsl:otherwise>
    </xsl:choose>
    <!-- Borrower Name -->
    <xsl:value-of select="FormatInsurance:PadSpaceRight(xslHelper:GetBorrowerName(Owners/Owner[@id=$OwnerID]/@firstName, Owners/Owner[@id=$OwnerID]/@lastName), 30)" />
    <!-- Property Address 1 -->
    <xsl:choose>
      <xsl:when test="Colls/Coll[@id=$CollID]/@line1">
        <xsl:value-of select="FormatInsurance:PadSpaceRight(FormatInsurance:LimitLength(Colls/Coll[@id=$CollID]/@line1, 30), 30)" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="FormatInsurance:PadSpaceRight('''', 30)" />
      </xsl:otherwise>
    </xsl:choose>
    <!-- Property Address 2 -->
    <xsl:choose>
      <xsl:when test="Colls/Coll[@id=$CollID]/@line2">
        <xsl:value-of select="FormatInsurance:PadSpaceRight(FormatInsurance:LimitLength(Colls/Coll[@id=$CollID]/@line2, 30), 30)" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="FormatInsurance:PadSpaceRight('''', 30)" />
      </xsl:otherwise>
    </xsl:choose>
    <!-- Property City -->
    <xsl:choose>
      <xsl:when test="Colls/Coll[@id=$CollID]/@city">
        <xsl:value-of select="FormatInsurance:PadSpaceRight(FormatInsurance:LimitLength(Colls/Coll[@id=$CollID]/@city, 25), 25)" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="FormatInsurance:PadSpaceRight('''', 25)" />
      </xsl:otherwise>
    </xsl:choose>
    <!-- Property State -->
    <xsl:choose>
      <xsl:when test="Colls/Coll[@id=$CollID]/@state">
        <xsl:value-of select="FormatInsurance:PadSpaceRight(FormatInsurance:LimitLength(Colls/Coll[@id=$CollID]/@state, 2), 2)" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="FormatInsurance:PadSpaceRight('''', 2)" />
      </xsl:otherwise>
    </xsl:choose>
    <!-- Property Zip -->
    <xsl:choose>
      <xsl:when test="Colls/Coll[@id=$CollID]/@zip">
        <xsl:value-of select="FormatInsurance:PadSpaceRight(FormatInsurance:LimitLength(Colls/Coll[@id=$CollID]/@zip, 5), 5)" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="FormatInsurance:PadSpaceRight('''', 5)" />
      </xsl:otherwise>
    </xsl:choose>
    <!-- Company Name -->
    <xsl:value-of select="FormatInsurance:PadSpaceRight(FormatInsurance:LimitLength(Colls/Coll[@id=$CollID]/Cvgs/Cvg[@id=$ReqCovID]/Plcys/Plcy[@id=$PlcyID]/@bicName, 30), 30)" />
    <!-- Company Line 1 -->
    <xsl:value-of select="FormatInsurance:PadSpaceRight('''', 30)" />
    <!-- Company Line 2 -->
    <xsl:value-of select="FormatInsurance:PadSpaceRight('''', 30)" />
    <!-- Company City -->
    <xsl:value-of select="FormatInsurance:PadSpaceRight('''', 25)" />
    <!-- Company State -->
    <xsl:value-of select="FormatInsurance:PadSpaceRight('''', 2)" />
    <!-- Company Zip -->
    <xsl:value-of select="FormatInsurance:PadSpaceRight('''', 5)" />
    <!-- Company Zip+4 -->
    <xsl:value-of select="FormatInsurance:PadSpaceRight('''', 4)" />
    <!-- Insurance Co. Name -->
    <xsl:value-of select="FormatInsurance:PadSpaceRight(FormatInsurance:LimitLength(Colls/Coll[@id=$CollID]/Cvgs/Cvg[@id=$ReqCovID]/Plcys/Plcy[@id=$PlcyID]/@bicName, 8), 8)" />
    <!-- Add Ins Flag -->
    <xsl:choose>
      <xsl:when test="Colls/Coll[@id = $CollID]/Cvgs/Cvg[@id=$ReqCovID]/Plcys/Plcy[@id=$PlcyID]/@otherAMT">
        <xsl:value-of select="FormatInsurance:PadSpaceRight(xslHelper:GetAddInsFlag(Colls/Coll[@id = $CollID]/Cvgs/Cvg[@id=$ReqCovID]/Plcys/Plcy[@id=$PlcyID]/@otherAMT), 1)" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="FormatInsurance:PadSpaceRight(''N'', 1)" />
      </xsl:otherwise>
    </xsl:choose>
    <!-- CR &LF -->
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
      
      public string LimitLength(string value, int length)
      {
         if (value == null)
         return string.Empty;

         return value.Substring(0, Math.Min(value.Length, length));
      }
     
      public string FormatAmount(string value, int length)
      {
         if ((value == null) || (value == string.Empty))
         {
            value = "0";
         }
         value = Convert.ToDecimal(value).ToString("0.00").Replace(".", string.Empty).PadLeft(length, ''0'');

         if (value.Length &gt; length)
         {
            value = "9".PadLeft(length, ''9'');
         }
         return value;
      }
  </msxsl:script>
</xsl:stylesheet>'

UPDATE COMMON_STYLESHEET
SET COMMON_XML = @thisxml,
UPDATE_DT = GETDATE(),
UPDATE_USER_TX = 'SCRIPT' 
where NAME_TX = @xlstName