--RUN ON LISTENER

--- YOU MUST EXECUTE THE FOLLOWING SCRIPT IN SQLCMD MODE.
:Connect BOND-DEV-LISTEN

USE [master]

GO

ALTER AVAILABILITY GROUP [BOND-DEV-DBS]
MODIFY REPLICA ON N'CP-SQLDEV-01' WITH (SEEDING_MODE = MANUAL)

GO

USE [master]

GO

ALTER AVAILABILITY GROUP [BOND-DEV-DBS]
MODIFY REPLICA ON N'CP-SQLDEV-03' WITH (SEEDING_MODE = MANUAL)

GO

USE [master]

GO

ALTER AVAILABILITY GROUP [BOND-DEV-DBS]
ADD DATABASE [WinAppLog];

GO


GO

