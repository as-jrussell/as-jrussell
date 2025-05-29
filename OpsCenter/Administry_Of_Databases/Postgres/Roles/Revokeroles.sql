DO
$$
DECLARE
    target_groups TEXT[] := ARRAY['dba_team'];  -- <-- UPDATE group names here
    rec RECORD;
    member_count INT;
    dryrun BOOLEAN := false;  -- FALSE = DRY RUN, TRUE = EXECUTE
BEGIN
    RAISE NOTICE 'Dry-run mode is %', CASE WHEN dryrun THEN 'OFF (changes will be applied)' ELSE 'ON (no changes made)' END;

    -- Step 3: Drop groups that are now empty
    FOR rec IN
        SELECT rolname
        FROM pg_roles
        WHERE rolname = ANY(target_groups)
    LOOP
        EXECUTE format(
            'SELECT COUNT(*) FROM pg_auth_members am JOIN pg_roles r ON am.roleid = r.oid WHERE r.rolname = %L',
            rec.rolname
        )
        INTO member_count;

        IF member_count = 0 THEN
            IF NOT dryrun THEN
                RAISE NOTICE '[DRY-RUN] Would drop group %', rec.rolname;
            ELSE
                RAISE NOTICE 'Dropping group %', rec.rolname;
                EXECUTE format('DROP ROLE IF EXISTS %I', rec.rolname);
            END IF;
        ELSE
            RAISE WARNING 'Cannot drop group % because it still has % members.', rec.rolname, member_count;
        END IF;
    END LOOP;
END
$$ LANGUAGE plpgsql;
