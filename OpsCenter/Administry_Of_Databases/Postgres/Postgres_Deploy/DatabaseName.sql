set role dbadmin; 

\echo Creating database :set

CREATE DATABASE :"customerdbname"
    WITH OWNER = dbadmin
    ENCODING = 'UTF8'
    LC_COLLATE = 'en_US.UTF-8'
    LC_CTYPE = 'en_US.UTF-8'
    TEMPLATE = model;

