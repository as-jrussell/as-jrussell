DECLARE @auth_mode INT;

EXEC xp_instance_regread 
    N'HKEY_LOCAL_MACHINE', 
    N'Software\Microsoft\MSSQLServer\MSSQLServer', 
    N'LoginMode', 
    @auth_mode OUTPUT;

SELECT 
    CASE @auth_mode 
        WHEN 1 THEN 'Windows Authentication'
        WHEN 2 THEN 'SQL Server and Windows Authentication'
        ELSE 'Unknown Authentication Mode'
    END AS AuthenticationMode;
