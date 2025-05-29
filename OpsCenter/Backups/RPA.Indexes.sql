Use [RPA]

IF NOT EXISTS (SELECT 1 FROM sys.indexes where [name] = 'IX_Rpa_Vow_Result_Records_PulledDate_UpdateUT_INCLUDES')
BEGIN
       CREATE NONCLUSTERED INDEX [IX_Rpa_Vow_Result_Records_PulledDate_UpdateUT_INCLUDES] 
       ON [RPA].[dbo].[Rpa_Vow_Result_Records] ([PulledDate],UpdateUT,FoundComprehensiveValue,FoundCollisionValue)
       INCLUDE ([WorkFlow]) WITH (ONLINE = ON, SORT_IN_TEMPDB = ON)
	   
	   PRINT 'Successfully Created Index: IX_Rpa_Vow_Result_Records_PulledDate_UpdateUT_INCLUDES'
END;
ELSE
BEGIN
	PRINT 'WARNING: IX_Rpa_Vow_Result_Records_PulledDate_UpdateUT_INCLUDES already exist!'
END;

IF NOT EXISTS (SELECT 1 FROM sys.indexes where [name] = 'IX_Results_Mortgage_Vow_PulledDate_INCLUDES')
BEGIN
       CREATE NONCLUSTERED INDEX [IX_Results_Mortgage_Vow_PulledDate_INCLUDES] 
       ON [RPA].[dbo].[Results_Mortgage_Vow] (PulledDate)
       INCLUDE (WorkFlow,InboundID) WITH (ONLINE = ON, SORT_IN_TEMPDB = ON)

	   PRINT 'Successfully Created Index: IX_Results_Mortgage_Vow_PulledDate_INCLUDES'
END;
ELSE
BEGIN
	PRINT 'WARNING: IX_Results_Mortgage_Vow_PulledDate_INCLUDES already exist!'
END;

IF NOT EXISTS (SELECT 1 FROM sys.indexes where [name] = 'IX_Results_Mortgage_Lienholder_Updates_PulledDate_INCLUDES')
BEGIN
       CREATE NONCLUSTERED INDEX [IX_Results_Mortgage_Lienholder_Updates_PulledDate_INCLUDES] 
       ON [RPA].[dbo].[Results_Mortgage_Lienholder_Updates] (PulledDate)
       INCLUDE ([WorkFlow]) WITH (ONLINE = ON, SORT_IN_TEMPDB = ON)
	   
	   PRINT 'Successfully Created Index: IX_Results_Mortgage_Lienholder_Updates_PulledDate_INCLUDES'
END;
ELSE
BEGIN
	PRINT 'WARNING: IX_Results_Mortgage_Lienholder_Updates_PulledDate_INCLUDES already exist!'
END;

IF NOT EXISTS (SELECT 1 FROM sys.indexes where [name] = 'IX_Results_Vehicle_Lienholder_Updates_PulledDate_UpdateUT_INCLUDES')
BEGIN
       CREATE NONCLUSTERED INDEX [IX_Results_Vehicle_Lienholder_Updates_PulledDate_UpdateUT_INCLUDES] 
       ON [RPA].[dbo].[Results_Vehicle_Lienholder_Updates] (PulledDate, UpdateUT)
       INCLUDE (WorkFlow,InBoundID) WITH (ONLINE = ON, SORT_IN_TEMPDB = ON)
	   
	   PRINT 'Successfully Created Index: IX_Results_Vehicle_Lienholder_Updates_PulledDate_UpdateUT_INCLUDES'
END;
ELSE
BEGIN
	PRINT 'WARNING: IX_Results_Vehicle_Lienholder_Updates_PulledDate_UpdateUT_INCLUDES already exist!'
END;



/*
DROP INDEX  [IX_Rpa_Vow_Result_Records_PulledDate_UpdateUT_INCLUDES] ON [RPA].[dbo].[Rpa_Vow_Result_Records] 
DROP INDEX  [IX_Results_Mortgage_Vow_PulledDate_INCLUDES] ON [RPA].[dbo].[Results_Mortgage_Vow]
DROP INDEX  [IX_Results_Mortgage_Lienholder_Updates_PulledDate_INCLUDES] ON [RPA].[dbo].[Results_Mortgage_Lienholder_Updates]
DROP INDEX  [IX_Results_Vehicle_Lienholder_Updates_PulledDate_UpdateUT_INCLUDES] ON [RPA].[dbo].[Results_Vehicle_Lienholder_Updates]
*/

