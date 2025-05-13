-- PostgreSQL Current Context Information Script

-- Returns the name of the current database.
SELECT CURRENT_CATALOG;

-- Returns the name of the current database (alternative syntax).
SELECT CURRENT_DATABASE();


-- Returns the name of the current user.
SELECT CURRENT_USER;

-- Returns the name of the current user role.
SELECT CURRENT_ROLE;

-- Returns the name of the current schema search path's first element.
SELECT CURRENT_SCHEMA;

-- Returns an array of the names of schemas in the current schema search path (excluding implicit system schemas).
SELECT CURRENT_SCHEMAS(false);

-- Returns an array of the names of schemas in the current schema search path (including implicit system schemas).
SELECT CURRENT_SCHEMAS(true);

-- Returns the current time with time zone.
SELECT CURRENT_TIME;

-- Returns the current date and time with time zone.
SELECT CURRENT_TIMESTAMP;

-- Returns the current date.
SELECT CURRENT_DATE;


SELECT rolname, rolsuper, rolcanlogin, rolinherit, rolcreaterole, rolcreatedb, rolreplication
FROM pg_roles
WHERE rolname = CURRENT_USER;


SELECT rolname, rolsuper as superuser
FROM pg_roles
WHERE rolsuper = true;

