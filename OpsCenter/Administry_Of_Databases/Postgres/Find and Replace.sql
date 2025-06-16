DO $$
DECLARE
    target_usernames TEXT[] := ARRAY['fflintstone']; -- Add all usernames here
    current_username TEXT;
    old_password_pattern TEXT := E'WITH LOGIN PASSWORD ''[^'']+'''; -- Matches WITH LOGIN PASSWORD 'anything_here'
    new_password_masked_string TEXT := 'WITH LOGIN PASSWORD ''xxxxxxxxxxxxxx''';
    rows_updated_total INT := 0;
    rows_updated_current_user INT;
BEGIN
    RAISE NOTICE 'Attempting to mask passwords in dba.account_log_history for multiple users.';

    FOREACH current_username IN ARRAY target_usernames
    LOOP
        RAISE NOTICE 'Processing user: "%"', current_username;

        UPDATE dba.account_log_history
        SET
            sql_command = REGEXP_REPLACE(sql_command, old_password_pattern, new_password_masked_string, 'g'),
            message = message || ' (Password masked in sql_command log entry)' -- Add a note to the message
        WHERE
            action_type = 'CREATE_USER' AND target_entity = current_username
            AND sql_command LIKE '%' || current_username || ' WITH LOGIN PASSWORD %'
            AND sql_command ~ old_password_pattern; -- Ensure it matches the specific password pattern

        GET DIAGNOSTICS rows_updated_current_user = ROW_COUNT;
        rows_updated_total := rows_updated_total + rows_updated_current_user;

        IF rows_updated_current_user > 0 THEN
            RAISE NOTICE '  - Successfully masked password in % record(s) for user "%".', rows_updated_current_user, current_username;
        ELSE
            RAISE NOTICE '  - No records found or no password pattern matched for user "%".', current_username;
        END IF;

    END LOOP;

    RAISE NOTICE 'Total records updated across all users: %', rows_updated_total;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'An error occurred during password masking: %', SQLERRM;
END $$ LANGUAGE plpgsql;