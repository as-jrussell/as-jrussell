


CREATE DATABASE :"dbname"
    WITH OWNER = dbadmin
    ENCODING = 'UTF8'
    LC_COLLATE = 'en_US.UTF-8'
    LC_CTYPE = 'en_US.UTF-8'
    TEMPLATE template0;

	

GRANT TEMPORARY, CONNECT ON DATABASE :"dbname"  TO PUBLIC;

GRANT ALL ON DATABASE :"dbname"  TO dba_team WITH GRANT OPTION;

GRANT ALL ON DATABASE :"dbname" TO dbadmin;


GRANT CREATE ON DATABASE :"dbname" TO dba_team;