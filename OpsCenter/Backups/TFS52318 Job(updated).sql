-- IMPLEMENTATION PLAN
-- ACC Correct Cancel Amounts
/*
Related TFS: TFS52318
Environment: Production
Server: ON-SQLCLSTPRD-1, ON-SQLCLSTPRD-2
*/
/*
    52318 - ACC Lender 5402 - Script to Correct Refunds
    CPI Act
    Cert Detail
    IH Prem Amt
*/
SET ANSI_NULLS, QUOTED_IDENTIFIER ON;
use unitrac
    -- Create Temp Table
if object_id('tempdb.dbo.#tmp','U')         is not null drop table #tmp
if object_id('tempdb.dbo.#tmp1cancel','U')  is not null drop table #tmp1cancel
if object_id('tempdb.dbo.#tmp2cancel','U')  is not null drop table #tmp2cancel
if object_id('tempdb.dbo.#tmp2','U')        is not null drop table #tmp2
if object_id('tempdb.dbo.#tmp3','U')        is not null drop table #tmp3
if object_id('tempdb.dbo.#tmp4','U')        is not null drop table #tmp4
declare @task varchar(15) = 'TFS52318'
declare @date           varchar(8)      = format( GETDATE(), 'yyyyMMdd', 'en-US' )
declare @time           varchar(6)      =  FORMAT(cast(GETDATE() as time), N'hhmmss');
declare @backout_name   varchar(100)    = 'HDTStorage.Unitrac.' + @task + '_' + @date + '_' + @time + '_Backout'
declare @FLAG_VERBOSE bit = 0   -- OFF FOR RUNNING AS AGENT JOB;
BEGIN /* temp table setup */
    select 
            fpc.NUMBER_TX, 
            fpc.id                  as FPC_ID, 
            cpiq.TOTAL_PREMIUM_NO   as TotalQuoteAmt, 
            fpc.EFFECTIVE_DT, 
            fpc.EXPIRATION_DT,
            TotalCancels.TotalCancelEntries, 
            cpiq.ID                 as IssueActID, 
            fpc.CPI_QUOTE_ID
    into 
            #tmp
    from    
            FORCE_PLACED_CERTIFICATE fpc
    join    
            CPI_ACTIVITY cpiq 
                on cpiq.CPI_QUOTE_ID            = fpc.CPI_QUOTE_ID 
                and cpiq.TYPE_CD                = 'I' 
                and cpiq.PURGE_DT               is null
                and cpiq.EXECUTION_STEPS_TX     is not null 
                and cpiq.EXECUTION_STEPS_TX     <> ''
    cross APPLY
    (
        select  
                count(*)        as TotalCancelEntries
        from    
                CPI_ACTIVITY 
        where   
                CPI_QUOTE_ID    = fpc.CPI_QUOTE_ID
                and TYPE_CD     = 'C' 
                and PURGE_DT    is null
    ) TotalCancels
    outer APPLY
    (
            select 
                    ID
            from 
                    CPI_ACTIVITY
            where 
                    CPI_QUOTE_ID  = fpc.CPI_QUOTE_ID
                    and TYPE_CD          = 'MT' 
                    and PURGE_DT  is null
    ) MTCancels
		where   fpc.MASTER_POLICY_ASSIGNMENT_ID IN (36750,41155) -- This is tied to the lender so will likely remain a constant
			and MTCancels.ID is null
    select * into #tmp1cancel from #tmp where TotalCancelEntries = 1
    select * into #tmp2cancel from #tmp where TotalCancelEntries > 1
    select 
            t.*, 
            c.TOTAL_PREMIUM_NO                          as CurrentCancelAmt,
            DATEDIFF(month, t.effective_dt, c.START_DT) as MonthDiff, 
            c.START_DT                                  as CancelStartDate, 
            c.id                                        as CancelActID,
            case
                when DATEADD(month, DATEDIFF(month, t.effective_dt, c.START_DT), t.effective_dt) < c.START_DT   then DATEDIFF(month, t.effective_dt, c.START_DT) + 1
                when DATEADD(month, DATEDIFF(month, t.effective_dt, c.START_DT), t.effective_dt) >= c.START_DT  then DATEDIFF(month, t.effective_dt, c.START_DT)
            end                                         as UsedTerms,
            replace(
            SUBSTRING(q.EXECUTION_STEPS_TX,CHARINDEX('MonthlyPremium=', q.EXECUTION_STEPS_TX),(CHARINDEX(', FirstMonthAddtl=',q.EXECUTION_STEPS_TX)-CHARINDEX('MonthlyPremium=', q.EXECUTION_STEPS_TX))),'MonthlyPremium=','') 
                                                        as MonthlyPremium ,
            replace(
            replace(
            replace(
            SUBSTRING(q.EXECUTION_STEPS_TX,CHARINDEX('FirstMonthAddtl=', q.EXECUTION_STEPS_TX),(CHARINDEX('PmtMethod',q.EXECUTION_STEPS_TX)-CHARINDEX('FirstMonthAddtl=', q.EXECUTION_STEPS_TX))),'FirstMonthAddtl=','') 
            ,CHAR(13),''), CHAR(10), '')                as FirstMonthAdditional
    into 
            #tmp2
    from    
            #tmp1cancel t
    join    
            CPI_ACTIVITY c on c.CPI_QUOTE_ID = t.cpi_quote_id and c.TYPE_CD = 'C' and c.PURGE_DT is null
    join    
            CPI_ACTIVITY q on q.ID = t.IssueActID
    select 
            *,
            (convert(int, t.usedTerms) * convert(decimal(5,2), t.monthlyPremium)) + convert(DECIMAL(5,2), t.firstmonthadditional)                               
                                                        as UsedPremium,
            (t.totalQuoteAmt - ((convert(int, t.usedTerms) * convert(decimal(5,2), t.monthlyPremium)) +  convert(DECIMAL(5,2), t.firstmonthadditional))) * -1   
                                                        as ShouldBeCancelAmt
    into    
            #tmp3
    from    
            #tmp2 t
    select  
        * 
    into 
        #tmp4 
    from 
        #tmp3 
    where 
        currentCancelAmt <> shouldbeCancelamt 
        and usedTerms > 0
        and (currentCancelAmt * -1) <> TotalQuoteAmt
END
if(@FLAG_VERBOSE = 1)
BEGIN /* before Check */
    select  
            '' 'CANCEL ACTIVITY - BEFORE UPDATE', 
            cpi.TOTAL_PREMIUM_NO,
            t.ShouldBeCancelAmt,
            *
    from 
            #tmp4 t
    join 
            CPI_ACTIVITY cpi on cpi.ID = t.CancelActID
    where 
            cpi.TOTAL_PREMIUM_NO <> t.shouldbeCancelamt
    select  
            '' 'CERT DETAIL - BEFORE UPDATE', 
            cd.AMOUNT_NO,
            t.ShouldBeCancelAmt,
            *
    from 
            #tmp4 t
    join 
            CERTIFICATE_DETAIL cd on cd.CPI_ACTIVITY_ID = t.CancelActID
    where 
            cd.AMOUNT_NO <> t.shouldbeCancelamt
    select 
            '' 'IH - BEFORE UPDATE', 
            SPECIAL_HANDLING_XML.value('(/SH/Premium)[1]', 'nvarchar(max)') as ihPremium, 
            ih.SPECIAL_HANDLING_XML, 
            ih.*
    from 
            INTERACTION_HISTORY ih
    join 
            #tmp4 t 
                on t.FPC_ID             = IH.RELATE_ID 
                and ih.RELATE_CLASS_TX  = 'Allied.UniTrac.ForcePlacedCertificate'
                and ih.TYPE_CD          = 'CPI'
END /* before Check */  
BEGIN /* Create Backout */
    create table #tmpBackout
    (
        ID              bigint,
        ACTIVITY_PREM   decimal (18,2),
        SH              XML,
        Table_name      varchar(30)
    )
    insert 
            into #tmpBackout
    select 
            cpi.ID, 
            cpi.TOTAL_PREMIUM_NO    as ACTIVITY_PREM, 
            NULL                    as SH, 
            'CPI_ACTIVITY'          as Table_Name
    from 
            #tmp4 t
    join 
            CPI_ACTIVITY cpi on cpi.ID = t.CancelActID
    insert 
            into #tmpBackout
    select 
            cd.ID, 
            cd.AMOUNT_NO            as ACTIVITY_PREM,
            null                    as SH, 
            'CERTIFICATE_DETAIL'    as Table_Name
    from 
            #tmp4 t
    join 
            CERTIFICATE_DETAIL cd on cd.CPI_ACTIVITY_ID = t.CancelActID
    insert 
            into #tmpBackout
    select 
            ih.id, 
            null                    as ACTIVITY_PREM,
            SPECIAL_HANDLING_XML    as SH, 
            'INTERACTION_HISTORY'   as Table_Name
    from 
            INTERACTION_HISTORY ih
    join 
            #tmp4 t 
                on t.FPC_ID             = IH.RELATE_ID 
                and ih.RELATE_CLASS_TX  = 'Allied.UniTrac.ForcePlacedCertificate'
                and ih.TYPE_CD          = 'CPI'
    -- Used so that the name for the backout table changes each day this is run
    exec('select * into ' + @backout_name + ' from #tmpBackout')
END /* Create Backout */
BEGIN /*Apply Update */
    update 
            cpi 
    set 
            TOTAL_PREMIUM_NO    = t.ShouldBeCancelAmt,
            UPDATE_DT           = getdate(), 
            UPDATE_USER_TX      = @task, 
            LOCK_ID             = (LOCK_ID % 255 ) + 1
    from 
            #tmp4 t
    join 
            CPI_ACTIVITY cpi on cpi.ID = t.CancelActID
    update 
            cd 
    set 
            AMOUNT_NO           = t.ShouldBeCancelAmt,
            UPDATE_DT           = getdate(), 
            UPDATE_USER_TX      = @task, 
            LOCK_ID             = (LOCK_ID % 255 ) + 1
    from 
            #tmp4 t
    join 
            CERTIFICATE_DETAIL cd on cd.CPI_ACTIVITY_ID = t.CancelActID
    update 
            ih 
    set      
            SPECIAL_HANDLING_XML.modify('replace value of (/SH/Premium/text())[1] with sql:column("t.UsedPremium")'),
            UPDATE_DT           = getdate(), 
            UPDATE_USER_TX      = @task, 
            LOCK_ID             = (ih.LOCK_ID % 255 ) + 1
    from 
            INTERACTION_HISTORY ih
    join 
            #tmp4 t 
                on t.FPC_ID             = IH.RELATE_ID 
                and ih.RELATE_CLASS_TX  = 'Allied.UniTrac.ForcePlacedCertificate'
                and ih.TYPE_CD          = 'CPI'
END /*Apply Update */
if(@FLAG_VERBOSE = 1)
BEGIN /* after Check */
    select  
            '' 'CANCEL ACTIVITY - AFTER UPDATE', 
            cpi.TOTAL_PREMIUM_NO,
            t.ShouldBeCancelAmt,
            *
    from 
            #tmp4 t
    join 
            CPI_ACTIVITY cpi on cpi.ID = t.CancelActID
    select  
            '' 'CERT DETAIL - AFTER UPDATE', 
            cd.AMOUNT_NO,
            t.ShouldBeCancelAmt,
            *
    from 
            #tmp4 t
    join 
            CERTIFICATE_DETAIL cd on cd.CPI_ACTIVITY_ID = t.CancelActID
    select 
            '' 'IH - BEFORE UPDATE', 
            SPECIAL_HANDLING_XML.value('(/SH/Premium)[1]', 'nvarchar(max)') as ihPremium, 
            ih.SPECIAL_HANDLING_XML, 
            ih.*
    from 
            INTERACTION_HISTORY ih
    join 
            #tmp4 t 
                on t.FPC_ID             = IH.RELATE_ID 
                and ih.RELATE_CLASS_TX  = 'Allied.UniTrac.ForcePlacedCertificate'
                and ih.TYPE_CD          = 'CPI'
END /* after Check */