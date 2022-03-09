@echo off
goto:run
	CAREFUL !!! Old hosts file will be renamed and a new one will be created.
:run
set hosts=%WinDir%\System32\drivers\etc\hosts
ren %hosts% hosts.old
if _%ERRORLEVEL%_==_0_ (
	echo ##################################################### >%hosts%
	echo #	automatically created on %date% %time% >>%hosts%
	echo ##################################################### >>%hosts%
	echo 192.168.2.10 Server.DOM.local Server >>%hosts%
	echo 192.168.2.7 DC1.DOM.local DC1 >>%hosts%
	echo 192.168.2.8 FILE.DOM.local FILE >>%hosts%
	echo 192.168.2.11 APP.DOM.local APP >>%hosts%
) else (
	echo Error while renaming hosts file. Maybe not elevated? Exiting... 
)
exit /b