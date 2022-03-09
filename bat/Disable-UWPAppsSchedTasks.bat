@echo off
rem Disable UWP Apps scheduled tasks.
rem Obsolete !!! Not currated anymore.
rem Only get, no set.
rem https: // fdossena.com/?p=w10debotnet/index_1903.frag

goto:run

TODO
schtasks /Change /TN "Microsoft\XblGameSave\XblGameSaveTask" /disable
schtasks /Change /TN "Microsoft\XblGameSave\XblGameSaveTaskLogon" /disable
schtasks /Change /TN "\Microsoft\Windows\Maps\MapsUpdateTask" /disable
schtasks /Change /TN "\Microsoft\Windows\Maps\MapsToastTask" /disable
schtasks /Change /TN "\Microsoft\Windows\HelloFace\FODCleanupTask" /Disable

:run

exit /b
