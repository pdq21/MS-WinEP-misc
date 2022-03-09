<#
    .SYNOPSIS
    Install apps within user space or machine wide.
    .NOTES
    Direct download of appx with ms store links, PackageFamilyName, ProductId, CategoryId
    Formats: appx, eappx, msixbundle, BlockMap
    
    TODO
    Script parameter declaration
    Enable sideloading
    Custom licences -LicensePath MyLicense.xml
    Provisioned: -Register -DisableDevelopmentMode
    .LINK
    Pkgs: https://store.rg-adguard.net/
    MSIX: https://docs.microsoft.com/en-us/windows/msix/packaging-tool/tool-overview
    APPX: https://www.howtogeek.com/285410/how-to-install-.appx-or-.appxbundle-software-on-windows-10/
#>
[CmdletBinding()]
param (
    [Parameter()][string]
    $pathPkgs = "${env:UserProfile}\Downloads\",
    [Parameter()][switch]
    $machineWide,
    [Parameter()][switch]
    $makeTranscript,
    [Parameter()][string]
    $pathTranscript = "${env:TEMP}\TS",
    [Parameter()][string]
    $fnTranscript = "AppPkgs-install.ts.log"
)
if(
    $machineWide -and ([System.Security.Principal.WindowsPrincipal] `
    [System.Security.Principal.WindowsIdentity]::GetCurrent()). `
    IsInRole("Administrators") -ne $true
) {
    Write-Host "Attempted machine wide installation without elevation. Exiting..." -f Red
}
else {
    if($makeTranscript) {
        if(!(Test-Path $pathTranscript)) {
            New-Item -Path $pathTranscript -ItemType "Directory" -Force | Out-Null
        }
        Start-Transcript -Path "${pathTranscript}\${fnTranscript}" -Append -Force
    }    
    if(
        Get-AppxPackage | Select-Object PackageFamilyName | Where-Object { $_ -match "store" }
    ) {
        Get-ChildItem $pathPkgs | Where-Object Name -match ".appx" | ForEach-Object {
            $ext = ($_.Name).Split(".")[-1].ToLower()
            if($ext -eq "appx" -or $ext -eq "msix") {
                if ($machineWide) {
                    #TODO
                    Add-AppxPackage -Path  "${pathPkgs}\$($_.Name)"
                }
                else {
                    #TODO
                    Add-AppxProvisionedPackage -PackagePath "${pathPkgs}\$($_.Name)" 
                }
            }
            elseif ($ext = "msixbundle") {
                #TODO
            }
            elseif ($ext = "BlockMap") {
                #TODO
            }
            else {
                Write-Host "${ext} not supported. Exiting..."
            }
        }
    }    
    if($makeTranscript) {
        Stop-Transcript
    }
}
