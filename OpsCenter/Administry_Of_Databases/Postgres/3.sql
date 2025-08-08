---Customer database (not sold on name just throwing out here)

GRANT EXECUTE ON FUNCTION dba.log_to_dba(text, text, text, text, text) TO ghost_logger;
GRANT EXECUTE ON FUNCTION dba.createschemawithpermissions(text, text, text[], boolean) TO ghost_logger;
GRANT EXECUTE ON FUNCTION pgp_sym_decrypt(bytea, text) TO ghost_logger;



INSERT INTO dba.dba_credentials (dbname, username, encrypted_password)
VALUES (
    'DBA',
    'ghost_logger',
    pgp_sym_encrypt('SomeRandomButLongPassword!', 'UltraSecretKey2025')
);


