--Adding endpoint first
/*
IF NOT EXISTS (SELECT * from sys.endpoints WHERE [name] = 'Hadr_endpoint')
    BEGIN
        CREATE ENDPOINT [Hadr_endpoint]
            STATE=STARTED
            AS TCP (LISTENER_PORT = 5022, LISTENER_IP = ALL)
            FOR DATA_MIRRORING (ROLE = ALL, AUTHENTICATION = WINDOWS NEGOTIATE
        , ENCRYPTION = REQUIRED ALGORITHM AES)
    END;




    use [master]

GO

GRANT CONNECT ON ENDPOINT::[Hadr_endpoint] TO [ELDREDGE_A\OCRSQL-TEST]

GO


    IF (SELECT state FROM sys.endpoints WHERE name = N'Hadr_endpoint') <> 0
BEGIN
    ALTER ENDPOINT [Hadr_endpoint] STATE = STARTED
END
 
 */


-- SELECT servicename, process_id, startup_type_desc, status_desc,
last_startup_time, service_account
FROM sys.dm_server_services WITH (NOLOCK) OPTION (RECOMPILE);