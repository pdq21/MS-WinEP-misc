<#
    .SYNOPSIS
    Block macros and files from internet within MS Office products.
    .NOTES
    Office versions: 2007 12.0, 2010 14.0, 2013 15.0, 2016 16.0, 2019 and O365 16.0
    Control macro settings (Reg_DWORD)
    1 Enable All Macros, 2: Disable All macros with notification,
    3: Disable all macros except those digitally signed, 4: Disable all without notification
    Change GPO
    Computer or User Configuration > Policies > Administrative Templates > Microsoft Office 2016 > Security Settings
    Disable VBA for Office applications
    User configuration > Policies > Administrative templates > Microsoft Word 2016 > Word options > Security > Trust Center
    VBA Macro Notification Settings: Enable all macros, Disable all macros without notification, Disable all macros with notification, Disable all except digitally signed macros
    Security > Trust Center ("Block macros from running in Office files from the Internet"
    User configuration > Policies > Administrative templates > Microsoft Office 2016 > Security settings > Trust Center
    Allow mix of policy and user locations
    Administrative templates > Microsoft Word 2016 > Word options > Security > Trust Center
    Block macros from running in Office files from the Internet etc.    
    .LINK
    https://en.wikipedia.org/wiki/History_of_Microsoft_Office
    https://www.heelpbook.net/2016/how-to-control-macro-settings-using-registry-keys-or-gpos/
    https://decentsecurity.com/block-office-macros
    https://4sysops.com/archives/restricting-or-blocking-office-2016-2019-macros-with-group-policy/
#>
[CmdletBinding()]
param (
    [Parameter()][string[]]
    [ValidateSet(
        "Outlook","Word","Excel","PowerPoint","Publisher","Visio"
    )]
    $products = @(
        "Outlook","Word","Excel","PowerPoint","Publisher","Visio"
    ),
    [Parameter()][string[]]
    [ValidateSet(
        "2007","12.0","2010","14.0","2013","15.0",
        "2016","16.0","2019","16.0","O365","16.0"
    )]
    $versions = @("16.0","2007")
)

#replace alphanum version by num if not already contained
$versions = $versions.ForEach({
    $ver = $args[0].$_
    if($ver) {
        if($versions.IndexOf($ver) -eq -1) {
            $ver
        }
    }
    else {
        $_
    }
}, @{
    "2007" = "12.0"; "2010" = "14.0"; "2013" = "15.0"
    "2016" = "16.0"; "2019" = "16.0"; "O365" = "16.0"
})
$reg = @{
    Versions = $versions
    Products = $products
    Path = "Registry::HKCU\SOFTWARE\Policies\Microsoft\Office\__NUMVER__\__PROD__\Security"
    Values = @{
        VBAWarnings = @{
            Value = 2
            Type = "Dword"
        }
        #added to outlook since 2013/15.0
        markinternalasunsafe = @{
            Value = 1
            Type = "Dword"
        }
        #added to all prod since 2013/15.0
        blockcontentexecutionfrominternet = @{
            Value = 1
            Type = "Dword"
        }
    }
}
$splat = @{
    Force = $true
    EA = "Stop"
}

#run
$reg."Versions".ForEach({
    $values = if([int32]$_ -ge 16) {
        $reg.Values
    }
    else {
        @{
            VBAWarnings = $reg.Values.VBAWarnings
        }
    }
    $reg."Products".ForEach({
        $path = $reg.Path -replace "__PROD__", $_ `
            -replace "__NUMVER__", $args[0]
        $args[1].GetEnumerator().ForEach({ #loop values
            $splat = @{
                Path = $args[1]
                Name = $_.Key
                Value = $_.Value.Value
                Type = $_.Value.Type
            }
            try {
                Write-Host "Writing $($splat.Name) for $($args[0]) version $($args[2])."
                if(!(Test-Path $splat.Path)) {
                    New-Item @splat | Out-Null
                }
                New-ItemProperty @splat
            }
            catch {
                Write-Host $_.FullyQualifiedErrorId -f Red
            }
        }, $_, $path, $args[0])
    }, $_, $values)
})
