---DBA database (not sold on name just throwing out here)
CREATE ROLE ghost_logger
    PASSWORD 'SomeRandomButLongPassword!'  -- This gets encrypted in the next step
    NOSUPERUSER
    NOCREATEDB
    NOCREATEROLE
    NOINHERIT
    LOGIN;  


-- Required for insert
GRANT USAGE ON SCHEMA info TO ghost_logger;
GRANT INSERT ON info.object_log_history TO ghost_logger;
GRANT USAGE, UPDATE ON SEQUENCE info.object_log_history_log_id_seq TO ghost_logger;



