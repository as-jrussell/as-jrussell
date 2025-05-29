SELECT * FROM dbo.LENDER
WHERE CODE_TX IN ('7350') 


--Loan Screen Information - LOAN/COLLATERAL/PROPERTY/OWNER/REQUIRED COVERAGE
SELECT L.ID, L.NUMBER_TX,P.ID, PCP.* from LOAN L
INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
INNER JOIN REQUIRED_COVERAGE RC ON P.ID = RC.PROPERTY_ID
INNER JOIN OWNER_LOAN_RELATE OL ON L.ID = OL.LOAN_ID
INNER JOIN OWNER O ON OL.OWNER_ID = O.ID
INNER JOIN OWNER_ADDRESS OA ON O.ADDRESS_ID = OA.ID
INNER JOIN dbo.PRIOR_CARRIER_POLICY PCP ON PCP.REQUIRED_COVERAGE_ID = RC.ID
WHERE L.LENDER_ID IN (2260) AND NUMBER_TX IN ('30004530')


SELECT  * 
--INTO UniTracHDStorage..INC0213096IH_2
FROM dbo.INTERACTION_HISTORY
WHERE PROPERTY_ID IN (107802673)


SELECT  * FROM dbo.INTERACTION_HISTORY
--UPDATE dbo.INTERACTION_HISTORY
--SET NOTE_TX = 'PROCTOR - PC
--Policy# 5205914
--Eff Date 1/1/2015 12:00:00 AM
--Exp Date 12/31/9999 11:59:59 PM'
WHERE ID IN (187203977)


SELECT  SPECIAL_HANDLING_XML.value('(/SH/InsuranceCompanyName)[1]', 'varchar (50)'),   * FROM dbo.INTERACTION_HISTORY
--UPDATE dbo.INTERACTION_HISTORY
--SET SPECIAL_HANDLING_XML = '<SH>
--  <InsuranceCompanyName>PROCTOR - PC</InsuranceCompanyName>
--  <PolicyNumber>5205914</PolicyNumber>
--  <EffDate>1/1/2015 12:00:00 AM</EffDate>
--  <CancellationDate>10/17/2015 12:00:00 AM</CancellationDate>
--  <ExpirationDate>12/31/9999 11:59:59 PM</ExpirationDate>
--  <ReasonMeaning />
--  <RC>108906822</RC>
--</SH>'
WHERE ID IN (187203975)


SELECT * FROM dbo.REF_CODE
WHERE CODE_CD  = 'PCP'

SELECT  *
--INTO    UniTracHDStorage..INC0213096
FROM    dbo.PRIOR_CARRIER_POLICY
WHERE   POLICY_NUMBER_TX IN ( '4252309', '4698213', '5574347', '4698187',
                              '4698150', '5933182', '4448634', '4481291',
                              '5392536', '5426396', '5135324', '4698190',
                              '4698256', '5380198', '4698207', '4698221',
                              '5591943', '5880986', '5473368', '5654927',
                              '4698139', '4170359', '4698170', '5473856',
                              '5573800', '5192428', '4626132', '5924823',
                              '5665323', '5215808', '4698157', '3284785',
                              '4698174', '5722859', '4698348', '4692495',
                              '3826971', '5458325', '5569786', '4698153',
                              '5569785', '5874045', '5751009', '5904278',
                              '4482834', '4698178', '4698200', '4246968',
                              '5750993', '4698198', '4987158', '2914499',
                              '5609115', '5904271', '5841879', '5220973',
                              '5134423', '4698160', '5591939', '4698223',
                              '4698177', '3179465', '5692842', '5722823',
                              '5397816', '5591946', '5591938', '5255986',
                              '4698356', '5592147', '5134417', '4952826',
                              '5172171', '4560240', '4822299', '4698209',
                              '5551120', '5591976', '5592169', '5665330',
                              '5676242', '4698194', '5541105', '4698261',
                              '5172172', '4698206', '4698144', '5591969',
                              '5541101', '3314993', '5524213', '4884202',
                              '5326207', '5577186', '4698210', '5290495',
                              '5592148', '5654931', '5839943', '5609114',
                              '5933177', '4935990', '5611462', '2393247',
                              '5200901', '5458331', '5777443', '5591973',
                              '5551123', '5592158', '5916724', '5636742',
                              '4698152', '5114317', '5473398', '5172173',
                              '5904273', '5735136', '4698291', '5524181',
                              '4698292', '4488240', '4899206', '4698282',
                              '5192427', '5446595', '5628834', '5215746',
                              '4698321', '5473385', '5409210', '5580220',
                              '5936661', '4698302', '4698323', '5925453',
                              '5426516', '4482834', '5380211', '4484729',
                              '5932828', '4698286', '5205914', '5355413',
                              '5220968', '5830244', '4698277', '4698310',
                              '5426519', '5574339', '5692873', '5879239',
                              '4698288', '5933178', '5215767', '5226368',
                              '4822300', '5397804', '5499204', '5323116',
                              '5830680', '4722249', '5192146', '5272121',
                              '5699672', '5039158', '4698267', '3702829',
                              '5192413', '5111132', '5882432', '5628300',
                              '5200909', '4698232' )



SELECT * FROM loan

SELECT * FROM UniTracHDStorage..INC0213096



--UPDATE dbo.PRIOR_CARRIER_POLICY
--SET INSURANCE_COMPANY_NAME_TX = 'PROCTOR - PC'
--WHERE POLICY_NUMBER_TX IN ('5205914')


SELECT  * FROM dbo.INTERACTION_HISTORY
--UPDATE dbo.INTERACTION_HISTORY
--SET NOTE_TX = 'PROCTOR - PC
--Policy# 5205914
--Eff Date 1/1/2015 12:00:00 AM
--Exp Date 12/31/9999 11:59:59 PM'
WHERE ID IN (187203977)


SELECT  SPECIAL_HANDLING_XML.value('(/SH/InsuranceCompanyName)[1]', 'varchar (50)'),   * FROM dbo.INTERACTION_HISTORY
--UPDATE dbo.INTERACTION_HISTORY
--SET SPECIAL_HANDLING_XML = '<SH>
--  <InsuranceCompanyName>PROCTOR - PC</InsuranceCompanyName>
--  <PolicyNumber>5205914</PolicyNumber>
--  <EffDate>1/1/2015 12:00:00 AM</EffDate>
--  <CancellationDate>10/17/2015 12:00:00 AM</CancellationDate>
--  <ExpirationDate>12/31/9999 11:59:59 PM</ExpirationDate>
--  <ReasonMeaning />
--  <RC>108906822</RC>
--</SH>'
WHERE ID IN (187203975)
