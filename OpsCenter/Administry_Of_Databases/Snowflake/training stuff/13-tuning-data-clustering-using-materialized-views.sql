
-- 13.0.0  Tuning Data Clustering Using Materialized Views
--         This lab will take approximately 30-40 minutes to complete.
--         These exercises will cover data clustering while using materialized
--         views.
--         - Clustering a table using a timestamped column.
--         - Creating tables and checking clustering for attributes.
--         - Clustering a table using a PAGE_ID column.

-- 13.1.0  ­­Cluster a Table Using a Timestamp Column
--         Imagine having a weblog that tracks metrics ­­accessible by different
--         attributes (IDs) for different use cases, such as a column-like page
--         ID or a column-like timestamp.

-- 13.1.1  Navigate to Worksheets and create a new worksheet.

-- 13.1.2  Name the worksheet Clustering & MV.

-- 13.1.3  Set the Worksheet context as follows:

USE ROLE TRAINING_ROLE;
USE DATABASE BADGER_DB;
USE WAREHOUSE BADGER_QUERY_WH;
ALTER SESSION SET USE_CACHED_RESULT=TRUE;


-- 13.2.0  Create a Table and Check Clustering for an Attribute

-- 13.2.1  Create a table by cloning a table in the TRAINING_DB Database.

CREATE OR REPLACE TABLE WEBLOG CLONE TRAINING_DB.TRAININGLAB.WEBLOG;

--         The original WEBLOG table was generated with data from the following
--         query:

INSERT INTO WEBLOG SELECT
(SEQ8())::BIGINT AS CREATE_MS
    ,UNIFORM(1,9999999,RANDOM(10002))::BIGINT PAGE_ID
    ,UNIFORM(1,9999999,RANDOM(10003))::INTEGER TIME_ON_LOAD_MS
    ,UNIFORM(1,9999999,RANDOM(10005))::INTEGER METRIC2
    ,UNIFORM(1,9999999,RANDOM(10006))::INTEGER METRIC3
    ,UNIFORM(1,9999999,RANDOM(10007))::INTEGER METRIC4
    ,UNIFORM(1,9999999,RANDOM(10008))::INTEGER METRIC5
    ,UNIFORM(1,9999999,RANDOM(10009))::INTEGER METRIC6
    ,UNIFORM(1,9999999,RANDOM(10010))::INTEGER METRIC7
    ,UNIFORM(1,9999999,RANDOM(10011))::INTEGER METRIC8
    ,UNIFORM(1,9999999,RANDOM(10012))::INTEGER METRIC9
FROM TABLE(GENERATOR(ROWCOUNT => 10000000000)) ORDER BY CREATE_ms;

ALTER WAREHOUSE BADGER_QUERY_WH SET WAREHOUSE_SIZE = 'MEDIUM';


-- 13.2.2  Check the clustering quality of the attribute, CREATE_MS. It is
--         expected to be good.

SELECT SYSTEM$CLUSTERING_INFORMATION( 'WEBLOG' , '(CREATE_MS)' );

--         Note the result of the query:

    {
    "cluster_by_keys" : "LINEAR(CREATE_MS)",
    "total_partition_count" : 20865,
    "total_constant_partition_count" : 0,
    "average_overlaps" : 0.194,
    "average_depth" : 1.0976,
    "partition_depth_histogram" : {
        "00000" : 0,
        "00001" : 18828,
        "00002" : 2037,
        "00003" : 0,
        "00004" : 0,
        "00005" : 0,
        "00006" : 0,
        "00007" : 0,
        "00008" : 0,
        "00009" : 0,
        "00010" : 0,
        "00011" : 0,
        "00012" : 0,
        "00013" : 0,
        "00014" : 0,
        "00015" : 0,
        "00016" : 0
        }
    }


-- 13.2.3  Run the following query containing a search filter using the column
--         CREATE_MS. Query performance is expected to be good.

SELECT COUNT(*) CNT, AVG(TIME_ON_LOAD_MS)
AVG_TIME_TO_LOAD FROM WEBLOG
WHERE CREATE_MS BETWEEN 1000000000 AND 1000001000;


-- 13.2.4  Check the query profile of above query.

-- 13.2.5  Notice that with the TableScan[2] operator the partition pruning is
--         very good:
--         Partitions scanned: 1
--         Partition total: 20,683
--         Query Profile 2

-- 13.2.6  Check for clustering on the other column, PAGE_ID. It is expected to
--         be poor.

SELECT SYSTEM$CLUSTERING_INFORMATION( 'WEBLOG' , '(PAGE_ID)' );


-- 13.2.7  Note the result from running above query:

    {
    "cluster_by_keys" : "LINEAR(PAGE_ID)",
    "total_partition_count" : 20663,
    "total_constant_partition_count" : 0,
    "average_overlaps" : 20662.0,
    "average_depth" : 20663.0,
    "partition_depth_histogram" : {
        "00000" : 0,
        "00001" : 0,
        "00002" : 0,
        "00003" : 0,
        "00004" : 0,
        "00005" : 0,
        "00006" : 0,
        "00007" : 0,
        "00008" : 0,
        "00009" : 0,
        "00010" : 0,
        "00011" : 0,
        "00012" : 0,
        "00013" : 0,
        "00014" : 0,
        "00015" : 0,
        "00016" : 0,
        "32768" : 20665
        }
    }


-- 13.2.8  Note that query performance is expected to be sub­optimal using the
--         filter with PAGE_ID:

SELECT COUNT(*) CNT, AVG(TIME_ON_LOAD_MS) AVG_TIME_TO_LOAD
FROM WEBLOG WHERE PAGE_ID=100000;


-- 13.2.9  Check the query profile of the above query. Notice that with the
--         TableScan[2] operator the partition pruning is rather poor. It’s
--         doing a full table scan.
--         Partition scanned: 20683
--         Partition total: 20683
--         Full Table Scan

-- 13.3.0  Cluster a Table Using a PAGE_ID Column
--         ­­Running both types of queries with equally good performance
--         requires using a second copy of the data that’s organized
--         differently, hence optimizing access for both query patterns.

-- 13.3.1  Create a Materialized View (MV).

-- 13.3.2  Creating the materialized view with Snowflake allows us to specify
--         the new clustering key, which enables Snowflake to ­­reorganize the
--         data during the initial creation of the materialized view.

CREATE OR REPLACE MATERIALIZED VIEW MV_TIME_TO_LOAD
(CREATE_MS, PAGE_ID, TIME_TO_LOAD_MS) CLUSTER BY (PAGE_ID) AS
SELECT CREATE_MS, PAGE_ID, TIME_ON_LOAD_MS FROM WEBLOG;  


-- 13.3.3  After completing the materialized view build, validate optimal data
--         distribution by retrieving the clustering information.

-- 13.3.4  Run the following query:

SELECT SYSTEM$CLUSTERING_INFORMATION
( 'MV_TIME_TO_LOAD' , '(PAGE_ID)' );


-- 13.3.5  Review the query results:

    {
    "cluster_by_keys" : "LINEAR(PAGE_ID)",
    "total_partition_count" : 6348,
    "total_constant_partition_count" : 0,
    "average_overlaps" : 1.9855,
    "average_depth" : 2.0046,
    "partition_depth_histogram" : {
        "00000" : 0,
        "00001" : 0,
        "00002" : 6330,
        "00003" : 7,
        "00004" : 11,
        "00005" : 0,
        "00006" : 0,
        "00007" : 0,
        "00008" : 0,
        "00009" : 0,
        "00010" : 0,
        "00011" : 0,
        "00012" : 0,
        "00013" : 0,
        "00014" : 0,
        "00015" : 0,
        "00016" : 0
            }
    }


-- 13.3.6  Check the runtime for the same query against the Materialized View.
--         Testing shows the response time is similar to the lookup by CREATE_MS
--         column against the base table.

-- 13.3.7  Run the following query:

SELECT COUNT(*),AVG(TIME_TO_LOAD_MS) AVG_TIME_TO_LOAD FROM MV_TIME_TO_LOAD WHERE PAGE_ID=100000;

--         This is a substantial improvement in terms of query performance.

-- 13.3.8  Check the query profile. Notice that with the TableScan[1] operator
--         the partition pruning is very effective:
--         Partition scanned: 1
--         Partition total: 6381
--         Materialized View Profile

-- 13.3.9  Use the SHOW command to display information about the materialized
--         view created:

SHOW MATERIALIZED VIEWS ON weblog;

--         Show Materialized Views
