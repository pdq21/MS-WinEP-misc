@echo off
rem display all WLAN profile keys
rem elevation needed
rem TODO add more locales
set nsh=netsh wlan show profiles * key=clear

%nsh% | findstr /i "SSID-Name"
whoami /groups | find /i "S-1-5-32-544" >nul
if %errorlevel%==0 (
    for /f "usebackq skip=1" %%i in (`wmic os get locale`) do (
        if _%%i_==_0409_ set key="material"
        if _%%i_==_0407_ set key="inhalt"
        setlocal enabledelayedexpansion
            %nsh% | findstr /i !key!
        endlocal
    )
) else (
    echo Can not display keys. Process not elevated.
)
exit /b
