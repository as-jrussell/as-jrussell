DECLARE @xlstName nvarchar(50) = 'FICS-BILLING'
DECLARE @xlstType nvarchar(4) = 'B'
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
      <xsl:for-each select="Billing/BillingXML">
         <xsl:apply-templates select="." />
      </xsl:for-each>
   </xsl:template>
   <xsl:template match="BillingXML">
      <xsl:param name="line-separator" select="''&#xD;&#xA;''" />
      <!-- 01: Lender # -->
      <xsl:value-of select="FormatInsurance:PadSpaceRight(xslHelper:GetFISCLenderCode(), 10)" />
      <!-- 11: Loan Number -->
      <xsl:value-of select="FormatInsurance:PadSpaceRight(LoanNumber, 20)"/>
      <!-- 31: Filler -->
      <xsl:value-of select="FormatInsurance:PadSpaceRight('''' , 1)" />
      <!-- 32: Delinquent Date -->
      <xsl:value-of select="FormatInsurance:PadSpaceRight('''', 8)" />
      <!-- 40: Unique Iden Code -->
      <xsl:value-of select="FormatInsurance:PadSpaceRight('''', 11)" />
      <!-- 51: Insurance Type Cd -->
      <xsl:value-of select="FormatInsurance:PadSpaceRight('''', 3)" />
      <!-- 54: Program Type Cd -->
      <xsl:value-of select="FormatInsurance:PadSpaceRight('''' , 2)" />
      <!-- 56: Property Type Cd -->
      <xsl:value-of select="FormatInsurance:PadSpaceRight('''', 15)" />
      <!-- 71: Company Payee Code -->
      <xsl:value-of select="FormatInsurance:PadSpaceRight(PayeeCode, 8)" />
      <!-- 79: Agent/Agency Payee Code -->
      <xsl:value-of select="FormatInsurance:PadSpaceRight('''', 8)" />
      <!-- 87: Payment Director Code -->
      <xsl:value-of select="FormatInsurance:PadSpaceRight(''C'', 1)" />
      <!-- 88: AM Best Code -->
      <xsl:value-of select="FormatInsurance:PadSpaceRight('''', 5)" />
      <!-- 93: NAIC Code -->
      <xsl:value-of select="FormatInsurance:PadSpaceRight('''', 5)" />
      <!-- 98: Premium Amount -->
      <xsl:value-of select="FormatInsurance:FormatAmount(Net, 11)"/>
      <!-- 109: Premium Due Date -->
      <xsl:value-of select="FormatInsurance:PadSpaceRight('''', 8)" />
      <!-- 117: Payment Identifier -->
      <xsl:value-of select="FormatInsurance:PadSpaceRight('''', 15)" />
      <!-- 132: Premium Paid Date -->
      <xsl:value-of select="FormatInsurance:PadSpaceRight(IssuePaidDate, 8)"/>
      <!-- 140: Policy/Coverage Eff Date -->
      <xsl:value-of select="FormatInsurance:PadSpaceRight(PolicyEffectiveDate, 8)" />
      <!-- 148: Policy Expiration Date -->
      <xsl:value-of select="FormatInsurance:PadSpaceRight(PolicyExpirationDate, 8)" />
      <!-- 156: Policy Cancellation Date -->
      <xsl:value-of select="FormatInsurance:PadSpaceRight('''', 8)" />
      <!-- 164: Policy Term -->
      <xsl:value-of select="FormatInsurance:PadSpaceRight('''', 3)" />
      <!-- 167: Payment Frequency -->
      <xsl:value-of select="FormatInsurance:PadSpaceRight(xslHelper:PaymentFrequency(FormatInsurance:DateFromStringYYYYMMDD(IssuePaidDate), FormatInsurance:DateFromStringYYYYMMDD(PolicyEffectiveDate)), 3)" />
      <!-- 170: Coverage Amount -->
      <xsl:value-of select="FormatInsurance:FormatAmountNoDecimal(Basis, 9)"/>
      <!-- 179: Policy Number -->
      <xsl:value-of select="FormatInsurance:PadSpaceRight(PolicyNumber, 40)"/>
      <!-- 219:Escrow Indicator -->
      <xsl:value-of select="FormatInsurance:PadSpaceRight(''E'', 1)" />
      <!-- 220: Transaction Type Code -->
      <xsl:value-of select="FormatInsurance:PadSpaceRight(''I'', 2)" />
      <!--222: Name-->
      <xsl:value-of select="FormatInsurance:LimitLength(FormatInsurance:PadSpaceRight(BorrowerInsComp, 40), 40)"/>
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
      <!--622: Flood Zone -->
      <xsl:value-of select="FormatInsurance:PadSpaceRight('''', 5)" />
      <!--627: Vehicle Year -->
      <xsl:value-of select="FormatInsurance:PadSpaceRight('''', 4)" />
      <!--631: Vehicle Make -->
      <xsl:value-of select="FormatInsurance:PadSpaceRight('''', 18)" />
      <!--649: Vehicle Model -->
      <xsl:value-of select="FormatInsurance:PadSpaceRight('''', 18)" />
      <!--667: Vehicle Identification -->
      <xsl:value-of select="FormatInsurance:PadSpaceRight('''', 17)" />
      <!--684: Old Policy Number -->
      <xsl:value-of select="FormatInsurance:PadSpaceRight('''', 25)" />
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
      
      public string LimitLength(string value, int length) 
      { 
         if (value == null) 
         { 
            return string.Empty; 
         }
         return value.Substring(0, Math.Min(value.Length, length)); 
      }      
      
      public string FormatAmount(string value, int length)
      {
         if ((value == null) || (value == string.Empty))
         {
            value = "0";
         }
         value = Convert.ToDecimal(value).ToString("0.00").PadLeft(length, ''0'');
         
         if (value.Length &gt; length)
         {
            value = "9.99".PadLeft(length, ''9''); 
         }
         return value;
      }
      
      public string FormatAmountNoDecimal(string value, int length)
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
      

      public string FormatYYYYMMDD(string value)
      {
         if ((value == null) || (value == string.Empty))
         {
            return PadSpaceRight(string.Empty, 7);
         }
         else
         {
            string pattern = "yyyy-MM-dd";
            DateTime parsedDate;
            DateTime.TryParseExact(value.Substring, pattern, null, System.Globalization.DateTimeStyles.None, out parsedDate);
            if (parsedDate = DateTime.MinValue)
            {
               return PadSpaceRight("", 8);
            }
            else
            {
               return parsedDate.ToString("yyyyMMdd");
            }
         }
      }      
      
      public DateTime DateFromStringYYYYMMDD(string value)
      {
         if (value.Length.Equals(8))
         {
            DateTime parsedDate;
            DateTime.TryParseExact(value, "yyyyMMdd", null, System.Globalization.DateTimeStyles.None, out parsedDate);
            return parsedDate;
         }
         else
         {
            return DateTime.MinValue;
         }
      }
   </msxsl:script>
</xsl:stylesheet>'

UPDATE COMMON_STYLESHEET
SET COMMON_XML = @thisxml,
UPDATE_DT = GETDATE(),
UPDATE_USER_TX = 'SCRIPT' 
where NAME_TX = @xlstName