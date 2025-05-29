@echo off
cls
rem Batch file to manage all sync services

IF "%1" == "" goto :CommandUsage


rem -------------------------------------------------------
rem 			MSGSRVREXTUSD
rem PA server: 	UNITRAC-WH08
sc \\unitrac-wh08.colo.as.local %1 MSGSRVREXTUSD
rem -------------------------------------------------------



rem -------------------------------------------------------
rem 			MSGSRVRADHOC
rem PA server: 	UNITRAC-WH08
sc \\unitrac-wh08.colo.as.local  %1 MSGSRVRADHOC
rem -------------------------------------------------------



echo Complete!!!
goto :End

:CommandUsage
echo "UniTrac_Sync <input>"
echo "Possible Commands: query, stop, start"

:End
