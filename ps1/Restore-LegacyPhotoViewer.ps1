<#
    .SYNOPSIS
    Enable legacy Photo Viewer.
    .NOTES
    If needed for all users, perform on default user hive
    %SystemDrive%\Users\Default\NTUSER.DAT
    .LINK
    Converted from .reg for Windows Registry Editor Version 5.00
    https://www.tenforums.com/tutorials/14312-restore-windows-photo-viewer-windows-10-a.html
#>
$FileTypes = @(
    ".bmp",".cr2",".dib",".gif",".ico",".jfif",".jpe",
    ".jpeg",".jpg",".jxr",".png",".tif",".tiff",".wdp"
)
$reg = [ordered]@{
    Classes = @{
        Path = "HKCU\SOFTWARE\Classes"
        Name = "" #default @
        Value = "PhotoViewer.FileAssoc.Tiff"
        Type = "String"
        Force = $true
        EA = "Stop"
    }
    OpenWithProgids = @{
        Path = "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FileExts\__R__\OpenWithProgids"
        Name = "PhotoViewer.FileAssoc.Tiff"
        Value = 0
        Type = "Unknown"
        Force = $true
        EA = "Stop"
    }
}
<#
    .NOTES
    Parallel worfklows instead of functions or scriptblocks are used for testing purposes.
    TODO
    Workflows introduce their own scope WORKFLOW:
    but copying/cloning hashtable by-ref still neccessary (?)
    because by default, hashtables are copied by-val
    .LINK
    man about_Workflows
    man about_Parallel
    man about_Ref
#>
workflow Set-Reg {
    param (
        [Parameter(Mandatory)][hashtable]$reg,
        [Parameter(Mandatory)][string[]]$FileTypes
    )
    Parallel {
        $reg.keys | ForEach-Object {
            Write-Host "Applying to ${_}: $($FileTypes)" -f Yellow
            $splat = $reg.$_.Clone()
            #ForEach -Parallel-Param only in workflow, not inside {}-Block 
            ForEach ($ft in $FileTypes) {
                try {
                    switch ($_) {
                        "Classes" {
                            $splat.Path = "Registry::$($reg.$_.Path)\${ft}"
                            #change default value
                            New-Item @splat | Out-Null
                        }
                        "OpenWithProgids" {
                            $splat.Path = "Registry::$($reg.$_.Path.Replace("__R__",${ft}))"
                            if(!(Test-Path $splat.Path)) {
                                #create default value
                                $splat.Name = ""
                                $splat.Type = "String"
                                New-Item @splat | Out-Null
                                $splat.Name = $reg.$_.Name
                                $splat.Type = $reg.$_.Type
                            }
                            #set value
                            New-ItemProperty @splat | Out-Null
                        }
                        default {
                            Write-Host "Key not known." -f Red
                        }
                    }
                }
                catch {
                    Write-Host "$($_.FullyQualifiedErrorId) - $($_.Exception)" -f Red
                }
            }
        }
    }
}
Set-Reg $reg $FileTypes