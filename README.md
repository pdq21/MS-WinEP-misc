# WinEP-misc

A collection of miscellaneous scripts to manage EP.  
This is a short synopsis of some of the tools contained.

## PS1

- `Remove-O365-pre-installed` could self-elevate itself
- `RemoteWipe-EpMdmWmi` uses a CIM-Class to reset Windows EP
- `Restore-PhotoViewerLegacyAsDefault` uses a parallelised worfklow
- `Distrib-FortiClientVPNCfg` distributes FortClient config contained inside the file
- `Disable-OfficeVBA-10-13-16-19` uses parameters passed within nested foreach-methods 
- `OpenWith-SecExecFileExt` changes the OpenWith-Key to Notepad.exe for specific file types (HTA, SCR, SCT, VBS, WSF) to avoid accidental execution by user

## BAT

- `Get-UserFlagNoPw` uses WMIC to loop through all users with false PasswordRequired-flag
- `Get-WLANKeys` extracts the clear keys from WLAN-Profiles if elevated
- `Package-IntuneCPTBatch` uses the MS Intune Content Packaging Tool to package all MSI from an input folder to a output
- `Disable-TelemetrieSchedTasks`, `Disable-UneccessaryServices` and `Disable-UWPAppsSchedTasks` build on the obsoleted [Windows Debloater from fdossena](https://fdossena.com/?p=w10debotnet/index_1903.frag) and are no longer maintained

## Hybrid

- `Reinstall-WinAppsPreinstalled-PSHybrid` is a chimaira of a BAT calling a PS1 contained within itself
