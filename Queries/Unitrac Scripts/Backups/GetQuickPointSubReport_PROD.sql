USE [UniTrac_DW]
GO
/****** Object:  StoredProcedure [dbo].[GetQuickPointSubReport]    Script Date: 2/16/2016 8:14:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--exec [GetQuickPointSubReport] '4/1/2010'
ALTER Procedure [dbo].[GetQuickPointSubReport]
(
   @DATE DATETIME
)
AS
begin

		Select
			rfd.ROW_CD, 
			rfd.DESC_TX as [FUN],
			rfd.SORT_ORDER_NO as [FUNCTION_ORDER],
			'All' as [SERVICE_QUEUE],
			L.COUNT_NO,
			MONTH_NO,QUARTER_NO,YEAR_NO
		from Month_DIM MD
			inner Join REPORT_FUNCTION_DEF rfd on rfd.REPORT_CD = 'crbm' and rfd.REPORT_TABLE_CD = 'QP' and rfd.ROW_CD = 'QPINQ'
			left Join (select lsf.MONTH_ID, sum(LSF.QP_INQUIRIES_NO) as COUNT_NO 
			            from LENDER_SUMMARY_FACT LSF 
			            inner join MONTH_DIM M on LSF.MONTH_ID = M.ID AND M.MONTH_NO <= MONTH(@DATE) AND M.YEAR_NO = YEAR(@DATE)
			            where lsf.LENDER_ID in (select distinct ld.ID 
			                                    from LENDER_DIM LD
						                              INNER JOIN AGENCY_DIM AD ON AD.ID = LD.AGENCY_ID --AND AD.CODE_TX <> 'FREIMARK'
						                          )
						   group by lsf.month_id
						  ) L on L.MONTH_ID = MD.ID
		WHERE MD.MONTH_NO <= MONTH(@DATE) AND MD.YEAR_NO = YEAR(@DATE)
	Union
		Select
			rfd.ROW_CD, 
			rfd.DESC_TX as [FUN],
			rfd.SORT_ORDER_NO as [FUNCTION_ORDER],
			'All' as [SERVICE_QUEUE],
			L.COUNT_NO,
			MONTH_NO,QUARTER_NO,YEAR_NO
		from Month_DIM MD
			inner Join REPORT_FUNCTION_DEF rfd on rfd.REPORT_CD = 'crbm' and rfd.REPORT_TABLE_CD = 'QP' and rfd.ROW_CD = 'QPIS'
			left Join (select lsf.MONTH_ID, sum(LSF.QP_INS_SBMT_NO) as COUNT_NO 
			            from LENDER_SUMMARY_FACT LSF 
			            inner join MONTH_DIM M on LSF.MONTH_ID = M.ID AND M.MONTH_NO <= MONTH(@DATE) AND M.YEAR_NO = YEAR(@DATE)
			            where lsf.LENDER_ID in (select distinct ld.ID 
			                                    from LENDER_DIM LD
						                              INNER JOIN AGENCY_DIM AD ON AD.ID = LD.AGENCY_ID --AND AD.CODE_TX <> 'FREIMARK'
						                          )
						   group by lsf.month_id
						  ) L on L.MONTH_ID = MD.ID
		WHERE MD.MONTH_NO <= MONTH(@DATE) AND MD.YEAR_NO = YEAR(@DATE)
   UNION
      Select
			rfd.ROW_CD, 
			rfd.DESC_TX as [FUN],
			rfd.SORT_ORDER_NO as [FUNCTION_ORDER],
			'All' as [SERVICE_QUEUE],
			L.COUNT_NO,
			MONTH_NO,QUARTER_NO,YEAR_NO
		from Month_DIM MD
			inner Join REPORT_FUNCTION_DEF rfd on rfd.REPORT_CD = 'crbm' and rfd.REPORT_TABLE_CD = 'QP' and rfd.ROW_CD = 'QPUIS'
			left Join (select lsf.MONTH_ID, sum(LSF.QP_UTL_SBMT_NO) as COUNT_NO 
			            from LENDER_SUMMARY_FACT LSF 
			            inner join MONTH_DIM M on LSF.MONTH_ID = M.ID AND M.MONTH_NO <= MONTH(@DATE) AND M.YEAR_NO = YEAR(@DATE)
			            where lsf.LENDER_ID in (select distinct ld.ID 
			                                    from LENDER_DIM LD
						                              INNER JOIN AGENCY_DIM AD ON AD.ID = LD.AGENCY_ID --AND AD.CODE_TX <> 'FREIMARK'
						                          )
						   group by lsf.month_id
						  ) L on L.MONTH_ID = MD.ID
		WHERE MD.MONTH_NO <= MONTH(@DATE) AND MD.YEAR_NO = YEAR(@DATE)
	UNION
	   Select
			rfd.ROW_CD, 
			rfd.DESC_TX as [FUN],
			rfd.SORT_ORDER_NO as [FUNCTION_ORDER],
			'All' as [SERVICE_QUEUE],
			L.COUNT_NO,
			MONTH_NO,QUARTER_NO,YEAR_NO
		from Month_DIM MD
			inner Join REPORT_FUNCTION_DEF rfd on rfd.REPORT_CD = 'crbm' and rfd.REPORT_TABLE_CD = 'QP' and rfd.ROW_CD = 'QPIID'
			left Join (select lsf.MONTH_ID, sum(LSF.QP_INS_INFO_NO) as COUNT_NO 
			            from LENDER_SUMMARY_FACT LSF 
			            inner join MONTH_DIM M on LSF.MONTH_ID = M.ID AND M.MONTH_NO <= MONTH(@DATE) AND M.YEAR_NO = YEAR(@DATE)
			            where lsf.LENDER_ID in (select distinct ld.ID 
			                                    from LENDER_DIM LD
						                              INNER JOIN AGENCY_DIM AD ON AD.ID = LD.AGENCY_ID --AND AD.CODE_TX <> 'FREIMARK'
						                          )
						   group by lsf.month_id
						  ) L on L.MONTH_ID = MD.ID
		WHERE MD.MONTH_NO <= MONTH(@DATE) AND MD.YEAR_NO = YEAR(@DATE)
	UNION
	   Select
			rfd.ROW_CD, 
			rfd.DESC_TX as [FUN],
			rfd.SORT_ORDER_NO as [FUNCTION_ORDER],
			'All' as [SERVICE_QUEUE],
			L.COUNT_NO,
			MONTH_NO,QUARTER_NO,YEAR_NO
		from Month_DIM MD
			inner Join REPORT_FUNCTION_DEF rfd on rfd.REPORT_CD = 'crbm' and rfd.REPORT_TABLE_CD = 'QP' and rfd.ROW_CD = 'QPNOTES'
			left Join (select lsf.MONTH_ID, sum(LSF.QP_ADD_NOTE_NO) as COUNT_NO 
			            from LENDER_SUMMARY_FACT LSF 
			            inner join MONTH_DIM M on LSF.MONTH_ID = M.ID AND M.MONTH_NO <= MONTH(@DATE) AND M.YEAR_NO = YEAR(@DATE)
			            where lsf.LENDER_ID in (select distinct ld.ID 
			                                    from LENDER_DIM LD
						                              INNER JOIN AGENCY_DIM AD ON AD.ID = LD.AGENCY_ID --AND AD.CODE_TX <> 'FREIMARK'
						                          )
						   group by lsf.month_id
						  ) L on L.MONTH_ID = MD.ID
		WHERE MD.MONTH_NO <= MONTH(@DATE) AND MD.YEAR_NO = YEAR(@DATE)
	order by [FUNCTION_ORDER]
end
