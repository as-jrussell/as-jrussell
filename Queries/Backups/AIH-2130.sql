USE [ACSYSTEM]
GO

--/****** Object:  User [audit]    Script Date: 4/22/2021 10:59:36 AM ******/
CREATE USER [audit] WITHOUT LOGIN WITH DEFAULT_SCHEMA=[dbo]
GO

CREATE SCHEMA [audit] AUTHORIZATION [audit]
GO

GRANT CREATE VIEW TO [ELDREDGE_A\tchappell];
GRANT CREATE PROCEDURE TO [ELDREDGE_A\tchappell];
GRANT ALTER ON SCHEMA::[dbo] TO [ELDREDGE_A\tchappell];
GRANT ALTER ON SCHEMA::[audit] TO [ELDREDGE_A\tchappell];


/*

REVOKE CREATE VIEW TO [ELDREDGE_A\tchappell];
REVOKE CREATE PROCEDURE TO [ELDREDGE_A\tchappell];
REVOKE ALTER ON SCHEMA::[dbo] TO [ELDREDGE_A\tchappell];
REVOKE ALTER ON SCHEMA::[audit] TO [ELDREDGE_A\tchappell];

*/