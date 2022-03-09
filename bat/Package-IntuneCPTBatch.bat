@echo off
rem batch package .intunewin with
rem intune content prep tool

set cpt=<path_to_CPT.exe>
set c=<path_to_source_MSIs>
set s=<source_setup_MSI_file>
set o=<output_path>

for /f "usebackq" %%i in (`dir /b "%c%\*.MSI"`) do (
    echo Packing %%i to %o%...
    "%cpt%" -c "%c%" -s "%%i" -o "%o%" >nul
)
exit /b