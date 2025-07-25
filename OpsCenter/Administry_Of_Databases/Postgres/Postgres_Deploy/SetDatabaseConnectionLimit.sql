-- ================================================
-- FUNCTION: admin.SetDatabaseConnectionLimit
-- PURPOSE: Set a database's connection limit and log the change
-- ================================================

CREATE OR REPLACE FUNCTION admin.SetDatabaseConnectionLimit(
    target_db TEXT,
    connection_limit INT
)
RETURNS TEXT
LANGUAGE plpgsql
AS $$
DECLARE
    action_label TEXT;
    status_label TEXT := 'SUCCESS';
    command_executed TEXT;
BEGIN
    -- Build the SQL command
    command_executed := format('ALTER DATABASE %I CONNECTION LIMIT %s;', target_db, connection_limit);
    EXECUTE command_executed;

    -- Define action type
    action_label := CASE
        WHEN connection_limit = 0 THEN 'Set DB Offline'
        WHEN connection_limit = -1 THEN 'Set DB Online'
        ELSE 'Set DB Conn Limit: ' || connection_limit::TEXT
    END;

    -- Log the event
    INSERT INTO info.object_log_history (
        action_type,
        target_entity,
        associated_entity,
        status,
        sql_command,
        message
    )
    VALUES (
        action_label,
        target_db,
        current_user,
        status_label,
        command_executed,
        format('Connection limit set to %s', connection_limit)
    );

    RETURN format('Database %s connection limit set to %s', target_db, connection_limit);
END $$;
