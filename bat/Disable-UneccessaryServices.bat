@echo off
rem Obsolete !!! Not currated anymore.
rem Only get, no set.
rem https: // fdossena.com/?p=w10debotnet/index_1903.frag
setlocal enabledelayedexpansion
rem util
set LF=^


rem ^ two times MORE
set sep=-
for /l %%i in (1,1,30) do set "sep=!sep!^^^^-"
rem services
set svc=DiagTrack,dmwappushservice,OneSyncSvc,MessagingService,wercplsupport,PcaSvc
set svc=%svc%,wlidsvc,wisvc,RetailDemo,diagsvc,shpamsvc,TermService,UmRdpService
set svc=%svc%,SessionEnv,TroubleshootingSvc,diagnosticshub.standardcollector.service
rem UWP/Metro Apps
set svc=%svc%,PushToInstall,XblAuthManager,XblGameSave,XboxNetApiSvc,XboxGipSvcsc,xbgm
set svc=%svc%,MapsBroker,lfsvc
rem %svc:,=^&echo.% not working, neither with ^ nor "" 
set svc=%svc:,=!LF!%
rem reg
set hvSvc=HKLM\SYSTEM\CurrentControlSet\Services
set hvApp=HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat
rem messed up permissions, trying anyway
set regSvc=DPS,WdiServiceHost,WdiSystemHost
set svc=%regSvc:,=!LF!%
rem carefull !!!
rem deleting/disabling causes error message/notification
rem Service Center could not be started
set regFind=OneSyncSvc,MessagingService,PimIndexMaintenanceSvc,UserDataSvc
set regFind=%regFind%,UnistoreSvc,BcastDVRUserService,Sgrmbroker,wscsvc
set regFind=%regFind:,=!LF!%
rem app compat
set regApp=AITEnable,DisableInventory,DisablePCA,DisableUAR
set regApp=%regApp:,=!LF!%

call:msg "Disabling services"
for %%i in (!svc!) do (
    echo %%i
    sc qc %%i | find /i "START_TYPE"
    rem sc config %%i start= disabled
)
call:msg "Changing registry values"
for %%i in (!regSvc!) do (
    echo %%i
    reg query "%hvSvc%" /v "%%i"
    rem reg delete %hv% /v "%%i" /f
)
for %%i in (!regFind!) do (
    echo %%i
    for /f "tokens=1" %%k in ('reg query "%hvSvc%" /k /f "%%i" ^| find /i "%%i"') do (
        echo %%k
        rem reg delete "%%k" /f
    )
)
for %%i in (!regApp!) do (
    echo %%i
    reg query "%hvApp%"" /v "%%i"
    rem reg add "%hvApp%" /v "%%i" /t REG_DWORD /d 0 /f
)

endlocal
exit /b

:msg
echo.
echo !sep!
echo %1
echo !sep!
echo.
goto:eof

rem TODO

rem reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Siuf\Rules" /v "NumberOfSIUFInPeriod" /t REG_DWORD /d 0 /f
rem reg delete "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Siuf\Rules" /v "PeriodInNanoSeconds" /f
rem reg add "HKCU\Software\Microsoft\Internet Explorer\PhishingFilter" /v "EnabledV9" /t REG_DWORD /d 0 /f
rem reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoRecentDocsHistory" /t REG_DWORD /d 1 /f
rem reg add "HKLM\SOFTWARE\Policies\Microsoft\MicrosoftEdge\PhishingFilter" /v "EnabledV9" /t REG_DWORD /d 0 /f
rem reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "EnableSmartScreen" /t REG_DWORD /d 0 /f

reg add "HKLM\SYSTEM\ControlSet001\Control\WMI\AutoLogger\AutoLogger-Diagtrack-Listener" /v Start /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\CompatTelRunner.exe" /v Debugger /t REG_SZ /d "%windir%\System32\taskkill.exe" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\DeviceCensus.exe" /v Debugger /t REG_SZ /d "%windir%\System32\taskkill.exe" /f

exit /b