
IF Object_id(N'tempdb..#Profiles') IS NOT NULL
DROP TABLE #Profiles;
CREATE TABLE #Profiles (
    profile_id INT,
    name VARCHAR(128),
    description VARCHAR(256)
);

IF Object_id(N'tempdb..#Accounts') IS NOT NULL
DROP TABLE #Accounts;
CREATE TABLE #Accounts (
    account_id INT,
    name VARCHAR(128),
    description VARCHAR(256),
    email_address VARCHAR(128),
    display_name VARCHAR(128),
    replyto_address VARCHAR(128),
    servertype VARCHAR(128),
    servername VARCHAR(128),
    port INT,
    username VARCHAR(128),
    use_default_credentials BIT,
    enable_ssl BIT
);

IF Object_id(N'tempdb..#ProfileAccounts') IS NOT NULL
DROP TABLE #ProfileAccounts;
CREATE TABLE #ProfileAccounts (
    profile_id INT,
	    name VARCHAR(128),
    account_id INT,
	email_address VARCHAR(128),
	sequence_number INT
);

INSERT INTO #Profiles
EXEC msdb.dbo.sysmail_help_profile_sp;

INSERT INTO #Accounts
EXEC msdb.dbo.sysmail_help_account_sp;

-- Capture data from sysmail_profileaccount
INSERT INTO #ProfileAccounts 
EXEC msdb.dbo.sysmail_help_profileaccount_sp;

SELECT p.name AS profile_name, a.name AS account_name, a.email_address
FROM #Profiles p
INNER JOIN #ProfileAccounts pa ON p.profile_id = pa.profile_id
INNER JOIN #Accounts a ON pa.account_id = a.account_id;

