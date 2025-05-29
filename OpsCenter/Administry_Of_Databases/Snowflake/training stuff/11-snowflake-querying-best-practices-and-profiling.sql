
-- 11.0.0  Snowflake Querying Best Practices and Profiling
--         This lab will take approximately 30 minutes to complete.
--         The Query Profile, available through the Snowflake web interface,
--         provides execution details for a query. For the selected query, it
--         provides a graphical representation of the main components of the
--         processing plan for the query, with statistics for each component,
--         along with details and statistics for the overall query.
--         The Query Profile includes the following features:
--         The operator tree representing a graphical representation of all
--         operator nodes the execution engine will perform, reading the results
--         from bottom to top, and from left to right.
--         Operators are the functional building blocks of a query. They are
--         responsible for different aspects of data management and processing,
--         including data access, transformations, and updates.
--         Node list displays a collapsible list of operator nodes by execution
--         time.
--         Link representing the data flow between each operator node. Each link
--         provides the amount of data processed in terms of number of rows
--         processed.
--         Percentage represents the fraction of time that this operator
--         consumed within the query step (e.g., 25% for Aggregate [5]). This
--         information is also reflected in the orange bar at the bottom of the
--         operator node, allowing for easy visual identification of
--         performance-critical operators.
--         - Using the Query Profile.
--         - Using other resources for understanding the Query Profile.
--         - Reviewing best practices of efficient SQL queries in Snowflake.
--         - Provide filters in the query to assist the SQL pruner in
--         restricting data access.
--         - Explore GROUP BY and ORDER BY operation performance.
--         - Use a ORDER BY performance example.
--         - Explore the LIMIT clause.
--         - Understand JOIN Optimizations in Snowflake.
--         - Learn dynamic partition pruning.

-- 11.1.0  Learn to Use the Query Profile
--         Learn to use the Snowflake Query Profile to read the execution plan
--         of a query including the various SQL operations and performance
--         metrics.

-- 11.1.1  Navigate to Worksheets and create a new worksheet:

-- 11.1.2  Give this worksheet the name Query Profile.

-- 11.1.3  Run the the following commands to set context and disable use of the
--         query result cache:

USE role training_role;
USE warehouse BADGER_QUERY_WH;
USE database snowflake_sample_data;
USE schema tpcds_sf10tcl;

ALTER session set
use_cached_result = false;


-- 11.1.4  Run Query 3 of the TPCDS_SF10TCL schema.
--         The query reports the total extended sales price per item brand of a
--         specific manufacturer (939) for all sales in a specific month of the
--         year (month 12).

-- 11.1.5  Run the query:

SELECT  dt.d_year
    ,item.i_brand_id brand_id
    ,item.i_brand brand
    ,sum(ss_net_profit) sum_agg
FROM  date_dim dt
    ,store_sales
    ,item
WHERE dt.d_date_sk = store_sales.ss_sold_date_sk
AND store_sales.ss_item_sk = item.i_item_sk
AND item.i_manufact_id = 939
AND dt.d_moy=12
GROUP BY
dt.d_year,item.i_brand,item.i_brand_id
ORDER BY
dt.d_year ,sum_agg desc, brand_id
LIMIT 100;

--         The preceding query may exceed 90 seconds is using a medium-sized
--         warehouse. Be aware that some queries listed here may take longer to
--         execute. Approximate times will be posted if they exceed 60 seconds,
--         i.e., one (1) minute.

-- 11.1.6  Access the Query Profile; in the Results section of the Worksheet
--         click on Query ID.
--         Show Query ID
--         Be aware that the numbers and results shown here might not exactly
--         match the results your queries display.

-- 11.1.7  The following shows the query profile for Query 3 of TPC-DS
--         benchmark.
--         Profiler
--         Some of the operations in this query graph display impressive metrics
--         which we will review in the next task.

-- 11.1.8  List Operator Nodes by Execution Time
--         A collapsible panel in the operator tree pane lists nodes by
--         execution time in descending order, which enables users to quickly
--         locate the costliest operator nodes in terms of execution time.

-- 11.1.9  Click on the collapsible panel info and it displays the only one (1)
--         operator: TableScan [7].
--         TableScan Operation
--         This is the only operator whose execution time is more or greater
--         than one (1) minute.

-- 11.1.10 Review the Operator Tree
--         The tree provides a graphical representation of the operator nodes
--         that comprise the query and the links that connect each operator.

-- 11.1.11 Examine the TableScan operation TableScan[7]: access to the largest
--         table, store_sales. The partitioning pruning metric for this
--         operator:
--         This is the only operator with an execution time more than one (1)
--         minute.

-- 11.1.12 Examine the JoinFilter operation JoinFilter [8]: Special filtering
--         operation that removes tuples from the table, store_sales, that can
--         be identified as not possibly matching the condition of the Join 10,
--         further in the query plan.
--         It provides a big row reduction in this example: of the total rows
--         out of the store_sales table many are removed and only 2.846M rows
--         remain for the Join 10 condition:
--         ITEM.I_ITEM_SK=STORE_SALES.SS_ITEM_SK
--         Join Filter
--         Several of the major operators that follow complete well under the
--         one (1) minute mark.

-- 11.1.13 Examine the Aggregate operation Aggregate [2]: groups input and
--         compute aggregate functions, representing SQL constructs of GROUP BY
--         with attributes.
--         Aggregate

-- 11.1.14 Attributes:
--         Grouping Keys DT.D_YEARITEM.I_BRANDITEM.I_BRAND_ID
--         Aggregate Functions SUM(STORE_SALES.SS_NET_PROFIT)
--         The number of input records to the Aggregate operator is 1.353M rows
--         and the output is 258. This row set size is relatively small, which
--         results in fast execution time of the operator.

-- 11.1.15 Network:
--         Another interesting point about the Aggregate operator is that it
--         runs in parallel on the compute nodes of the virtual warehouse, to
--         process the data local to each compute node. The Network metric,
--         2.44MB in this example, represents the amount of data being shuffled
--         across nodes for final grouping result. Again, this is a relatively
--         small amount of data being shuffled and contributes to the overall
--         speed of the query execution.

-- 11.1.16 Examine the Sort operation Sort [4]: orders input on expression.
--         The sort keys define the sorting order:
--         Sort keys: DT.D_YEAR ASC NULLS LASTSUM (STORE_SALES.SS_NET_PROFIT)
--         DESC NULLS FIRSTITEM.I_BRAND_ID ASC NULLS LAST
--         100 - Number of rows
--         0 - Offset
--         The sort operator has the LIMIT property being pushed down for
--         performance optimization.
--         SortWithLimit

-- 11.2.0  Resources for Understanding the Query Profile
--         The documentation contains detailed explanation on other operators
--         you may observed in a query profile:
--         https://docs.snowflake.com/en/user-guide/ui-query-profile.html
--         Additional details included in the overview/detail pane, which is
--         divided into three (3) sections:
--         Operator Details:
--         Execution Time:
--         Execution time provides information about where time was spent during
--         the querying process. Time spent can be broken down into the
--         following categories, and are displayed in the following order:
--         Statistics:
--         A major source of information provided in the Detail panel is the
--         various statistics, grouped in the following sections:

-- 11.3.0  Review the Best Practices of Efficient SQL Queries in Snowflake

-- 11.3.1  Overview and Objectives:
--         User submits SQL queries to interact with data and objects in the
--         Snowflake database. Effective query formulation and retrieval can
--         have significant impact on query performance which in turn optimizes
--         compute usage and credit consumption.
--         This lab will go through examples of common query constructs and
--         review the query profiles for understanding the performance of
--         processing various query constructs. This is to help spot both best
--         practices of designing high performing SQL queries as well as typical
--         issues in SQL query expressions that may cause performance
--         bottlenecks and improvement opportunities.

-- 11.3.2  Best practices for writing efficient high performing SQL queries:

-- 11.3.3  Key benefits:
--         Writing effective high performing SQL queries will result in
--         efficiency of compute usage (virtual warehouse) and cost
--         optimization.

-- 11.3.4  TPCH Benchmark Schema
--         TPCH Schema

-- 11.4.0  Provide Filter in Query to Assist SQL Pruner for Restricting Data
--         Access
--         The objective is to review performance benefits and implications of
--         filter design using best practices.

-- 11.4.1  Provide filter in WHERE clause to restrict dataset as much as
--         possible.

-- 11.4.2  Additionally, use columns matching the table’s clustering dimensions
--         will provide the best skipping/pruning of micro-partitions as such
--         filter allows you query to access only relevant subsets of data which
--         improves performance and reduces costs.

-- 11.4.3  Navigate to Worksheets and create a new worksheet.

-- 11.4.4  Name the Worksheet Filter Design.

-- 11.4.5  Set the following as context:

USE role training_role;
USE warehouse BADGER_QUERY_WH;
USE database snowflake_sample_data;
USE schema TPCH_SF1000;

ALTER SESSION SET USE_CACHED_RESULT = false;


-- 11.4.6  Filter Column Matches Table’s Clustering Column

-- 11.4.7  Run the following query:

SELECT
    c_custkey,
    c_name,
    sum(l_extendedprice * (1 - l_discount)) as revenue,
    c_acctbal,
    n_name,
    c_address,
    c_phone,
    c_comment
FROM
    customer,
    orders,
    lineitem,
    nation
WHERE
    c_custkey = o_custkey
and l_orderkey = o_orderkey
and o_orderdate >= to_date('1993-10-01')
and o_orderdate < dateadd(month, 3, to_date('1993-10-01'))
and l_returnflag = 'R'
and c_nationkey = n_nationkey
GROUP BY
    c_custkey,
    c_name,
    c_acctbal,
    c_phone,
    n_name,
    c_address,
    c_comment
ORDER BY
    3 desc
LIMIT 20;


-- 11.4.8  Access the query profile after the execution completes

-- 11.4.9  Click on the TableScan [4] operator as screen capture below.

-- 11.4.10 Take note of the performance metrics:

-- 11.4.11 The SQL pruner skips a small portion of partitions. This corresponds
--         to the following filter:

-- 11.4.12 The table ORDERS is not well clustered on the predicate column
--         ORDERDATE.
--         Orders Table Query Profiler

-- 11.4.13 Check the clustering quality of filter column, ORDERDATE by running
--         the command:

SELECT SYSTEM$CLUSTERING_INFORMATION( 'orders' , '(o_orderdate)' );


-- 11.4.14 Review the result:
--         Documentation link for more understanding and details of clustering
--         information:
--         https://docs.snowflake.com/en/user-guide/tables-clustering-
--         micropartitions.html

-- 11.4.15 Filter Column Does NOT Match Table’s Clustering Column.

-- 11.4.16 Review the same query profile as in Task 1.

-- 11.4.17 Click on the TableScan [6] operator as shown in the screen capture
--         below.

-- 11.4.18 Take note of the performance metrics:
--         Partitions scanned (860), partitions and total partitions (860) as in
--         the example shown.

-- 11.4.19 Table note of the following observations:
--         The SQL pruner did not skip any partition when reading the table
--         CUSTOMER.
--         The reason there is no WHERE predicate for CUSTOMER table and the
--         JOIN condition is (ORDERS.O_CUSTKEY = CUSTOMER.C_CUSTKEY) and
--         CUSTOMER table is not clustered by c_custkey.
--         No where Predicate

-- 11.4.20 Check the clustering quality of filter column, c_custkey by running
--         the following command:

SELECT SYSTEM$CLUSTERING_INFORMATION( 'customer' , '(c_custkey)' );


-- 11.4.21 Examine the results:

-- 11.4.22 The histogram shows that all of the micro-partitions are grouped at
--         the lower-end of the histogram:
--         Note the following documentation link for more understanding and
--         details regarding clustering:
--         https://docs.snowflake.com/en/user-guide/tables-clustering-
--         micropartitions.html

-- 11.5.0  Explore GROUP BY and ORDER BY Operation Performance

-- 11.5.1  Review performance benefits and implications GROUP BY column usage
--         scenarios.
--         The following scenarios have more limited requirement on compute
--         resources, thereby contributing to faster query performance:

-- 11.5.2  GROUP BY with low cardinality columns.

-- 11.5.3  Run the following query, query 1 of TPCH schema:

SELECT
l_returnflag,
l_linestatus,
sum(l_quantity) as sum_qty,
sum(l_extendedprice) as sum_base_price,
sum(l_extendedprice * (1-l_discount)) 
  as sum_disc_price,
sum(l_extendedprice * (1-l_discount) * 
  (1+l_tax)) as sum_charge,
avg(l_quantity) as avg_qty,
avg(l_extendedprice) as avg_price,
avg(l_discount) as avg_disc,
count(*) as count_order
FROM
lineitem
WHERE
l_shipdate <= dateadd(day, -90, to_date('1998-12-01'))
GROUP BY
l_returnflag,
l_linestatus
ORDER BY
l_returnflag,
L_linestatus;


-- 11.5.4  Select to view the query profile.

-- 11.5.5  Click on the operator Aggregate [1].

-- 11.5.6  Take note of the performance metrics for this operator.
--         Note the following items:
--         No Bottleneck

-- 11.6.0  ORDER BY Performance Example

-- 11.6.1  Select to view the same query profile as example above.

-- 11.6.2  Click on the operator Sort [4].

-- 11.6.3  Take note of the performance metrics for this operator.
--         Note the following items:
--         No Bottleneck

-- 11.6.4  GROUP BY using column matching table’s clustering column.
--         In the GROUP BY clause, use column matching clustering order. The
--         query optimizer can push down partition pruning to benefit
--         performance.

-- 11.6.5  Run the following query:

SELECT l_shipdate, count( * )
FROM lineitem
GROUP BY 1
ORDER BY 1;


-- 11.6.6  Access the query profile after the execution completes.

-- 11.6.7  Click on the TableScan [2] operator as screen capture below.

-- 11.6.8  Take note of the performance metrics:

-- 11.6.9  Note the following item:
--         High Correlation

-- 11.6.10 Check the clustering quality of filter column, l_shipdate using the
--         following command:

SELECT SYSTEM$CLUSTERING_INFORMATION( 'lineitem' , '(l_shipdate)' ); 

--         Review the result:

-- 11.7.0  Explore the LIMIT Clause
--         Applying a LIMIT clause to a query does not affect the amount of data
--         tread. It merely limits the results set output.
--         Take note of the following best practices:

-- 11.7.1  Using LIMIT to limit the Result_Set.

-- 11.7.2  Execute the following query:

SELECT
S.SS_SOLD_DATE_SK,
R.SR_RETURNED_DATE_SK,
S.SS_STORE_SK,
S.SS_ITEM_SK,
S.SS_CUSTOMER_SK,
S.SS_TICKET_NUMBER,
S.SS_QUANTITY,
S.SS_SALES_PRICE,
S.SS_CUSTOMER_SK,
S.SS_STORE_SK,
S.SS_QUANTITY,
S.SS_SALES_PRICE,
R.SR_RETURN_AMT
FROM SNOWFLAKE_SAMPLE_DATA.TPCDS_SF10TCL.STORE_SALES  S
INNER JOIN SNOWFLAKE_SAMPLE_DATA.TPCDS_SF10TCL.STORE_RETURNS  R on R.SR_ITEM_SK=S.SS_ITEM_SK
WHERE  S.SS_ITEM_SK =4164
LIMIT 100;


-- 11.7.3  Review the query profile:
--         Using LIMIT
--         Note the following items:

-- 11.8.0  Join Optimizations in Snowflake
--         Join is one of the most resource intensive operations. Snowflake
--         optimizer provides built-in dynamic partition pruning to help reduce
--         data access during join processing.

-- 11.8.1  Take note of the following best practices:
--         Use JOIN filter column that matches the table’s clustering column so
--         the query optimizer can push down partition pruning to the larger
--         table (which is usually the probe side of Hash Join).

-- 11.9.0  Dynamic Partition Pruning
--         This exercise will run through the best practices for pruning
--         partitions.

-- 11.9.1  Run the following query:

USE SCHEMA snowflake_sample_data.tpcds_sf10tcl;
SELECT count(ss_customer_sk)
FROM store_sales JOIN date_dim d
ON ss_sold_date_sk = d_date_sk
WHERE d_year = 2000
GROUP BY ss_customer_sk;


-- 11.9.2  Select to view the query profile.
--         Dynamic Partition Pruning

-- 11.9.3  Click on the operator TableScan [4].

-- 11.9.4  Take note of the performance metrics for this operator:
--         Partitions scanned (16505), partitions and total partitions (84577)
--         as in the example shown.

-- 11.9.5  Observe the following conditions:
--         D.D_DATE_SK = STORE_SALES.SS_SOLD_DATE_SK

-- 11.9.6  Check the clustering quality of predicate column ss_sold_date_sk in
--         store_sales table using the following command:

SELECT SYSTEM$CLUSTERING_INFORMATION( 'snowflake_sample_data.tpcds_sf10tcl.store_sales', '(ss_sold_date_sk)');


-- 11.9.7  The table is well clustered around the ss_sold_date_sk dimension:
--         The clustering depth is very low: 1.3368
--         The histogram shows that there are most micro-partitions groups are
--         at the top range (most at an overlap depth of 01).
