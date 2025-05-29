---------------------- REF_CODE Updates YEAH -------------------
USE UniTrac

SELECT * FROM dbo.REF_CODE WHERE DOMAIN_CD IN ('SSRSCONFIGINFO','system')

Update REF_CODE Set Meaning_TX = 'http://unitracapp-staging.alliedsolutions.net/UniTracServer/Help/Help.htm' 
where CODE_CD = 'HelpFileURL' and DOMAIN_CD = 'System' 

Update REF_CODE Set Meaning_TX = 'flNVdN5QdgKa6ZTJkXPz2Qcpaqlgap1OMgJnN4nTvxwXXly+OogMLQ==' 
where CODE_CD = 'Password' and DOMAIN_CD = 'SSRSConfigInfo'

Update REF_CODE Set Meaning_TX = 'http://UTSTAGE-RPT01/reportserver' 
where CODE_CD = 'ServerUrl' and DOMAIN_CD = 'SSRSConfigInfo'

Update REF_CODE Set Meaning_TX = 'UniTracAppUser' 
where CODE_CD = 'UserId' and DOMAIN_CD = 'SSRSConfigInfo'

Update REF_CODE Set Meaning_TX = 'http://UTSTAGE-RPT01/ReportServer/ReportExecution2005.asmx' 
where CODE_CD = 'ReportExecutionServiceUrl' and DOMAIN_CD = 'SSRSConfigInfo'

Update REF_CODE Set Meaning_TX = 'http://UTSTAGE-RPT01/ReportServer/ReportService2005.asmx' 
where CODE_CD = 'ReportServiceUrl' and DOMAIN_CD = 'SSRSConfigInfo'

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

Update CONNECTION_DESCRIPTOR Set NAME_TX = 'UniTracDW',SERVER_TX = 'UTSTAGE01', 
USERNAME_TX = 'nClZlXE2ktrN5UdonQgfWMV9leEPNo96CTTKyO0zp8c=', 
PASSWORD_TX = 'flNVdN5QdgKa6ZTJkXPz2Qcpaqlgap1OMgJnN4nTvxwXXly+OogMLQ==' where ID = 1

Update CONNECTION_DESCRIPTOR Set NAME_TX = 'VUT_Agency',SERVER_TX = 'VUTSTAGE01', 
USERNAME_TX = 'ykGX/FdKYchEg5OZ0B7PIA==', 
PASSWORD_TX = 'ykGX/FdKYchEg5OZ0B7PIA==' where ID = 3

DELETE FROM CONNECTION_DESCRIPTOR
WHERE ID IN (5,7,8,9,10,11,12,21,22,23,25,26,27,28,30,31)

Update CONNECTION_DESCRIPTOR Set NAME_TX = 'AGENCY',SERVER_TX = 'VUTSTAGE01',USERNAME_TX = 'ykGX/FdKYchEg5OZ0B7PIA==',PASSWORD_TX = 'ykGX/FdKYchEg5OZ0B7PIA==' where ID = 4
Update CONNECTION_DESCRIPTOR Set NAME_TX = 'PST',SERVER_TX = 'VUTSTAGE02',DATABASE_NM = 'VUT',USERNAME_TX = 'ykGX/FdKYchEg5OZ0B7PIA==',PASSWORD_TX = 'ykGX/FdKYchEg5OZ0B7PIA==' where ID = 6
Update CONNECTION_DESCRIPTOR Set NAME_TX = 'PST_HIST',SERVER_TX = 'VUTSTAGE02',DATABASE_NM = 'VUTHISTORY', USERNAME_TX = 'ykGX/FdKYchEg5OZ0B7PIA==',PASSWORD_TX = 'ykGX/FdKYchEg5OZ0B7PIA==' where ID = 24
Update CONNECTION_DESCRIPTOR Set NAME_TX = 'Scan',SERVER_TX = 'UTSTAGE01',USERNAME_TX = 'ykGX/FdKYchEg5OZ0B7PIA==',PASSWORD_TX = 'ykGX/FdKYchEg5OZ0B7PIA==' where ID = 29
Update CONNECTION_DESCRIPTOR Set NAME_TX = 'WTQ',SERVER_TX = '10.10.18.203\Wintraq2',USERNAME_TX = 'O3v12M9Xt9uJw8Z7ZAxqtwbNX1gf9fBZ',PASSWORD_TX = 'vCcp3ukI8dVlSbkFUKc6hyInNpi7JuWS' where ID = 32
Update CONNECTION_DESCRIPTOR Set NAME_TX = 'PERFLOG',SERVER_TX = 'UTSTAGE01',DATABASE_NM = 'UniTrac',USERNAME_TX = 'ykGX/FdKYchEg5OZ0B7PIA==',PASSWORD_TX = 'ykGX/FdKYchEg5OZ0B7PIA==' where ID = 33
Update CONNECTION_DESCRIPTOR Set NAME_TX = 'OSC',SERVER_TX = 'VUTSTAGE05',DATABASE_NM = 'VUT',USERNAME_TX = 'ykGX/FdKYchEg5OZ0B7PIA==',PASSWORD_TX = 'ykGX/FdKYchEg5OZ0B7PIA==' where ID = 34
Update CONNECTION_DESCRIPTOR Set NAME_TX = 'OSC_HIST',SERVER_TX = 'VUTSTAGE05',DATABASE_NM = 'VUTHistory',USERNAME_TX = 'ykGX/FdKYchEg5OZ0B7PIA==',PASSWORD_TX = 'ykGX/FdKYchEg5OZ0B7PIA==' where ID = 35

