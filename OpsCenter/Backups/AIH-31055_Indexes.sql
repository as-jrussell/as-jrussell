/*
Missing Index Details from AIH-31055.sql - SQLSDEVAWRD03.aws.local.IQQ_LIVE (ELDREDGE_A\jrussell (75))
The Query Processor estimates that implementing the following index could improve the query cost by 13.3185%.
*/

/*
USE [IQQ_LIVE]



CREATE INDEX [IX_PRODUCT_TRAIT_PURGE_DT_CODE_CD] ON [IQQ_LIVE].[dbo].[PRODUCT_TRAIT] ([PURGE_DT],[CODE_CD]) INCLUDE ([PRODUCT_ID])
*/


/*
Missing Index Details from AIH-31055.sql - SQLSDEVAWRD03.aws.local.IQQ_LIVE (ELDREDGE_A\jrussell (75))
The Query Processor estimates that implementing the following index could improve the query cost by 96.1683%.
*/

/*

CREATE INDEX [IX_QUOTE_WORKSHEET_ORIGIN_SOURCE_CD_PURGE_DT_CREATE_DT] ON [IQQ_LIVE].[dbo].[QUOTE_WORKSHEET] ([ORIGIN_SOURCE_CD], [PURGE_DT],[CREATE_DT]) INCLUDE ([DESIGNATED_BRANCH_ID])
CREATE INDEX [IX_ORGANIZATION_RELATE_CLASS_NAME_TX_ACTIVE_IN_PURGE_DT] ON [IQQ_LIVE].[dbo].[ORGANIZATION] ([RELATE_CLASS_NAME_TX], [ACTIVE_IN], [PURGE_DT]) INCLUDE ([NAME_TX])
CREATE INDEX [IX_LENDER_PURGE_DT_DEMO_ACCOUNT_IN] ON [IQQ_LIVE].[dbo].[LENDER] ([PURGE_DT],[DEMO_ACCOUNT_IN]) INCLUDE ([LENDER_ID])
*/

/*
Missing Index Details from AIH-31055.sql - SQLSDEVAWRD03.aws.local.IQQ_LIVE (ELDREDGE_A\jrussell (115))
The Query Processor estimates that implementing the following index could improve the query cost by 87.7986%.
*/

/*
USE [IQQ_COMMON]
GO
CREATE NONCLUSTERED INDEX [IX_USERS_LAST_LOGIN_DT_ID]
ON [dbo].[USERS] ([LAST_LOGIN_DT])
INCLUDE ([ID])
GO

CREATE NONCLUSTERED INDEX [IX_USERS_ACTIVE_IN_ID]
ON [dbo].[USERS] ([ACTIVE_IN])
INCLUDE ([ID])
GO



*/


