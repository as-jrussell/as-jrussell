USE YourDatabaseName;  -- Replace with your actual database name

-- Create a stored procedure
CREATE PROCEDURE dbo.ExecuteScriptWithProxy
WITH EXECUTE AS 'ProxyAccountName'  -- Replace with the name of your proxy account
AS
BEGIN
    -- Define the script you want to execute
    DECLARE @Script NVARCHAR(MAX);
    SET @Script = N'
        -- Your script goes here
        -- For example, you can run a simple SQL command
        SELECT GETDATE() AS CurrentDateTime;
    ';

    -- Execute the script
    EXEC sp_executesql @Script;
END;
