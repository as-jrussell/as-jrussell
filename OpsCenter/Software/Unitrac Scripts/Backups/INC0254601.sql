USE [UniTrac]
GO 
--Loan Screen Information - LOAN/COLLATERAL/PROPERTY/OWNER/REQUIRED COVERAGE
SELECT  L.ID [LoanID], C.ID [CollID], P.ID [PropertyID], RC.ID [ReqCovID], POP.ID, OP.ID [OwnerProperID],
PC.ID [PolicyCoverageID] INTO #tmp
--SELECT CANCEL_REASON_CD, ex
FROM    LOAN L
        INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
        INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
        INNER JOIN REQUIRED_COVERAGE RC ON P.ID = RC.PROPERTY_ID
        INNER JOIN dbo.PROPERTY_OWNER_POLICY_RELATE POP ON POP.PROPERTY_ID = P.ID
        INNER JOIN dbo.OWNER_POLICY OP ON OP.ID = POP.OWNER_POLICY_ID
        INNER JOIN dbo.POLICY_COVERAGE PC ON PC.OWNER_POLICY_ID = OP.ID
WHERE   L.LENDER_ID = '2333'
        AND L.NUMBER_TX IN ( '202018', '201744', '300239', '101503', '101620',
                             '302007', '20243', '103940', '200573', '201836',
                             '300976', '301308', '109656', '200175', '200785',
                             '202860', '209540', '300663', '303066', '110370',
                             '201394', '207417', '301384', '105540', '107798',
                             '210946', '10360', '20541', '106266', '106286',
                             '109094', '112361', '201231', '300556', '301054',
                             '20296', '111090', '112431', '203630', '204097',
                             '206432', '211145', '300905', '301814', '302252',
                             '118660', '302817', '205057', '21004', '109081',
                             '111079', '306263', '100352', '109331', '117932',
                             '117963', '201251', '202153', '202964', '203925',
                             '206302', '207413', '300680', '10171', '100755',
                             '102462', '114552', '116482', '202729', '202948',
                             '303505', '120435', '305485', '107866', '20198',
                             '110272', '111742', '112239', '200174', '205443',
                             '300019', '303058', '303689', '110233', '112098',
                             '112405', '112854', '200960', '206165', '210369',
                             '302571', '302892', '303176', '306296', '109557',
                             '109587', '111760', '301230', '301657', '306304',
                             '106331', '108421', '111210', '203211', '204936',
                             '209520', '113060', '114546', '119957', '206214',
                             '211209', '111567', '119276', '200553', '201702',
                             '302290', '20240', '102420', '203846', '204774',
                             '302514', '304056', '105477', '201077', '200043',
                             '200980', '103244', '106933', '301639', '202677',
                             '300432', '20168', '101704', '102860', '110640',
                             '111452', '202703', '302619', '104690', '201074',
                             '201094', '301243', '20839', '104667', '107375',
                             '201856', '300764', '113936', '115796', '116579',
                             '210946', '120006', '118136', '119965', '119966',
                             '208803', '113382', '113655', '201140', '207478',
                             '107521', '118165', '120017', '118193', '118028',
                             '101593', '120209', '204867', '116725', '107719',
                             '201414', '106928', '206759', '100474', '110233',
                             '113464', '205475', '210666', '210809', '306362',
                             '109828', '119632', '206435', '210670', '116654',
                             '305586', '305609', '301175', '304108', '105627',
                             '114769', '114879', '120321', '200159', '201210',
                             '209765', '301223', '304499', '120121', '203211',
                             '205559', '209546', '303058', '306379', '114883',
                             '210647', '306388' )



SELECT  LoanID ,
        CollID ,
		PropertyID,
        ReqCovID ,
        ID ,
        OwnerProperID ,
        PolicyCoverageID FROM #tmp



SELECT * INTO UniTracHDStorage..INC0254601_Loan
FROM dbo.LOAN
WHERE ID IN (SELECT LoanID FROM #tmp)

SELECT * INTO UniTracHDStorage..INC0254601_Coll
FROM dbo.COLLATERAL
WHERE ID IN (SELECT CollID FROM #tmp)


SELECT * INTO UniTracHDStorage..INC0254601_Prop
FROM dbo.PROPERTY
WHERE ID IN (SELECT PropertyID FROM #tmp)

SELECT * --INTO UniTracHDStorage..INC0254601_RC
FROM dbo.REQUIRED_COVERAGE
WHERE ID IN (SELECT ReqCovID FROM #tmp)

SELECT * FROM UniTracHDStorage..INC0254601_RC


SELECT * INTO UniTracHDStorage..INC0254601_OP
FROM dbo.OWNER_POLICY
WHERE ID IN (SELECT OwnerProperID FROM #tmp)

SELECT * INTO UniTracHDStorage..INC0254601_PC
FROM dbo.POLICY_COVERAGE
WHERE ID IN (SELECT PolicyCoverageID FROM #tmp)


SELECT * FROM UniTracHDStorage..CUS3769


SELECT CC.* --INTO UniTracHDStorage..INC0254601_COll_MaintenanceChange
FROM dbo.REQUIRED_COVERAGE RC
JOIN #tmp T ON T.ReqCovID = RC.ID
JOIN dbo.LOAN L ON L.ID = LoanID
JOIN UniTracHDStorage..CUS3769 C ON C.[ACCT NO] = L.NUMBER_TX --AND C.[Coverage] = RC.TYPE_CD
JOIN dbo.COLLATERAL CC ON CC.LOAN_ID = L.ID
WHERE RC.ID IN (SELECT ReqCovID FROM #tmp)






SELECT * FROM UniTracHDStorage..INC0254601_COll_MaintenanceChange


UPDATE dbo.REQUIRED_COVERAGE
SET STATUS_CD = 'M', UPDATE_DT = GETDATE(), UPDATE_USER_TX = 'INC0254601', 
LOCK_ID = CASE WHEN LOCK_ID >= 255 THEN 1 ELSE LOCK_ID + 1 END
--SELECT * FROM REQUIRED_COVERAGE
WHERE ID IN (SELECT ReqCovID FROM #tmp)

(SELECT ID FROM UniTracHDStorage..INC0254601_RC_MaintenanceChange)






--Get Versions
SELECT @@VERSION AS 'SQL Server Version'

SELECT @@VERSION AS 'SQL Server Version'

--Product Information
SELECT
SERVERPROPERTY('ProductVersion') AS ProductVersion,
SERVERPROPERTY('ProductLevel') AS ProductLevel,
SERVERPROPERTY('Edition') AS Edition,
SERVERPROPERTY('EngineEdition') AS EngineEdition;
GO
--ServerName
SELECT @@SERVERNAME [DB installed on]