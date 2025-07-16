
SQLines 3.3.137 x64 - SQL Conversion and Assessment Tool.
Copyright (c) 2024 SQLines. All Rights Reserved.

SQLINES FOR EVALUATION USE ONLY (14 DAYS).

Command line error:

   -in option not set

How to use:

    sqlines -option=value [...n]

Options:

   -s        - Source type
   -t        - Target type
   -in       - List of files (wildcards *.* are allowed)
   -out      - Output directory (the current directory by default)
   -log      - Log file (sqlines.log by default)
   -a        - Run an assessment (using sqlines_report.tpl template)
   -rpt      - Report file (sqlines_report.html by default, -a should be set)
   -snp      - Code snippets file (sqlines_report_snippets.html by default, -a should be set)
   -?        - Print how to use

Example:

Convert script.sql file from Oracle to SQL Server

   sqlines.exe -s=oracle -t=sql -in=script.sql

