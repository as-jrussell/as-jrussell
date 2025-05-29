-- 1. Create roles (users)
CREATE ROLE report_user LOGIN PASSWORD 'StrongPassword1';
CREATE ROLE app_user LOGIN PASSWORD 'StrongPassword2';

-- 2. Create schemas owned by respective roles
CREATE SCHEMA app_schema AUTHORIZATION app_user;
CREATE SCHEMA analytics_schema AUTHORIZATION postgres;

-- 3. Grant schema permissions
GRANT USAGE, CREATE ON SCHEMA app_schema TO app_user;
GRANT USAGE ON SCHEMA analytics_schema TO report_user;

-- 4. Table-level privileges for existing and future tables

-- For analytics_schema: read-only for report_user
GRANT SELECT ON ALL TABLES IN SCHEMA analytics_schema TO report_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA analytics_schema
GRANT SELECT ON TABLES TO report_user;

-- For app_schema: full CRUD for app_user
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA app_schema TO app_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA app_schema
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO app_user;

-- 5. Set default search_path for easier querying
ALTER ROLE app_user SET search_path = app_schema;
ALTER ROLE report_user SET search_path = analytics_schema;
