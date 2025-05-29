USE UniTrac


SELECT * FROM dbo.WORK_ITEM
WHERE ID IN (41433904 )


SELECT * FROM dbo.MESSAGE
WHERE ID IN (10180256)


SELECT * FROM dbo.TRADING_PARTNER_LOG
WHERE MESSAGE_ID = 10180256

Exception Transforming the Documents
Exception : DB Error(GetCollaterals): Execution Timeout Expired.  The timeout period elapsed prior to completion of the operation or the server is not responding.
Exception Stack Trace :    at Osprey.Database.SqlServerDBCommand.ExecuteImpl(String procedureName) in E:\Unitrac_QA_2.1\2 Lower Business Level\OspreyLib\Common\Database\SqlServerDBCommand.cs:line 100
   at Osprey.Database.DBCommand.Execute(String procedureName) in E:\Unitrac_QA_2.1\2 Lower Business Level\OspreyLib\Common\Database\DBCommand.cs:line 84
   at Allied.UniTrac.CollateralContract.GetList(Criteria crit) in E:\Unitrac_QA_2.1\3 Upper Business Level\UniTracLib\Contracts\CollateralContract.cs:line 117
   at Osprey.GetListRequest.Execute() in E:\Unitrac_QA_2.1\2 Lower Business Level\OspreyLib\Common\Contract\GetListRequest.cs:line 48
   at Osprey.RequestContract.Execute(RequestContract request) in E:\Unitrac_QA_2.1\2 Lower Business Level\OspreyLib\Common\Contract\RequestContract.cs:line 157
   at Osprey.BusinessObject.GetList[T](ContractObject contract, Criteria crit, CancellationToken token) in E:\Unitrac_QA_2.1\2 Lower Business Level\OspreyLib\Common\BusinessObject.cs:line 349
   at Allied.UniTrac.LenderExtract.MatchingHelper.Initialize(Int32 lekey, Boolean checkLine1Keywords, UInt64 transactionId) in E:\Unitrac_QA_2.1\3 Upper Business Level\UniTracLib\LenderExtract\MatchingHelper.cs:line 201
   at Allied.UniTrac.LenderExtract.TrackingChunkedPPD.Apply(BusinessObjectCollection boColl) in E:\Unitrac_QA_2.1\3 Upper Business Level\UniTracLib\LenderExtract\TrackingChunkedPPD.cs:line 140
   at LDHLib.Message.FinalizeTransformation() in E:\Unitrac_QA_2.1\3 Upper Business Level\LDH\LDHLib\Message\Message.cs:line 1254
   at LDHLib.Message.Transform() in E:\Unitrac_QA_2.1\3 Upper Business Level\LDH\LDHLib\Message\Message.cs:line 1215


   UPDATE M
   SET M.PROCESSED_IN = 'N', M.RECEIVED_STATUS_CD = 'RCVD', M.LOCK_ID = M.LOCK_ID+1
   --SELECT M.PROCESSED_IN, M.RECEIVED_STATUS_CD ,* 
   FROM  dbo.MESSAGE M 
   WHERE ID IN (10180256)
