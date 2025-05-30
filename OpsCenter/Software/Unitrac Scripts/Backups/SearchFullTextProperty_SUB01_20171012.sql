USE [Unitrac_Reports]
GO

/****** Object:  StoredProcedure [dbo].[SearchFullTextProperty]    Script Date: 10/12/2017 3:00:44 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--EXEC [SearchFullTextProperty]  @searchText='("john*" or formsof(thesaurus, "john"))'
--EXEC [SearchFullTextProperty]   @searchText='("john*" or formsof(thesaurus, "john")) and ("2010*" or formsof(thesaurus, "2010"))'
CREATE PROCEDURE [dbo].[SearchFullTextProperty]
(
   @userId bigint = null,
   @lenderId bigint = null, 
   @includeUTL char(1) = 'Y',
   @includeArchive char(1) = 'Y',
   @searchText NVARCHAR(4000) = null,
   @propertyNumber int = null,
   @pageNumber int = null,
   @useLenderGrouping char(1) = 'Y',
   @userBranch nvarchar(200) = null,		
   @userDealer nvarchar(200) = null			
)
AS 
BEGIN

   IF @userBranch = ''			
		set @userBranch = null

   IF @userDealer = ''			
		set @userDealer = null

   SET NOCOUNT ON

   declare @sql nvarchar(max)
	
	CREATE table #tmpSearch 
   (
      ID          BIGINT,
      AGENCY_ID   BIGINT,
      LENDER_ID   BIGINT,
      ADDRESS_ID  BIGINT null,
      YEAR_TX         nvarchar(4) null,
      MAKE_TX         nvarchar(30) null,
      MODEL_TX        nvarchar(30) null,
      VIN_TX          nvarchar(18) null,
      TITLE_CD        char(1) null,
      DESCRIPTION_TX  nvarchar(100) null,
      NUMBER_TX          nvarchar(18) null,
      ROWNUMBER   BIGINT,
      NUMBEROFROWS   BIGINT,
      PAGENUMBER   BIGINT,
      NUMBEROFPAGES   BIGINT,
      RECORD_TYPE_CD char(1)
   )
	
		
	DECLARE @insert nVARCHAR(MAX)
	DECLARE @select nVARCHAR(MAX)
	DECLARE @joins nVARCHAR(MAX)
	DECLARE @where nVARCHAR(MAX)
	DECLARE @order nVARCHAR(MAX)
	DECLARE @query nVARCHAR(MAX)

	SELECT @insert = '
		insert into #tmpSearch(ID,
                        AGENCY_ID,
                        LENDER_ID,
                        ADDRESS_ID,
                        YEAR_TX,
                        MAKE_TX,
                        MODEL_TX,
                        VIN_TX,
                        TITLE_CD,
                        DESCRIPTION_TX,
                        RECORD_TYPE_CD,
                        NUMBER_TX,
                        ROWNUMBER,
                        NUMBEROFROWS,
                        PAGENUMBER,
                        NUMBEROFPAGES)
	'
   select @select = '
			select top 100 p.ID as ''PROPERTY_ID'',
			p.AGENCY_ID, p.LENDER_ID,  p.ADDRESS_ID,
			p.YEAR_TX, p.MAKE_TX,  p.MODEL_TX, p.VIN_TX,
			p.TITLE_CD, p.DESCRIPTION_TX, p.RECORD_TYPE_CD,
			null,null,null,null,null
	'
   select @where = '
			where CONTAINS ( ft.KEY_WORD, @searchText )
			' + case when @useLenderGrouping = 'Y' and isnull(@lenderid, 0) <> 0 then '' 
			         when isnull(@lenderid, 0) <> 0 then ' AND ft.lender_id = @lenderID ' 
				     else '' end
			+ '
			and p.PURGE_DT is null 
            and p.RECORD_TYPE_CD IN  (''G'''
			  + case when @includeUTL = 'Y' then ', ''E'', ''I'', ''U''' else '' end
			  + case when @includeArchive = 'Y' then ', ''A''' else '' end
			  + ')
	'
   select @joins = '
		from PROPERTY p 
		join SEARCH_FULLTEXT ft on ft.PROPERTY_ID = p.id 
	'
	select @order = ' '

   IF ( isnull(@searchText, '') <> '') AND @pageNumber is null
   BEGIN
      if (isnull(@lenderId, 0) <= 0 and @userId > 0)
      begin
		   select @joins = @joins + '
         INNER JOIN dbo.AGENCY_USER_RELATE AUR  ON AUR.AGENCY_ID = p.AGENCY_ID AND AUR.PURGE_DT IS NULL and AUR.USER_ID = @userId
			'
      end
      else if(@lenderId > 0)
      begin
        select @joins = @joins + case @useLenderGrouping when 'Y' then '
         join (select * from fnGetLenderGroupLenderIdsForLender( @lenderId, @useLenderGrouping )) res on res.LENDER_ID = ft.LENDER_ID
			'
			else '' end
      end
	  --ELSE
	  --BEGIN
	  --END
   END ELSE IF ( isnull(@searchText, '') <> '') AND @lenderId > 0
   BEGIN
      BEGIN
			DECLARE @insert2 nVARCHAR(MAX)
			DECLARE @select2 nVARCHAR(MAX)
			DECLARE @joins2 nVARCHAR(MAX)
			DECLARE @where2 nVARCHAR(MAX)

         CREATE TABLE  #tmpSearch2 
         (
           PROPERTY_ID BIGINT,
           AGENCY_ID   BIGINT,
           LENDER_ID   BIGINT,
           ADDRESS_ID  BIGINT null,
           YEAR_TX         nvarchar(4) null,
           MAKE_TX         nvarchar(30) null,
           MODEL_TX        nvarchar(30) null,
           VIN_TX          nvarchar(18) null,
           TITLE_CD        char(1) null,
           DESCRIPTION_TX  nvarchar(100) null,
           NUMBER_TX         nvarchar(18) null,
           ROWNUMBER   BIGINT,
           NUMBEROFROWS   BIGINT,
           PAGENUMBER   BIGINT,
           NUMBEROFPAGES   BIGINT,
           RECORD_TYPE_CD char(1)
         )

         select @insert2 = '
				INSERT  INTO #tmpSearch2
				(PROPERTY_ID,
				AGENCY_ID,
				LENDER_ID,
				ADDRESS_ID,
				YEAR_TX,
				MAKE_TX,
				MODEL_TX,
				VIN_TX,
				TITLE_CD,
				DESCRIPTION_TX,
				RECORD_TYPE_CD,
				NUMBER_TX)
			'
         select @select2 = '
			SELECT p.ID as ''PROPERTY_ID'',
            p.AGENCY_ID,
            p.LENDER_ID,
            ADDRESS_ID,
            YEAR_TX,
            MAKE_TX,
            MODEL_TX,
            VIN_TX,
            TITLE_CD,
            DESCRIPTION_TX,
            p.RECORD_TYPE_CD,
            NUMBER_TX
			'
         select @joins2 = '
			   from PROPERTY p 
            INNER JOIN dbo.COLLATERAL C  ON P.ID = C.PROPERTY_ID AND C.PURGE_DT IS NULL
            INNER JOIN dbo.LOAN L1  ON C.LOAN_ID = L1.ID AND L1.PURGE_DT IS NULL AND L1.RECORD_TYPE_CD <> ''D''
				join SEARCH_FULLTEXT ft on ft.PROPERTY_ID = p.id 
		    ' + case @useLenderGrouping when 'Y' then '
            join (select * from fnGetLenderGroupLenderIdsForLender( @lenderId, @useLenderGrouping )) res on res.LENDER_ID = ft.LENDER_ID
			'
			else '' end + '
            where CONTAINS ( ft.KEY_WORD, @searchText )
            and L1.RECORD_TYPE_CD IN  (''G'''
			  + case when @includeUTL = 'Y' then ', ''E'', ''I'', ''U''' else '' end
			  + case when @includeArchive = 'Y' then ', ''A''' else '' end
			  + ')
            AND p.PURGE_DT is null 
			AND p.RECORD_TYPE_CD <> ''D''
			'
			+ case when @useLenderGrouping = 'Y' and isnull(@lenderid, 0) <> 0 then '' 
			       when isnull(@lenderid, 0) <> 0 then ' AND ft.lender_id = @lenderID ' 
				   else '' end
			+ CASE WHEN @userBranch is null then '' else ' AND L1.LENDER_BRANCH_CODE_TX = @userBranch' END
			+ CASE WHEN @userDealer is null then '' else ' AND L1.DEALER_CODE_TX = @userDealer' END
         --select @order2 = ' ORDER BY L1.NUMBER_TX'

			select @query = @insert2 + @select2 + @joins2
			--select @searchText searchText, @lenderId lenderId, @useLenderGrouping useLenderGrouping, @userBranch userBranch, @userDealer userDealer, @query query

			exec sys.sp_executesql @query, 
			N'@userId bigint, @lenderId bigint, @includeUTL char(1),  @includeArchive char(1), @searchText NVARCHAR(4000), @propertyNumber int, @pageNumber int, @useLenderGrouping char(1)',
			@userId, @lenderId, @includeUTL,  @includeArchive, @searchText, @propertyNumber, @pageNumber, @useLenderGrouping

      END
      BEGIN
            SELECT
				PROPERTY_ID,
				AGENCY_ID,
				LENDER_ID,
				ADDRESS_ID,
				YEAR_TX,
				MAKE_TX,
				MODEL_TX,
				VIN_TX,
				TITLE_CD,
				DESCRIPTION_TX,
				RECORD_TYPE_CD,
				NUMBER_TX, 
				ROW_NUMBER() OVER(ORDER BY NUMBER_TX) AS ROWNUMBER,
				(select count(*) from #tmpSearch2) as NUMBEROFROWS
			into #loanList
			FROM #tmpSearch2

            select @select = '
				SELECT ll.*, @pageNumber as PAGENUMBER, (NUMBEROFROWS / @propertyNumber) + 1 AS NUMBEROFPAGES 
				'
            select @joins = '
				FROM #loanList ll
				'
            select @where = '
				WHERE ROWNUMBER BETWEEN (1 + ((@pageNumber - 1) * @propertyNumber)) AND (@pageNumber * @propertyNumber) 
				' 
            select @order = '
				ORDER BY ll.NUMBER_TX
				'
      END
   END

	select @query = @insert + @select + @joins + @where + @order	

--select 'query1' = @query

	exec sys.sp_executesql @query, 
     N'@userId bigint, @lenderId bigint, @includeUTL char(1),  @includeArchive char(1), @searchText NVARCHAR(4000), @propertyNumber int, @pageNumber int, @useLenderGrouping char(1)',
	 @userId, @lenderId, @includeUTL,  @includeArchive, @searchText, @propertyNumber, @pageNumber, @useLenderGrouping

   select @select = '
		SELECT distinct TOP 100
      P1.AGENCY_ID ,
      P1.LENDER_ID ,
      C.ID as COLLATERAL_ID,
      RC.ID AS REQUIRED_COVERAGE_ID,
      CASE WHEN L1.RECORD_TYPE_CD IN (''E'', ''I'', ''U'') THEN ''Y'' ELSE ''N'' END AS UTL_IN,
      L1.ID AS LOAN_ID,
      L1.NUMBER_TX AS LOAN_NUMBER_TX ,
      L1.STATUS_CD AS LOAN_STATUS_CD,
      L1.RECORD_TYPE_CD as LOAN_RECORD_TYPE_CD,
      L1.EXTRACT_UNMATCH_COUNT_NO AS LOAN_UNMATCH_COUNT_NO,
      Temp.BORROWER_NAMES_TX,
      P1.id AS PROPERTY_ID ,
      isnull(OA.LINE_1_TX,'''') + '' '' + isnull(OA.CITY_TX,'''') + '' '' + isnull(OA.STATE_PROV_TX,'''') + '' '' + isnull(OA.POSTAL_CODE_TX,'''') AS ADDRESS_TX,
      isnull(P1.YEAR_TX, '''') + '' '' + isnull(P1.MAKE_TX, '''') + '' '' + isnull(P1.MODEL_TX, '''') + '' '' + isnull(P1.VIN_TX, '''') AS VEHICLE_DESCRIPTION_TX,
      P1.DESCRIPTION_TX AS PROPERTY_DESCRIPTION_TX,
      OA.LINE_1_TX,
      OA.CITY_TX,
      OA.STATE_PROV_TX,
      OA.POSTAL_CODE_TX,
      P1.YEAR_TX,
      P1.MAKE_TX,
      P1.MODEL_TX,
      P1.VIN_TX,
      P1.TITLE_CD,
      RCA.VALUE_TX AS PROPERY_TYPE_CD,
      C.STATUS_CD AS COLLATERAL_STATUS_CD,
      P1.RECORD_TYPE_CD as PROPERTY_RECORD_TYPE_CD,
      RC.TYPE_CD as COVERAGE_TYPE_CD,
      RC.STATUS_CD as COVERAGE_STATUS_CD,
      OP.BIC_NAME_TX AS INSURANCE_TX,
      OP.POLICY_NUMBER_TX AS INSURANCE_NUMBER_TX,
      OP.MAIL_DT AS MAIL_DT,
      OP.CANCELLATION_DT,
      RC.SUMMARY_STATUS_CD as SUMMARY_STATUS_CD,
      RC.SUMMARY_SUB_STATUS_CD as SUMMARY_SUB_STATUS_CD,
      RC.RECORD_TYPE_CD as COVERAGE_RECORD_TYPE_CD,
      LD.CODE_TX AS LENDER_CODE_TX,
      LD.NAME_TX AS LENDER_NAME_TX,
      LD.TAX_ID_TX,
      '''' AS OTHER_TX,
      P1.PAGENUMBER,
      P1.NUMBEROFPAGES
	'
   select @joins = '
		FROM #tmpSearch P1
      INNER JOIN dbo.COLLATERAL C  ON P1.ID = C.PROPERTY_ID AND C.PURGE_DT IS NULL
      INNER JOIN dbo.LENDER LD  ON LD.ID = P1.LENDER_ID AND LD.PURGE_DT IS NULL
      INNER JOIN dbo.COLLATERAL_CODE CC  on CC.ID = C.COLLATERAL_CODE_ID AND CC.PURGE_DT IS NULL
      INNER JOIN dbo.LOAN L1  ON C.LOAN_ID = L1.ID AND L1.PURGE_DT IS NULL AND L1.RECORD_TYPE_CD <> ''D''
      LEFT OUTER JOIN dbo.OWNER_ADDRESS OA  ON OA.ID = P1.ADDRESS_ID AND OA.PURGE_DT IS NULL
      LEFT OUTER JOIN dbo.REF_CODE_ATTRIBUTE RCA  ON RCA.DOMAIN_CD = ''SecondaryClassification'' AND RCA.REF_CD = CC.SECONDARY_CLASS_CD AND RCA.ATTRIBUTE_CD=''PropertyType''
      CROSS APPLY ( select (SELECT isnull(O.FIRST_NAME_TX, '''') + '' '' + isnull(O.LAST_NAME_TX, '''') + '';''
							FROM dbo.OWNER_LOAN_RELATE olr 
							INNER JOIN dbo.[OWNER] O on olr.OWNER_ID = O.ID AND O.PURGE_DT IS NULL
							WHERE olr.LOAN_ID = l1.ID 
							AND olr.PURGE_DT is null
							ORDER BY olr.PRIMARY_IN desc, olr.id
                  FOR XML PATH(''''), type).value(''.'', ''nvarchar(max)'') )  Temp ( BORROWER_NAMES_TX )
      LEFT OUTER JOIN dbo.REQUIRED_COVERAGE RC  ON P1.id = RC.PROPERTY_ID AND RC.PURGE_DT IS NULL
                                                                and rc.RECORD_TYPE_CD <> ''D''
      outer apply GetCurrentCoverage(P1.ID, rc.ID, rc.TYPE_CD) OP
	'
   select @where = '
        WHERE L1.RECORD_TYPE_CD IN  (''G'''
			  + case when @includeUTL = 'Y' then ', ''E'', ''I'', ''U''' else '' end
			  + case when @includeArchive = 'Y' then ', ''A''' else '' end
			  + ')
		'
		+ CASE WHEN @userBranch is null then '' else ' AND L1.LENDER_BRANCH_CODE_TX = @userBranch' END
		+ CASE WHEN @userDealer is null then '' else ' AND L1.DEALER_CODE_TX = @userDealer' END
	select @order = '
		ORDER BY L1.ID, L1.NUMBER_TX, Temp.BORROWER_NAMES_TX
	'
	select @query = @select + @joins + @where + @order	
--	select @query as 'query2'

	exec sys.sp_executesql @query, 
   N'@includeUTL char(1),  @includeArchive char(1),  @userBranch nvarchar(200),	@userDealer nvarchar(200)',
	@includeUTL, @includeArchive, @userBranch, @userDealer

END

GO

