---------------------- REF_CODE Updates YEAH -------------------
USE UniTrac

SELECT * FROM dbo.REF_CODE WHERE DOMAIN_CD IN ('SSRSCONFIGINFO','system')

Update REF_CODE Set Meaning_TX = 'http://utqa2-app1/UniTracServer/Help/Help.htm' 
where CODE_CD = 'HelpFileURL' and DOMAIN_CD = 'System' 

Update REF_CODE Set Meaning_TX = '9JISp5ZNyrAcNw+dns3LhNPpHr8Io6FVLNZICwpDK4sArB/JxLs2KgU+3D4wGd4h' 
where CODE_CD = 'Password' and DOMAIN_CD = 'SSRSConfigInfo'

Update REF_CODE Set Meaning_TX = 'http://utqa-sql-14/reportserver' 
where CODE_CD = 'ServerUrl' and DOMAIN_CD = 'SSRSConfigInfo'

Update REF_CODE Set Meaning_TX = 'ReportUser' 
where CODE_CD = 'UserId' and DOMAIN_CD = 'SSRSConfigInfo'

Update REF_CODE Set Meaning_TX = 'http://utqa-sql-14/ReportServer/ReportService2005.asmx' 
where CODE_CD = 'ReportExecutionServiceUrl' and DOMAIN_CD = 'SSRSConfigInfo'

Update REF_CODE Set Meaning_TX = 'http://utqa-sql-14/ReportServer/ReportService2005.asmx' 
where CODE_CD = 'ReportServiceUrl' and DOMAIN_CD = 'SSRSConfigInfo'


---------------------- REF_CODE File Location Updates -------------------


UPDATE REF_CODE
SET MEANING_TX = '\\utqa2-app1\LenderFiles\AOBC\TelevoxResponse\'
WHERE DOMAIN_CD = 'DefaultFileLoc' AND CODE_CD = 'AUTOOBC_RF'

UPDATE REF_CODE
SET MEANING_TX = '\\utqa2-app1\LenderFiles\Escrow\InsFile\'
WHERE DOMAIN_CD = 'DefaultFileLoc' AND CODE_CD = 'INSBCKFD'

UPDATE REF_CODE
SET MEANING_TX = '\\utqa2-app1\LenderFiles\LenderCancelFiles\'
WHERE DOMAIN_CD = 'DefaultFileLoc' AND CODE_CD = 'LNDRCNCL'


-------------------------------------------------------------------



------------------------ validate ----------------------------
SELECT * FROM UniTrac..REF_CODE
WHERE CODE_CD = 'PASSWORD' AND DOMAIN_CD = 'SSRSConfigInfo'

SELECT * FROM UniTrac..REF_CODE
WHERE CODE_CD = 'ServerUrl' AND DOMAIN_CD = 'SSRSConfigInfo'

SELECT * FROM  UniTrac..REF_CODE 
where CODE_CD = 'UserId' and DOMAIN_CD = 'SSRSConfigInfo'

SELECT * FROM UniTrac..USERS where USER_NAME_TX = 'admin'

SELECT * FROM UniTrac..USERS where USER_NAME_TX = 'MsgSrvr'

SELECT * FROM UniTrac..USERS where USER_NAME_TX = 'LDHSrvr'

----- Reset admin account password to be the same between UT-QA and UT-PROD -----------
update users set PASSWORD_TX = 'OOo2uY6cqEVRVagK2TRCCg==' where USER_NAME_TX = 'admin'

update users set PASSWORD_TX = 'OOo2uY6cqEVRVagK2TRCCg==' where USER_NAME_TX = 'MsgSrvr'

update users set PASSWORD_TX = 'kbi6PwjuYdDFYxAp2Y5JWw==' where USER_NAME_TX = 'LDHSrvr'

----------- CONNECTION DESCRIPTORS OY!!! -------------------------------
select * from UniTrac..CONNECTION_DESCRIPTOR

USE [UniTrac]
GO

Update CONNECTION_DESCRIPTOR Set NAME_TX = 'UniTracDW',SERVER_TX = 'UTQA-SQL-14', 
USERNAME_TX = 'nClZlXE2ktrN5UdonQgfWMV9leEPNo96CTTKyO0zp8c=', 
PASSWORD_TX = --'flNVdN5QdgKa6ZTJkXPz2Qcpaqlgap1OMgJnN4nTvxwXXly+OogMLQ==' 
'tROKIsmSZCRZ6em+1WCiTeY6nsRwNtfq+H9SqTZoXfPQ6zNuXI6CYGEmb1Jrzp8v'
WHERE ID = 1

Update CONNECTION_DESCRIPTOR Set NAME_TX = 'VUT_Agency',SERVER_TX = 'VUTQA01', 
USERNAME_TX = 'ykGX/FdKYchEg5OZ0B7PIA==', 
PASSWORD_TX = 'ykGX/FdKYchEg5OZ0B7PIA==' where ID = 3

DELETE 
--SELECT *
FROM CONNECTION_DESCRIPTOR
WHERE ID not IN (1,3,29,35,36,37,40,41)

Update CONNECTION_DESCRIPTOR Set NAME_TX = 'Scan',SERVER_TX = 'UTQA-SQL-14',USERNAME_TX = 'nClZlXE2ktrN5UdonQgfWMV9leEPNo96CTTKyO0zp8c=',PASSWORD_TX = 'tROKIsmSZCRZ6em+1WCiTeY6nsRwNtfq+H9SqTZoXfPQ6zNuXI6CYGEmb1Jrzp8v' where ID = 29
Update CONNECTION_DESCRIPTOR Set NAME_TX = 'PERFLOG',SERVER_TX = 'UTQA-SQL-14',DATABASE_NM = 'Unitrac',USERNAME_TX = 'nClZlXE2ktrN5UdonQgfWMV9leEPNo96CTTKyO0zp8c=',PASSWORD_TX = 'tROKIsmSZCRZ6em+1WCiTeY6nsRwNtfq+H9SqTZoXfPQ6zNuXI6CYGEmb1Jrzp8v' where ID = 35
Update CONNECTION_DESCRIPTOR Set NAME_TX = 'ProdRO',SERVER_TX = 'UNITRAC-DB01',DATABASE_NM = 'Unitrac', USERNAME_TX = '6AQRyQ1OIN9iZ11ys1Tcfh3Yef2QEMcJp1IAcWJjorM=',PASSWORD_TX = 'eTup3wL/SuV0ly4K/X2Fe+3PvDDPSShu' where ID = 36
Update CONNECTION_DESCRIPTOR Set NAME_TX = 'UniTracArchive',SERVER_TX = 'UTQA-SQL-14',USERNAME_TX = 'nClZlXE2ktrN5UdonQgfWMV9leEPNo96CTTKyO0zp8c=',PASSWORD_TX = 'tROKIsmSZCRZ6em+1WCiTeY6nsRwNtfq+H9SqTZoXfPQ6zNuXI6CYGEmb1Jrzp8v' where ID = 37
Update CONNECTION_DESCRIPTOR Set NAME_TX = 'NADA-VehicleUC',SERVER_TX = 'UTQA-SQL-14',USERNAME_TX = 'nClZlXE2ktrN5UdonQgfWMV9leEPNo96CTTKyO0zp8c=',PASSWORD_TX = 'tROKIsmSZCRZ6em+1WCiTeY6nsRwNtfq+H9SqTZoXfPQ6zNuXI6CYGEmb1Jrzp8v' where ID = 40
Update CONNECTION_DESCRIPTOR Set NAME_TX = 'NADA-VehicleCT',SERVER_TX = 'UTQA-SQL-14',USERNAME_TX = 'nClZlXE2ktrN5UdonQgfWMV9leEPNo96CTTKyO0zp8c=',PASSWORD_TX = 'tROKIsmSZCRZ6em+1WCiTeY6nsRwNtfq+H9SqTZoXfPQ6zNuXI6CYGEmb1Jrzp8v' where ID = 41

