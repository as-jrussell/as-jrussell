USE [UniTrac]
GO 

--Loan Screen Information - LOAN/COLLATERAL/PROPERTY/OWNER/REQUIRED COVERAGE
SELECT RC.ID, C.ID,P.ID, RC.INSURANCE_STATUS_CD, RC.INSURANCE_SUB_STATUS_CD, L.* FROM LOAN L
INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
INNER JOIN REQUIRED_COVERAGE RC ON P.ID = RC.PROPERTY_ID
INNER JOIN OWNER_LOAN_RELATE OL ON L.ID = OL.LOAN_ID
INNER JOIN OWNER O ON OL.OWNER_ID = O.ID
INNER JOIN OWNER_ADDRESS OA ON O.ADDRESS_ID = OA.ID
INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
WHERE LL.CODE_TX IN ('3303') AND L.NUMBER_TX IN ('7010002157')


select STATUS_CD, * from process_definition
where update_user_tx = 'UBSGoodThru' and active_in = 'Y'

UPDATE RC
SET GOOD_THRU_DT = NULL, INSURANCE_STATUS_CD = 'A', SUMMARY_STATUS_CD = 'A', CREATE_DT = '2016-01-27 15:23:39.700'
--SELECT GOOD_THRU_DT, INSURANCE_STATUS_CD, *
FROM dbo.REQUIRED_COVERAGE RC
WHERE ID IN (117677822,117677823)


SELECT * FROM dbo.PROCESS_LOG
WHERE UPDATE_DT >= '2016-11-06 'AND PROCESS_DEFINITION_ID = '52'

SELECT * FROM dbo.PROCESS_DEFINITION
WHERE DESCRIPTION_TX LIKE '%through%'
AND ACTIVE_IN = 'Y' AND ONHOLD_IN = 'N'


UPDATE c 
SET Create_DT = '2016-01-27 15:23:39.700'
FROM dbo.COLLATERAL C
WHERE ID = '117792530'

UPDATE P
SET CREATE_DT = '2016-01-27 15:23:39.700'
FROM dbo.PROPERTY P 
WHERE ID = '116503859'

UPDATE L
SET STATUS_DT = '2016-01-27 15:23:39.520', CREATE_DT = '2016-01-27 15:23:39.700'
--SELECT STATUS_DT, EFFECTIVE_DT, *
FROM dbo.LOAN L
WHERE id = '143758065'



UPDATE dbo.PROCESS_DEFINITION
SET LOCK_ID = LOCK_ID+1, UPDATE_DT = GETDATE(), ONHOLD_IN = 'N',
SETTINGS_XML_IM = '<ProcessDefinitionSettings>
  <LastProcessedDate />
  <TargetServerList>
    <TargetServer />
  </TargetServerList>
  <TargetServiceList>
    <TargetService>UnitracBusinessServiceGoodThru</TargetService>
  </TargetServiceList>
  <PredecessorProcessList>
    <PredecessorProcess />
  </PredecessorProcessList>
  <LDAPServer>10.10.18.186</LDAPServer>
  <LDAPPath>ou=groups,ou=internal,dc=as,dc=net</LDAPPath>
  <LenderListThrottle>10</LenderListThrottle>
  <AnticipatedNextScheduledDate>8/14/2016 8:16:06 PM</AnticipatedNextScheduledDate>
  <LenderList>
    <LenderID LastProcessed="8/12/2016 6:48:05 AM" IsEnabled="Y">0106</LenderID>
    <LenderID LastProcessed="8/12/2016 2:57:00 AM" IsEnabled="Y">3045</LenderID>
    <LenderID LastProcessed="8/12/2016 4:58:00 AM" IsEnabled="Y">3055</LenderID>
    <LenderID LastProcessed="8/12/2016 3:16:59 AM" IsEnabled="Y">3054</LenderID>
    <LenderID LastProcessed="8/12/2016 3:16:59 AM" IsEnabled="Y">6602</LenderID>
    <LenderID LastProcessed="5/29/2014 6:45:40 PM" IsEnabled="Y">7046</LenderID>
    <LenderID LastProcessed="4/8/2016 3:35:12 PM" IsEnabled="Y">4162</LenderID>
    <LenderID LastProcessed="1/7/2016 8:06:53 AM" IsEnabled="Y">6545</LenderID>
    <LenderID LastProcessed="8/12/2016 3:36:58 AM" IsEnabled="Y">9941</LenderID>
    <LenderID LastProcessed="8/12/2016 4:27:58 AM" IsEnabled="Y">1481</LenderID>
    <LenderID LastProcessed="8/12/2016 6:06:57 AM" IsEnabled="Y">3058</LenderID>
    <LenderID LastProcessed="8/12/2016 6:07:01 AM" IsEnabled="Y">3041</LenderID>
    <LenderID LastProcessed="8/12/2016 6:16:57 AM" IsEnabled="Y">6576</LenderID>
    <LenderID LastProcessed="5/29/2014 6:49:17 PM" IsEnabled="Y">3043</LenderID>
    <LenderID LastProcessed="8/12/2016 6:16:58 AM" IsEnabled="Y">3065</LenderID>
    <LenderID LastProcessed="8/12/2016 6:16:58 AM" IsEnabled="Y">3057</LenderID>
    <LenderID LastProcessed="8/12/2016 2:37:02 AM" IsEnabled="Y">3044</LenderID>
    <LenderID LastProcessed="8/12/2016 2:37:02 AM" IsEnabled="Y">3232</LenderID>
    <LenderID LastProcessed="8/12/2016 2:47:04 AM" IsEnabled="Y">4078</LenderID>
    <LenderID LastProcessed="8/12/2016 2:56:55 AM" IsEnabled="Y">2620</LenderID>
    <LenderID LastProcessed="8/12/2016 2:57:01 AM" IsEnabled="Y">1609</LenderID>
    <LenderID LastProcessed="8/12/2016 3:06:56 AM" IsEnabled="Y">1414</LenderID>
    <LenderID LastProcessed="8/12/2016 3:26:57 AM" IsEnabled="Y">1884</LenderID>
    <LenderID LastProcessed="8/12/2016 3:27:00 AM" IsEnabled="Y">2355</LenderID>
    <LenderID LastProcessed="8/12/2016 3:37:00 AM" IsEnabled="Y">6029</LenderID>
    <LenderID LastProcessed="8/12/2016 3:57:57 AM" IsEnabled="Y">7044</LenderID>
    <LenderID LastProcessed="8/12/2016 3:57:57 AM" IsEnabled="Y">6235</LenderID>
    <LenderID LastProcessed="8/12/2016 3:57:59 AM" IsEnabled="Y">0115</LenderID>
    <LenderID LastProcessed="8/12/2016 4:06:57 AM" IsEnabled="Y">6250</LenderID>
    <LenderID LastProcessed="8/12/2016 4:37:01 AM" IsEnabled="Y">6536</LenderID>
    <LenderID LastProcessed="8/12/2016 5:26:56 AM" IsEnabled="Y">6142</LenderID>
    <LenderID LastProcessed="10/31/2014 9:49:03 AM" IsEnabled="Y">6452</LenderID>
    <LenderID LastProcessed="8/12/2016 5:26:57 AM" IsEnabled="Y">2945</LenderID>
    <LenderID LastProcessed="8/12/2016 6:16:59 AM" IsEnabled="Y">2946</LenderID>
    <LenderID LastProcessed="8/12/2016 6:17:00 AM" IsEnabled="Y">2947</LenderID>
    <LenderID LastProcessed="5/29/2014 6:49:41 PM" IsEnabled="Y">2948</LenderID>
    <LenderID LastProcessed="8/12/2016 6:17:01 AM" IsEnabled="Y">2949</LenderID>
    <LenderID LastProcessed="8/12/2016 6:37:00 AM" IsEnabled="Y">32010013</LenderID>
    <LenderID LastProcessed="8/12/2016 7:07:05 AM" IsEnabled="Y">6572</LenderID>
    <LenderID LastProcessed="8/12/2016 7:18:00 AM" IsEnabled="Y">41020143</LenderID>
    <LenderID LastProcessed="5/29/2014 6:49:44 PM" IsEnabled="Y">09010047</LenderID>
    <LenderID LastProcessed="8/12/2016 3:26:58 AM" IsEnabled="Y">10010313</LenderID>
    <LenderID LastProcessed="8/12/2016 3:26:59 AM" IsEnabled="Y">10015799</LenderID>
    <LenderID LastProcessed="8/12/2016 3:27:01 AM" IsEnabled="Y">10010213</LenderID>
    <LenderID LastProcessed="8/12/2016 4:06:57 AM" IsEnabled="Y">10010003</LenderID>
    <LenderID LastProcessed="8/12/2016 4:06:59 AM" IsEnabled="Y">41010100</LenderID>
    <LenderID LastProcessed="5/29/2014 6:49:47 PM" IsEnabled="Y">10010348</LenderID>
    <LenderID LastProcessed="8/12/2016 4:07:00 AM" IsEnabled="Y">39016600</LenderID>
    <LenderID LastProcessed="2/18/2015 11:17:44 AM" IsEnabled="Y">10010025</LenderID>
    <LenderID LastProcessed="8/12/2016 4:07:02 AM" IsEnabled="Y">39010048</LenderID>
    <LenderID LastProcessed="8/12/2016 4:07:02 AM" IsEnabled="Y">10021100</LenderID>
    <LenderID LastProcessed="8/12/2016 4:07:03 AM" IsEnabled="Y">10024700</LenderID>
    <LenderID LastProcessed="10/27/2014 4:47:02 AM" IsEnabled="Y">1520</LenderID>
    <LenderID LastProcessed="8/12/2016 4:17:55 AM" IsEnabled="Y">1802</LenderID>
    <LenderID LastProcessed="8/12/2016 4:17:56 AM" IsEnabled="Y">4142</LenderID>
    <LenderID LastProcessed="8/12/2016 4:17:56 AM" IsEnabled="Y">1815</LenderID>
    <LenderID LastProcessed="8/5/2014 6:26:08 AM" IsEnabled="Y">2140</LenderID>
    <LenderID LastProcessed="8/12/2016 4:17:57 AM" IsEnabled="Y">1504</LenderID>
    <LenderID LastProcessed="8/12/2016 4:17:57 AM" IsEnabled="Y">3040</LenderID>
    <LenderID LastProcessed="8/12/2016 4:17:58 AM" IsEnabled="Y">23040027</LenderID>
    <LenderID LastProcessed="8/12/2016 4:17:59 AM" IsEnabled="Y">10010358</LenderID>
    <LenderID LastProcessed="1/21/2016 2:05:11 PM" IsEnabled="Y">9994</LenderID>
    <LenderID LastProcessed="8/12/2016 4:17:59 AM" IsEnabled="Y">10010061</LenderID>
    <LenderID LastProcessed="8/12/2016 4:17:59 AM" IsEnabled="Y">10010311</LenderID>
    <LenderID LastProcessed="8/12/2016 4:27:56 AM" IsEnabled="Y">01010053</LenderID>
    <LenderID LastProcessed="8/12/2016 4:27:57 AM" IsEnabled="Y">10015599</LenderID>
    <LenderID LastProcessed="8/12/2016 4:27:59 AM" IsEnabled="Y">41010108</LenderID>
    <LenderID LastProcessed="7/29/2015 11:23:44 AM" IsEnabled="Y">10010190</LenderID>
    <LenderID LastProcessed="8/12/2016 4:28:00 AM" IsEnabled="Y">09010036</LenderID>
    <LenderID LastProcessed="7/31/2015 11:14:48 AM" IsEnabled="Y">01010026</LenderID>
    <LenderID LastProcessed="8/12/2016 4:28:01 AM" IsEnabled="Y">10010019</LenderID>
    <LenderID LastProcessed="8/12/2016 4:28:02 AM" IsEnabled="Y">01010036</LenderID>
    <LenderID LastProcessed="8/12/2016 4:28:04 AM" IsEnabled="Y">01010029</LenderID>
    <LenderID LastProcessed="8/12/2016 4:28:04 AM" IsEnabled="Y">01010040</LenderID>
    <LenderID LastProcessed="8/12/2016 4:28:06 AM" IsEnabled="Y">09010035</LenderID>
    <LenderID LastProcessed="6/7/2016 10:07:01 AM" IsEnabled="Y">2298</LenderID>
    <LenderID LastProcessed="5/29/2014 6:50:04 PM" IsEnabled="Y">51501</LenderID>
    <LenderID LastProcessed="8/12/2016 4:36:57 AM" IsEnabled="Y">1988</LenderID>
    <LenderID LastProcessed="8/12/2016 4:36:58 AM" IsEnabled="Y">9081</LenderID>
    <LenderID LastProcessed="12/31/2014 3:20:59 AM" IsEnabled="Y">4354</LenderID>
    <LenderID LastProcessed="4/19/2016 6:09:30 AM" IsEnabled="Y">10023400</LenderID>
    <LenderID LastProcessed="5/19/2015 9:27:39 AM" IsEnabled="Y">6258</LenderID>
    <LenderID LastProcessed="8/12/2016 4:36:59 AM" IsEnabled="Y">41016300</LenderID>
    <LenderID LastProcessed="8/12/2016 4:36:59 AM" IsEnabled="Y">10010325</LenderID>
    <LenderID LastProcessed="8/12/2016 4:37:00 AM" IsEnabled="Y">10016900</LenderID>
    <LenderID LastProcessed="8/12/2016 4:37:00 AM" IsEnabled="Y">10030001</LenderID>
    <LenderID LastProcessed="8/12/2016 4:37:01 AM" IsEnabled="Y">5003</LenderID>
    <LenderID LastProcessed="8/12/2016 4:37:02 AM" IsEnabled="Y">2500</LenderID>
    <LenderID LastProcessed="5/29/2014 6:50:15 PM" IsEnabled="Y">10010063</LenderID>
    <LenderID LastProcessed="5/29/2014 6:50:15 PM" IsEnabled="Y">10070300</LenderID>
    <LenderID LastProcessed="5/29/2014 6:50:16 PM" IsEnabled="Y">39015800</LenderID>
    <LenderID LastProcessed="8/12/2016 4:37:02 AM" IsEnabled="Y">10020200</LenderID>
    <LenderID LastProcessed="5/29/2014 6:50:17 PM" IsEnabled="Y">10015699</LenderID>
    <LenderID LastProcessed="8/12/2016 4:46:56 AM" IsEnabled="Y">01010044</LenderID>
    <LenderID LastProcessed="8/12/2016 4:46:56 AM" IsEnabled="Y">39060119</LenderID>
    <LenderID LastProcessed="8/12/2016 4:46:57 AM" IsEnabled="Y">39020047</LenderID>
    <LenderID LastProcessed="8/12/2016 4:46:57 AM" IsEnabled="Y">10010200</LenderID>
    <LenderID LastProcessed="8/12/2016 4:46:58 AM" IsEnabled="Y">10010335</LenderID>
    <LenderID LastProcessed="8/12/2016 4:46:58 AM" IsEnabled="Y">41010097</LenderID>
    <LenderID LastProcessed="5/29/2014 6:50:21 PM" IsEnabled="Y">41010101</LenderID>
    <LenderID LastProcessed="8/31/2015 7:33:33 AM" IsEnabled="Y">5040</LenderID>
    <LenderID LastProcessed="5/29/2014 6:50:23 PM" IsEnabled="Y">2722</LenderID>
    <LenderID LastProcessed="8/12/2016 4:46:59 AM" IsEnabled="Y">1874</LenderID>
    <LenderID LastProcessed="7/8/2014 12:48:51 PM" IsEnabled="Y">1730</LenderID>
    <LenderID LastProcessed="8/12/2016 4:46:59 AM" IsEnabled="Y">6443</LenderID>
    <LenderID LastProcessed="8/12/2016 4:47:00 AM" IsEnabled="Y">0078</LenderID>
    <LenderID LastProcessed="8/12/2016 4:57:55 AM" IsEnabled="Y">6254</LenderID>
    <LenderID LastProcessed="8/12/2016 4:57:56 AM" IsEnabled="Y">1505</LenderID>
    <LenderID LastProcessed="8/12/2016 4:57:56 AM" IsEnabled="Y">1554</LenderID>
    <LenderID LastProcessed="8/12/2016 4:57:57 AM" IsEnabled="Y">6225</LenderID>
    <LenderID LastProcessed="1/2/2015 7:57:00 AM" IsEnabled="Y">3361</LenderID>
    <LenderID LastProcessed="8/12/2016 4:57:57 AM" IsEnabled="Y">10018600</LenderID>
    <LenderID LastProcessed="8/12/2016 4:57:58 AM" IsEnabled="Y">6569</LenderID>
    <LenderID LastProcessed="8/12/2016 4:57:59 AM" IsEnabled="Y">5010</LenderID>
    <LenderID LastProcessed="5/29/2014 6:50:42 PM" IsEnabled="Y">10021200</LenderID>
    <LenderID LastProcessed="8/12/2016 4:57:59 AM" IsEnabled="Y">10025800</LenderID>
    <LenderID LastProcessed="8/12/2016 4:58:00 AM" IsEnabled="Y">3411</LenderID>
    <LenderID LastProcessed="8/12/2016 5:06:56 AM" IsEnabled="Y">2943</LenderID>
    <LenderID LastProcessed="8/12/2016 5:06:57 AM" IsEnabled="Y">4348</LenderID>
    <LenderID LastProcessed="8/12/2016 5:06:57 AM" IsEnabled="Y">3067</LenderID>
    <LenderID LastProcessed="4/28/2015 6:27:23 AM" IsEnabled="Y">6305</LenderID>
    <LenderID LastProcessed="8/12/2016 5:06:57 AM" IsEnabled="Y">2999</LenderID>
    <LenderID LastProcessed="8/12/2016 5:06:58 AM" IsEnabled="Y">2013</LenderID>
    <LenderID LastProcessed="8/12/2016 5:06:58 AM" IsEnabled="Y">2815</LenderID>
    <LenderID LastProcessed="8/12/2016 5:06:59 AM" IsEnabled="Y">2700</LenderID>
    <LenderID LastProcessed="8/12/2016 5:06:59 AM" IsEnabled="Y">1991</LenderID>
    <LenderID LastProcessed="8/12/2016 5:07:00 AM" IsEnabled="Y">1829</LenderID>
    <LenderID LastProcessed="5/29/2014 6:51:00 PM" IsEnabled="Y">1948</LenderID>
    <LenderID LastProcessed="8/12/2016 5:07:00 AM" IsEnabled="Y">1555</LenderID>
    <LenderID LastProcessed="12/30/2015 9:06:07 AM" IsEnabled="Y">1075</LenderID>
    <LenderID LastProcessed="8/12/2016 5:16:57 AM" IsEnabled="Y">1123</LenderID>
    <LenderID LastProcessed="8/12/2016 5:16:58 AM" IsEnabled="Y">1987</LenderID>
    <LenderID LastProcessed="8/12/2016 5:16:59 AM" IsEnabled="Y">2790</LenderID>
    <LenderID LastProcessed="5/29/2014 6:51:07 PM" IsEnabled="Y">39013300</LenderID>
    <LenderID LastProcessed="8/12/2016 5:16:59 AM" IsEnabled="Y">41012700</LenderID>
    <LenderID LastProcessed="8/12/2016 5:17:00 AM" IsEnabled="Y">41010019</LenderID>
    <LenderID LastProcessed="8/12/2016 5:17:00 AM" IsEnabled="Y">10023000</LenderID>
    <LenderID LastProcessed="7/29/2015 7:03:32 AM" IsEnabled="Y">10010210</LenderID>
    <LenderID LastProcessed="8/12/2016 5:17:01 AM" IsEnabled="Y">39010039</LenderID>
    <LenderID LastProcessed="8/12/2016 5:17:01 AM" IsEnabled="Y">10020600</LenderID>
    <LenderID LastProcessed="8/12/2016 5:17:02 AM" IsEnabled="Y">41010158</LenderID>
    <LenderID LastProcessed="8/12/2016 5:17:02 AM" IsEnabled="Y">16010100</LenderID>
    <LenderID LastProcessed="8/12/2016 5:26:56 AM" IsEnabled="Y">41015100</LenderID>
    <LenderID LastProcessed="8/12/2016 5:26:57 AM" IsEnabled="Y">39020101</LenderID>
    <LenderID LastProcessed="6/24/2016 10:56:18 AM" IsEnabled="Y">39010094</LenderID>
    <LenderID LastProcessed="8/12/2016 5:26:57 AM" IsEnabled="Y">41010066</LenderID>
    <LenderID LastProcessed="8/12/2016 5:26:58 AM" IsEnabled="Y">01010041</LenderID>
    <LenderID LastProcessed="8/12/2016 5:26:58 AM" IsEnabled="Y">01010032</LenderID>
    <LenderID LastProcessed="8/12/2016 5:26:59 AM" IsEnabled="Y">39010072</LenderID>
    <LenderID LastProcessed="8/12/2016 5:27:00 AM" IsEnabled="Y">09010026</LenderID>
    <LenderID LastProcessed="5/29/2014 6:51:49 PM" IsEnabled="Y">10010357</LenderID>
    <LenderID LastProcessed="4/15/2016 10:05:38 AM" IsEnabled="Y">41010085</LenderID>
    <LenderID LastProcessed="8/12/2016 5:36:57 AM" IsEnabled="Y">39010073</LenderID>
    <LenderID LastProcessed="8/12/2016 5:36:58 AM" IsEnabled="Y">10020000</LenderID>
    <LenderID LastProcessed="8/12/2016 5:37:00 AM" IsEnabled="Y">09010027</LenderID>
    <LenderID LastProcessed="8/12/2016 5:37:01 AM" IsEnabled="Y">01010045</LenderID>
    <LenderID LastProcessed="8/12/2016 5:37:03 AM" IsEnabled="Y">01010100</LenderID>
    <LenderID LastProcessed="8/12/2016 5:46:57 AM" IsEnabled="Y">09010029</LenderID>
    <LenderID LastProcessed="8/12/2016 5:46:57 AM" IsEnabled="Y">09010025</LenderID>
    <LenderID LastProcessed="8/12/2016 5:46:58 AM" IsEnabled="Y">01010092</LenderID>
    <LenderID LastProcessed="8/12/2016 5:46:59 AM" IsEnabled="Y">01010093</LenderID>
    <LenderID LastProcessed="8/12/2016 5:46:59 AM" IsEnabled="Y">01010060</LenderID>
    <LenderID LastProcessed="8/12/2016 5:46:59 AM" IsEnabled="Y">10010212</LenderID>
    <LenderID LastProcessed="8/12/2016 5:47:01 AM" IsEnabled="Y">09010023</LenderID>
    <LenderID LastProcessed="8/12/2016 5:56:58 AM" IsEnabled="Y">10010035</LenderID>
    <LenderID LastProcessed="8/12/2016 5:56:59 AM" IsEnabled="Y">10021300</LenderID>
    <LenderID LastProcessed="8/12/2016 5:56:59 AM" IsEnabled="Y">10023600</LenderID>
    <LenderID LastProcessed="8/12/2016 5:56:59 AM" IsEnabled="Y">01010089</LenderID>
    <LenderID LastProcessed="8/12/2016 5:57:00 AM" IsEnabled="Y">10024900</LenderID>
    <LenderID LastProcessed="8/12/2016 5:57:00 AM" IsEnabled="Y">01010090</LenderID>
    <LenderID LastProcessed="8/12/2016 5:57:01 AM" IsEnabled="Y">01010091</LenderID>
    <LenderID LastProcessed="4/19/2016 2:06:12 PM" IsEnabled="Y">10010209</LenderID>
    <LenderID LastProcessed="8/12/2016 6:06:56 AM" IsEnabled="Y">10025400</LenderID>
    <LenderID LastProcessed="8/12/2016 6:06:58 AM" IsEnabled="Y">1832</LenderID>
    <LenderID LastProcessed="8/12/2016 6:06:58 AM" IsEnabled="Y">6229</LenderID>
    <LenderID LastProcessed="8/12/2016 6:06:59 AM" IsEnabled="Y">1770</LenderID>
    <LenderID LastProcessed="8/12/2016 6:07:00 AM" IsEnabled="Y">1798</LenderID>
    <LenderID LastProcessed="8/12/2016 6:07:00 AM" IsEnabled="Y">1979</LenderID>
    <LenderID LastProcessed="5/29/2014 6:52:26 PM" IsEnabled="Y">2122</LenderID>
    <LenderID LastProcessed="8/12/2016 6:07:02 AM" IsEnabled="Y">1891</LenderID>
    <LenderID LastProcessed="8/12/2016 6:16:57 AM" IsEnabled="Y">5009</LenderID>
    <LenderID LastProcessed="7/30/2015 10:14:04 AM" IsEnabled="Y">6361</LenderID>
    <LenderID LastProcessed="8/12/2016 6:16:58 AM" IsEnabled="Y">6556</LenderID>
    <LenderID LastProcessed="8/12/2016 6:16:59 AM" IsEnabled="Y">1836</LenderID>
    <LenderID LastProcessed="9/11/2015 6:10:48 AM" IsEnabled="Y">2928</LenderID>
    <LenderID LastProcessed="8/12/2016 6:17:00 AM" IsEnabled="Y">2912</LenderID>
    <LenderID LastProcessed="8/12/2016 6:26:57 AM" IsEnabled="Y">2931</LenderID>
    <LenderID LastProcessed="8/12/2016 6:26:58 AM" IsEnabled="Y">1928</LenderID>
    <LenderID LastProcessed="2/2/2015 6:57:17 AM" IsEnabled="Y">0068</LenderID>
    <LenderID LastProcessed="8/12/2016 6:26:58 AM" IsEnabled="Y">3060</LenderID>
    <LenderID LastProcessed="8/12/2016 6:26:59 AM" IsEnabled="Y">2771</LenderID>
    <LenderID LastProcessed="4/22/2016 1:15:22 PM" IsEnabled="Y">1086</LenderID>
    <LenderID LastProcessed="8/12/2016 6:27:00 AM" IsEnabled="Y">1036</LenderID>
    <LenderID LastProcessed="3/16/2016 11:41:15 AM" IsEnabled="Y">1050</LenderID>
    <LenderID LastProcessed="8/12/2016 6:27:01 AM" IsEnabled="Y">1025</LenderID>
    <LenderID LastProcessed="8/12/2016 6:27:01 AM" IsEnabled="Y">1205</LenderID>
    <LenderID LastProcessed="8/12/2016 6:27:01 AM" IsEnabled="Y">1207</LenderID>
    <LenderID LastProcessed="8/12/2016 6:27:02 AM" IsEnabled="Y">1360</LenderID>
    <LenderID LastProcessed="8/12/2016 6:27:02 AM" IsEnabled="Y">1405</LenderID>
    <LenderID LastProcessed="8/12/2016 6:36:59 AM" IsEnabled="Y">1400</LenderID>
    <LenderID LastProcessed="8/12/2016 6:37:00 AM" IsEnabled="Y">1408</LenderID>
    <LenderID LastProcessed="8/12/2016 6:37:01 AM" IsEnabled="Y">1539</LenderID>
    <LenderID LastProcessed="5/2/2016 8:36:59 AM" IsEnabled="Y">1434</LenderID>
    <LenderID LastProcessed="8/12/2016 6:37:01 AM" IsEnabled="Y">1473</LenderID>
    <LenderID LastProcessed="8/12/2016 6:37:02 AM" IsEnabled="Y">1579</LenderID>
    <LenderID LastProcessed="8/12/2016 6:37:02 AM" IsEnabled="Y">1570</LenderID>
    <LenderID LastProcessed="8/12/2016 6:37:03 AM" IsEnabled="Y">1594</LenderID>
    <LenderID LastProcessed="10/31/2014 7:28:08 AM" IsEnabled="Y">1624</LenderID>
    <LenderID LastProcessed="8/12/2016 6:37:04 AM" IsEnabled="Y">1595</LenderID>
    <LenderID LastProcessed="8/12/2016 6:48:01 AM" IsEnabled="Y">1724</LenderID>
    <LenderID LastProcessed="8/12/2016 6:48:01 AM" IsEnabled="Y">1767</LenderID>
    <LenderID LastProcessed="8/12/2016 6:48:02 AM" IsEnabled="Y">1689</LenderID>
    <LenderID LastProcessed="8/12/2016 6:48:03 AM" IsEnabled="Y">1625</LenderID>
    <LenderID LastProcessed="8/12/2016 6:48:04 AM" IsEnabled="Y">1831</LenderID>
    <LenderID LastProcessed="8/12/2016 6:48:06 AM" IsEnabled="Y">1776</LenderID>
    <LenderID LastProcessed="8/12/2016 6:48:07 AM" IsEnabled="Y">1784</LenderID>
    <LenderID LastProcessed="8/12/2016 6:48:08 AM" IsEnabled="Y">1863</LenderID>
    <LenderID LastProcessed="8/12/2016 6:56:59 AM" IsEnabled="Y">1841</LenderID>
    <LenderID LastProcessed="8/12/2016 6:57:00 AM" IsEnabled="Y">1870</LenderID>
    <LenderID LastProcessed="3/2/2016 8:35:23 AM" IsEnabled="Y">1854</LenderID>
    <LenderID LastProcessed="8/12/2016 6:57:01 AM" IsEnabled="Y">1913</LenderID>
    <LenderID LastProcessed="8/12/2016 6:57:02 AM" IsEnabled="Y">1890</LenderID>
    <LenderID LastProcessed="8/12/2016 6:57:03 AM" IsEnabled="Y">1881</LenderID>
    <LenderID LastProcessed="8/12/2016 6:57:03 AM" IsEnabled="Y">1921</LenderID>
    <LenderID LastProcessed="8/12/2016 6:57:04 AM" IsEnabled="Y">1933</LenderID>
    <LenderID LastProcessed="8/12/2016 6:57:04 AM" IsEnabled="Y">1934</LenderID>
    <LenderID LastProcessed="3/17/2015 11:17:08 AM" IsEnabled="Y">1943</LenderID>
    <LenderID LastProcessed="8/12/2016 6:57:05 AM" IsEnabled="Y">1945</LenderID>
    <LenderID LastProcessed="8/12/2016 7:07:00 AM" IsEnabled="Y">1937</LenderID>
    <LenderID LastProcessed="8/12/2016 7:07:01 AM" IsEnabled="Y">1954</LenderID>
    <LenderID LastProcessed="8/12/2016 7:07:02 AM" IsEnabled="Y">1968</LenderID>
    <LenderID LastProcessed="8/12/2016 7:07:03 AM" IsEnabled="Y">1977</LenderID>
    <LenderID LastProcessed="8/12/2016 7:07:04 AM" IsEnabled="Y">1980</LenderID>
    <LenderID LastProcessed="8/12/2016 7:07:04 AM" IsEnabled="Y">1981</LenderID>
    <LenderID LastProcessed="8/12/2016 7:07:06 AM" IsEnabled="Y">1978</LenderID>
    <LenderID LastProcessed="8/12/2016 7:17:59 AM" IsEnabled="Y">1986</LenderID>
    <LenderID LastProcessed="8/12/2016 7:18:01 AM" IsEnabled="Y">2007</LenderID>
    <LenderID LastProcessed="8/12/2016 7:18:01 AM" IsEnabled="Y">2026</LenderID>
    <LenderID LastProcessed="6/24/2014 4:10:23 PM" IsEnabled="Y">4450</LenderID>
    <LenderID LastProcessed="8/12/2016 7:18:02 AM" IsEnabled="Y">0100</LenderID>
    <LenderID LastProcessed="8/12/2016 7:18:02 AM" IsEnabled="Y">3082</LenderID>
    <LenderID LastProcessed="8/12/2016 7:26:58 AM" IsEnabled="Y">2042</LenderID>
    <LenderID LastProcessed="8/12/2016 7:26:58 AM" IsEnabled="Y">2039</LenderID>
    <LenderID LastProcessed="8/12/2016 7:26:59 AM" IsEnabled="Y">1531</LenderID>
    <LenderID LastProcessed="10/8/2015 11:23:36 AM" IsEnabled="Y">1545</LenderID>
    <LenderID LastProcessed="8/12/2016 7:26:59 AM" IsEnabled="Y">1290</LenderID>
    <LenderID LastProcessed="8/12/2016 7:27:00 AM" IsEnabled="Y">1020</LenderID>
    <LenderID LastProcessed="8/12/2016 7:27:00 AM" IsEnabled="Y">1580</LenderID>
    <LenderID LastProcessed="8/12/2016 7:27:01 AM" IsEnabled="Y">1693</LenderID>
    <LenderID LastProcessed="8/12/2016 7:27:01 AM" IsEnabled="Y">1630</LenderID>
    <LenderID LastProcessed="12/2/2015 6:45:00 AM" IsEnabled="Y">1627</LenderID>
    <LenderID LastProcessed="2/27/2015 3:47:20 AM" IsEnabled="Y">1614</LenderID>
    <LenderID LastProcessed="4/12/2016 11:25:36 AM" IsEnabled="Y">1727</LenderID>
    <LenderID LastProcessed="8/12/2016 7:27:02 AM" IsEnabled="Y">1769</LenderID>
    <LenderID LastProcessed="8/12/2016 2:28:00 AM" IsEnabled="Y">1786</LenderID>
    <LenderID LastProcessed="8/12/2016 2:28:00 AM" IsEnabled="Y">1741</LenderID>
    <LenderID LastProcessed="8/12/2016 2:28:01 AM" IsEnabled="Y">1764</LenderID>
    <LenderID LastProcessed="8/12/2016 2:36:56 AM" IsEnabled="Y">1865</LenderID>
    <LenderID LastProcessed="8/12/2016 2:36:57 AM" IsEnabled="Y">1862</LenderID>
    <LenderID LastProcessed="8/11/2014 10:06:08 AM" IsEnabled="Y">1872</LenderID>
    <LenderID LastProcessed="11/3/2014 1:27:11 PM" IsEnabled="Y">1883</LenderID>
    <LenderID LastProcessed="8/12/2016 2:36:58 AM" IsEnabled="Y">1895</LenderID>
    <LenderID LastProcessed="8/12/2016 2:36:58 AM" IsEnabled="Y">1952</LenderID>
    <LenderID LastProcessed="8/12/2016 2:36:59 AM" IsEnabled="Y">1873</LenderID>
    <LenderID LastProcessed="8/12/2016 2:46:59 AM" IsEnabled="Y">1974</LenderID>
    <LenderID LastProcessed="5/29/2014 6:48:49 PM" IsEnabled="Y">4323</LenderID>
    <LenderID LastProcessed="8/12/2016 2:56:55 AM" IsEnabled="Y">3875</LenderID>
    <LenderID LastProcessed="8/12/2016 2:56:56 AM" IsEnabled="Y">2864</LenderID>
    <LenderID LastProcessed="6/1/2016 11:15:43 AM" IsEnabled="Y">0094</LenderID>
    <LenderID LastProcessed="8/12/2016 2:56:57 AM" IsEnabled="Y">1170</LenderID>
    <LenderID LastProcessed="8/20/2015 10:05:30 AM" IsEnabled="Y">1206</LenderID>
    <LenderID LastProcessed="8/12/2016 2:56:58 AM" IsEnabled="Y">1215</LenderID>
    <LenderID LastProcessed="8/12/2016 2:56:59 AM" IsEnabled="Y">1598</LenderID>
    <LenderID LastProcessed="8/12/2016 2:57:00 AM" IsEnabled="Y">1626</LenderID>
    <LenderID LastProcessed="7/1/2014 12:03:43 PM" IsEnabled="Y">1691</LenderID>
    <LenderID LastProcessed="8/12/2016 2:57:02 AM" IsEnabled="Y">1729</LenderID>
    <LenderID LastProcessed="7/30/2014 6:11:30 AM" IsEnabled="Y">1758</LenderID>
    <LenderID LastProcessed="6/17/2015 6:33:59 AM" IsEnabled="Y">1777</LenderID>
    <LenderID LastProcessed="8/12/2016 3:06:54 AM" IsEnabled="Y">1783</LenderID>
    <LenderID LastProcessed="8/12/2016 3:06:56 AM" IsEnabled="Y">1818</LenderID>
    <LenderID LastProcessed="8/12/2016 3:06:58 AM" IsEnabled="Y">1823</LenderID>
    <LenderID LastProcessed="8/12/2016 3:06:59 AM" IsEnabled="Y">1857</LenderID>
    <LenderID LastProcessed="8/12/2016 3:06:59 AM" IsEnabled="Y">1858</LenderID>
    <LenderID LastProcessed="8/12/2016 3:07:00 AM" IsEnabled="Y">1897</LenderID>
    <LenderID LastProcessed="9/1/2015 8:23:58 AM" IsEnabled="Y">1951</LenderID>
    <LenderID LastProcessed="8/12/2016 3:16:55 AM" IsEnabled="Y">2030</LenderID>
    <LenderID LastProcessed="8/12/2016 3:16:56 AM" IsEnabled="Y">2046</LenderID>
    <LenderID LastProcessed="8/12/2016 3:16:58 AM" IsEnabled="Y">2095</LenderID>
    <LenderID LastProcessed="8/12/2016 3:26:56 AM" IsEnabled="Y">2239</LenderID>
    <LenderID LastProcessed="8/12/2016 3:26:57 AM" IsEnabled="Y">2240</LenderID>
    <LenderID LastProcessed="8/12/2016 3:26:59 AM" IsEnabled="Y">2375</LenderID>
    <LenderID LastProcessed="8/12/2016 3:27:01 AM" IsEnabled="Y">2515</LenderID>
    <LenderID LastProcessed="2/16/2016 10:56:28 AM" IsEnabled="Y">2520</LenderID>
    <LenderID LastProcessed="8/12/2016 3:27:02 AM" IsEnabled="Y">2530</LenderID>
    <LenderID LastProcessed="8/12/2016 3:36:55 AM" IsEnabled="Y">2910</LenderID>
    <LenderID LastProcessed="2/4/2016 7:56:47 AM" IsEnabled="Y">3100</LenderID>
    <LenderID LastProcessed="8/12/2016 3:36:56 AM" IsEnabled="Y">4278</LenderID>
    <LenderID LastProcessed="5/5/2015 2:37:01 PM" IsEnabled="Y">4298</LenderID>
    <LenderID LastProcessed="8/12/2016 3:36:57 AM" IsEnabled="Y">4304</LenderID>
    <LenderID LastProcessed="8/12/2016 3:36:57 AM" IsEnabled="Y">4500</LenderID>
    <LenderID LastProcessed="5/12/2016 8:17:03 AM" IsEnabled="Y">5600</LenderID>
    <LenderID LastProcessed="8/12/2016 3:36:59 AM" IsEnabled="Y">6087</LenderID>
    <LenderID LastProcessed="8/12/2016 3:37:01 AM" IsEnabled="Y">6156</LenderID>
    <LenderID LastProcessed="8/12/2016 3:37:01 AM" IsEnabled="Y">6202</LenderID>
    <LenderID LastProcessed="9/10/2014 5:55:50 AM" IsEnabled="Y">6205</LenderID>
    <LenderID LastProcessed="8/12/2016 3:37:02 AM" IsEnabled="Y">6233</LenderID>
    <LenderID LastProcessed="10/13/2015 1:07:09 PM" IsEnabled="Y">6262</LenderID>
    <LenderID LastProcessed="8/12/2016 3:46:54 AM" IsEnabled="Y">6546</LenderID>
    <LenderID LastProcessed="8/12/2016 3:46:55 AM" IsEnabled="Y">6583</LenderID>
    <LenderID LastProcessed="8/12/2016 3:46:55 AM" IsEnabled="Y">6681</LenderID>
    <LenderID LastProcessed="8/12/2016 3:46:56 AM" IsEnabled="Y">6682</LenderID>
    <LenderID LastProcessed="8/12/2016 3:46:56 AM" IsEnabled="Y">6801</LenderID>
    <LenderID LastProcessed="8/12/2016 3:46:57 AM" IsEnabled="Y">7016</LenderID>
    <LenderID LastProcessed="8/12/2016 3:46:58 AM" IsEnabled="Y">8600</LenderID>
    <LenderID LastProcessed="8/12/2016 3:46:59 AM" IsEnabled="Y">8700</LenderID>
    <LenderID LastProcessed="3/2/2015 6:15:12 AM" IsEnabled="Y">1301</LenderID>
    <LenderID LastProcessed="8/12/2016 3:47:00 AM" IsEnabled="Y">1097</LenderID>
    <LenderID LastProcessed="8/12/2016 3:47:01 AM" IsEnabled="Y">3035</LenderID>
    <LenderID LastProcessed="8/12/2016 3:57:56 AM" IsEnabled="Y">0259</LenderID>
    <LenderID LastProcessed="12/1/2014 5:37:50 AM" IsEnabled="Y">7200</LenderID>
    <LenderID LastProcessed="8/12/2016 3:57:56 AM" IsEnabled="Y">1385</LenderID>
    <LenderID LastProcessed="8/12/2016 3:57:58 AM" IsEnabled="Y">1879</LenderID>
    <LenderID LastProcessed="8/12/2016 3:57:58 AM" IsEnabled="Y">2107</LenderID>
    <LenderID LastProcessed="8/12/2016 3:58:00 AM" IsEnabled="Y">2202</LenderID>
    <LenderID LastProcessed="8/12/2016 3:58:00 AM" IsEnabled="Y">3200</LenderID>
    <LenderID LastProcessed="8/12/2016 3:58:01 AM" IsEnabled="Y">4339</LenderID>
    <LenderID LastProcessed="8/12/2016 4:06:58 AM" IsEnabled="Y">7140</LenderID>
    <LenderID LastProcessed="8/12/2016 4:07:00 AM" IsEnabled="Y">1771</LenderID>
    <LenderID LastProcessed="8/12/2016 3:16:57 AM" IsEnabled="Y">2259</LenderID>
    <LenderID LastProcessed="8/12/2016 3:16:57 AM" IsEnabled="Y">2261</LenderID>
    <LenderID LastProcessed="8/12/2016 3:16:57 AM" IsEnabled="Y">2048</LenderID>
    <LenderID LastProcessed="8/12/2016 3:16:57 AM" IsEnabled="Y">4352</LenderID>
    <LenderID LastProcessed="8/12/2016 3:16:58 AM" IsEnabled="Y">1574</LenderID>
    <LenderID LastProcessed="8/12/2016 2:47:00 AM" IsEnabled="Y">4125</LenderID>
    <LenderID LastProcessed="1/15/2016 2:27:15 PM" IsEnabled="Y">3800</LenderID>
    <LenderID LastProcessed="8/12/2016 2:47:01 AM" IsEnabled="Y">7632</LenderID>
    <LenderID LastProcessed="7/31/2014 4:27:12 AM" IsEnabled="Y">5176</LenderID>
    <LenderID LastProcessed="8/12/2016 2:47:01 AM" IsEnabled="Y">2965</LenderID>
    <LenderID LastProcessed="4/8/2016 11:56:05 AM" IsEnabled="Y">7120</LenderID>
    <LenderID LastProcessed="8/12/2016 5:27:00 AM" IsEnabled="Y">6611</LenderID>
    <LenderID LastProcessed="8/12/2016 5:36:57 AM" IsEnabled="Y">2395</LenderID>
    <LenderID LastProcessed="8/12/2016 5:36:58 AM" IsEnabled="Y">2890</LenderID>
    <LenderID LastProcessed="8/12/2016 5:36:59 AM" IsEnabled="Y">3750</LenderID>
    <LenderID LastProcessed="8/12/2016 5:37:01 AM" IsEnabled="Y">1001</LenderID>
    <LenderID LastProcessed="8/12/2016 5:37:02 AM" IsEnabled="Y">5625</LenderID>
    <LenderID LastProcessed="8/12/2016 5:46:56 AM" IsEnabled="Y">3145</LenderID>
    <LenderID LastProcessed="8/12/2016 5:47:00 AM" IsEnabled="Y">2263</LenderID>
    <LenderID LastProcessed="8/12/2016 5:57:00 AM" IsEnabled="Y">2385</LenderID>
    <LenderID LastProcessed="8/12/2016 5:57:00 AM" IsEnabled="Y">2302</LenderID>
    <LenderID LastProcessed="8/12/2016 6:37:05 AM" IsEnabled="Y">2269</LenderID>
    <LenderID LastProcessed="8/12/2016 2:47:02 AM" IsEnabled="Y">7450</LenderID>
    <LenderID LastProcessed="8/12/2016 7:18:03 AM" IsEnabled="Y">3760</LenderID>
    <LenderID LastProcessed="8/12/2016 2:37:00 AM" IsEnabled="Y">3755</LenderID>
    <LenderID LastProcessed="8/12/2016 2:47:03 AM" IsEnabled="Y">5100</LenderID>
    <LenderID LastProcessed="8/12/2016 2:47:05 AM" IsEnabled="Y">4942</LenderID>
    <LenderID LastProcessed="8/12/2016 2:37:00 AM" IsEnabled="Y">7130</LenderID>
    <LenderID LastProcessed="8/12/2016 2:37:01 AM" IsEnabled="Y">1149</LenderID>
    <LenderID LastProcessed="8/12/2016 2:47:05 AM" IsEnabled="Y">4750</LenderID>
    <LenderID LastProcessed="8/12/2016 7:18:04 AM" IsEnabled="Y">4356</LenderID>
    <LenderID LastProcessed="8/12/2016 7:18:04 AM" IsEnabled="Y">2981</LenderID>
    <LenderID LastProcessed="8/12/2016 2:47:03 AM" IsEnabled="Y">4233</LenderID>
    <LenderID LastProcessed="8/12/2016 5:46:58 AM" IsEnabled="Y">2281</LenderID>
    <LenderID LastProcessed="8/12/2016 3:06:54 AM" IsEnabled="Y">4401</LenderID>
    <LenderID LastProcessed="8/12/2016 7:06:59 AM" IsEnabled="Y">2332</LenderID>
    <LenderID LastProcessed="8/12/2016 4:06:59 AM" IsEnabled="Y">3132</LenderID>
    <LenderID LastProcessed="8/12/2016 3:06:55 AM" IsEnabled="Y">4846</LenderID>
    <LenderID LastProcessed="8/12/2016 6:57:02 AM" IsEnabled="Y">2287</LenderID>
    <LenderID LastProcessed="8/12/2016 7:17:59 AM" IsEnabled="Y">1190</LenderID>
    <LenderID LastProcessed="8/12/2016 4:46:56 AM" IsEnabled="Y">3037</LenderID>
    <LenderID LastProcessed="8/12/2016 7:26:57 AM" IsEnabled="Y">2725</LenderID>
    <LenderID LastProcessed="8/12/2016 3:06:57 AM" IsEnabled="Y">2814</LenderID>
    <LenderID LastProcessed="8/12/2016 4:18:00 AM" IsEnabled="Y">9010001</LenderID>
    <LenderID LastProcessed="8/12/2016 7:07:01 AM" IsEnabled="Y">3013</LenderID>
    <LenderID LastProcessed="8/12/2016 6:48:00 AM" IsEnabled="Y">3104</LenderID>
    <LenderID LastProcessed="8/12/2016 5:57:01 AM" IsEnabled="Y">3020</LenderID>
    <LenderID LastProcessed="8/12/2016 6:06:57 AM" IsEnabled="Y">3012</LenderID>
    <LenderID LastProcessed="1/1/2000 6:06:57 AM" IsEnabled="Y">3303</LenderID>
  </LenderList>
</ProcessDefinitionSettings>'
WHERE ID = '52'



select * from process_definition
where update_user_tx = 'UBSGoodThru' and active_in = 'Y'