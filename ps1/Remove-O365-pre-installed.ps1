<#
    .SYNOPSIS
    Remove all pre-provisioned C2R Office apps and language packs with self-elevation.
    .LINK
    https://www.tenforums.com/microsoft-office-365/138802-how-completely-remove-preinstalled-office-apps-new-pc-2.html
    https://marckean.com/2013/07/01/fully-automate-the-installation-of-office-365/
#>
If (!([Security.Principal.WindowsPrincipal] `
    [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(
        [Security.Principal.WindowsBuiltInRole]'Administrator')
    ) {
    $splat = @{
        FilePath = "powershell.exe"
        ArgumentList = "-NoProfile -ExecutionPolicy Bypass -File `"{0}`"" -f $PSCommandPath
        Verb = "RunAs"
    }
    Start-Process @splat
    Exit
}

$unStr = "*Microsoft.Office*"
$pkgs = @(
    "{90160000-008C-0000-1000-0000000FF1CE}" #C2RInt.16.msi
    "{90160000-008C-0410-1000-0000000FF1CE}" #C2RIntLoc.it-it.16.msi
    "{90160000-008C-0413-1000-0000000FF1CE}" #C2RIntLoc.nl-nl.16.msi
    "{90160000-008C-0407-1000-0000000FF1CE}" #C2RIntLoc.de-de.16.msi
    "{90160000-008C-0409-1000-0000000FF1CE}" #C2RIntLoc.en-us.16.msi
    "{90160000-008C-040C-1000-0000000FF1CE}" #C2RIntLoc.fr-fr.16.msi
    "{90160000-007E-0000-1000-0000000FF1CE}" #SPPRedist.msi
)
$lang = @(
    "de-de"
    "en-us"
    "fr-fr"
    "it-it"
    "nl-nl"
)
$langArgs = "DisplayLevel=false scenario=install scenariosubtype=uninstall sourcetype=None "
$langargs += "productstoremove=O365HomePremRetail.16_##i18n##_x-none culture=##i18n## version.16=16.0"
$langParam = @{
    FilePath = "`"${env:ProgramFiles}\Common Files\Microsoft Shared\ClickToRun\OfficeClickToRun.exe`""
    NoNewWindow = $true
    Wait = $true
}
$msiParam = @{
    FilePath = "msiexec.exe"
    NoNewWindow = $true
    Wait = $true
}

Write-Host "removing MSO365 AppxPkgs..."  -f Yellow
# "Microsoft.MicrosoftOfficeHub"
Get-AppxPackage $unStr | Remove-AppxPackage
Get-AppxPackage -AllUsers $unStr | Remove-AppxPackage -AllUsers
Get-AppxProvisionedPackage -Online $unStr | Remove-AppxProvisionedPackage -Online

Write-Host "removing O365HomePremRetail C2R..." -f Yellow
$lang.foreach({
    Write-Host $_
    $langParam.ArgumentList = $langArgs -replace "##i18n##", $_
    Start-Process @langParam
})

Write-Host "removing MSO365 C2R pre-installed components" -f Yellow
$pkgs.foreach({
    Write-Host $_
    $msiParam.ArgumentList = "/qb /quiet /passive /x ${_}"
    Start-Process @msiParam
})
