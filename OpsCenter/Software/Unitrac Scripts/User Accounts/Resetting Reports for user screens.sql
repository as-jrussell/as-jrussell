USE UniTrac

--Pull username
SELECT * FROM dbo.USERS
WHERE FAMILY_NAME_TX IN ('') AND ACTIVE_IN = 'Y' AND PURGE_DT IS NULL

--If user doesn't have password but want Verification give user generic password 
UPDATE dbo.USERS
SET PASSWORD_TX = 'GG/C/8xpjcHNh0+bLQvMjLdPZO8YmyAV'
--SELECT * FROM dbo.USERS
WHERE ID = 'XXXX'

---Backup UserPreference
SELECT * INTO UniTracHDStorage..INCXXXXXX
FROM dbo.USER_PREFERENCE
WHERE USER_ID IN ('')

--delete the DashboardPreference row ONLY
DELETE dbo.USER_PREFERENCE
--SELECT * FROM dbo.USER_PREFERENCE
WHERE USER_ID IN ('')
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


exec LoginSSO @userName='jrussell'

select * from user_relate
where user_id in (2059)


select * from user_security_group_relate
where user_id in (2059)

select * from USER_QUEUE_FILTER



   SELECT *
   FROM USERS
   WHERE USER_NAME_TX = 'jrussell'
     and PURGE_DT is null
     and ACTIVE_IN = 'Y'
     and EXTERN_MAINT_IN = 'Y'


	 update u
	 set EXTERN_MAINT_IN =R.EXTERN_MAINT_IN
	 --select *
	    FROM USERS U 
		join unitrachdstorage..[20200205User_Restore] R on R.id= u.id
