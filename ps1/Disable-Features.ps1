<#
    	.SYNOPSIS
	Disable and remove specific windows optional features, also called features on demand.
#>
$wofPkgs = @(
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
$slPkgId = "{89F4137D-6C26-4A84-BDB8-2E5A4BB71E00}"
$splatWOF = @{
	FeatureName = ""
	Online = $true
	NoRestart = $true
	Remove = $true
	EA = "Stop"
}
$splatSL = @{
	FilePath = "MsiExec.exe"
	Args = "/x${slPkgId} /quiet /passive /qb"
	NoNewWindow = $true
}

Write-Host "Searching for matching enabled WOF..."
ForEach ($f in $wofPkgs) {
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
try {
	Start-Process @splatSL | Wait-Process
}
catch {
	Write-Host "$($_.FullyQualifiedErrorId) - $($_.Exception)" -f Red
}
