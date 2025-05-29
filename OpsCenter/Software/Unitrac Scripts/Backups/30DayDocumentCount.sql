CREATE PROCEDURE [dbo].[30DayDocumentCount]
   @lenderCodes nvarchar(max)
AS
begin
-------------------------------------------------------------------------------------------------------------------------
-- 30 DAy Document Count and hours to work
-------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------
------ 
------		STEP 1: get all the batch image queue entries
------		STEP 2: adjust them for holiday / weekend etc
------		STEP 3: aggregate the results

   CREATE TABLE #LENDER_CODES ( LENDER_CODE NVARCHAR(100))

   INSERT INTO #LENDER_CODES
			SELECT
				sf.STRVALUE
			FROM
				dbo.SplitFunction(@lenderCodes, ',') sf

   ---- STEP 1: get all the batch image queue entries
   select
	   ldr.code_tx as LENDER_CD,
	   LDR.NAME_TX as LENDER_NAME,
	   IQ.ImageType,
	   0 as [reducedays],
	   CASE WHEN iq.ImageType not in ( 'F', 'DF' ) THEN 1 ELSE 0 END AS [InHouseNo],
	   CASE WHEN iq.ImageType in ( 'F', 'DF' ) THEN 1 ELSE 0 END AS [OutSourceNo],
	   iq.createddate, iq.lastmodifieddate,
	   case 
		   when datediff(hour,iq.createddate, iq.lastmodifieddate) <= 24 then 'Less Than 24 hrs' 
		   when datediff(hour,iq.createddate, iq.lastmodifieddate) > 24 and datediff(hour,iq.createddate, iq.lastmodifieddate) <= 48 then '24 to 48 hrs'
		   else 'More Than 48 hrs'
	   end
	   as [workedhours]
   into
	   #datatemp
   from 
	   vut.dbo.tblImageQueue iq
	   join vut.dbo.ScanBatch sb on sb.lenderkey = iq.lenderkey and sb.batchid = iq.batchid
	   join lender ldr on ldr.id = iq.LenderKey 
	   JOIN #LENDER_CODES ldrCode ON ldr.CODE_TX = ldrCode.LENDER_CODE
   where
	   iq.CreatedDate >= DateAdd(month,-1,getdate())


   ---- STEP 2: adjust them for holiday / weekend etc
	Update #datatemp
	Set ReduceDays = (Select count(*) from vut.dbo.lkuAgencyHoliday where CreatedDate >= HolidayDate and lastmodifieddate <= HolidayDate)
	from #datatemp

	Update #datatemp
	set ReduceDays = ReduceDays + datediff(wk,CreatedDate,lastmodifieddate) * 2

	Update #datatemp
	set ReduceDays = ReduceDays + 1
	where datepart(dw,CreatedDate) = 1 

	Update #datatemp
	set ReduceDays = ReduceDays + 1
	where datepart(dw,lastmodifieddate) = 7


	Update #datatemp 
	set workedhours = 
	case 
		when (datediff(hour,createddate, lastmodifieddate)-(reducedays * 24)) <= 24 then 'Less Than 24 hrs' 
		when (datediff(hour,createddate, lastmodifieddate)-(reducedays * 24)) > 24 and (datediff(hour,createddate, lastmodifieddate)-(reducedays * 24)) <= 48 then '24 to 48 hrs'
		else 'More Than 48 hrs'
	end
	where
		reducedays > 0

   ---- Step 3: aggregate the results
   select
	   LENDER_CD,
	   LENDER_NAME,
	   WORKEDHOURS as HOURS_TO_WORK,
	   SUM(InHouseNo+outsourceNo) AS TXN_COUNT
   FROM
	   #datatemp
   group by
	   lender_cd,
	   lender_name,
	   workedhours


   DROP TABLE #LENDER_CODES
end
