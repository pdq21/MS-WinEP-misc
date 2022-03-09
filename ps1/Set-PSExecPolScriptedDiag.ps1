<#
    .SYNOPSIS
    Set Exec Pol and Sec Diag for machine.
    .NOTES
    TODO
    Loop through all existing users and temp-mounted default user hive.
    Set for pwsh.
#>
$reg = @{
    PS = @{
        Type = "Microsoft.PowerShell"
        StringValues = @{
            Path = "C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\powershell.exe"
            ExecutionPolicy = "restricted"
        }
    }
    Diag = @{
        Type = "ScriptedDiagnostics"
        StringValues = @{
            ExecutionPolicy = "restricted"
        }
    }
}
$splat = @{
    Type = "String"
    Force = $true
    EA = "Stop"
}

$reg.Keys.ForEach({
    $reg.$_.ForEach({
        $splat.Path = "Registry::HKLM\SOFTWARE\Microsoft\PowerShell\1\ShellIds\$($_.Type)"
        if(!(Test-Path $splat.Path)) {
            #create default value
            $splat.Name = ""
            $splat.Value = ""
            New-Item @splat | Out-Null
        }
        $_.StringValues.GetEnumerator().ForEach({
            $splat.Name = $_.Key
            $splat.Value = $_.Value
            New-ItemProperty @splat | Out-Null
        })
    })
})