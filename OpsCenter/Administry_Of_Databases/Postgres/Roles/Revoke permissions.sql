DO
$$
DECLARE
    target_groups TEXT[] := ARRAY['super_group', 'creator_group'];  -- <-- UPDATE group names here
    rec RECORD;
    member_count INT;
    dryrun BOOLEAN := false;  -- FALSE = DRY RUN, TRUE = EXECUTE
BEGIN
    RAISE NOTICE 'Dry-run mode is %', CASE WHEN dryrun THEN 'OFF (changes will be applied)' ELSE 'ON (no changes made)' END;

    -- Step 1: Revoke users from target groups
    FOR rec IN
        SELECT r.rolname AS member_name, m.rolname AS group_name
        FROM pg_auth_members am
        JOIN pg_roles r ON am.member = r.oid
        JOIN pg_roles m ON am.roleid = m.oid
        WHERE m.rolname = ANY(target_groups)
    LOOP
        IF NOT dryrun THEN
            RAISE NOTICE '[DRY-RUN] Would revoke group % from member %', rec.group_name, rec.member_name;
        ELSE
            RAISE NOTICE 'Revoking group % from member %', rec.group_name, rec.member_name;
            EXECUTE format('REVOKE %I FROM %I', rec.group_name, rec.member_name);
        END IF;
    END LOOP;

    -- Step 2: Verification - Check if groups are now empty
    FOR rec IN
        SELECT rolname
        FROM pg_roles
        WHERE rolname = ANY(target_groups)
    LOOP
        EXECUTE format(
            'SELECT COUNT(*) FROM pg_auth_members am JOIN pg_roles r ON am.roleid = r.oid WHERE r.rolname = %L',
            rec.rolname
        ) INTO member_count;

        IF member_count = 0 THEN
            RAISE NOTICE 'Group % is now empty and ready for drop.', rec.rolname;
        ELSE
            RAISE WARNING 'Group % still has % members and cannot be dropped.', rec.rolname, member_count;
        END IF;
    END LOOP;
END
$$ LANGUAGE plpgsql;
