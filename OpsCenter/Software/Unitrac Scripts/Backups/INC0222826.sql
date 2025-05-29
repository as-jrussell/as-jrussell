SELECT  L.ID [LoanID] ,
        L.NUMBER_TX [LoanNumber] ,
        RC.*
INTO    #tmp2
FROM    LOAN L
        INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
        INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
        INNER JOIN REQUIRED_COVERAGE RC ON P.ID = RC.PROPERTY_ID
        INNER JOIN OWNER_LOAN_RELATE OL ON L.ID = OL.LOAN_ID
        INNER JOIN OWNER O ON OL.OWNER_ID = O.ID
        INNER JOIN OWNER_ADDRESS OA ON O.ADDRESS_ID = OA.ID
        INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
WHERE   LL.CODE_TX IN ( '2250' )
        AND L.NUMBER_TX NOT IN ( '10004674', '10002864', '10003949', '10004154',
                             '10006337', '10005071', '10007465', '10007816',
                             '10008083', '410004622', '410004791', '410004924',
                             '410003852', '410004865', '410003790',
                             '410005099', '410004561', '410004770',
                             '410008461', '410006273', '410003800',
                             '410008338', '410005133', '410008651',
                             '410008296', '410006836', '10004092', '10004144',
                             '10004215', '410007610', '1012092705',
                             '1013013000', '1013022514', '1013042504',
                             '1013060609', '1013081910', '1014010902',
                             '1015031804', '1015032000', '1015051106',
                             '1015071701', '410004414', '1015041400',
                             '1013103106', '10005125', '10005293', '10006153',
                             '10008694', '10005170', '10008737', '10291990',
                             '410005467', '410008275', '410008430',
                             '410008512', '50007379', '1012091211',
                             '1013052902', '1012102501', '410003500',
                             '1013062005', '410005109', '410006390',
                             '410007649', '410008297', '410008333', '10003013',
                             '10003124', '410004395', '410008557', '410008336',
                             '101307032', '1013101001', '1015101509',
                             '1014040407', '1014100807', '1013052201',
                             '10005460', '50006422', '410007143', '10004055',
                             '10004401', '10005488', '10008039', '10008498',
                             '10008675', '410002290', '410005716',
                             '1013120305', '410006428', '10004635', '10007453',
                             '10007761', '1013062001', '410003690',
                             '410006959', '410005055', '410006312',
                             '1015010614', '1015091701', '410004930',
                             '410007590', '10005768', '10006542', '10008705',
                             '410004955', '1013021404', '1013103001',
                             '10005409', '410001654', '410005604',
                             '1013050306', '1014052003', '1015042402',
                             '50007784', '410004054', '10005315', '10007348',
                             '10007591', '1013031407', '1013041107',
                             '10002404', '30005674', '410002383', '410003856',
                             '410004854', '410007634', '410007968',
                             '1013032603', '50005630', '10007671', '10006300',
                             '1014010609', '1014110501', '1015030409',
                             '410007186', '410007656', '410004510',
                             '410006821', '1015021805', '1015031814',
                             '10004504', '50004863', '10007426', '40021669',
                             '50005950', '410004709', '410006669',
                             '1014052100', '1014071605', '1014123002',
                             '410002887', '410005023', '410006781',
                             '410007958', '410008165', '410008331',
                             '410008527', '10004374', '10005629', '410008216',
                             '1013031902', '10005427', '10007627', '10007901' )

SELECT L.NUMBER_TX, RC. *
INTO UniTracHDStorage..INC0222826
FROM    LOAN L
        INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
        INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
        INNER JOIN REQUIRED_COVERAGE RC ON P.ID = RC.PROPERTY_ID
        INNER JOIN OWNER_LOAN_RELATE OL ON L.ID = OL.LOAN_ID
        INNER JOIN OWNER O ON OL.OWNER_ID = O.ID
        INNER JOIN OWNER_ADDRESS OA ON O.ADDRESS_ID = OA.ID
        INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
WHERE   LL.CODE_TX IN ( '2250' )  AND RC.TYPE_CD = 'WIND' AND RC.ID IN (SELECT ID FROM #tmp2)
--AND L.STATUS_CD = 'A' AND L.ID NOT IN (121242402) AND RC.STATUS_CD = 'A'


--SELECT  L.ID [LoanID] ,
--        L.NUMBER_TX [LoanNumber] ,
--        RC.*
--INTO UniTracHDStorage..INC0222826_2
--FROM    LOAN L
--        INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
--        INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
--        INNER JOIN REQUIRED_COVERAGE RC ON P.ID = RC.PROPERTY_ID
--        INNER JOIN OWNER_LOAN_RELATE OL ON L.ID = OL.LOAN_ID
--        INNER JOIN OWNER O ON OL.OWNER_ID = O.ID
--        INNER JOIN OWNER_ADDRESS OA ON O.ADDRESS_ID = OA.ID
--        INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
--WHERE   LL.CODE_TX IN ( '2250' )  AND L.ID IN (SELECT LoanID FROM #tmp)
--AND RC.TYPE_CD = 'WIND' AND RC.STATUS_CD = 'A' --AND L.NUMBER_TX = '10004674'
----'10004674'
--ORDER BY L.NUMBER_TX ASC




--'8800587L40','8900533L40','
UPDATE dbo.REQUIRED_COVERAGE
SET STATUS_CD = 'I'
--SELECT * FROM dbo.REQUIRED_COVERAGE
WHERE ID IN (SELECT ID FROM #tmp2) AND TYPE_CD = 'WIND' AND STATUS_CD = 'A'