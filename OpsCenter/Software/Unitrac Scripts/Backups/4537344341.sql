/* (inserted by DPA)
Procedure: UniTrac.dbo.GetLenderCycleInfo
Character Range: 2980 to 3956
Waiting on statement: 

SELECT DISTINCT TOP 1 P.ID, 
   LP.LENDER_ID, 
   CASE 
      WHEN T3.Loc.value('.','datetimeoffset') = '0001-01-01 00:00:00' THEN GETDATE() 
      ELSE T3.Loc.value('.','datetime') 
   END as NextCycle, 
   T3.Loc.value('.','nvarchar(30)') as NextCycle, 
   P.LAST_SCHEDULED_DT as LastCycle 
FROM PROCESS_DEFINITION P CROSS APPLY SETTINGS_XML_IM.nodes(
   '/ProcessDefinitionSettings/LCGCTList/LCGCTId') as T2(Loc) CROSS APPLY SETTINGS_XML_IM.nodes(
   '/ProcessDefinitionSettings/AnticipatedNextScheduledDate') as T3(Loc) 
JOIN LENDER_COLLATERAL_GROUP_COVERAGE_TYPE LCGCT 
ON LCGCT.ID = T2.Loc.value('.','bigint') 
JOIN LENDER_PRODUCT LP 
ON LP.ID = LCGCT.LENDER_PRODUCT_ID 
WHERE P.PROCESS_TYPE_CD = @ProcessTypeCode 
AND T3.Loc is not null 
AND P.STATUS_CD <> 'Expired' 
AND P.ACTIVE_IN = 'Y' 
AND LP.LENDER_ID = @LenderId 
AND LCGCT.PURGE_DT IS NULL 
AND LP.PURGE_DT IS NULL 
AND P.PURGE_DT IS NULL 
ORDER BY 3 ASC

*/
CREATE PROCEDURE [dbo] 
.[GetLenderCycleInfo]  
(  
@LenderId bigint,  
@ProcessTypeCode nvarchar(10) = null,  
@LcgctId bigint = null,  
@PropertyType nvarchar(10) = null  
)  
AS  
   BEGIN  
      --Default to cycle   
      if @ProcessTypeCode is null  
      set @ProcessTypeCode = 'CYCLEPRC'  
      IF @LcgctId = 0  
      Set @LcgctId = NULL  
      IF @PropertyType = ''  
      Set @PropertyType = NULL  
      IF (@LenderId IS NOT NULL AND @LcgctId IS NOT NULL)  
      BEGIN  
         SELECT DISTINCT TOP 1 P.ID,  
            LP.LENDER_ID,  
            CASE  
               WHEN T3.Loc.value('.','datetimeoffset') = '0001-01-01 00:00:00' THEN GETDATE()  
               ELSE T3.Loc.value('.','datetime')  
            END as NextCycle,  
            T3.Loc.value('.','nvarchar(30)') as NextCycle,  
            P.LAST_SCHEDULED_DT as LastCycle  
         FROM PROCESS_DEFINITION P CROSS APPLY SETTINGS_XML_IM.nodes( 
            '/ProcessDefinitionSettings/LCGCTList/LCGCTId') as T2(Loc) CROSS APPLY  
            SETTINGS_XML_IM.nodes('/ProcessDefinitionSettings/AnticipatedNextScheduledDate') as T3( 
            Loc)  
         JOIN LENDER_COLLATERAL_GROUP_COVERAGE_TYPE LCGCT  
         ON LCGCT.ID = T2.Loc.value('.','bigint')  
         JOIN LENDER_PRODUCT LP  
         ON LP.ID = LCGCT.LENDER_PRODUCT_ID  
         WHERE P.PROCESS_TYPE_CD = @ProcessTypeCode  
        AND T3.Loc is not null  
        AND P.STATUS_CD <> 'Expired'  
        AND P.ACTIVE_IN = 'Y'  
        AND LP.LENDER_ID = @LenderId  
        AND LCGCT.ID = @LcgctId  
        AND LCGCT.PURGE_DT IS NULL  
        AND LP.PURGE_DT IS NULL  
        AND P.PURGE_DT IS NULL  
         ORDER BY 3 ASC  
         END  
      ELSE  
      IF (@LenderId IS NOT NULL AND @PropertyType IS NOT NULL)  
      BEGIN  
         SELECT DISTINCT TOP 1 P.ID,  
            LP.LENDER_ID,  
            CASE  
               WHEN T3.Loc.value('.','datetimeoffset') = '0001-01-01 00:00:00' THEN GETDATE()  
               ELSE T3.Loc.value('.','datetime')  
            END as NextCycle,  
            T3.Loc.value('.','nvarchar(30)') as NextCycle,  
            P.LAST_SCHEDULED_DT as LastCycle  
         FROM PROCESS_DEFINITION P CROSS APPLY SETTINGS_XML_IM.nodes( 
            '/ProcessDefinitionSettings/LCGCTList/LCGCTId') as T2(Loc) CROSS APPLY  
            SETTINGS_XML_IM.nodes('/ProcessDefinitionSettings/AnticipatedNextScheduledDate') as T3( 
            Loc)  
         JOIN LENDER_COLLATERAL_GROUP_COVERAGE_TYPE LCGCT  
         ON LCGCT.ID = T2.Loc.value('.','bigint')  
         JOIN LENDER_PRODUCT LP  
         ON LP.ID = LCGCT.LENDER_PRODUCT_ID  
         JOIN dbo.LCCG_COLLATERAL_CODE_RELATE lccgRel  
         ON lccgRel.LCCG_ID = LCGCT.LCCG_ID  
         JOIN dbo.COLLATERAL_CODE cc  
         ON cc.ID = lccgRel.COLLATERAL_CODE_ID  
         JOIN dbo.REF_CODE_ATTRIBUTE rca  
         ON rca.ATTRIBUTE_CD='PropertyType'  
        AND rca.DOMAIN_CD='SecondaryClassification'  
        AND rca.REF_CD = cc.SECONDARY_CLASS_CD  
         WHERE P.PROCESS_TYPE_CD = @ProcessTypeCode  
        AND T3.Loc is not null  
        AND P.STATUS_CD <> 'Expired'  
        AND P.ACTIVE_IN = 'Y'  
        AND LP.LENDER_ID = @LenderId  
        AND rca.VALUE_TX = @PropertyType  
        AND lccgRel.PURGE_DT is NULL  
        AND cc.PURGE_DT is NULL  
        AND rca.PURGE_DT is NULL  
        AND LCGCT.PURGE_DT IS NULL  
        AND LP.PURGE_DT IS NULL  
        AND P.PURGE_DT IS NULL  
         ORDER BY 3 ASC  
         END  
      ELSE  
      BEGIN 
/* BEGIN ACTIVE SECTION (inserted by DPA) */  
         SELECT DISTINCT TOP 1 P.ID,  
            LP.LENDER_ID,  
            CASE  
               WHEN T3.Loc.value('.','datetimeoffset') = '0001-01-01 00:00:00' THEN GETDATE()  
               ELSE T3.Loc.value('.','datetime')  
            END as NextCycle,  
            T3.Loc.value('.','nvarchar(30)') as NextCycle,  
            P.LAST_SCHEDULED_DT as LastCycle  
         FROM PROCESS_DEFINITION P CROSS APPLY SETTINGS_XML_IM.nodes( 
            '/ProcessDefinitionSettings/LCGCTList/LCGCTId') as T2(Loc) CROSS APPLY  
            SETTINGS_XML_IM.nodes('/ProcessDefinitionSettings/AnticipatedNextScheduledDate') as T3( 
            Loc)  
         JOIN LENDER_COLLATERAL_GROUP_COVERAGE_TYPE LCGCT  
         ON LCGCT.ID = T2.Loc.value('.','bigint')  
         JOIN LENDER_PRODUCT LP  
         ON LP.ID = LCGCT.LENDER_PRODUCT_ID  
         WHERE P.PROCESS_TYPE_CD = @ProcessTypeCode  
        AND T3.Loc is not null  
        AND P.STATUS_CD <> 'Expired'  
        AND P.ACTIVE_IN = 'Y'  
        AND LP.LENDER_ID = @LenderId  
        AND LCGCT.PURGE_DT IS NULL  
        AND LP.PURGE_DT IS NULL  
        AND P.PURGE_DT IS NULL  
         ORDER BY 3 ASC 
/* END ACTIVE SECTION (inserted by DPA) */  
         END  
   END  