use [SVSalesMgmt_Allied]

--Best improvement this index would be nice -Install time - 00:00:00.158

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'dbo.SVGoalProdXref') AND name = N'IX_SVGoalProdXref_INum_ProdNum_DeleteFlg')
BEGIN
CREATE NONCLUSTERED INDEX [IX_SVGoalProdXref_INum_ProdNum_DeleteFlg] ON [dbo].[SVGoalProdXref]
(
	[INum] ASC,
	[ProdNum] ASC,
	[DeleteFlg] ASC
)
INCLUDE([GoalNum]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
END


--Not necessarily improve the performance that much but the system would like to see it added -  00:06:48.702 
 
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'dbo.SVResultsHistory') AND name = N'IX_SVResultsHistory_GoalNum_OrgNum_GroupOrgNum')
BEGIN
CREATE NONCLUSTERED INDEX [IX_SVResultsHistory_GoalNum_OrgNum_GroupOrgNum] ON [dbo].[SVResultsHistory]
(
	[INum] ASC,
	[TimePeriod] ASC
)
INCLUDE([GoalNum],[OrgNum],[GroupOrgNum]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
END


