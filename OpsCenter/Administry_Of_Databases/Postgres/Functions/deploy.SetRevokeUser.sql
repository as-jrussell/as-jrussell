-- Create or replace the child function to handle user dropping
CREATE OR REPLACE FUNCTION deploy.SetRevokeUser(
    p_usernames TEXT[],
    p_execute_flag BOOLEAN DEFAULT FALSE
)
RETURNS TEXT
LANGUAGE plpgsql
AS $$
/*
==========================================================
🙅‍♂️ deploy.SetRevokeUser() - Example Use Cases
==========================================================

-- 🔪 BASIC USER DROP: Just remove a user (full delete)
SELECT deploy.SetRevokeUser(
    p_usernames := ARRAY['readonly_jc'],
    p_execute_flag := TRUE
);

-- 🔫 MULTIPLE USERS: Delete several users at once
SELECT deploy.SetRevokeUser(
    p_usernames := ARRAY['intern_2022', 'contractor_2023'],
    p_execute_flag := TRUE
);

-- 🧪 DRY-RUN: Simulate user deletion
SELECT deploy.SetRevokeUser(
    p_usernames := ARRAY['test_user_123'],
    p_execute_flag := FALSE
);
*/

DECLARE
    v_entity_exists BOOLEAN;
    v_sql_command TEXT;
    v_log_status TEXT;
    v_return_message TEXT := '';
    v_current_user_name TEXT;
BEGIN
    IF p_usernames IS NOT NULL AND array_length(p_usernames, 1) > 0 THEN
        FOREACH v_current_user_name IN ARRAY p_usernames LOOP
            SELECT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = v_current_user_name) INTO v_entity_exists;

            IF v_entity_exists THEN
                v_sql_command := format('DROP ROLE %I', v_current_user_name);
                RAISE NOTICE '[DRY-RUN] Would drop user: "%"', v_current_user_name;

                IF p_execute_flag THEN
                    EXECUTE v_sql_command;
                    v_log_status := 'EXECUTED';
                    RAISE NOTICE 'User "%s" dropped.', v_current_user_name;
                ELSE
                    v_log_status := 'DRY_RUN';
                END IF;

                INSERT INTO dba.account_log_history (action_type, target_entity, associated_entity, status, sql_command, message)
                VALUES (
                    'DROP_USER',
                    v_current_user_name,
                    NULL,
                    v_log_status,
                    v_sql_command,
                    'User drop attempted.'
                );
                v_return_message := v_return_message || format('User "%s" dropped. ', v_current_user_name);
            ELSE
                v_log_status := 'NOT_FOUND';
                INSERT INTO dba.account_log_history (action_type, target_entity, associated_entity, status, sql_command, message)
                VALUES (
                    'DROP_USER',
                    v_current_user_name,
                    NULL,
                    v_log_status,
                    NULL,
                    'User not found, no action taken.'
                );
            END IF;
        END LOOP;
    END IF;

    RETURN v_return_message;
END;
$$;
