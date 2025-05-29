use unitrac

SELECT U.USER_NAME_TX ,
       U.FAMILY_NAME_TX ,
       U.GIVEN_NAME_TX ,
       U.EMAIL_TX ,
       sf.CODE_TX ,
       sf.DESCRIPTION_TX ,
       sc.ATTRIBUTE_1_IN
FROM   dbo.SECURITY_CONTAINER sc
       JOIN dbo.SECURITY_FUNCTION sf ON sf.ID = sc.SECURITY_FUNC_ID
       JOIN dbo.USERS U ON U.ID = sc.USER_ID
WHERE  sf.ID = 64
       AND sc.ATTRIBUTE_1_IN = 'Y'
       AND U.ACTIVE_IN = 'Y'
       AND U.PURGE_DT IS NULL
       AND sc.PURGE_DT IS NULL;
	   --64
	   

	   select * from SECURITY_FUNCTION sf
	   join  dbo.SECURITY_CONTAINER sc ON sf.ID = sc.SECURITY_FUNC_ID
	   join security_group sg on sg.id = sc.security_grp_id
	   WHERE  sf.ID = 64 AND sc.ATTRIBUTE_1_IN = 'Y'
	   and sg.id in (2,7,8,33,48,69,187,199)




	   select * from SECURITY_FUNCTION
	   where display_tx like '%escrow%'



	   select * from security_group

	    select * from USER_SECURITY_GROUP_RELATE usgr
		join users u on u.id =usgr.user_id
		where u.id in (7)


   select * from security_group sg
	   join USER_SECURITY_GROUP_RELATE usgr on usgr.sec_grp_id = sg.id
		join users u on u.id =usgr.user_id
		where sg.ID = 1


		UT-PRD-LISTENER


		exec SearchFullTextProperty @searchText=N'("John*")',@includeArchive=N'N',@lenderId=962,@useLenderGrouping='N'


		select sf.*
	--	   select sg.id into #tmpSG 
		   from security_group sg
	   join USER_SECURITY_GROUP_RELATE usgr on usgr.sec_grp_id = sg.id
		join users u on u.id =usgr.user_id
		join dbo.SECURITY_CONTAINER sc ON U.ID = sc.USER_ID
		JOIN dbo.SECURITY_FUNCTION sf ON sf.ID = sc.SECURITY_FUNC_ID
WHERE  sf.ID = 64
       AND sc.ATTRIBUTE_1_IN = 'Y'
       AND U.ACTIVE_IN = 'Y'
       AND U.PURGE_DT IS NULL
       AND sc.PURGE_DT IS NULL;

	   select * from #tmpSG

select DISTINCT  U.GIVEN_NAME_TX [First Name],
       U.FAMILY_NAME_TX [Last Name], 
       U.EMAIL_TX [Email] ,'Access to Escrow Outsource' [Access to Escrow Outsource], sg.DESCRIPTION_TX
		  from security_group sg
	   join USER_SECURITY_GROUP_RELATE usgr on usgr.sec_grp_id = sg.id
		join users u on u.id =usgr.user_id
		join dbo.SECURITY_CONTAINER sc ON U.ID = sc.USER_ID
		where sg.ID in (select * from #tmpSG) and U.EMAIL_TX is not null 
		       AND sc.ATTRIBUTE_1_IN = 'Y' and U.EMAIL_TX is not null
       AND U.ACTIVE_IN = 'Y'
       AND U.PURGE_DT IS NULL 
       AND sc.PURGE_DT IS NULL
union		
select DISTINCT  U.GIVEN_NAME_TX [First Name],
       U.FAMILY_NAME_TX [Last Name], 
       U.EMAIL_TX [Email] ,
       sf.DESCRIPTION_TX, sg.DESCRIPTION_TX
FROM   dbo.SECURITY_CONTAINER sc
       JOIN dbo.SECURITY_FUNCTION sf ON sf.ID = sc.SECURITY_FUNC_ID
       JOIN dbo.USERS U ON U.ID = sc.USER_ID
	   join USER_SECURITY_GROUP_RELATE usgr on u.id =usgr.user_id
	   join security_group sg on usgr.sec_grp_id = sg.id
WHERE  sf.ID = 64
       AND sc.ATTRIBUTE_1_IN = 'Y' and U.EMAIL_TX is not null
       AND U.ACTIVE_IN = 'Y'
       AND U.PURGE_DT IS NULL 
       AND sc.PURGE_DT IS NULL;
	   --64



	   
select DISTINCT  U.GIVEN_NAME_TX [First Name],
       U.FAMILY_NAME_TX [Last Name], 
       U.EMAIL_TX [Email] ,'Access to Escrow Outsource' [Access to Escrow Outsource]
	   --select *
		  from security_group sg
	   join USER_SECURITY_GROUP_RELATE usgr on usgr.sec_grp_id = sg.id
		join users u on u.id =usgr.user_id
		where sg.ID in (select * from #tmpSG) and U.EMAIL_TX is not null --and u.FAMILY_NAME_TX = 'rowe'
		and 

		select usgr.*
		  from security_group sg
	   join USER_SECURITY_GROUP_RELATE usgr on usgr.sec_grp_id = sg.id
		join users u on u.id =usgr.user_id
		where sg.ID in (select * from #tmpSG) and U.EMAIL_TX is not null and u.FAMILY_NAME_TX = 'rowe'