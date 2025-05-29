@echo off
cls
rem Batch file to manage all MessageServer services

IF "%1" == "" goto :CommandUsage

rem -------------------------------------------------------
rem 			DIRECTORYWATCHERSERVERIN
rem rem PA server: 	UNITRAC-WH14
sc \\unitrac-wh14.colo.as.local %1 directorywatcherserverin
rem -------------------------------------------------------

rem -------------------------------------------------------
rem 			DIRECTORYWATCHERSERVEROUT
rem rem PA server: 	UNITRAC-WH14
sc \\unitrac-wh14.colo.as.local %1 directorywatcherserverout
rem -------------------------------------------------------

rem -------------------------------------------------------
rem 			MSGSRVRDEF
rem rem PA server: 	UNITRAC-WH08
sc \\unitrac-wh08.colo.as.local %1 msgsrvrdef
rem -------------------------------------------------------

echo Complete!!!
goto :End

:CommandUsage
echo "LFP <input>"
echo "Possible Commands: query, stop, start"

:End
pause