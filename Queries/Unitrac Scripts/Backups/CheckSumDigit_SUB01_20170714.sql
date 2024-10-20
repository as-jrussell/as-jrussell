USE [Unitrac_Reports]
GO
/****** Object:  UserDefinedFunction [dbo].[CheckSumDigit]    Script Date: 7/14/2017 1:16:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER function [dbo].[CheckSumDigit] (@codevalue bigint)
returns  Int
as 
 begin 
  declare @barCodeCheckRes Int
  declare @idx     tinyInt
  declare @sgn     Int
  Declare @codetext as varchar(50)
  
  set   @barCodeCheckRes = 0
  
  Set @codetext = ltrim(rtrim(str(@codevalue,50,0)))
/*  
  if @codetext is NULL 
    Set @codetext = ''
    
  if len(@codetext) > 12
    Set @codetext = right(@codetext,12)
   else
     Begin
	   Set @codetext = replace(space(12 - len(@codetext)),' ','0')
     End 
 */   

  set @idx = 1
  while (@idx <= len(@codetext))
  begin 
     -- Calculate sign of digit (- for even digit and + for an odd digit 
     if ((@idx % 2) = 0) 
 set @sgn = -1
     else 
        set @sgn = +1
     set  @barCodeCheckRes = @barCodeCheckRes +
             convert (tinyInt, substring (@codetext,@idx,1)) * @sgn
     set @idx = @idx + 1    
  end 
  -- return the resulting digit,
  return ( abs(@barCodeCheckRes % 10))
end 
