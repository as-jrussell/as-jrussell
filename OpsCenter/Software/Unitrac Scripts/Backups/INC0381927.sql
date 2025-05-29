USE UniTrac

--Pull username
SELECT * FROM dbo.USERS
WHERE FAMILY_NAME_TX IN ('Cunningham') AND ACTIVE_IN = 'Y' AND PURGE_DT IS NULL

--If user doesn't have password but want Verification give user generic password 
UPDATE dbo.USERS
SET PASSWORD_TX = 'GG/C/8xpjcHNh0+bLQvMjLdPZO8YmyAV'
--SELECT * FROM dbo.USERS
WHERE ID = '1742'

---Backup UserPreference
SELECT * INTO UniTracHDStorage..INC0381927
FROM dbo.USER_PREFERENCE
WHERE USER_ID IN ('1742')

--delete the DashboardPreference row ONLY
DELETE dbo.USER_PREFERENCE
--SELECT * FROM dbo.USER_PREFERENCE
WHERE USER_ID IN ('1742')
AND TYPE_TX = 'DashboardPreference'
AND VALUE_TX = 'DefaultDashboard'


---Close and ReOpen UI for Verfication 
---If their password was blank previously reset their password to blank
UPDATE dbo.USERS
SET PASSWORD_TX = ''
--SELECT * FROM dbo.USERS
WHERE ID = '2059'



/*


Could I have you close out of your Unitrac software by clicking on the X in
the top right hand corner and re-launching Unitrac software then try the
reports and let me know if that resolves your problem.
 

*/