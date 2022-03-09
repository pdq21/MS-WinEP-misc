<#
    .SYNOPSIS
    Remove Dell utils bloatware.
#>
$MsiParam = "/quiet /passive /qb"
$DellGUID = @{
    CommandPowerManager = "{18469ED8-8C36-4CF7-BD43-0FC9B1931AF8}"
    SARemediation = "{28CCD076-0839-4837-9B2D-EF35E7BF2488}"
    DellOptimizer = "{4EA9855C-3339-4AE3-977B-6DF8A369469D}"
    DellOptimizerUI = "{E27862BD-4371-4245-896A-7EBE989B6F7F}"
    SAUpdatePlugin = "{F05A10C0-5F5F-4755-8613-66BB841FEB08}"
}
$Transcript = @{
    use = $false
    Path = $env:TEMP
}

if($Transcript.use) {
    if(!(Test-Path $Transcript.Path)) {
        New-Item $Transcript.Path -ItemType "Directory" -Force | Out-Null
    }
    Start-Transcript -Path $Transcript.Path -Append -Force
}
try {
    $DellGUID.GetEnumerator() | ForEach-Object {
        Write-Host "removing $($_.Name)..."
        $arg = "/x$($_.Value) ${MsiParam}"
        Start-Process "MSIEXEC.EXE" -ArgumentList $arg | Wait-Process
    }
}
catch {
    Write-Host "$($_.FullyQualifiedErrorId) - $($_.Exception)" -f Red
}
if($Transcript.use) {
    Stop-Transcript
}