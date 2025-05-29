-- Create a fake linked server using a valid provider and fake server details
EXEC sp_addlinkedserver   
    @server = N'FakeLinkedServer2',   
    @srvproduct = N'FakeSQL',  -- MUST be anything BUT 'SQL Server'
    @provider = N'SQLNCLI11',  -- Or 'SQLNCLI', 'MSOLEDBSQL', 'SQLNCLI10' depending on your installed providers
    @datasrc = N'127.0.0.1\BogusInstance';  -- Invalid/bogus instance name is fine

-- Add login mapping (won’t connect anyway)
EXEC sp_addlinkedsrvlogin   
    @rmtsrvname = N'FakeLinkedServer2',   
    @useself = N'False',   
    @locallogin = NULL,   
    @rmtuser = N'NotReal',   
    @rmtpassword = N'Nope123!';
