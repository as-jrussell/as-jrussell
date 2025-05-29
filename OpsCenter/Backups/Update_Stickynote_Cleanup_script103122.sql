USE [IVOS]
GO

BEGIN TRAN;
/* Declare variables */
DECLARE @Ticket NVARCHAR(15) =N'test1_10312022'; --change to ticket #

--Batch denotes how many rows will be deleted each loop.
DECLARE @batch INT = 4000;
DECLARE @counter INT;
DECLARE @total_rows INT;
DECLARE @RowsToChange INT;
DECLARE @SourceDatabase NVARCHAR(100) = 'IVOS' /* This will be the schema in HDTStorage */;

/* Temp table creation */

IF EXISTS(SELECT [name] FROM tempdb.sys.tables WHERE [name] like '#SN_Cleanup%') 
BEGIN
   DROP TABLE #SN_Cleanup ;
END; 


with g1 as (
Select Row_Number() over (partition by sticky_note_file_name order by sticky_note_id) as grank,* from sticky_note
where add_Date > '10/7/2022' 
and sticky_note_overview = 'Police Report'
and add_user = 'IVOS_WebAPI'
),
g2 as (
	Select distinct claim_id from g1
	where claim_id in(
		1548554
		,1548575
		,1548580
		,1548581
		,1548594
		,1548600
		,1548601
		,1548603
		,1548604
		,1548609
		,1548610
		,1548611
		,1548613
		,1548614
		,1548625
		,1548638
		,1548649
		,1548658
		,1548659
		,1548661
		,1548667
		,1548668
		,1548674
		,1548676
		,1548678
		,1548680
		,1548682
		,1548686
		,1548687
		,1548689
		,1548690
		,1548699
		,1548701
		,1548705
		,1548707
		,1548716
		,1548717
		,1548720
		,1548732
		,1548734
		,1548751
		,1548762
		,1548772
		,1548777
		,1548779
		,1548796
		,1548802
		,1548804
		,1548806
		,1548807
		,1548815
		,1548825
		,1548827
		,1548832
		,1548851
		,1548852
		,1548867
		,1548870
		,1548874
		,1548893
		,1548898
		,1548899
		,1548913
		,1548923
		,1548928
		,1548935
		,1548937
		,1548942
		,1548955
		,1548956
		,1548959
		,1549065
		,1549069
		,1549071
		,1549077
		,1549087
		,1549090
		,1549097
		,1549100
		,1549101
		,1549110
		,1549121
		,1549124
		,1549127
		,1549139
		,1549140
		,1549142
		,1549144
		,1549147
		,1549148
		,1549151
		,1549154
		,1549157
		,1549159
		,1549160
		,1549161
		,1549171
		,1549182
		,1549183
		,1549189
		,1549208
		,1549210
		,1549213
		,1549215
		,1549218
		,1549248
		,1549257
		,1549262
		,1549272
		,1549275
		,1549280
		,1549282
		,1549287
		,1549290
		,1549291
		,1549295
	 )
),
_data as (
Select Row_Number() over (partition by sticky_note_file_name order by sticky_note_id) as grank, sn.* from sticky_note sn
inner join g2 on g2.claim_id = sn.claim_id
where add_Date > '10/7/2022'
and sticky_note_overview = 'Police Report'
and add_user = 'IVOS_WebAPI'
)

select *
into #SN_Cleanup
from _data
where grank > 1

/* Step 1 - Calculate rows to be changed - same query as populate Storage table */

select @RowsToChange = count(*)
from #SN_Cleanup

/* Existence check for Storage tables - Exit if they exist */
IF NOT EXISTS (SELECT *
               FROM HDTStorage.sys.tables   
               WHERE name like  @Ticket+'_sticky_note'+'%' AND type IN (N'U'))
	BEGIN

    	/* populate new Storage table from Sources */
    	EXEC(
		'SELECT * into HDTStorage.'+@SourceDatabase+'.'+@Ticket+'_sticky_note
  		FROM #SN_Cleanup')
  
    	/* Does Storage Table meet expectations */
	IF( @@RowCount =  @RowsToChange )
		BEGIN
			PRINT 'Storage table meets expections - continue'

			/* Step 3 - Perform table update */
			SET @counter = 1;
			SET @total_rows = 0;
			WHILE (@counter > 0 AND @total_rows < @RowsToChange)

			BEGIN 

			UPDATE TOP(@batch) sn
			SET claim_id = '1560362'
			FROM sticky_note sn
  			INNER JOIN #SN_Cleanup snc on sn.sticky_note_id = snc.sticky_note_id
			WHERE sn.claim_id <> '1560362'

            SET @counter = @@ROWCOUNT
			SET @total_rows = @total_rows + @counter

			INSERT INTO [HDTStorage].[dbo].[DeleteRecords]
           ( [TableName], [Counter], [total_rows], [RowsToChange], [DateTimeStamp] )
			VALUES
           ( 'sticky_note', @counter, @total_rows, @RowsToChange, getdate() )
            END

        		/* Step 4 - Inspect results - Commit/Rollback */
			IF ( @total_rows = @RowsToChange )
		  		BEGIN
		    			PRINT 'SUCCESS - Performing commit'
		    			COMMIT;
		  		END
			ELSE
		  		BEGIN
		    			PRINT 'FAILED TO UPDATE - Performing Rollback'
		    			ROLLBACK;
		  		END
			END
		ELSE
      		BEGIN
        		PRINT 'Storage does not meet expectations - rollback'
			ROLLBACK;
			END
	END
	ELSE
	BEGIN
		PRINT 'HD TABLE EXISTS - Stop work'
		COMMIT;
	END