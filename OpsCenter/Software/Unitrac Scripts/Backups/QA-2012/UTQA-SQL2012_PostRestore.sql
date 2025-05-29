/*  
	Script Title:	Update UTQA-SQL2012 after restore from Production
    Created by:		Steve Moran
	Date/Time:		2014-11-24 14:46:25.837
	Description:	Run this script after a restore has been done
					on the UTQA-SQL2012 server against the UniTrac datbase
*/
USE UniTrac

SELECT * FROM dbo.REF_CODE WHERE DOMAIN_CD IN ('SSRSCONFIGINFO','system')

Update REF_CODE Set Meaning_TX = 'http://UTQA-SQL2012/UniTracServer/Help/Help.htm' 
where CODE_CD = 'HelpFileURL' and DOMAIN_CD = 'System' 

Update REF_CODE Set Meaning_TX = 'flNVdN5QdgKa6ZTJkXPz2Qcpaqlgap1OMgJnN4nTvxwXXly+OogMLQ==' 
where CODE_CD = 'Password' and DOMAIN_CD = 'SSRSConfigInfo'

Update REF_CODE Set Meaning_TX = 'http://UTQA-SQL2012/reportserver' 
where CODE_CD = 'ServerUrl' and DOMAIN_CD = 'SSRSConfigInfo'

Update REF_CODE Set Meaning_TX = 'UniTracAppUser' 
where CODE_CD = 'UserId' and DOMAIN_CD = 'SSRSConfigInfo'

Update REF_CODE Set Meaning_TX = 'http://UTQA-SQL2012/ReportServer/ReportExecution2005.asmx' 
where CODE_CD = 'ReportExecutionServiceUrl' and DOMAIN_CD = 'SSRSConfigInfo'

Update REF_CODE Set Meaning_TX = 'http://UTQA-SQL2012/ReportServer/ReportService2005.asmx' 
where CODE_CD = 'ReportServiceUrl' and DOMAIN_CD = 'SSRSConfigInfo'

--Update CONNECTION_DESCRIPTOR Set SERVER_TX = 'UTSTAGE01', 
--USERNAME_TX = 'nClZlXE2ktrN5UdonQgfWMV9leEPNo96CTTKyO0zp8c=', 
--PASSWORD_TX = 'flNVdN5QdgKa6ZTJkXPz2Qcpaqlgap1OMgJnN4nTvxwXXly+OogMLQ==' where ID = 1

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


------------------------- validate -----------------------------------

----------- CONNECTION DESCRIPTORS OY!!! -------------------------------
USE [UniTrac]
GO

Update CONNECTION_DESCRIPTOR Set NAME_TX = 'UniTracDW',SERVER_TX = 'UTQA-SQL2012', 
USERNAME_TX = 'nClZlXE2ktrN5UdonQgfWMV9leEPNo96CTTKyO0zp8c=', 
PASSWORD_TX = 'flNVdN5QdgKa6ZTJkXPz2Qcpaqlgap1OMgJnN4nTvxwXXly+OogMLQ==' where ID = 1

Update CONNECTION_DESCRIPTOR Set NAME_TX = 'VUT_Agency',SERVER_TX = 'VUTSTAGE01', 
USERNAME_TX = 'ykGX/FdKYchEg5OZ0B7PIA==', 
PASSWORD_TX = 'ykGX/FdKYchEg5OZ0B7PIA==' where ID = 3

DELETE FROM CONNECTION_DESCRIPTOR
WHERE ID IN (4,5,6,7,8,9,10,11,12,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35)

Update CONNECTION_DESCRIPTOR Set NAME_TX = 'AGENCY',SERVER_TX = 'VUTSTAGE01',USERNAME_TX = 'ykGX/FdKYchEg5OZ0B7PIA==',PASSWORD_TX = 'ykGX/FdKYchEg5OZ0B7PIA==' where ID = 4
Update CONNECTION_DESCRIPTOR Set NAME_TX = 'CST',SERVER_TX = 'VUTSTAGE02',USERNAME_TX = 'ykGX/FdKYchEg5OZ0B7PIA==',PASSWORD_TX = 'ykGX/FdKYchEg5OZ0B7PIA==' where ID = 5
Update CONNECTION_DESCRIPTOR Set NAME_TX = 'PST',SERVER_TX = 'VUTSTAGE03',USERNAME_TX = 'ykGX/FdKYchEg5OZ0B7PIA==',PASSWORD_TX = 'ykGX/FdKYchEg5OZ0B7PIA==' where ID = 6
Update CONNECTION_DESCRIPTOR Set NAME_TX = 'CML',SERVER_TX = 'VUTSTAGE04',USERNAME_TX = 'ykGX/FdKYchEg5OZ0B7PIA==',PASSWORD_TX = 'ykGX/FdKYchEg5OZ0B7PIA==' where ID = 7
Update CONNECTION_DESCRIPTOR Set NAME_TX = 'MID',SERVER_TX = 'VUTSTAGE05',USERNAME_TX = 'ykGX/FdKYchEg5OZ0B7PIA==',PASSWORD_TX = 'ykGX/FdKYchEg5OZ0B7PIA==' where ID = 8

----- Reset admin account password to be the same between UT-QA and UT-PROD -----------
update users set PASSWORD_TX = 'OOo2uY6cqEVRVagK2TRCCg==' where USER_NAME_TX = 'admin'

update users set PASSWORD_TX = 'OOo2uY6cqEVRVagK2TRCCg==' where USER_NAME_TX = 'MsgSrvr'

update users set PASSWORD_TX = 'kbi6PwjuYdDFYxAp2Y5JWw==' where USER_NAME_TX = 'LDHSrvr'

select * from UniTrac..CONNECTION_DESCRIPTOR