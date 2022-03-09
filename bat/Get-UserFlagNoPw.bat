@echo off
if _%1_==_?_ (
	echo.
	echo Get known accounts with:
	echo PasswordRequired FALSE, Disabled FALSE, Status OK, Lockout FALSE
	echo Note: Using WMI instead of NET USER [user].
	echo Note: PasswordRequired flag is not updated regularly by OS.
	echo Use 'try' to test the logins.
	echo Look for error 1327 'no empty passwords allowed'.
	echo Otherwise error 1326 'wrong username or password'.
	exit /b
)

set w=Disabled = 'false' and PasswordRequired = 'false'
set w=%w% and Status = 'ok' and Lockout = 'false'
set get=Name,LocalAccount,SID,AccountType
set try=WMIC UserAccount WHERE "%w%" GET Name^^,Domain
set for=usebackq skip=1 tokens=1,2
set msg=trying # account %%j

WMIC UserAccount WHERE "%w%" GET %get%

if /i _%1_==_try_ (
	for /f "%for%" %%i in (`%try%`) do (
		if /i _%%i_==_%computername%_ (
			echo %msg:#=local%
			runas /noprofile /user:"%%j" cmd
		) else (
			echo  %msg:#=domain%
			runas /noprofile /user:"%%j@%%i" cmd
		)
	)
)

exit /b
