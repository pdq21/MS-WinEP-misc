<#
    .SYNOPSIS
	Disable and remove windows specific optional features.
#>
$Features = @(
	"TelnetClient"
	"DirectPlay"
	"FaxServicesClientPackage"
	"LegacyComponents"
	"MediaPlayback"
	"ScanManagementConsole"
	"TFTP"
	"TIFFIFilter"
	"WorkFolders-Client"
	#"Xps-Foundation-Xps-Viewer"
	#"Printing-XPSServices-Features"
	#"WindowsMediaPlayer"
	#"Printing-Foundation-Features"
	#"Printing-PrintToPDFServices-Features"
	#"SearchEngine-Client-Package"
	"SimpleTCP"
	"Client-ProjFS" # Windows Projected File System
    "Containers"
    "IIS*"
    "MicrosoftWindowsPowerShellV2*"
	"NetFx3" #re-install may be problematic
    "SMB1*"
   	"Microsoft-Hyper-V*"
	"MSMQ-*"
	"internet-explorer*"
	"*Browser.InternetExplorer*"
)
$splatWOF = @{
	FeatureName = ""
	Online = $true
	NoRestart = $true
	Remove = $true
	EA = "Stop"
}

Write-Host "Searching for matching enabled WOF..."
ForEach ($f in $Features) {
	try {
		Get-WindowsOptionalFeature -Online -FeatureName $f | `
			Where-Object State -EQ Enabled | ForEach-Object {
				Write-Host "Disabling $($_.FeatureName)..."
				$splatWOF.FeatureName =  $_.FeatureName
				Disable-WindowsOptionalFeature @splatWOF | Out-Null
			}
	}
	catch {
		Write-Host "$($_.FullyQualifiedErrorId) - $($_.Exception)" -f Red
	}
}

Write-Host "Uninstalling Silverlight..."
$pkgId = "{89F4137D-6C26-4A84-BDB8-2E5A4BB71E00}"
$splatSP = @{
	FilePath = "MsiExec.exe"
	Args = "/x${pkgId} /quiet /passive /qb"
	NoNewWindow = $true
}
try {
	Start-Process @splatSP | Wait-Process
}
catch {
	Write-Host "$($_.FullyQualifiedErrorId) - $($_.Exception)" -f Red
}
