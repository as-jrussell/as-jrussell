SHOW DATABASES;
SHOW TABLES;
SHOW VIEWS;
SHOW COLUMNS IN TABLE <table_name>;
SHOW COLUMNS IN VIEW <view_name>;
SHOW FILES;
SHOW STAGES;
SHOW WAREHOUSES;
SHOW USERS;
SHOW GRANTS;
SHOW ROLES;
SHOW PARAMETERS;
SHOW TASKS;
SHOW PIPELINES;
SHOW STREAMS;
SHOW SUBSCRIPTIONS;
SHOW SECURITY INTEGRATION;
SHOW FILE FORMATS;
SHOW QUERY HISTORY;
SHOW FUNCTIONS;
SHOW SESSION_PARAMETERS;
SHOW VARIANT_TYPE;
SHOW SEQUENCES;
SHOW AUDIT POLICIES;
SHOW JOBS;
SHOW RESOURCE MONITORS;
SHOW REPLICATION;
SHOW SCHEDULES;
SHOW VIRTUAL WAREHOUSES;
SHOW NETWORK POLICIES;
SHOW STORAGE INTEGRATIONS;
SHOW INGESTION INTEGRATIONS;
SHOW CREDENTIALS;
SHOW EXTERNAL TABLES;
SHOW EXTERNAL FUNCTIONS;
SHOW DATABASE GRANTS;
SHOW ALL GRANTS;
SHOW MASKING POLICIES;
SHOW STATISTICS FOR TABLE <table_name>;
SHOW CREDENTIALS;


/*

SHOW COLUMNS: Requires the SELECT privilege on the table or view being queried.
SHOW FILES: Requires the USAGE privilege on the stage.
SHOW GRANTS: Requires the USAGE privilege on the object being queried or the global VIEW DEFINITION privilege.
SHOW PARAMETERS: Requires the USAGE privilege on the account or the global VIEW DEFINITION privilege.
SHOW SCHEMAS: Requires the USAGE privilege on the database or the global VIEW DEFINITION privilege.
SHOW STAGES: Requires the USAGE privilege on the stage or the global VIEW DEFINITION privilege.
SHOW TABLES: Requires the USAGE privilege on the schema or the global VIEW DEFINITION privilege.
SHOW DATABASES: Requires the ACCOUNTADMIN role.
SHOW PRIVILEGES: Requires the ACCOUNTADMIN role.
SHOW ROLES: Requires the ACCOUNTADMIN role.
SHOW USERS: Requires the ACCOUNTADMIN role.

Note: The privileges listed above are the minimum required to execute the corresponding "show" function. 
Additional privileges may be required depending on the specific objects being queried.

*/