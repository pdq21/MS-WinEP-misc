<#
	.SYNOPSIS
	Export the startmenu layout of the current EP.
	.NOTES
	DefaultLayouts.xml: ${env:PUBLIC}\..\Default\AppData\Local\Microsoft\Windows\Shell
	Current User: ${env:LOCALAPPDATA}\Microsoft\Windows\Shell\
	Help: man startlayout
	User session needs to be active, otherwise StartLayout can not be exported:
	Exception: No login session, CategoryInfo: NotSpecified: (:) [Export-StartLayout], COMException
	.LINK
	https://docs.microsoft.com/en-us/windows/configuration/customize-and-export-start-layout
#>
$path = @{
	getDefault = "${env:PUBLIC}\..\Default\AppData\Local\Microsoft\Windows\Shell"
	exportTo = "${env:TEMP}\StartLayout"
}
$EA = "Continue"

if (!(Test-Path $path.exportTo)) { 
	New-Item -Path $path.exportTo -ItemType "Directory" -Force | Out-Null
}

Copy-Item -Path $path.getDefault -Destination $path.exportTo -Force -Recurse -EA $EA | Out-Null
Export-StartLayout -Path "$($path.exportTo)\CurrentUser.xml" -EA $EA | Out-Null
Export-StartLayoutEdgeAssets -Path "$($path.exportTo)\EdgeAssets.xml" -EA $EA | Out-Null

Get-ChildItem $path.exportTo