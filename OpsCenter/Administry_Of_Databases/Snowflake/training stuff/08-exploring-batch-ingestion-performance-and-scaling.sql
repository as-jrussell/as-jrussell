
-- 8.0.0   Exploring Batch Ingestion Performance and Scaling
--         This lab will take approximately 15-30 minutes to complete (depending
--         on the types of warehouses used).
--         As a best practice in Snowflake, virtual warehouses are used for
--         workload segmentation. It is typical to dedicate a compute cluster
--         for ingesting data. As data volume increases, users can adjust the
--         compute resources to complete the ingestion workload faster.
--         Snowflake offers the concept of scaling up compute by offering
--         virtual warehouses in a range of t-shirt sizes which start at Extra-
--         Small (one node), through, Small, Medium, and Large, up to a massive
--         128 node 4X Large cluster. Each increment is designed to be double
--         the capacity of the previous cluster.
--         - Explore data size increases using the benchmark TPCH dataset scale
--         factors.
--         - Adjust and increase compute resources via the Snowflake virtual
--         warehouse t-shirt sizes as batch insert data size increases.
--         - Develop practical experience and note observations of the batch
--         insert throughput while scaling various virtual warehouse T-shirt
--         sizes.
--         This batch insert operation is an insert with SELECT, using lineitem
--         table with 150G holding 6 billion rows from the TPCH dataset. This is
--         a relatively straightforward operation for which there is no SQL
--         tuning necessary as it’s a pure brute force task, similar to many ELT
--         operations.

-- 8.1.0   Explore Data Size Increases Using TPCH Dataset Scale Factors
--         This exercise explores increasing data size for batch insert
--         workload, using the set of TPCH data set scale factors. The batch
--         insert will insert many millions of rows from the lineitem table into
--         a new table using insert with select operation.

-- 8.1.1   Navigate to Worksheets and create a new worksheet and name it Batch
--         Insert.

-- 8.1.2   Set the context for this worksheet tab:

USE WAREHOUSE BADGER_LOAD_WH;
USE DATABASE BADGER_DB;
USE SCHEMA PUBLIC;


-- 8.1.3   Execute the following statements to configure the warehouse:

ALTER WAREHOUSE BADGER_LOAD_WH SET WAREHOUSE_SIZE = 'XSMALL';
ALTER WAREHOUSE BADGER_LOAD_WH SUSPEND;
ALTER WAREHOUSE BADGER_LOAD_WH RESUME;


-- 8.1.4   Execute the following statement to insert the TPCH_SF1 lineitem
--         table, a 157MB file containing 6 millions:

CREATE OR REPLACE TRANSIENT TABLE lineitem_sf1 LIKE snowflake_sample_data.tpch_sf1.lineitem;
INSERT INTO lineitem_sf1 SELECT * FROM snowflake_sample_data.tpch_sf1.lineitem;

--         Navigate to the History tab and note the Total Elapsed Time (which
--         may be less than 10 seconds).

-- 8.1.5   Insert the TPCH_SF10 lineitem table, a 1.5GB file holding 60 millions
--         rows.
--         As data sizes increase, it is expected to adjust virtual warehouse
--         sizes to keep up with the workload.

-- 8.1.6   Feel free to explore increasing the virtual warehouse size as
--         following:

ALTER WAREHOUSE BADGER_LOAD_WH SET WAREHOUSE_SIZE = 'MEDIUM';
ALTER WAREHOUSE BADGER_LOAD_WH SUSPEND;
ALTER WAREHOUSE BADGER_LOAD_WH RESUME;


-- 8.1.7   Execute the following statement to insert 60 millions rows into a new
--         table.

CREATE OR REPLACE TRANSIENT TABLE lineitem_sf10 LIKE snowflake_sample_data.tpch_sf10.lineitem;
INSERT INTO lineitem_sf10 SELECT * FROM snowflake_sample_data.tpch_sf10.lineitem;


-- 8.1.8   Navigate to the History tab and note the Total Elapsed Time.

-- 8.1.9   Insert the TPCH_SF100 lineitem table, a 15GB file holding 600
--         millions rows.

-- 8.1.10  Explore increasing the virtual warehouse size as shown in the
--         following statements:

ALTER WAREHOUSE BADGER_LOAD_WH SET WAREHOUSE_SIZE = 'XLARGE';
ALTER WAREHOUSE BADGER_LOAD_WH SUSPEND;
ALTER WAREHOUSE BADGER_LOAD_WH RESUME;


-- 8.1.11  Execute the following statement to insert 600 millions rows into a
--         new table:

CREATE OR REPLACE TRANSIENT TABLE lineitem_sf100 LIKE snowflake_sample_data.tpch_sf100.lineitem;
INSERT INTO lineitem_sf100 SELECT * FROM snowflake_sample_data.tpch_sf100.lineitem;


-- 8.1.12  Navigate to the History tab and note the Total Elapsed Time.
--         As the data size increases, dynamically scaling up the compute
--         cluster will help to keep up with workload performance.

-- 8.2.0   Explore Batch Insert Rates with Scaling Virtual Warehouse Sizes
--         This exercise evaluates the batch insert throughput when scaling the
--         sizes of the virtual warehouses. This batch insert operation is an
--         insert with select, using lineitem table with 150G holding 6 billions
--         rows from TPCH dataset. The straightforward operation for which there
--         is no SQL tuning necessary as it’s a pure brute force task, is
--         similar to many ELT operations.

-- 8.2.1   The workload would be based on batching inserts with the TPCH_SF1000
--         lineitem table, 150GB, holding 6 billions rows:

CREATE OR REPLACE TRANSIENT TABLE lineitem_sf1000 LIKE snowflake_sample_data.tpch_sf1000.lineitem;
INSERT INTO lineitem_sf1000 SELECT * FROM snowflake_sample_data.tpch_sf1000.lineitem;


-- 8.3.0   Executing the Tests
--         Perform a test using warehouse sizes from x-small to 2x-large,
--         setting the warehouse_size value with one of the choices.

-- 8.3.1   Before choosing the virtual warehouse size, read on to the next step
--         to get some guidance on elapsed time result:

ALTER WAREHOUSE BADGER_LOAD_WH SET WAREHOUSE_SIZE = 'X-LARGE';
ALTER WAREHOUSE BADGER_LOAD_WH SUSPEND;
ALTER WAREHOUSE BADGER_LOAD_WH RESUME;


-- 8.3.2   Review results on virtual warehouse size vs elapsed time.
--         When executing the batch insert on the fixed size benchmark table,
--         observe that doubling virtual size will halve the elapsed time.
--         Fixed Size Benchmarks
--         Note the credit costs vs elapsed time: similar costs for twice as
--         fast, as billed per second.
--         Cost vs. Elapsed Time

-- 8.3.3   Execute the test using the commands in step 1 with your own choice of
--         virtual warehouse size, keeping in mind the above data points:

ALTER WAREHOUSE BADGER_LOAD_WH SET WAREHOUSE_SIZE = 'MEDIUM';
ALTER WAREHOUSE BADGER_LOAD_WH SUSPEND;
ALTER WAREHOUSE BADGER_LOAD_WH RESUME;

--         It is expected that the compute power scales linearly as the virtual
--         warehouse sizes increase, doubling the batch insert rate at each
--         increase.
--         Warehouse Linear Scaling
