@echo off
setlocal enabledelayedexpansion

set CPT=.\CPT\IntuneWinAppUtil_1.8.4.exe
set TODO=.\bin\TODO
set DONE=.\bin\DONE
set OUT=.\IntunePkgs
set LOG=.\Intune.log

if /i __%1__ == __?__ (

    set purpose=-= Pack batch .intunewin [Win32] with Intune CPT =-
    set website=https://github.com/microsoft/Microsoft-Win32-Content
    set website=!website!-Prep-Tool/archive/refs/heads/master.zip

    echo.
    echo !purpose!
    echo.
    echo Expects the following default structure:
    echo CPT inside "%CPT%"
    echo Installer inside "%TODO%"
    echo Moves already packed installer to "%DONE%"
    echo Saves .intunewin to "%OUT%"
    echo Logs to "%LOG%" without tee
    echo.
    echo CPT runs in quiet mode and overrides existing output
    echo CPT does not provide error levels
    echo The CPT is provided under
    echo !website!
    echo.

    exit /b 999
)

set root=%~dp0
set CPT=%root%%CPT:.\=%
set TODO=%root%%TODO:.\=%
set DONE=%root%%DONE:.\=%
set OUT=%root%%OUT:.\=%
set LOG=%root%%LOG:.\=%

call:msg Starting

rem loop installer extensions
for /d %%e in (EXE, MSI) do (
    if exist "%TODO%\*.%%e" (
	rem loop all files with same extension in .
        for /f "usebackq" %%i in (`dir /b "%TODO%\*.%%e"`) do (
            if not __%%i__ == ____ (
                call:cpt "%%i" %%e
            ) else (
                call:msg Token "%%i" empty
            )
        )
    ) else (
        call:msg No "%%e" found
    )
)

call:msg Exiting
exit /b %errorlevel%

:cpt
    set fn=%1
    set fn=%fn:"=%
    set fniw=%fn:~-3%
    if __%fn%__ == ____ goto:eof
    if /i __%fniw%__ == __EXE__ (
	set fniw=%fn:EXE=intunewin%
    ) else (
	if /i __%fniw%__ == __MSI__ (
	    set fniw=%fn:MSI=intunewin%
	) else (
	    call:msg "%fn%" of unsupported filetype
	    goto:eof
	)
    )
    set tmptodo=%TODO%\tmptodo
    echo. >> %LOG%
    call:msg Unpacked %fn%
    dir /n "%TODO%\%fn%" | find /i "%fn%"
    dir /n "%TODO%\%fn%" | find /i "%fn%" >> "%LOG%"
    mkdir "!tmptodo!" >> "%LOG%" 2>>&1
    move /y "%TODO%\%fn%" "!tmptodo!" >> "%LOG%" 2>>&1
    set "com="%CPT%" -c "!tmptodo!" -s "%fn%" -o "%OUT%" -q ^>^> "!LOG!""
    start "Packing %fn%" /wait /i cmd /c "!com!"
    call:msg Packed %fn%
    dir /n "%OUT%\%fniw%" | find /i "%fniw%"
    dir /n "%OUT%\%fniw%" | find /i "%fniw%" >> "%LOG%"
    move /y "!tmptodo!\%fn%" "%DONE%" >> "%LOG%"
    rmdir /q /s "!tmptodo!" >> "%LOG%" 2>>&1
goto:eof

:msg
    set msg=%date% %time% %*
    echo %msg%
    echo %msg% >> %LOG%
goto:eof

