@echo off
rem 2022-05-19
setlocal

set purpose=-= Repack or create an installer with 7-zip =-
set website=https://documentation.help/7-Zip/sfx.htm

set name=DWGTrueView_2022_English_64bit_dlm.7z
set inpth=src
set outpth=exe
set cfgpth=cfg
set cfgfn=config.txt
set zippth=7z
set logpth=log

if /i __%1__ == __?__ (
    echo.
    echo %purpose%
    echo.
    echo Expects the following default structure:
    echo %%1 source name, else "<name>.7z"
    echo %%2 source path, else ".\%inpth%"
    echo %%3 output path, else ".\%outpth%"
    echo %%4 configuration path, else ".\%cfgpth%"
    echo %%5 config filename, else "<name>.%cfgfn%"
    echo %%6 path to 7zr.exe and 7zSD.exe, else in ".\%zippth%"
    echo.
    echo Logs to ".\%logpth%". Only resulting error code written to console.
    echo The 7z exe are provided by SDK\bin under
    echo %website%
    echo.
    exit /b 999
) else (
    if not __%1__ == ____ (
        set name=%1
        if /i not __%2__ == ____ set inpth=%2
        if /i not __%3__ == ____ set outpth=%3
        if /i not __%4__ == ____ set cfgpth=%4
        if /i not __%5__ == ____ set cfgfn=%5
        if /i not __%6__ == ____ set zippth=%6
    )
)

set src=%inpth%\%name%
set zr=%zippth%\7zr.exe
set outfile=%outpth%\%name%.repacked.exe
set cfgfn=%name%.config.txt
set logfn=7z_%date:~-4%-%date:~3,2%-%date:~0,2%_%name:~0,6%~%name:~-4%.txt
set logfile=%logpth%\%logfn%

if not exist %logpth% mkdir %logpth%
echo %logfn% >%logfile%

if not exist "%src%" (
    set emsg=Source file not found. Exiting without changes.
    goto:err
)
if not exist "%outpth%" (
    mkdir "%outpth%"
    if not %errorlevel% == 0 (
        set emsg=Error creating output path. Exiting without changes.
        goto:err
    )
)

echo. >>%logfile%
echo %zr%... >>%logfile%
"%zr%" a "%src%" "%zr%" -mx9 -mf=BCJ2 >>%logfile%
echo. >>%logfile%
echo copy... >>%logfile%
copy /b "%zippth%\7zSD.sfx" + "%cfgpth%\%cfgfn%" + "%src%" "%outfile%" >>%logfile%

if not %errorlevel% == 0 (
    set emsg=Run errored with %errorlevel%.
) else (
    set emsg=Exiting run without error level.
)

:err
echo. >>%logfile%
echo %emsg% >>%logfile%
echo %emsg%

endlocal
exit /b %errorlevel%
