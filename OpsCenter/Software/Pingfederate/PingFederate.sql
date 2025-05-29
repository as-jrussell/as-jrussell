
/*
channel		value
3			CN=Domain Users,OU=Domain,OU=Allied Groups,DC=as,DC=local&[objectclass,user]
4			CN=Github - Users,OU=Application Access Groups,OU=Allied Groups,DC=as,DC=local&
5			CN=Snowflake Data Warehouse - User,OU=Application Access Groups,OU=Allied Groups,DC=as,DC=local&
7			CN=Jira - Administrators,OU=Application Access Groups,OU=Allied Groups,DC=as,DC=local&[objectclass,user]
8			CN=Jira - Users,OU=Application Access Groups,OU=Allied Groups,DC=as,DC=local&
10			CN=Snowflake Data Warehouse - User,OU=Application Access Groups,OU=Allied Groups,DC=as,DC=local&
16			CN=AWS Admin users,OU=AWS,OU=Application Access Groups,OU=Allied Groups,DC=as,DC=local&
17			CN=Domain Users,OU=Domain,OU=Allied Groups,DC=as,DC=local&[objectclass,user]



SELECT  [channel]
      ,[value]
  FROM [Pingfederate].[dbo].[channel_variable]
  where name = 'users_group_and_filter'
*/




DECLARE @username nvarchar(25) = ''
DECLARE  @channel nvarchar(10) = ''

  select G.saasGroup, G.saasGroupName, U.saasUsername,u.dsGuid, U.created, U.modified, U.channel, v.*
    FROM [Pingfederate].[dbo].[channel_user] u 
  join [Pingfederate].[dbo].[group_membership] m on m.userDsGuid = u.dsGuid
  join [Pingfederate].[dbo].[channel_group] g on g.dsGuid = m.groupDsGuid
  join [Pingfederate].[dbo].[channel_variable] v on U.channel = v.channel
  where v.name = 'users_group_and_filter'
  and saasUsername = @username
  and V.channel like '%'+ @channel +'%' 
  order by v.channel asc 
