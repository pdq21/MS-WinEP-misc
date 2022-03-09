@echo off
rem quick tools
if _%1_=_?_ (
    echo.
    echo t... Restart time service.
    echo w... Windows update cleanup.
    echo n... Update NTP service. 
    echo.
)
if /i _%1_=_t_ (
    net stop w32time && net start w32time && w32tm /resync
)
if /i _%1_=_w_ (
    dism /Online /Cleanup-Image /StartComponentCleanup
)
if /i _%1_=_n_ (
    setlocal
    set ntp=192.168.1.1 pool.ntp.org
    set logDir=%TEMP%
    set log=%logDir%\ntp-set.log
    set hvSvc=hklm\system\currentcontrolset\services\w32time\parameters

    if not exist "%logDir%" mkdir "%logDir%"

    rem goto:start
    sc stop w32time
    ping 0.0.0.0 -n 5
    sc query w32time
    w32tm /unregister
    w32tm /register
    sc start w32time
    ping 0.0.0.0 -n 5
    sc query w32time
    rem :start

    echo. >> %log%
    echo ---- cur --- %date% %time% >> %log%
    reg query %hvSvc% /v ntpserver >> %log%
    w32tm /query /source >> %log%
    w32tm /config /manualpeerlist:"%ntp%" /syncfromflags:manual /reliable:yes /update >> %log%
    echo. >> %log%
    echo ---- new --- %date% %time% >> %log%
    reg query %hvSvc% /v ntpserver >> %log%
    w32tm /query /source >> %log%
    w32tm /stripchart /computer:"%computername%" /samples:2 /dataonly >> %log%

    rem goto:eof
    sc stop w32time
    ping 0.0.0.0 -n 5
    sc start w32time
    w32tm /query /source
    type %log%
    endlocal
)

exit /b
