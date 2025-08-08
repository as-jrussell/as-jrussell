-- FUNCTION: deploy.setrevokeuser(text[], text[], boolean, boolean)

-- DROP FUNCTION IF EXISTS deploy.setrevokeuser(text[], text[], boolean, boolean);
set role dba_team; 


CREATE OR REPLACE FUNCTION deploy.SetRevokeUser(
    p_usernames TEXT[],
    p_inherit_roles TEXT[] DEFAULT NULL,
    p_execute_flag BOOLEAN DEFAULT FALSE,
    p_drop_user BOOLEAN DEFAULT FALSE
)
RETURNS TEXT
LANGUAGE plpgsql
/*


SELECT deploy.SetRevokeUser(
    p_usernames     := ARRAY['superman'],
    p_inherit_roles := ARRAY['db_datareader'],
    p_execute_flag  := TRUE,
    p_drop_user     := TRUE
);

/*
============================================================================
🧪 DRY-RUN ONLY — TEST REVOKING ROLES (DON'T EXECUTE)
============================================================================
*/
SELECT deploy.SetRevokeUser(
    p_usernames     := ARRAY['user_qa', 'user_test'],
    p_inherit_roles := ARRAY['db_viewer', 'db_readonly'],
    p_execute_flag  := FALSE,
    p_drop_user     := FALSE
);

/*
============================================================================
🪓 REVOKE ROLES FROM USERS — THEN DROP USERS (default behavior)
============================================================================
*/
SELECT deploy.SetRevokeUser(
    p_usernames     := ARRAY['user_temp1', 'user_temp2'],
    p_inherit_roles := ARRAY['db_datareader', 'db_function_exec'],
    p_execute_flag  := TRUE
    -- p_drop_user is TRUE by default
);

/*
============================================================================
🛑 REVOKE ROLES ONLY — DO NOT DROP USERS
============================================================================
*/
SELECT deploy.SetRevokeUser(
    p_usernames     := ARRAY['jrussell'],
    p_inherit_roles := ARRAY['db_datareader'],
    p_execute_flag  := TRUE,
    p_drop_user     := FALSE
);

/*
============================================================================
🔥 DROP USERS WITHOUT REVOKING ANYTHING
============================================================================
*/
SELECT deploy.SetRevokeUser(
    p_usernames     := ARRAY['old_admin1', 'retired_user'],
    p_execute_flag  := TRUE,
    p_drop_user     := TRUE
);

/*
============================================================================
👀 DRY-RUN FULL DESTRUCTION — SEE EVERYTHING THAT WOULD HAPPEN
============================================================================
*/
SELECT deploy.SetRevokeUser(
    p_usernames     := ARRAY['intern_doomed'],
    p_inherit_roles := ARRAY['db_temp'],
    p_execute_flag  := FALSE,
    p_drop_user     := TRUE
);

/*
============================================================================
🧾 BONUS: Inside a Batch Job or Admin Script
============================================================================
*/
DO $$
BEGIN
    PERFORM deploy.SetRevokeUser(
        p_usernames     := ARRAY['app_bot1', 'app_bot2'],
        p_inherit_roles := ARRAY['db_execute_only'],
        p_execute_flag  := TRUE,
        p_drop_user     := TRUE
    );
END
$$;



*/
AS $$
DECLARE
    v_user TEXT;
    v_role TEXT;
    v_sql TEXT;
    v_log_status TEXT;
    v_result TEXT := '';
BEGIN
    IF p_usernames IS NULL OR array_length(p_usernames, 1) = 0 THEN
        RETURN '[WARN] No usernames provided.';
    END IF;

    -- Revoke inherited roles if provided
    IF p_inherit_roles IS NOT NULL THEN
        FOREACH v_user IN ARRAY p_usernames LOOP
            FOREACH v_role IN ARRAY p_inherit_roles LOOP
                v_sql := format('REVOKE %I FROM %I;', v_role, v_user);

                IF p_execute_flag THEN
                    EXECUTE v_sql;
                    v_log_status := 'EXECUTED';
                ELSE
                    v_log_status := 'DRY_RUN';
                END IF;

                INSERT INTO info.account_log_history (
                    action_type, target_entity, associated_entity, status, sql_command, message
                ) VALUES (
                    'REVOKE_ROLE', v_user, v_role, v_log_status, v_sql,
                    'Revoked role from user.'
                );

                v_result := v_result || format('[%s] %s\n', v_log_status, v_sql);
            END LOOP;
        END LOOP;
    END IF;

    -- Optionally drop users
    IF p_drop_user THEN
        FOREACH v_user IN ARRAY p_usernames LOOP
            v_sql := format('DROP ROLE IF EXISTS %I;', v_user);

            IF p_execute_flag THEN
                EXECUTE v_sql;
                v_log_status := 'EXECUTED';
            ELSE
                v_log_status := 'DRY_RUN';
            END IF;

            INSERT INTO info.account_log_history (
                action_type, target_entity, associated_entity, status, sql_command, message
            ) VALUES (
                'DROP_USER', v_user, NULL, v_log_status, v_sql,
                'Dropped user account.'
            );

            v_result := v_result || format('[%s] %s\n', v_log_status, v_sql);
        END LOOP;
    END IF;

    RETURN v_result;
END;
$$;

ALTER FUNCTION deploy.SetRevokeUser(TEXT[], TEXT[], BOOLEAN, BOOLEAN)
    OWNER TO dba_team;
