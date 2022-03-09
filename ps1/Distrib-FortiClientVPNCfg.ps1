<#
    .SYNOPSIS
    Distribute Forti Client configuration as script, e.g. push to EP with Intune.
    .DESCRIPTION
    Replaces values inside ((...)) with given parameters.
    Expects input templates as "${FTCcfgPath}\FTC-$($cfgParam.verFull)-template.conf".
    .NOTES
    PoC tested with FCT-6.4.3.1608 and FTC-7.0.1.0083.
    .LINK
	https://devicemanagement.microsoft.com/#blade/Microsoft_Intune_DeviceSettings/DevicesWindowsMenu/powershell
#>
[CmdletBinding()]
param (
    [Parameter()][string]
    $templatePath = ".\FTC-config",
    [Parameter()][string]
    $FTCverFull = "6.4.3.1608", #<insert full version>
    [Parameter()][string]
    $FTCverShort = "6.4.3", #< insert short version >
    [Parameter()][string]
    $genAuth = "< insert hash >", #Enc
    [Parameter()][string]
    $quarTitle = "< insert hash >",
    [Parameter()][string]
    $quarStmt = "< insert hash >",
    [Parameter()][string]
    $quarRem = "< insert hash >",
    [Parameter()][int32]
    $logLvl = 7,
    [Parameter()][string]
    $username = "< insert username >",
    [Parameter()][string] #[ValidatePattern]
    $conIP = "000.000.000.000",
    [Parameter()]
    $conPort = "0000",
    [Parameter()]
    $conName = "< insert connection name >",
    [Parameter()][datetime]
    $date = (Get-Date)
)

#TODO use parameters block as cfg splat (loop?)
$cfgParam = @{
    verFull = $FTCverFull
    verShort = $FTCverShort
    genAuth = $genAuth
    quarTitle = $quarTitle
    quarStmt = $quarStmt
    quarRem = $quarRem
    logLvl = $logLvl
    username = $username
    conIP = $conIP
    conPort = $conPort
    conName = $conName
    date = $date.ToString("yyyy\/MM\/dd") #FTC expected format
}
$cfg = @{
    inPath = "${templatePath}\FTC-$($cfgParam.verFull)-template.conf"
    outPath = "${env:TEMP}\FTC-$($cfgParam.verFull).conf"
    logPath = "${env:TEMP}\FTC-$($cfgParam.verFull).conf.log"
    logDate = $date.ToString("yyyy-MM-dd hh:mm:ss")
}
$FTCparam = @{
    exePath = "${env:ProgramFiles}\Fortinet\FortiClient\FCcfg.exe"
    args = "-o import -f $($cfg.outPath)"
}

function logFun([string]$msg="") {
    $msg = "$($cfg.logDate) - ${msg}.`nEvent written to log. Exiting..."
    Write-Host $msg -f Red
    $msg | Out-File $cfg.logPath -Append -Force
}

#run
if(Test-Path $FTCparam.exePath){
    try {
        $cfgContent = Get-Content $cfg.inPath
        $cfgParam.Keys | ForEach-Object {
            $cfgContent = $cfgContent -replace "\(\(${_}\)\)", $cfgParam[$_]
        }
        $cfgContent | Out-File -FilePath $cfg.outPath -Force -EA "Stop"
        Start-Process -FilePath $FTCparam.exePath -ArgumentList $FTCparam.args
    }
    catch {
        logFun "$($_.FullyQualifiedErrorId) - $($_.Exception)"
    }
}
else {
    logFun "$($FTCparam.exePath) not found"   
}
