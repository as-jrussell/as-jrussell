USE [Unitrac_Reports]
GO

/****** Object:  UserDefinedFunction [dbo].[fn_PaymentPeriodGenerator]    Script Date: 2/15/2018 2:37:53 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



Create FUNCTION [dbo].[fn_PaymentPeriodGenerator] (
@FPC_ID bigint,
@TERM_NO int = 0
)

RETURNS DECIMAL(18,2)
AS
BEGIN

declare @totalpayment decimal(19,2) = 0;
declare @runningpaymenttotal decimal(19,2) = 0;
declare @payment decimal(19,2) = 0;
declare @fpcid int = @FPC_ID;
declare @return_payment decimal(19,2) = 0;
 
select @totalpayment =  sum(ft.amount_no) from FORCE_PLACED_CERTIFICATE fpc
inner join FINANCIAL_TXN ft on ft.FPC_ID = fpc.id
       and ft.PURGE_DT is null
       and ft.TXN_TYPE_CD in ('P')
where
fpc.id = @fpcid
group by ft.FPC_ID
 

DECLARE @Temp1 TABLE(
    term varchar(5) ,
    charges decimal(19,2),
	payments decimal(19,2)
);


insert into @Temp1
select ft.TERM_NO, sum(ft.amount_no) as charges, @payment as payments
from FORCE_PLACED_CERTIFICATE fpc
inner join FINANCIAL_TXN ft on ft.FPC_ID = fpc.id
       and ft.PURGE_DT is null
       and ft.TXN_TYPE_CD in ('R','C','CP')
where
fpc.id = @fpcid
group by ft.TERM_NO
order by ft.TERM_NO

SET @runningpaymenttotal = @totalpayment
 
DECLARE @chargeCount INT
SELECT @chargeCount = COUNT(*) FROM @Temp1
DECLARE @term INT
SET @term = 1
 
WHILE @term <= @chargeCount 
BEGIN
        DECLARE @charges decimal(19,2) = 0;
        SELECT @charges = charges FROM @Temp1 WHERE term = @term
 
        IF ABS(@runningpaymenttotal) > @charges
        BEGIN
               SET @runningpaymenttotal = @runningpaymenttotal + @charges
               UPDATE @Temp1
               SET payments = @charges
               WHERE term = @term
        END
        ELSE IF ABS(@runningpaymenttotal) >= 0
        BEGIN
               UPDATE @Temp1
               SET payments = ABS(@runningpaymenttotal)
                WHERE term = @term
 
               SET @runningpaymenttotal = 0
        END
        SET @term = @term + 1
END
select @return_payment = t1.payments from @Temp1 t1 where t1.term = @TERM_NO
return @return_payment
END


GO

