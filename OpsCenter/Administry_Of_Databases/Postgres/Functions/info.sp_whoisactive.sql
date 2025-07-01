CREATE OR REPLACE FUNCTION info.sp_whoisactive (
    p_database_name TEXT DEFAULT NULL,
    p_show_idle_in_transaction BOOLEAN DEFAULT FALSE,
    p_show_all_idle BOOLEAN DEFAULT FALSE
)
RETURNS TABLE (
    duration INTERVAL,
    pid INT,
    datname NAME,
    usename NAME,
    application_name TEXT,
    client_addr INET,
    backend_start TIMESTAMPTZ,
    xact_start TIMESTAMPTZ,
    query_start TIMESTAMPTZ,
    state_change TIMESTAMPTZ,
    state TEXT,
    wait_event_type TEXT,
    wait_event TEXT,
    query TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT
        NOW() - sa.query_start AS duration,
        sa.pid,
        sa.datname,
        sa.usename,
        sa.application_name,
        sa.client_addr,
        sa.backend_start,
        sa.xact_start,
        sa.query_start,
        sa.state_change,
        sa.state,
        sa.wait_event_type,
        sa.wait_event,
        sa.query
    FROM
        pg_stat_activity sa
    WHERE
        sa.pid <> pg_backend_pid()
        AND (
            p_show_all_idle
            OR
            (
                NOT p_show_all_idle AND NOT p_show_idle_in_transaction AND sa.state <> 'idle'
            )
            OR
            (
                NOT p_show_all_idle AND p_show_idle_in_transaction AND sa.state <> 'idle' OR sa.state ILIKE 'idle in transaction%'
            )
        )
        AND (p_database_name IS NULL OR sa.datname = p_database_name)
    ORDER BY
        sa.query_start DESC;
END;
$$;