
-- 12.0.0  (Optional) Troubleshooting Tools and Tuning Performance Metrics
--         This lab will take approximately 30-40 minutes to complete.
--         This lab provides examples for identifying some of the most common
--         performance bottlenecks and issues you may encounter when running
--         queries in Snowflake. These exercises will also demonstrate the set
--         of SQL operations that are most commonly associated with these
--         performance bottlenecks and issues.
--         - Key metrics that impact performance.
--         - Tools within snowflake that query performance management and
--         monitoring.
--         - Testing spillage to local and remote storage.
--         - Using large GROUP BY functions.
--         - Review clustering statements for improving performance.
--         - Dealing with issues such as a JOIN explosion.
--         - Tuning the timeout parameter to manage rogue queries.

-- 12.1.0  Key Metrics Impacting Performance

-- 12.2.0  Toolkit for Query Performance Management and Monitoring

-- 12.2.1  Navigate to Worksheets and create a new worksheet.

-- 12.2.2  Give it the name Performance Metrics.

-- 12.2.3  Set the following as context:

USE role training_role;
USE warehouse BADGER_query_wh;
USE database snowflake_sample_data;
USE schema tpcds_sf10tcl;


-- 12.3.0  Spilling to Local Storage and Remote Storage - Large Sort
--         In this scenario, we will examine large window operations with ORDER
--         BY operations, which can cause spillage to disk, i.e. local storage.
--         The next few statements list detailed catalog sales data together
--         with a running sum of sales price within the order.

-- 12.3.1  Set the virtual warehouse to EXTRA-SMALL and run the following
--         queries:

USE SCHEMA snowflake_sample_data.tpcds_sf10tcl;
ALTER SESSION SET USE_CACHED_RESULT = FALSE;
ALTER WAREHOUSE BADGER_query_wh SUSPEND;
ALTER WAREHOUSE BADGER_query_wh SET WAREHOUSE_SIZE = XSMALL;
ALTER WAREHOUSE BADGER_query_wh RESUME;

SELECT cs_bill_customer_sk, cs_order_number, i_product_name, cs_sales_price
    , SUM(cs_sales_price) OVER (PARTITION BY cs_order_number
       ORDER BY i_product_name
       ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) running_sum
  FROM catalog_sales, date_dim, item
 WHERE cs_sold_date_sk = d_date_sk
   AND cs_item_sk = i_item_sk
   AND d_year IN (2000) AND d_moy IN (1,2,3,4,5,6)
 LIMIT 100;


-- 12.3.2  Select Query ID and view the query profile results

-- 12.3.3  Click on the operator WindowFunction [1].
--         Take note of the performance metrics for this operator:
--         Take note of the response time on an XSMALL warehouse: a bit over 4
--         minutes.
--         Observe Window Function

-- 12.3.4  Using a MEDIUM virtual warehouse

-- 12.3.5  Run the following statements:

-- 12.3.6  Re-run the above query

-- 12.3.7  Select to view the query profile

-- 12.3.8  Click on the operator WindowFunction [1]
--         Take note of the performance metrics for this operator:
--         Take note of the response time on a MEDIUM warehouse: around 1 minute
--         9 seconds
--         The spillage remained the same, but the time to complete the query
--         was about one-quarter of the original time.
--         Observe Window Function

-- 12.3.9  Using a LARGE virtual warehouse

-- 12.3.10 Run the following statements:

-- 12.3.11 Re-run the above query.

-- 12.3.12 Select to view the query profile.

-- 12.3.13 Click on the operator WindowFunction [1].
--         Take note of the performance metrics for this operator:
--         Take note of the response time on a LARGE warehouse: slightly over 30
--         seconds!
--         This time, there was no spillage to local storage and the time to
--         complete the query was halved.
--         Observe Window Function
--         Note the following observations:
--         Snowflake’s architecture allows for linear scaling of compute
--         resources, enabling both better performance and lower cost at the
--         same time!
--         Credit Consumption by Warehouse Size

-- 12.4.0  Large GROUP BY
--         The next few examples demonstrate how a large GROUP BY query can
--         produce much spillage to disk.

-- 12.4.1  Using a SMALL virtual warehouse
--         Run the following query, which summarizes the average prices and
--         quantities for the catalog sales that are split by gender for the
--         first half year of 2000:

use schema SNOWFLAKE_SAMPLE_DATA.tpcds_sf10tcl;

ALTER SESSION SET USE_CACHED_RESULT = false;
ALTER WAREHOUSE BADGER_query_wh SUSPEND;
ALTER WAREHOUSE BADGER_query_wh SET WAREHOUSE_SIZE = SMALL;
ALTER WAREHOUSE BADGER_query_wh RESUME;

SELECT cd_gender
    , AVG(lp) average_list_price
    , AVG(sp) average_sales_price
    , AVG(qu) average_quantity
  FROM (
        SELECT cd_gender, cs_order_number, AVG(cs_list_price) lp
            , AVG(cs_sales_price) sp, AVG(cs_quantity) qu
        FROM catalog_sales, date_dim, customer_demographics
        WHERE cs_sold_date_sk = d_date_sk
        AND cs_bill_cdemo_sk = cd_demo_sk
        AND d_year IN (2000) AND d_moy IN (1,2,3,4,5,6,7,8,9,10)
        GROUP BY cd_gender, cs_order_number
        ) inner_query
  GROUP BY cd_gender;


-- 12.4.2  Select the Query ID to view the query profile

-- 12.4.3  Click on the operator Aggregate [1]
--         Take note of the performance metrics for this operator:
--         Take note of the response time on a SMALL warehouse: slightly less
--         than 3 minutes
--         Observe Window Function
--         Appropriate Solution: Remove symptom of spilling to local storage
--         (and remote storage if that also occurs) by sizing up the virtual
--         warehouse.

-- 12.4.4  Confirm the results of using a MEDIUM virtual warehouse

-- 12.4.5  Set the following statements including increasing the virtual
--         warehouse size to medium:

ALTER WAREHOUSE BADGER_query_wh SUSPEND;
ALTER WAREHOUSE BADGER_query_wh SET WAREHOUSE_SIZE = MEDIUM;
ALTER WAREHOUSE BADGER_query_wh RESUME;


-- 12.4.6  Re-run the above query.

-- 12.4.7  Select to view the query profile.

-- 12.4.8  Click on the operator Aggregate [1].
--         Aggregate in the Profiler
--         Take note of the performance metrics for this operator:
--         Aggregate Performance metrics
--         Take note of the response time on MEDIUM warehouse: approximately 1
--         min 30s.
--         Conclusion: Linear and dynamic scaling of compute resource for
--         performance improvement (due to reducing spilling to local storage).

-- 12.5.0  WHERE Clause (Filter) Column is Not the Clustering Dimension of the
--         Base Table
--         In this scenario, we will examine a large table scan symptom caused
--         by the query’s FILTER column, which is not the clustering dimension
--         of the base table.

-- 12.5.1  Run a query and review Performance Metrics.

-- 12.5.2  Run the following setup:

use schema SNOWFLAKE_SAMPLE_DATA.TPCH_SF1000;

ALTER SESSION SET USE_CACHED_RESULT = false;
ALTER WAREHOUSE BADGER_query_wh SUSPEND;
ALTER WAREHOUSE BADGER_query_wh SET WAREHOUSE_SIZE = MEDIUM;
ALTER WAREHOUSE BADGER_query_wh RESUME;
USE WAREHOUSE   BADGER_query_wh;

--         Run the following query:

SELECT COUNT(*)
FROM  lineitem
WHERE l_extendedprice < 30000;

--         The query results in around 244M rows.

-- 12.5.3  Select to view the query profile

-- 12.5.4  Click on the operator TableScan [2]
--         Take note of the performance metrics for this operator:
--         Profiler TableScan

-- 12.5.5  Review clustering

-- 12.5.6  Run the following statement:

SELECT SYSTEM$CLUSTERING_INFORMATION( 'lineitem' , '(l_extendedprice)' );

--         Notice the number of lines scanned.
--         Rows Scanned

-- 12.5.7  Take note of the table’s clustering quality on column
--         l_extendedprice:
--         Pruning Results
--         The table is poorly clustered around the l_extendedprice dimension.
--         Here are some results from the clustering statement:

-- 12.6.0  WHERE Clause (Filter) Column is the Clustering Dimension of the Base
--         Table
--         In this scenario, we will examine an efficient table scan when the
--         query’s FILTER column is the clustering dimension of the base table.

-- 12.6.1  Run a query and review performance metrics

-- 12.6.2  Run the following setup to configure the context

USE SCHEMA SNOWFLAKE_SAMPLE_DATA.TPCH_SF1000;

ALTER SESSION SET USE_CACHED_RESULT = false;
ALTER WAREHOUSE BADGER_query_wh SUSPEND;
ALTER WAREHOUSE BADGER_query_wh SET WAREHOUSE_SIZE = MEDIUM;
ALTER WAREHOUSE BADGER_query_wh RESUME;
USE WAREHOUSE   BADGER_query_wh;


-- 12.6.3  Run the following query:

SELECT COUNT(*)
FROM lineitem
WHERE l_shipdate > to_date('1995-03-15');

--         The query returns results around 323M rows.
--         Rows Scanned

-- 12.6.4  Select to view the query profile.

-- 12.6.5  Click on the operator TableScan [2]
--         Take note of the performance metrics for this operator. This shows
--         poor pruning.
--         Review Clustering

-- 12.6.6  Review clustering

-- 12.6.7  Run the following statement:

SELECT SYSTEM$CLUSTERING_INFORMATION( 'lineitem' , '(l_extendedprice)' ); 

--         Take note of the table’s clustering quality on column l_shipdate:

-- 12.6.8  Summary of clustering performance tuning.
--         The amount of data scanned by a query is directly related to how well
--         a query’s WHERE clause column correlates to the clustering dimension
--         of the table being accessed.
--         In the Data Clustering Tuning lab, we will tackle the technique of
--         tuning the table’s clustering dimension based on the query access
--         (FILTER columns) requirements.

-- 12.7.0  Rogue Query Symptoms from Join Explosion
--         In this scenario, we will explore run away query symptoms which are
--         common in real workloads. One common type of rogue query includes
--         join pitfalls like explosion of output and unintentional cross join.

-- 12.7.1  Join on a non-unique key.

-- 12.7.2  Run the following setup:

USE SCHEMA  snowflake_sample_data.tpcds_sf100tcl;

ALTER SESSION SET USE_CACHED_RESULT = false;
ALTER WAREHOUSE BADGER_query_wh SUSPEND;
ALTER WAREHOUSE BADGER_query_wh SET WAREHOUSE_SIZE = MEDIUM;
ALTER WAREHOUSE BADGER_query_wh RESUME;
USE WAREHOUSE   BADGER_query_wh;


-- 12.7.3  Run the following query which joins non-unique key (a join pitfall):

SELECT
S.SS_SOLD_DATE_SK,
R.SR_RETURNED_DATE_SK ,
S.SS_STORE_SK,
S.SS_ITEM_SK,
S.SS_SALES_PRICE,
S.SS_SALES_PRICE,
R.SR_RETURN_AMT
FROM STORE_SALES  S
INNER JOIN STORE_RETURNS  R
on R.SR_ITEM_SK=S.SS_ITEM_SK
WHERE  S.SS_ITEM_SK =4164;

--         This query will likely take 3-5 minutes to finish.

-- 12.7.4  After one (1) minute, click on Abort to terminate the query.

-- 12.7.5  Review the Query Profile

-- 12.7.6  Select Query ID to view the query profile
--         Take note of the performance metrics for operator JOIN [5]:
--         The join produces over 6B rows from the two input data sets, 25k and
--         233k respectively.
--         Note also the pruning that was performed. Was the pruning effective?
--         Join Explosion
--         To avoid performance issues with joins that can possibly explode the
--         outputs, the best practice is to join on unique keys. If it is not
--         possible to join on unique keys, consider other options including the
--         following:

-- 12.8.0  Tune the Timeout Parameter to Manage Rogue Queries
--         In this exercise, we will explore tuning the timeout parameter to
--         manage long running workloads.

-- 12.8.1  Review the existing value of the time out parameter

SHOW parameters in warehouse BADGER_query_wh;


-- 12.8.2  Review the output of the show command:
--         Review the Show Command
--         It shows that the statement_timeout_in_seconds of the virtual
--         warehouse has the following values:
--         Values:
--         Default:

-- 12.8.3  Modify the statement_timeout_in_seconds parameter to 60 seconds;

ALTER WAREHOUSE BADGER_query_wh SET statement_timeout_in_seconds = 60;


-- 12.8.4  Re-execute the query by running the following statements:

ALTER SESSION SET USE_CACHED_RESULT = false;
USE WAREHOUSE BADGER_query_wh;


-- 12.8.5  Run the same SELECT statement again:

SELECT
S.SS_SOLD_DATE_SK,
R.SR_RETURNED_DATE_SK ,
S.SS_STORE_SK,
S.SS_ITEM_SK,
S.SS_SALES_PRICE,
S.SS_SALES_PRICE,
R.SR_RETURN_AMT
FROM STORE_SALES  S
INNER JOIN STORE_RETURNS  R
on R.SR_ITEM_SK=S.SS_ITEM_SK
WHERE  S.SS_ITEM_SK =4164;


-- 12.8.6  The statement is terminated by the system
--         After the above query runs for 1 minute, it receives the following
--         error; it is cancelled by the system as the execution time exceeds
--         the time out limit of 60 seconds.
--         Statement Timed Out

-- 12.8.7  Execute the following command to revert the time out change:

ALTER warehouse BADGER_query_wh SET statement_timeout_in_seconds = 0;


-- 12.8.8  Confirm the parameters have been reset

SHOW parameters in warehouse BADGER_query_wh;


-- 12.9.0  Using the Query Tag to Identify and Track Queries for Monitoring
--         In this exercise, we will examine how to set the QUERY_TAG parameter
--         to track queries executed within a session.
--         This additional metadata can be queried later for tracking purposes:

-- 12.9.1  Review the existing value of the Query_TAG parameter by running the
--         following statement:

SHOW parameters LIKE '%query_tag%' for session;

--         The query result will similar to the following:
--         Statement Timed Out

-- 12.9.2  Update the QUERY_TAG parameter:

ALTER SESSION SET QUERY_TAG = 'join pitfalls';


-- 12.9.3  Add a LIMIT clause to the join explosion query in the previous
--         exercise and run the query:

USE SCHEMA  snowflake_sample_data.tpcds_sf100tcl;
ALTER SESSION SET USE_CACHED_RESULT = false;
USE WAREHOUSE BADGER_query_wh;

SELECT
s.ss_sold_date_sk,
r.sr_returned_date_sk,
s.ss_store_sk,
r.sr_returned_date_sk,
s.ss_item_sk,
s.ss_sales_price,
r.sr_return_amt
FROM store_sales s
INNER JOIN store_returns r
ON  r.sr_item_sk=s.ss_item_sk
WHERE s.ss_item_sk = 4164
LIMIT 100;


-- 12.9.4  Use the HISTORY UI and the Query Tag filter to look for the previous
--         query executed with new tagging
--         The step may appear similar to the following screenshot:
--         History WebUI
--         Additionally, use the tagging when scanning the
--         INFORMATION_SCHEMA.QUERY_HISTORY system table:

SELECT query_id, query_tag
FROM
TABLE (information_schema.query_history())
WHERE
query_tag LIKE '%join%';

--         The final result may appear similar to the following:
--         Query Tag Example

-- 12.9.5  If time permits, go back and modify the existing variables of the
--         previous queries

-- 12.9.6  Identify any other options that can be used to improve the queries
--         used here
