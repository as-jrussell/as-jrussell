USE UniTrac

--Pull username
SELECT * FROM dbo.USERS
WHERE FAMILY_NAME_TX = 'Carr'

--If user doesn't have password but want Verification give user generic password 
UPDATE dbo.USERS
SET PASSWORD_TX = 'GG/C/8xpjcHNh0+bLQvMjLdPZO8YmyAV'
--SELECT * FROM dbo.USERS
WHERE ID = '2059'

---Backup UserPreference
SELECT * --INTO UniTracHDStorage..INC0252921
FROM dbo.USER_PREFERENCE
WHERE USER_ID = '2059'

--delete the DashboardPreference row ONLY
DELETE dbo.USER_PREFERENCE
--SELECT * FROM dbo.USER_PREFERENCE
WHERE USER_ID = '2059' 
AND TYPE_TX = 'DashboardPreference'
AND VALUE_TX = 'DefaultDashboard'


---Close and ReOpen UI for Verfication 
---If their password was blank previously reset their password to blank
UPDATE dbo.USERS
SET PASSWORD_TX = ''
--SELECT * FROM dbo.USERS
WHERE ID = '2059'

