/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [UserName], [RoleName]
      ,[Description]
  FROM [ReportServer].[dbo].[Users] U
 join [ReportServer].[dbo].[PolicyUserRole]  PUP on U.[UserID] = PUP.[UserID]
 join [ReportServer].[dbo].[Roles] R on PUP.[RoleID] = R.[RoleID]





