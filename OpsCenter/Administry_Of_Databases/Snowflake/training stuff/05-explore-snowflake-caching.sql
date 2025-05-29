
-- 5.0.0   Explore Snowflake Caching
--         This lab will take approximately 25-30 minutes to complete.
--         - Learn about the different types of caching used by Snowflake,
--         specifically metadata caching.
--         - Identify the role of data caching in the compute cluster.
--         - Explore query result caching.

-- 5.1.0   Metadata Caching

-- 5.1.1   Open a new worksheet and name it Caching.

-- 5.1.2   Set the context as follows:

-- 5.1.3   Alternatively, you can set the context using SQL:

USE ROLE TRAINING_ROLE;
USE WAREHOUSE BADGER_QUERY_WH;
USE SCHEMA SNOWFLAKE_SAMPLE_DATA.TPCH_SF100;


-- 5.1.4   Suspend your warehouse:

ALTER WAREHOUSE BADGER_QUERY_WH SUSPEND;

--         Be aware, if your warehouse is already suspended, the Web UI will
--         display an error. You can safely ignore it.

-- 5.1.5   Run the following query:

SELECT MIN(l_orderkey), MAX(l_orderkey), COUNT(*) FROM lineitem;


-- 5.1.6   Click the Query ID at the top of the result pane, then click the link
--         to open the profile.

-- 5.1.7   Click the profile tab. It should show that 100% of the result came
--         from metadata cache:
--         Query Profile - Metadata Cache Result
--         If your results did not come from the metadata cache, where did they
--         come from? Can you explain why?

-- 5.2.0   Data Caching in the Compute Cluster

-- 5.2.1   Disable USE_CACHED_RESULT so you are only using metadata cache and
--         the data cache (not the query result cache):

ALTER SESSION SET USE_CACHED_RESULT = FALSE;


-- 5.2.2   Run Query 1 of the TPCH benchmark. This will automatically resume
--         your warehouse:

SELECT l_returnflag, l_linestatus,
SUM(l_quantity) AS sum_qty,
SUM(l_extendedprice) AS sum_base_price,
SUM(l_extendedprice * (l_discount)) AS sum_disc_price, SUM(l_extendedprice * (l_discount) * (1+l_tax))
   AS sum_charge,
AVG(l_quantity) AS avg_qty,
AVG(l_extendedprice) AS avg_price,
AVG(l_discount) AS avg_disc,
COUNT(*) as count_order
FROM lineitem
WHERE l_shipdate <= dateadd(day, 90, to_date('1998-12-01'))
GROUP BY l_returnflag, l_linestatus
ORDER BY l_returnflag, l_linestatus;


-- 5.2.3   Review the Query Profile and view the metric Percentage Scanned from
--         Cache.
--         What do you see? Is it what you expected?
--         Since the query is being run for the first time on a newly resumed
--         warehouse, the cache will be cold, and all data will be read from
--         disk.

-- 5.2.4   Run the following query, with a slightly different WHERE clause:

SELECT l_returnflag, l_linestatus,
    SUM(l_quantity) AS sum_qty,
    SUM(l_extendedprice) AS sum_base_price,
    SUM(l_extendedprice * (l_discount)) AS sum_disc_price, SUM(l_extendedprice * (l_discount) * (1+l_tax))
    AS sum_charge,
    AVG(l_quantity) AS avg_qty,
    AVG(l_extendedprice) AS avg_price,
    AVG(l_discount) AS avg_disc,
    COUNT(*) as count_order
FROM lineitem
WHERE l_shipdate <= dateadd(day, 90, to_date('1998-12-01'))
and l_extendedprice <= 20000
GROUP BY l_returnflag, l_linestatus
ORDER BY l_returnflag, l_linestatus;


-- 5.2.5   Review the Query Profile.
--         Identify what happened to the caching metric. It should have
--         increased, since this query has a similar pattern to the previous
--         query so it could reuse some data from the data cache.

-- 5.2.6   Run the following query, which is similar, but JOINs the data to
--         another table:

SELECT l_orderkey,
SUM(l_extendedprice*(l_discount)) AS revenue,
o_orderdate, o_shippriority
FROM customer, orders, lineitem
WHERE C_mktsegment = 'BUILDING'
  AND c_custkey = o_custkey
  AND l_orderkey = o_orderkey
  AND o_orderdate < to_date('1995-03-15')
  AND l_shipdate > to_date('1995-03-15')
GROUP BY l_orderkey, o_orderdate, o_shippriority
ORDER BY 2 DESC, o_orderdate
LIMIT 10;


-- 5.2.7   Review the Query Profile once again.
--         Did you see what you expected to see?
--         There will still be some Percentage Scanned from Cache, but it will
--         not be as high as in the previous step. This is because you joined it
--         to another table, so more of the data was not already loaded into
--         cache.

-- 5.3.0   Explore Query Result Caching

-- 5.3.1   Suspend your warehouse, to clear the data cache:

ALTER WAREHOUSE BADGER_QUERY_WH SUSPEND;


-- 5.3.2   Set USE_CACHED_RESULT back to TRUE:

ALTER SESSION SET USE_CACHED_RESULT=TRUE;


-- 5.3.3   Set the Worksheet contexts as follows:

-- 5.3.4   Alternatively, you can set the context using SQL:

USE ROLE TRAINING_ROLE;
USE WAREHOUSE BADGER_QUERY_WH;
USE SNOWFLAKE_SAMPLE_DATA.TPCH_SF100;


-- 5.3.5   Run Query 1 of the TPCH benchmark:

SELECT l_returnflag, l_linestatus,
    SUM(l_quantity) AS BADGER_sum_qty,
    SUM(l_extendedprice) AS sum_base_price,
    SUM(l_extendedprice * (l_discount)) AS sum_disc_price,
    SUM(l_extendedprice * (l_discount) * (1+l_tax)) AS sum_charge,
    AVG(l_quantity) AS avg_qty,
    AVG(l_extendedprice) AS avg_price,
    AVG(l_discount) AS avg_disc,
    COUNT(*) AS count_order
FROM lineitem
WHERE l_shipdate <= dateadd(day, 90, to_date('1998-12-01'))
GROUP BY l_returnflag, l_linestatus
ORDER BY l_returnflag, l_linestatus;


-- 5.3.6   Check the query profile. How much cache was used?

-- 5.3.7   Suspend your warehouse:

ALTER WAREHOUSE BADGER_QUERY_WH SUSPEND;


-- 5.3.8   Rerun Query 1 from the previous step. What do you think will happen?

-- 5.3.9   Bring up the Query Profile and check it.
--         The query completed without using a warehouse, because the results
--         were accessible in the query result cache.

-- 5.3.10  Grant privileges to your warehouse to the role SYSADMIN, and then
--         change to that role:

GRANT USAGE ON WAREHOUSE BADGER_QUERY_WH TO ROLE SYSADMIN;
USE ROLE SYSADMIN;


-- 5.3.11  Re-run the query. What do you think will happen?

SELECT l_returnflag, l_linestatus,
    SUM(l_quantity) AS BADGER_sum_qty,
    SUM(l_extendedprice) AS sum_base_price,
    SUM(l_extendedprice * (l_discount)) AS sum_disc_price,
    SUM(l_extendedprice * (l_discount) * (1+l_tax)) AS sum_charge,
    AVG(l_quantity) AS avg_qty,
    AVG(l_extendedprice) AS avg_price,
    AVG(l_discount) AS avg_disc,
    COUNT(*) AS count_order
FROM lineitem
WHERE l_shipdate <= dateadd(day, 90, to_date('1998-12-01'))
GROUP BY l_returnflag, l_linestatus
ORDER BY l_returnflag, l_linestatus;

--         Check the query profile. Did the new role use any cache? Why or why
--         not?
--         Everyone in class is using the SYSADMIN role, which cannot use the
--         query result cache from another role. However, the first students to
--         run the query as SYSADMIN will put the result set in the query result
--         cache for that role. Students who run the query later will use the
--         query result cache.

-- 5.3.12  Open a new worksheet, to start a new session.

-- 5.3.13  Set your context to TRAINING_ROLE, SNOWFLAKE_SAMPLE_DATA, TPCH_SF100,
--         and BADGER_WH:

USE ROLE TRAINING_ROLE;
USE WAREHOUSE BADGER_QUERY_WH;
USE SCHEMA SNOWFLAKE_SAMPLE_DATA.TPCH_SF100;

--         Run the query again. What do you think will happen?
--         Check the query profile. Was the query cached used? Why or why not?
--         ANSWER: The query cache was used, because it was run by someone in
--         the same role. So the query cache can be used across sessions as long
--         as it is in the same role.

-- 5.3.14  Change the line AS BADGER_sum_qty to AS BADGER_sum_qty_new and run
--         the query again.
--         What do you think will happen?

SELECT l_returnflag, l_linestatus,
    SUM(l_quantity) AS BADGER_sum_qty_new,
    SUM(l_extendedprice) AS sum_base_price,
    SUM(l_extendedprice * (l_discount)) AS sum_disc_price,
    SUM(l_extendedprice * (l_discount) * (1+l_tax)) AS sum_charge,
    AVG(l_quantity) AS avg_qty,
    AVG(l_extendedprice) AS avg_price,
    AVG(l_discount) AS avg_disc,
    COUNT(*) AS count_order
FROM lineitem
WHERE l_shipdate <= dateadd(day, 90, to_date('1998-12-01'))
GROUP BY l_returnflag, l_linestatus
ORDER BY l_returnflag, l_linestatus;

--         Check the query profile and the percentage of cache used.
--         The query result cache was not used, because the query was not
--         identical. However, most of the result was able to use the data
--         cache, stored on the virtual warehouse.
