use UTL

--Stored Proc that would work for the LOAN table
--Added CREATE NONCLUSTERED INDEX [IDX_LOAN] ON [dbo].[LOAN] ([LENDER_ID],[PURGE_DT],[EVALUATION_DT]) INCLUDE ([ID],[CREATE_DT]) Dropped the sproc time to 1 second


--Offered in August 2021 did not use
--CREATE INDEX [IX_LOAN_MATCH_RELATE_STATUS_CD_PURGE_DT] ON [UTL].[dbo].[LOAN_MATCH_RELATE] ([STATUS_CD], [PURGE_DT]) INCLUDE ([LOAN_ID], [MATCH_RESULT_CD], [USER_MATCH_RESULT_CD])



---31 sec
--Added CREATE NONCLUSTERED INDEX [IDX_LOAN]  ON [dbo].[LOAN] ([PURGE_DT],[EVALUATION_DT]) INCLUDE ([ID],[LENDER_ID],[CREATE_DT]) Dropped the sproc time to 7 seconds
--Added CREATE NONCLUSTERED INDEX [IDX_LOAN] ON [dbo].[LOAN] ([LENDER_ID],[PURGE_DT],[EVALUATION_DT]) INCLUDE ([ID],[CREATE_DT]) Dropped the sproc time to 1 second


--Offered in August 2021 did not use
--CREATE INDEX [IX_LOAN_MATCH_RELATE_STATUS_CD_PURGE_DT] ON [UTL].[dbo].[LOAN_MATCH_RELATE] ([STATUS_CD], [PURGE_DT]) INCLUDE ([LOAN_ID], [MATCH_RESULT_CD], [USER_MATCH_RESULT_CD])

/*
5	UTL 2.0 Match
6	UTL 2.0 Match 2
7	UTL 2.0 Rematch: Repo Plus
8	UTL 2.0 Rematch: Mid-Size Lenders
9	UTL 2.0 Rematch: Default
10	UTL 2.0 Rematch: Adhoc
11	UTL 2.0 Rematch: Wells Fargo
12	UTL 2.0 Rematch: Santander

*/

--SELECT * FROM PROCESS_DEFINITION