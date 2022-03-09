@echo off
rem Disable telemetrie scheduled tasks.
rem Obsolete !!! Not currated anymore.
rem Only get, no set.
rem https: // fdossena.com/?p=w10debotnet/index_1903.frag
setlocal enabledelayedexpansion
set LF=^


rem ^ two times MORE
set ms=Microsoft\Windows
set del=^"%windir%\System32\Tasks\%ms%\SettingSync\*^"
set t=^"%ms%\AppID\SmartScreenSpecific^"
set t=%t%,^"%ms%\Application Experience\AitAgent^"
set t=%t%,^"%ms%\Application Experience\Microsoft Compatibility Appraiser^"
set t=%t%,^"%ms%\Application Experience\ProgramDataUpdater^"
set t=%t%,^"%ms%\Application Experience\StartupAppTask^"
set t=%t%,^"%ms%\Autochk\Proxy^"
set t=%t%,^"%ms%\CloudExperienceHost\CreateObjectTask^"
set t=%t%,^"%ms%\Customer Experience Improvement Program\BthSQM^"
set t=%t%,^"%ms%\Customer Experience Improvement Program\Consolidator^"
set t=%t%,^"%ms%\Customer Experience Improvement Program\KernelCeipTask^"
set t=%t%,^"%ms%\Customer Experience Improvement Program\Uploader^"
set t=%t%,^"%ms%\Customer Experience Improvement Program\UsbCeip^"
set t=%t%,^"%ms%\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector^"
set t=%t%,^"%ms%\DiskFootprint\Diagnostics^"
set t=%t%,^"%ms%\FileHistory\File History (maintenance mode)^"
set t=%t%,^"%ms%\Maintenance\WinSAT^"
set t=%t%,^"%ms%\PI\Sqm-Tasks^"
set t=%t%,^"%ms%\Shell\FamilySafetyRefresh^"
set t=%t%,^"%ms%\Shell\FamilySafetyUpload^"
set t=%t%,^"%ms%\Windows Error Reporting\QueueReporting^"
set t=%t%,^"%ms%\WindowsUpdate\Automatic App Update^"
set t=%t%,^"%ms%\License Manager\TempSignedLicenseExchange^"
set t=%t%,^"%ms%\Clip\License Validation^"
set t=%t%,^"%ms%\ApplicationData\DsSvcCleanup^"
set t=%t%,^"%ms%\Power Efficiency Diagnostics\AnalyzeSystem^"
set t=%t%,^"%ms%\PushToInstall\LoginCheck^"
set t=%t%,^"%ms%\PushToInstall\Registration^"
set t=%t%,^"%ms%\Shell\FamilySafetyMonitor^"
set t=%t%,^"%ms%\Shell\FamilySafetyMonitorToastTask^"
set t=%t%,^"%ms%\Shell\FamilySafetyRefreshTask^"
set t=%t%,^"%ms%\Subscription\EnableLicenseAcquisition^"
set t=%t%,^"%ms%\Subscription\LicenseAcquisition^"
set t=%t%,^"%ms%\Diagnosis\RecommendedTroubleshootingScanner^"
set t=%t%,^"%ms%\Diagnosis\Scheduled^"
set t=%t%,^"%ms%\NetTrace\GatherNetworkInfo^"
set t=%t:,=!LF!%

echo Delete %del%
rem del /F /Q %del%

for %%i in (!t!) do (
    echo Disable %%i
    rem schtasks /Change /TN %%i /disable 
)


endlocal
exit /b