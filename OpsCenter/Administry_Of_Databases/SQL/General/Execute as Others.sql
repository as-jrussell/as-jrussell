/*--Per Database
--EXECUTE AS user = ''

--Per Instance
EXECUTE AS Login = ''

--Verify the execution context is now login1.  
SELECT SUSER_NAME(), USER_NAME();  

--Display current execution context.  
SELECT SUSER_NAME(), USER_NAME();  
-- The execution context stack now has three principals: the originating caller, login1 and login2.  
--The following REVERT statements will reset the execution context to the previous context.  
REVERT;  
--Display current execution context.  
SELECT SUSER_NAME(), USER_NAME();  
REVERT;  
--Display current execution context.  
SELECT SUSER_NAME(), USER_NAME();  
  */



  
-- Set up your script as a variable
DECLARE @Script NVARCHAR(2000)
DECLARE @AccountName NVARCHAR(100) = ''
DECLARE @DatabaseName SYSNAME = ''
DECLARE @WhatIf BIT = 0
SET @Script = N' 

  use ['+@DatabaseName +'] SELECT SUSER_NAME()[Login Name], USER_NAME() [User Name], DB_NAME()[Database Name]


';

-- Execute the script with the specified Windows AD account
IF @WhatIf = 0
BEGIN
EXECUTE AS LOGIN = @AccountName; -- Replace with the AD account name
EXEC sp_executesql @Script;
REVERT;
END
ELSE 
BEGIN
PRINT( @AccountName); -- Replace with the AD account name
PRINT 'EXEC sp_executesql '+@Script+''
END


