USE [master]
GO
CREATE LOGIN [ELDREDGE_A\tchappell] FROM WINDOWS WITH DEFAULT_DATABASE=[ACSYSTEM]
GO
USE [ACSYSTEM]
GO
ALTER AUTHORIZATION ON DATABASE::[ACSYSTEM] TO [ELDREDGE_A\tchappell]
GO

use master

GRANT VIEW SERVER STATE TO [ELDREDGE_A\tchappell]

GRANT ALTER ANY DATABASE TO [ELDREDGE_A\tchappell]
GO