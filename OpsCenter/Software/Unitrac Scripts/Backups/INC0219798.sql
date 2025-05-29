USE [UniTrac]
GO 

--Loan Screen Information - LOAN/COLLATERAL/PROPERTY/OWNER/REQUIRED COVERAGE
SELECT COUNt (NUMBER_TX), LL.NAME_TX FROM LOAN L
INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
INNER JOIN REQUIRED_COVERAGE RC ON P.ID = RC.PROPERTY_ID
INNER JOIN OWNER_LOAN_RELATE OL ON L.ID = OL.LOAN_ID
INNER JOIN OWNER O ON OL.OWNER_ID = O.ID
INNER JOIN OWNER_ADDRESS OA ON O.ADDRESS_ID = OA.ID
INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
INNER JOIN dbo.INTERACTION_HISTORY IH ON IH.PROPERTY_ID = P.ID
WHERE rc.SUMMARY_SUB_STATUS_CD = 'C' AND RC.SUMMARY_STATUS_CD NOT IN ('C',
'CH',
'E',
'EH', 'X',
'XH') AND L.STATUS_CD = 'A'
GROUP BY LL.NAME_TX


SELECT * FROM dbo.REF_CODE
WHERE --CODE_CD LIKE ('%SUMMARY_STATUS_CD%')

--CODE_CD IN ('F', 'D') AND 
DOMAIN_CD IN ( 'RequiredCoverageInsStatus')

'RequiredCoverageInsSubStatus',




SELECT  ID, DESCRIPTION_TX, SECONDARY_CLASS_CD
FROM    dbo.COLLATERAL_CODE
WHERE   ID IN ( '13', '15', '81', '83', '181', '230', '232', '315', '317',
                '381', '383', '451', '498', '598', '617', '651', '1', '10',
                '12', '42', '67', '69', '71', '76', '78', '203', '210', '237',
                '246', '269', '276', '371', '435', '437', '446', '478', '503',
                '505', '512', '537', '571', '578', '14', '16', '31', '33',
                '63', '80', '82', '233', '250', '280', '333', '382', '467',
                '514', '518', '584', '616', '650', '51', '60', '62', '85',
                '228', '385', '453', '485', '487', '528', '555', '560', '562',
                '564', '594', '596', '619', '621', '7', '8', '39', '72', '75',
                '89', '90', '225', '239', '258', '275', '289', '290', '308',
                '325', '357', '457', '508', '525', '526', '543', '557', '575',
                '576', '593', '640', '2', '9', '27', '34', '52', '59', '70',
                '77', '209', '234', '245', '270', '313', '338', '345', '370',
                '427', '445', '452', '463', '513', '527', '538', '577', '652',
                '4', '11', '29', '61', '68', '79', '86', '204', '229', '243',
                '268', '304', '318', '343', '436', '504', '511', '522', '536',
                '547', '554', '579', '586', '597', '622', '647', '654', '5',
                '6', '41', '73', '74', '88', '206', '255', '259', '274', '291',
                '309', '409', '456', '473', '474', '523', '524', '542', '574',
                '624', '641' )



SELECT LO.TYPE_CD, LO.CODE_TX , Lo.NAME_TX,*
FROM LENDER L
INNER JOIN LENDER_ORGANIZATION LO ON L.ID = LO.LENDER_ID
INNER JOIN RELATED_DATA RD ON LO.ID = RD.RELATE_ID --AND RD.DEF_ID = '105'
WHERE L.CODE_TX = '' AND Lo.TYPE_CD = 'DIV'


