
-- 7.0.0   Dynamic Data Masking
--         This lab will take approximately 30 minutes to complete.
--         In this lab you will create a MASKING_ADMIN role to create and apply
--         multiple masking policies to PII columns within a custom TAXPAYER
--         database.
--         - Create a custom database, schema, and tables against which
--         sensitive data will be masked, partially masked, and unmasked.
--         - Load Personally Identifiable Information (PII) into a table and
--         then mask and/or unmask sensitive data.
--         - Create various roles to mask and unmask data.
--         - Test the masking policies to confirm they work as expected.
--         - Learn about secure views and restricting viewing access rights.

-- 7.1.0   Masking Policies and Roles
--         The lab uses a combination of centralized and de-centralized
--         administration of masking policies, in which the masking policies are
--         stored within an application database (TAXPAYER_DB). The
--         MASKING_ADMIN role administers the masking policies rather than the
--         owner of the TAXPAYER database and schema owner, TRAINING_ROLE.
--         Be sure to substitute your assigned login user name (i.e., your
--         ANIMAL name) for BADGER throughout this file.

-- 7.1.1   Create a new application role for querying taxpayer data:

use role securityadmin;
drop role if exists taxpayer_role;
create role taxpayer_role;
grant role taxpayer_role to role training_role;


-- 7.1.2   Set the context for creating the TAXPAYER database and schema:

use role training_role;
use warehouse BADGER_QUERY_wh;

--         In this instance, the specific role of TRAINING_ROLE is the owner of
--         the application objects which require masking.

-- 7.1.3   Create a new warehouse for your login account:

create warehouse if not exists BADGER_QUERY_wh;
use warehouse BADGER_QUERY_wh;
grant usage on warehouse BADGER_QUERY_wh to role taxpayer_role;


-- 7.1.4   Create a new database, TAXPAYER_BADGER_DB
--         In this instance, the TAXPAYER objects are created within the PUBLIC
--         schema:

drop database if exists taxpayer_BADGER_db;
create database taxpayer_BADGER_db;
use schema taxpayer_BADGER_db.public;


-- 7.2.0   Create Custom Tables to Test Masking

-- 7.2.1   Create the TAXPAYER, TAXPAYER_DEPENDENTS, and TAXPAYER_WAGES tables:

create or replace table taxpayer 
(
  taxpayer_ssn varchar2(9) not null, 
  filing_status varchar2(1), 
  nbr_exemptions number(2,0), 
  lastname varchar2(30) not null, 
  firstname varchar2(30) not null, 
  street varchar2(30),
  city varchar2(20) not null, 
  state varchar2(20) not null, 
  zip number(9,0),
  home_phone number(10,0), 
  cell_phone number(10,0), 
  email varchar2(40),
  birthdate date not null 
);

create table taxpayer_dependents 
(
  dependent_ssn varchar2(9) not null,
  taxpayer_ssn varchar2(9) not null, 
  dep_relationship varchar2(10) not null, 
  dep_lastname varchar2(30) not null, 
  dep_firstname varchar2(30),
  dep_city varchar2(30), 
  dep_state varchar2(2),
  dep_zipcode number(9,0), 
  dep_home_phone number(10,0), 
  dep_cell_phone number(10,0), 
  dep_email varchar2(40), 
  dep_birthdate date
);

create table taxpayer_wages 
(
  taxpayer_ssn varchar2(9) not null, 
  tax_year number(4,0) not null, 
  w2_total_income number not null,
  adj_gross_income number(12,0) not null, 
  taxable_income number(12,0) not null, 
  total_federal_tax number(12,0) not null
);


-- 7.3.0   Assign the Correct Access to Specific Roles

-- 7.3.1   Grant table access to the SYSADMIN & TAXPAYER_ROLE roles:

grant usage on database taxpayer_BADGER_db to sysadmin;
grant usage on schema taxpayer_BADGER_db.public to role sysadmin;
grant select on all tables in schema taxpayer_BADGER_db.public to sysadmin;
grant usage on database taxpayer_BADGER_db to taxpayer_role;
grant usage on schema taxpayer_BADGER_db.public to role taxpayer_role;
grant select on all tables in schema taxpayer_BADGER_db.public to taxpayer_role;


-- 7.4.0   Populate the Tables with PII Data

-- 7.4.1   Load the application data into the tables.

-- 7.4.2   Load PII data into the taxpayer schema:

insert into taxpayer values
(123456789,'S',0,'Smith','Margie','345 Maple St','Houston','TX',78909,
7007869087,7007869234,'msmith@test.com','09-APR-1965'),
(678465237,'M',2,'Bredsguard','Stanley','1313 Montrose Ave','Chicago','IL',60625,
3124567899,312453882,'stan@zzz.com','11-DEC-1976'),
(345117826,'M',2,'Moe','Arnold','6366 Milwaukee Ave','San Diego','CA',23596,
2134457219,2136628174,'moea@z121.com','26-SEP-1955'),
(985207742,'M',3,'Bradford','Reed','23 9th St','Provo','UT',84652,
8012361189,8013682956,'refinersfire@bbb.com','09-APR-1949'),
(237812332,'D',3,'Larry','Simpson','1462 Baker Blvd','Torrance','CA',86798,
7145657889,7142237766,'lsimpson@geek.com','11-JAN-1970'),
(873554189,'M',2,'Kirby','Helen','10 Willow Dr','Kankakee','IL',65234,
3478904432,3478904432,'kirby@abcd.com','01-NOV-1956'),
(907872319,'S',1,'Wellberger','Peter','144 Stevens St','Las Vegas','NV',87231,
6523490871,6524453219,'wellberger@redsa.com','04-JUN-1965'),
(734638955,'M',3,'Broussard','Kim','1910 State Ave','Argyle','NB',33278,
972351199,9722267234,'kimb@corn.com','11-MAY-1957'),
(234893277,'M',2,'White','Walter','308 Negra Arroyo Ln','Albuquerque','NM',78556,
5052348644,5056712381,'heisenberg@abcd.com','30-JUN-1950'),
(349070043,'S',1,'Williams','Bob','3790 N Temple','Salt Lake City','UT',89767,
8019074197,8013221885,'bwilliams@slc.com','23-MAR-1971');


-- 7.4.3   Load PII data into the taxpayer_dependents schema:

insert into taxpayer_dependents values 
(123456798,678465237,'Spouse','Bredsguard','Deborah','Chicago','IL',60625, 
3124345899,3124479072,'debbieb@lazoo.com','27-FEB-1979'),
(332129001,678465237,'Daughter','Bredsguard','Rhonda','Chicago','IL',60625,
3124345899,323212780,'rhondac@ysnq.com','01-DEC-1991'),
(332789123,678465237,'Daughter','Bredsguard','Rebecca','Chicago','IL',60625,
3124345899,323212782,'bredsgr@aszoo.com','27-FEB-1990'),
(390700095,345117826,'Spouse','Moe','Cynthia','San Diego','CA',23596,
2134457219,2132180095,'moec@zxcv.com','02-SEP-1967'),
(334721199,345117826,'Son','Moe','Thomas','San Diego','CA',23596,
2134457219,2132180088,'moet@mnj.com','02-SEP-1988'),
(334789220,345117826,'Daughter','Moe','Sylvia','San Diego','CA',23596,
2134457219,2136677211,'sylviam@otewq.com','11-DEC-1992'),
(991781002,985207742,'Spouse','Bradford','Doris','Provo','UT',84652,
8012361189,8012328771,'dbradford@mnq.com','31-OCT-1956'),
(443891055,985207742,'Son','Bradford','Kenneth','Provo','UT',84652,
8012361189,8015431125,'kbradford@snq.com','31-OCT-1996'),
(441556923,985207742,'Son','Bradford','Jordan','Provo','UT',84652,
8012361189,8019344279,'jbradford@mm1nq.com','31-OCT-1992'),
(551511899,237812332,'Son','Simpson','Kevin','Torrance','CA',86798,
7145657889,7142237790,'kevsimp@sdfg.com','19-JUL-1985'),
(112932783,237812332,'Spouse','Simpson','Stacy','Torrance','CA',86798,
7145657889,7143458124,'stacys@lodq.com','01-JUL-1950'),
(349548814,237812332,'Daughter','Simpson','Denell','Torrance','CA',86798,
7145657889,7144552311,'denell@jsp.com','01-JUL-1983'),
(231458895,873554189,'Spouse','Kirby','Matthew','Danville','IL',65234,
3478904432,3471125628,'kirbym@wert.com','15-SEP-1965'),
(775623119,873554189,'Son','Kirby','Lawrence','Danville','IL',65234,
3478904432,3259856623,'lawrencek@snz.com','05-MAR-1993'),
(775846650,873554189,'Son','Kirby','Alan','Danville','IL',65234,
3478904432,3259233576,'akirby@msn.com','31-MAY-1994'),
(907272314,907872319,'Daughter','Wellberger','Sandra','Las Vegas','NV',87231,
6523490871,6523468201,'wells@axoo.com','04-JUN-1985'),
(676534239,734638955,'Spouse','Broussard','Dillon','Gatlin','NB',33278,
972351199,9724345447,'broussardd@orb.com','03-AUG-1964'),
(223441000,234893277,'Spouse','White','Skyler','Albuquerque','NM',78556,
5052348644,5052212672,'skylerw@orb.com','02-APR-1959'),
(998700222,349070043,'Spouse','Williams','Yvette','Salt Lake City','UT',89767,
8019074197,8016233445,'ywilliams12@slc.com','16-JUN-1974'),
(443233887,349070043,'Daughter','Williams','Denise','Salt Lake City','UT',89767,
8019074197,8012278550,'dwilliams12@wert.com','28-OCT-1993');


-- 7.4.4   Load PII data into the taxpayer_wages schema:

insert into taxpayer_wages values 
(123456789,2011,104990,97250,89730,80900),
(123456789,2012,113400,101200,90650,89500),
(123456789,2013,103200,99870,75298,70925),
(234893277,2011,250900,180400,120000,111235),
(234893277,2012,160780,150668,100300,98700),
(234893277,2013,200600,172400,145900,136783),
(237812332,2011,120678,118500,109720,109210),
(237812332,2012,190700,175600,168923,158820),
(237812332,2013,89400,81000,75600,74577),
(345117826,2011,110678,109400,105000,98750),
(345117826,2012,150600,147200,130649,127788),
(345117826,2013,280900,250320,210100,209855),
(349070043,2011,90870,88730,87200,85590),
(349070043,2012,65100,60760,60411,55750),
(349070043,2013,95700,93100,89500,84120),
(678465237,2011,110560,108920,103745,103745),
(678465237,2012,189700,185690,180003,178600),
(678465237,2013,101337,96711,94350,92800),
(734638955,2011,116890,111256,107562,106980),
(734638955,2012,100577,99300,94368,90800),
(734638955,2013,101100,100700,99910,88504),
(873554189,2011,140900,138725,133960,129780),
(873554189,2012,125790,113449,110200,109800),
(873554189,2013,101100,100700,99910,89504),
(907872319,2011,350670,337800,334950,296500),
(907872319,2012,375900,369108,358600,339875),
(907872319,2013,460700,437120,425700,419762),
(985207742,2011,120900,118600,115650,113820),
(985207742,2012,689400,655000,603118,602880),
(985207742,2013,575670,572100,560900,560920);


-- 7.5.0   Confirm Data Propagation

-- 7.5.1   Verify the data loaded correctly into their respective application
--         tables:

select * from taxpayer;
select * from taxpayer_dependents;
select * from taxpayer_wages;


-- 7.6.0   Assign Roles for Data Masking

-- 7.6.1   Setup the MASKING_ADMIN role:

use role securityadmin;
drop role if exists masking_admin_BADGER_db;
create role masking_admin_BADGER_db;

grant create masking policy on schema taxpayer_BADGER_db.public to role 
    masking_admin_BADGER_db;
grant usage on database taxpayer_BADGER_db to role masking_admin_BADGER_db;
grant usage on schema taxpayer_BADGER_db.public to role masking_admin_BADGER_db;
grant role masking_admin_BADGER_db to user BADGER;


-- 7.6.2   As MASKING_ADMIN, create the masking policies in the TAXPAYER
--         database:

use role masking_admin_BADGER_db;

create or replace masking policy taxpayer_BADGER_db.public.ssn_mask as
  (val string) returns string ->
  case
    when current_role() in ('TRAINING_ROLE') then val
    when current_role() in ('SYSADMIN') then repeat('*', length(val)-4) || right(val, 4)
    else '*** REDACTED ***'
  end;

create or replace masking policy taxpayer_BADGER_db.public.email_mask as
(val string) returns string ->
  case
    when current_role() in ('TRAINING_ROLE') then val
    when current_role() in ('SYSADMIN') then regexp_replace(val,'.+\@','*****@')
    else '*** REDACTED ***'
  end;

create or replace masking policy taxpayer_BADGER_db.public.name_mask as
(val varchar) returns varchar ->
  case
    when current_role() in ('SYSADMIN') then regexp_replace(val,'.','*',2)
    when current_role() in ('PUBLIC') then '*** REDACTED ***'
    else val
    end;


-- 7.6.3   Allow TRAINING_ROLE to set or unset the masking policies
--         (decentralized management of masking policies)
--         These steps are NOT required if planning to deploy centralized
--         administration of masking policies in which you want to have the
--         MASKING_ADMIN role apply all masking policies rather than the owner
--         role (TRAINING_ROLE) of the application schema.

grant apply on masking policy taxpayer_BADGER_db.public.ssn_mask to role training_role;
grant apply on masking policy taxpayer_BADGER_db.public.name_mask to role training_role;
grant apply on masking policy taxpayer_BADGER_db.public.email_mask to role training_role;


-- 7.7.0   Set Data Masking Policies

-- 7.7.1   As TRAINING_ROLE, set masking policies for TAXPAYER columns
--         (decentralized management of masking policies):

use role training_role;

alter table taxpayer modify column email set masking policy email_mask;
alter table taxpayer modify column taxpayer_ssn set masking policy ssn_mask;
alter table taxpayer modify column lastname set masking policy name_mask;
alter table taxpayer modify column firstname set masking policy name_mask;


-- 7.7.2   As TRAINING_ROLE, set masking policies for TAXPAYER_DEPENDENTS
--         columns:

alter table taxpayer_dependents modify column dep_email set masking policy email_mask;
alter table taxpayer_dependents modify column taxpayer_ssn set masking policy ssn_mask;
alter table taxpayer_dependents modify column dependent_ssn set masking policy ssn_mask;
alter table taxpayer_dependents modify column dep_lastname set masking policy name_mask;
alter table taxpayer_dependents modify column dep_firstname set masking policy name_mask;


-- 7.7.3   As TRAINING_ROLE, set masking policies for TAXPAYER_WAGES columns:

alter table taxpayer_wages modify column taxpayer_ssn set masking policy ssn_mask;


-- 7.8.0   Using SHOW and DESC Commands, View Masking Policy Metadata

-- 7.8.1   As MASKING_ADMIN, view masking policy metadata (SHOW, DESC commands)

use role masking_admin_BADGER_db;

-- Current database only
-- Students will see only those masking masking policies in their own database
show masking policies;

-- Match pattern on policy name for current database
show masking policies like '%email%';

-- All databases in account
-- Students will see masking policies in all databases in the training account
show masking policies in account;

-- Match pattern on policy name across all databases in account
show masking policies like '%email%' in account;

-- Match pattern on policy name for a specific database
show masking policies like '%email%' in database taxpayer_BADGER_db;


-- 7.8.2   Run DESCRIBE for each masking policy.

-- 7.8.3   View the masking policy for each section:

desc masking policy ssn_mask;
desc masking policy name_mask;
desc masking policy email_mask;


-- 7.8.4   Change to the training_role role before describing the tables:

use role training_role;


-- 7.8.5   Run DESCRIBE for each table.

-- 7.8.6   Expand the output window and note each non-null Policy name for each
--         column that has an assigned masking policy:

desc table taxpayer;
desc table taxpayer_dependents;
desc table taxpayer_wages;


-- 7.8.7   View grants on masking policies:

show grants on masking policy email_mask;
show grants on masking policy name_mask;
show grants on masking policy ssn_mask;


-- 7.9.0   Test Masking Policies

-- 7.9.1   Run table queries as the role TRAINING_ROLE:

use role training_role;

select taxpayer_ssn,lastname,firstname,email,city,state from taxpayer;
select dependent_ssn,taxpayer_ssn,dep_relationship,dep_email,dep_lastname,
    dep_firstname,dep_city from taxpayer_dependents;
select taxpayer_ssn,tax_year,w2_total_income,total_federal_tax from taxpayer_wages;

--         When run, confirm the status of the following values; SSN, NAME, and
--         EMAIL as unmasked data or displaying PII in plain text.

-- 7.9.2   Run table queries as a different role; SYSADMIN:

use role sysadmin;

select taxpayer_ssn,lastname,firstname,email,city,state from taxpayer;
select dependent_ssn,taxpayer_ssn,dep_relationship,dep_email,dep_lastname,
    dep_firstname,dep_city from taxpayer_dependents;
select taxpayer_ssn,tax_year,w2_total_income,total_federal_tax from taxpayer_wages;

--         When run, confirm the status of the following values; SSN, NAME, and
--         EMAIL data is partially masked.

-- 7.9.3   Run table queries as role TAXPAYER_ROLE:

use role taxpayer_role;

select taxpayer_ssn,lastname,firstname,email,city,state from taxpayer;
select dependent_ssn,taxpayer_ssn,dep_relationship,dep_email,dep_lastname,
    dep_firstname,dep_city from taxpayer_dependents;
select taxpayer_ssn,tax_year,w2_total_income,total_federal_tax from taxpayer_wages;

--         When run, confirm the status of the following values; SSN, NAME, and
--         EMAIL data is fully masked or there is redacted information in the
--         columns.
