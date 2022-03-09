@echo off
REM DISPLAY_NAME : Volume Shadow Copy
vssadmin list shadows >nul
if %errorlevel%==0 (

	vssadmin list shadows | find /i "\\?\GLOBALROOT"
	if not %errorlevel%==0 (
		if not _%1_==_f_ (
			choice /m "Existing restore point(s). Continue?"
			if not _%errorlevel%_==_1_ (
				echo "Exiting..."
				exit /b
			)
		)
	)

	set hvPol="HKLM\SOFTWARE\Policies\Microsoft\Windows NT\SystemRestore"
	set hvMs="HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SystemRestore"
	
	reg add "%hvPol%" /v "DisableConfig" /t "REG_DWORD" /d "1" /f
	reg add "%hvPol%" /v "DisableSR " /t "REG_DWORD" /d "1" /f
	reg add "%hvMs%" /v "DisableConfig" /t "REG_DWORD" /d "1" /f
	reg add "%hvMs%" /v "DisableSR " /t "REG_DWORD" /d "1" /f

	vssadmin delete shadows /all /quiet
	sc stop VSS
	sc config VSS start= disabled

	schtasks /Change /TN "\Microsoft\Windows\SystemRestore\SR" /disable
) else (
	echo Needs to run elevated. Exiting...
)
exit /b
