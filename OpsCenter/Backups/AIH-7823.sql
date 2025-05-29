use master

IF EXISTS (SELECT 1 FROM sys.server_file_audits where name = 'Audit-20180403-123205')
BEGIN 
		ALTER SERVER AUDIT [Audit-20180403-123205] WITH (STATE = OFF)
		ALTER SERVER AUDIT [Audit-20180403-123205]
		TO FILE 
		(		MAXSIZE = 5120 MB
			,MAX_FILES = 2
			,FILEPATH = N'G:\Audit\Miscellaneous'
		)
		ALTER SERVER AUDIT [Audit-20180403-123205] WITH (STATE = ON)
		PRINT 'Audit-20180403-123205 MAX SIZE AND MAX FILES have been reduce, remove any older file'

END 

	ELSE

BEGIN
	PRINT 'Audit-20180403-123205 was not modified'


END

