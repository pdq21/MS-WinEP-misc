<# :
:: Header to create Batch/PowerShell hybrid
@echo off
setlocal
set "POWERSHELL_BAT_ARGS=%*"
if defined POWERSHELL_BAT_ARGS set "POWERSHELL_BAT_ARGS=%POWERSHELL_BAT_ARGS:"=\"%"
endlocal & powershell -NoLogo -NoProfile -Command "$_ = $input; Invoke-Expression $( '$input = $_; $_ = \"\"; $args = @( &{ $args } %POWERSHELL_BAT_ARGS% );' + [String]::Join( [char]10, $( Get-Content \"%~f0\" ) ) )"
goto :EOF

Reinstalls/Reregisters all standard packages.
Pass package filter with $args[0].

https://stackoverflow.com/questions/36672784/convert-a-small-ps-script-into-a-long-line-in-a-batch-file
https://www.dostips.com/forum/viewtopic.php?f=3&t=5543

rem other method
rem setlocal
set psfile=%0
echo %psfile:bat=ps1%
set exec=ByPass
set param=-NoLogo -NonInteractive -NoProfile
start powershell %param% -File "%psfile%" /wait
REM -ExecutionPolicy "%exec%"
wsreset
endlocal

#>

$path = "${env:ProgramData}\Pkgs"
$fn = "$($PSCommandPath.split("\\")[-1]).log"
$pkgReg = "Registry::HKLM:\Software\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\Applications"

Start-Transcript -Path "${path}\${fn}" -Force -Append
New-Item -Path $path -ItemType "Directory" | Out-Null

$Packages = Get-Item $pkgReg | Get-ChildItem

#filter if provided with $args[0]
if ([string]::IsNullOrEmpty($args[0]))
{
	Write-Host "No filter specified, attempting to re-register all provisioned apps."
}
else
{
	$Packages = $Packages | Where-Object { $_.Name -like $args[0] } 
	if ($Packages -eq $null)
	{
		Write-Host "No provisioned apps match the specified filter."
		exit
	}
	else
	{
		Write-Host "Registering the provisioned apps that match $($args[0])"
	}
}

ForEach($Package in $Packages) {
	$PackageName = $Package | Get-ItemProperty | Select-Object -ExpandProperty "PSChildName"
	$PackagePath = [System.Environment]::ExpandEnvironmentVariables(
		$Package | Get-ItemProperty | Select-Object -ExpandProperty "Path"
	)
	Write-Host "Attempting to register package: ${PackageName}"
	Add-AppxPackage -Register $PackagePath -DisableDevelopmentMode
}

Stop-Transcript
