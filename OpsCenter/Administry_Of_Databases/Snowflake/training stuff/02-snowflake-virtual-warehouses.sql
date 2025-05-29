
-- 2.0.0   Snowflake Virtual Warehouses
--         This lab will take approximately 30 minutes to complete.
--         This lab is designed to familiarize users with the Snowflake Web UI
--         interface and with critical Snowflake-specific administrative tasks.
--         - Logging into the Web UI and knowing its various functions.
--         - Creating and modifying a virtual warehouse using the Snowflake
--         infrastructure.
--         - Using standard SQL statements to modify an existing database.
--         - Examine Snowflake’s data organization structure, storage, compute,
--         and metadata in the Cloud services.

-- 2.1.0   Creating Virtual Warehouses Using the Web UI
--         An important concept in Snowflake is the ability to allocate multiple
--         clusters of varying sized virtual warehouses to different tasks or
--         business functions. This is called Zero Contention Workload
--         Segmentation. This concept allows processes such as ETL/ELT to run
--         completely separate from end-user queries or from other tasks.

-- 2.1.1   Start by creating a virtual warehouse.
--         In this lab, you will generate multiple warehouses; the first
--         warehouse for running queries, a second warehouse for ingesting data,
--         and a third warehouse for high concurrency.
--         The instructor may already have completed a brief tour of the
--         Snowflake UI prior to starting this lab.

-- 2.1.2   In the top left corner, select the Databases tab.

-- 2.1.3   Review the databases already present.

-- 2.1.4   Next, select the Shares tab:
--         Note the message the Shares window displays:
--         Shares Tab Message
--         When you create a Snowflake Account, by default only the role
--         Accountadmin has access to create a share. Regular users typically
--         log in using the role Sysadmin. You must change roles in order to
--         create Shares.
--         Be aware the role training_role has the necessary privileges to see
--         shares as well.

-- 2.1.5   Select the Warehouses tab.
--         You use this tab in the Web UI primarily to create warehouses and to
--         view the status, name, size, cluster details, scaling policies, and
--         so forth of existing warehouses.

-- 2.1.6   Select the Worksheets tab.
--         The Worksheets tab is where you will execute most of the SQL for this
--         course. We will create a worksheet for each lab.
--         In this task, you will use the Snowflake UI to create a new virtual
--         warehouse for tasks like ingesting data. Note there are three(3)
--         primary sections shown in the Worksheets tab.
--         The navigation tree window in the left-hand column is referred to as
--         the Object Browser. Here you navigate through the different
--         databases, schemas, and tables.
--         The SQL Editor window is just to the right of the Object Browser.
--         Here you can input your SQL queries and then click the Run button.
--         Below the editor is the Results window. Here you can view the output
--         of your SQL commands, determine whether they executed successfully,
--         and also preview any data.
--         In addition to these three (3) primary windows are other tabs and
--         icons you should examine and review at your convenience.

-- 2.1.7   Create a Virtual Warehouse using UI.
--         Let’s begin by creating a new virtual warehouse. Return to the
--         Warehouses tab.

-- 2.1.8   Click on the (+)Create… icon to create a new virtual warehouse.
--         Name: BADGER_LOAD_WH
--         Size: Medium
--         X-Large (XL) is the default size for Virtual Warehouses in Snowflake.
--         You should select something smaller.

-- 2.1.9   Set Auto-Suspend to 5 Minutes

-- 2.1.10  Leave the other settings as their default.

-- 2.1.11  Click Finish

-- 2.2.0   Query the Virtual Warehouse using SQL
--         In this task you will use SQL to create a new virtual warehouse for
--         running queries.

-- 2.2.1   Navigate to the Worksheets tab.

-- 2.2.2   Turn on Code Highlight by selecting the three dots in the upper
--         right-hand corner next to the selected Schema and select Turn on Code
--         Highlight.
--         Turn on Code Highlight

-- 2.2.3   Click on the dropdown arrow directly next to the (+) for creating a
--         new Worksheet.

-- 2.2.4   Click inside of the name of the worksheet and name the worksheet
--         Compute.

-- 2.2.5   Use the following SQL statements in the SQL Editor window to create
--         or replace a virtual warehouse with the following parameters:

CREATE OR REPLACE WAREHOUSE BADGER_QUERY_WH
  WAREHOUSE_SIZE = 'LARGE'
  WAREHOUSE_TYPE = 'STANDARD'
  AUTO_SUSPEND = 60
  AUTO_RESUME = true
  MIN_CLUSTER_COUNT = 1
  MAX_CLUSTER_COUNT = 2
  INITIALLY_SUSPENDED = true
  SCALING_POLICY = 'STANDARD'
  COMMENT = 'Training WH for completing hands on labs queries';
  
  CREATE OR REPLACE WAREHOUSE BADGER_LOAD_WH
  WAREHOUSE_SIZE = 'XSMALL'
  WAREHOUSE_TYPE = 'STANDARD'
  AUTO_SUSPEND = 60
  AUTO_RESUME = true
  MIN_CLUSTER_COUNT = 1
  MAX_CLUSTER_COUNT = 2
  INITIALLY_SUSPENDED = true
  SCALING_POLICY = 'STANDARD'
  COMMENT = 'Training WH for completing hands on lab data movement';


-- 2.2.6   Run the SHOW command to review the two (2) warehouses created by you
--         and any other warehouses that may already exist in the same account.

SHOW WAREHOUSES;


-- 2.3.0   Explore the AUTO-SUSPEND and AUTO-RESUME Features
--         AUTO-SUSPEND and AUTO-RESUME are very important features as a virtual
--         warehouse is charged only for credit usage when it is running
--         (credits are billed per-second). When not in use, it is important to
--         conserve power and costs by suspending any non-functioning virtual
--         warehouses.

-- 2.3.1   Configure the AUTO-SUSPEND setting by first selecting the worksheet
--         labelled Compute.

-- 2.3.2   Use the following SQL to issue an ALTER statement to your Warehouse
--         and change the following parameters:

ALTER WAREHOUSE BADGER_LOAD_WH SET AUTO_SUSPEND = 60;


-- 2.3.3   Select the Warehouses tab and locate your Warehouse and confirm the
--         parameters are as follows:
--         Auto Suspend: 1 minutes

-- 2.4.0   Suspend a Warehouse Using SQL Commands

-- 2.4.1   Select the worksheet Compute.

-- 2.4.2   Use SQL to issue a command to suspend your load warehouse:

ALTER WAREHOUSE BADGER_LOAD_WH SUSPEND;

--         If for some reason a warehouse is already in a suspended state, the
--         above command may return a message stating it’s in an invalid state
--         and the warehouse cannot be suspended.

-- 2.4.3   Select the Warehouses tab.

-- 2.4.4   Locate your Warehouse and confirm that the Status is now set to
--         Suspended.

-- 2.4.5   Select the worksheet Compute and run the following statements:

USE WAREHOUSE BADGER_QUERY_WH;
ALTER SESSION SET USE_CACHED_RESULT = false;
SELECT * FROM TRAINING_DB.TRAININGLAB.REGION;

--         Because the warehouse is by default set to auto resume, it turns
--         itself on automatically when Snowflake receives a query pointed to
--         that Warehouse that requires compute resource.

-- 2.4.6   Select the Warehouses tab once again.

-- 2.4.7   Locate your Warehouses and check that the Status is marked as
--         Started.

-- 2.5.0   Size Up (Scale Up) the Virtual Warehouse Using the UI
--         Warehouses are provisioned in t-shirt sizes. Size specifies the
--         number of servers that comprise each cluster in a virtual warehouse.
--         Each larger size is equivalent to the preceding size x 2, applicable
--         to both the number of VMs in the cluster as well as in Snowflake
--         credits consumed.

-- 2.5.1   Navigate to the Warehouses tab.

-- 2.5.2   Highlight one of your warehouses, BADGER_LOAD_WH.

-- 2.5.3   Click on (+)Configure.

-- 2.5.4   Click on Size to drop down the list of sizes.

-- 2.5.5   Select Large and click Finish.
--         Configure Warehouse

-- 2.5.6   Configure Resizing by Sizing Down using a SQL command.
--         Resizing can be performed any time, even when the virtual warehouse
--         is running.
--         Here are some effects of resizing:
--         Suspended warehouses: no immediate impact, they will start at the new
--         size upon next resume.
--         Running warehouses: immediate impact, running queries complete at
--         their current size while queued and future queries will run at the
--         new size.

-- 2.5.7   Configure resizing by first selecting the worksheet Compute.

-- 2.5.8   Use SQL to resize one of the warehouses:

ALTER WAREHOUSE BADGER_QUERY_WH SET WAREHOUSE_SIZE = 'MEDIUM';


-- 2.5.9   Select the Warehouses tab.
--         Locate your warehouse and confirm the size is now MEDIUM.

-- 2.5.10  Use the following query to benchmark the relative performance of
--         different warehouse sizes:

USE WAREHOUSE BADGER_QUERY_WH;
USE SCHEMA SNOWFLAKE_SAMPLE_DATA.TPCH_SF1000;

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
l_linestatus;


-- 2.6.0   Explore the Scale Out Function of Multi-Cluster Warehouses
--         A Snowflake multi-cluster warehouse consists of one or more clusters
--         of servers that execute queries. For a given warehouse, a user can
--         set both the minimum and maximum number of compute clusters allocated
--         to that warehouse.

-- 2.6.1   Configure Scale Out of a multi-clustered virtual warehouse by first
--         selecting the worksheet Compute.

-- 2.6.2   Use the following SQL command to create a new virtual warehouse for
--         automatic concurrency scale out:

CREATE OR REPLACE WAREHOUSE BADGER_SCALE_OUT_WH
  WAREHOUSE_SIZE = 'SMALL'
  AUTO_SUSPEND = 60
  AUTO_RESUME = true
  MIN_CLUSTER_COUNT = 1
  MAX_CLUSTER_COUNT = 3
  INITIALLY_SUSPENDED = true
  SCALING_POLICY = 'STANDARD'
  COMMENT = 'Training WH for completing concurrency tests';

--         Because you are setting the Maximum Clusters > than the Minimum
--         Clusters, you will be configuring the Warehouse in Auto-Scale Mode
--         and allowing Snowflake to scale the Warehouse as needed to handing
--         fluctuating workloads. If you set the Maximum Clusters and Minimum
--         Clusters to the same number, you would be running in "Maximized
--         Mode’, which you might do for a stable workload.
--         The Scaling Policy controls when and how Snowflake will turn on/off
--         additional clusters in the warehouse, up to the number of Maximum
--         Clusters. Using the Standard option means Snowflake automatically
--         starts additional clusters when it detects queries are being queued.
--         This is designed to maximize both query responsiveness and
--         concurrency.

-- 2.7.0   Considerations for Managing Virtual Warehouses
--         Independently size Virtual Warehouses for Workload Separation; for
--         example, ETL workload does not need to impact the dashboard workload.
--         Use AUTO-SUSPEND and AUTO-RESUME features to pay only for running
--         workloads and to optimize compute savings.
--         Independently size up or size down each virtual warehouse according
--         to performance needs or data volume. These scenarios will be covered
--         in multiple labs throughout the course.
--         Automatic scale out using multi-clustered virtual warehouses for more
--         users and maximized concurrency. This scenario will be explained in
--         the concurrency lab.
--         Pick the appropriate Scaling Policy of multi-clustered virtual
--         warehouses to match workload types.
