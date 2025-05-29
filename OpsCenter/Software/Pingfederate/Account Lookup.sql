  select *
    FROM [Pingfederate].[dbo].[channel_user] u 
  join [Pingfederate].[dbo].[group_membership] m on m.userDsGuid = u.dsGuid
  join [Pingfederate].[dbo].[channel_group] g on g.dsGuid = m.groupDsGuid
  join [Pingfederate].[dbo].[channel_variable] v on U.channel = v.channel
  where
  saasusername like 'Noah%'



  
  select  *
    FROM  [Pingfederate].[dbo].[channel_group]
	where channel = 19
	and   saasGroupName like '%aws%billing%'
