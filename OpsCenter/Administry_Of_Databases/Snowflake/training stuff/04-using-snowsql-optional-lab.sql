
-- 4.0.0   Using SnowSQL (Optional Lab)
--         This lab will take approximately 40 minutes to complete.
--         This lab requires you to have SnowSQL running on your laptop. You may
--         either pre-install it prior to the course or install it during the
--         course period either during course time or as a homework assignment.
--         - Learn how to access and run SnowSQL.
--         - Check connectivity of SnowSQL.
--         - How to modify the SnowSQL configuration file.
--         - Run batch scripts using the SnowSQL command line tool.

-- 4.1.0   Connecting to the JupyterLab and Accessing the Terminal
--         The Snowflake University JupyterLab server is a web-based tool for
--         running Python and other bits of data, line by line. It’s immensely
--         helpful to read through the code, make changes as needed, and then
--         see the results as it progresses. We will be using the JupyterLab
--         server in this lab to access the Snowflake command-line tool,
--         SnowSQL, and learn how to interact with Snowflake without having to
--         install any local connectors.
--         The Snowflake University JupyterLab provides a pre-installed
--         environment to complete this lab. This includes Jupyter Notebooks,
--         Python, Spark, and R, all of which are available for end-user access.
--         The lab includes the following Snowflake connectors, clients, and
--         drivers:
--         JupyterLab (https://jupyterlab.readthedocs.io) is a large, complex
--         application with many features to develop open-source software,
--         promote open-standards and services for interactive computing across
--         dozens of programming languages. It can be overwhelming at first; we
--         will be using only the basics. For this lab we will focus
--         specifically on SnowSQL.

-- 4.1.1   Login to the Snowflake University JupyterLab Server

-- 4.1.2   Open a browser and navigate to https://labs.snowflakeuniversity.com/
--         You will be redirected to the Snowflake University Sign in page:
--         Snowflake University JupyterLab Sign In Dialog Box
--         Access to Snowflake University JupyterLab server is controlled by the
--         Snowflake Training Account credentials (account name, user login
--         name, and password) which were provided to you by the course
--         instructor. After the Snowflake Training Account credentials expire,
--         access to the Snowflake University JupyterLab server will be revoked.

-- 4.1.3   Enter your Snowflake Training Account credentials
--         Access the Snowflake University JupyterLab by entering the following
--         information:
--         Once you have logged into the Snowflake University JupyterLab server,
--         a progress bar will indicate when a dedicated server instance has
--         started.
--         Progress Bar for Accessing a JupyterLab Server
--         After the server is ready, you will automatically be redirected to
--         the JupyterLab interface main work area.
--         JupyterLab Main Work Area
--         Under the Launcher window, locate the third row of icons labeled
--         Other. We will be suing the following two (2) icons: Terminal and
--         Text File.
--         Locate the terminal icon on the third row*. Launch a new terminal
--         session. You should be presented with a new terminal login prompt.
--         JupyterLab Main Work Area

-- 4.2.0   Connect to SnowSQL
--         The SnowSQL config file is automatically installed in <your home
--         directory>/.snowsql/config. You can edit this file to add credentials
--         and set things such as your role, warehouse, database, and schema.
--         This sets defaults that will be used any time you connect to
--         Snowflake using snowsql.

-- 4.3.0   Start SnowSQL from the Command Line

-- 4.3.1   Execute the following command to log in to SnowSQL:

snowsql -a <account_name> -u <user_name>

--         Again, use the same account name and user name you are using for the
--         course labs.

-- 4.3.2   Examine the SnowSQL prompt and identify your user name, database,
--         schema, and warehouse.
--         You did not specify these, but Snowflake used your defaults.
--         Here is a sample screenshot showing the typical login process as
--         performed by the user INSTRUCTOR1 while logging into the sample
--         account lta63607.
--         JupyterLab Main Work Area
--         In the previous screenshot the user name is INSTRUCTOR1. Students
--         should use their assigned animal name, e.g., BADGER, COBRA, or MOOSE,
--         and so on.

-- 4.3.3   Run some sample commands to verify your role, and the current
--         account:

select current_account();
select current_role();

--         You should be presented with something similar to the following:
--         JupyterLab Main Work Area
--         As you start typing commands, note that the terminal window will
--         prompt you by suggesting auto-complete commands. This can prove very
--         useful when executing commands within the SnowSQL environment.

-- 4.3.4   When you are done using SnowSQL, log out by typing CTRL-D or !quit or
--         !exit and Return to exit.

-- 4.3.5   Type snowsql -? to get a list of command line options for SnowSQL.

-- 4.4.0   Set Default Connection Information

-- 4.4.1   In the Jupyter interface, in the command bar at the top, select File
--         > Open From Path...

-- 4.4.2   In the dialog box that appears, enter this as the Path, then click
--         Open:
--         .snowsql/config
--         An error message will appear; dismiss this and continue.

-- 4.4.3   A tab will open with the config file available for edit.
--         The top part of this file defines the default connection credentials.
--         Make the following changes:
--         You may not want to set the default password in your config file in
--         your production environment; the password is stored in clear text,
--         and can be read by anyone with access to that file. If you do put a
--         password in your configuration file, make sure the file is secure.

-- 4.4.4   Save the file (File > Save File). Leave the tab open for changes you
--         will make later.

-- 4.4.5   Select the tab that contains your terminal window.
--         At the terminal prompt, enter: snowsql
--         This will read the default information from your configuration file
--         and log you in.
--         Check the snowsql command prompt to verify that the database, schema,
--         and warehouse you entered in your configuration file are set
--         correctly.

-- 4.4.6   Run this command at the prompt to verify your role:
--         SELECT current_role();

-- 4.4.7   Exit from Snowsql:
--         !exit, or !quit, or CTRL+C

-- 4.5.0   Create an Alternate Connection

-- 4.5.1   Select the tab that contains the config file:
--         Scroll down to line 23 where is says [Connections.example].
--         In this section, you can create named connections that you can use as
--         alternates to your default connection. The title for each named
--         connection is [Connections.<name>], where <name> is the name you are
--         assigning to the connection.

-- 4.5.2   Change example to sysadmin, to change the name of this connection to
--         sysadmin.

-- 4.5.3   Enter the appropriate values on lines 26 through 28.

-- 4.5.4   Add the line:
--         rolename = sysadmin

-- 4.5.5   Save the changes to the file, and then select the tab with your
--         terminal window.

-- 4.5.6   At the terminal prompt, enter:
--         snowsql -c sysadmin
--         This connects to snowsql using your named connection, rather than
--         your default connection.

-- 4.5.7   Verify that your database, role, warehouse, and schema are as
--         expected, then exit from SnowSQL.

-- 4.6.0   Running a Batch Script
--         SnowSQL can also be used to run a batch script, which you will do in
--         this exercise.

-- 4.6.1   Open a new file (File > New > Text File). It will show up in the left
--         side pane as untitled.txt.

-- 4.6.2   Right-click the file name and rename it to myscript.txt.

-- 4.6.3   Copy and paste the following text into the file:

use role training_role;
use warehouse BADGER_WH;
use database BADGER_DB;
create or replace table snowsql_tbl 
    (col1 INT, col2 VARCHAR);
insert into snowsql_tbl values 
    (1, 'This is line 1'), (2, 'This is line 2'), (3, 'This is line 3');
select * from snowsql_tbl;


-- 4.6.4   Replace the two BADGER placeholders in the text file your user name.

-- 4.6.5   Save the file.

-- 4.6.6   Return to the tab with the terminal window.

-- 4.6.7   Run the script using snowsql, by executing this command:
--         snowsql -f ~/myscript.txt
--         The output will be printed to the screen.

-- 4.6.8   Now run the script and redirect the output to a file:
--         snowsql -f ~/myscript.txt > myoutput.txt
--         No output will be printed to the screen, as the output is being
--         redirected to myoutput.txt. The file will appear in the left side
--         navigation pane.

-- 4.6.9   In the left side navigation pane, select the output file
--         (myoutput.txt).

-- 4.6.10  Review the contents.

-- 4.6.11  Log out of Jupyter (File > Log Out).
