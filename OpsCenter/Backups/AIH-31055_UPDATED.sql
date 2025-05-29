USE [IQQ_LIVE]

GO

/****** Object:  StoredProcedure [dbo].[LenderInfo]    Script Date: 2/23/2024 2:02:02 PM ******/
SET ANSI_NULLS ON

GO

SET QUOTED_IDENTIFIER ON

GO

IF NOT EXISTS (SELECT *
               FROM   sys.objects
               WHERE  object_id = Object_id(N'[dbo].[GetLenderInfo]')
                      AND type IN ( N'P', N'PC' ))
  BEGIN
      /* Create Empty Stored Procedure */
      EXEC dbo.Sp_executesql
        @statement = N'CREATE PROCEDURE [dbo].[GetLenderInfo] AS RETURN 0;';
  END;

GO

/* Alter Stored Procedure */
---EXEC [dbo].[GetLenderInfo] @Lender_List ='3Rivers'
ALTER PROCEDURE [dbo].[Getlenderinfo] (@LENDER_LIST NVARCHAR(100)='')
AS
  BEGIN

     SELECT Replace(O.NAME_TX, ',', ' ') AS NAME_TX,
             L.LENDER_ID,
             L.CREATE_DT,
             L.ALLIED_SALES_REGION_CD,
             L.ENABLE_CARFAX_IN,
             L.ENROLL_NADA_IN,
             L.ENABLE_DOCUSIGN_USE_LIVE_IN,
             L.ENABLE_CARFAX_ACH_IN,
             L.ALLOW_ENABLE_INTERACTIVE_SELLING_IN,
             L.ENABLE_MONRONEY_LABELS_IN,
             L.ENABLE_MASS_IMPORT_IN,
             L.SSO_ENABLED_IN,
             L.ENABLE_LIVE_SUPPORT_IN,
             L.PURGE_DT,
             O.ACTIVE_IN,
             A.CITY_TX,
             AGENCY.NAME_TX               AS [AGENCY_NAME_TX],
             OPR.ID                       AS [OPR_ID],
             CW.ORGANIZATION_ID,
             CW.ACTIVE_IN                 AS [CW_ACTIVE_IN],
             CW.ENABLED_IN,
             A.STATE_PROV_TX,
             VO.NAME_TX                   AS [VO_NAME_TX],
             VO.GUID,
             VO.PURGE_DT                  AS [VO_PURGE_DT]
      INTO   #LENDER_INFO
      FROM   LENDER L
             JOIN ORGANIZATION O
               ON O.ID = L.LENDER_ID
                  AND O.PURGE_DT IS NULL
             LEFT JOIN ORGANIZATION AGENCY
                    ON AGENCY.ID = O.PARENT_ID
                       AND AGENCY.PURGE_DT IS NULL
             LEFT JOIN CONSUMER_WEBSITE CW
                    ON CW.ORGANIZATION_ID = O.ID
                       AND CW.PURGE_DT IS NULL
             JOIN ADDRESS_ORGANIZATION_RELATE AOR
               ON AOR.ORGANIZATION_ID = O.ID
                  AND AOR.ADDRESS_TYPE_CD = 'OADDR'
             JOIN [ADDRESS] A
               ON A.ID = AOR.ADDRESS_ID
                  AND A.PURGE_DT IS NULL
             LEFT JOIN VENDOR_OFFERING VO
                    ON L.VENDOR_OFFERING_GUID = VO.GUID
                       AND VO.PURGE_DT IS NULL
             LEFT OUTER JOIN ORGANIZATION_PRODUCT_RELATE OPR
                          ON OPR.ORGANIZATION_ID = L.LENDER_ID
      WHERE  L.PURGE_DT IS NULL
             AND O.ACTIVE_IN = 'Y'
             AND O.NAME_TX IN ( @LENDER_LIST )

      SELECT DISTINCT 'Yes' AS TRAINING_API_IN,
                      O.ID
      INTO   #TRAINING_SUB
      FROM   [iqq_training].[dbo].QUOTE_WORKSHEET QW
             JOIN [iqq_training].[dbo].ORGANIZATION OB
               ON QW.DESIGNATED_BRANCH_ID = OB.ID
                  AND OB.PURGE_DT IS NULL
             JOIN [iqq_training].[dbo].ORGANIZATION O
               ON OB.PARENT_ID = O.ID
                  AND O.PURGE_DT IS NULL
      WHERE  QW.ORIGIN_SOURCE_CD = 'API'
             AND QW.PURGE_DT IS NULL
             AND QW.CREATE_DT >= Dateadd(year, -1, Getutcdate())
             AND O.NAME_TX IN ( @LENDER_LIST )

      SELECT DISTINCT 'Yes' AS LIVE_API_IN,
                      O.ID
      INTO   #LIVE_SUB
      FROM   [iqq_live].[dbo].QUOTE_WORKSHEET QW
             JOIN [iqq_live].[dbo].ORGANIZATION OB
               ON QW.DESIGNATED_BRANCH_ID = OB.ID
                  AND OB.PURGE_DT IS NULL
             JOIN [iqq_live].[dbo].ORGANIZATION O
               ON OB.PARENT_ID = O.ID
                  AND O.PURGE_DT IS NULL
      WHERE  QW.ORIGIN_SOURCE_CD = 'API'
             AND QW.PURGE_DT IS NULL
             AND QW.CREATE_DT >= Dateadd(year, -1, Getutcdate())
             AND O.NAME_TX IN ( @LENDER_LIST )

      SELECT DISTINCT TOP 4 'Yes'                      AS GAP_IN,
                            O.ID,
                            PROVIDER.ORGANIZATION_NAME AS ProviderName,
                            CASE
                              WHEN QO.PRODUCT_ID IS NOT NULL THEN 'Yes'
                            END                        AS QuoteOnly,
                            P.REMIT_PMT_METHOD_CD      AS GAPACH,
                            P.EFFECTIVE_DATE_LIVE_DT   AS GAPLatestProductDate,
                            O.ID                       AS GAPPRODID
      INTO   #GAP
      FROM   PRODUCT P
             JOIN ORGANIZATION_PRODUCT_RELATE OPR
               ON P.PRODUCT_GUID = OPR.PRODUCT_GUID
                  AND OPR.PURGE_DT IS NULL
             JOIN ORGANIZATION O
               ON OPR.ORGANIZATION_ID = O.ID
                  AND O.PURGE_DT IS NULL
             CROSS APPLY Fnascendproducthierarchy(P.ID, 'A', 1, NULL, 'Allied.iQQ.CoreBO.Provider') PROVIDER
             LEFT OUTER JOIN (SELECT PT.PRODUCT_ID
                              FROM   PRODUCT_TRAIT PT
                                     LEFT OUTER JOIN (SELECT PT.PRODUCT_ID
                                                      FROM   PRODUCT_TRAIT PT
                                                      WHERE  PT.PURGE_DT IS NULL
                                                             AND CODE_CD IN ( 'QUOTE_SELL', 'QUOTE_SELL_FULF', 'QUOTE_SELL_FULF_REMIT' )) Q
                                                  ON PT.PRODUCT_ID = Q.PRODUCT_ID
                              WHERE  PT.PURGE_DT IS NULL
                                     AND PT.CODE_CD LIKE 'QUOTE_ONLY'
                                     AND Q.PRODUCT_ID IS NULL) QO
                          ON P.ID = QO.PRODUCT_ID
      WHERE  P.PURGE_DT IS NULL
             AND P.TYPE_CD = 'GAP'
             AND P.ACTIVE_IN = 'Y'
             AND O.NAME_TX IN ( @LENDER_LIST )

      SELECT DISTINCT 'Yes'                      AS MBP_IN,
                      O.ID,
                      PROVIDER.ORGANIZATION_NAME AS ProviderName,
                      P.REMIT_PMT_METHOD_CD      AS MBPACH,
                      P.EFFECTIVE_DATE_LIVE_DT   AS MBPLatestProductDate,
                      O.ID                       AS MBPPRODID
      INTO   #MBP
      FROM   PRODUCT P
             JOIN ORGANIZATION_PRODUCT_RELATE OPR
               ON P.PRODUCT_GUID = OPR.PRODUCT_GUID
                  AND OPR.PURGE_DT IS NULL
             JOIN ORGANIZATION O
               ON OPR.ORGANIZATION_ID = O.ID
                  AND O.PURGE_DT IS NULL
             CROSS APPLY Fnascendproducthierarchy(P.ID, 'A', 1, NULL, 'Allied.iQQ.CoreBO.Provider') PROVIDER
      WHERE  P.PURGE_DT IS NULL
             AND P.TYPE_CD = 'MBP'
             AND P.ACTIVE_IN = 'Y'
             AND O.NAME_TX IN ( @LENDER_LIST )

      SELECT DISTINCT 'Yes'                      AS DPW_IN,
                      O.ID,
                      PROVIDER.ORGANIZATION_NAME AS ProviderName,
                      P.REMIT_PMT_METHOD_CD      AS DPWACH,
                      P.EFFECTIVE_DATE_LIVE_DT   AS DPWLatestProductDate,
                      O.ID                       AS DPWPRODID
      INTO   #DPW
      FROM   PRODUCT P
             JOIN ORGANIZATION_PRODUCT_RELATE OPR
               ON P.PRODUCT_GUID = OPR.PRODUCT_GUID
                  AND OPR.PURGE_DT IS NULL
             JOIN ORGANIZATION O
               ON OPR.ORGANIZATION_ID = O.ID
                  AND O.PURGE_DT IS NULL
             CROSS APPLY Fnascendproducthierarchy(P.ID, 'A', 1, NULL, 'Allied.iQQ.CoreBO.Provider') PROVIDER
      WHERE  P.PURGE_DT IS NULL
             AND P.TYPE_CD = 'DPW'
             AND P.ACTIVE_IN = 'Y'
             AND O.NAME_TX IN ( @LENDER_LIST )

      SELECT DISTINCT 'Yes'                      AS VPP_IN,
                      O.ID,
                      PROVIDER.ORGANIZATION_NAME AS ProviderName,
                      P.REMIT_PMT_METHOD_CD      AS VPPACH,
                      P.EFFECTIVE_DATE_LIVE_DT   AS VPPLatestProductDate,
                      O.ID                       AS VPPPRODID
      INTO   #VPP
      FROM   PRODUCT P
             JOIN ORGANIZATION_PRODUCT_RELATE OPR
               ON P.PRODUCT_GUID = OPR.PRODUCT_GUID
                  AND OPR.PURGE_DT IS NULL
             JOIN ORGANIZATION O
               ON OPR.ORGANIZATION_ID = O.ID
                  AND O.PURGE_DT IS NULL
             CROSS APPLY Fnascendproducthierarchy(P.ID, 'A', 1, NULL, 'Allied.iQQ.CoreBO.Provider') PROVIDER
      WHERE  P.PURGE_DT IS NULL
             AND P.TYPE_CD = 'VPP'
             AND P.ACTIVE_IN = 'Y'
             AND O.NAME_TX IN ( @LENDER_LIST )

      SELECT DISTINCT 'Yes'                      AS API_IN,
                      O.ID,
                      PROVIDER.ORGANIZATION_NAME AS ProviderName
      INTO   #API
      FROM   PRODUCT P
             JOIN ORGANIZATION_PRODUCT_RELATE OPR
               ON P.PRODUCT_GUID = OPR.PRODUCT_GUID
                  AND OPR.PURGE_DT IS NULL
             JOIN ORGANIZATION O
               ON OPR.ORGANIZATION_ID = O.ID
                  AND O.PURGE_DT IS NULL
             CROSS APPLY Fnascendproducthierarchy(P.ID, 'A', 1, NULL, 'Allied.iQQ.CoreBO.Provider') PROVIDER
      WHERE  P.PURGE_DT IS NULL
             AND P.API_ENABLED_IN = 'Y'
             AND P.ACTIVE_IN = 'Y'
             AND O.NAME_TX IN ( @LENDER_LIST )

      SELECT DISTINCT 'Yes'                      AS CI_IN,
                      O.ID,
                      PROVIDER.ORGANIZATION_NAME AS ProviderName,
                      P.EFFECTIVE_DATE_LIVE_DT   AS CILatestProductDate,
                      O.ID                       AS CIPRODID
      INTO   #CI
      FROM   PRODUCT P
             JOIN ORGANIZATION_PRODUCT_RELATE OPR
               ON P.PRODUCT_GUID = OPR.PRODUCT_GUID
                  AND OPR.PURGE_DT IS NULL
             JOIN ORGANIZATION O
               ON OPR.ORGANIZATION_ID = O.ID
                  AND O.PURGE_DT IS NULL
             CROSS APPLY Fnascendproducthierarchy(P.ID, 'A', 1, NULL, 'Allied.iQQ.CoreBO.Provider') PROVIDER
      WHERE  P.PURGE_DT IS NULL
             AND P.TYPE_CD = 'CI'
             AND P.ACTIVE_IN = 'Y'
             AND O.NAME_TX IN ( @LENDER_LIST )

      SELECT DISTINCT 'Yes'                      AS DP_IN,
                      O.ID,
                      PROVIDER.ORGANIZATION_NAME AS ProviderName,
                      P.EFFECTIVE_DATE_LIVE_DT   AS DPLatestProductDate,
                      O.ID                       AS DPPRODID
      INTO   #DP
      FROM   PRODUCT P
             JOIN ORGANIZATION_PRODUCT_RELATE OPR
               ON P.PRODUCT_GUID = OPR.PRODUCT_GUID
                  AND OPR.PURGE_DT IS NULL
             JOIN ORGANIZATION O
               ON OPR.ORGANIZATION_ID = O.ID
                  AND O.PURGE_DT IS NULL
             CROSS APPLY Fnascendproducthierarchy(P.ID, 'A', 1, NULL, 'Allied.iQQ.CoreBO.Provider') PROVIDER
      WHERE  P.PURGE_DT IS NULL
             AND P.TYPE_CD = 'DP'
             AND P.ACTIVE_IN = 'Y'

      SELECT DISTINCT 'Yes'                      AS JLP_IN,
                      O.ID,
                      PROVIDER.ORGANIZATION_NAME AS ProviderName
      INTO   #JLP
      FROM   PRODUCT P
             JOIN ORGANIZATION_PRODUCT_RELATE OPR
               ON P.PRODUCT_GUID = OPR.PRODUCT_GUID
                  AND OPR.PURGE_DT IS NULL
             JOIN ORGANIZATION O
               ON OPR.ORGANIZATION_ID = O.ID
                  AND O.PURGE_DT IS NULL
             CROSS APPLY Fnascendproducthierarchy(P.ID, 'A', 1, NULL, 'Allied.iQQ.CoreBO.Provider') PROVIDER
      WHERE  P.PURGE_DT IS NULL
             AND P.TYPE_CD = 'JLP'
             AND P.ACTIVE_IN = 'Y'
             AND O.NAME_TX IN ( @LENDER_LIST )

      SELECT DISTINCT 'Yes' AS ADR_IN,
                      O.ID,
                      CASE
                        WHEN AB.BUNDLE_CODE_CD = 'Both'
                              OR AB.BUNDLE_CODE_CD = 'MBP' THEN CONVERT(VARCHAR(3), AP.BENEFIT_FREQUENCY_PER_YEAR_NO)
                                                                + ' years'
                      END   AS MBPADR,
                      CASE
                        WHEN AB.BUNDLE_CODE_CD = 'Both'
                              OR AB.BUNDLE_CODE_CD = 'GAP' THEN CONVERT(VARCHAR(3), AP.BENEFIT_FREQUENCY_PER_YEAR_NO)
                                                                + ' years'
                      END   AS GAPADR,
                      CASE
                        WHEN AB.BUNDLE_CODE_CD = 'Both'
                              OR AB.BUNDLE_CODE_CD = 'DPW' THEN CONVERT(VARCHAR(3), AP.BENEFIT_FREQUENCY_PER_YEAR_NO)
                                                                + ' years'
                      END   AS DPWADR,
                      CASE
                        WHEN AB.BUNDLE_CODE_CD = 'Both'
                              OR AB.BUNDLE_CODE_CD = 'VPP' THEN CONVERT(VARCHAR(3), AP.BENEFIT_FREQUENCY_PER_YEAR_NO)
                                                                + ' years'
                      END   AS VPPADR,
                      CASE
                        WHEN Count(AVDR_BENEFIT.PRODUCT_ID) > 0
                             AND Count(STANDARD_BENEFIT.PRODUCT_ID) > 0 THEN 'ADR AV'
                        WHEN Count(AVDR_BENEFIT.PRODUCT_ID) > 0 THEN 'AVDR'
                        ELSE 'ST'
                      END   AS ADR_TYPE
      INTO   #ADR
      FROM   PRODUCT P
             JOIN ORGANIZATION_PRODUCT_RELATE OPR
               ON P.PRODUCT_GUID = OPR.PRODUCT_GUID
                  AND OPR.PURGE_DT IS NULL
             JOIN ORGANIZATION O
               ON OPR.ORGANIZATION_ID = O.ID
                  AND O.PURGE_DT IS NULL
             JOIN ADR_PRODUCT AP
               ON P.ID = AP.PRODUCT_ID
                  AND AP.PURGE_DT IS NULL
             JOIN ADR_BENEFIT AB
               ON P.ID = AB.PRODUCT_ID
                  AND AB.PURGE_DT IS NULL
             LEFT JOIN(SELECT DISTINCT AB.PRODUCT_ID
                       FROM   ADR_BENEFIT AB
                              JOIN ADR_PRODUCT AP
                                ON AB.PRODUCT_ID = AB.PRODUCT_ID
                                   AND AP.PURGE_DT IS NULL
                       WHERE  AB.PURGE_DT IS NULL
                              AND AB.AVDR_IN = 'Y') AVDR_BENEFIT
                    ON P.ID = AVDR_BENEFIT.PRODUCT_ID
             LEFT JOIN(SELECT DISTINCT AB.PRODUCT_ID
                       FROM   ADR_BENEFIT AB
                              JOIN ADR_PRODUCT AP
                                ON AB.PRODUCT_ID = AB.PRODUCT_ID
                                   AND AP.PURGE_DT IS NULL
                       WHERE  AB.PURGE_DT IS NULL
                              AND AB.AVDR_IN = 'N') STANDARD_BENEFIT
                    ON P.ID = STANDARD_BENEFIT.PRODUCT_ID
      WHERE  P.PURGE_DT IS NULL
             AND P.TYPE_CD = 'ADR'
             AND P.ACTIVE_IN = 'Y'
             AND O.NAME_TX IN ( @LENDER_LIST )
      GROUP  BY AP.AUTO_AND_RV_PRODUCT_CARD_OPTION_IN,
                O.ID,
                AB.BUNDLE_CODE_CD,
                AP.BENEFIT_FREQUENCY_PER_YEAR_NO

      SELECT DISTINCT CASE
                        WHEN CWT.ENABLED_IN = 'Y'
                             AND CWL.ENABLED_IN = 'Y' THEN 4
                        WHEN CWT.ENABLED_IN = 'Y'
                             AND ( CWL.ENABLED_IN != 'Y'
                                    OR CWL.ENABLED_IN IS NULL ) THEN 3
                        WHEN ( CWT.ENABLED_IN != 'Y'
                                OR CWT.ENABLED_IN IS NULL )
                             AND CWL.ENABLED_IN = 'Y' THEN 2
                        ELSE 1
                      END AS CONWEB_IN,
                      O.ID
      INTO   #CONWEB
      FROM   ORGANIZATION O
             LEFT JOIN IQQ_LIVE.dbo.CONSUMER_WEBSITE CWL
                    ON CWL.ORGANIZATION_ID = O.ID
                       AND CWL.PURGE_DT IS NULL
             LEFT JOIN IQQ_TRAINING.dbo.CONSUMER_WEBSITE CWT
                    ON CWT.ORGANIZATION_ID = O.ID
                       AND CWT.PURGE_DT IS NULL
      WHERE  O.PURGE_DT IS NULL
             AND O.NAME_TX IN ( @LENDER_LIST )

      SELECT DISTINCT U.ID,
                      U.ACTIVE_IN,
                      U.LAST_LOGIN_DT,
                      O.PARENT_ID
      INTO   #USERS1
      FROM   USERS U
             JOIN ORGANIZATION_USER_RELATE OUR
               ON OUR.[USER_ID] = U.ID
                  AND OUR.RELATE_TYPE_CD = 'P'
                  AND OUR.PURGE_DT IS NULL
             JOIN ORGANIZATION O
               ON O.[GUID] = OUR.ORGANIZATION_GUID
                  AND O.PURGE_DT IS NULL
      WHERE  U.PURGE_DT IS NULL
             AND O.NAME_TX IN ( @LENDER_LIST )

      SELECT LO.ID,
             LO.NAME_TX,
             LO.PURGE_DT
      INTO   #LIVEO
      FROM   #LENDER_INFO LI
             JOIN [iqq_live].[dbo].[ORGANIZATION] LO
               ON LI.NAME_TX = LO.NAME_TX
                  AND LO.PURGE_DT IS NULL
      WHERE  LO.NAME_TX IN ( @LENDER_LIST )
             AND LO.NAME_TX IN ( @LENDER_LIST )

      SELECT LO.ID,
             LO.NAME_TX,
             LO.PURGE_DT
      INTO   #TRAINO
      FROM   #LENDER_INFO LI
             JOIN [iqq_training].[dbo].[ORGANIZATION] LO
               ON LI.NAME_TX = LO.NAME_TX
                  AND LO.PURGE_DT IS NULL
      WHERE  LO.NAME_TX IN ( @LENDER_LIST )

      SELECT U_Active.ID
      INTO   #U_Active
      FROM   #USERS1
             LEFT JOIN USERS U_Active
                    ON U_Active.ID = #USERS1.ID
                       AND U_Active.ACTIVE_IN = 'Y'

      SELECT U_All_Time.ID
      INTO   #U_All_Time
      FROM   #USERS1
             LEFT JOIN USERS U_All_Time
                    ON U_All_Time.ID = #USERS1.ID
                       AND U_All_Time.LAST_LOGIN_DT IS NOT NULL

      SELECT U_Signed_In_This_Month.ID
      INTO   #U_Signed_In_This_Month
      FROM   #USERS1
             LEFT JOIN USERS U_Signed_In_This_Month
                    ON U_Signed_In_This_Month.ID = #USERS1.ID
                       AND U_Signed_In_This_Month.LAST_LOGIN_DT >= Dateadd(month, -1, Getutcdate());

      SELECT DISTINCT LI.NAME_TX,
                      LI.LENDER_ID,
                      CONVERT(DATETIME2, Switchoffset(CONVERT(DATETIMEOFFSET, LI.CREATE_DT), (SELECT Datename(tz, Sysdatetimeoffset())))) CREATE_DT,
                      LI.CITY_TX,
                      LI.STATE_PROV_TX,
                      LI.ALLIED_SALES_REGION_CD,
                      CASE
                        WHEN LI.[AGENCY_NAME_TX] = 'Allied Solutions LLC' THEN 'Allied'
                        WHEN LI.[AGENCY_NAME_TX] = 'GSG' THEN 'GSG'
                        ELSE 'Unknown'
                      END                                                                                                                 AS 'Broker',
                      CASE
                        WHEN Max(#GAP.GAP_IN) IS NULL
                             AND Max(#MBP.MBP_IN) IS NULL
                             AND Max(#DPW.DPW_IN) IS NULL
                             AND Max(#VPP.VPP_IN) IS NULL THEN 'Yes'
                        ELSE ''
                      END                                                                                                                 AS 'Has None',
                      Max(#GAP.GAP_IN)                                                                                                    AS 'HasGAP',
                      Max(#GAP.ProviderName)                                                                                              AS GAPProvider,
                      Max(#GAP.QuoteOnly)                                                                                                 AS QuoteOnly,
                      Max(#MBP.MBP_IN)                                                                                                    AS HasMBP,
                      Max(#MBP.ProviderName)                                                                                              AS MBPProvider,
                      Max(#DPW.DPW_IN)                                                                                                    AS HasDPW,
                      Max(#DPW.ProviderName)                                                                                              AS DPWProvider,
                      Max(#VPP.VPP_IN)                                                                                                    AS HasVPP,
                      Max(#VPP.ProviderName)                                                                                              AS VPPProvider,
                      CASE
                        WHEN Max(#TRAINING_SUB.TRAINING_API_IN) IS NOT NULL
                             AND Max(#LIVE_SUB.LIVE_API_IN) IS NOT NULL THEN 'Yes (L T)'
                        WHEN Max(#LIVE_SUB.LIVE_API_IN) IS NOT NULL THEN 'Yes (L)'
                        WHEN Max(#TRAINING_SUB.TRAINING_API_IN) IS NOT NULL THEN 'Yes (T)'
                        WHEN Max(LI.VO_NAME_TX) IS NULL THEN 'No'
                      END                                                                                                                 AS HasAPI,
                      Max(LI.[VO_NAME_TX])                                                                                                AS LosAPI,
                      Max(#CI.CI_IN)                                                                                                      AS HasCLCD,
                      Max(#CI.ProviderName)                                                                                               AS CLCDProvider,
                      Max(#DP.DP_IN)                                                                                                      AS HasDP,
                      Max(#DP.ProviderName)                                                                                               AS DPProvider,
                      CASE
                        WHEN LI.ENABLE_LIVE_SUPPORT_IN = 'N' THEN 'No'
                        ELSE ''
                      END                                                                                                                 AS LIVE_CHAT,
                      CASE
                        WHEN LI.ALLOW_ENABLE_INTERACTIVE_SELLING_IN = 'Y' THEN 'Enabled'
                        ELSE ''
                      END                                                                                                                 AS INTERACTIVE_SELLING_IN,
                      CASE
                        WHEN LI.ENABLE_DOCUSIGN_USE_LIVE_IN = 'Y' THEN 'Enabled'
                        ELSE 'Disabled'
                      END                                                                                                                 AS DocuSign,
                      CASE
                        WHEN LI.ENABLE_CARFAX_IN = 'Y' THEN 'Enabled'
                        ELSE 'Disabled'
                      END                                                                                                                 AS CarFax,
                      CASE
                        WHEN LI.ENABLE_MONRONEY_LABELS_IN = 'Y' THEN 'Enabled'
                        ELSE ''
                      END                                                                                                                 AS MONRONEY_LABELS_IN,
                      CASE
                        WHEN LI.ENABLE_MASS_IMPORT_IN = 'Y' THEN 'Enabled'
                        ELSE ''
                      END                                                                                                                 AS MASS_IMPORT_IN,
                      Max(#ADR.ADR_TYPE)                                                                                                  AS GeneralADR,
                      Max(#ADR.MBPADR)                                                                                                    AS MBPADR,
                      Max(#ADR.GAPADR)                                                                                                    AS GAPADR,
                      Max(#ADR.DPWADR)                                                                                                    AS DPWADR,
                      Max(#ADR.VPPADR)                                                                                                    AS VPPADR,
                      Max(#JLP.JLP_IN)                                                                                                    AS HasJLP,
                      CASE
                        WHEN LI.[CW_ACTIVE_IN] = 'Y'
                             AND LI.ENABLED_IN = 'Y' THEN 'Enabled'
                        ELSE ''
                      END                                                                                                                 AS ConsumerWebsite,
                      CASE
                        WHEN LI.ENROLL_NADA_IN = 'Y' THEN 'Enrolled'
                        ELSE 'Not Enrolled'
                      END                                                                                                                 AS NADA,
                      Max(#GAP.GAPACH)                                                                                                    AS GAPACH,
                      Max(#MBP.MBPACH)                                                                                                    AS MBPACH,
                      Max(#DPW.DPWACH)                                                                                                    AS DPWACH,
                      Max(#VPP.VPPACH)                                                                                                    AS VPPACH,
                      CASE
                        WHEN LI.ENABLE_CARFAX_ACH_IN = 'Y' THEN 'Yes'
                        ELSE 'No'
                      END                                                                                                                 AS CarFaxACH,
                      CASE
                        WHEN LI.SSO_ENABLED_IN = 'Y' THEN 'Yes'
                        ELSE ''
                      END                                                                                                                 AS IDP_IN,
                      CONVERT(VARCHAR(20), Count(DISTINCT(#U_Active.ID)))
                      + ' of '
                      + CONVERT(VARCHAR(20), Count(DISTINCT(#USERS1.ID)))                                                                 AS ActiveUsers,
                      CONVERT(VARCHAR(20), Count(DISTINCT(#U_All_Time.ID)))
                      + ' of '
                      + CONVERT(VARCHAR(20), Count(DISTINCT(#USERS1.ID)))                                                                 AS SignedInAllTime,
                      CONVERT(VARCHAR(20), Count(DISTINCT(#U_Signed_In_This_Month.ID )))
                      + ' of '
                      + CONVERT(VARCHAR(20), Count(DISTINCT(#USERS1.ID)))                                                                 AS SignedInLastMonth,
                      GAPLatestProductDate,
                      MBPLatestProductDate,
                      DPWLatestProductDate,
                      VPPLatestProductDate,
                      CILatestProductDate,
                      DPLatestProductDate
      INTO   #LDR_INFO
      --SELECT *
      FROM   #LENDER_INFO LI
             JOIN #TRAINO
               ON LI.NAME_TX = #TRAINO.NAME_TX
                  AND #TRAINO.PURGE_DT IS NULL
             LEFT JOIN #TRAINING_SUB
                    ON #TRAINING_SUB.ID = #TRAINO.ID
             LEFT JOIN #LIVE_SUB
                    ON #LIVE_SUB.ID = LI.LENDER_ID
             LEFT JOIN #GAP
                    ON #GAP.ID = LI.LENDER_ID
             LEFT JOIN #MBP
                    ON #MBP.ID = LI.LENDER_ID
             LEFT JOIN #DPW
                    ON #DPW.ID = LI.LENDER_ID
             LEFT JOIN #VPP
                    ON #VPP.ID = LI.LENDER_ID
             LEFT JOIN #CI
                    ON #CI.ID = LI.LENDER_ID
             LEFT JOIN #DP
                    ON #DP.ID = LI.LENDER_ID
             LEFT JOIN #JLP
                    ON #JLP.ID = LI.LENDER_ID
             LEFT JOIN #ADR
                    ON #ADR.ID = LI.LENDER_ID
             LEFT JOIN #USERS1
                    ON #USERS1.PARENT_ID = LI.LENDER_ID
             LEFT JOIN #U_Active
                    ON #U_Active.ID = #USERS1.ID
             LEFT JOIN #U_All_Time
                    ON #U_All_Time.ID = #USERS1.ID
             LEFT JOIN #U_Signed_In_This_Month
                    ON #U_Signed_In_This_Month.ID = #USERS1.ID
      WHERE  LI.PURGE_DT IS NULL
             AND LI.ACTIVE_IN = 'Y'
             AND LI.NAME_TX IN ( @LENDER_LIST )
       GROUP  BY LI.NAME_TX,
                LI.LENDER_ID,
                LI.[AGENCY_NAME_TX],
                LI.CREATE_DT,
                LI.CITY_TX,
                LI.STATE_PROV_TX,
                LI.ALLIED_SALES_REGION_CD,
                LI.[OPR_ID],
                LI.ENABLE_CARFAX_IN,
                LI.ENROLL_NADA_IN,
                LI.ENABLE_DOCUSIGN_USE_LIVE_IN,
                LI.ENABLE_CARFAX_ACH_IN,
                LI.ALLOW_ENABLE_INTERACTIVE_SELLING_IN,
                LI.ENABLE_MONRONEY_LABELS_IN,
                LI.ENABLE_MASS_IMPORT_IN,
                LI.[CW_ACTIVE_IN],
                LI.ENABLED_IN,
                LI.SSO_ENABLED_IN,
                LI.ENABLE_LIVE_SUPPORT_IN,
                #GAP.ProviderName,
                #GAP.GAPLatestProductDate,
                #GAP.GAPPRODID,
                #MBP.ProviderName,
                #MBP.MBPLatestProductDate,
                #MBP.MBPPRODID,
                #DPW.ProviderName,
                #DPW.DPWLatestProductDate,
                #DPW.DPWPRODID,
                #VPP.ProviderName,
                #VPP.VPPLatestProductDate,
                #VPP.VPPPRODID,
                #CI.CILatestProductDate,
                #CI.ProviderName,
                #CI.CIPRODID,
                #DP.DPLatestProductDate,
                #DP.ProviderName,
                #DP.DPPRODID
      SELECT Row_number()
               OVER (
                 PARTITION BY NAME_TX
                 ORDER BY GAPLatestProductDate DESC, MBPLatestProductDate DESC, DPWLatestProductDate DESC, VPPLatestProductDate DESC, CILatestProductDate DESC, DPLatestProductDate DESC) AS PRODUCT_RECENCY,
             *
      INTO   #ORDERED_INFO
      FROM   #LDR_INFO

      SELECT NAME_TX,
             LENDER_ID,
             CREATE_DT,
             CITY_TX,
             STATE_PROV_TX,
             ALLIED_SALES_REGION_CD,
             "Broker",
             "Has None",
             HasGAP,
             GAPProvider,
             QuoteOnly,
             HasMBP,
             MBPProvider,
             HasDPW,
             DPWProvider,
             HasVPP,
             VPPProvider,
             HasAPI,
             LosAPI,
             HasCLCD,
             CLCDProvider,
             HasDP,
             DPProvider,
             LIVE_CHAT,
             INTERACTIVE_SELLING_IN,
             DocuSign,
             CarFax,
             MONRONEY_LABELS_IN,
             MASS_IMPORT_IN,
             GeneralADR,
             MBPADR,
             GAPADR,
             DPWADR,
             VPPADR,
             HasJLP,
             ConsumerWebsite,
             NADA,
             GAPACH,
             MBPACH,
             DPWACH,
             VPPACH,
             CarFaxACH,
             IDP_IN,
             ActiveUsers,
             SignedInAllTime,
             SignedInLastMonth
      FROM   #ORDERED_INFO
      WHERE  PRODUCT_RECENCY = 1
END
  