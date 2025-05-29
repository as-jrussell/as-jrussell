/****** Object:  StoredProcedure [dbo].[Report_PendingMessageServer_TPLog]     ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Report_PendingMessageServer_TPLog]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Report_PendingMessageServer_TPLog]
GO

/****** Object:  StoredProcedure [dbo].[Report_PendingMessageServer_TPLog]    Script Date: 09/26/2016 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Report_PendingMessageServer_TPLog]
AS
BEGIN
	;With
	tmpLenders As
	(
	 SELECT
		LenderCode = P.TAB.value('.', 'nvarchar(max)')
		,ServiceName = SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/TargetServiceList/TargetService)[1]', 'nvarchar(max)')
		FROM PROCESS_DEFINITION pd 
		CROSS APPLY pd.SETTINGS_XML_IM.nodes('(/ProcessDefinitionSettings/LenderList/LenderID)') AS P (TAB)
		WHERE pd.PROCESS_TYPE_CD = 'MSGSRV' 
		AND pd.ACTIVE_IN = 'y'
	 UNION ALL
		Select
		 LenderCode=''
		,ServiceName='MSGSRVRAdhoc'
	 UNION ALL
		Select
		 LenderCode='BSSWeb'
		,ServiceName='MSGSRVRBSS'
	)
	SELECT TPL.UPDATE_USER_TX, max(TPl.CREATE_DT) as LastLoggedEvent
	FROM TRADING_PARTNER_LOG TPL (NOLOCK) 
	join TRADING_PARTNER TP on TP.ID = TPL.TRADING_PARTNER_ID
	WHERE  
	--TPL.UPDATE_USER_TX in ('MsgSrvrEXTUSD' , 'MsgSrvradhoc', 'MsgSrvrEXTHUNT', 'MsgSrvrEXTPENF' , 'MsgSrvrEXTSANT', 'MsgSrvrBSS' )
	TPL.UPDATE_USER_TX in (Select ServiceName From tmpLenders Group By ServiceName)
	AND TPL.PROCESS_CD = 'MS'
	GROUP BY  TPL.UPDATE_USER_TX
	order by TPL.UPDATE_USER_TX
END
