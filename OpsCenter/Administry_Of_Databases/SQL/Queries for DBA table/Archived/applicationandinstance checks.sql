use InventoryDWH

--validating applications with a server
exec info.getcmsapplications @searchenv = 'nonProd'
exec info.getcmsapplications @searchenv = 'allprod'

	-- EXEC [Info].[getCMSApplications] @SearchAPP = 'UniTrac', @SearchENV = 'PROD'
	-- EXEC [Info].[getCMSApplications] @SearchHost = 'INFRDEVAWDB01'

--validating instances  
exec info.getcmsinstances @SearchENV = 'nonProd'
exec info.getcmsinstances @SearchENV = 'allprod'

	-- EXEC [Info].[getCMSInstances] @SearchHost = 'INFRDEVAWDB01'

	EXEC [Info].[SetCMSInstances] @DryRun = 0
	EXEC [Info].[SetCMSApplications] @DryRun = 0


