USE [Unitrac_Reports]
GO

/****** Object:  Index [IDX_COLLATERAL_PROPERTY_ID_PURGE_DT]    Script Date: 4/4/2018 11:24:13 AM ******/
CREATE NONCLUSTERED INDEX [IDX_COLLATERAL_PROPERTY_ID_PURGE_DT] ON [dbo].[COLLATERAL]
(
	[PROPERTY_ID] ASC,
	[PURGE_DT] ASC
)
INCLUDE ( 	[LOAN_ID],
	[COLLATERAL_CODE_ID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO
