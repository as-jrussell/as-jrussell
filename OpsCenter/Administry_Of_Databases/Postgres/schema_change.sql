DO $$
DECLARE
    target_schema TEXT := 'myveryfirstschema';
    table_list TEXT[] := ARRAY[
        'sportstable',
        'myfirstpostgrestable',
        'SportsTable',
        'VideoGames'
    ];
    tbl TEXT;
BEGIN
    -- Step 1: Create schema if not exists
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.schemata WHERE schema_name = target_schema
    ) THEN
        RAISE NOTICE 'Creating schema: %', target_schema;
        EXECUTE format('CREATE SCHEMA %I', target_schema);
    ELSE
        RAISE NOTICE 'Schema already exists: %', target_schema;
    END IF;

    -- Step 2: Loop through and move tables if they exist
    FOREACH tbl IN ARRAY table_list
    LOOP
        IF EXISTS (
            SELECT 1 
            FROM information_schema.tables 
            WHERE table_schema = 'public' AND table_name = tbl
        ) THEN
            RAISE NOTICE 'Moving table: %', tbl;
            EXECUTE format('ALTER TABLE public.%I SET SCHEMA %I', tbl, target_schema);
        ELSE
            RAISE WARNING 'Table not found in public schema: %', tbl;
        END IF;
    END LOOP;
END $$;
