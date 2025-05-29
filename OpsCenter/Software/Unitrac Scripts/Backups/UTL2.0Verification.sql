
  declare @today DateTime = Cast(Getdate() as Date)
  declare @from DateTime = @today - 7

  /*
  select source.[Code], [0],[1],[2],[3],[4],[5],[6]
  from
  (select le.CODE_TX [Code], le.NAME_TX [Lender], umr.UTL_VERSION_NO [Version], umr.MATCH_RESULT_CD [MatchResult], Cast(umr.CREATE_DT as Date)  [Date]
   from UTL_MATCH_RESULT umr
     join LOAN l on umr.UTL_LOAN_ID = l.ID
     join LENDER le on l.LENDER_ID = le.ID
   where umr.CREATE_DT >= @from and umr.CREATE_DT < @today) as source
   PIVOT
   (
      count([Code])
	  for [Date] in ([0],[1],[2],[3],[4],[5],[6])
   ) as PivotTable;
   */


  select le.CODE_TX [Code], le.NAME_TX [Lender], umr.UTL_VERSION_NO [Version], umr.MATCH_RESULT_CD [MatchResult], Cast(umr.CREATE_DT as Date)  [Date], count(*) [Count]
  from UTL_MATCH_RESULT umr
    join LOAN l on umr.UTL_LOAN_ID = l.ID
    join LENDER le on l.LENDER_ID = le.ID
  where umr.CREATE_DT >= @from and umr.CREATE_DT < @today
    and umr.UTL_VERSION_NO > 0
  group by le.CODE_TX, le.NAME_TX, umr.UTL_VERSION_NO,umr.MATCH_RESULT_CD, Cast(umr.CREATE_DT as Date)
  order by le.NAME_TX, Cast(umr.CREATE_DT as Date) desc

