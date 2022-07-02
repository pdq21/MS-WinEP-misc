@echo off
setlocal

set purpose=-= Pack .intunewin [Win32] with Intune CPT =-
set website=https://github.com/microsoft/Microsoft-Win32-Content
set website=%website%-Prep-Tool/archive/refs/heads/master.zip

set name=DWGTrueView_2022_English_64bit_dlm.7z.repacked.exe
set inpth=exe
set outpth=IntunePkgs
set logpth=log

if /i __%1__ == __?__ (
    echo.
    echo %purpose%
    echo.
    echo Expects the following default structure:
    echo IntuneWinAppUtil.exe inside "."
    echo %%1 source path, else ".\%inpth%"
    echo %%2 source file name
    echo %%3 output path, else ".\%outpth%"
    echo.
    echo CPT run in quiet mode to override existing output.
    echo CPT does not provide error levels.
    echo Logging to "%logpth%" without tee.
    echo The CPT is provided under
    echo %website%
    echo.
    exit /b 999
) else (
    if not __%1__ == ____ (
        set name=%1
        if /i not __%2__ == ____ set inpth=%2
        if /i not __%3__ == ____ set outpth=%3
    )
)

set src=%inpth%\%name%
set logfn=CPT_%date:~-4%-%date:~3,2%-%date:~0,2%_%name:~0,6%~%name:~-4%.txt
set logfile=%logpth%\%logfn%

if not exist "%logpth%" mkdir "%logpth%" 2>nul
echo %logfn% >%logfile%

IntuneWinAppUtil.exe -c "%inpth%" -s "%name%" -o "%outpth%" -q >>%logfile%

endlocal
exit /b %errorlevel%
