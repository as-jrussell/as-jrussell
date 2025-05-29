USE [Unitrac_Reports]
GO

/****** Object:  StoredProcedure [dbo].[Report_PendingMessageServerOutbound]    Script Date: 1/13/2017 8:08:20 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[Report_PendingMessageServerOutbound]
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
          SELECT
		   [Direction] = case when IsNull(MESSAGE_DIRECTION_CD,'O')='O' then 'OUTBOUND' else MESSAGE_DIRECTION_CD end
		  ,[Type] = case when TYPE_CD='LFP_TP' then 'LFP' when TYPE_CD='BSS_TP' then 'BSS' else TYPE_CD end
		  ,SN.ServiceName
		  ,[Received] = case when RECEIVED_STATUS_CD='RCVD' then 'Received' when RECEIVED_STATUS_CD='OBADHOC' then 'Adhoc' else RECEIVED_STATUS_CD end
		  ,[MSG_COUNT]=IsNull(MSG_COUNT,0)
		  ,Newest_Date
		  ,Oldest_Date
          FROM (Select ServiceName From tmpLenders Group By ServiceName) As SN
		  LEFT Join(
			  Select
		       MESSAGE_DIRECTION_CD
			  ,ServiceName
			  ,TYPE_CD
		      ,RECEIVED_STATUS_CD
			  ,MSG_COUNT = Count(EXTERNAL_ID_TX)
			  ,Oldest_Date = Min(M.UPDATE_DT)
			  ,Newest_Date = Max(M.UPDATE_DT)
			  --,TP.EXTERNAL_ID_TX, ServiceName=TP.NAME_TX, M.*
			  --,Related.VALUE_TX
			  --,Related.NAME_TX
			  FROM message M (NOLOCK)
			  JOIN      TRADING_PARTNER TP (NOLOCK) ON M.RECEIVED_FROM_TRADING_PARTNER_ID = TP.ID
			  CROSS Apply(
				Select TOP 1
				 ServiceName
				,LenderCode
				From tmpLenders tl
				Where tl.LenderCode = EXTERNAL_ID_TX
			  ) As TPSN
			  JOIN      DELIVERY_INFO DI           ON M.DELIVERY_INFO_ID = DI.id
			  OUTER Apply(
				select distinct RDD.NAME_TX, VALUE_TX from RELATED_DATA RD Join RELATED_DATA_DEF RDD On RDD.id = RD.DEF_ID
				where DI.id = RD.RELATE_ID
				AND TYPE_CD!='BSS_TP'
			  ) As Related
			  LEFT JOIN WORK_ITEM WI ON WI.RELATE_ID = M.ID AND WI.WORKFLOW_DEFINITION_ID = 1
			  WHERE PROCESSED_IN = 'N'
			  AND 1 = case when TYPE_CD='LFP_TP' and RECEIVED_STATUS_CD in ('RCVD','OBADHOC') then 1 when TYPE_CD='BSS_TP'AND RECEIVED_STATUS_CD NOT IN ('PRSD','ADHOC','HOLD') then 1 else 0 end
			  AND MESSAGE_DIRECTION_CD = 'O'
			  and TYPE_CD in ('LFP_TP','BSS_TP')
			  AND 1 = case when TYPE_CD='LFP_TP' and (Related.NAME_TX!='UniTracDeliveryType' OR Related.NAME_TX is null) then 0 else 1 end
			  and 1 = case when TYPE_CD='LFP_TP' and (DELIVER_TO_TRADING_PARTNER_ID!='2046' OR DELIVER_TO_TRADING_PARTNER_ID is null) then 0 else 1 end
			  AND 1 = case when TYPE_CD='LFP_TP' and (VALUE_TX!='IMPORT' OR VALUE_TX is null) then 0 else 1 end
			  AND M.PURGE_DT IS null
			  GROUP BY
			   ServiceName
			  ,TYPE_CD
		      ,MESSAGE_DIRECTION_CD
		      ,RECEIVED_STATUS_CD
		  ) As TPM On (TPM.ServiceName=SN.ServiceName OR (SN.ServiceName Like '%Adhoc' AND RECEIVED_STATUS_CD='OBADHOC'))
		CROSS Apply(
		Select
			[Order] =
			Case
			When SN.ServiceName Like '%USD' Then 1 
			When SN.ServiceName Like '%Adhoc' Then 3
			When SN.ServiceName Like '%PenF' Then 5
			When SN.ServiceName Like '%Hunt' Then 7
			When SN.ServiceName Like '%Info' Then 9
			When SN.ServiceName Like '%Sant' Then 11
			When SN.ServiceName Like '%BSS' Then 13
			Else 99
			End
		) As Custom
		  ORDER BY
		   Custom.[Order]
		  ,SN.ServiceName
		  ,TYPE_CD
		  ,RECEIVED_STATUS_CD
END


GO

