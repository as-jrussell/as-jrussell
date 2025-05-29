USE UniTrac_DW

SELECT DD.YEAR_NO, DD.MONTH_NO, SUM(InHouse_No) AS SUM_VALUE
--SELECT LENDER_ID, COUNT(*)
--SELECT *
				from DATE_DIM DD 
					INNER JOIN NOTICE_FACT NF ON NF.DATE_ID = DD.ID  AND DD.YEAR_NO = '2016' --AND MONTH_NO = '2'
					inner join CENTER_DIM cd on cd.ID = NF.CENTER_ID and cd.CODE_TX <> 'AS/DALLAS1'
					inner join AGENCY_DIM ad on ad.ID = cd.AGENCY_ID and ad.CODE_TX <> 'FREIMARK'
					GROUP by DD.YEAR_NO, DD.MONTH_NO
					--GROUP BY LENDER_ID ORDER BY COUNT(*) DESC 
				--	ORDER BY INHOUSE_NO DESC  


					--UT_GetNoticeDataPoints
					--exec GetProcessingStatsSumSubReport @DATE='2017-01-01 00:00:00' 