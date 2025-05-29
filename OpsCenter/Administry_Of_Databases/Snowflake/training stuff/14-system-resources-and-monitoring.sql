
-- 14.0.0  System Resources and Monitoring
--         This lab will take approximately 15-20 minutes to complete.
--         These exercises will cover system resource monitoring.
--         - Configuring and creating resource monitoring using the web
--         interface.
--         - Exploring system usage and billing using the web interface.
--         - Monitoring queries using the web interface history page.
--         - Monitoring system storage usages, compute usages, credit
--         consumption, and user logins and connections.

-- 14.1.0  Setting Up Resource Monitoring Using the Web Interface

-- 14.1.1  Navigate to Worksheets and create a new worksheet.

-- 14.1.2  Name the worksheet Resource Monitoring.

-- 14.1.3  Set the Worksheet context as follows:

USE ROLE TRAINING_ROLE;
USE DATABASE BADGER_DB;
USE WAREHOUSE BADGER_QUERY_WH;


-- 14.2.0  Creating Resource Monitors

-- 14.2.1  Create a virtual warehouse called BADGER_monitor_WH.

-- 14.2.2  Confirm the following settings are in place:
--         You will NOT be able to create a Resource Monitor, unless you have
--         the ability to assume the AccountAdmin role.

-- 14.2.3  Click on Account.

-- 14.2.4  Click on Resource Monitor.

-- 14.2.5  Select the + sign to create a new Resource Monitor.

-- 14.2.6  Enter a name usernn_limit1 with quota of 100 credits and specify that
--         you would like to monitor the BADGER_WH virtual warehouse.

-- 14.2.7  Specify that when the quota reaches 90% you would like to perform a
--         suspend, and when the quota reaches 100% you would like to perform an
--         immediate suspend.

-- 14.2.8  Click on Account >> Resource Monitors.
--         Can you see the newly created Resource Monitor listed?

-- 14.2.9  Click on usernn_limit1 to display the details panel.
--         Click the Edit icon and increase the quota to 200 and add an
--         additional threshold so that notification is sent when the
--         consumption reaches 50% of the total quota.
--         Check what resource monitors are available with SHOW RESOURCE
--         MONITORS command.

-- 14.2.10 When done, drop the virtual warehouse USERNN_WH and the resource
--         monitor usernn_limit1.

-- 14.3.0  Explore the System Usage & Billing Using the Web Interface

-- 14.3.1  Review Warehouse Usage.
--         In the Warehouses tab, locate the BADGER_LOAD_WH warehouse and click
--         on its name.

-- 14.3.2  Review the Warehouse Load Over Time information.

-- 14.3.3  Select the Account tab.
--         Make sure the Billing & Usage section is selected. Review the
--         information about Snowflake credits billed for the given time period.

-- 14.3.4  Monitor Snowflake Storage.

-- 14.3.5  Select the Account tab.

-- 14.3.6  Navigate to the Billing & Usage section.

-- 14.3.7  Toggle on the Average Storage Used option.

-- 14.3.8  Toggle between months and review the Change in Total Storage
--         throughout the month.

-- 14.3.9  Toggle between the Database, Stage, and Fail Safe categories and
--         review the change in storage for each throughout the month.

-- 14.4.0  Monitoring Queries Using the Web Interface History Page
--         The Snowflake documentation pages contain a wealth of details on
--         using this tool, History Page, to monitor queries.

-- 14.4.1  Explore the History Page features
--         To do: https://docs.snowflake.com/en/user-guide/ui-history.html

-- 14.5.0  Monitoring System Storage Use
--         By using the System Functions Account Usage and Information Schema
--         you can drill down into system storage use.

-- 14.5.1  Query 1 - Billable Storage:

SELECT
    AVG(CASE WHEN (((storage_usage.USAGE_DATE) >= ((TO_DATE(DATE_TRUNC('month', CURRENT_DATE())))) 
    AND (storage_usage.USAGE_DATE) < ((TO_DATE(DATEADD('month', 1, DATE_TRUNC('month', CURRENT_DATE()))))))) 
    THEN ((storage_usage.STORAGE_BYTES / POWER(1024, 4)) + (storage_usage.FAILSAFE_BYTES / POWER(1024, 4))) 
    ELSE NULL END) AS "storage_usage.curr_mtd_billable_tb",
    AVG(CASE WHEN (((storage_usage.USAGE_DATE) >= ((TO_DATE(DATEADD('month', -1, DATE_TRUNC('month', CURRENT_DATE()))))) 
    AND (storage_usage.USAGE_DATE) < ((TO_DATE(DATEADD('month', 1, DATEADD('month', -1, DATE_TRUNC('month', CURRENT_DATE())))))))) 
    THEN (storage_usage.STORAGE_BYTES / POWER(1024, 4)) + (storage_usage.FAILSAFE_BYTES / POWER(1024, 4)) 
    ELSE NULL END) AS "storage_usage.prior_mtd_billable_tb"
FROM
    SNOWFLAKE.ACCOUNT_USAGE.STORAGE_USAGE AS storage_usage;


-- 14.5.2  Query 2 - Billable Storage by Month:

SELECT
    TO_CHAR(DATE_TRUNC('month',
    storage_usage.USAGE_DATE ),
    'YYYY-MM') AS "storage_usage.usage_month",
    AVG(((storage_usage.STORAGE_BYTES / POWER(1024, 4)) + (storage_usage.FAILSAFE_BYTES / POWER(1024, 4)))) 
    AS "storage_usage.billable_tb"
FROM
    SNOWFLAKE.ACCOUNT_USAGE.STORAGE_USAGE AS storage_usage
WHERE
    (((storage_usage.USAGE_DATE) >= ((TO_DATE(DATEADD('month',
    -12,
    DATE_TRUNC('month',
    CURRENT_DATE())))))
    AND (storage_usage.USAGE_DATE) < ((TO_DATE(DATEADD('month',
    12,
    DATEADD('month',
    -12,
    DATE_TRUNC('month',
    CURRENT_DATE()))))))))
GROUP BY
    DATE_TRUNC('month',
    storage_usage.USAGE_DATE )
ORDER BY
    1 DESC;


-- 14.5.3  Query 3 - Return average daily storage usage for the past 10 days,
--         per database, for all databases in your account:

SELECT
*
FROM TABLE(INFORMATION_SCHEMA.DATABASE_STORAGE_USAGE_HISTORY(
    DATEADD('DAYS',-10,CURRENT_DATE()),CURRENT_DATE()));


-- 14.5.4  Query 4 - Return average daily storage usage for the past 10 days for
--         your account overall:

SELECT
    USAGE_DATE,
    SUM(AVERAGE_DATABASE_BYTES) AVERAGE_DATABASE_BYTES,
    SUM(AVERAGE_FAILSAFE_BYTES) AVERAGE_FAILSAFE_BYTES
FROM TABLE(INFORMATION_SCHEMA.DATABASE_STORAGE_USAGE_HISTORY(
    DATEADD('DAYS',-10,CURRENT_DATE()),CURRENT_DATE()))
GROUP BY
    USAGE_DATE
ORDER BY
    USAGE_DATE;


-- 14.5.5  Query 5 - Return average daily data storage usage for all the
--         Snowflake stages in your account for the past 10 days:

SELECT
*
FROM TABLE(INFORMATION_SCHEMA.STAGE_STORAGE_USAGE_HISTORY(
        DATEADD('DAYS',-10,CURRENT_DATE()),CURRENT_DATE()));


-- 14.6.0  Monitoring System Compute Use
--         Drill down into the System Compute usage by utilizing the System
--         Functions Account Usage and Information Schema.

-- 14.6.1  Query 1 - Retrieve hourly warehouse usage over the past 10 days for
--         all virtual warehouses that ran during this time period:

SELECT * FROM table(information_schema.warehouse_metering_history(
        dateadd('days',-10,current_date())));


-- 14.6.2  Query 2 - Retrieve hourly warehouse usage for a named warehouse on a
--         specified date:

SELECT * FROM table(information_schema.warehouse_metering_history(
    current_date(),current_date(), 
    'BADGER_QUERY_WH'));


-- 14.7.0  Monitoring System Credit Consumption
--         Determine the total amount of system credits consumed by using the
--         System Functions Account Usage and Information Schema.

-- 14.7.1  Query 1 - Total Credits Used (MTD):

SELECT
    COALESCE(SUM(CASE WHEN (((warehouse_metering_history.START_TIME) >= ((DATE_TRUNC('month', CURRENT_DATE()))) AND (warehouse_metering_history.START_TIME) < ((DATEADD('month', 1, DATE_TRUNC('month', CURRENT_DATE())))))) THEN warehouse_metering_history.CREDITS_USED ELSE NULL END),
    0) AS "warehouse_metering_history.current_mtd_credits_used",
    COALESCE(SUM(CASE WHEN EXTRACT(MONTH, warehouse_metering_history.START_TIME) = EXTRACT(MONTH, CURRENT_TIMESTAMP()) - 1 AND warehouse_metering_history.START_TIME <= dateadd(MONTH, -1, CURRENT_TIMESTAMP()) THEN warehouse_metering_history.CREDITS_USED ELSE NULL END),
    0) AS "warehouse_metering_history.prior_mtd_credits_used"
FROM
    SNOWFLAKE.ACCOUNT_USAGE.WAREHOUSE_METERING_HISTORY AS warehouse_metering_history;


-- 14.7.2  Query 2 - Credits Used by Warehouse:

SELECT
    warehouse_metering_history.WAREHOUSE_NAME 
    AS "warehouse_metering_history.warehouse_name",
    COALESCE(SUM(warehouse_metering_history.CREDITS_USED),
    0) AS "warehouse_metering_history.total_credits_used"
FROM
    SNOWFLAKE.ACCOUNT_USAGE.WAREHOUSE_METERING_HISTORY 
    AS warehouse_metering_history
WHERE
    (((warehouse_metering_history.START_TIME) >= ((DATE_TRUNC('month',
    CURRENT_DATE())))
    AND (warehouse_metering_history.START_TIME) < ((DATEADD('month',
    1,
    DATE_TRUNC('month',
    CURRENT_DATE()))))))
GROUP BY
    1
ORDER BY
    1;


-- 14.7.3  Query 3 - Credits Used Over Time by Warehouse (MTD):

SELECT
  "warehouse_metering_history.warehouse_name",
  "warehouse_metering_history.start_date",
  "warehouse_metering_history.total_credits_used"
FROM
    (
    SELECT
        *,
        DENSE_RANK() OVER (
    ORDER BY
        z___min_rank) AS z___pivot_row_rank,
        RANK() OVER (PARTITION BY z__pivot_col_rank
    ORDER BY
        z___min_rank) AS z__pivot_col_ordering
    FROM
        (
        SELECT
        *,
        MIN(z___rank) OVER (
            PARTITION BY "warehouse_metering_history.start_date") 
        AS z___min_rank
    FROM
        (
        SELECT
        *,
        RANK() OVER (
        ORDER BY
        CASE
        WHEN z__pivot_col_rank = 1 THEN
        (CASE
        WHEN "warehouse_metering_history.total_credits_used" 
        IS NOT NULL THEN 0
            ELSE 1
            END)
            ELSE 2
            END,
        CASE
        WHEN z__pivot_col_rank = 1 
        THEN "warehouse_metering_history.total_credits_used"
        ELSE NULL
        END DESC,
        "warehouse_metering_history.total_credits_used" DESC,
        z__pivot_col_rank,
        "warehouse_metering_history.start_date") AS z___rank
    FROM
        (
        SELECT
        *,
        DENSE_RANK() OVER (
        ORDER BY
        CASE
        WHEN "warehouse_metering_history.warehouse_name" IS NULL 
            THEN 1
            ELSE 0
        END,
        "warehouse_metering_history.warehouse_name") 
            AS z__pivot_col_rank
    FROM
        (
        SELECT
            warehouse_metering_history.WAREHOUSE_NAME 
            AS "warehouse_metering_history.warehouse_name",
            TO_CHAR(
            TO_DATE(warehouse_metering_history.START_TIME),
            'YYYY-MM-DD') 
            AS "warehouse_metering_history.start_date",
            COALESCE(
                SUM(warehouse_metering_history.CREDITS_USED),
            0) AS "warehouse_metering_history.total_credits_used"
    FROM
        SNOWFLAKE.ACCOUNT_USAGE.WAREHOUSE_METERING_HISTORY 
        AS warehouse_metering_history
        WHERE
        (((warehouse_metering_history.START_TIME) >= ((DATE_TRUNC('month',
        CURRENT_DATE())))
        AND (warehouse_metering_history.START_TIME) < ((DATEADD('month',
        1,
        DATE_TRUNC('month',
        CURRENT_DATE()))))))
        GROUP BY
        1,
        TO_DATE(warehouse_metering_history.START_TIME)) ww ) bb
        WHERE
    z__pivot_col_rank <= 16384 ) aa ) xx ) zz
WHERE
    z___pivot_row_rank <= 500
    OR z__pivot_col_ordering = 1
ORDER BY
    z___pivot_row_rank;


-- 14.8.0  Monitoring User Logins and Connections
--         It is always useful to review user account use. By using the System
--         Functions Account Usage and Information Schema you can determine the
--         exact amount of user logins and their respective connection time.

-- 14.8.1  Query 1 - Total Logins:

SELECT
    COUNT(*) AS "login_history.logins",
    COUNT(CASE WHEN (CASE WHEN CASE WHEN login_history.IS_SUCCESS = 'YES' THEN TRUE ELSE FALSE END THEN 1 ELSE 0 END ) = 0 THEN 1 ELSE NULL END) AS "login_history.total_failed_logins",
    1 * 0 * ((COUNT(CASE WHEN (CASE WHEN CASE WHEN login_history.IS_SUCCESS = 'YES' THEN TRUE ELSE FALSE END THEN 1 ELSE 0 END ) = 0 THEN 1 ELSE NULL END)) / NULLIF((COUNT(*)),
    0)) AS "login_history.login_failure_rate"

FROM
    SNOWFLAKE.ACCOUNT_USAGE.LOGIN_HISTORY AS login_history
WHERE
    (((login_history.EVENT_TIMESTAMP) >= ((DATE_TRUNC('month',
    CURRENT_DATE())))
    AND (login_history.EVENT_TIMESTAMP) < ((DATEADD('month',
    1,
    DATE_TRUNC('month',
    CURRENT_DATE()))))));


-- 14.8.2  Query 2 - Logins by User (MTD):

SELECT
    login_history.USER_NAME AS "login_history.user_name",
    COUNT(*) AS "login_history.logins",
    COUNT(CASE WHEN (CASE WHEN CASE WHEN login_history.IS_SUCCESS = 'YES' 
    THEN TRUE ELSE FALSE END 
    THEN 1 ELSE 0 END ) = 0 THEN 1 ELSE NULL END) AS "login_history.total_failed_logins",
    1 * 0 * ((COUNT(CASE WHEN (CASE WHEN CASE WHEN login_history.IS_SUCCESS = 'YES' 
    THEN TRUE ELSE FALSE END 
    THEN 1 ELSE 0 END ) = 0 THEN 1 ELSE NULL END)) / NULLIF((COUNT(*)),
    0)) AS "login_history.login_failure_rate"

FROM
    SNOWFLAKE.ACCOUNT_USAGE.LOGIN_HISTORY AS login_history
WHERE
    (((login_history.EVENT_TIMESTAMP) >= ((DATE_TRUNC('month',
    CURRENT_DATE())))
    AND (login_history.EVENT_TIMESTAMP) < ((DATEADD('month',
    1,
    DATE_TRUNC('month',
    CURRENT_DATE()))))))
GROUP BY
    1
ORDER BY
    2 DESC;


-- 14.8.3  Query 3 - Logins by User and Connection Type (MTD):

SELECT
    "login_history.reported_client_type",
    "login_history.user_name",
    "login_history.logins",
    "login_history.total_failed_logins",
    "login_history.login_failure_rate"
FROM
    (
    SELECT
        *,
        DENSE_RANK() OVER (
    ORDER BY
        z___min_rank) AS z___pivot_row_rank,
        RANK() OVER (PARTITION BY z__pivot_col_rank
    ORDER BY
        z___min_rank) AS z__pivot_col_ordering
    FROM
        (
        SELECT
            *,
            MIN(z___rank) 
            OVER (PARTITION BY "login_history.user_name") 
            AS z___min_rank
    FROM
        (
        SELECT
            *,
            RANK() OVER (
        ORDER BY
            CASE
            WHEN z__pivot_col_rank = 1 THEN
            (CASE
                WHEN "login_history.logins" IS NOT NULL THEN 0
                ELSE 1
            END)
                ELSE 2
            END,
            CASE
                WHEN z__pivot_col_rank = 1 
                THEN "login_history.logins"
                ELSE NULL
            END DESC,
            "login_history.logins" DESC,
            z__pivot_col_rank,
            "login_history.user_name") AS z___rank
    FROM
        (
        SELECT
            *,
            DENSE_RANK() OVER (
        ORDER BY
            CASE
            WHEN "login_history.reported_client_type" IS NULL THEN 1
                ELSE 0
            END,
            "login_history.reported_client_type") AS z__pivot_col_rank
    FROM
        (
        SELECT
            login_history.REPORTED_CLIENT_TYPE 
        AS "login_history.reported_client_type",
            login_history.USER_NAME AS "login_history.user_name",
        COUNT(*) AS "login_history.logins",
        COUNT(CASE WHEN (CASE WHEN CASE WHEN login_history.IS_SUCCESS = 'YES' 
            THEN TRUE ELSE FALSE END 
            THEN 1 ELSE 0 END ) = 0 THEN 1 ELSE NULL END) 
            AS "login_history.total_failed_logins",
            1 * 0 * ((COUNT(CASE WHEN (CASE WHEN CASE 
            WHEN login_history.IS_SUCCESS = 'YES' 
            THEN TRUE ELSE FALSE END 
            THEN 1 ELSE 0 END ) = 0 THEN 1 ELSE NULL END)) / NULLIF((COUNT(*)),
            0)) AS "login_history.login_failure_rate"
    FROM
        SNOWFLAKE.ACCOUNT_USAGE.LOGIN_HISTORY AS login_history
        WHERE
            (((login_history.EVENT_TIMESTAMP) >= ((DATE_TRUNC('month',
            CURRENT_DATE())))
        AND (login_history.EVENT_TIMESTAMP) < ((DATEADD('month',
            1,
            DATE_TRUNC('month',
            CURRENT_DATE()))))))
        GROUP BY
            1,
            2) ww ) bb
        WHERE
            z__pivot_col_rank <= 16384 ) aa ) xx ) zz
WHERE
    z___pivot_row_rank <= 500
    OR z__pivot_col_ordering = 1
ORDER BY
    z___pivot_row_rank;

