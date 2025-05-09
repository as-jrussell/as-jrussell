USE [Unitrac_Reports]
GO
/****** Object:  StoredProcedure [dbo].[Report_CallResolution]    Script Date: 7/14/2017 1:20:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Report_CallResolution] 
/**/
--Declare
 @LenderCode NVarChar(10)=Null
,@BranchCode NVarChar(20)=Null
,@Division NVarChar(20)=Null
--,@Begin_Date DateTime=Null
,@End_Date DateTime=Null
,@RollMonths TinyInt=12 --rolling counts for 12 months
,@MonthOffset TinyInt=1 --offset within last month(s)
,@CallType NVarChar(15)='INBNDCALL'
--,@Coverage NVarChar(30)=Null

,@Debug NVarChar(10)=Null
AS
BEGIN
	Declare @BOM DateTime=Null
	
	Declare @GetDate DateTime = GetDate()

	Declare @this_MonthDate DateTime=Cast(@GetDate As DateTime) --instead cast this as Date if not interested in the time part
	--Declare @last_MonthDate DateTime=DateAdd(month, -1, @this_MonthDate)
	--
	Declare @this_BOMonth DateTime=DateAdd(day, -Day(@this_MonthDate) + 1, @this_MonthDate)
	--Declare @last_BOMonth DateTime=DateAdd(month, -1, @this_BOMonth)
	--
	Declare @last_EOMonth DateTime=DateAdd(day, -Day(@this_MonthDate), @this_MonthDate)
	Declare @this_EOMonth DateTime=DateAdd(month, 1, @last_EOMonth) --this may not be quite exactly accurate as possible

/*
--DEFAULTS:
*/
	Select
	 @Debug=IsNull(@Debug,'0')
	--,@Division=IsNull(@Division,'4') --Mortgage
	,@CallType=IsNull(@CallType,'INBNDCALL')
	,@RollMonths=IsNull(@RollMonths,12)
	,@MonthOffset=IsNull(@MonthOffset,3)

	Select
	-- @BOM=IsNull(@BOM,@last_BOMonth) --use last_BOMonth since this month is not yet over
	--,@End_Date=IsNull(@BOM,@last_EOMonth) --use last_EOMonth since this month is not yet over
	-- @Begin_Date=IsNull(@Begin_Date,@this_MonthDate - @RollMonths) --default using this month date, even if probably not actually the BOM
	 @BOM=IsNull(@BOM,@this_MonthDate - @RollMonths) --default using this month date, even if probably not actually the BOM
	,@End_Date=IsNull(@End_Date,@this_MonthDate - 1) --default using this month date, even if its probably not actually the EOM

/*
--DEBUGGING:
	Select
	 @Debug='2771' --PenFed
	 --@Debug='2252' --SpaceCoast
	,@BOM='1/1/2017'
	,@End_Date='1/31/2017'
	,@RollMonths=1
*/

	Select
	 @LenderCode=IsNull(@LenderCode,@Debug)
	Where IsNull(@Debug,'0')>'0'

	Declare @LenderID BigInt = Case When IsNull(@LenderCode,'0')='0' Then Null Else (Select Top 1 LENDER.ID From LENDER (NoLock) Where LENDER.CODE_TX=@LenderCode And LENDER.PURGE_DT Is Null And LENDER.AGENCY_ID=1) End

	Declare @RollMonthOffset TinyInt = @RollMonths + @MonthOffset --probably 12 + 3 = 15
	Declare @RollMonthOffset_FromBOM DateTime = DateAdd(Month, -1 * @RollMonthOffset, @End_Date) --assume offset is positive, so multiply it by -1
	/*
	--reset BOM (and EOM) to THIS month date but only if it is the 1st of THIS month:
	*/
	If Cast(@BOM As Date) = Cast(@this_BOMonth As Date)
	Begin
		Select
		 @BOM = @this_MonthDate
		,@End_Date = @this_MonthDate
	End

	Declare @BOM_Month Int=DatePart(Month,@BOM)
	Declare @BOM_Year Int=DatePart(Year,@BOM)
	Declare @End_Date_Month Int=DatePart(Month,@End_Date) --this should be the same as @BOM_Month
	Declare @End_Date_Year Int=DatePart(Year,@End_Date) --this should be the same as @BOM_Year

	Declare @BOY DateTime='1/1/' + Cast(@BOM_Year As VarChar(4))

	Declare
	 @ihID_BOY BigInt --BeginningOfYear
	,@ihID_BOM BigInt --BeginningOfMonth
	,@ihID_EOM BigInt --EndOfMonth
	,@ihID_Roll BigInt --uses @RollMonths
	,@ihDate_BOY DateTime --BeginningOfYear
	,@ihDate_BOM DateTime --BeginningOfMonth
	,@ihDate_EOM DateTime --EndOfMonth
	,@ihDate_Roll DateTime --uses @RollMonths
--
IF OBJECT_ID(N'tempdb..#IH',N'U') IS NOT NULL
	Drop Table #IH
IF OBJECT_ID(N'tempdb..#tmpInbound',N'U') IS NOT NULL
	Drop Table #tmpInbound
IF OBJECT_ID(N'tempdb..#tmpCallsWithMult',N'U') IS NOT NULL
	Drop Table #tmpCallsWithMult
--
		Select IH.ID, IH.CREATE_DT, IH.Loan_ID, IH.PROPERTY_ID
		,DP.Year
		,DP.Month
		,CallType=IH.TYPE_CD
		,Who=Who.TypeCode
		Into #IH
		From INTERACTION_HISTORY IH (NoLock)
		CROSS Apply(
			Select
			 Month=DatePart(month,IH.CREATE_DT)
			,Year=DatePart(year,IH.CREATE_DT)
		) As DP
		CROSS Apply(Select TypeCode=IH.SPECIAL_HANDLING_XML.value('(/SH[1]/WhoTypeCode)[1]', 'nvarchar(20)')) As Who
		Where 1=1
        And IH.PURGE_DT Is Null
        And (IH.TYPE_CD=@CallType)
	    And Who.TypeCode In ('Borrower','Cosigner')
        --And DateDiff(month,IH.CREATE_DT,@last_MonthDate)<=(@RollMonths + @MonthOffset) --e.g. we would never need data any older than 12 + 2 = 14 months old, where @RollMonths defaults to 12 where @MonthOffset defaults to 2
		And IH.CREATE_DT >= @RollMonthOffset_FromBOM
		And IH.CREATE_DT <= IsNull(@End_Date,IH.CREATE_DT)
;
--
	Select
	 @ihID_Roll=(Select MIN(IH.ID) From #IH IH)--Where DateDiff(month,IH.CREATE_DT,@last_MonthDate)=@RollMonths AND DateDiff(year,IH.CREATE_DT,@last_MonthDate) In (0, 1))
	,@ihID_BOY=(Select MIN(IH.ID) From #IH IH Where Cast(IH.CREATE_DT As Date)>=Cast(@BOY As Date))
	,@ihID_BOM=(Select MIN(IH.ID) From #IH IH Where IH.Month=@BOM_Month AND IH.Year=@BOM_Year)
	,@ihID_EOM=(Select MAX(IH.ID) From #IH IH Where IH.Month=@End_Date_Month AND IH.Year=@End_Date_Year)
;
	Select
	 @ihDate_Roll=(Select IH.CREATE_DT From #IH IH Where IH.ID=@ihID_Roll)
	,@ihDate_BOY=(Select IH.CREATE_DT From #IH IH Where IH.ID=@ihID_BOY)
	,@ihDate_BOM=(Select IH.CREATE_DT From #IH IH Where IH.ID=@ihID_BOM)
	,@ihDate_EOM=(Select IH.CREATE_DT From #IH IH Where IH.ID=@ihID_EOM)
;
--
	SET NOCOUNT ON
	If IsNull(@Debug,'0')>'0'
	Begin
		SET NOCOUNT OFF

		Print '@Debug:'
		Print @Debug
		Print '@LenderCode:'
		Print @LenderCode
		Print '@LenderID:'
		Print @LenderID
		Print '@Division:'
		Print @Division
		--Print '@Coverage:'
		--Print @Coverage
		Print '@CallType:'
		Print @CallType
		Print '@RollMonths:'
		Print @RollMonths
		Print '@MonthOffset:'
		Print @MonthOffset
		Print '@BOY'
		Print @BOY
		Print '@BOM'
		Print @BOM
		--Print '@last_BOMonth:'
		--Print @last_BOMonth
		Print '@last_EOMonth:'
		Print @last_EOMonth
		Print '@this_BOMonth:'
		Print @this_BOMonth
		Print '@this_EOMonth:'
		Print @this_EOMonth
		;Select
		 'RollMonths'=@RollMonths
		,'ihID_Roll'=@ihID_Roll,'ihDate_Roll'=@ihDate_Roll
		--,'ihID_BOY'=@ihID_BOY,'ihDate_BOY'=@ihDate_BOY
		--,'ihID_BOM'=@ihID_BOM,'ihDate_BOM'=@ihDate_BOM
		,'ihID_EOM'=@ihID_EOM,'ihDate_EOM'=@ihDate_EOM

		;Select Count#IH=Count(*) From #IH
		;Select '#IH:'='(TempTable)',* From #IH IH Order By IH.CREATE_DT
	End

/*
Create Table #tmpInbound(
 CoverType NVarChar(30)
,Called_Month Int
,Called_Year Int
ri,LenderID BigInt
,LenderCode NVarChar(10)
,LoanID BigInt
,PropID BigInt
,ColID BigInt
,RC_ID BigInt
,IH_ID BigInt
)
*/

;
Select top 100 percent
 CoverType = RC.TYPE_CD
,[Year] = Called.Year
,[Month] = Called.Month
,[MonthName] = Called.MonthName
,L.LENDER_ID As LenderID
,LND.CODE_TX As LenderCode
,L.DIVISION_CODE_TX
,L.BRANCH_CODE_TX
,LoanID = Coalesce(IH.LOAN_ID,C.LOAN_ID,L.ID)
,PropID = ID2.Prop
,IH_PropID = IH.PROPERTY_ID
,RefCode
/*
,RefNum
,RefPart.ReqCov
,RefPart.CollatLast4
*/

,RC_ID = Coalesce(RC.ID, ID2.RC)
,C.ID As ColID
,C.PRIMARY_LOAN_IN
,IH.ID As IH_ID
,Call_Type=IH.TYPE_CD
,Call_Time=IH.CREATE_DT
,CREATE_DT=IH.CREATE_DT
,Who--=Who.TypeCode
--,Satisfied=[Caller].Satisfied
--,One_Call=Resolution.OneCall
--,ResolutionCode=Resolution.TypeCode
--,Escalated=[Call].Escalated
Into #tmpInbound
From INTERACTION_HISTORY IH (NoLock)
Join #IH IH2 On IH2.ID=IH.ID
OUTER Apply(Select Satisfied=IH.SPECIAL_HANDLING_XML.value('(/SH[1]/CallerSatisfied)[1]', 'nvarchar(1)')) As [Caller]
OUTER Apply(Select
 OneCall=IH.SPECIAL_HANDLING_XML.value('(/SH[1]/OneCallResolution)[1]', 'nvarchar(1)')
,[Type]=IH.SPECIAL_HANDLING_XML.value('(/SH[1]/ResolutionType)[1]', 'nvarchar(30)')
,[TypeCode]=IH.SPECIAL_HANDLING_XML.value('(/SH[1]/ResolutionTypeCode)[1]', 'nvarchar(20)')
) As Resolution
OUTER Apply(Select RefCode=IH.SPECIAL_HANDLING_XML.value('(/SH[1]/ReferenceNumber)[1]', 'nvarchar(30)')) As RefCode
OUTER Apply(Select RC=IH.SPECIAL_HANDLING_XML.value('(/SH[1]/RC)[1]', 'bigint')) As ID
LEFT Join PROPERTY P (NoLock) On P.ID=IH.PROPERTY_ID And P.PURGE_DT Is Null

CROSS Apply(Select RC=Coalesce(IH.REQUIRED_COVERAGE_ID, ID.RC), Prop=Coalesce(P.ID, Null)) As ID2
OUTER Apply(Select Top 1 C.* From COLLATERAL C (NoLock) Where ((P.ID Is NOT Null AND C.PROPERTY_ID=IH.PROPERTY_ID)) And (C.LOAN_ID=IH.LOAN_ID OR IH.LOAN_ID Is Null) And C.PURGE_DT Is Null Order By Case When C.PRIMARY_LOAN_IN='Y' And C.STATUS_CD='A' Then 1 When C.PRIMARY_LOAN_IN='Y' Then 3 When C.STATUS_CD='A' Then 5 Else 9 End) As C
LEFT Join REQUIRED_COVERAGE RC (NoLock) On (RC.ID=ID2.RC) And RC.PURGE_DT Is Null
CROSS Apply(Select Prop=Coalesce(P.ID, Null)) As ID3
--OR parse and use RefNum, which is MUCH more inefficient
--CROSS Apply(Select RefNum=Case When 1=IsNumeric(RefCode) Then Try_Cast(RefCode As BigInt) Else Cast(Null As BigInt) End) As RefNum
--CROSS Apply(Select ValidRef = Case When RefNum Is NOT Null AND '7'=Substring(RefCode, 1, 1) Then 1 Else 0 End) As [Is]
--CROSS Apply(
--	Select
--	 CollatLast4=Case When 1=ValidRef Then Cast(Substring(RefCode, Len(RefCode) - 4, 4) As Int) Else Cast(Null As Int) End
--	,ReqCov=Case When 1=ValidRef Then Cast(Substring(Stuff(RefCode, Len(RefCode) - 4, 5, ''), 2, Len(RefCode)) As BigInt) Else Cast(Null As BigInt) End
--	) As RefPart
--OUTER Apply(Select Top 1 C.* From COLLATERAL C (NoLock) Where (C.PROPERTY_ID=Coalesce(P.ID,C.PROPERTY_ID) AND C.LOAN_ID=Coalesce(IH.LOAN_ID,C.LOAN_ID)) /*AND (CollatLast4 Is NULL OR CollatLast4 = C.ID % 10000)*/ And C.PURGE_DT Is Null Order By Case When C.PRIMARY_LOAN_IN='Y' And C.STATUS_CD='A' Then 1 When C.PRIMARY_LOAN_IN='Y' Then 3 When C.STATUS_CD='A' Then 5 Else 9 End) As C
--CROSS Apply(Select RC=Coalesce(IH.REQUIRED_COVERAGE_ID, ID.RC, RefPart.ReqCov)) As ID2
--LEFT Join REQUIRED_COVERAGE RC (NoLock) On (RC.ID=ID2.RC) And RC.PURGE_DT Is Null
--LEFT Join PROPERTY P2 (NoLock) On P2.ID=RC.PROPERTY_ID And P2.PURGE_DT Is Null
--CROSS Apply(Select Prop=Coalesce(P.ID, P2.ID)) As ID3

Join LOAN L (NoLock) On L.ID=IsNull(IH.LOAN_ID,C.LOAN_ID) And L.PURGE_DT Is Null
Join LENDER LND (NoLock) On LND.ID=L.LENDER_ID And LND.PURGE_DT Is Null

/*
--WRONG: instead use IH.SPECIAL_HANDLING_XML.WhoTypeCode In ('Borrower', 'Cosigner')
*/
--Join OWNER_LOAN_RELATE OLR (NoLock) On L.ID=OLR.LOAN_ID And OLR.PURGE_DT Is Null And OLR.OWNER_TYPE_CD In ('B','CS')
--
--CROSS Apply(Select TypeCode=IH.SPECIAL_HANDLING_XML.value('(/SH[1]/WhoTypeCode)[1]', 'nvarchar(max)')) As Who

CROSS Apply(
	Select
	 Year=DatePart(Year,IH.CREATE_DT)
	,Month=DatePart(Month,IH.CREATE_DT)
	,MonthName=DateName(Month,IH.CREATE_DT)
 ) As Called

--OUTER Apply(Select Escalated=IH.SPECIAL_HANDLING_XML.value('(/SH[1]/CallEscalated)[1]', 'nvarchar(1)')) As [Call] --??

/*
CROSS Apply(
	Select
	 Month=@BOM_Month --DatePart(month,@BOM)
	,Year=@BOM_Year --DatePart(year,@BOM)
 ) As BOM
 */
--CROSS Apply(Select ThisQuarter=Cast(Case When DateDiff(month,IH.CREATE_DT,GetDate())<=3 Then 1 Else 0 End As Bit)) As [Within]

Where 1=1
--**--**--**--**--
  --And DateDiff(month,IH.CREATE_DT,GetDate())<=(@RollMonths + @MonthOffset) --we would never need data any older than 12 + 2 = 14 months old
  --And (@BOM Is Null OR DateDiff(month,IH.CREATE_DT,@BOM) Between 0 And 2)
  --And (@BOM Is Null OR (Called.Month=BOM.Month AND Called.Year=BOM.Year))
  --And IH.ID Between @ihID_BOY And @ihID_EOM
  --And IH.ID Between @ihID_Roll And @ihID_EOM
  And IH.CREATE_DT Between DateAdd(Month, -1 * Abs(@MonthOffset), @ihDate_Roll) And @ihDate_EOM
--**--**--**--**--
  And (L.DIVISION_CODE_TX=@Division OR NullIf(@Division,'') Is Null)
  And (RTrim(L.BRANCH_CODE_TX)=RTrim(@BranchCode) OR @BranchCode Is Null)
  And (L.LENDER_ID=@LenderID OR (@LenderID Is Null AND LND.CANCEL_DT Is Null AND LND.TEST_IN='N'))
  --And Who.TypeCode In ('Borrower','Cosigner')
;

	If IsNull(@Debug,'0')>'0'
	Begin
		;Select Count#IBC=Count(*) From #tmpInbound Where IsNull(@Debug,'0')>'0'
		;Select '#tmpInbound:'='(TempTable)'
		 ,tmp.*
		 ,LOAN.NUMBER_TX As LoanNumber
		 From #tmpInbound tmp
		 LEFT Join LOAN (NoLock) On LOAN.ID=tmp.LoanID
		 --Order By LenderCode, Cast(tmp.CREATE_DT As Date), CoverType
		 Order By LOAN.NUMBER_TX, CoverType, tmp.BRANCH_CODE_TX, tmp.CREATE_DT
		
		Print '#records Inbound:'
		Declare @RC Int=(Select COUNT(*) From #tmpInbound)
		Print @RC
	End

;With
 Inbound2 As
(
Select
 I1.*
,Mult.SameOffset As MultSameOffset
,AnotherDT=Another.DT
,Loan_Num=LOAN.NUMBER_TX
From #tmpInbound I1
Join LOAN (NoLock) On LOAN.ID=I1.LoanID
OUTER Apply(
			Select TOP 1 DT = I2.CREATE_DT
			From #tmpInbound I2
			Where 1=1
			And I2.IH_ID<>I1.IH_ID --do NOT include same IH_ID
			And I2.LoanID=I1.LoanID
			And (I2.CoverType=I1.CoverType OR (I2.CoverType Is Null AND I1.CoverType Is Null))

			--look BEHIND:
			And I2.CREATE_DT >= DateAdd(Month, -1 * Abs(@MonthOffset), I1.CREATE_DT) --need to multiply offset by -1 for "lookbehind"
			And I2.CREATE_DT < I1.CREATE_DT --only calls in the PAST ("lookbehind")

			--look AROUND: ("split" @MonthOffset between PAST and FUTURE; note that offset is truncated; so that e.g. 3 / 2 is truncated to 1)
			--And I2.CREATE_DT >= DateAdd(Month, -1 * Abs(@MonthOffset) / 2, I1.CREATE_DT) --need to multiply offset by -1 for "lookbehind" part
			--And I2.CREATE_DT < DateAdd(Month, +1 * Abs(@MonthOffset) / 2, I1.CREATE_DT)

			Order By Abs(DateDiff(Day, I2.CREATE_DT, I1.CREATE_DT)) DESC --sort by the FURTHEREST other call-date (but still being within the offset)
) As Another
CROSS Apply(
	Select
	 SameOffset =
	 Case
		When Another.DT Is NOT Null
		And Cast(Another.DT As Date)=Cast(I1.CREATE_DT As Date) --consider SAME-DAY calls to be LOGICALLY the same call...remember that Another.DT is the FURTHEREST other call-date, so the only other calls possible within the offset would be on this same day
		Then 1 --instead make this 1 if the decision is made to consider SAME-DAY calls to be DISTINCT

		When Another.DT Is NOT Null
		Then 1

		Else 0
	 End
 )
 As Mult
)
Select I2.* Into #tmpCallsWithMult From Inbound2 I2

/*
--DEBUG:
*/
IF IsNull(@Debug,'0')>'0'
Begin
	Select 'Multiple:' as '(Mult:behind)', tmp.*, IH.SPECIAL_HANDLING_XML From #tmpCallsWithMult tmp LEFT Join INTERACTION_HISTORY IH (NoLock) On IH.ID=tmp.IH_ID Where MultSameOffset!=0 /*And (One_Call='Y' OR Satisfied='N')*/ Order By CoverType, tmp.BRANCH_CODE_TX, tmp.CREATE_DT, tmp.LoanID
	Select 'Single:' as '(Sing:behind)', tmp.*, IH.SPECIAL_HANDLING_XML From #tmpCallsWithMult tmp LEFT Join INTERACTION_HISTORY IH (NoLock) On IH.ID=tmp.IH_ID Where MultSameOffset=0 /*And (One_Call='N' OR Satisfied='N')*/ Order By CoverType, tmp.BRANCH_CODE_TX, tmp.CREATE_DT, tmp.LoanID
End

/*
*/
Select
 '''' + LenderCode As 'Lender Code'--|TextFormat'
--,LenderID As 'Lender_ID'
,LENDER.NAME_TX As 'Lender Name'
,rcDiv.MEANING_TX As 'Division'
,'Branch'='''' + BRANCH_CODE_TX
,'Coverage' = Case When CoverType Is Null Then '' Else CoverType End
,tmp.Year
,tmp.MonthName As 'Month'
,YM.Year_Month As 'Year-Month'--|TextFormat'
,'Call Type' = tmp.Call_Type
,'Total'=Count(*)
,'Multiple Calls'=Sum(MultSameOffset)
,'Single Calls'=Count(*) - Sum(MultSameOffset)
,'Single%|PercentFormatDecimalPlaces1' = Cast( Round( (1.0 - ((Sum(MultSameOffset) * 1.0) / (IsNull(NullIf(Count(*),0),Null) * 1.0))) * 100.0, 1 ) / 100.0 As Decimal(4, 3) )
--,'Single%|PercentFormat' = (1.0 - ((Sum(MultSameOffset) * 1.0) / (IsNull(NullIf(Count(*),0),Null) * 1.0)))
From #tmpCallsWithMult tmp
Join LENDER (NoLock) On LENDER.ID=tmp.LenderID
CROSS Apply(
	Select
	 [Day] = ' (as of day ' + Cast(Day(@GetDate) As VarChar(2)) + ')'
	,[Date] = ' (as of ' + Convert(varchar(5), @GetDate, 1) + ')' --note that varchar(5) will cause its format to be MM/dd
) AsOf
CROSS Apply(
	Select
	 Year_Month =Cast(tmp.Year As VarChar(4)) + '-' + Case When tmp.Month < 10 Then '0' + Cast(tmp.Month As Char(1)) Else Cast(tmp.Month As Char(2)) End
 + Case When tmp.Year = Year(@GetDate) And tmp.Month >= Month(@GetDate) Then AsOf.[Date] Else '' End
) As YM
LEFT Join REF_CODE rcDiv (NoLock) On rcDiv.CODE_CD=DIVISION_CODE_TX And rcDiv.DOMAIN_CD='ContractType'
--CROSS Apply( Select [Single] = (1.0 - ((Sum(MultSameOffset) * 1.0) / (IsNull(NullIf(Count(*),0),Null) * 1.0))) ) As [Percent]
Where 1=1
  And tmp.Year >= Year(@ihDate_Roll) --this is actually probably not needed
  --EXCLUDE the 3 month offset from 15 months ago:
  And 1 = Case When tmp.Year = Year(@ihDate_Roll) Then Case When tmp.Month >= Month(@ihDate_Roll) + @MonthOffset Then 1 Else 0 End Else 1 End

Group By
 LenderID
,LenderCode
,LENDER.NAME_TX
,rcDiv.MEANING_TX
,BRANCH_CODE_TX
,CoverType
,tmp.Call_Type
,tmp.Year
,tmp.Month
,Year_Month
,tmp.MonthName
,AsOf.Day
,AsOf.Date

Order By
 LenderCode
,LENDER.NAME_TX
,rcDiv.MEANING_TX
,BRANCH_CODE_TX
,CoverType
,tmp.Call_Type
,tmp.Year
,tmp.Month

END
