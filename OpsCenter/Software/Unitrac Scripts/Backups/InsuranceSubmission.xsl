<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/XSL/Format">

   <xsl:param name="param1"/>
   <xsl:param name="param2"/>
   <xsl:param name="param3"/>

   <!-- define common attributes -->
   <xsl:attribute-set name="HeaderStyle">
      <xsl:attribute name="border">1px solid blue</xsl:attribute>
      <xsl:attribute name="padding">1pt</xsl:attribute>
      <xsl:attribute name="font">bold 11pt Candara</xsl:attribute>
      <xsl:attribute name="text-align">center</xsl:attribute>
      <xsl:attribute name="background-color">#cccccc</xsl:attribute>
   </xsl:attribute-set>
   <xsl:attribute-set name="LabelStyle">
      <xsl:attribute name="font">bold 10pt Candara</xsl:attribute>
      <xsl:attribute name="margin-left">5px</xsl:attribute>
      <xsl:attribute name="space-after">.2cm</xsl:attribute>
   </xsl:attribute-set>
   <xsl:attribute-set name="InputStyle">
      <xsl:attribute name="width">1cm</xsl:attribute>
      <xsl:attribute name="border">1px solid gray</xsl:attribute>
      <xsl:attribute name="margin-left">10px</xsl:attribute>
      <xsl:attribute name="margin-right">10px</xsl:attribute>
      <xsl:attribute name="padding-left">3px</xsl:attribute>
      <xsl:attribute name="space-before">.1cm</xsl:attribute>
      <xsl:attribute name="font">bold 10pt Arial</xsl:attribute>
   </xsl:attribute-set>

   <xsl:strip-space elements='*'/>

   <xsl:template match="InsuranceDocument">

      <xsl:variable name="AddlNameRaw">
         <xsl:value-of select="Insured/AdditionalName"/>
      </xsl:variable>
      <xsl:variable name="AddlName">
         <xsl:if test="$AddlNameRaw = ''">&#xA0;</xsl:if>
         <xsl:value-of select="$AddlNameRaw"/>
      </xsl:variable>
      <xsl:variable name="BwrPhoneRaw">
         <xsl:value-of select="substring(Insured/PhoneNumber,1,10)"/>
      </xsl:variable>
      <xsl:variable name="BwrExtRaw">
         <xsl:value-of select="substring(Insured/PhoneNumber,11)"/>
      </xsl:variable>
      <xsl:variable name="BwrPhone">
         <xsl:if test="$BwrPhoneRaw = ''">&#xA0;</xsl:if>
         <xsl:if test="$BwrPhoneRaw != '' and ($BwrExtRaw = '' or substring($BwrExtRaw,1,1) = 'x')">
            <xsl:value-of select="format-number($BwrPhoneRaw, '(###) ###-####')"/>
         </xsl:if>
         <xsl:if test="$BwrPhoneRaw != '' and ($BwrExtRaw != '' and substring($BwrExtRaw,1,1) != 'x')">
            <xsl:value-of select="$BwrPhoneRaw"/>
         </xsl:if>
         <xsl:if test="$BwrExtRaw != '' and substring($BwrExtRaw,1,1) = 'x'">
            &#xA0;<xsl:value-of select="$BwrExtRaw"/>
         </xsl:if>
         <xsl:if test="$BwrExtRaw != '' and substring($BwrExtRaw,1,1) != 'x'">
            <xsl:value-of select="$BwrExtRaw"/>
         </xsl:if>
      </xsl:variable>
      <xsl:variable name="BwrEmailRaw">
         <xsl:value-of select="Insured/Email"/>
      </xsl:variable>
      <xsl:variable name="BwrEmail">
         <xsl:if test="$BwrEmailRaw = ''">&#xA0;</xsl:if>
         <xsl:value-of select="$BwrEmailRaw"/>
      </xsl:variable>
      <xsl:variable name="PropertyDescRaw">
         <xsl:value-of select="Property/Description"/>
      </xsl:variable>
      <xsl:variable name="PropertyDesc">
         <xsl:if test="$PropertyDescRaw = ''">&#xA0;</xsl:if>
         <xsl:value-of select="$PropertyDescRaw"/>
      </xsl:variable>
      <xsl:variable name="LoanNbr">
         <xsl:value-of select="@LoanNumber"/>
      </xsl:variable>
      <xsl:variable name="PropType">
         <xsl:value-of select="Property/@Type"/>
      </xsl:variable>
      <xsl:variable name="InsNameRaw">
         <xsl:value-of select="InsuranceCompany/Name"/>
      </xsl:variable>
      <xsl:variable name="InsName">
         <xsl:if test="$InsNameRaw = ''">&#xA0;</xsl:if>
         <xsl:value-of select="$InsNameRaw"/>
      </xsl:variable>
      <xsl:variable name="InsPhoneRaw">
         <xsl:value-of select="substring(InsuranceCompany/PhoneNumber,1,10)"/>
      </xsl:variable>
      <xsl:variable name="InsExtRaw">
         <xsl:value-of select="substring(InsuranceCompany/PhoneNumber,11)"/>
      </xsl:variable>
      <xsl:variable name="InsPhone">
         <xsl:if test="$InsPhoneRaw = ''">&#xA0;</xsl:if>
         <xsl:if test="$InsPhoneRaw != '' and ($InsExtRaw = '' or substring($InsExtRaw,1,1) = 'x')">
            <xsl:value-of select="format-number($InsPhoneRaw, '(###) ###-####')"/>
         </xsl:if>
         <xsl:if test="$InsPhoneRaw != '' and ($InsExtRaw != '' and substring($InsExtRaw,1,1) != 'x')">
            <xsl:value-of select="$InsPhoneRaw"/>
         </xsl:if>
         <xsl:if test="$InsExtRaw != '' and substring($InsExtRaw,1,1) = 'x'">
            &#xA0;<xsl:value-of select="$InsExtRaw"/>
         </xsl:if>
         <xsl:if test="$InsExtRaw != '' and substring($InsExtRaw,1,1) != 'x'">
            <xsl:value-of select="$InsExtRaw"/>
         </xsl:if>
      </xsl:variable>
      <xsl:variable name="AgencyNameRaw">
         <xsl:value-of select="InsuranceCompany/Agency/Name"/>
      </xsl:variable>
      <xsl:variable name="AgencyName">
         <xsl:if test="$AgencyNameRaw = ''">&#xA0;</xsl:if>
         <xsl:value-of select="$AgencyNameRaw"/>
      </xsl:variable>
      <xsl:variable name="AgencyPhoneRaw">
         <xsl:value-of select="substring(InsuranceCompany/Agency/PhoneNumber,1,10)"/>
      </xsl:variable>
      <xsl:variable name="AgencyExtRaw">
         <xsl:value-of select="substring(InsuranceCompany/Agency/PhoneNumber,11)"/>
      </xsl:variable>
      <xsl:variable name="AgencyPhone">
         <xsl:if test="$AgencyPhoneRaw = ''">&#xA0;</xsl:if>
         <xsl:if test="$AgencyPhoneRaw != '' and ($AgencyExtRaw = '' or substring($AgencyExtRaw,1,1) = 'x')">
            <xsl:value-of select="format-number($AgencyPhoneRaw, '(###) ###-####')"/>
         </xsl:if>
         <xsl:if test="$AgencyPhoneRaw != '' and ($AgencyExtRaw != '' and substring($AgencyExtRaw,1,1) != 'x')">
            <xsl:value-of select="$AgencyPhoneRaw"/>
         </xsl:if>
         <xsl:if test="$AgencyExtRaw != '' and substring($AgencyExtRaw,1,1) = 'x'">
            &#xA0;<xsl:value-of select="$AgencyExtRaw"/>
         </xsl:if>
         <xsl:if test="$AgencyExtRaw != '' and substring($AgencyExtRaw,1,1) != 'x'">
            <xsl:value-of select="$AgencyExtRaw"/>
         </xsl:if>
      </xsl:variable>
      <xsl:variable name="AgentNameRaw">
         <xsl:value-of select="InsuranceCompany/Agency/Agent/Name"/>
      </xsl:variable>
      <xsl:variable name="AgentName">
         <xsl:if test="$AgentNameRaw = ''">&#xA0;</xsl:if>
         <xsl:value-of select="$AgentNameRaw"/>
      </xsl:variable>
      <xsl:variable name="AgentEmailRaw">
         <xsl:value-of select="InsuranceCompany/Agency/Agent/Email"/>
      </xsl:variable>
      <xsl:variable name="AgentEmail">
         <xsl:if test="$AgentEmailRaw = ''">&#xA0;</xsl:if>
         <xsl:value-of select="$AgentEmailRaw"/>
      </xsl:variable>
      <xsl:variable name="ExpireDateRaw">
         <xsl:value-of select="Policy/ExpirationDate"/>
      </xsl:variable>
      <xsl:variable name="ExpireDate">
         <xsl:if test="$ExpireDateRaw = ''">&#xA0;</xsl:if>
         <xsl:value-of select="$ExpireDateRaw"/>
      </xsl:variable>
      <xsl:variable name="CollDeductRaw">
         <xsl:if test="CoverageInformation[@Qualifier='NC']/Type='Collision'">No Collision</xsl:if>
      </xsl:variable>
      <xsl:variable name="CollDeduct">
         <xsl:if test="$CollDeductRaw = 'No Collision'">
            <xsl:value-of select="$CollDeductRaw"/>
         </xsl:if>
         <xsl:if test="$CollDeductRaw != 'No Collision'">
           <xsl:choose>
             <xsl:when test="CoverageInformation[@Qualifier = 'COLL']/DeductibleAmount">
               <xsl:value-of select="CoverageInformation[@Qualifier = 'COLL']/DeductibleAmount"/>
             </xsl:when>
           </xsl:choose>
         </xsl:if>
      </xsl:variable>
      <xsl:variable name="CompDeductRaw">
         <xsl:if test="CoverageInformation[@Qualifier='NC']/Type='Comprehensive'">No Comprehensive</xsl:if>
      </xsl:variable>
      <xsl:variable name="CompDeduct">
         <xsl:if test="$CompDeductRaw = 'No Comprehensive'">
            <xsl:value-of select="$CompDeductRaw"/>
         </xsl:if>
         <xsl:if test="$CompDeductRaw != 'No Comprehensive'">
           <xsl:choose>
             <xsl:when test="CoverageInformation[@Qualifier = 'COMP']/DeductibleAmount">
               <xsl:value-of select="CoverageInformation[@Qualifier = 'COMP']/DeductibleAmount"/>
             </xsl:when>

             <xsl:when test="CoverageInformation[@Qualifier = 'DWELL']//CoverageAmount">
               <xsl:value-of select="CoverageInformation[@Qualifier = 'DWELL']//CoverageAmount"/>
             </xsl:when>
           </xsl:choose>
         </xsl:if>
      </xsl:variable>
      <xsl:variable name="CoverageAmnt">
         <xsl:if test="$CompDeductRaw = 'No Comprehensive'">
            <xsl:value-of select="$CompDeductRaw"/>
         </xsl:if>
         <xsl:if test="$CompDeductRaw != 'No Comprehensive'">
            <xsl:value-of select="$CompDeduct"/>
         </xsl:if>
      </xsl:variable>
      <xsl:variable name="LienholderListedRaw">
         <xsl:value-of select="LienHolder/IsPayeeListed"/>
      </xsl:variable>
      <xsl:variable name="LienholderListed">
         <xsl:if test="$LienholderListedRaw = 'true'">Yes</xsl:if>
         <xsl:if test="$LienholderListedRaw = 'false'">No</xsl:if>
         <xsl:if test="$LienholderListedRaw = ''">No</xsl:if>
      </xsl:variable>
      <xsl:variable name="LienholderNameRaw">
         <xsl:value-of select="LienHolder/CompanyName"/>
      </xsl:variable>
      <xsl:variable name="LienholderName">
         <xsl:if test="$LienholderNameRaw = ''">&#xA0;</xsl:if>
         <xsl:value-of select="$LienholderNameRaw"/>
      </xsl:variable>
      <xsl:variable name="LienholderAddrRaw">
         <xsl:value-of select="LienHolder/Address/Line1"/>
         <xsl:value-of select="LienHolder/Address/City"/>
         <xsl:value-of select="LienHolder/Address/StateAbbreviation"/>
      </xsl:variable>
      <xsl:variable name="LienholderAddr">
         <xsl:if test="$LienholderAddrRaw = ''">&#xA0;</xsl:if>
      </xsl:variable>
      <xsl:variable name="InsuredAddrRaw">
         <xsl:value-of select="Insured/Address/Line1"/>
         <xsl:value-of select="Insured/Address/City"/>
         <xsl:value-of select="Insured/Address/StateAbbreviation"/>
      </xsl:variable>
      <xsl:variable name="InsuredAddr">
         <xsl:if test="$InsuredAddrRaw = ''">&#xA0;</xsl:if>
      </xsl:variable>
      <xsl:variable name="PropertyAddrRaw">
         <xsl:value-of select="Property/Address/Line1"/>
         <xsl:value-of select="Property/Address/City"/>
         <xsl:value-of select="Property/Address/StateAbbreviation"/>
      </xsl:variable>
      <xsl:variable name="PropertyAddr">
         <xsl:if test="$PropertyAddrRaw = ''">&#xA0;</xsl:if>
      </xsl:variable>
      <xsl:variable name="LienholderLabel">
         <xsl:if test="($PropType = 'Real Estate') or ($PropType='Mobile Home')">Mortgagee</xsl:if>
         <xsl:if test="($PropType = 'Vehicle') or ($PropType='Boat')">Lienholder</xsl:if>
      </xsl:variable>
      <xsl:variable name="RealEstateLabel">
         <xsl:if test="$PropType = 'Real Estate'">Real Estate Information</xsl:if>
         <xsl:if test="$PropType='Mobile Home'">Mobile Home Address</xsl:if>
      </xsl:variable>
      <xsl:variable name="VinLabel">
         <xsl:if test="$PropType = 'Boat'">Hull Number:</xsl:if>
         <xsl:if test="$PropType != 'Boat'">Vehicle Identification Number (VIN):</xsl:if>
      </xsl:variable>

      <root>

         <layout-master-set>

            <simple-page-master master-name="page" margin-top=".75cm" margin-left="1cm" margin-right="1cm" margin-bottom=".75cm">
               <region-body region-name="body" />
            </simple-page-master>

         </layout-master-set>

         <page-sequence master-reference="page">

            <flow flow-name="body" font="bold 10pt Arial">
               <!--<block space-before="6pt" space-after=".2cm" height="1in" width="8in">
                <external-graphic src="Images/Header1_eng.gif" content-width="scale-to-fit" content-height="scale-to-fit"/>
                <external-graphic src="Images/Header2_eng.gif" content-width="scale-to-fit" content-height="scale-to-fit"/>
                <external-graphic src="Images/Header3_eng.gif" content-width="scale-to-fit" content-height="scale-to-fit"/>
                <external-graphic src="Images/Header4.gif" content-width="scale-to-fit" content-height="scale-to-fit"/>
                <external-graphic src="Images/Header5.gif" content-width="scale-to-fit" content-height="scale-to-fit"/>
                <external-graphic src="Images/Header6.gif" content-width="scale-to-fit" content-height="scale-to-fit"/>
                <external-graphic src="Images/Header7.gif" content-width="scale-to-fit" content-height="scale-to-fit"/>
             </block>-->
               <block space-before="6pt" space-after=".5cm" font="bold 14pt Arial" text-align="center" width="8in">
                  Insurance Submission
               </block>

               <table space-after=".2cm">
                  <!-- this table is for defining the header area -->
                  <table-column column-width='55%'/>
                  <table-column column-width='45%'/>
                  <table-body>
                     <table-row>
                        <table-cell>
                           <block>
                              Reference Id: <xsl:value-of select="@Id"/>
                           </block>
                           <block>
                              Control Number: <xsl:value-of select="LenderControlNumber"/>
                           </block>
                           <block>
                              Loan Number: <xsl:value-of select="$LoanNbr"/>
                           </block>
                        </table-cell>
                        <table-cell>
                           <block>
                              Date Submitted: <xsl:value-of select="SubmitDateTime"/>
                           </block>
                           <block>
                              Originator: <xsl:value-of select="Originator"/>
                           </block>
                        </table-cell>
                     </table-row>
                  </table-body>
               </table>
               <table>
                  <table-column column-width='54%'/>
                  <table-column column-width='46%'/>
                  <table-header>
                     <table-row>
                        <table-cell xsl:use-attribute-sets="HeaderStyle" number-columns-spanned="2">
                           <block>Policy Type</block>
                        </table-cell>
                     </table-row>
                  </table-header>
                  <table-body>
                     <table-row>
                        <table-cell border="1px solid blue" padding="2pt">
                           <block xsl:use-attribute-sets="LabelStyle">
                              Property Type: <xsl:value-of select="Property/@Type"/>
                           </block>
                        </table-cell>
                        <table-cell border="1px solid blue" padding="2pt">
                           <block xsl:use-attribute-sets="LabelStyle">
                              Policy Status: <xsl:value-of select="PolicyStatus"/>
                           </block>
                        </table-cell>
                     </table-row>
                  </table-body>
               </table>

               <table>
                  <!-- this table is for defining 2 columns -->
                  <table-column column-width='55%'/>
                  <table-column column-width='45%'/>
                  <table-body>
                     <table-row>
                        <table-cell>
                           <!-- this cell defines the left column -->
                           <table padding-top=".2cm">
                              <!-- Financial info group box -->
                              <table-column column-width='98%'/>
                              <table-header>
                                 <table-row>
                                    <table-cell xsl:use-attribute-sets="HeaderStyle">
                                       <block>Financial Information</block>
                                    </table-cell>
                                 </table-row>
                              </table-header>
                              <table-body>
                                 <table-row>
                                    <table-cell border="1px solid blue" padding="2pt">
                                       <block xsl:use-attribute-sets="LabelStyle">
                                          Financial Institution:
                                          <block xsl:use-attribute-sets="InputStyle">
                                             <xsl:value-of select="LienHolder/AdditionalName"/>
                                          </block>
                                       </block>
                                       <block xsl:use-attribute-sets="LabelStyle">
                                          Is the <xsl:value-of select="$LienholderLabel"/> listed on the policy:
                                          <block xsl:use-attribute-sets="InputStyle">
                                             <xsl:value-of select="$LienholderListed"/>
                                          </block>
                                       </block>
                                       <block xsl:use-attribute-sets="LabelStyle">
                                          <xsl:value-of select="$LienholderLabel"/> Name:
                                          <block xsl:use-attribute-sets="InputStyle">
                                             <xsl:value-of select="$LienholderName"/>
                                          </block>
                                       </block>
                                       <block xsl:use-attribute-sets="LabelStyle">
                                          <xsl:value-of select="$LienholderLabel"/> Address:
                                          <block xsl:use-attribute-sets="InputStyle">
                                             <xsl:if test="$LienholderAddrRaw != ''">
                                                <block>
                                                   <xsl:value-of select="LienHolder/Address/Line1"/>
                                                </block>
                                                <block>
                                                   <xsl:value-of select="LienHolder/Address/Line2"/>
                                                </block>
                                                <block>
                                                   <xsl:value-of select="LienHolder/Address/City"/>, <xsl:value-of select="LienHolder/Address/StateAbbreviation"/>&#xA0;&#xA0;<xsl:value-of select="LienHolder/Address/Zip"/>
                                                </block>
                                             </xsl:if>
                                             <xsl:if test="$LienholderAddrRaw = ''">
                                                <block>&#xA0;</block>
                                             </xsl:if>
                                          </block>
                                       </block>
                                    </table-cell>
                                 </table-row>
                              </table-body>
                           </table>
                           <xsl:if test="($PropType = 'Real Estate') or ($PropType='Mobile Home')">
                              <table padding-top=".2cm">
                                 <!-- Property Info group box -->
                                 <table-column column-width='98%'/>
                                 <table-header>
                                    <table-row>
                                       <table-cell xsl:use-attribute-sets="HeaderStyle">
                                          <block>
                                             <xsl:value-of select="$RealEstateLabel"/>
                                          </block>
                                       </table-cell>
                                    </table-row>
                                 </table-header>
                                 <table-body>
                                    <table-row>
                                       <table-cell border="1px solid blue" padding="2pt">
                                          <block xsl:use-attribute-sets="LabelStyle">
                                             Physical Address:
                                             <block xsl:use-attribute-sets="InputStyle">
                                                <xsl:if test="$PropertyAddrRaw != ''">
                                                   <block>
                                                      <xsl:value-of select="Property/Address/Line1"/>
                                                   </block>
                                                   <block>
                                                      <xsl:value-of select="Property/Address/Line2"/>
                                                   </block>
                                                   <block>
                                                      <xsl:value-of select="Property/Address/City"/>, <xsl:value-of select="Property/Address/StateAbbreviation"/>&#xA0;&#xA0;<xsl:value-of select="Property/Address/Zip"/>
                                                   </block>
                                                </xsl:if>
                                                <xsl:if test="$PropertyAddrRaw = ''">
                                                   <block>&#xA0;</block>
                                                </xsl:if>
                                             </block>
                                          </block>
                                          <xsl:if test="$PropertyDesc != ''">
                                             <block xsl:use-attribute-sets="LabelStyle">
                                                Description:
                                                <block xsl:use-attribute-sets="InputStyle">
                                                   <block>
                                                      <xsl:value-of select="$PropertyDesc"/>
                                                   </block>
                                                </block>
                                             </block>
                                          </xsl:if>
                                       </table-cell>
                                    </table-row>
                                 </table-body>
                              </table>
                           </xsl:if>
                           <xsl:if test="($PropType != 'Real Estate')">
                              <table padding-top=".2cm">
                                 <!-- Vehicle Info group box -->
                                 <table-column column-width='98%'/>
                                 <table-header>
                                    <table-row>
                                       <table-cell xsl:use-attribute-sets="HeaderStyle">
                                          <block>
                                             <xsl:value-of select="$PropType"/> Information
                                          </block>
                                       </table-cell>
                                    </table-row>
                                 </table-header>
                                 <table-body>
                                    <table-row>
                                       <table-cell border="1px solid blue" padding="2pt">
                                          <table>
                                             <table-body>
                                                <table-row xsl:use-attribute-sets="LabelStyle">
                                                   <table-cell padding="2pt">
                                                      <block>Year:</block>
                                                   </table-cell>
                                                   <table-cell padding="2pt">
                                                      <block>Make:</block>
                                                   </table-cell>
                                                   <table-cell padding="2pt">
                                                      <block>Model:</block>
                                                   </table-cell>
                                                </table-row>
                                                <table-row>
                                                   <table-cell padding="2pt">
                                                      <block xsl:use-attribute-sets="InputStyle" margin-right="2px">
                                                         <xsl:value-of select="Property/Vehicle/Year"/>
                                                      </block>
                                                   </table-cell>
                                                   <table-cell padding="2pt">
                                                      <block xsl:use-attribute-sets="InputStyle" margin-left="2px" margin-right="2px">
                                                         <xsl:value-of select="Property/Vehicle/Make"/>
                                                      </block>
                                                   </table-cell>
                                                   <table-cell padding="2pt">
                                                      <block xsl:use-attribute-sets="InputStyle" margin-left="2px">
                                                         <xsl:value-of select="Property/Vehicle/Model"/>
                                                      </block>
                                                   </table-cell>
                                                </table-row>
                                                <table-row>
                                                   <table-cell padding="2pt" number-columns-spanned="3">
                                                      <block space-before=".2cm" xsl:use-attribute-sets="LabelStyle">
                                                         <xsl:value-of select="$VinLabel"/>
                                                         <block xsl:use-attribute-sets="InputStyle">
                                                            <block>
                                                               <xsl:value-of select="Property/Vehicle/VIN"/>
                                                            </block>
                                                         </block>
                                                      </block>
                                                   </table-cell>
                                                </table-row>
                                             </table-body>
                                          </table>
                                       </table-cell>
                                    </table-row>
                                 </table-body>
                              </table>
                           </xsl:if>
                           <table padding-top=".2cm">
                              <!-- Borrower Info group box -->
                              <table-column column-width='98%'/>
                              <table-header>
                                 <table-row>
                                    <table-cell xsl:use-attribute-sets="HeaderStyle">
                                       <block>Borrower Information</block>
                                    </table-cell>
                                 </table-row>
                              </table-header>
                              <table-body>
                                 <table-row>
                                    <table-cell border="1px solid blue" padding="2pt">
                                       <block xsl:use-attribute-sets="LabelStyle">
                                          Name of Insured:
                                          <block xsl:use-attribute-sets="InputStyle">
                                             <xsl:value-of select="Insured/FirstName"/>
                                             <inline space-start=".2cm"/>
                                             <xsl:value-of select="Insured/LastName"/>
                                          </block>
                                       </block>
                                       <block xsl:use-attribute-sets="LabelStyle">
                                          Additional name:
                                          <block xsl:use-attribute-sets="InputStyle">
                                             <xsl:value-of select="$AddlName"/>
                                          </block>
                                       </block>
                                       <block xsl:use-attribute-sets="LabelStyle">
                                          Phone Number:
                                          <block xsl:use-attribute-sets="InputStyle">
                                             <xsl:value-of select="$BwrPhone"/>
                                          </block>
                                       </block>
                                       <block xsl:use-attribute-sets="LabelStyle">
                                          Email:
                                          <block xsl:use-attribute-sets="InputStyle">
                                             <xsl:value-of select="$BwrEmail"/>
                                          </block>
                                       </block>
                                       <block xsl:use-attribute-sets="LabelStyle">
                                          Current Address:
                                          <block xsl:use-attribute-sets="InputStyle">
                                             <xsl:if test="$InsuredAddrRaw != ''">
                                                <block>
                                                   <xsl:value-of select="Insured/Address/Line1"/>
                                                </block>
                                                <block>
                                                   <xsl:value-of select="Insured/Address/Line2"/>
                                                </block>
                                                <block>
                                                   <xsl:value-of select="Insured/Address/City"/>, <xsl:value-of select="Insured/Address/StateAbbreviation"/>&#xA0;&#xA0;<xsl:value-of select="Insured/Address/Zip"/>
                                                </block>
                                             </xsl:if>
                                             <xsl:if test="$InsuredAddrRaw = ''">
                                                <block>&#xA0;</block>
                                             </xsl:if>
                                          </block>
                                       </block>
                                    </table-cell>
                                 </table-row>
                              </table-body>
                           </table>
                        </table-cell>
                        <table-cell>
                           <!-- this cell defines the right column -->
                           <table padding-top=".2cm">
                              <!-- Insurance Info group box -->
                              <table-column column-width='100%'/>
                              <table-header>
                                 <table-row>
                                    <table-cell xsl:use-attribute-sets="HeaderStyle">
                                       <block>Insurance Information</block>
                                    </table-cell>
                                 </table-row>
                              </table-header>
                              <table-body>
                                 <table-row>
                                    <table-cell border="1px solid blue" padding="2pt">
                                       <block xsl:use-attribute-sets="LabelStyle">
                                          Insurance Company:
                                          <block xsl:use-attribute-sets="InputStyle">
                                             <xsl:value-of select="InsuranceCompany/CompanyName"/>
                                          </block>
                                       </block>
                                       <block xsl:use-attribute-sets="LabelStyle">
                                          Policy Number:
                                          <block xsl:use-attribute-sets="InputStyle">
                                             <xsl:value-of select="Policy/@Number"/>
                                          </block>
                                       </block>
                                       <block xsl:use-attribute-sets="LabelStyle">
                                          Policy Effective Date:
                                          <block xsl:use-attribute-sets="InputStyle">
                                             <xsl:value-of select="Policy/EffectiveDate"/>
                                          </block>
                                       </block>
                                       <block xsl:use-attribute-sets="LabelStyle">
                                          Policy Expiration Date:
                                          <block xsl:use-attribute-sets="InputStyle">
                                             <xsl:value-of select="$ExpireDate"/>
                                          </block>
                                       </block>
                                       <xsl:if test="($PropType != 'Vehicle')">
                                         <block-container>
                                          <block xsl:use-attribute-sets="LabelStyle">
                                             Property Deductible:
                                             <block xsl:use-attribute-sets="InputStyle" white-space-treatment="preserve">
                                               <xsl:choose>
                                                 <xsl:when test="CoverageInformation/DeductibleAmount">
                                                   <xsl:value-of select="CoverageInformation/DeductibleAmount"/>
                                                 </xsl:when>
                                                 <xsl:otherwise>&#xA0;</xsl:otherwise>
                                               </xsl:choose>
                                             </block>
                                          </block>
                                          <block xsl:use-attribute-sets="LabelStyle">
                                             Coverage Amount:
                                             <block xsl:use-attribute-sets="InputStyle" white-space-treatment="preserve">
                                               <xsl:choose>
                                                 <xsl:when test="$CoverageAmnt != ''">
                                                   <xsl:value-of select="$CoverageAmnt"/>
                                                 </xsl:when>
                                                 <xsl:otherwise>&#xA0;</xsl:otherwise>
                                               </xsl:choose>
                                             </block>
                                          </block>
                                         </block-container>
                                       </xsl:if>
                                       <xsl:if test="($PropType = 'Vehicle')">
                                          <block xsl:use-attribute-sets="LabelStyle">
                                             Comprehensive Deductible:
                                             <block xsl:use-attribute-sets="InputStyle">
                                                <xsl:value-of select="$CompDeduct"/>
                                             </block>
                                          </block>
                                          <block xsl:use-attribute-sets="LabelStyle">
                                             Collision Deductible:
                                             <block xsl:use-attribute-sets="InputStyle">
                                                <xsl:value-of select="$CollDeduct"/>
                                             </block>
                                          </block>
                                       </xsl:if>
                                       <block xsl:use-attribute-sets="LabelStyle">
                                          Insurance Company Phone Number:
                                          <block xsl:use-attribute-sets="InputStyle">
                                             <xsl:value-of select="$InsPhone"/>
                                          </block>
                                       </block>
                                       <block xsl:use-attribute-sets="LabelStyle">
                                          Insurance Agency Name:
                                          <block xsl:use-attribute-sets="InputStyle">
                                             <xsl:value-of select="$AgencyName"/>
                                          </block>
                                       </block>
                                       <block xsl:use-attribute-sets="LabelStyle">
                                          Insurance Agency Phone Number:
                                          <block xsl:use-attribute-sets="InputStyle">
                                             <xsl:value-of select="$AgencyPhone"/>
                                          </block>
                                       </block>
                                       <block xsl:use-attribute-sets="LabelStyle">
                                          Agent Name:
                                          <block xsl:use-attribute-sets="InputStyle">
                                            <xsl:value-of select="$AgentName"/>
                                          </block>
                                       </block>
                                       <block xsl:use-attribute-sets="LabelStyle">
                                          Agent Email Address:
                                          <block xsl:use-attribute-sets="InputStyle">
                                            <xsl:value-of select="$AgentEmail"/>
                                          </block>
                                       </block>
                                    </table-cell>
                                 </table-row>
                              </table-body>
                           </table>
                        </table-cell>
                     </table-row>
                  </table-body>
               </table>
            </flow>
         </page-sequence>
      </root>

   </xsl:template>

</xsl:stylesheet>
