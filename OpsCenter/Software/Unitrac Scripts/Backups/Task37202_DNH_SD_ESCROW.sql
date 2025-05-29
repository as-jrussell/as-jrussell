DECLARE @xlstName nvarchar(50) = 'DNH-ESCROW'
DECLARE @xlstType nvarchar(4) = 'E'
IF NOT EXISTS (select 1 from COMMON_STYLESHEET where NAME_TX = @xlstName)
BEGIN
	INSERT INTO COMMON_STYLESHEET
	(NAME_TX, TYPE_CD, CREATE_DT, UPDATE_DT, UPDATE_USER_TX, PURGE_DT, LOCK_ID, DEFAULT_IN)
	VALUES
	(@xlstName, @xlstType, GETDATE(), GETDATE(), 'SCRIPT', NULL, 1, 'N')
END

declare @thisxml xml = 
'<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:xslHelper="urn:xslHelper" 
                xmlns:msxsl="urn:schemas-microsoft-com:xslt" 
                xmlns:FormatInsurance="urn:custom-scripts-csharp"
                >
   <xsl:preserve-space elements="xsl:text"/>
   <xsl:output method="text" omit-xml-declaration="yes" indent="no"/>
   <xsl:decimal-format name="us" decimal-separator="." grouping-separator=","/>
   <xsl:template match="/">
      <xsl:for-each select="Escrow/EscrowXML/EscrowBaseXML">
         <xsl:apply-templates select="." />
      </xsl:for-each>
   </xsl:template>
   <xsl:template match="EscrowBaseXML">
      <xsl:param name="line-separator" select="''&#xD;&#xA;''" />
      <!-- Loan Number -->      
      <xsl:value-of select="FormatInsurance:PadSpaceRight(FormatInsurance:PadZeroLeft(LoanNumber, 10), 35)"/>
      <!-- Coverage Type -->
      <xsl:value-of select="FormatInsurance:TranslateCoverageType(TypeCode)"/>
      <!-- Coverage Amount -->
      <xsl:value-of select="FormatInsurance:FormatAmount(CoverageAmount, 11)"/>
      <!-- Agent Payee -->
      <xsl:value-of select="FormatInsurance:PadSpaceRight('''', 5)"/>
      <!-- Company Payee -->
      <xsl:value-of select="FormatInsurance:PadZeroLeft(PayeeCode, 5)"/>
      <!-- Policy Number -->
      <xsl:value-of select="FormatInsurance:PadSpaceRight(PolicyNumber, 18)"/>
      <!-- Cancel Date -->
      <xsl:value-of select="FormatInsurance:FormatCYYMMDD('''')"/>
      <!-- Expire Date -->
      <xsl:value-of select="FormatInsurance:FormatCYYMMDD(PolicyExpirationDate)"/>
      <!-- Effective Date -->
      <xsl:value-of select="FormatInsurance:FormatCYYMMDD(PolicyEffectiveDate)"/>
      <!-- Escrow Ind -->
      <xsl:value-of select="''Y''"/>
      <!-- Premium Due Amount -->
      <xsl:value-of select="FormatInsurance:FormatAmount(Premium, 8)"/>
      <!-- Premium Due Date -->
      <xsl:value-of select="FormatInsurance:FormatCYYMMDD(DueDate)"/>
      <!-- Borrower Name -->
      <xsl:value-of select="FormatInsurance:LimitLength(FormatInsurance:PadSpaceRight(concat(LastName, '', '', FirstName), 30), 30)"/>
      <!-- Property Address 1 -->
      <xsl:value-of select="FormatInsurance:PadSpaceRight(PropertyAddress1, 30)"/>
      <!-- Property Address 2 -->
      <xsl:value-of select="FormatInsurance:PadSpaceRight(PropertyAddress2, 30)"/>
      <!-- Property City -->
      <xsl:value-of select="FormatInsurance:PadSpaceRight(PropertyCity, 25)"/>
      <!-- Property State -->
      <xsl:value-of select="FormatInsurance:PadSpaceRight(PropertyState, 2)"/>
      <!-- Property Zip -->
      <xsl:value-of select="FormatInsurance:LimitLength(FormatInsurance:PadSpaceRight(PropertyZip, 5), 5)"/>
      <!-- Company Name -->
      <xsl:value-of select="FormatInsurance:PadSpaceRight('''', 30)"/>
      <!-- Company Line 1 -->
      <xsl:value-of select="FormatInsurance:PadSpaceRight('''', 30)"/>
      <!-- Company Line 2 -->
      <xsl:value-of select="FormatInsurance:PadSpaceRight('''', 30)"/>
      <!-- Company City -->
      <xsl:value-of select="FormatInsurance:PadSpaceRight('''', 25)"/>
      <!-- Company State -->
      <xsl:value-of select="FormatInsurance:PadSpaceRight('''', 2)"/>
      <!-- Company Zip -->
      <xsl:value-of select="FormatInsurance:PadSpaceRight('''', 5)"/>
      <!-- Company Zip+4 -->
      <xsl:value-of select="FormatInsurance:PadSpaceRight('''', 4)"/>
      <!-- Insurance Co. Name -->
      <xsl:value-of select="FormatInsurance:LimitLength(FormatInsurance:PadSpaceRight(Company, 8), 8)"/>
      <!-- Add Ins Flag -->
      <xsl:choose>
         <xsl:when test="Other=''0.00''">
            <xsl:value-of select="'' ''"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:value-of select="''Y''"/>
         </xsl:otherwise>
      </xsl:choose>
      <!-- CR &LF -->
      <xsl:value-of select="$line-separator"/>
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
      
      public string PadZeroLeft(string value, int length)
      {
         if (value == null)
         {
            value = string.Empty;
         }
         return value.Trim().PadLeft(length, ''0'');      
      }
      
      public string LimitLength(string value, int length) 
      { 
         if (value == null) 
         { 
            return string.Empty; 
         }
         return value.Substring(0, Math.Min(value.Length, length)); 
      }
      
      public string FormatCYYMMDD(string value)
      {
         if ((value == null) || (value == string.Empty))
         {
            return PadSpaceRight(string.Empty, 7);
         }
         else
         {
            string pattern = "yyyyMMdd";
            DateTime parsedDate;
            DateTime.TryParseExact(value, pattern, null, System.Globalization.DateTimeStyles.None, out parsedDate);
            if (parsedDate.Year &gt; 1999)
            {
               return "1" + parsedDate.ToString("yyMMdd"); 
            }
            else
            {
               return "0" + parsedDate.ToString("yyMMdd"); 
            }
         }              
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
      
      public string TranslateCoverageType(string value)
      {
         switch (value)
         {
            case "FLOOD":
               return "W";
            case "HAZARD":
               return "H";
            case "WIND":
               return "A";
            default:
               return " ";
         }
      }
   </msxsl:script>
</xsl:stylesheet>'

UPDATE COMMON_STYLESHEET
SET COMMON_XML = @thisxml,
UPDATE_DT = GETDATE(),
UPDATE_USER_TX = 'Task37202',
LOCK_ID = LOCK_ID + 1  
where NAME_TX = @xlstName