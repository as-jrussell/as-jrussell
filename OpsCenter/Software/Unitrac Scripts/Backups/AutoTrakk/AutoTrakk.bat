@echo off
cls
echo 
cd E:\ExternalActions\AutoTrakk
set year=%date:~10,4%
set month=%date:~4,2%
set day=%date:~7,2%
set hour=%time:~0,2%
:replace leading space with 0 for hours < 10
if "%hour:~0,1%" == " "  set hour=0%hour:~1,1%
set minute=%time:~3,2%
set second=%time:~6,2%
set MYDATE=%year%.%month%.%day%_%hour%.%minute%.%second%
Echo *** Begin SQLCMD %MYDATE% *** > E:\ExternalActions\AutoTrakk\Logs\%MYDATE%.log
"C:\Program Files\Microsoft SQL Server\Client SDK\ODBC\130\Tools\Binn\SQLCMD.EXE" -U solarwinds_sql -P S0l@rw1nds -S Unitrac-DB01 -d Unitrac -i "E:\ExternalActions\AutoTrakk\AutoTrakk.SQL" 2>&1 >> E:\ExternalActions\AutoTrakk\Logs\%MYDATE%.log
Echo *** SQLCMD Complete %MYDATE% *** >> E:\ExternalActions\AutoTrakk\Logs\%MYDATE%.log



pause